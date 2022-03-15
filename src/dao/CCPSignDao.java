package dao;

import java.sql.Connection;

import model.CCPSign;

public interface CCPSignDao {
	public CCPSign getCCPSignByDateAndProcessCode(Connection conn, String date, String processCode);
	public boolean delete(Connection conn, String date, String processCode);
	public boolean sign(Connection conn, CCPSign ccpSign);
}