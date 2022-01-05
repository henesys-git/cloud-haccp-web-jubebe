package mes.service;

import java.sql.Connection;
import java.util.List;

import mes.dao.SensorDao;
import mes.frame.database.JDBCConnectionPool;
import mes.model.Sensor;

public class SensorService {

	private SensorDao sensorDao;
	private String bizNo;
	
	public SensorService(SensorDao sensorDao, String bizNo) {
		this.sensorDao = sensorDao;
		this.bizNo = bizNo;
	}
	
	public List<Sensor> getAllSensors() {
		Connection conn = JDBCConnectionPool.getTenantDB(bizNo);
		
		List<Sensor> sensorList = sensorDao.getAllSensors(conn);
		
		return sensorList;
	}
}
