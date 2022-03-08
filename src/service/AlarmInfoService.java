package service;

import java.sql.Connection;

import org.apache.log4j.Logger;

import dao.AlarmInfoDao;
import mes.frame.database.JDBCConnectionPool;
import model.AlarmInfo;

public class AlarmInfoService {
	
	private AlarmInfoDao alarmInfoDao;
	private Connection conn;
	
	static final Logger logger = Logger.getLogger(AlarmInfoService.class.getName());

	public AlarmInfoService(AlarmInfoDao alarmInfoDao) {
		this.alarmInfoDao = alarmInfoDao;
	}
	
	public AlarmInfo getAlarmInfo(String tenantId) {
		AlarmInfo alarmInfo = null;
		
		try {
			conn = JDBCConnectionPool.getTenantDB(tenantId);
			alarmInfo = alarmInfoDao.getAlarmInfo(conn);
		} catch(Exception e) {
			logger.error(e.getMessage());
		} finally {
		    try { conn.close(); } catch (Exception e) { /* Ignored */ }
		}

		return alarmInfo;
	}
}
