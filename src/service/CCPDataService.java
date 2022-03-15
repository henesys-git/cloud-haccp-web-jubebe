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
	
	public List<CCPDataHeadViewModel> getCCPDataHeadViewModels(String type, String startDate, String endDate, String processCode) {
		List<CCPDataHeadViewModel> cvmList = null;
		
		try {
			conn = JDBCConnectionPool.getTenantDB(tenantId);
			cvmList = ccpDataDao.getAllCCPDataHeadViewModel(conn, type, startDate, endDate, processCode);
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
}
