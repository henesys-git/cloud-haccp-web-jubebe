package dao;

import java.sql.Connection;
import java.util.List;

import mes.model.ChecklistData;

public interface ChecklistDataDao {
	public int insert(Connection conn, ChecklistData clData);
	public ChecklistData select(Connection conn, String checklistId, int seqNo);
	public List<ChecklistData> selectAll(Connection conn, String checklistId);
}
