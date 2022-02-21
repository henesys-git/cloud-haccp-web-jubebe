package dao;

import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;

import org.apache.log4j.Logger;

import mes.frame.database.JDBCConnectionPool;
import model.Sensor;

public class SensorDaoImpl implements SensorDao {
	
	private Statement stmt;
	private ResultSet rs;
	
	static final Logger logger = 
			Logger.getLogger(SensorDaoImpl.class.getName());
	
	public SensorDaoImpl() {
	}

	@Override
	public List<Sensor> getAllSensors(Connection conn) {
		
		try {
			stmt = conn.createStatement();
			
			String sql = new StringBuilder()
				.append("SELECT * 		\n")
				.append("FROM sensor	\n")
				.append("WHERE tenant_id = '" + JDBCConnectionPool.getTenantId(conn) + "'\n")
				.toString();
			
			logger.debug("sql:\n" + sql);
			
			rs = stmt.executeQuery(sql);
			
			List<Sensor> sensorList = new ArrayList<Sensor>();
			
			while(rs.next()) {
				Sensor data = extractFromResultSet(rs);
				sensorList.add(data);
			}
			
			return sensorList;
			
		} catch (SQLException ex) {
			ex.printStackTrace();
		} finally {
		    try { rs.close(); } catch (Exception e) { /* Ignored */ }
		    try { stmt.close(); } catch (Exception e) { /* Ignored */ }
		}
		
		return null;
	};
	
	@Override
	public Sensor getSensor(Connection conn, String sensorId) {
		
		try {
			stmt = conn.createStatement();
			
			String sql = new StringBuilder()
				.append("SELECT * 		\n")
				.append("FROM sensor	\n")
				.append("WHERE tenant_id = '" + JDBCConnectionPool.getTenantId(conn) + "'\n")
				.append("  AND sensor_id = '" + sensorId + "'\n")
				.toString();
			
			logger.debug("sql:\n" + sql);
			
			rs = stmt.executeQuery(sql);
			
			Sensor sensor = new Sensor();
			
			if(rs.next()) {
				sensor = extractFromResultSet(rs);
			}
			
			return sensor;
		} catch (SQLException ex) {
			ex.printStackTrace();
		} finally {
		    try { rs.close(); } catch (Exception e) { /* Ignored */ }
		    try { stmt.close(); } catch (Exception e) { /* Ignored */ }
		}
		
		return null;
	};
	
	private Sensor extractFromResultSet(ResultSet rs) throws SQLException {
		Sensor sensor = new Sensor();
		
		sensor.setSensorId(rs.getString("sensor_id"));
		sensor.setSensorName(rs.getString("sensor_name"));
		sensor.setValueMax(rs.getDouble("value_max"));
		sensor.setValueMin(rs.getDouble("value_min"));
		sensor.setValueType(rs.getString("value_type"));
		sensor.setIpAddress(rs.getString("ip_address"));
		sensor.setProtocolInfo(rs.getString("protocol_info"));
		sensor.setPacketInfo(rs.getString("packet_info"));
		sensor.setTypeCode(rs.getString("type_code"));
		
	    return sensor;
	}
}
