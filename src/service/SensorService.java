package service;

import java.sql.Connection;
import java.util.List;

import dao.SensorDao;
import mes.frame.database.JDBCConnectionPool;
import model.Sensor;

public class SensorService {

	private SensorDao sensorDao;
	private String bizNo;
	private List<Sensor> sensorList;
	
	public SensorService(SensorDao sensorDao, String bizNo) {
		this.sensorDao = sensorDao;
		this.bizNo = bizNo;
	}
	
	public List<Sensor> getAllSensors() {
		Connection conn = JDBCConnectionPool.getTenantDB(bizNo);
		
		sensorList = sensorDao.getAllSensors(conn);
		
		return sensorList;
	}
	
	public Sensor getSensorById(String id) {
		Connection conn = JDBCConnectionPool.getTenantDB(bizNo);
		Sensor sensor = sensorDao.getSensor(conn, id);
		return sensor;
	}
	
	public boolean judgeValue(Sensor sensor, double value) {
		double min = sensor.getValueMin();
		double max = sensor.getValueMax();
		
		if( value < min || value > max ) {
			return false;
		}
		
		return true;
	}
}
