package shm.service;

import java.sql.Connection;
import java.util.List;

import org.apache.log4j.Logger;

import shm.dao.CCPDataDao;
import mes.frame.database.JDBCConnectionPool;
import shm.viewmodel.CCPDataDetailViewModel;
import shm.viewmodel.CCPDataHeadViewModel;

public class CCPDataService {

	private CCPDataDao ccpDataDao;
	private String tenantId;
	private Connection conn;
	
	static final Logger logger = Logger.getLogger(CCPDataService.class.getName());
	
	public CCPDataService(CCPDataDao ccpDataDao, String tenantId) {
		this.ccpDataDao = ccpDataDao;
		this.tenantId = tenantId;
	}
	
	public List<CCPDataHeadViewModel> getCCPDataHeadViewModels(
			String sensorId, 
			String startDate, 
			String endDate, 
			String testYN) {
		
		List<CCPDataHeadViewModel> cvmList = null;
		
		try {
			conn = JDBCConnectionPool.getTenantDB(tenantId);
			cvmList = ccpDataDao.getAllCCPDataHeadViewModel(conn, sensorId, startDate, endDate, testYN);
		} catch(Exception e) {
			logger.error(e.getMessage());
		} finally {
		    try { conn.close(); } catch (Exception e) { /* Ignored */ }
		}
		
		return cvmList;
	}

	public List<CCPDataDetailViewModel> getCCPDataDetailViewModels(String sensorKey) {
		List<CCPDataDetailViewModel> cvmList = null;
		
		try {
			Connection conn = JDBCConnectionPool.getTenantDB(tenantId);
			cvmList = ccpDataDao.getAllCCPDataDetailViewModel(conn, sensorKey);
		} catch(Exception e) {
			logger.error(e.getMessage());
		} finally {
		    try { conn.close(); } catch (Exception e) { /* Ignored */ }
		}
		
		return cvmList;
	}
}
