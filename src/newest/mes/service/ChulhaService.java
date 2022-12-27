package newest.mes.service;

import java.sql.Connection;
import java.util.List;

import org.apache.log4j.Logger;

import mes.frame.database.JDBCConnectionPool;
import newest.mes.dao.ChulhaDao;
import newest.mes.model.ChulhaInfo;
import newest.mes.model.ChulhaInfoDetail;
import newest.mes.viewmodel.ChulhaInfoViewModel;

public class ChulhaService {
	private ChulhaDao chulhaDao;
	private String bizNo;
	private Connection conn;
	
	static final Logger logger = Logger.getLogger(ChulhaService.class.getName());

	public ChulhaService(ChulhaDao chulhaDao, String bizNo) {
		this.chulhaDao = chulhaDao;
		this.bizNo = bizNo;
	}
	
	public List<ChulhaInfoViewModel> getChulhaInfo() {
		List<ChulhaInfoViewModel> chulhaList = null;
		
		try {
			conn = JDBCConnectionPool.getTenantDB(bizNo);
			chulhaList = chulhaDao.getChulhaInfo(conn);
		} catch(Exception e) {
			logger.error(e.getMessage());
		} finally {
		    try { conn.close(); } catch (Exception e) { /* Ignored */ }
		}
		
		return chulhaList;
	}

	public List<ChulhaInfoViewModel> getChulhaInfoDetail(String chulhaNo) {
		List<ChulhaInfoViewModel> chulhaList = null;
		
		try {
			conn = JDBCConnectionPool.getTenantDB(bizNo);
			chulhaList = chulhaDao.getChulhaInfoDetail(conn, chulhaNo);
		} catch(Exception e) {
			logger.error(e.getMessage());
		} finally {
			try { conn.close(); } catch (Exception e) { /* Ignored */ }
		}
		
		return chulhaList;
	}
	
	public boolean insert(ChulhaInfo ci, List<ChulhaInfoDetail> detailList) {
		try {
			conn = JDBCConnectionPool.getTenantDB(bizNo);
			conn.setAutoCommit(false);
			
			boolean inserted = false;
			inserted = chulhaDao.insert(conn, ci);
			if(!inserted) {
				conn.rollback();
				return false;
			}
			
			for(ChulhaInfoDetail cid : detailList) {
				inserted = chulhaDao.insert(conn, cid);
				if(!inserted) {
					conn.rollback();
					return false;
				}
			}
			
			conn.commit();
			return true;
		} catch(Exception e) {
			logger.error(e.getMessage());
		} finally {
		    try { conn.close(); } catch (Exception e) { /* Ignored */ }
		}
		
		return false;
	}
	
	public boolean update(ChulhaInfo ci, List<ChulhaInfoDetail> detailList) {
		try {
			conn = JDBCConnectionPool.getTenantDB(bizNo);
			conn.setAutoCommit(false);
			
			boolean updated = false;
			updated = chulhaDao.update(conn, ci);
			if(!updated) {
				conn.rollback();
				return false;
			}
			
			for(ChulhaInfoDetail cid : detailList) {
				updated = chulhaDao.update(conn, cid);
				if(!updated) {
					conn.rollback();
					return false;
				}
			}
			
			conn.commit();
			return true;
		} catch(Exception e) {
			logger.error(e.getMessage());
		} finally {
		    try { conn.close(); } catch (Exception e) { /* Ignored */ }
		}
		
		return false;
	}
	
	public boolean delete(String chulhaNo) {
		
		return false;
	}
}
