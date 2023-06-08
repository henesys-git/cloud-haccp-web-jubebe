package dao;

import java.sql.Connection;
import java.util.List;

import model.ChecklistData;
import model.DocumentData;
import model.UploadChecklistData;

public interface UploadChecklistDataDao {
	public int insert(Connection conn, UploadChecklistData docData);
	public int update(Connection conn, UploadChecklistData docData);
	public int delete(Connection conn, UploadChecklistData docData);
	public UploadChecklistData select(Connection conn, String documentId, int seqNo);
	public List<UploadChecklistData> selectAll(Connection conn, String checklistId);
}
