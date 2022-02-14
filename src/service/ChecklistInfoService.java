package service;

import java.sql.Connection;

import dao.ChecklistInfoDao;
import mes.frame.database.JDBCConnectionPool;
import model.ChecklistInfo;

public class ChecklistInfoService {
	private ChecklistInfoDao clDao;
	private String bizNo;
	
	public ChecklistInfoService(ChecklistInfoDao clDao, String bizNo) {
		this.clDao = clDao;
		this.bizNo = bizNo;
	}
	
//	public int insert(ChecklistData clData) {
//		Connection conn = JDBCConnectionPool.getTenantDB(bizNo);
//		int result = clDao.insert(conn, clData);
//		return result;
//	}
	
	public ChecklistInfo select(String checklistId) {
		Connection conn = JDBCConnectionPool.getTenantDB(bizNo);
		ChecklistInfo clInfo = clDao.select(conn, checklistId);
		return clInfo;
	}
	
//	public List<ChecklistData> selectAll(String checklistId) {
//		Connection conn = JDBCConnectionPool.getTenantDB(bizNo);
//		List<ChecklistData> list = clDao.selectAll(conn, checklistId);
//		return list;
//	}
}
