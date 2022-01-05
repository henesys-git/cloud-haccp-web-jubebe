package mes.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;

import org.apache.log4j.Logger;

import mes.model.Sensor;

public class SensorDaoImpl implements SensorDao {
	
	static final Logger logger = 
			Logger.getLogger(SensorDaoImpl.class.getName());
	
	public SensorDaoImpl() {
	}

	@Override
	public List<Sensor> getAllSensors(Connection conn) {
		
		try {
			Statement stmt = conn.createStatement();
			
			String sql = new StringBuilder()
				.append("SELECT * 		\n")
				.append("FROM sensor	\n")
				.toString();
			
			logger.debug("sql:\n" + sql);
			
			ResultSet rs = stmt.executeQuery(sql);
			
			List<Sensor> sensorList = new ArrayList<Sensor>();
			
			while(rs.next()) {
				Sensor data = extractFromResultSet(rs);
				sensorList.add(data);
			}
			
			return sensorList;
			
		} catch (SQLException ex) {
			ex.printStackTrace();
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
