package newest.mes.service;

import java.sql.Connection;
import java.util.List;

import org.apache.log4j.Logger;
import org.json.simple.JSONArray;

import dao.ProductDao;
import mes.frame.database.JDBCConnectionPool;
import model.Product;
import newest.mes.dao.OrderDao;
import newest.mes.dao.ProductionPlanDao;
import newest.mes.model.Order;
import newest.mes.model.ProductionPlan;
import viewmodel.ProductViewModel;

public class ProductionPlanService {

	private ProductionPlanDao planDao;
	private String bizNo;
	private Connection conn;
	
	static final Logger logger = Logger.getLogger(ProductionPlanService.class.getName());

	public ProductionPlanService(ProductionPlanDao planDao, String bizNo) {
		this.planDao = planDao;
		this.bizNo = bizNo;
	}
	
	public List<ProductionPlan> getAllPlans() {
		List<ProductionPlan> planList = null;
		
		try {
			conn = JDBCConnectionPool.getTenantDB(bizNo);
			planList = planDao.getAllPlans(conn);
		} catch(Exception e) {
			logger.error(e.getMessage());
		} finally {
		    try { conn.close(); } catch (Exception e) { /* Ignored */ }
		}
		
		return planList;
	}
	
	public Order getOrderById(String id) {
		Order order = null;
		
		try {
			conn = JDBCConnectionPool.getTenantDB(bizNo);
			order = planDao.getOrder(conn, id);
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
			return planDao.insert(conn, plan);
		} catch(Exception e) {
			logger.error(e.getMessage());
		} finally {
		    try { conn.close(); } catch (Exception e) { /* Ignored */ }
		}
		
		return false;
	}
	
	public boolean update(ProductionPlan plan) {
		try {
			conn = JDBCConnectionPool.getTenantDB(bizNo);
			return planDao.update(conn, plan);
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
			return planDao.delete(conn, planNo);
		} catch(Exception e) {
			logger.error(e.getMessage());
		} finally {
		    try { conn.close(); } catch (Exception e) { /* Ignored */ }
		}
		
		return false;
	}
	
	public boolean instructionInsert(String instructionDate, String productId, String planNo, String instructionCount) {
		try {
			conn = JDBCConnectionPool.getTenantDB(bizNo);
			return planDao.instructionInsert(conn, instructionDate, productId, planNo, instructionCount);
		} catch(Exception e) {
			logger.error(e.getMessage());
		} finally {
		    try { conn.close(); } catch (Exception e) { /* Ignored */ }
		}
		
		return false;
	}
	
}
