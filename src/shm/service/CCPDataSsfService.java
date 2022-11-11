package shm.service;

import java.sql.Connection;
import java.util.List;

import org.apache.log4j.Logger;

import shm.dao.SsfKPIDao;
import mes.frame.database.JDBCConnectionPool;
import shm.viewmodel.SsfKpiLevel2;

public class CCPDataSsfService {

	private SsfKPIDao ssfKpiDao;
	private String tenantId;
	private Connection conn;
	
	static final Logger logger = Logger.getLogger(CCPDataSsfService.class.getName());
	
	public CCPDataSsfService(SsfKPIDao ssfKpiDao, String tenantId) {
		this.ssfKpiDao = ssfKpiDao;
		this.tenantId = tenantId;
	}
	
	public List<SsfKpiLevel2> getCCPDataViewModels() {
		
		List<SsfKpiLevel2> list = null;
		
		try {
			conn = JDBCConnectionPool.getTenantDB(tenantId);
			list = ssfKpiDao.getKPIData(conn);
		} catch(Exception e) {
			logger.error(e.getMessage());
		} finally {
		    try { conn.close(); } catch (Exception e) { /* Ignored */ }
		}
		
		return list;
	}
}
