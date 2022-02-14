package dao;

import java.sql.Connection;

import model.User;

public interface UserDao {
	public User getUserById(Connection conn, String userId);
}
