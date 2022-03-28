package dao;

import java.sql.Connection;
import java.util.List;

import model.Sensor;

public interface SensorDao {
	public List<Sensor> getAllSensors(Connection conn);
	public Sensor getSensor(Connection conn, String sensor);
	public boolean insert(Connection conn, Sensor sensor);
	public boolean update(Connection conn, Sensor sensor);
	public boolean delete(Connection conn, String sensor_id);
}