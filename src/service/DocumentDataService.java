package service;

import java.sql.Connection;
import java.util.List;

import org.apache.log4j.Logger;

import dao.ChecklistDataDao;
import dao.DocumentDataDao;
import mes.frame.database.JDBCConnectionPool;
import model.ChecklistData;
import model.DocumentData;

public class DocumentDataService {
	private DocumentDataDao docDao;
	private String bizNo;
	private Connection conn;
	
	static final Logger logger = Logger.getLogger(DocumentDataService.class.getName());
	
	public DocumentDataService(DocumentDataDao docDao, String bizNo) {
		this.docDao = docDao;
		this.bizNo = bizNo;
	}
	
	public int insert(DocumentData docData) {
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
	
	public DocumentData select(String documentId, int seqNo) {
		DocumentData clData = null;
		
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
	
	public List<DocumentData> selectAll(String documentId) {
		List<DocumentData> list = null;
		
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
	
	public int update(DocumentData docData) {
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
	
	public int delete(DocumentData docData) {
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
