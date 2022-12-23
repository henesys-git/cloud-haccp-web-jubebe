package newest.mes.service;

import java.sql.Connection;
import java.util.List;

import org.apache.log4j.Logger;

import mes.frame.database.JDBCConnectionPool;
import newest.mes.dao.RawmaterialStorageDao;
import newest.mes.model.RawmaterialStorage;
import utils.StockNoGenerator;

public class RawmaterialStorageService {

	private RawmaterialStorageDao rawmaterialStorageDao;
	private String bizNo;
	private Connection conn;
	
	static final Logger logger = Logger.getLogger(RawmaterialStorageService.class.getName());

	public RawmaterialStorageService(RawmaterialStorageDao rawmaterialStorageDao, String bizNo) {
		this.rawmaterialStorageDao = rawmaterialStorageDao;
		this.bizNo = bizNo;
	}
	
	public List<RawmaterialStorage> getStockGroupByRawmaterialId() {
		List<RawmaterialStorage> rawmaterialStorageList = null;
		
		try {
			conn = JDBCConnectionPool.getTenantDB(bizNo);
			rawmaterialStorageList = rawmaterialStorageDao.getStockGroupByRawmaterialId(conn);
		} catch(Exception e) {
			logger.error(e.getMessage());
		} finally {
		    try { conn.close(); } catch (Exception e) { /* Ignored */ }
		}
		
		return rawmaterialStorageList;
	}
	
	public List<RawmaterialStorage> getStockGroupByStockNo(String rawmaterialId) {
		List<RawmaterialStorage> rawmaterialStorageList = null;
		
		try {
			conn = JDBCConnectionPool.getTenantDB(bizNo);
			rawmaterialStorageList = rawmaterialStorageDao.getStockGroupByStockNo(conn, rawmaterialId);
		} catch(Exception e) {
			logger.error(e.getMessage());
		} finally {
		    try { conn.close(); } catch (Exception e) { /* Ignored */ }
		}
		
		return rawmaterialStorageList;
	}
	
	public List<RawmaterialStorage> getStock(String stockNo) {
		List<RawmaterialStorage> rawmaterialStorageList = null;
		
		try {
			conn = JDBCConnectionPool.getTenantDB(bizNo);
			rawmaterialStorageList = rawmaterialStorageDao.getStock(conn, stockNo);
		} catch(Exception e) {
			logger.error(e.getMessage());
		} finally {
		    try { conn.close(); } catch (Exception e) { /* Ignored */ }
		}
		
		return rawmaterialStorageList;
	}
	
	public boolean ipgoChulgo(String rawmaterialStockNo, 
							  String rawmaterialId, 
							  String ioDatetime, 
							  int ioAmt) {
		try {
			RawmaterialStorage storage = new RawmaterialStorage();
			if(rawmaterialStockNo.equals("")) {
				storage.setRawmaterialStockNo(StockNoGenerator.generate());
			} else {
				storage.setRawmaterialStockNo(rawmaterialStockNo);
			}
			storage.setRawmaterialId(rawmaterialId);
			storage.setIoDatetime(ioDatetime);
			storage.setIoAmt(ioAmt);
			
			conn = JDBCConnectionPool.getTenantDB(bizNo);
			return rawmaterialStorageDao.ipgoChulgo(conn, storage);
		} catch(Exception e) {
			logger.error(e.getMessage());
		} finally {
		    try { conn.close(); } catch (Exception e) { /* Ignored */ }
		}
		
		return false;
	};
	
	public boolean insert(RawmaterialStorage rawmaterialStorage) {
		try {
			conn = JDBCConnectionPool.getTenantDB(bizNo);
			return rawmaterialStorageDao.insert(conn, rawmaterialStorage);
		} catch(Exception e) {
			logger.error(e.getMessage());
		} finally {
		    try { conn.close(); } catch (Exception e) { /* Ignored */ }
		}
		
		return false;
	}
	
	public boolean update(RawmaterialStorage rawmaterialStorage) {
		try {
			conn = JDBCConnectionPool.getTenantDB(bizNo);
			return rawmaterialStorageDao.update(conn, rawmaterialStorage);
		} catch(Exception e) {
			logger.error(e.getMessage());
		} finally {
		    try { conn.close(); } catch (Exception e) { /* Ignored */ }
		}
		
		return false;
	}
	
	public boolean delete(String rawmaterialStorageNo) {
		try {
			conn = JDBCConnectionPool.getTenantDB(bizNo);
			return rawmaterialStorageDao.delete(conn, rawmaterialStorageNo);
		} catch(Exception e) {
			logger.error(e.getMessage());
		} finally {
		    try { conn.close(); } catch (Exception e) { /* Ignored */ }
		}
		
		return false;
	}
	
}
