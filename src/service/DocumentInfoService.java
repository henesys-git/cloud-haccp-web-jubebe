package service;

import java.sql.Connection;
import java.util.List;

import org.apache.log4j.Logger;

import dao.ChecklistInfoDao;
import mes.frame.database.JDBCConnectionPool;
import model.ChecklistInfo;

public class DocumentInfoService {
	private ChecklistInfoDao clDao;
	private String bizNo;
	private Connection conn;
	
	static final Logger logger = Logger.getLogger(DocumentInfoService.class.getName());
	
	public DocumentInfoService(ChecklistInfoDao clDao, String bizNo) {
		this.clDao = clDao;
		this.bizNo = bizNo;
	}
	
	public List<ChecklistInfo> selectAll() {
		List<ChecklistInfo> checklistInfoList = null;
		
		try {
			conn = JDBCConnectionPool.getTenantDB(bizNo);
			checklistInfoList = clDao.selectAll(conn);
		} catch(Exception e) {
			logger.error(e.getMessage());
		} finally {
		    try { conn.close(); } catch (Exception e) { /* Ignored */ }
		}
		
		return checklistInfoList;
	}
	
	public ChecklistInfo select(String checklistId) {
		ChecklistInfo clInfo = null;
		
		try {
			conn = JDBCConnectionPool.getTenantDB(bizNo);
			clInfo = clDao.select(conn, checklistId);
		} catch(Exception e) {
			logger.error(e.getMessage());
		} finally {
		    try { conn.close(); } catch (Exception e) { /* Ignored */ }
		}
		
		return clInfo;
	}
	
	public boolean insert(ChecklistInfo clInfo) {
		try {
			conn = JDBCConnectionPool.getTenantDB(bizNo);
			return clDao.insert(conn, clInfo);
		} catch(Exception e) {
			logger.error(e.getMessage());
		} finally {
		    try { conn.close(); } catch (Exception e) { /* Ignored */ }
		}
		
		return false;
	}
	
	public boolean update(ChecklistInfo clInfo) {
		try {
			conn = JDBCConnectionPool.getTenantDB(bizNo);
			return clDao.update(conn, clInfo);
		} catch(Exception e) {
			logger.error(e.getMessage());
		} finally {
		    try { conn.close(); } catch (Exception e) { /* Ignored */ }
		}
		
		return false;
	}
	
	public boolean delete(String checklistId) {
		try {
			conn = JDBCConnectionPool.getTenantDB(bizNo);
			return clDao.delete(conn, checklistId);
		} catch(Exception e) {
			logger.error(e.getMessage());
		} finally {
		    try { conn.close(); } catch (Exception e) { /* Ignored */ }
		}
		
		return false;
	}
}
