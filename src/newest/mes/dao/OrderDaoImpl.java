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

import mes.client.util.NumberGeneratorForCloudMES;
import mes.frame.database.JDBCConnectionPool;
import newest.mes.model.Order;

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
	public List<Order> getAllOrdersNoChulhaYet(Connection conn) {
		
		try {
			stmt = conn.createStatement();
			
			String sql = new StringBuilder()
				.append("SELECT\n")
				.append("	O.order_no,\n")
				.append("	O.order_date,\n")
				.append("	O.customer_code,\n")
				.append("	C.customer_name\n")
				.append("FROM mes_order O	\n")
				.append("INNER JOIN mes_order_detail D\n")
				.append("	ON O.order_no = D.order_no\n")
				.append("INNER JOIN mes_product_customer C\n")
				.append("	ON O.customer_code = C.customer_code\n")
				.append("WHERE O.tenant_id = '" + JDBCConnectionPool.getTenantId(conn) + "'\n")
				.append("	AND D.chulha_yn = 'N'\n")
				.append("GROUP BY O.order_no\n")
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
				//.append("A.order_no  		\n")
				.append("FROM mes_order_detail A\n")
				.append("INNER JOIN product B \n")
				.append("ON A.product_id = B.product_id \n")
				.append("WHERE A.tenant_id = '" + JDBCConnectionPool.getTenantId(conn) + "'\n")
				.append("	AND order_no = '" + orderNo + "'\n")
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
	public List<Order> getOrderDetailsNoChulhaYet(Connection conn, String orderNo) {
		
		try {
			stmt = conn.createStatement();
			
			String sql = new StringBuilder()
				.append("SELECT\n")
				.append("	od.order_no,\n")
				.append("	od.order_detail_no,\n")
				.append("	od.product_id,\n")
				.append("	p.product_name,\n")
				.append("	od.order_count,\n")
				.append("	od.chulha_yn\n")
				.append("FROM mes_order_detail od\n")
				.append("INNER JOIN product p\n")
				.append("	ON od.product_id = p.product_id\n")
				.append("WHERE od.tenant_id = '" + JDBCConnectionPool.getTenantId(conn) + "'\n")
				.append("	AND od.order_no = '" + orderNo + "'\n")
				.append("	AND od.chulha_yn = 'N'\n")
				.toString();
			
			logger.debug("sql:\n" + sql);
			
			rs = stmt.executeQuery(sql);
			
			List<Order> list = new ArrayList<Order>();
			
			while(rs.next()) {
				Order data = extractFromResultChulhaDetailSet(rs);
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
			sql = new StringBuilder()
					.append("DELETE FROM mes_order_detail \n")
					.append("WHERE tenant_id='" + JDBCConnectionPool.getTenantId(conn) + "'\n")
					.append("	AND order_no='" + orderNo + "';\n")
					.toString();
			
			logger.debug("sql:\n" + sql);
			
			int j = stmt.executeUpdate(sql);
			
	        if(i == 1 && j >= 1) {
	        	return true;
	        }

	    } catch (SQLException ex) {
	        ex.printStackTrace();
	    }

	    return false;
	}
	
	@Override
	public boolean chulha(Connection conn, Order order) {
		try {
			stmt = conn.createStatement();
			
			String sql = new StringBuilder()
					.append("UPDATE mes_order_detail\n")
					.append("SET chulha_yn = 'Y'\n")
					.append("WHERE tenant_id = '" + JDBCConnectionPool.getTenantId(conn) + "'\n")
					.append("  AND order_no = '" + order.getOrderNo() + "'\n")
					.append("  AND order_detail_no = '" + order.getOrderDetailNo() + "';\n")
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
	public boolean excelInsert(Connection conn, Order order, JSONArray param) {
		
		
		JSONObject jsonObj;
		JSONObject jsonObj2 = (JSONObject) param.get(0);
		
		String sql = "";		
		int k = 0;
		int dtUpdate = 0;
		String orderNo = "";
		String custCd = jsonObj2.get("cust_cd").toString(); // 최초 고객사코드로 초기화
		int detailNo = 0;
		String former = "";
		
		//최초에 주문번호 한번 생성
		NumberGeneratorForCloudMES generator = new NumberGeneratorForCloudMES();
		orderNo = generator.generateOdrNum();
		
		try {
			
			//for(int a = 0; a < param.size(); a++) {
			
			System.out.println("HEAD#########");
			System.out.println(orderNo);
			System.out.println(custCd);
				
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
			ps.setString(2, orderNo);
			ps.setString(3, order.getOrderDate());
			ps.setString(4, custCd);
			
	        int i = ps.executeUpdate();
	        
	        for(k = 0; k < param.size(); k++) {
	        
	        jsonObj = (JSONObject) param.get(k);
	        
	      //이전과 고객사코드가 같을 때는 주문번호 최초 그대로, detail_no + 1 추가
			if(custCd.equals(jsonObj.get("cust_cd").toString())) {
				
				custCd = jsonObj.get("cust_cd").toString();
				
			}
			// 고객사코드가 바뀌었을 때 주문번호 새로 생성 , detail_no 0으로 초기화, head 테이블에 insert 해준다.
			else {
				
				orderNo = generator.generateOdrNum();
				custCd = jsonObj.get("cust_cd").toString();
				detailNo = 0;
				
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

				PreparedStatement ps3 = conn.prepareStatement(sql);
				
				ps3.setString(1, JDBCConnectionPool.getTenantId(conn));
				ps3.setString(2, orderNo);
				ps3.setString(3, order.getOrderDate());
				ps3.setString(4, custCd);
				
		        int l = ps3.executeUpdate();
				
			}
	        
	        System.out.println("BODY#########");
			System.out.println(orderNo);
			System.out.println(detailNo);
			System.out.println(jsonObj.get("prod_cd").toString());
			System.out.println(jsonObj.get("order_count").toString());
	        
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
			ps2.setInt(2, detailNo);
			ps2.setString(3, jsonObj.get("prod_cd").toString());
			ps2.setString(4, jsonObj.get("order_count").toString());
			ps2.setString(5, "N");
			ps2.setString(6, orderNo);
			
	        int j = ps2.executeUpdate();
	        
	        	if(j == 1) {
	        		dtUpdate += 1;
	        		detailNo += 1;
	        	}
	        
	        }
	        
	        if(i == 1 && dtUpdate >= 1) {
	        	return true;
	        }
		  //} // if(former, after end)
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
		
		//order.setOrderNo(rs.getString("order_no"));
		//order.setOrderDetailNo(rs.getString("order_detail_no"));
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
	
	private Order extractFromResultChulhaDetailSet(ResultSet rs) throws SQLException {
		
		Order order = new Order();
		
		order.setOrderNo(rs.getString("order_no"));
		order.setOrderDetailNo(rs.getString("order_detail_no"));
		order.setProductId(rs.getString("product_id"));
		order.setProductName(rs.getString("product_name"));
		order.setOrderCount(rs.getString("order_count"));
		order.setChulhaYn(rs.getString("chulha_yn"));
		
		return order;
	}
	
}
