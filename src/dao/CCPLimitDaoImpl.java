package dao;

import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;

import org.apache.log4j.Logger;

import mes.frame.database.JDBCConnectionPool;
import model.CCPLimit;

public class CCPLimitDaoImpl implements CCPLimitDao {
	
	private Statement stmt;
	private ResultSet rs;
	
	static final Logger logger = 
			Logger.getLogger(CCPLimitDaoImpl.class.getName());
	
	public CCPLimitDaoImpl() {
	}
	
	@Override
	public List<CCPLimit> getAllCCPLimit(Connection conn) {
		
		try {
			stmt = conn.createStatement();
			
			String sql = new StringBuilder()
				.append("SELECT \n")
				.append("	event_code,\n")
				.append("	object_id,\n")
				.append("	min_value,\n")
				.append("	max_value,\n")
				.append("	value_unit\n")
				.append("FROM ccp_limit\n")
				.append("WHERE A.tenant_id = '" + JDBCConnectionPool.getTenantId(conn) + "'\n")
				.toString();
			
			logger.debug("sql:\n" + sql);
			
			rs = stmt.executeQuery(sql);
			
			List<CCPLimit> list = new ArrayList<CCPLimit>();
			
			while(rs.next()) {
				CCPLimit info = extractFromResultSet(rs);
				list.add(info);
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
	public CCPLimit getCCPLimit(Connection conn, String eventCode, String productId) {
		
		try {
			stmt = conn.createStatement();
			
			String sql = new StringBuilder()
					.append("SELECT \n")
					.append("	event_code,\n")
					.append("	object_id,\n")
					.append("	min_value,\n")
					.append("	max_value,\n")
					.append("	value_unit\n")
					.append("FROM ccp_limit\n")
					.append("WHERE tenant_id = '" + JDBCConnectionPool.getTenantId(conn) + "'\n")
					.append("  AND event_code = '" + eventCode + "'\n")
					.append("  AND object_id = '" + productId + "'\n")
					.toString();

			logger.debug("sql:\n" + sql);
			
			rs = stmt.executeQuery(sql);
			
			CCPLimit ccpLimit = new CCPLimit();
			
			if(rs.next()) {
				ccpLimit = extractFromResultSet(rs);
			}
			
			return ccpLimit;
		} catch (SQLException ex) {
			ex.printStackTrace();
		} finally {
		    try { rs.close(); } catch (Exception e) { /* Ignored */ }
		    try { stmt.close(); } catch (Exception e) { /* Ignored */ }
		}
		
		return null;
	};
	
	private CCPLimit extractFromResultSet(ResultSet rs) throws SQLException {
		CCPLimit ccpLimit = new CCPLimit();
		
		ccpLimit.setEventCode(rs.getString("event_code"));
		ccpLimit.setProductId(rs.getString("object_id"));
		ccpLimit.setMinValue(rs.getString("min_value"));
		ccpLimit.setMaxValue(rs.getString("max_value"));
		ccpLimit.setValueUnit(rs.getString("value_unit"));
		
	    return ccpLimit;
	}
}
