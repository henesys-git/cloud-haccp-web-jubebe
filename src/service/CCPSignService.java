package service;

import java.sql.Connection;

import org.apache.log4j.Logger;

import dao.CCPSignDao;
import dao.UserDaoImpl;
import mes.frame.database.JDBCConnectionPool;
import model.CCPSign;
import model.User;

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
	
	public CCPSign getCCPSignByDateAndProcessCode(String date, String processCode) {
		try {
			conn = JDBCConnectionPool.getTenantDB(tenantId);
			ccpSign = ccpSignDao.getCCPSignByDateAndProcessCode(conn, date, processCode);
		} catch(Exception e) {
			logger.error(e.getMessage());
		} finally {
		    try { conn.close(); } catch (Exception e) { /* Ignored */ }
		}
		
		return ccpSign;
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
