package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;

import org.apache.log4j.Logger;

import mes.frame.database.JDBCConnectionPool;
import model.CommonCode;
import model.Menu;

public class MenuDaoImpl implements MenuDao {
	
	private Statement stmt;
	private ResultSet rs;
	
	static final Logger logger = 
			Logger.getLogger(MenuDaoImpl.class.getName());
	
	
	public MenuDaoImpl() {
	}

	@Override
	public List<Menu> getMenuByTenant(Connection conn) {

		try {
			stmt = conn.createStatement();
			
			String sql = new StringBuilder()
				.append("SELECT A.*						\n")
				.append("FROM menu A					\n")
				.append("INNER JOIN menu_customer B		\n")
				.append("	ON A.menu_id = B.menu_id	\n")
				.append("WHERE B.tenant_id = '" + JDBCConnectionPool.getTenantId(conn) + "'\n")
				.toString();
			
			logger.debug("sql:\n" + sql);
			
			rs = stmt.executeQuery(sql);
			
			List<Menu> list = new ArrayList<Menu>();
			
			while(rs.next()) {
				Menu menu = extractFromResultSet(rs);
				list.add(menu);
			}
			
			return list;
		} catch (SQLException ex) {
			ex.printStackTrace();
		}
		
		return null;
	};
	
	@Override
	public List<Menu> getAllMenu(Connection conn) {

		try {
			stmt = conn.createStatement();
			
			String sql = new StringBuilder()
				.append("SELECT A.*						\n")
				.append("FROM menu A					\n")
				.toString();
			
			logger.debug("sql:\n" + sql);
			
			rs = stmt.executeQuery(sql);
			
			List<Menu> list = new ArrayList<Menu>();
			
			while(rs.next()) {
				Menu menu = extractFromResultSet(rs);
				list.add(menu);
			}
			
			return list;
		} catch (SQLException ex) {
			ex.printStackTrace();
		}
		
		return null;
	};
	
	@Override
	public Menu getMaxMenuId(Connection conn) {
		
		try {
			stmt = conn.createStatement();
			
			String sql = new StringBuilder()
				.append("SELECT MAX(CAST(menu_id AS INT)) AS menu_id, \n")
				.append("'' AS menu_name, \n")
				.append(" 0 AS menu_level, \n")
				.append("'' AS path, \n")
				.append("'' AS parent_menu_id \n")
				.append("FROM menu	\n")
				.toString();
			
			logger.debug("sql:\n" + sql);
			
			rs = stmt.executeQuery(sql);
			
			Menu menu = new Menu();
			
			if(rs.next()) {
				menu = extractFromResultSet(rs);
			}
			
			return menu;
		} catch (SQLException ex) {
			ex.printStackTrace();
		} finally {
		    try { rs.close(); } catch (Exception e) { /* Ignored */ }
		    try { stmt.close(); } catch (Exception e) { /* Ignored */ }
		}
		
		return null;
		
	}
	
	@Override
	public boolean insert(Connection conn, Menu menu) {
		String sql = "";
		try {
			sql = new StringBuilder()
					.append("INSERT INTO\n")
					.append("	menu (\n")
					.append("		menu_id,\n")
					.append("		menu_name,\n")
					.append("		menu_level,\n")
					.append("		path,\n")
					.append("		parent_menu_id\n")
					.append("	)\n")
					.append("VALUES\n")
					.append("	(\n")
					.append("		?,\n")
					.append("		?,\n")
					.append("		?,\n")
					.append("		?,\n")
					.append(" 		? \n")
					.append("	);\n")
					.toString();

			PreparedStatement ps = conn.prepareStatement(sql);
			
			ps.setString(1, menu.getMenuId());
			ps.setString(2, menu.getMenuName());
			ps.setInt(3, menu.getMenuLevel());
			ps.setString(4, menu.getPath());
			ps.setString(5, menu.getParentMenuId());
			
	        int i = ps.executeUpdate();

	        if(i < 0) {
	        	conn.rollback();
	        	return false;
	        }
	        
	        sql = new StringBuilder()
					.append("INSERT INTO\n")
					.append("	menu_customer (\n")
					.append("		menu_id,\n")
					.append("		tenant_id\n")
					.append("	)\n")
					.append("VALUES\n")
					.append("	(\n")
					.append("		?,\n")
					.append("		?\n")
					.append("	);\n")
					.toString();

			PreparedStatement ps2 = conn.prepareStatement(sql);
			
			
			ps2.setString(1, menu.getMenuId());
			ps2.setString(2, JDBCConnectionPool.getTenantId(conn));
			
	        int j = ps2.executeUpdate();

	        if(j == 1) {
	        	return true;
	        }
	        else {
	        	conn.rollback();
	        	return false;
	        }

	    } catch (SQLException ex) {
	        ex.printStackTrace();
	    }

	    return false;
	}
	
	@Override
	public boolean update(Connection conn, Menu menu) {
		try {
			stmt = conn.createStatement();
			System.out.println(menu);
			String sql = new StringBuilder()
					.append("UPDATE menu \n")
					.append("SET\n")
					.append("	menu_name='" + menu.getMenuName() + "',	 \n")
					.append("	menu_level='" + menu.getMenuLevel() + "',\n")
					.append("	path='" + menu.getPath() + "',			 \n")
					.append("	parent_menu_id='" + menu.getParentMenuId() + "'\n")
					.append("  WHERE menu_id='" + menu.getMenuId() + "';\n")
					.toString();
			
			logger.debug("sql:\n" + sql);
			
	        int i = stmt.executeUpdate(sql);
	        System.out.println("i : " + i + "===========");
	        if(i == 1) {
	        	return true;
	        }

	    } catch (SQLException ex) {
	        ex.printStackTrace();
	    }

	    return false;
	}
	
	@Override
	public boolean delete(Connection conn, String menuId) {
		String sql = "";
		try {
			stmt = conn.createStatement();
			
			sql = new StringBuilder()
					.append("DELETE FROM menu\n")
					.append("WHERE menu_id='" + menuId + "';\n")
					.toString();
			
			logger.debug("sql:\n" + sql);
			
			int i = stmt.executeUpdate(sql);

			if(i < 0) {
	        	conn.rollback();
	        	return false;
	        }
			
			sql = new StringBuilder()
					.append("DELETE FROM menu_customer \n")
					.append("WHERE menu_id='" + menuId + "';\n")
					.toString();
			
			logger.debug("sql:\n" + sql);
			
			int j = stmt.executeUpdate(sql);

			if(j == 1) {
	        	return true;
	        }
			else {
				conn.rollback();
				return false;
			}

	    } catch (SQLException ex) {
	        ex.printStackTrace();
	    }

	    return false;
	}
	
	private Menu extractFromResultSet(ResultSet rs) throws SQLException {
		return new Menu(
				rs.getString("menu_id"),
				rs.getString("menu_name"),
				rs.getInt("menu_level"),
				rs.getString("path"),
				rs.getString("parent_menu_id")
			);
	}
}
