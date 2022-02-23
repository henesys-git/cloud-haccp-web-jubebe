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
import mes.model.ChecklistAlarm;

public class ChecklistAlarmDaoImpl implements ChecklistAlarmDao {
	static final Logger logger = 
			Logger.getLogger(ChecklistAlarmDaoImpl.class.getName());
	
	@Override
	public List<ChecklistAlarm> select(Connection conn) {
		try {
			Statement stmt = conn.createStatement();
			
			String sql = new StringBuilder()
					.append("SELECT\n")
					.append("        A.checklist_id,\n")
					.append("        B.checklist_name,\n")
					.append("        B.revision_no,\n")
					.append("        A.check_interval,\n")
					.append("        A.latest_check_date\n")
					.append("FROM\n")
					.append("        checklist_alarm A\n")
					.append("INNER JOIN checklist_info B\n")
					.append("ON A.checklist_id = B.checklist_id \n")
					.append("WHERE A.tenant_id = '" + JDBCConnectionPool.getTenantId(conn) + "'\n")
					.append("ORDER BY A.checklist_id\n")
					.append(";\n")
					.toString();
			
			logger.debug("sql:\n" + sql);
			ResultSet rs = stmt.executeQuery(sql);
			
			List<ChecklistAlarm> clAlarm = new ArrayList<ChecklistAlarm>();
			while(rs.next()) {
				ChecklistAlarm cl = extractFromResultSet(rs);
				clAlarm.add(cl);
			}
			return clAlarm;
			
		} catch (SQLException ex) {
			ex.printStackTrace();
		}
		
		return null;
	}
	
	private ChecklistAlarm extractFromResultSet(ResultSet rs) throws SQLException {
	    ChecklistAlarm clAlarm = new ChecklistAlarm();
	    clAlarm.setChecklistId(rs.getString("checklist_id"));
	    clAlarm.setChecklistName(rs.getString("checklist_name"));
	    clAlarm.setRevisionNo(rs.getInt("revision_no"));
	    clAlarm.setCheckInterVal(rs.getString("check_interval"));
	    clAlarm.setLatestCheckDate(rs.getString("latest_check_date"));
	    System.out.println("extract:"+ clAlarm);
	    return clAlarm;
	}
}
