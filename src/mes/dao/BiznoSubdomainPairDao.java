package mes.dao;

import java.sql.Connection;

import mes.model.BiznoSubdomainPair;

public interface BiznoSubdomainPairDao {
	public BiznoSubdomainPair getBiznoSubdomainPair(Connection conn, String subdomain);
}
