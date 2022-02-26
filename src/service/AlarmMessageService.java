package service;

import java.sql.Connection;

import org.apache.log4j.Logger;

import dao.AlarmMessageDao;
import dao.SensorDaoImpl;
import mes.frame.database.JDBCConnectionPool;
import model.LimitOutAlarmMessage;
import model.Sensor;

public class AlarmMessageService {
	
	private AlarmMessageDao alarmMessageDao;
	private Connection conn;
	
	static final Logger logger = Logger.getLogger(AlarmMessageService.class.getName());

	public AlarmMessageService(AlarmMessageDao alarmMessageDao) {
		this.alarmMessageDao = alarmMessageDao;
	}
	
	public LimitOutAlarmMessage getMessage(String bizNo, String eventCode, String sensorId) {
		LimitOutAlarmMessage limitOutAlarmMessage = null;
		Sensor sensor = null;
		
		try {
			conn = JDBCConnectionPool.getTenantDB(bizNo);
			
			limitOutAlarmMessage = alarmMessageDao.getLimitOutAlarmMessage(conn, eventCode);
			
			// TODO getLimitOutAlarmMessage 메서드에 sensorName도 한꺼번에 가져와서 아래 두줄 없애야됨
			SensorService sensorService = new SensorService(new SensorDaoImpl(), bizNo);
			sensor = sensorService.getSensorById(sensorId);
			
			limitOutAlarmMessage.setSensorName(sensor.getSensorName());
		} catch(Exception e) {
			logger.error(e.getMessage());
		} finally {
		    try { conn.close(); } catch (Exception e) { /* Ignored */ }
		}

		return limitOutAlarmMessage;
	}
}
