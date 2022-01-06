package mes.service;

import java.sql.Connection;
import java.util.ArrayList;
import java.util.List;

import mes.dao.CCPDataDao;
import mes.dao.SensorDao;
import mes.dao.SensorDaoImpl;
import mes.frame.database.JDBCConnectionPool;
import mes.model.CCPData;
import mes.model.Sensor;
import viewmodel.CCPDataViewModel;

public class CCPDataService {

	private CCPDataDao ccpDataDao;
	private String bizNo;
	
	public CCPDataService(CCPDataDao ccpDataDao, String bizNo) {
		this.ccpDataDao = ccpDataDao;
		this.bizNo = bizNo;
	}
	
	public List<CCPData> getCCPData(String type, String startDate, String endDate) {
		Connection conn = JDBCConnectionPool.getTenantDB(bizNo);
		
		List<CCPData> ccpDataList = ccpDataDao.getAllCCPData(conn, type, startDate, endDate);
		
		return ccpDataList;
	}
	
	public List<CCPDataViewModel> getCCPDataViewModels(String type, String startDate, String endDate) {
		Connection conn = JDBCConnectionPool.getTenantDB(bizNo);
		
		List<CCPDataViewModel> cvmList = ccpDataDao.getAllCCPDataViewModel(conn, type, startDate, endDate);
		
		return cvmList;
//		SensorDao sensorDao = new SensorDaoImpl();
//		List<Sensor> sensors = sensorDao.getAllSensors(conn);
//		
//		List<CCPDataViewModel> vmList = new ArrayList<>();
//		
//		for(int i=0; i<ccpDataList.size(); i++) {
//			CCPDataViewModel vm = new CCPDataViewModel();
//
//			CCPData data = ccpDataList.get(i);
//			
//			vm.setCreateTime(data.getCreateTime());
//			vm.setSensorKey(data.getSensorKey());
//			vm.setEvent(data.getEventCode());
//		}
	}
}
