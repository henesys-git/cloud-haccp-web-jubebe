package dao;

import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;

import model.BiznoSubdomainPair;

public class BiznoSubdomainPairDaoImpl implements BiznoSubdomainPairDao {
	private Statement stmt;
	private ResultSet rs;
	
	public BiznoSubdomainPairDaoImpl() {
	}

	@Override
	public BiznoSubdomainPair getBiznoSubdomainPair(Connection conn, String subdomain) {
		
		try {
			stmt = conn.createStatement();
			
			String sql = new StringBuilder()
				.append("SELECT * 								\n")
				.append("FROM bizno_subdomain_pair				\n")
				.append("WHERE subdomain = '" + subdomain + "'	\n")
				.toString();
			
			rs = stmt.executeQuery(sql);
			
			BiznoSubdomainPair csp = new BiznoSubdomainPair();
			
			if(rs.next()) {
				csp = extractFromResultSet(rs);
			}
			
			return csp;
			
		} catch (SQLException ex) {
			ex.printStackTrace();
		} finally {
		    try { rs.close(); } catch (Exception e) { /* Ignored */ }
		    try { stmt.close(); } catch (Exception e) { /* Ignored */ }
		}
		
		return null;
	};
	
	private BiznoSubdomainPair extractFromResultSet(ResultSet rs) throws SQLException {
		BiznoSubdomainPair csp = new BiznoSubdomainPair();
	    
		csp.setBizNo(rs.getString("biz_no"));
		csp.setSubdomain(rs.getString("subdomain"));

	    return csp;
	}
}
