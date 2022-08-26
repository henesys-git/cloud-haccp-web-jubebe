package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
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
	
	@Override
	public boolean insert(Connection conn, Sensor sensor) {
		try {
			String sql = new StringBuilder()
					.append("INSERT INTO\n")
					.append("	sensor (\n")
					.append("		tenant_id,\n")
					.append("		sensor_id,\n")
					.append("		sensor_name,\n")
					.append("		value_type,\n")
					.append("		ip_address,\n")
					.append("		protocol_info,\n")
					.append("		packet_info,\n")
					.append("		type_code,\n")
					.append("		checklist_id\n")
					.append("	)\n")
					.append("VALUES\n")
					.append("	(\n")
					.append("		?,\n")
					.append("		?,\n")
					.append("		?,\n")
					.append("		?,\n")
					.append("		?,\n")
					.append("		?,\n")
					.append("		?,\n")
					.append("		?,\n")
					.append("		?\n")
					.append("	);\n")
					.toString();

			PreparedStatement ps = conn.prepareStatement(sql);
			
			ps.setString(1, JDBCConnectionPool.getTenantId(conn));
			ps.setString(2, sensor.getSensorId());
			ps.setString(3, sensor.getSensorName());
			ps.setString(4, sensor.getValueType());
			ps.setString(5, sensor.getIpAddress());
			ps.setString(6, sensor.getProtocolInfo());
			ps.setString(7, sensor.getPacketInfo());
			ps.setString(8, sensor.getTypeCode());
			ps.setString(9, sensor.getChecklistId());
			
	        int i = ps.executeUpdate();

	        if(i == 1) {
	        	return true;
	        }

	    } catch (SQLException ex) {
	        ex.printStackTrace();
	    }

	    return false;
	}
	
	@Override
	public boolean update(Connection conn, Sensor sensor) {
		try {
			stmt = conn.createStatement();
			
			String sql = new StringBuilder()
					.append("UPDATE sensor\n")
					.append("SET\n")
					.append("	sensor_name='" + sensor.getSensorName() + "',\n")
					.append("	value_type='" + sensor.getValueType() + "',\n")
					.append("	ip_address='" + sensor.getIpAddress() + "',\n")
					.append("	protocol_info='" + sensor.getProtocolInfo() + "',\n")
					.append("	packet_info='" + sensor.getPacketInfo() + "',\n")
					.append("	type_code='" + sensor.getTypeCode() + "' \n")
					.append("	checklist_id='" + sensor.getChecklistId() + "' \n")
					.append("WHERE tenant_id='" + JDBCConnectionPool.getTenantId(conn) + "'\n")
					.append("  AND sensor_id='" + sensor.getSensorId() + "';\n")
					.toString();
			
			logger.debug("sql:\n" + sql);
			
	        int i = stmt.executeUpdate(sql);

	        if(i == 1) {
	        	return true;
	        }

	    } catch (SQLException ex) {
	        ex.printStackTrace();
	    }

	    return false;
	}
	
	@Override
	public boolean delete(Connection conn, String sensorId) {
		try {
			stmt = conn.createStatement();
			
			String sql = new StringBuilder()
					.append("DELETE FROM sensor\n")
					.append("WHERE tenant_id='" + JDBCConnectionPool.getTenantId(conn) + "'\n")
					.append("	AND sensor_id='" + sensorId + "';\n")
					.toString();
			
			logger.debug("sql:\n" + sql);
			
			int i = stmt.executeUpdate(sql);

	        if(i == 1) {
	        	return true;
	        }

	    } catch (SQLException ex) {
	        ex.printStackTrace();
	    }

	    return false;
	}
	
	private Sensor extractFromResultSet(ResultSet rs) throws SQLException {
		
		Sensor sensor = new Sensor();
		
		sensor.setSensorId(rs.getString("sensor_id"));
		sensor.setSensorName(rs.getString("sensor_name"));
		sensor.setValueType(rs.getString("value_type"));
		sensor.setIpAddress(rs.getString("ip_address"));
		sensor.setProtocolInfo(rs.getString("protocol_info"));
		sensor.setPacketInfo(rs.getString("packet_info"));
		sensor.setTypeCode(rs.getString("type_code"));
		sensor.setChecklistId(rs.getString("checklist_id"));
		
	    return sensor;
	}
}
