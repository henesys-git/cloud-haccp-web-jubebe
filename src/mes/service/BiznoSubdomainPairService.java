package mes.service;

import java.sql.Connection;

import mes.dao.BiznoSubdomainPairDao;
import mes.frame.database.JDBCConnectionPool;
import mes.model.BiznoSubdomainPair;

public class BiznoSubdomainPairService {
	private BiznoSubdomainPairDao bspDao;
	
	public BiznoSubdomainPairService(BiznoSubdomainPairDao bspDao) {
		this.bspDao = bspDao;
	}
	
	public String getBizno(String subdomain) {
		Connection conn = JDBCConnectionPool.getMasterDB();
		
		BiznoSubdomainPair bsPair = bspDao.getBiznoSubdomainPair(conn, subdomain);
		
		return bsPair.getBizNo();
	}
}
