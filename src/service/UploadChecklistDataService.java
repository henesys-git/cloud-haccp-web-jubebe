package service;

import java.sql.Connection;
import java.util.List;

import org.apache.log4j.Logger;

import dao.ChecklistDataDao;
import dao.DocumentDataDao;
import dao.UploadChecklistDataDao;
import mes.frame.database.JDBCConnectionPool;
import model.ChecklistData;
import model.DocumentData;
import model.UploadChecklistData;

public class UploadChecklistDataService {
	private UploadChecklistDataDao docDao;
	private String bizNo;
	private Connection conn;
	
	static final Logger logger = Logger.getLogger(UploadChecklistDataService.class.getName());
	
	public UploadChecklistDataService(UploadChecklistDataDao docDao, String bizNo) {
		this.docDao = docDao;
		this.bizNo = bizNo;
	}
	
	public int insert(UploadChecklistData docData) {
		int result = -1;
		
		try {
			conn = JDBCConnectionPool.getTenantDB(bizNo);
			result = docDao.insert(conn, docData);
		} catch(Exception e) {
			logger.error(e.getMessage());
		} finally {
		    try { conn.close(); } catch (Exception e) { /* Ignored */ }
		}
		
		return result;
	}
	
	public UploadChecklistData select(String documentId, int seqNo) {
		UploadChecklistData clData = null;
		
		try {
			conn = JDBCConnectionPool.getTenantDB(bizNo);
			clData = docDao.select(conn, documentId, seqNo);
		} catch(Exception e) {
			logger.error(e.getMessage());
		} finally {
		    try { conn.close(); } catch (Exception e) { /* Ignored */ }
		}
		
		return clData;
	}
	
	public List<UploadChecklistData> selectAll(String documentId) {
		List<UploadChecklistData> list = null;
		
		try {
			conn = JDBCConnectionPool.getTenantDB(bizNo);
			list = docDao.selectAll(conn, documentId);
		} catch(Exception e) {
			logger.error(e.getMessage());
		} finally {
		    try { conn.close(); } catch (Exception e) { /* Ignored */ }
		}
		
		return list;
	}
	
	public int update(UploadChecklistData docData) {
		int result = -1;
		
		try {
			conn = JDBCConnectionPool.getTenantDB(bizNo);
			result = docDao.update(conn, docData);
		} catch(Exception e) {
			logger.error(e.getMessage());
		} finally {
		    try { conn.close(); } catch (Exception e) { /* Ignored */ }
		}
		
		return result;
	}
	
	public int delete(UploadChecklistData docData) {
		int result = -1;
		
		try {
			conn = JDBCConnectionPool.getTenantDB(bizNo);
			result = docDao.delete(conn, docData);
		} catch(Exception e) {
			logger.error(e.getMessage());
		} finally {
		    try { conn.close(); } catch (Exception e) { /* Ignored */ }
		}
		
		return result;
	}
	
}
