package mes.dao;

import java.sql.Connection;
import java.util.List;

import mes.model.Sensor;

public interface SensorDao {
	public List<Sensor> getAllSensors(Connection conn);
}