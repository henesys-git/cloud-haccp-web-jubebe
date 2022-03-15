package dao;

import java.sql.Connection;
import java.util.List;

import model.CCPData;
import viewmodel.CCPDataDetailViewModel;
import viewmodel.CCPDataHeadViewModel;
import viewmodel.CCPDataMonitoringModel;
import viewmodel.CCPDataStatisticModel;

public interface CCPDataDao {
	public List<CCPData> getAllCCPData(Connection conn, String type, String startDate, String endDate);
	public List<CCPDataHeadViewModel> getAllCCPDataHeadViewModel(Connection conn, String type, String startDate, String endDate);
	public List<CCPDataDetailViewModel> getAllCCPDataDetailViewModel(Connection conn, String sensorKey);
	public boolean fixLimitOut(Connection conn, String sensorKey, String createTime, String improvement);
	public List<CCPDataStatisticModel> getCCPDataStatisticModel(Connection conn, String toDate, String sensorId);
	public List<CCPDataMonitoringModel> getCCPDataMonitoringModel(Connection conn, String toDate);
}