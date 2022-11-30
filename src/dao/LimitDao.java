package dao;

import java.sql.Connection;
import java.util.List;

import model.Limit;

public interface LimitDao {
	public List<Limit> getAllLimit(Connection conn);
	public List<Limit> getLimitType1(Connection conn, String type);
	public List<Limit> getLimitType2(Connection conn, String type);
	public Limit getLimit(Connection conn, String eventCode, String objectId);
	public boolean insert(Connection conn, Limit limit);
	public boolean update(Connection conn, Limit limit);
	public boolean delete(Connection conn, String eventCode, String objectId);
}