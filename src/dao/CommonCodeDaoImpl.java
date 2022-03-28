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

public class CommonCodeDaoImpl implements CommonCodeDao {
	
	private Statement stmt;
	private ResultSet rs;
	
	static final Logger logger = 
			Logger.getLogger(CommonCodeDaoImpl.class.getName());
	
	public CommonCodeDaoImpl() {
	}

	@Override
	public List<CommonCode> getAllCodes(Connection conn) {
		
		try {
			stmt = conn.createStatement();
			
			String sql = new StringBuilder()
				.append("SELECT * 		\n")
				.append("FROM common_code	\n")
				.append("WHERE tenant_id = '" + JDBCConnectionPool.getTenantId(conn) + "'\n")
				.toString();
			
			logger.debug("sql:\n" + sql);
			
			rs = stmt.executeQuery(sql);
			
			List<CommonCode> commonCodeList = new ArrayList<CommonCode>();
			
			while(rs.next()) {
				CommonCode data = extractFromResultSet(rs);
				commonCodeList.add(data);
			}
			
			return commonCodeList;
			
		} catch (SQLException ex) {
			ex.printStackTrace();
		} finally {
		    try { rs.close(); } catch (Exception e) { /* Ignored */ }
		    try { stmt.close(); } catch (Exception e) { /* Ignored */ }
		}
		
		return null;
	};
	
	@Override
	public CommonCode getCommonCode(Connection conn, String codeId) {
		
		try {
			stmt = conn.createStatement();
			
			String sql = new StringBuilder()
				.append("SELECT * 		\n")
				.append("FROM common_code	\n")
				.append("WHERE tenant_id = '" + JDBCConnectionPool.getTenantId(conn) + "'\n")
				.append("  AND code = '" + codeId + "'\n")
				.toString();
			
			logger.debug("sql:\n" + sql);
			
			rs = stmt.executeQuery(sql);
			
			CommonCode commonCode = new CommonCode();
			
			if(rs.next()) {
				commonCode = extractFromResultSet(rs);
			}
			
			return commonCode;
		} catch (SQLException ex) {
			ex.printStackTrace();
		} finally {
		    try { rs.close(); } catch (Exception e) { /* Ignored */ }
		    try { stmt.close(); } catch (Exception e) { /* Ignored */ }
		}
		
		return null;
	};
	
	@Override
	public boolean insert(Connection conn, CommonCode commonCode) {
		try {
			String sql = new StringBuilder()
					.append("INSERT INTO\n")
					.append("	sensor (\n")
					.append("		tenant_id,\n")
					.append("		code,\n")
					.append("		code_name,\n")
					.append("		code_type\n")
					.append("	)\n")
					.append("VALUES\n")
					.append("	(\n")
					.append("		?,\n")
					.append("		?,\n")
					.append("		?,\n")
					.append("		? \n")
					.append("	);\n")
					.toString();

			PreparedStatement ps = conn.prepareStatement(sql);
			
			ps.setString(1, JDBCConnectionPool.getTenantId(conn));
			ps.setString(2, commonCode.getCommonCodeId());
			ps.setString(3, commonCode.getCommonCodeName());
			ps.setString(4, commonCode.getCommonCodeType());
			
	        int i = ps.executeUpdate();

	        if(i == 1) {
	        	return true;
	        }

	    } catch (SQLException ex) {
	        ex.printStackTrace();
	    }

	    return false;
	}
	
	@Override
	public boolean update(Connection conn, CommonCode commonCode) {
		try {
			stmt = conn.createStatement();
			
			String sql = new StringBuilder()
					.append("UPDATE sensor\n")
					.append("SET\n")
					.append("	code_name='" + commonCode.getCommonCodeName() + "',\n")
					.append("	code_type='" + commonCode.getCommonCodeType() + "'\n")
					.append("WHERE tenant_id='" + JDBCConnectionPool.getTenantId(conn) + "'\n")
					.append("  AND code='" + commonCode.getCommonCodeId() + "';\n")
					.toString();
			
			logger.debug("sql:\n" + sql);
			
	        int i = stmt.executeUpdate(sql);

	        if(i == 1) {
	        	return true;
	        }

	    } catch (SQLException ex) {
	        ex.printStackTrace();
	    }

	    return false;
	}
	
	@Override
	public boolean delete(Connection conn, String codeId) {
		try {
			stmt = conn.createStatement();
			
			String sql = new StringBuilder()
					.append("DELETE FROM common_code\n")
					.append("WHERE tenant_id='" + JDBCConnectionPool.getTenantId(conn) + "'\n")
					.append("	AND code='" + codeId + "';\n")
					.toString();
			
			logger.debug("sql:\n" + sql);
			
			int i = stmt.executeUpdate(sql);

	        if(i == 1) {
	        	return true;
	        }

	    } catch (SQLException ex) {
	        ex.printStackTrace();
	    }

	    return false;
	}
	
	
	private CommonCode extractFromResultSet(ResultSet rs) throws SQLException {
		
		CommonCode commonCode = new CommonCode();
		
		commonCode.setCommonCodeId(rs.getString("code"));
		commonCode.setCommonCodeName(rs.getString("code_name"));
		commonCode.setCommonCodeType(rs.getString("code_type"));
		
	    return commonCode;
		
	}
}
