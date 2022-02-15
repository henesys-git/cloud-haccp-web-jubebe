package service;

import java.sql.Connection;
import java.util.List;

import dao.EventInfoDao;
import mes.frame.database.JDBCConnectionPool;
import model.EventInfo;

public class EventInfoService {

	private EventInfoDao eventInfoDao;
	private String bizNo;
	
	public EventInfoService(EventInfoDao eventInfoDao, String bizNo) {
		this.eventInfoDao = eventInfoDao;
		this.bizNo = bizNo;
	}
	
	public boolean insert() {
		return false;
	}
	
	public List<EventInfo> getAllEventInfo() {
		Connection conn = JDBCConnectionPool.getTenantDB(bizNo);
		return eventInfoDao.getAllEventInfo(conn);
	}

	public EventInfo getEventInfoByCode(String code) {
		Connection conn = JDBCConnectionPool.getTenantDB(bizNo);
		EventInfo event = eventInfoDao.getEventInfo(conn, code);
		return event;
	}
	
	public boolean isLimitOut(EventInfo event, double value) {
		double min = event.getMinValue();
		double max = event.getMaxValue();
		
		if( value < min || value > max ) {
			return true;
		}
		
		return false;
	}
}
