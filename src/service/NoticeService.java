package service;

import java.sql.Connection;
import java.util.List;

import org.apache.log4j.Logger;

import dao.NoticeDao;
import mes.frame.database.JDBCConnectionPool;
import model.Notice;

public class NoticeService {
	
	private NoticeDao noticeDao;
	private String tenantId;
	private Connection conn;
	
	static final Logger logger = Logger.getLogger(NoticeService.class.getName());
	
    public NoticeService(NoticeDao noticeDao, String tenantId) {
    	this.noticeDao = noticeDao;
    	this.tenantId = tenantId;
    }
    
    public List<Notice> getAllNotice() {
    	List<Notice> noticeList = null;
    	
    	try {
    		conn = JDBCConnectionPool.getTenantDB(tenantId);
    		noticeList = noticeDao.getAllNotice(conn);
    	} catch(Exception e) {
    		logger.error(e.getMessage());
		} finally {
		    try { conn.close(); } catch (Exception e) { /* Ignored */ }
		}
    	
    	return noticeList;
    }
    
    public List<Notice> getActiveNotice() {
    	List<Notice> noticeList = null;
    	
    	try {
    		conn = JDBCConnectionPool.getTenantDB(tenantId);
    		noticeList = noticeDao.getActiveNotice(conn);
    	} catch(Exception e) {
    		logger.error(e.getMessage());
		} finally {
		    try { conn.close(); } catch (Exception e) { /* Ignored */ }
		}
    	
    	return noticeList;
    }
    
    public Notice getNotice(String regDatetime) {
    	Notice notice = null;
    	
    	try {
    		conn = JDBCConnectionPool.getTenantDB(tenantId);
    		notice = noticeDao.getNotice(conn, regDatetime);
    	} catch(Exception e) {
    		logger.error(e.getMessage());
		} finally {
		    try { conn.close(); } catch (Exception e) { /* Ignored */ }
		}
    	
    	return notice;
    }
    
    public boolean insert(Notice notice) {
		try {
			conn = JDBCConnectionPool.getTenantDB(tenantId);
			return noticeDao.insert(conn, notice);
		} catch(Exception e) {
			logger.error(e.getMessage());
		} finally {
		    try { conn.close(); } catch (Exception e) { /* Ignored */ }
		}
		
		return false;
	}
	
	public boolean update(Notice notice) {
		try {
			conn = JDBCConnectionPool.getTenantDB(tenantId);
			return noticeDao.update(conn, notice);
		} catch(Exception e) {
			logger.error(e.getMessage());
		} finally {
		    try { conn.close(); } catch (Exception e) { /* Ignored */ }
		}
		
		return false;
	}
	
	public boolean delete(String registerDatetime) {
		try {
			conn = JDBCConnectionPool.getTenantDB(tenantId);
			return noticeDao.delete(conn, registerDatetime);
		} catch(Exception e) {
			logger.error(e.getMessage());
		} finally {
		    try { conn.close(); } catch (Exception e) { /* Ignored */ }
		}
		
		return false;
	}
}