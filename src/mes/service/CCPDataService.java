package mes.service;

import java.sql.Connection;
import java.util.List;

import mes.dao.CCPDataDao;
import mes.frame.database.JDBCConnectionPool;
import mes.model.CCPData;
import viewmodel.CCPDataDetailViewModel;
import viewmodel.CCPDataHeadViewModel;

public class CCPDataService {

	private CCPDataDao ccpDataDao;
	private String bizNo;
	
	public CCPDataService(CCPDataDao ccpDataDao, String bizNo) {
		this.ccpDataDao = ccpDataDao;
		this.bizNo = bizNo;
	}
	
	public List<CCPData> getCCPData(String type, String startDate, String endDate) {
		Connection conn = JDBCConnectionPool.getTenantDB(bizNo);
		
		List<CCPData> ccpDataList = ccpDataDao.getAllCCPData(conn, type, startDate, endDate);
		
		return ccpDataList;
	}
	
	public List<CCPDataHeadViewModel> getCCPDataHeadViewModels(String type, String startDate, String endDate) {
		Connection conn = JDBCConnectionPool.getTenantDB(bizNo);
		
		List<CCPDataHeadViewModel> cvmList = ccpDataDao.getAllCCPDataHeadViewModel(conn, type, startDate, endDate);
		
		return cvmList;
	}

	public List<CCPDataDetailViewModel> getCCPDataDetailViewModels(String sensorKey) {
		Connection conn = JDBCConnectionPool.getTenantDB(bizNo);
		
		List<CCPDataDetailViewModel> cvmList = ccpDataDao.getAllCCPDataDetailViewModel(conn, sensorKey);
		
		return cvmList;
	}
	
	public boolean fixLimitOut(String sensorKey, String createTime, String improvementCode) {
		Connection conn = JDBCConnectionPool.getTenantDB(bizNo);
		
		boolean fixed = ccpDataDao.fixLimitOut(conn, sensorKey, createTime, improvementCode);
		
		return fixed;
	}
}
