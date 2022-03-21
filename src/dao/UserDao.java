package dao;

import java.sql.Connection;
import java.util.List;

import model.User;

public interface UserDao {
	public List<User> getAllUsers(Connection conn);
	public User getUser(Connection conn, String id);
	public boolean insert(Connection conn, User user);
	public boolean updateAuthority(Connection conn, User user);
	public boolean delete(Connection conn, String id);
	public User getOverlapId(Connection conn, String id);
}