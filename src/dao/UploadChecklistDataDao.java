package dao;

import java.sql.Connection;
import java.util.List;

import model.ChecklistData;
import model.DocumentData;

public interface UploadChecklistDataDao {
	public int insert(Connection conn, DocumentData docData);
	public int update(Connection conn, DocumentData docData);
	public int delete(Connection conn, DocumentData docData);
	public DocumentData select(Connection conn, String documentId, int seqNo);
	public List<DocumentData> selectAll(Connection conn, String checklistId);
}
