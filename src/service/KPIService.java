package service;

import java.sql.Connection;
import java.util.List;

import org.apache.log4j.Logger;

import dao.CCPDataDao;
import mes.frame.database.JDBCConnectionPool;
import viewmodel.KPIProductionViewModel;
import viewmodel.KPIQualityViewModel;

public class KPIService {

	private CCPDataDao ccpDataDao;
	private String tenantId;
	private Connection conn;
	
	static final Logger logger = Logger.getLogger(KPIService.class.getName());
	
	public KPIService(CCPDataDao ccpDataDao, String tenantId) {
		this.ccpDataDao = ccpDataDao;
		this.tenantId = tenantId;
	}
	
	public List<KPIProductionViewModel> getKPIProductionViewModels(
			String processCode,
			String startDate, 
			String endDate) {
		
		List<KPIProductionViewModel> list = null;
		
		try {
			conn = JDBCConnectionPool.getTenantDB(tenantId);
			list = ccpDataDao.getKPIProduction(conn, processCode, startDate, endDate);
		} catch(Exception e) {
			logger.error(e.getMessage());
		} finally {
		    try { conn.close(); } catch (Exception e) { /* Ignored */ }
		}
		
		return list;
	}
	
	public List<KPIQualityViewModel> getKPIQualityViewModels(
			String processCode,
			String startDate, 
			String endDate,
			String sensorId) {
		
		List<KPIQualityViewModel> list = null;
		
		try {
			conn = JDBCConnectionPool.getTenantDB(tenantId);
			list = ccpDataDao.getKPIQuality(conn, processCode, startDate, endDate, sensorId);
		} catch(Exception e) {
			logger.error(e.getMessage());
		} finally {
		    try { conn.close(); } catch (Exception e) { /* Ignored */ }
		}
		
		return list;
	}
	
}
