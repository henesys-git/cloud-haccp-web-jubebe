package newest.mes.service;

import java.sql.Connection;
import java.util.List;

import org.apache.log4j.Logger;

import mes.frame.database.JDBCConnectionPool;
import newest.mes.dao.OrderDao;
import newest.mes.model.Order;

public class OrderService {

	private OrderDao orderDao;
	private String bizNo;
	private Connection conn;
	
	static final Logger logger = Logger.getLogger(OrderService.class.getName());

	public OrderService(OrderDao orderDao, String bizNo) {
		this.orderDao = orderDao;
		this.bizNo = bizNo;
	}
	
	public List<Order> getAllOrders() {
		List<Order> orderList = null;
		
		try {
			conn = JDBCConnectionPool.getTenantDB(bizNo);
			orderList = orderDao.getAllOrders(conn);
		} catch(Exception e) {
			logger.error(e.getMessage());
		} finally {
		    try { conn.close(); } catch (Exception e) { /* Ignored */ }
		}
		
		return orderList;
	}
	
	public List<Order> getAllOrdersNoChulhaYet() {
		List<Order> orderList = null;
		
		try {
			conn = JDBCConnectionPool.getTenantDB(bizNo);
			orderList = orderDao.getAllOrdersNoChulhaYet(conn);
		} catch(Exception e) {
			logger.error(e.getMessage());
		} finally {
		    try { conn.close(); } catch (Exception e) { /* Ignored */ }
		}
		
		return orderList;
	}
	
	public List<Order> getOrderDetails(String orderNo) {
		List<Order> orderList = null;
		
		try {
			conn = JDBCConnectionPool.getTenantDB(bizNo);
			orderList = orderDao.getOrderDetails(conn, orderNo);
		} catch(Exception e) {
			logger.error(e.getMessage());
		} finally {
		    try { conn.close(); } catch (Exception e) { /* Ignored */ }
		}
		
		return orderList;
	}
	
	public List<Order> getOrderDetailsNoChulhaYet(String orderNo) {
		List<Order> orderList = null;
		
		try {
			conn = JDBCConnectionPool.getTenantDB(bizNo);
			orderList = orderDao.getOrderDetailsNoChulhaYet(conn, orderNo);
		} catch(Exception e) {
			logger.error(e.getMessage());
		} finally {
			try { conn.close(); } catch (Exception e) { /* Ignored */ }
		}
		
		return orderList;
	}
	
	public Order getOrderById(String id) {
		Order order = null;
		
		try {
			conn = JDBCConnectionPool.getTenantDB(bizNo);
			order = orderDao.getOrder(conn, id);
		} catch(Exception e) {
			logger.error(e.getMessage());
		} finally {
		    try { conn.close(); } catch (Exception e) { /* Ignored */ }
		}
		
		return order;
	}
	
	public boolean insert(Order order) {
		try {
			conn = JDBCConnectionPool.getTenantDB(bizNo);
			return orderDao.insert(conn, order);
		} catch(Exception e) {
			logger.error(e.getMessage());
		} finally {
		    try { conn.close(); } catch (Exception e) { /* Ignored */ }
		}
		
		return false;
	}
	
	public boolean update(Order order) {
		try {
			conn = JDBCConnectionPool.getTenantDB(bizNo);
			return orderDao.update(conn, order);
		} catch(Exception e) {
			logger.error(e.getMessage());
		} finally {
		    try { conn.close(); } catch (Exception e) { /* Ignored */ }
		}
		
		return false;
	}
	
	public boolean delete(String orderNo) {
		try {
			conn = JDBCConnectionPool.getTenantDB(bizNo);
			return orderDao.delete(conn, orderNo);
		} catch(Exception e) {
			logger.error(e.getMessage());
		} finally {
		    try { conn.close(); } catch (Exception e) { /* Ignored */ }
		}
		
		return false;
	}
	
	public boolean chulha(Order order) {
		try {
			conn = JDBCConnectionPool.getTenantDB(bizNo);
			return orderDao.chulha(conn, order);
		} catch(Exception e) {
			logger.error(e.getMessage());
		} finally {
		    try { conn.close(); } catch (Exception e) { /* Ignored */ }
		}
		
		return false;
	}
	
}
