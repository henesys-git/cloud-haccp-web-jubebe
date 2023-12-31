package dao;

import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;

import org.apache.log4j.Logger;

import mes.frame.database.JDBCConnectionPool;
import model.CCPSign;

public class CCPSignDaoImpl implements CCPSignDao {
	
	static final Logger logger = Logger.getLogger(CCPSignDaoImpl.class.getName());
	
	private Statement stmt;
	private ResultSet rs;
	
	public CCPSignDaoImpl() {}

	@Override
	public List<CCPSign> getCCPSignByDateAndProcessCode(Connection conn, String date, String processCode) {
		
		try {
			stmt = conn.createStatement();
			
			String sql = new StringBuilder()
				.append("SELECT																\n")
				.append("	A.sign_date,													\n")
				.append("	A.process_code,													\n")
				.append("	A.checker_id,													\n")
				.append("	A.sign_type,													\n")
				.append("	B.user_name														\n")
				.append("FROM data_sign	A													\n")
				.append("LEFT OUTER JOIN user B												\n")
				.append("ON A.checker_id = B.user_id										\n")
				.append("WHERE A.tenant_id = '" + JDBCConnectionPool.getTenantId(conn) + "'	\n")
				.append("  AND A.sign_date = '" + date + "'									\n")
				.append("  AND A.process_code = '" + processCode + "'							\n")
				.append("GROUP BY A.sign_type												\n")
				.append("ORDER BY A.sign_type												\n")
				.toString();
			
			logger.debug("sql:\n" + sql);
			
			rs = stmt.executeQuery(sql);
			
			//CCPSign data = new CCPSign();
			
			List<CCPSign> dataList = new ArrayList<CCPSign>();
			
			while(rs.next()) {
				CCPSign data = extractFromResultSet(rs);
				dataList.add(data);
			}
			
			return dataList;
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
	    			.append("	checker_id, \n")
	    			.append("	sign_type \n")
	    			.append(")\n")
	    			.append("VALUES (\n")
	    			.append("	'" + JDBCConnectionPool.getTenantId(conn) + "',\n")
	    			.append("	'" + ccpSign.getSignDate() + "',\n")
	    			.append("	'" + ccpSign.getProcessCode() + "',\n")
	    			.append("	'" + ccpSign.getCheckerId() + "',\n")
	    			.append("	'" + ccpSign.getSignType() + "' \n")
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
		data.setSignType(rs.getString("sign_type"));
		data.setUserName(rs.getString("user_name"));
		
	    return data;
	}
}
