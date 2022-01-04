package mes.dao;

import java.sql.Connection;

import mes.model.User;

public interface UserDao {
	public User getUserById(Connection conn, String userId);
}
