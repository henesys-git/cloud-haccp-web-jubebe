package dao;

import java.sql.Connection;
import java.util.List;

import mes.model.ChecklistAlarm;
import mes.model.ChecklistSign;


public interface ChecklistAlarmDao {
	public List<ChecklistAlarm> select(Connection conn);
	public List<ChecklistSign> select2(Connection conn);
	public boolean alarm(Connection conn, ChecklistAlarm clAlarm);
}
