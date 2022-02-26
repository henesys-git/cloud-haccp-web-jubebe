package dao;

import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;

import org.apache.log4j.Logger;

import mes.frame.database.JDBCConnectionPool;
import model.LimitOutAlarmMessage;

public class AlarmMessageDaoImpl implements AlarmMessageDao {
	
	private Statement stmt;
	private ResultSet rs;
	
	static final Logger logger = 
			Logger.getLogger(AlarmMessageDaoImpl.class.getName());
	
	public AlarmMessageDaoImpl() {
	}
	
	/* TODO sensor_name 추가하기
	 * sensor 테이블에서 sensor_name 컬럼 with 절로 가져와야 하는데, 
	 * mariadb version 때문에 with절이 안되서 보류
	 * service 클래스에서 쿼리 한번 더 해서 sensor_name 가져옴
	 * */
	
	@Override
	public LimitOutAlarmMessage getLimitOutAlarmMessage(Connection conn, String eventCode) {
		
		try {
			stmt = conn.createStatement();
			
			String sql = new StringBuilder()
					.append("SELECT \n")
					.append("	C.channel_id,\n")
					.append("	C.api_token,\n")
					.append("	A.event_name,\n")
					.append("	B.code_name as process_name,\n")
					.append("	A.min_value,\n")
					.append("	A.max_value\n")
					.append("FROM event_info A\n")
					.append("INNER JOIN common_code B\n")
					.append("	ON A.parent_code = B.code\n")
					.append("INNER JOIN alarm_info C\n")
					.append("	ON A.tenant_id = C.tenant_id\n")
					.append("WHERE A.tenant_id = '" + JDBCConnectionPool.getTenantId(conn) + "'\n")
					.append("  AND A.event_code = '" + eventCode + "'\n")
					.toString();

			logger.debug("sql:\n" + sql);
			
			rs = stmt.executeQuery(sql);
			
			LimitOutAlarmMessage cam = new LimitOutAlarmMessage();
			
			if(rs.next()) {
				cam = extractFromResultSet(rs);
			}
			
			return cam;
		} catch (SQLException ex) {
			ex.printStackTrace();
		} finally {
		    try { rs.close(); } catch (Exception e) { /* Ignored */ }
		    try { stmt.close(); } catch (Exception e) { /* Ignored */ }
		}
		
		return null;
	};
	
	private LimitOutAlarmMessage extractFromResultSet(ResultSet rs) throws SQLException {
		LimitOutAlarmMessage cam = new LimitOutAlarmMessage();
		
		cam.setChannelId(rs.getString("channel_id"));
		cam.setApiToken(rs.getString("api_token"));
		cam.setEventName(rs.getString("event_name"));
		cam.setProcessName(rs.getString("process_name"));
		cam.setMinValue(rs.getDouble("min_value"));
		cam.setMaxValue(rs.getDouble("max_value"));
		
	    return cam;
	}
}
