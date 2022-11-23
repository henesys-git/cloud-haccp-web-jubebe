package service;

import java.sql.Connection;
import java.util.List;

import org.apache.log4j.Logger;

import dao.CCPLimitDao;
import mes.frame.database.JDBCConnectionPool;
import model.CCPLimit;

public class CCPLimitService {

	private CCPLimitDao ccpLimitDao;
	private String bizNo;
	private Connection conn;
	
	static final Logger logger = Logger.getLogger(CCPLimitService.class.getName());
	
	public CCPLimitService(CCPLimitDao ccpLimitDao, String bizNo) {
		this.ccpLimitDao = ccpLimitDao;
		this.bizNo = bizNo;
	}
	
	public boolean insert() {
		return false;
	}
	
	public List<CCPLimit> getAllCCPLimit() {
		List<CCPLimit> list = null;
		
		try {
			conn = JDBCConnectionPool.getTenantDB(bizNo);
			list = ccpLimitDao.getAllCCPLimit(conn);
		} catch(Exception e) {
			logger.error(e.getMessage());
		} finally {
		    try { conn.close(); } catch (Exception e) { /* Ignored */ }
		}
		
		return list;
	}

	public CCPLimit getCCPLimitByCode(String evtCode, String productId) {
		CCPLimit ccpLimit = null;
		
		try {
			conn = JDBCConnectionPool.getTenantDB(bizNo);
			ccpLimit = ccpLimitDao.getCCPLimit(conn, evtCode, productId);
		} catch(Exception e) {
			logger.error(e.getMessage());
		} finally {
		    try { conn.close(); } catch (Exception e) { /* Ignored */ }
		}
		
		return ccpLimit;
	}
	
	public boolean isLimitOut(CCPLimit ccpLimit, String value) {
		String min = ccpLimit.getMinValue();
		String max = ccpLimit.getMaxValue();
		
		logger.info("isLimitOut()");
		logger.info("biz: " + this.bizNo);
		logger.info(ccpLimit.toString());
		logger.info("min: " + min);
		logger.info("max: " + max);
		logger.info("val: " + value);
		
		try {
			double valueD = Double.parseDouble(value);
			double minD = Double.parseDouble(min);
			double maxD = Double.parseDouble(max);
			
			if( valueD < minD || valueD > maxD ) {
				logger.info("limit out: true");
				return true;
			}
		} catch(NumberFormatException e) {
			if( value.compareTo(min) < 0 ) {
				logger.info("limit out: true");
				return true;
			}
			
			if( value.compareTo(max) > 0 ) {
				logger.info("limit out: true");
				return true;
			}
		}
		
		logger.info("limit out: false");
		return false;
	}
}
