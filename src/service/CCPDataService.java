package service;

import java.sql.Connection;
import java.util.List;

import org.apache.log4j.Logger;

import dao.CCPDataDao;
import dao.CCPSignDao;
import mes.frame.database.JDBCConnectionPool;
import model.CCPData;
import viewmodel.CCPDataDetailViewModel;
import viewmodel.CCPDataHeadViewModel;
import viewmodel.CCPDataHeatingMonitoringGraphModel;
import viewmodel.CCPDataHeatingMonitoringModel;
import viewmodel.CCPDataMonitoringModel;
import viewmodel.CCPDataStatisticModel;
import viewmodel.CCPTestDataHeadViewModel;
import viewmodel.CCPTestDataViewModel;

public class CCPDataService {

	private CCPDataDao ccpDataDao;
	private CCPSignDao ccpSignDao;
	private String tenantId;
	private Connection conn;
	
	static final Logger logger = Logger.getLogger(CCPDataService.class.getName());
	
	public CCPDataService(CCPDataDao ccpDataDao, String tenantId) {
		this.ccpDataDao = ccpDataDao;
		this.tenantId = tenantId;
	}

	public CCPDataService(CCPDataDao ccpDataDao, CCPSignDao ccpSignDao, String tenantId) {
		this.ccpDataDao = ccpDataDao;
		this.ccpSignDao = ccpSignDao;
		this.tenantId = tenantId;
	}
	
	public List<CCPData> getCCPData(String type, String startDate, String endDate) {
		List<CCPData> ccpDataList = null;
		
		try {
			conn = JDBCConnectionPool.getTenantDB(tenantId);
			ccpDataList = ccpDataDao.getAllCCPData(conn, type, startDate, endDate);
		} catch(Exception e) {
			logger.error(e.getMessage());
		} finally {
		    try { conn.close(); } catch (Exception e) { /* Ignored */ }
		}
		
		return ccpDataList;
	}
	
	public List<CCPDataHeadViewModel> getCCPDataHeadViewModels(
			String sensorId, 
			String startDate, 
			String endDate, 
			String processCode) {
		
		List<CCPDataHeadViewModel> cvmList = null;
		
		try {
			conn = JDBCConnectionPool.getTenantDB(tenantId);
			cvmList = ccpDataDao.getAllCCPDataHeadViewModel(conn, sensorId, startDate, endDate, processCode);
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
	
	public boolean fixLimitOut(String sensorKey, String createTime, String improvementAction, String date, String processCode) {
		try {
			conn = JDBCConnectionPool.getTenantDB(tenantId);
			conn.setAutoCommit(false);
			
			boolean fixed = ccpDataDao.fixLimitOut(conn, sensorKey, createTime, improvementAction);
			
			logger.debug("공정코드:");
			logger.debug(processCode);
			boolean deleted = ccpSignDao.delete(conn, date, processCode);
			
			if(fixed && deleted) {
				conn.commit();
				return true;
			} else {
				conn.rollback();
				return false;
			}
		} catch(Exception e) {
			logger.error(e.getMessage());
		} finally {
		    try { conn.close(); } catch (Exception e) { /* Ignored */ }
		}
		
		return false;
	}
	
	public List<CCPDataStatisticModel> getCCPDataStatisticModel(String toDate, String sensorId) {
		List<CCPDataStatisticModel> cvmList = null;
		
		try {
			Connection conn = JDBCConnectionPool.getTenantDB(tenantId);
			cvmList = ccpDataDao.getCCPDataStatisticModel(conn, toDate, sensorId);
		} catch(Exception e) {
			logger.error(e.getMessage());
		} finally {
		    try { conn.close(); } catch (Exception e) { /* Ignored */ }
		}
		
		return cvmList;
	}
	
	public List<CCPDataMonitoringModel> getCCPDataMonitoringModel(String toDate, String processCode) {
		List<CCPDataMonitoringModel> cvmList = null;
		
		try {
			Connection conn = JDBCConnectionPool.getTenantDB(tenantId);
			cvmList = ccpDataDao.getCCPDataMonitoringModel(conn, toDate, processCode);
		} catch(Exception e) {
			logger.error(e.getMessage());
		} finally {
		    try { conn.close(); } catch (Exception e) { /* Ignored */ }
		}
		
		return cvmList;
	}

	public List<CCPDataDetailViewModel> getMetalBreakAwayList(String sensorKey, String sensorId, String processCode, String toDate, String fromDate) {
		List<CCPDataDetailViewModel> cvmList = null;

		try {
			conn = JDBCConnectionPool.getTenantDB(tenantId);
			cvmList = ccpDataDao.getMetalBreakAwayList(conn, sensorKey, sensorId, processCode, toDate, fromDate);
		} catch(Exception e) {
			logger.error(e.getMessage());
		} finally {
		    try { conn.close(); } catch (Exception e) { /* Ignored */ }
		}
		
		return cvmList;
	}

	public List<CCPTestDataHeadViewModel> getCCPTestDataHead(String startDate, String endDate, String processCode) {
		List<CCPTestDataHeadViewModel> list = null;
		
		try {
			Connection conn = JDBCConnectionPool.getTenantDB(tenantId);
			list = ccpDataDao.getCCPTestDataHead(conn, startDate, endDate, processCode);
		} catch(Exception e) {
			logger.error(e.getMessage());
		} finally {
			try { conn.close(); } catch (Exception e) { /* Ignored */ }
		}
		
		return list;
	}

	public List<CCPTestDataViewModel> getCCPTestData(String date, String processCode, String sensorId) {
		List<CCPTestDataViewModel> list = null;
		
		try {
			Connection conn = JDBCConnectionPool.getTenantDB(tenantId);
			list = ccpDataDao.getCCPTestData(conn, date, processCode, sensorId);
		} catch(Exception e) {
			logger.error(e.getMessage());
		} finally {
		    try { conn.close(); } catch (Exception e) { /* Ignored */ }
		}
		
		return list;
	}
	
	public List<CCPDataHeatingMonitoringModel> getCCPHeatingMonitoringModels(
			String sensorId, 
			String startDate, 
			String endDate, 
			String processCode) {
		
		List<CCPDataHeatingMonitoringModel> cvmList = null;
		
		try {
			conn = JDBCConnectionPool.getTenantDB(tenantId);
			cvmList = ccpDataDao.getAllCCPDataHeatingMonitoringModel(conn, sensorId, startDate, endDate, processCode);
		} catch(Exception e) {
			logger.error(e.getMessage());
		} finally {
		    try { conn.close(); } catch (Exception e) { /* Ignored */ }
		}
		
		return cvmList;
	}
	
	public List<CCPDataHeatingMonitoringGraphModel> getCCPHeatingMonitoringGraphModels(
			String sensorKey,
			String sensorId) {
		
		List<CCPDataHeatingMonitoringGraphModel> cvmList = null;
		
		try {
			conn = JDBCConnectionPool.getTenantDB(tenantId);
			cvmList = ccpDataDao.getAllCCPDataHeatingMonitoringGraphModel(conn, sensorKey, sensorId);
		} catch(Exception e) {
			logger.error(e.getMessage());
		} finally {
		    try { conn.close(); } catch (Exception e) { /* Ignored */ }
		}
		
		return cvmList;
	}
	
	public List<CCPDataHeatingMonitoringGraphModel> getCCPHeatingMonitoringGraphModels2(
			String sensorKey,
			String sensorId) {
		
		List<CCPDataHeatingMonitoringGraphModel> cvmList = null;
		
		try {
			conn = JDBCConnectionPool.getTenantDB(tenantId);
			cvmList = ccpDataDao.getAllCCPDataHeatingMonitoringGraphModel(conn, sensorKey, sensorId);
		} catch(Exception e) {
			logger.error(e.getMessage());
		} finally {
		    try { conn.close(); } catch (Exception e) { /* Ignored */ }
		}
		
		return cvmList;
	}
	
}
