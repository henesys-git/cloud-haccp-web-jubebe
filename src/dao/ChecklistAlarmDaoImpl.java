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
import mes.model.ChecklistSign;

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
					.append("        DATE_FORMAT(TIMEDIFF(SYSDATE(), A.latest_check_date), '%H') AS time_diff, \n")
					.append("        YEAR(A.latest_check_date) AS alarm_year,\n")
					.append("        MONTH(A.latest_check_date) AS alarm_month,\n")
					.append("        DAY(A.latest_check_date) AS alarm_day,\n")
					.append("        HOUR(A.latest_check_date) AS alarm_hour \n")
					.append("FROM	\n")
					.append("        checklist_alarm A\n")
					.append("INNER JOIN checklist_info B\n")
					.append("ON A.checklist_id = B.checklist_id \n")
					.append("WHERE A.tenant_id = '" + JDBCConnectionPool.getTenantId(conn) + "'\n")
					.append("AND CAST(A.check_interval AS INT) < CAST(DATE_FORMAT(TIMEDIFF(SYSDATE(), A.latest_check_date), '%H') AS INT)\n")
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
	
	public List<ChecklistSign> select2(Connection conn) {
		try {
			Statement stmt = conn.createStatement();
			
			String sql = new StringBuilder()
					.append("SELECT\n")
					.append("        A.checklist_id,\n")
					.append("        B.checklist_name,\n")
					.append("        A.sign_writer,\n")
					.append("        A.sign_checker,\n")
					.append("        A.sign_approver \n")
					.append("FROM	\n")
					.append("        checklist_data A\n")
					.append("INNER JOIN checklist_info B\n")
					.append("ON A.checklist_id = B.checklist_id \n")
					.append("WHERE A.tenant_id = '" + JDBCConnectionPool.getTenantId(conn) + "'\n")
					.append("AND A.sign_writer IS NULL OR A.sign_checker IS NULL OR A.sign_approver IS NULL \n")
					.append("ORDER BY A.checklist_id ASC, A.seq_no DESC\n")
					.append(";\n")
					.toString();
			
			logger.debug("sql:\n" + sql);
			ResultSet rs = stmt.executeQuery(sql);
			
			List<ChecklistSign> clSign = new ArrayList<ChecklistSign>();
			while(rs.next()) {
				ChecklistSign cl = extractFromResultSet2(rs);
				clSign.add(cl);
			}
			return clSign;
			
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
	    clAlarm.setLatestCheckDate(rs.getString("time_diff"));
	    clAlarm.setAlarmYear(rs.getString("alarm_year"));
	    clAlarm.setAlarmMonth(rs.getString("alarm_month"));
	    clAlarm.setAlarmDay(rs.getString("alarm_day"));
	    clAlarm.setAlarmHour(rs.getString("alarm_hour"));
	    System.out.println("extract:"+ clAlarm);
	    return clAlarm;
	}
	
	private ChecklistSign extractFromResultSet2(ResultSet rs) throws SQLException {
	    ChecklistSign clSign = new ChecklistSign();
	    clSign.setChecklistId(rs.getString("checklist_id"));
	    clSign.setChecklistName(rs.getString("checklist_name"));
	    clSign.setSignWriter(rs.getString("sign_writer"));
	    clSign.setSignChecker(rs.getString("sign_checker"));
	    clSign.setSignApprover(rs.getString("sign_approver"));
	    System.out.println("extract:"+ clSign);
	    return clSign;
	}
}
