package dao;

import java.sql.Connection;
import java.util.List;

import model.CCPLimit;

public interface CCPLimitDao {
	public List<CCPLimit> getAllCCPLimit(Connection conn);
	public CCPLimit getCCPLimit(Connection conn, String eventCode, String productId);
}