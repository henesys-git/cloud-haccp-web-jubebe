package dao;

import java.sql.Connection;

import model.ChecklistInfo;

public interface ChecklistInfoDao {
	//public int insert(Connection conn, ChecklistData clData);
	public ChecklistInfo select(Connection conn, String checklistId);
	//public List<ChecklistData> selectAll(Connection conn, String checklistId);
}
