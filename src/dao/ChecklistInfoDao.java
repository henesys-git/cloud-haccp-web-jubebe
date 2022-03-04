package dao;

import java.sql.Connection;
import java.util.List;

import model.ChecklistInfo;

public interface ChecklistInfoDao {
	public ChecklistInfo select(Connection conn, String checklistId);
	public List<ChecklistInfo> selectAll(Connection conn);
	public boolean insert(Connection conn, ChecklistInfo clInfo);
	public boolean update(Connection conn, ChecklistInfo clInfo);
	public boolean delete(Connection conn, String checklistId);
}
