package dao;

import java.sql.Connection;
import java.util.List;

import model.ChecklistData;
import model.DocumentData;

public interface DocumentDataDao {
	public int insert(Connection conn, ChecklistData clData);
	public int update(Connection conn, ChecklistData clData);
	public int delete(Connection conn, ChecklistData clData);
	public DocumentData select(Connection conn, String documentId, int seqNo);
	public List<DocumentData> selectAll(Connection conn, String checklistId);
}
