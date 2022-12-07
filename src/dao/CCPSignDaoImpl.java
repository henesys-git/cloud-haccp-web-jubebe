package dao;

import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;

import org.apache.log4j.Logger;

import mes.frame.database.JDBCConnectionPool;
import model.CCPSign;

public class CCPSignDaoImpl implements CCPSignDao {
	
	static final Logger logger = Logger.getLogger(CCPSignDaoImpl.class.getName());
	
	private Statement stmt;
	private ResultSet rs;
	
	public CCPSignDaoImpl() {}

	@Override
	public CCPSign getCCPSignByDateAndProcessCode(Connection conn, String date, String processCode) {
		
		try {
			stmt = conn.createStatement();
			
			String sql = new StringBuilder()
				.append("SELECT																\n")
				.append("	sign_date,														\n")
				.append("	process_code,													\n")
				.append("	checker_id														\n")
				.append("FROM data_sign														\n")
				.append("WHERE tenant_id = '" + JDBCConnectionPool.getTenantId(conn) + "'	\n")
				.append("  AND sign_date = '" + date + "'									\n")
				.append("  AND process_code = '" + processCode + "'							\n")
				.toString();
			
			logger.debug("sql:\n" + sql);
			
			rs = stmt.executeQuery(sql);
			
			CCPSign data = new CCPSign();
			
			if(rs.next()) {
				data = extractFromResultSet(rs);
			}
			
			return data;
		} catch (SQLException ex) {
			ex.printStackTrace();
		} finally {
		    try { rs.close(); } catch (Exception e) { /* Ignored */ }
		    try { stmt.close(); } catch (Exception e) { /* Ignored */ }
		}
		
		return null;
	};
	
	@Override
	public boolean delete(Connection conn, String date, String processCode) {
		try {
			stmt = conn.createStatement();
			
			String sql = new StringBuilder()
					.append("DELETE FROM data_sign\n")
					.append("WHERE tenant_id = '" + JDBCConnectionPool.getTenantId(conn) + "'\n")
					.append("	AND sign_date = '" + date + "'\n")
					.append("	AND process_code = '" + processCode + "'\n")
					.toString();
			
			logger.debug("sql:\n" + sql);

			int i = stmt.executeUpdate(sql);

	        if(i > -1) {
	        	return true;
	        }
		} catch (SQLException ex) {
			ex.printStackTrace();
		} finally {
		    try { stmt.close(); } catch (Exception e) { /* Ignored */ }
		}
		
		return false;
	}
	
	@Override
	public boolean deletePeriod(Connection conn, String date, String date2, String processCode) {
		try {
			stmt = conn.createStatement();
			
			String sql = new StringBuilder()
					.append("DELETE FROM data_sign\n")
					.append("WHERE tenant_id = '" + JDBCConnectionPool.getTenantId(conn) + "'\n")
					.append("	AND sign_date BETWEEN '" + date + "'\n")
					.append("	AND '" + date2 + "'\n")
					.append("	AND process_code like '%" + processCode + "%'\n")
					.toString();
			
			logger.debug("sql:\n" + sql);

			int i = stmt.executeUpdate(sql);

	        if(i > -1) {
	        	return true;
	        }
		} catch (SQLException ex) {
			ex.printStackTrace();
		} finally {
		    try { stmt.close(); } catch (Exception e) { /* Ignored */ }
		}
		
		return false;
	}

	@Override
	public boolean sign(Connection conn, CCPSign ccpSign) {
	    try {
	    	stmt = conn.createStatement();
	    	
	    	String sql = new StringBuilder()
	    			.append("INSERT INTO data_sign (\n")
	    			.append("	tenant_id,\n")
	    			.append("	sign_date,\n")
	    			.append("	process_code,\n")
	    			.append("	checker_id\n")
	    			.append(")\n")
	    			.append("VALUES (\n")
	    			.append("	'" + JDBCConnectionPool.getTenantId(conn) + "',\n")
	    			.append("	'" + ccpSign.getSignDate() + "',\n")
	    			.append("	'" + ccpSign.getProcessCode() + "',\n")
	    			.append("	'" + ccpSign.getCheckerId() + "'\n")
	    			.append(");\n")
	    			.toString();
	    	
	    	logger.debug("sql:\n" + sql);
			
	        int i = stmt.executeUpdate(sql);

	        if(i > -1) {
	        	return true;
	        }
	    } catch (SQLException ex) {
	        ex.printStackTrace();
	    } finally {
		    try { stmt.close(); } catch (Exception e) { /* Ignored */ }
		}

	    return false;
	}
	
	private CCPSign extractFromResultSet(ResultSet rs) throws SQLException {
		CCPSign data = new CCPSign();
		
		data.setSignDate(rs.getString("sign_date"));
		data.setProcessCode(rs.getString("process_code"));
		data.setCheckerId(rs.getString("checker_id"));
		
	    return data;
	}
}
