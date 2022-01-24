package mes.service;

import java.sql.Connection;

import dao.ChecklistDataDao;
import mes.frame.database.JDBCConnectionPool;
import mes.model.ChecklistData;

public class ChecklistDataService {
	private ChecklistDataDao clDao;
	private String bizNo;
	
	public ChecklistDataService(ChecklistDataDao clDao, String bizNo) {
		this.clDao = clDao;
		this.bizNo = bizNo;
	}
	
	public int insert(ChecklistData clData) {
		Connection conn = JDBCConnectionPool.getTenantDB(bizNo);
		int result = clDao.insert(conn, clData);
		return result;
	}
	
	public ChecklistData select(String checklistId, int seqNo) {
		Connection conn = JDBCConnectionPool.getTenantDB(bizNo);
		ChecklistData clData = clDao.select(conn, checklistId, seqNo);
		return clData;
	}
}
