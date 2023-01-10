package newest.mes.service;

import java.sql.Connection;
import java.util.List;

import org.apache.log4j.Logger;
import org.json.simple.JSONArray;

import dao.ProductDao;
import mes.frame.database.JDBCConnectionPool;
import model.Product;
import newest.mes.dao.OrderDao;
import newest.mes.dao.ProductionResultDao;
import newest.mes.model.Order;
import newest.mes.model.ProductionPlan;
import newest.mes.model.ProductionResult;
import viewmodel.ProductViewModel;

public class ProductionResultService {

	private ProductionResultDao resultDao;
	private String bizNo;
	private Connection conn;
	
	static final Logger logger = Logger.getLogger(ProductionResultService.class.getName());

	public ProductionResultService(ProductionResultDao resultDao, String bizNo) {
		this.resultDao = resultDao;
		this.bizNo = bizNo;
	}
	
	public List<ProductionResult> getAllResults() {
		List<ProductionResult> resultList = null;
		
		try {
			conn = JDBCConnectionPool.getTenantDB(bizNo);
			resultList = resultDao.getAllResults(conn);
		} catch(Exception e) {
			logger.error(e.getMessage());
		} finally {
		    try { conn.close(); } catch (Exception e) { /* Ignored */ }
		}
		
		return resultList;
	}
	
	public Order getOrderById(String id) {
		Order order = null;
		
		try {
			conn = JDBCConnectionPool.getTenantDB(bizNo);
			order = resultDao.getOrder(conn, id);
		} catch(Exception e) {
			logger.error(e.getMessage());
		} finally {
		    try { conn.close(); } catch (Exception e) { /* Ignored */ }
		}
		
		return order;
	}
	
	public boolean insert(ProductionPlan plan) {
		try {
			conn = JDBCConnectionPool.getTenantDB(bizNo);
			return resultDao.insert(conn, plan);
		} catch(Exception e) {
			logger.error(e.getMessage());
		} finally {
		    try { conn.close(); } catch (Exception e) { /* Ignored */ }
		}
		
		return false;
	}
	
	public boolean packingUpdate(String packingCount, String planNo) {
		try {
			conn = JDBCConnectionPool.getTenantDB(bizNo);
			return resultDao.packingUpdate(conn, packingCount, planNo);
		} catch(Exception e) {
			logger.error(e.getMessage());
		} finally {
		    try { conn.close(); } catch (Exception e) { /* Ignored */ }
		}
		
		return false;
	}
	
	public boolean delete(String planNo) {
		try {
			conn = JDBCConnectionPool.getTenantDB(bizNo);
			return resultDao.delete(conn, planNo);
		} catch(Exception e) {
			logger.error(e.getMessage());
		} finally {
		    try { conn.close(); } catch (Exception e) { /* Ignored */ }
		}
		
		return false;
	}
	
}
