package dao;

import java.sql.Connection;
import java.util.List;

import mes.model.ChecklistAlarm;

public interface ChecklistAlarmDao {
	public List<ChecklistAlarm> select(Connection conn);
}
