package dao;

import java.sql.Connection;
import java.util.List;

import model.CCPData;
import viewmodel.CCPDataDetailViewModel;
import viewmodel.CCPDataHeadViewModel;
import viewmodel.CCPDataHeatingMonitoringGraphModel;
import viewmodel.CCPDataHeatingMonitoringModel;
import viewmodel.CCPDataMonitoringModel;
import viewmodel.CCPDataStatisticModel;
import viewmodel.CCPTestDataHeadViewModel;
import viewmodel.CCPTestDataViewModel;
import viewmodel.KPIProductionViewModel;
import viewmodel.KPIQualityViewModel;

public interface CCPDataDao {
	public List<CCPData> getAllCCPData(Connection conn, String type, String startDate, String endDate);
	public List<CCPTestDataHeadViewModel> getCCPTestDataHeadBySensorAndProd(Connection conn, String startDate, String endDate, String processCode);
	public List<CCPTestDataHeadViewModel> getCCPTestDataHeadBySensor(Connection conn, String startDate, String endDate, String processCode);
	public List<CCPTestDataHeadViewModel> getCCPTestDataHeadByProd(Connection conn, String startDate, String endDate, String processCode);
	public List<CCPTestDataViewModel> getCCPTestData(Connection conn, String date, String processCode, String sensorId);
	public List<CCPDataHeadViewModel> getAllCCPDataHeadViewModel(Connection conn, String sensorId, String startDate, String endDate, String processCode);
	public List<CCPDataDetailViewModel> getAllCCPDataDetailViewModel(Connection conn, String sensorKey);
	public boolean fixLimitOut(Connection conn, String sensorKey, String createTime, String improvement);
	public List<CCPDataStatisticModel> getCCPDataStatisticModel(Connection conn, String toDate, String sensorId);
	public List<CCPDataMonitoringModel> getCCPDataMonitoringModel(Connection conn, String toDate, String processCode);
	public List<CCPDataDetailViewModel> getMetalBreakAwayList(Connection conn, String sensorKey, String sensorId, String processCode, String toDate, String fromDate);
	public List<CCPDataHeatingMonitoringModel> getAllCCPDataHeatingMonitoringModel(Connection conn, String sensorId, String startDate, String endDate, String processCode);
	public List<CCPDataHeatingMonitoringGraphModel> getAllCCPDataHeatingMonitoringGraphModel(Connection conn, String sensorKey, String sensorId);
	public List<CCPDataHeatingMonitoringGraphModel> getAllCCPDataHeatingMonitoringGraphModel2(Connection conn, String sensorKey, String sensorId);
	public List<KPIProductionViewModel> getKPIProduction(Connection conn, String processCode, String toDate, String fromDate);
	public List<KPIQualityViewModel> getKPIQuality(Connection conn, String processCode, String toDate, String fromDate, String sensorId);
}