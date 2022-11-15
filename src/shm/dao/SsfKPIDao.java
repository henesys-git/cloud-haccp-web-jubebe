package shm.dao;

import java.sql.Connection;
import java.util.List;

import shm.viewmodel.SsfKpiLevel2;

public interface SsfKPIDao {
	public List<SsfKpiLevel2> getKPIData(Connection conn);
	public Boolean updateSsfSentYn(Connection conn, String sensorKey, String value);
}