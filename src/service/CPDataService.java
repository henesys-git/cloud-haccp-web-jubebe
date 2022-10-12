package service;

import java.sql.Connection;
import java.util.List;

import org.apache.log4j.Logger;

import dao.CCPDataDao;
import dao.CCPSignDao;
import dao.CPDataDao;
import mes.frame.database.JDBCConnectionPool;
import model.CCPData;
import viewmodel.CCPDataDetailViewModel;
import viewmodel.CCPDataHeadViewModel;
import viewmodel.CCPDataMonitoringModel;
import viewmodel.CCPDataStatisticModel;
import viewmodel.CCPTestDataHeadViewModel;
import viewmodel.CCPTestDataViewModel;
import viewmodel.CPDataHeadViewModel;
import viewmodel.CPDataMonitoringModel;

public class CPDataService {

	private CPDataDao ccpDataDao;
	private CCPSignDao ccpSignDao;
	private String tenantId;
	private Connection conn;
	
	static final Logger logger = Logger.getLogger(CPDataService.class.getName());
	
	public CPDataService(CPDataDao ccpDataDao, String tenantId) {
		this.ccpDataDao = ccpDataDao;
		this.tenantId = tenantId;
	}

	public CPDataService(CPDataDao ccpDataDao, CCPSignDao ccpSignDao, String tenantId) {
		this.ccpDataDao = ccpDataDao;
		this.ccpSignDao = ccpSignDao;
		this.tenantId = tenantId;
	}
	
	public List<CPDataHeadViewModel> getCCPDataHeadViewModels(
			String sensorId, 
			String startDate, 
			String endDate, 
			String processCode) {
		
		List<CPDataHeadViewModel> cvmList = null;
		
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
	
	public List<CPDataMonitoringModel> getCCPDataMonitoringModel() {
		List<CPDataMonitoringModel> cvmList = null;
		
		try {
			Connection conn = JDBCConnectionPool.getTenantDB(tenantId);
			cvmList = ccpDataDao.getCCPDataMonitoringModel(conn);
		} catch(Exception e) {
			logger.error(e.getMessage());
		} finally {
		    try { conn.close(); } catch (Exception e) { /* Ignored */ }
		}
		
		return cvmList;
	}
	
}
