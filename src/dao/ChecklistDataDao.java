package dao;

import java.sql.Connection;

import mes.model.ChecklistData;

public interface ChecklistDataDao {
	public int insert(Connection conn, ChecklistData clData);
}
