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
import model.Limit;

public class LimitDaoImpl implements LimitDao {
	
	private Statement stmt;
	private ResultSet rs;
	
	static final Logger logger = 
			Logger.getLogger(LimitDaoImpl.class.getName());
	
	public LimitDaoImpl() {
	}

	@Override
	public List<Limit> getAllLimit(Connection conn) {
		
		try {
			stmt = conn.createStatement();
			
			String sql = new StringBuilder()
				.append("SELECT  			\n")
				.append("A.event_code,  	\n")
				.append("B.event_name,  	\n")
				.append("A.object_id,  		\n")
				.append("IF(INSTR(A.object_id, 'TP') = 1, C.sensor_name, D.product_name) AS object_name, \n")
				.append("A.min_value,		\n")
				.append("A.max_value,		\n")
				.append("A.value_unit 		\n")
				.append("FROM ccp_limit A  				\n")
				.append("INNER JOIN event_info B		\n")
				.append("ON A.event_code = B.event_code \n")
				.append("LEFT JOIN sensor C  			\n")
				.append("ON A.object_id = C.sensor_id  	\n")
				.append("LEFT JOIN product D			\n")
				.append("ON A.object_id = D.product_id	\n")
				.append("WHERE A.tenant_id = '" + JDBCConnectionPool.getTenantId(conn) + "'\n")
				.toString();
			
			logger.debug("sql:\n" + sql);
			
			rs = stmt.executeQuery(sql);
			
			List<Limit> limitList = new ArrayList<Limit>();
			
			while(rs.next()) {
				Limit data = extractFromResultSet(rs);
				limitList.add(data);
			}
			
			return limitList;
			
		} catch (SQLException ex) {
			ex.printStackTrace();
		} finally {
		    try { rs.close(); } catch (Exception e) { /* Ignored */ }
		    try { stmt.close(); } catch (Exception e) { /* Ignored */ }
		}
		
		return null;
	};
	
	@Override
	public Limit getLimit(Connection conn, String eventCode, String objectId) {
		
		try {
			stmt = conn.createStatement();
			
			String sql = new StringBuilder()
				.append("SELECT * 		\n")
				.append("A.event_code,  	\n")
				.append("B.event_name,  	\n")
				.append("A.object_id,  		\n")
				.append("IF(INSTR(A.object_id, 'TP') = 1, C.sensor_name, D.product_name) AS object_name, \n")
				.append("A.min_value,		\n")
				.append("A.max_value,		\n")
				.append("A.value_unit 		\n")
				.append("FROM ccp_limit A  				\n")
				.append("INNER JOIN event_info B		\n")
				.append("ON A.event_code = B.event_code \n")
				.append("LEFT JOIN sensor C  			\n")
				.append("ON A.object_id = C.sensor_id  	\n")
				.append("LEFT JOIN product D			\n")
				.append("ON A.object_id = D.product_id	\n")
				.append("WHERE A.tenant_id = '" + JDBCConnectionPool.getTenantId(conn) + "'\n")
				.append("  AND A.event_code = '" + eventCode + "'\n")
				.append("  AND A.object_id = '" + objectId + "'\n")
				.toString();
			
			logger.debug("sql:\n" + sql);
			
			rs = stmt.executeQuery(sql);
			
			Limit limit = new Limit();
			
			if(rs.next()) {
				limit = extractFromResultSet(rs);
			}
			
			return limit;
		} catch (SQLException ex) {
			ex.printStackTrace();
		} finally {
		    try { rs.close(); } catch (Exception e) { /* Ignored */ }
		    try { stmt.close(); } catch (Exception e) { /* Ignored */ }
		}
		
		return null;
	};
	
	@Override
	public boolean insert(Connection conn, Limit limit) {
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
			ps.setString(2, limit.getEventCode());
			
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
	public boolean update(Connection conn, Limit limit) {
		try {
			stmt = conn.createStatement();
			
			String sql = new StringBuilder()
					.append("UPDATE ccp_limit \n")
					.append("SET\n")
					.append("min_value = '" + limit.getMinValue() + "', \n")
					.append("max_value = '" + limit.getMaxValue() + "', \n")
					.append("value_unit = '" + limit.getValueUnit() + "' \n")
					.append("WHERE tenant_id='" + JDBCConnectionPool.getTenantId(conn) + "'\n")
					.append("AND event_code='" + limit.getEventCode() + "' \n")
					.append("AND object_id='" + limit.getObjectId() + "' \n")
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
	public boolean delete(Connection conn, String eventCode, String objectId) {
		try {
			stmt = conn.createStatement();
			
			String sql = new StringBuilder()
					.append("DELETE FROM ccp_limit \n")
					.append("WHERE tenant_id='" + JDBCConnectionPool.getTenantId(conn) + "'\n")
					.append("	AND event_code='" + eventCode + "' \n")
					.append("	AND object_id='" + objectId + "' \n")
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
	
	private Limit extractFromResultSet(ResultSet rs) throws SQLException {
		
		Limit limit = new Limit();
		
		limit.setEventCode(rs.getString("event_code"));
		limit.setObjectId(rs.getString("object_id"));
		limit.setMinValue(rs.getString("min_value"));
		limit.setMaxValue(rs.getString("max_value"));
		limit.setValueUnit(rs.getString("value_unit"));
		limit.setEventName(rs.getString("event_name"));
		limit.setObjectName(rs.getString("object_name"));
		
	    return limit;
	}
}
