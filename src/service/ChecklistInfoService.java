package service;

import java.sql.Connection;

import org.apache.log4j.Logger;

import dao.ChecklistInfoDao;
import mes.frame.database.JDBCConnectionPool;
import model.ChecklistInfo;

public class ChecklistInfoService {
	private ChecklistInfoDao clDao;
	private String bizNo;
	private Connection conn;
	
	static final Logger logger = Logger.getLogger(ChecklistInfoService.class.getName());
	
	public ChecklistInfoService(ChecklistInfoDao clDao, String bizNo) {
		this.clDao = clDao;
		this.bizNo = bizNo;
	}
	
	public ChecklistInfo select(String checklistId) {
		ChecklistInfo clInfo = null;
		
		try {
			conn = JDBCConnectionPool.getTenantDB(bizNo);
			clInfo = clDao.select(conn, checklistId);
		} catch(Exception e) {
			logger.error(e.getMessage());
		} finally {
		    try { conn.close(); } catch (Exception e) { /* Ignored */ }
		}
		
		return clInfo;
	}
}
