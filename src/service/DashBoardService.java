package service;

import java.sql.Connection;
import java.util.List;

import org.apache.log4j.Logger;

import dao.CCPDataDao;
import dao.DashBoardDao;
import mes.frame.database.JDBCConnectionPool;
import model.CCPData;
import model.DashBoard;
import viewmodel.CCPDataDetailViewModel;
import viewmodel.CCPDataHeadViewModel;
import viewmodel.CCPDataHeatingMonitoringGraphModel;
import viewmodel.CCPDataHeatingMonitoringModel;
import viewmodel.CCPDataMonitoringModel;
import viewmodel.CCPDataStatisticModel;
import viewmodel.CCPTestDataHeadViewModel;
import viewmodel.CCPTestDataViewModel;

public class DashBoardService {

	private DashBoardDao dashDao;
	private String tenantId;
	private Connection conn;
	
	static final Logger logger = Logger.getLogger(DashBoardService.class.getName());
	
	public DashBoardService(DashBoardDao dashDao, String tenantId) {
		this.dashDao = dashDao;
		this.tenantId = tenantId;
	}

	
	public List<DashBoard> getDashBoardData1Table() {
		List<DashBoard> dashList = null;
		
		try {
			conn = JDBCConnectionPool.getTenantDB(tenantId);
			dashList = dashDao.getDashBoardData1Table(conn);
		} catch(Exception e) {
			logger.error(e.getMessage());
		} finally {
		    try { conn.close(); } catch (Exception e) { /* Ignored */ }
		}
		
		return dashList;
	}
	
	public List<DashBoard> getDashBoardData1Graph() {
		List<DashBoard> dashList = null;
		
		try {
			conn = JDBCConnectionPool.getTenantDB(tenantId);
			dashList = dashDao.getDashBoardData1Graph(conn);
		} catch(Exception e) {
			logger.error(e.getMessage());
		} finally {
		    try { conn.close(); } catch (Exception e) { /* Ignored */ }
		}
		
		return dashList;
	}
	
	public List<DashBoard> getDashBoardData2Table() {
		List<DashBoard> dashList = null;
		
		try {
			conn = JDBCConnectionPool.getTenantDB(tenantId);
			dashList = dashDao.getDashBoardData2Table(conn);
		} catch(Exception e) {
			logger.error(e.getMessage());
		} finally {
		    try { conn.close(); } catch (Exception e) { /* Ignored */ }
		}
		
		return dashList;
	}
	
	public List<DashBoard> getDashBoardData2Graph() {
		List<DashBoard> dashList = null;
		
		try {
			conn = JDBCConnectionPool.getTenantDB(tenantId);
			dashList = dashDao.getDashBoardData2Graph(conn);
		} catch(Exception e) {
			logger.error(e.getMessage());
		} finally {
		    try { conn.close(); } catch (Exception e) { /* Ignored */ }
		}
		
		return dashList;
	}
	
	
	
}
