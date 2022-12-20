package newest.mes.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;

import org.apache.log4j.Logger;

import mes.frame.database.JDBCConnectionPool;
import model.Product;
import newest.mes.model.Order;
import viewmodel.ProductViewModel;

public class OrderDaoImpl implements OrderDao {
	
	private Statement stmt;
	private ResultSet rs;
	
	static final Logger logger = 
			Logger.getLogger(OrderDaoImpl.class.getName());
	
	public OrderDaoImpl() {
	}

	@Override
	public List<Order> getAllOrders(Connection conn) {
		
		try {
			stmt = conn.createStatement();
			
			String sql = new StringBuilder()
				.append("SELECT * 		\n")
				.append("FROM mes_order	\n")
				.append("WHERE tenant_id = '" + JDBCConnectionPool.getTenantId(conn) + "'\n")
				.toString();
			
			logger.debug("sql:\n" + sql);
			
			rs = stmt.executeQuery(sql);
			
			List<Order> list = new ArrayList<Order>();
			
			while(rs.next()) {
				Order data = extractFromResultSet(rs);
				list.add(data);
			}
			
			return list;
			
		} catch (SQLException ex) {
			ex.printStackTrace();
		} finally {
		    try { rs.close(); } catch (Exception e) { /* Ignored */ }
		    try { stmt.close(); } catch (Exception e) { /* Ignored */ }
		}
		
		return null;
	};
	
	@Override
	public List<Order> getOrderDetails(Connection conn, String orderNo) {
		
		try {
			stmt = conn.createStatement();
			
			String sql = new StringBuilder()
				.append("SELECT * 		\n")
				.append("FROM mes_order_detail \n")
				.append("WHERE tenant_id = '" + JDBCConnectionPool.getTenantId(conn) + "'\n")
				.append("and order_no = '" + orderNo + "'\n")
				.toString();
			
			logger.debug("sql:\n" + sql);
			
			rs = stmt.executeQuery(sql);
			
			List<Order> list = new ArrayList<Order>();
			
			while(rs.next()) {
				Order data = extractFromResultDetailSet(rs);
				list.add(data);
			}
			
			return list;
			
		} catch (SQLException ex) {
			ex.printStackTrace();
		} finally {
		    try { rs.close(); } catch (Exception e) { /* Ignored */ }
		    try { stmt.close(); } catch (Exception e) { /* Ignored */ }
		}
		
		return null;
	};
	
	@Override
	public Order getOrder(Connection conn, String orderNo) {
		
		try {
			stmt = conn.createStatement();
			
			String sql = new StringBuilder()
				.append("SELECT * 		\n")
				.append("FROM mes_order	\n")
				.append("WHERE tenant_id = '" + JDBCConnectionPool.getTenantId(conn) + "'\n")
				.append("  AND order_no = '" + orderNo + "'\n")
				.toString();
			
			logger.debug("sql:\n" + sql);
			
			rs = stmt.executeQuery(sql);
			
			Order order = new Order();
			
			if(rs.next()) {
				order = extractFromResultSet(rs);
			}
			
			return order;
		} catch (SQLException ex) {
			ex.printStackTrace();
		} finally {
		    try { rs.close(); } catch (Exception e) { /* Ignored */ }
		    try { stmt.close(); } catch (Exception e) { /* Ignored */ }
		}
		
		return null;
	};
	
	@Override
	public boolean insert(Connection conn, Order order) {
		try {
			String sql = new StringBuilder()
					.append("INSERT INTO\n")
					.append("	mes_order (\n")
					.append("		tenant_id, \n")
					.append("		order_no,\n")
					.append("		order_date,\n")
					.append("		customer_code \n")
					.append("	)\n")
					.append("VALUES\n")
					.append("	(\n")
					.append("		?,\n")
					.append("		?,\n")
					.append("		?\n")
					.append("	);\n")
					.toString();

			PreparedStatement ps = conn.prepareStatement(sql);
			
			ps.setString(1, JDBCConnectionPool.getTenantId(conn));
			ps.setString(2, order.getOrderNo());
			ps.setString(3, order.getOrderDate());
			ps.setString(3, order.getCustomerCode());
			
	        int i = ps.executeUpdate();

	        if(i == 1) {
	        	return true;
	        }

	    } catch (SQLException ex) {
	        ex.printStackTrace();
	    }

	    return false;
	}
	
	@Override
	public boolean update(Connection conn, Order order) {
		try {
			stmt = conn.createStatement();
			
			String sql = new StringBuilder()
					.append("UPDATE mes_order\n")
					.append("SET order_no='" + order.getOrderNo() + "'\n")
					.append("WHERE tenant_id='" + JDBCConnectionPool.getTenantId(conn) + "'\n")
					.append("  AND order_no='" + order.getOrderNo() + "';\n")
					.toString();
			
			logger.debug("sql:\n" + sql);
			
	        int i = stmt.executeUpdate(sql);

	        if(i == 1) {
	        	return true;
	        }

	    } catch (SQLException ex) {
	        ex.printStackTrace();
	    }

	    return false;
	}
	
	@Override
	public boolean delete(Connection conn, String orderNo) {
		
		String sql = "";
		
		try {
			stmt = conn.createStatement();
			
			sql = new StringBuilder()
					.append("DELETE FROM mes_order \n")
					.append("WHERE tenant_id='" + JDBCConnectionPool.getTenantId(conn) + "'\n")
					.append("	AND order_no='" + orderNo + "';\n")
					.toString();
			
			logger.debug("sql:\n" + sql);
			
			int i = stmt.executeUpdate(sql);
			System.out.println("int i : " + i + "##################");
			sql = new StringBuilder()
					.append("DELETE FROM mes_order_detail \n")
					.append("WHERE tenant_id='" + JDBCConnectionPool.getTenantId(conn) + "'\n")
					.append("	AND order_no='" + orderNo + "';\n")
					.toString();
			
			logger.debug("sql:\n" + sql);
			
			int j = stmt.executeUpdate(sql);
			System.out.println("int j : " + j + "##################");
			
			System.out.println(i == 1 && j >= 1);
			
	        if(i == 1 && j >= 1) {
	        	return true;
	        }

	    } catch (SQLException ex) {
	        ex.printStackTrace();
	    }

	    return false;
	}
	
	
	private Order extractFromResultSet(ResultSet rs) throws SQLException {
		
		Order order = new Order();
		
		order.setOrderNo(rs.getString("order_no"));
		order.setOrderDate(rs.getString("order_date"));
		order.setCustomerCode(rs.getString("customer_code"));
		
		return order;
	}
	
	private Order extractFromResultDetailSet(ResultSet rs) throws SQLException {
		
		Order order = new Order();
		
		order.setProductId(rs.getString("product_id"));
		order.setOrderCount(rs.getString("order_count"));
		order.setChulhaYn(rs.getString("chulha_yn"));
		
		return order;
	}
	
}
