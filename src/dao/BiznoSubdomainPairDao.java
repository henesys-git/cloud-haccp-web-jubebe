package dao;

import java.sql.Connection;

import model.BiznoSubdomainPair;

public interface BiznoSubdomainPairDao {
	public BiznoSubdomainPair getBiznoSubdomainPair(Connection conn, String subdomain);
}
