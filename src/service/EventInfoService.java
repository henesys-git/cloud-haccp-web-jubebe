package service;

import java.sql.Connection;
import java.util.List;

import org.apache.log4j.Logger;

import dao.EventInfoDao;
import mes.frame.database.JDBCConnectionPool;
import model.EventInfo;

public class EventInfoService {

	private EventInfoDao eventInfoDao;
	private String bizNo;
	private Connection conn;
	
	static final Logger logger = Logger.getLogger(EventInfoService.class.getName());
	
	public EventInfoService(EventInfoDao eventInfoDao, String bizNo) {
		this.eventInfoDao = eventInfoDao;
		this.bizNo = bizNo;
	}
	
	public boolean insert() {
		return false;
	}
	
	public List<EventInfo> getAllEventInfo() {
		List<EventInfo> list = null;
		
		try {
			conn = JDBCConnectionPool.getTenantDB(bizNo);
			list = eventInfoDao.getAllEventInfo(conn);
		} catch(Exception e) {
			logger.error(e.getMessage());
		} finally {
		    try { conn.close(); } catch (Exception e) { /* Ignored */ }
		}
		
		return list;
	}

	public EventInfo getEventInfoByCode(String code) {
		EventInfo event = null;
		
		try {
			conn = JDBCConnectionPool.getTenantDB(bizNo);
			event = eventInfoDao.getEventInfo(conn, code);
		} catch(Exception e) {
			logger.error(e.getMessage());
		} finally {
		    try { conn.close(); } catch (Exception e) { /* Ignored */ }
		}
		
		return event;
	}
}
