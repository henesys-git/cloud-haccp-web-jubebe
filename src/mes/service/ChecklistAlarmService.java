package mes.service;

import java.sql.Connection;
import java.util.List;

import dao.ChecklistAlarmDao;
import mes.frame.database.JDBCConnectionPool;
import mes.model.ChecklistAlarm;

public class ChecklistAlarmService {
	private ChecklistAlarmDao clDao;
	private String bizNo;
	
	public ChecklistAlarmService(ChecklistAlarmDao clDao, String bizNo) {
		this.clDao = clDao;
		this.bizNo = bizNo;
	}
	
	public List<ChecklistAlarm> select() {
		Connection conn = JDBCConnectionPool.getTenantDB(bizNo);
		List<ChecklistAlarm> clAlarm = clDao.select(conn);
		return clAlarm;
	}
	
}
