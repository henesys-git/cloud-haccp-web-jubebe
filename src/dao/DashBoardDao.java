package dao;

import java.sql.Connection;
import java.util.List;

import model.CCPData;
import model.DashBoard;

public interface DashBoardDao {
	public List<DashBoard> getDashBoardData1Table(Connection conn);
	public List<DashBoard> getDashBoardData1Graph(Connection conn);
	public List<DashBoard> getDashBoardData2Table(Connection conn);
	public List<DashBoard> getDashBoardData2Graph(Connection conn);
	
}