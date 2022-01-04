package mes.service;

import java.sql.Connection;

import mes.dao.UserDao;
import mes.frame.database.JDBCConnectionPool;
import mes.frame.util.PasswordHash;
import mes.model.User;

public class LoginService {
	private UserDao userDao;
	
	public LoginService(UserDao userDao) {
		this.userDao = userDao;
	}
	
	public User checkPassword(String userId, String password) {
		Connection conn = JDBCConnectionPool.getConnection();
		
		User user = userDao.getUserById(conn, userId);

		String hashedPassword = PasswordHash.hashPassword(password);
		
		if(user.getPassword().equals(password)) {
			return user;
		} else {
			return null;
		}
	}
}
