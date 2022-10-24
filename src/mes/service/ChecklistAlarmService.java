package mes.service;

import java.sql.Connection;
import java.util.List;

import org.apache.log4j.Logger;

import dao.ChecklistAlarmDao;
import mes.frame.database.JDBCConnectionPool;
import mes.model.ChecklistAlarm;
import mes.model.ChecklistSign;
import service.ChecklistInfoService;

public class ChecklistAlarmService {
	private ChecklistAlarmDao clDao;
	private String bizNo;
	private Connection conn;
	
	static final Logger logger = Logger.getLogger(ChecklistInfoService.class.getName());
	
	public ChecklistAlarmService(ChecklistAlarmDao clDao, String bizNo) {
		this.clDao = clDao;
		this.bizNo = bizNo;
	}
	
	public List<ChecklistAlarm> select() {
		List<ChecklistAlarm> clAlarm = null;
		
		try {
			conn = JDBCConnectionPool.getTenantDB(bizNo);
			clAlarm = clDao.select(conn);
		} catch(Exception e) {
			logger.error(e.getMessage());
		} finally {
		    try { conn.close(); } catch (Exception e) { /* Ignored */ }
		}
		
		return clAlarm;
	}
	
	public List<ChecklistSign> select2() {
		List<ChecklistSign> clSign = null;
		
		try {
			conn = JDBCConnectionPool.getTenantDB(bizNo);
			clSign = clDao.select2(conn);
		} catch(Exception e) {
			logger.error(e.getMessage());
		} finally {
		    try { conn.close(); } catch (Exception e) { /* Ignored */ }
		}

		return clSign;
	}
	
	public boolean alarm(ChecklistAlarm clAlarm) {
		try {
			conn = JDBCConnectionPool.getTenantDB(bizNo);
			return clDao.alarm(conn, clAlarm);
		} catch(Exception e) {
			logger.error(e.getMessage());
		} finally {
		    try { conn.close(); } catch (Exception e) { /* Ignored */ }
		}
		return false;
	}
	
}
