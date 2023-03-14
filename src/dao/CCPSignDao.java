package dao;

import java.sql.Connection;
import java.util.List;

import model.CCPSign;

public interface CCPSignDao {
	public List<CCPSign> getCCPSignByDateAndProcessCode(Connection conn, String date, String processCode);
	public boolean delete(Connection conn, String date, String processCode);
	public boolean deletePeriod(Connection conn, String date, String date2, String processCode);
	public boolean sign(Connection conn, CCPSign ccpSign);
}