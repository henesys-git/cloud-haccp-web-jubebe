package dao;

import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;

import model.BiznoSubdomainPair;

public class BiznoSubdomainPairDaoImpl implements BiznoSubdomainPairDao {
	public BiznoSubdomainPairDaoImpl() {
	}

	@Override
	public BiznoSubdomainPair getBiznoSubdomainPair(Connection conn, String subdomain) {
		
		try {
			Statement stmt = conn.createStatement();
			
			String sql = new StringBuilder()
				.append("SELECT * 								\n")
				.append("FROM bizno_subdomain_pair				\n")
				.append("WHERE subdomain = '" + subdomain + "'	\n")
				.toString();
			
			ResultSet rs = stmt.executeQuery(sql);
			
			BiznoSubdomainPair csp = new BiznoSubdomainPair();
			
			if(rs.next()) {
				csp = extractFromResultSet(rs);
			}
			
			return csp;
			
		} catch (SQLException ex) {
			ex.printStackTrace();
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
