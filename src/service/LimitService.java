package service;

import java.sql.Connection;
import java.util.List;

import org.apache.log4j.Logger;

import dao.LimitDao;
import mes.frame.database.JDBCConnectionPool;
import model.Limit;

public class LimitService {

	private LimitDao limitDao;
	private String bizNo;
	private Connection conn;
	
	static final Logger logger = Logger.getLogger(LimitService.class.getName());

	public LimitService(LimitDao limitDao, String bizNo) {
		this.limitDao = limitDao;
		this.bizNo = bizNo;
	}
	
	public List<Limit> getAllLimit() {
		List<Limit> limitList = null;
		
		try {
			conn = JDBCConnectionPool.getTenantDB(bizNo);
			limitList = limitDao.getAllLimit(conn);
		} catch(Exception e) {
			logger.error(e.getMessage());
		} finally {
		    try { conn.close(); } catch (Exception e) { /* Ignored */ }
		}
		
		return limitList;
	}
	
	public List<Limit> getLimitType1(String type) {
		List<Limit> limitList = null;
		
		try {
			conn = JDBCConnectionPool.getTenantDB(bizNo);
			limitList = limitDao.getLimitType1(conn, type);
		} catch(Exception e) {
			logger.error(e.getMessage());
		} finally {
		    try { conn.close(); } catch (Exception e) { /* Ignored */ }
		}
		
		return limitList;
	}
	
	public List<Limit> getLimitType2(String type) {
		List<Limit> limitList = null;
		
		try {
			conn = JDBCConnectionPool.getTenantDB(bizNo);
			limitList = limitDao.getLimitType2(conn, type);
		} catch(Exception e) {
			logger.error(e.getMessage());
		} finally {
		    try { conn.close(); } catch (Exception e) { /* Ignored */ }
		}
		
		return limitList;
	}
	
	public Limit getLimitById(String eventCode, String objectId) {
		Limit limit = null;
		
		try {
			conn = JDBCConnectionPool.getTenantDB(bizNo);
			limit = limitDao.getLimit(conn, eventCode, objectId);
		} catch(Exception e) {
			logger.error(e.getMessage());
		} finally {
		    try { conn.close(); } catch (Exception e) { /* Ignored */ }
		}
		
		return limit;
	}
	
	public boolean insert(Limit limit) {
		try {
			conn = JDBCConnectionPool.getTenantDB(bizNo);
			return limitDao.insert(conn, limit);
		} catch(Exception e) {
			logger.error(e.getMessage());
		} finally {
		    try { conn.close(); } catch (Exception e) { /* Ignored */ }
		}
		
		return false;
	}
	
	public boolean update(Limit limit) {
		try {
			conn = JDBCConnectionPool.getTenantDB(bizNo);
			return limitDao.update(conn, limit);
		} catch(Exception e) {
			logger.error(e.getMessage());
		} finally {
		    try { conn.close(); } catch (Exception e) { /* Ignored */ }
		}
		
		return false;
	}
	
	public boolean delete(String eventCode, String objectId) {
		try {
			conn = JDBCConnectionPool.getTenantDB(bizNo);
			return limitDao.delete(conn, eventCode, objectId);
		} catch(Exception e) {
			logger.error(e.getMessage());
		} finally {
		    try { conn.close(); } catch (Exception e) { /* Ignored */ }
		}
		
		return false;
	}
}
