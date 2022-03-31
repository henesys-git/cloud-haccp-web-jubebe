package dao;

import java.sql.Connection;
import java.util.List;

import model.ChecklistData;

public interface ChecklistDataDao {
	public int insert(Connection conn, ChecklistData clData);
	public int update(Connection conn, ChecklistData clData);
	public int delete(Connection conn, ChecklistData clData);
	public ChecklistData select(Connection conn, String checklistId, int seqNo);
	public ChecklistData selectSignData(Connection conn, String checklistId, int seqNo);
	public List<ChecklistData> selectAll(Connection conn, String checklistId);
	public int doSign(Connection conn, ChecklistData clData, String signTarget, String loginId);
	public List<ChecklistData> selectSignColumn(Connection conn, String checklistId);
}
