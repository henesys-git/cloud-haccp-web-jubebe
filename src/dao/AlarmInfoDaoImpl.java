package dao;

import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;

import org.apache.log4j.Logger;

import mes.frame.database.JDBCConnectionPool;
import model.AlarmInfo;

public class AlarmInfoDaoImpl implements AlarmInfoDao {
	
	private Statement stmt;
	private ResultSet rs;
	
	static final Logger logger = 
			Logger.getLogger(AlarmInfoDaoImpl.class.getName());
	
	public AlarmInfoDaoImpl() {
	}
	
	@Override
	public AlarmInfo getAlarmInfo(Connection conn) {
		
		try {
			stmt = conn.createStatement();
			
			String sql = new StringBuilder()
					.append("SELECT \n")
					.append("	channel_id,\n")
					.append("	api_token\n")
					.append("FROM alarm_info A\n")
					.append("WHERE A.tenant_id = '" + JDBCConnectionPool.getTenantId(conn) + "'\n")
					.toString();

			logger.debug("sql:\n" + sql);
			
			rs = stmt.executeQuery(sql);
			
			AlarmInfo info = new AlarmInfo();
			
			if(rs.next()) {
				info = extractFromResultSet(rs);
			}
			
			return info;
		} catch (SQLException ex) {
			ex.printStackTrace();
		} finally {
		    try { rs.close(); } catch (Exception e) { /* Ignored */ }
		    try { stmt.close(); } catch (Exception e) { /* Ignored */ }
		}
		
		return null;
	};
	
	private AlarmInfo extractFromResultSet(ResultSet rs) throws SQLException {
		AlarmInfo info = new AlarmInfo();
		
		info.setChannelId(rs.getString("channel_id"));
		info.setApiToken(rs.getString("api_token"));
		
	    return info;
	}
}
