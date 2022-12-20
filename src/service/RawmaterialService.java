package service;

import java.sql.Connection;
import java.util.List;

import org.apache.log4j.Logger;

import dao.RawmaterialDao;
import mes.frame.database.JDBCConnectionPool;
import model.Rawmaterial;
import viewmodel.RawmaterialViewModel;

public class RawmaterialService {

	private RawmaterialDao rawmaterialDao;
	private String bizNo;
	private Connection conn;
	
	static final Logger logger = Logger.getLogger(RawmaterialService.class.getName());

	public RawmaterialService(RawmaterialDao rawmaterialDao, String bizNo) {
		this.rawmaterialDao = rawmaterialDao;
		this.bizNo = bizNo;
	}
	
	public List<Rawmaterial> getAllRawmaterials() {
		List<Rawmaterial> rawmaterialList = null;
		
		try {
			conn = JDBCConnectionPool.getTenantDB(bizNo);
			rawmaterialList = rawmaterialDao.getAllRawmaterials(conn);
		} catch(Exception e) {
			logger.error(e.getMessage());
		} finally {
		    try { conn.close(); } catch (Exception e) { /* Ignored */ }
		}
		
		return rawmaterialList;
	}
	
	public Rawmaterial getRawmaterialById(String id) {
		Rawmaterial rawmaterial = null;
		
		try {
			conn = JDBCConnectionPool.getTenantDB(bizNo);
			rawmaterial = rawmaterialDao.getRawmaterial(conn, id);
		} catch(Exception e) {
			logger.error(e.getMessage());
		} finally {
		    try { conn.close(); } catch (Exception e) { /* Ignored */ }
		}
		
		return rawmaterial;
	}
	
	public boolean insert(Rawmaterial rawmaterial) {
		try {
			conn = JDBCConnectionPool.getTenantDB(bizNo);
			return rawmaterialDao.insert(conn, rawmaterial);
		} catch(Exception e) {
			logger.error(e.getMessage());
		} finally {
		    try { conn.close(); } catch (Exception e) { /* Ignored */ }
		}
		
		return false;
	}
	
	public boolean update(Rawmaterial rawmaterial) {
		try {
			conn = JDBCConnectionPool.getTenantDB(bizNo);
			return rawmaterialDao.update(conn, rawmaterial);
		} catch(Exception e) {
			logger.error(e.getMessage());
		} finally {
		    try { conn.close(); } catch (Exception e) { /* Ignored */ }
		}
		
		return false;
	}
	
	public boolean delete(String rawmaterialId) {
		try {
			conn = JDBCConnectionPool.getTenantDB(bizNo);
			return rawmaterialDao.delete(conn, rawmaterialId);
		} catch(Exception e) {
			logger.error(e.getMessage());
		} finally {
		    try { conn.close(); } catch (Exception e) { /* Ignored */ }
		}
		
		return false;
	}
	
	public List<RawmaterialViewModel> getAllRawmaterialsViewModel() {
		List<RawmaterialViewModel> rawmaterialList = null;
		
		try {
			conn = JDBCConnectionPool.getTenantDB(bizNo);
			rawmaterialList = rawmaterialDao.getAllRawmaterialsViewModels(conn);
		} catch(Exception e) {
			logger.error(e.getMessage());
		} finally {
		    try { conn.close(); } catch (Exception e) { /* Ignored */ }
		}
		
		return rawmaterialList;
	}
}
