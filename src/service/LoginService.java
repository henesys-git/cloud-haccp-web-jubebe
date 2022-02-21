package service;

import java.sql.Connection;

import org.apache.log4j.Logger;

import dao.UserDao;
import mes.frame.database.JDBCConnectionPool;
import mes.frame.util.PasswordHash;
import model.User;

public class LoginService {
	private UserDao userDao;
	private Connection conn;
	
	static final Logger logger = Logger.getLogger(LoginService.class.getName());

	public LoginService(UserDao userDao) {
		this.userDao = userDao;
	}
	
	public User checkPassword(String bizNo, String userId, String password) {
		User user = null;
		
		try {
			conn = JDBCConnectionPool.getTenantDB(bizNo);
			user = userDao.getUserById(conn, userId);
		} catch(Exception e) {
			logger.error(e.getMessage());
		} finally {
		    try { conn.close(); } catch (Exception e) { /* Ignored */ }
		}

		String hashedPassword = PasswordHash.hashPassword(password);
		
		if(user.getPassword().equals(password)) {
			return user;
		} else {
			return null;
		}
	}
}
