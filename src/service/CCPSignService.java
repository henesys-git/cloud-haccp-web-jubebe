package service;

import java.sql.Connection;
import java.util.List;

import org.apache.log4j.Logger;

import dao.CCPSignDao;
import dao.UserDaoImpl;
import mes.frame.database.JDBCConnectionPool;
import model.CCPSign;
import model.User;
import viewmodel.CCPTestDataViewModel;

public class CCPSignService {

	private CCPSignDao ccpSignDao;
	private String tenantId;
	private Connection conn;
	private CCPSign ccpSign = null;
	
	static final Logger logger = Logger.getLogger(CCPSignService.class.getName());
	
	public CCPSignService(CCPSignDao ccpSignDao, String tenantId) {
		this.ccpSignDao = ccpSignDao;
		this.tenantId = tenantId;
	}
	
	public CCPSignService(CCPSignDao ccpSignDao, String tenantId, Connection conn) {
		this.ccpSignDao = ccpSignDao;
		this.tenantId = tenantId;
		this.conn = conn;
	}
	
	public List<CCPSign> getCCPSignByDateAndProcessCode(String date, String processCode) {
		List<CCPSign> list = null;
		try {
			conn = JDBCConnectionPool.getTenantDB(tenantId);
			list = ccpSignDao.getCCPSignByDateAndProcessCode(conn, date, processCode);
		} catch(Exception e) {
			logger.error(e.getMessage());
		} finally {
		    try { conn.close(); } catch (Exception e) { /* Ignored */ }
		}
		
		return list;
	}
	
	public boolean delete(String date, String processCode) {
		try {
			conn = JDBCConnectionPool.getTenantDB(tenantId);
			return ccpSignDao.delete(conn, date, processCode);
		} catch(Exception e) {
			logger.error(e.getMessage());
		} finally {
		    try { conn.close(); } catch (Exception e) { /* Ignored */ }
		}

		return false;
	}
	
	public String sign(CCPSign ccpSign) {
		try {
			conn = JDBCConnectionPool.getTenantDB(tenantId);
			Boolean inserted = ccpSignDao.sign(conn, ccpSign);
			
			if(inserted) {
				UserService userService = new UserService(new UserDaoImpl(), tenantId);
				User user = userService.getUser(ccpSign.getCheckerId());
				return user.getUserName();
			}
		} catch(Exception e) {
			logger.error(e.getMessage());
		} finally {
		    try { conn.close(); } catch (Exception e) { /* Ignored */ }
		}

		return null;
	}
	
}
