package dao;

import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;

import org.apache.log4j.Logger;

import mes.frame.database.JDBCConnectionPool;
import model.Menu;

public class MenuDaoImpl implements MenuDao {
	
	static final Logger logger = 
			Logger.getLogger(MenuDaoImpl.class.getName());
	
	
	public MenuDaoImpl() {
	}

	@Override
	public List<Menu> getMenuByTenant(Connection conn) {

		try {
			Statement stmt = conn.createStatement();
			
			String sql = new StringBuilder()
				.append("SELECT A.*						\n")
				.append("FROM menu A					\n")
				.append("INNER JOIN menu_customer B		\n")
				.append("	ON A.menu_id = B.menu_id	\n")
				.append("WHERE B.tenant_id = '" + JDBCConnectionPool.getTenantId(conn) + "'\n")
				.toString();
			
			logger.debug("sql:\n" + sql);
			
			ResultSet rs = stmt.executeQuery(sql);
			
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
