package dao;

import java.sql.Connection;
import java.util.List;

import model.CommonCode;

public interface CommonCodeDao {
	public List<CommonCode> getAllCodes(Connection conn);
	public CommonCode getCommonCode(Connection conn, String commonCode);
	public boolean insert(Connection conn, CommonCode commonCode);
	public boolean update(Connection conn, CommonCode commonCode);
	public boolean delete(Connection conn, String code_id);
}