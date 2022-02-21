package service;

import java.sql.Connection;

import org.apache.log4j.Logger;

import dao.BiznoSubdomainPairDao;
import mes.frame.database.JDBCConnectionPool;
import model.BiznoSubdomainPair;

public class BiznoSubdomainPairService {
	private BiznoSubdomainPairDao bspDao;
	private Connection conn;
	
	static final Logger logger = Logger.getLogger(BiznoSubdomainPairService.class.getName());
	
	public BiznoSubdomainPairService(BiznoSubdomainPairDao bspDao) {
		this.bspDao = bspDao;
	}
	
	public String getBizno(String subdomain) {
		BiznoSubdomainPair bsPair = null;
		
		try {
			conn = JDBCConnectionPool.getMasterDB();
			bsPair = bspDao.getBiznoSubdomainPair(conn, subdomain);
		} catch(Exception e) {
			logger.error(e.getMessage());
		} finally {
		    try { conn.close(); } catch (Exception e) { /* Ignored */ }
		}
		
		return bsPair.getBizNo();
	}
}
