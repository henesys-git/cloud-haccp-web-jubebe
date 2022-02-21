package dao;

import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;

import org.apache.log4j.Logger;

import mes.frame.database.JDBCConnectionPool;
import model.EventInfo;

public class EventInfoDaoImpl implements EventInfoDao {
	
	private Statement stmt;
	private ResultSet rs;
	
	static final Logger logger = 
			Logger.getLogger(EventInfoDaoImpl.class.getName());
	
	public EventInfoDaoImpl() {
	}
	
	@Override
	public List<EventInfo> getAllEventInfo(Connection conn) {
		
		try {
			stmt = conn.createStatement();
			
			String sql = new StringBuilder()
				.append("SELECT \n")
				.append("	A.event_code,\n")
				.append("	A.event_name,\n")
				.append("	A.min_value,\n")
				.append("	A.max_value,\n")
				.append("	B.code_name as process_name\n")
				.append("FROM event_info A\n")
				.append("INNER JOIN common_code B\n")
				.append("	ON A.parent_code = B.code\n")
				.append("WHERE A.tenant_id = '" + JDBCConnectionPool.getTenantId(conn) + "'\n")
				.toString();
			
			logger.debug("sql:\n" + sql);
			
			rs = stmt.executeQuery(sql);
			
			List<EventInfo> list = new ArrayList<EventInfo>();
			
			while(rs.next()) {
				EventInfo info = extractFromResultSet(rs);
				list.add(info);
			}
			
			return list;
			
		} catch (SQLException ex) {
			ex.printStackTrace();
		} finally {
		    try { rs.close(); } catch (Exception e) { /* Ignored */ }
		    try { stmt.close(); } catch (Exception e) { /* Ignored */ }
		}
		
		return null;
	};

	@Override
	public EventInfo getEventInfo(Connection conn, String eventCode) {
		
		try {
			stmt = conn.createStatement();
			
			String sql = new StringBuilder()
					.append("SELECT \n")
					.append("	A.event_code,\n")
					.append("	A.event_name,\n")
					.append("	A.min_value,\n")
					.append("	A.max_value,\n")
					.append("	B.code_name as process_name\n")
					.append("FROM event_info A\n")
					.append("INNER JOIN common_code B\n")
					.append("	ON A.parent_code = B.code\n")
					.append("WHERE A.tenant_id = '" + JDBCConnectionPool.getTenantId(conn) + "'\n")
					.append("  AND A.event_code = '" + eventCode + "'\n")
					.toString();

			logger.debug("sql:\n" + sql);
			
			rs = stmt.executeQuery(sql);
			
			EventInfo event = new EventInfo();
			
			if(rs.next()) {
				event = extractFromResultSet(rs);
			}
			
			return event;
		} catch (SQLException ex) {
			ex.printStackTrace();
		} finally {
		    try { rs.close(); } catch (Exception e) { /* Ignored */ }
		    try { stmt.close(); } catch (Exception e) { /* Ignored */ }
		}
		
		return null;
	};
	
	private EventInfo extractFromResultSet(ResultSet rs) throws SQLException {
		EventInfo event = new EventInfo();
		
		event.setEventCode(rs.getString("event_code"));
		event.setEventName(rs.getString("event_name"));
		event.setMinValue(rs.getDouble("min_value"));
		event.setMaxValue(rs.getDouble("max_value"));
		event.setProcessName(rs.getString("process_name"));
		
	    return event;
	}
}
