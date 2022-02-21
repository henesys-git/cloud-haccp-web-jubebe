package service;

import java.sql.Connection;
import java.util.List;

import org.apache.log4j.Logger;

import dao.CCPDataDao;
import mes.frame.database.JDBCConnectionPool;
import model.CCPData;
import viewmodel.CCPDataDetailViewModel;
import viewmodel.CCPDataHeadViewModel;

public class CCPDataService {

	private CCPDataDao ccpDataDao;
	private String bizNo;
	private Connection conn;
	
	static final Logger logger = Logger.getLogger(CCPDataService.class.getName());
	
	public CCPDataService(CCPDataDao ccpDataDao, String bizNo) {
		this.ccpDataDao = ccpDataDao;
		this.bizNo = bizNo;
	}
	
	public List<CCPData> getCCPData(String type, String startDate, String endDate) {
		List<CCPData> ccpDataList = null;
		
		try {
			conn = JDBCConnectionPool.getTenantDB(bizNo);
			ccpDataList = ccpDataDao.getAllCCPData(conn, type, startDate, endDate);
		} catch(Exception e) {
			logger.error(e.getMessage());
		} finally {
		    try { conn.close(); } catch (Exception e) { /* Ignored */ }
		}
		
		return ccpDataList;
	}
	
	public List<CCPDataHeadViewModel> getCCPDataHeadViewModels(String type, String startDate, String endDate) {
		List<CCPDataHeadViewModel> cvmList = null;
		
		try {
			conn = JDBCConnectionPool.getTenantDB(bizNo);
			cvmList = ccpDataDao.getAllCCPDataHeadViewModel(conn, type, startDate, endDate);
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
			Connection conn = JDBCConnectionPool.getTenantDB(bizNo);
			cvmList = ccpDataDao.getAllCCPDataDetailViewModel(conn, sensorKey);
		} catch(Exception e) {
			logger.error(e.getMessage());
		} finally {
		    try { conn.close(); } catch (Exception e) { /* Ignored */ }
		}
		
		return cvmList;
	}
	
	public boolean fixLimitOut(String sensorKey, String createTime, String improvementCode) {
		boolean fixed = false;
		
		try {
			conn = JDBCConnectionPool.getTenantDB(bizNo);
			fixed = ccpDataDao.fixLimitOut(conn, sensorKey, createTime, improvementCode);
		} catch(Exception e) {
			logger.error(e.getMessage());
		} finally {
		    try { conn.close(); } catch (Exception e) { /* Ignored */ }
		}
		
		return fixed;
	}
}
