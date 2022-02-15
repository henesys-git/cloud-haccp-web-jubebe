package dao;

import java.sql.Connection;
import java.util.List;

import model.EventInfo;

public interface EventInfoDao {
	public List<EventInfo> getAllEventInfo(Connection conn);
	public EventInfo getEventInfo(Connection conn, String eventCode);
}