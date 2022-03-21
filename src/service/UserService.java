package service;

import java.sql.Connection;
import java.util.List;

import org.apache.log4j.Logger;

import dao.UserDao;
import mes.frame.database.JDBCConnectionPool;
import model.User;

public class UserService {

	private UserDao userDao;
	private String bizNo;
	private Connection conn;
	
	static final Logger logger = Logger.getLogger(UserService.class.getName());

	public UserService(UserDao userDao, String bizNo) {
		this.userDao = userDao;
		this.bizNo = bizNo;
	}
	
	public List<User> getAllUsers() {
		logger.debug("method start");
		
		List<User> userList = null;
		
		try {
			conn = JDBCConnectionPool.getTenantDB(bizNo);
			userList = userDao.getAllUsers(conn);
		} catch(Exception e) {
			logger.error(e.getMessage());
		} finally {
		    try { conn.close(); } catch (Exception e) { /* Ignored */ }
		}
		
		return userList;
	}
	
	public User getUser(String id) {
		User user = null;
		
		try {
			conn = JDBCConnectionPool.getTenantDB(bizNo);
			user = userDao.getUser(conn, id);
		} catch(Exception e) {
			logger.error(e.getMessage());
		} finally {
		    try { conn.close(); } catch (Exception e) { /* Ignored */ }
		}
		
		return user;
	}
	
	public boolean insert(User user) {
		try {
			conn = JDBCConnectionPool.getTenantDB(bizNo);
			return userDao.insert(conn, user);
		} catch(Exception e) {
			logger.error(e.getMessage());
		} finally {
		    try { conn.close(); } catch (Exception e) { /* Ignored */ }
		}
		
		return false;
	}
	
	public boolean updateAuthority(User user) {
		try {
			conn = JDBCConnectionPool.getTenantDB(bizNo);
			return userDao.updateAuthority(conn, user);
		} catch(Exception e) {
			logger.error(e.getMessage());
		} finally {
		    try { conn.close(); } catch (Exception e) { /* Ignored */ }
		}
		
		return false;
	}
	
	public boolean delete(String userId) {
		try {
			conn = JDBCConnectionPool.getTenantDB(bizNo);
			return userDao.delete(conn, userId);
		} catch(Exception e) {
			logger.error(e.getMessage());
		} finally {
		    try { conn.close(); } catch (Exception e) { /* Ignored */ }
		}
		
		return false;
	}
	
	public User getOverlapId(String id) {
		User user = null;
		
		try {
			conn = JDBCConnectionPool.getTenantDB(bizNo);
			user = userDao.getOverlapId(conn, id);
		} catch(Exception e) {
			logger.error(e.getMessage());
		} finally {
		    try { conn.close(); } catch (Exception e) { /* Ignored */ }
		}
		
		return user;
	}
}
