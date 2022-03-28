package service;

import java.sql.Connection;
import java.util.List;

import org.apache.log4j.Logger;

import dao.CommonCodeDao;
import mes.frame.database.JDBCConnectionPool;
import model.CommonCode;

public class CommonCodeService {

	private CommonCodeDao commonCodeDao;
	private String bizNo;
	private Connection conn;
	
	static final Logger logger = Logger.getLogger(CommonCodeService.class.getName());

	public CommonCodeService(CommonCodeDao commonCodeDao, String bizNo) {
		this.commonCodeDao = commonCodeDao;
		this.bizNo = bizNo;
	}
	
	public List<CommonCode> getAllCodes() {
		List<CommonCode> commonCodeList = null;
		
		try {
			conn = JDBCConnectionPool.getTenantDB(bizNo);
			commonCodeList = commonCodeDao.getAllCodes(conn);
		} catch(Exception e) {
			logger.error(e.getMessage());
		} finally {
		    try { conn.close(); } catch (Exception e) { /* Ignored */ }
		}
		
		return commonCodeList;
	}
	
	public CommonCode getCodeById(String codeId) {
		CommonCode commonCode = null;
		
		try {
			conn = JDBCConnectionPool.getTenantDB(bizNo);
			commonCode = commonCodeDao.getCommonCode(conn, codeId);
		} catch(Exception e) {
			logger.error(e.getMessage());
		} finally {
		    try { conn.close(); } catch (Exception e) { /* Ignored */ }
		}
		
		return commonCode;
	}
	
	public boolean insert(CommonCode commonCode) {
		try {
			conn = JDBCConnectionPool.getTenantDB(bizNo);
			return commonCodeDao.insert(conn, commonCode);
		} catch(Exception e) {
			logger.error(e.getMessage());
		} finally {
		    try { conn.close(); } catch (Exception e) { /* Ignored */ }
		}
		
		return false;
	}
	
	public boolean update(CommonCode commonCode) {
		try {
			conn = JDBCConnectionPool.getTenantDB(bizNo);
			return commonCodeDao.update(conn, commonCode);
		} catch(Exception e) {
			logger.error(e.getMessage());
		} finally {
		    try { conn.close(); } catch (Exception e) { /* Ignored */ }
		}
		
		return false;
	}
	
	public boolean delete(String codeId) {
		try {
			conn = JDBCConnectionPool.getTenantDB(bizNo);
			return commonCodeDao.delete(conn, codeId);
		} catch(Exception e) {
			logger.error(e.getMessage());
		} finally {
		    try { conn.close(); } catch (Exception e) { /* Ignored */ }
		}
		
		return false;
	}
}
