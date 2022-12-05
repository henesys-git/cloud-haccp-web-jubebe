package dao;

import java.sql.Connection;
import java.util.List;

import model.ChecklistInfo;

public interface ChecklistInfoDao {
	public ChecklistInfo select(Connection conn, String checklistId);
	public ChecklistInfo selectChecklistNoByProdAndSensor(Connection conn, String prodCd, String sensorId);
	public ChecklistInfo selectChecklistNoByProd(Connection conn, String prodCd);
	public ChecklistInfo selectChecklistNoBySensor(Connection conn, String sensorId);
	public List<ChecklistInfo> selectAll(Connection conn);
	public String getFormClassifiicationCriteria(Connection conn, String ccpType);
	public boolean insert(Connection conn, ChecklistInfo clInfo);
	public boolean update(Connection conn, ChecklistInfo clInfo);
	public boolean delete(Connection conn, String checklistId);
	public boolean sign(Connection conn, ChecklistInfo clInfo, String aa);
}
