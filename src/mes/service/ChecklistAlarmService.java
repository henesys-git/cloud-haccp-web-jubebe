package mes.service;

import java.sql.Connection;
import java.util.List;

import dao.ChecklistAlarmDao;
import mes.frame.database.JDBCConnectionPool;
import mes.model.ChecklistAlarm;
import mes.model.ChecklistSign;

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
	
	public List<ChecklistSign> select2() {
		Connection conn = JDBCConnectionPool.getTenantDB(bizNo);
		List<ChecklistSign> clSign = clDao.select2(conn);
		return clSign;
	}
	
}
