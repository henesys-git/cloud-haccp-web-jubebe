package service;

import java.sql.Connection;
import java.util.List;

import org.apache.log4j.Logger;

import dao.ChecklistDataDao;
import mes.frame.database.JDBCConnectionPool;
import model.ChecklistData;

public class ChecklistDataService {
	private ChecklistDataDao clDao;
	private String bizNo;
	private Connection conn;
	
	static final Logger logger = Logger.getLogger(ChecklistDataService.class.getName());
	
	public ChecklistDataService(ChecklistDataDao clDao, String bizNo) {
		this.clDao = clDao;
		this.bizNo = bizNo;
	}
	
	public int insert(ChecklistData clData) {
		int result = -1;
		
		try {
			conn = JDBCConnectionPool.getTenantDB(bizNo);
			result = clDao.insert(conn, clData);
		} catch(Exception e) {
			logger.error(e.getMessage());
		} finally {
		    try { conn.close(); } catch (Exception e) { /* Ignored */ }
		}
		
		return result;
	}
	
	public ChecklistData select(String checklistId, int seqNo) {
		ChecklistData clData = null;
		
		try {
			conn = JDBCConnectionPool.getTenantDB(bizNo);
			clData = clDao.select(conn, checklistId, seqNo);
		} catch(Exception e) {
			logger.error(e.getMessage());
		} finally {
		    try { conn.close(); } catch (Exception e) { /* Ignored */ }
		}
		
		return clData;
	}
	
	public List<ChecklistData> selectAll(String checklistId) {
		List<ChecklistData> list = null;
		
		try {
			conn = JDBCConnectionPool.getTenantDB(bizNo);
			list = clDao.selectAll(conn, checklistId);
		} catch(Exception e) {
			logger.error(e.getMessage());
		} finally {
		    try { conn.close(); } catch (Exception e) { /* Ignored */ }
		}
		
		return list;
	}
	
	public int update(ChecklistData clData) {
		int result = -1;
		
		try {
			conn = JDBCConnectionPool.getTenantDB(bizNo);
			result = clDao.update(conn, clData);
		} catch(Exception e) {
			logger.error(e.getMessage());
		} finally {
		    try { conn.close(); } catch (Exception e) { /* Ignored */ }
		}
		
		return result;
	}
	
	public int delete(ChecklistData clData) {
		int result = -1;
		
		try {
			conn = JDBCConnectionPool.getTenantDB(bizNo);
			result = clDao.delete(conn, clData);
		} catch(Exception e) {
			logger.error(e.getMessage());
		} finally {
		    try { conn.close(); } catch (Exception e) { /* Ignored */ }
		}
		
		return result;
	}
	
	public int doSign(ChecklistData clData, String signTarget, String loginId) {
		int result = -1;
		
		try {
			conn = JDBCConnectionPool.getTenantDB(bizNo);
			result = clDao.doSign(conn, clData, signTarget, loginId);
		} catch(Exception e) {
			logger.error(e.getMessage());
		} finally {
		    try { conn.close(); } catch (Exception e) { /* Ignored */ }
		}
		
		return result;
	}
	
	public List<ChecklistData> selectSignColumn(String checklistId) {
		List<ChecklistData> list = null;
		
		try {
			conn = JDBCConnectionPool.getTenantDB(bizNo);
			list = clDao.selectSignColumn(conn, checklistId);
		} catch(Exception e) {
			logger.error(e.getMessage());
		} finally {
		    try { conn.close(); } catch (Exception e) { /* Ignored */ }
		}
		
		return list;
	}
}
