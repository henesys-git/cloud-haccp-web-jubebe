package dao;

import java.sql.Connection;

import model.AlarmInfo;

public interface AlarmInfoDao {
	public AlarmInfo getAlarmInfo(Connection conn);
}