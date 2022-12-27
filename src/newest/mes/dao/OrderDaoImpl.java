package newest.mes.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;

import org.apache.log4j.Logger;
import org.json.simple.JSONArray;
import org.json.simple.JSONObject;

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
				.append("SELECT  		\n")
				.append("A.order_no,  		\n")
				.append("A.order_date,  		\n")
				.append("A.customer_code,  		\n")
				.append("B.customer_name  		\n")
				.append("FROM mes_order A \n")
				.append("INNER JOIN mes_product_customer B \n")
				.append("ON A.customer_code = B.customer_code \n")
				.append("WHERE A.tenant_id = '" + JDBCConnectionPool.getTenantId(conn) + "'\n")
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
				.append("SELECT  		\n")
				.append("A.product_id,  		\n")
				.append("B.product_name,  		\n")
				.append("A.order_count,  		\n")
				.append("A.chulha_yn  		\n")
				.append("FROM mes_order_detail A\n")
				.append("INNER JOIN product B \n")
				.append("ON A.product_id = B.product_id \n")
				.append("WHERE A.tenant_id = '" + JDBCConnectionPool.getTenantId(conn) + "'\n")
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
	public List<Order> getOrderInfos(Connection conn) {
		
		try {
			stmt = conn.createStatement();
			
			String sql = new StringBuilder()
				.append("SELECT 		\n")
				.append("A.order_no,		\n")
				.append("A.customer_code,		\n")
				.append("D.customer_name,		\n")
				.append("B.product_id,		\n")
				.append("E.product_name,		\n")
				.append("B.order_count	\n")
				.append("FROM mes_order	A\n")
				.append("INNER JOIN mes_order_detail B\n")
				.append("ON A.order_no = B.order_no \n")
				.append("LEFT JOIN mes_production_plan C\n")
				.append("ON B.order_no = C.order_no \n")
				.append("AND B.product_id = C.product_id \n")
				.append("INNER JOIN mes_product_customer D\n")
				.append("ON A.customer_code = D.customer_code \n")
				.append("INNER JOIN product E\n")
				.append("ON B.product_id = E.product_id \n")
				.append("WHERE A.tenant_id = '" + JDBCConnectionPool.getTenantId(conn) + "'\n")
				.append("AND C.order_yn IS NULL \n")
				.toString();
			
			logger.debug("sql:\n" + sql);
			
			rs = stmt.executeQuery(sql);
			
			List<Order> list = new ArrayList<Order>();
			
			while(rs.next()) {
				Order data = extractFromResultInfoSet(rs);
				list.add(data);
			}
			
			System.out.println(list);
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
	public boolean insert(Connection conn, Order order, JSONArray param) {
		
		
		JSONObject jsonObj;
		
		String sql = "";		
		int k = 0;
		int dtUpdate = 0;
		
		try {
			sql = new StringBuilder()
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
					.append("		?,\n")
					.append("		?\n")
					.append("	);\n")
					.toString();

			PreparedStatement ps = conn.prepareStatement(sql);
			
			ps.setString(1, JDBCConnectionPool.getTenantId(conn));
			ps.setString(2, order.getOrderNo());
			ps.setString(3, order.getOrderDate());
			ps.setString(4, order.getCustomerCode());
			
	        int i = ps.executeUpdate();
	        
	        for(k = 0; k < param.size(); k++) {
	        
	        jsonObj = (JSONObject) param.get(k);
	        	
	        sql = new StringBuilder()
					.append("INSERT INTO\n")
					.append("	mes_order_detail (\n")
					.append("		tenant_id, \n")
					.append("		order_detail_no,\n")
					.append("		product_id,\n")
					.append("		order_count,\n")
					.append("		chulha_yn,\n")
					.append("		order_no \n")
					.append("	)\n")
					.append("VALUES\n")
					.append("	(\n")
					.append("		?,\n")
					.append("		?,\n")
					.append("		?,\n")
					.append("		?,\n")
					.append("		?,\n")
					.append("		?\n")
					.append("	);\n")
					.toString();
	        
			PreparedStatement ps2 = conn.prepareStatement(sql);
			
			ps2.setString(1, JDBCConnectionPool.getTenantId(conn));
			ps2.setInt(2, k);
			ps2.setString(3, jsonObj.get("product_id").toString());
			ps2.setString(4, jsonObj.get("order_count").toString());
			ps2.setString(5, "N");
			ps2.setString(6, order.getOrderNo());
			
	        int j = ps2.executeUpdate();
	        
	        	if(j == 1) {
	        		dtUpdate += 1;
	        	}
	        
	        }
	        
	        if(i == 1 && dtUpdate >= 1) {
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
		order.setCustomerName(rs.getString("customer_name"));
		return order;
	}
	
	private Order extractFromResultDetailSet(ResultSet rs) throws SQLException {
		
		Order order = new Order();
		
		order.setProductId(rs.getString("product_id"));
		order.setProductName(rs.getString("product_name"));
		order.setOrderCount(rs.getString("order_count"));
		order.setChulhaYn(rs.getString("chulha_yn"));
		
		return order;
	}
	
	private Order extractFromResultInfoSet(ResultSet rs) throws SQLException {
		
		Order order = new Order();
		
		order.setOrderNo(rs.getString("order_no"));
		order.setCustomerCode(rs.getString("customer_code"));
		order.setProductId(rs.getString("product_id"));
		order.setOrderCount(rs.getString("order_count"));
		order.setCustomerName(rs.getString("customer_name"));
		order.setProductName(rs.getString("product_name"));
		
		return order;
	}
	
}
