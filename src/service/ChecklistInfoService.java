package service;

import java.sql.Connection;
import java.util.List;

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
	
	public List<ChecklistInfo> selectAll() {
		List<ChecklistInfo> checklistInfoList = null;
		
		try {
			conn = JDBCConnectionPool.getTenantDB(bizNo);
			checklistInfoList = clDao.selectAll(conn);
		} catch(Exception e) {
			logger.error(e.getMessage());
		} finally {
		    try { conn.close(); } catch (Exception e) { /* Ignored */ }
		}
		
		return checklistInfoList;
	}
	
	public ChecklistInfo selectChecklistNo(String formClassificationCriteria, 
										   String prodCd, 
										   String sensorId) {
		ChecklistInfo clInfo = null;
		
		try {
			conn = JDBCConnectionPool.getTenantDB(bizNo);
			
			switch(formClassificationCriteria) {
			case "센서별제품그룹별":
				clInfo = clDao.selectChecklistNoByProdAndSensor(conn, prodCd, sensorId);
				break;
			case "센서별":
				clInfo = clDao.selectChecklistNoBySensor(conn, sensorId);
				break;
			// 2022 12 08 최현수
			// 현재 '제품그룹별'은 지원이 안됨
			// checklist.modal.js에서 getChecklistData 메서드에서 
			// sensor id로 process code를 가져오는데 제품그룹별로 할 시에는 sensor id를 못가져와서
			case "제품그룹별":
				clInfo = clDao.selectChecklistNoByProd(conn, prodCd);
				break;
			}
		} catch(Exception e) {
			logger.error(e.getMessage());
		} finally {
		    try { conn.close(); } catch (Exception e) { /* Ignored */ }
		}
		
		return clInfo;
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
	
	public boolean insert(ChecklistInfo clInfo) {
		try {
			conn = JDBCConnectionPool.getTenantDB(bizNo);
			return clDao.insert(conn, clInfo);
		} catch(Exception e) {
			logger.error(e.getMessage());
		} finally {
		    try { conn.close(); } catch (Exception e) { /* Ignored */ }
		}
		
		return false;
	}
	
	public boolean update(ChecklistInfo clInfo) {
		try {
			conn = JDBCConnectionPool.getTenantDB(bizNo);
			return clDao.update(conn, clInfo);
		} catch(Exception e) {
			logger.error(e.getMessage());
		} finally {
		    try { conn.close(); } catch (Exception e) { /* Ignored */ }
		}
		
		return false;
	}
	
	public boolean delete(String checklistId) {
		try {
			conn = JDBCConnectionPool.getTenantDB(bizNo);
			return clDao.delete(conn, checklistId);
		} catch(Exception e) {
			logger.error(e.getMessage());
		} finally {
		    try { conn.close(); } catch (Exception e) { /* Ignored */ }
		}
		
		return false;
	}
	
	public boolean sign(ChecklistInfo clInfo, String aa) {
		try {
			conn = JDBCConnectionPool.getTenantDB(bizNo);
			return clDao.sign(conn, clInfo, aa);
		} catch(Exception e) {
			logger.error(e.getMessage());
		} finally {
		    try { conn.close(); } catch (Exception e) { /* Ignored */ }
		}
		
		return false;
	}
	
	public String getFormClassificationCriteria(String ccpType) {
		String criteria = "";
		
		try {
			conn = JDBCConnectionPool.getTenantDB(bizNo);
			criteria = clDao.getFormClassifiicationCriteria(conn, ccpType);
		} catch(Exception e) {
			logger.error(e.getMessage());
		} finally {
		    try { conn.close(); } catch (Exception e) { /* Ignored */ }
		}
		
		return criteria;
	}
}
