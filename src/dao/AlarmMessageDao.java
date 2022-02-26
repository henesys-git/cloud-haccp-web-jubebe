package dao;

import java.sql.Connection;

import model.LimitOutAlarmMessage;

public interface AlarmMessageDao {
	public LimitOutAlarmMessage getLimitOutAlarmMessage(Connection conn, String eventCode);
}