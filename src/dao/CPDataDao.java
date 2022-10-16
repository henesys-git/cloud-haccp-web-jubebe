package dao;

import java.sql.Connection;
import java.util.List;

import model.CCPData;
import viewmodel.CCPDataDetailViewModel;
import viewmodel.CCPDataHeadViewModel;
import viewmodel.CCPDataMonitoringModel;
import viewmodel.CCPDataStatisticModel;
import viewmodel.CCPTestDataHeadViewModel;
import viewmodel.CCPTestDataViewModel;
import viewmodel.CPDataHeadViewModel;
import viewmodel.CPDataMonitoringModel;

public interface CPDataDao {
	public List<CPDataHeadViewModel> getAllCCPDataHeadViewModel(Connection conn, String sensorId, String startDate, String endDate, String processCode);
	public List<CPDataMonitoringModel> getCCPDataMonitoringModel(Connection conn);
}