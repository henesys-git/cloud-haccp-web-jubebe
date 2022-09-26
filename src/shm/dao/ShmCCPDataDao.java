package shm.dao;

import java.sql.Connection;
import java.util.List;

import shm.model.C0010;

public interface ShmCCPDataDao {
	public List<C0010> getCCPData(Connection conn, String sensorKey);
}