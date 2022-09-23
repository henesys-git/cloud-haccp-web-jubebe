package shm.dao;

import java.sql.Connection;
import java.util.List;

import shm.viewmodel.CCPDataDetailViewModel;
import shm.viewmodel.CCPDataHeadViewModel;

public interface CCPDataDao {
	public List<CCPDataHeadViewModel> getAllCCPDataHeadViewModel(Connection conn, String sensorId, String startDate, String endDate, String processCode);
	public List<CCPDataDetailViewModel> getAllCCPDataDetailViewModel(Connection conn, String sensorKey);
	public Boolean updateShmSentYn(Connection conn, String sensorKey, String value);
}