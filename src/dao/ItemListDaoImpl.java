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
import model.ItemList;
import model.Product;

public class ItemListDaoImpl implements ItemListDao {
	
	private Statement stmt;
	private ResultSet rs;
	
	static final Logger logger = 
			Logger.getLogger(ItemListDaoImpl.class.getName());
	
	public ItemListDaoImpl() {
	}
	
	@Override
	public List<ItemList> getSensorList(Connection conn) {
		
		try {
			stmt = conn.createStatement();
			
			String sql = new StringBuilder()
				.append("SELECT  															\n")
				.append("	sensor_id,  													\n")
				.append("	sensor_name  													\n")
				.append("FROM sensor														\n")
				.append("WHERE tenant_id = '" + JDBCConnectionPool.getTenantId(conn) + "'	\n")
				.toString();
			
			logger.debug("sql:\n" + sql);
			
			rs = stmt.executeQuery(sql);
			
			List<ItemList> list = new ArrayList<ItemList>();
			
			while(rs.next()) {
				ItemList data = extractFromResultSet(rs);
				list.add(data);
			}
			
			return list;
			
		} catch (SQLException ex) {
			ex.printStackTrace();
		} finally {
		    try { rs.close(); } catch (Exception e) { /* Ignored */ }
		    try { stmt.close(); } catch (Exception e) { /* Ignored */ }
		}
		
		return null;
	};

	@Override
	public List<ItemList> getSensorList(Connection conn, String type_cd) {
		
		try {
			stmt = conn.createStatement();
			
			String sql = new StringBuilder()
				.append("SELECT  															\n")
				.append("	sensor_id,  													\n")
				.append("	sensor_name  													\n")
				.append("FROM sensor														\n")
				.append("WHERE tenant_id = '" + JDBCConnectionPool.getTenantId(conn) + "'	\n")
				.append("AND type_code = '" + type_cd + "' 									\n")
				.toString();
			
			logger.debug("sql:\n" + sql);
			
			rs = stmt.executeQuery(sql);
			
			List<ItemList> list = new ArrayList<ItemList>();
			
			while(rs.next()) {
				ItemList data = extractFromResultSet(rs);
				list.add(data);
			}
			
			return list;
			
		} catch (SQLException ex) {
			ex.printStackTrace();
		} finally {
		    try { rs.close(); } catch (Exception e) { /* Ignored */ }
		    try { stmt.close(); } catch (Exception e) { /* Ignored */ }
		}
		
		return null;
	};
	
	@Override
	public List<ItemList> getCCPList(Connection conn, String type_cd) {
		
		try {
			stmt = conn.createStatement();
			
			String sql = new StringBuilder()
				.append("SELECT  		\n")
				.append("	code,  		\n")
				.append("	code_name  		\n")
				.append("FROM common_code	\n")
				.append("WHERE tenant_id = '" + JDBCConnectionPool.getTenantId(conn) + "'\n")
				.append("  AND code like '" + type_cd + "%' \n")
				.toString();
			
			logger.debug("sql:\n" + sql);
			
			rs = stmt.executeQuery(sql);
			
			List<ItemList> list = new ArrayList<ItemList>();
			
			while(rs.next()) {
				ItemList data = extractCCPFromResultSet(rs);
				list.add(data);
			}
			
			return list;
			
		} catch (SQLException ex) {
			ex.printStackTrace();
		} finally {
		    try { rs.close(); } catch (Exception e) { /* Ignored */ }
		    try { stmt.close(); } catch (Exception e) { /* Ignored */ }
		}
		
		return null;
	};
	
	private ItemList extractFromResultSet(ResultSet rs) throws SQLException {
		return new ItemList(
					rs.getString("sensor_id"),
					rs.getString("sensor_name")
		);
	}
	
	private ItemList extractCCPFromResultSet(ResultSet rs) throws SQLException {
		return new ItemList(
					rs.getString("code"),
					rs.getString("code_name")
		);
	}
	
}
