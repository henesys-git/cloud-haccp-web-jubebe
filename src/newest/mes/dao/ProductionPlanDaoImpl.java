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
import newest.mes.model.ProductionPlan;
import viewmodel.ProductViewModel;

public class ProductionPlanDaoImpl implements ProductionPlanDao {
	
	private Statement stmt;
	private ResultSet rs;
	
	static final Logger logger = 
			Logger.getLogger(ProductionPlanDaoImpl.class.getName());
	
	public ProductionPlanDaoImpl() {
	}

	@Override
	public List<ProductionPlan> getAllPlans(Connection conn) {
		
		try {
			stmt = conn.createStatement();
			
			String sql = new StringBuilder()
				.append("SELECT  		\n")
				.append("A.plan_no,		\n")
				.append("A.plan_date, 	\n")
				.append("A.product_id, 	\n")
				.append("A.plan_count, 	\n")
				.append("A.order_yn, 	\n")
				.append("A.customer_code, \n")
				.append("B.customer_name, \n")
				.append("C.product_name \n")
				.append("FROM mes_production_plan A	\n")
				.append("INNER JOIN mes_product_customer B	\n")
				.append("ON A.customer_code = B.customer_code \n")
				.append("INNER JOIN product C	\n")
				.append("ON A.product_id = C.product_id \n")
				.append("WHERE A.tenant_id = '" + JDBCConnectionPool.getTenantId(conn) + "'\n")
				.toString();
			
			logger.debug("sql:\n" + sql);
			
			rs = stmt.executeQuery(sql);
			
			List<ProductionPlan> list = new ArrayList<ProductionPlan>();
			
			while(rs.next()) {
				ProductionPlan data = extractFromResultSet(rs);
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
				//order = extractFromResultSet(rs);
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
	public boolean insert(Connection conn, ProductionPlan plan) {
		
		String sql = "";		
		
		try {
			sql = new StringBuilder()
					.append("INSERT INTO\n")
					.append("	mes_production_plan (\n")
					.append("		tenant_id, \n")
					.append("		plan_no,\n")
					.append("		plan_date,\n")
					.append("		product_id, \n")
					.append("		plan_count, \n")
					.append("		order_no, \n")
					.append("		customer_code, \n")
					.append("		order_yn \n")
					.append("	)\n")
					.append("VALUES\n")
					.append("	(\n")
					.append("		?,\n")
					.append("		?,\n")
					.append("		?,\n")
					.append("		?,\n")
					.append("		?,\n")
					.append("		?,\n")
					.append("		?,\n")
					.append("		? \n")
					.append("	);\n")
					.toString();

			PreparedStatement ps = conn.prepareStatement(sql);
			
			ps.setString(1, JDBCConnectionPool.getTenantId(conn));
			ps.setString(2, plan.getPlanNo());
			ps.setString(3, plan.getPlanDate());
			ps.setString(4, plan.getProductId());
			ps.setString(5, plan.getPlanCount());
			ps.setString(6, plan.getOrderNo());
			ps.setString(7, plan.getCustomerCode());
			ps.setString(8, "Y");
			
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
	public boolean update(Connection conn, ProductionPlan plan) {
		try {
			stmt = conn.createStatement();
			
			String sql = new StringBuilder()
					.append("UPDATE mes_production_plan\n")
					.append("SET plan_count ='" + plan.getPlanCount() + "',\n")
					.append("plan_date ='" + plan.getPlanDate() + "'\n")
					.append("WHERE tenant_id='" + JDBCConnectionPool.getTenantId(conn) + "'\n")
					.append("  AND plan_no='" + plan.getPlanNo() + "' \n")
					.append("  AND product_id='" + plan.getProductId() + "';\n")
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
	public boolean delete(Connection conn, String planNo) {
		
		String sql = "";
		
		try {
			stmt = conn.createStatement();
			
			sql = new StringBuilder()
					.append("DELETE FROM mes_production_plan \n")
					.append("WHERE tenant_id='" + JDBCConnectionPool.getTenantId(conn) + "'\n")
					.append("	AND plan_no='" + planNo + "';\n")
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
	public boolean instructionInsert(Connection conn, String instructionDate, String productId, String planNo, String instructionCount) {
		
		String sql = "";		
		
		try {
			
			stmt = conn.createStatement();
			
			sql = new StringBuilder()
					.append("INSERT INTO\n")
					.append("	mes_production_instruction (\n")
					.append("		tenant_id, \n")
					.append("		plan_no,\n")
					.append("		work_line_no,\n")
					.append("		plan_count_allocated,\n")
					.append("		work_date,\n")
					.append("		work_start_time,\n")
					.append("		work_finish_time,\n")
					.append("		packing_count,\n")
					.append("		worker_count,\n")
					.append("		rawmaterial_deduct_yn,\n")
					.append("		work_status,\n")
					.append("		ipgo_yn \n")
					.append("	)\n")
					.append("VALUES\n")
					.append("	(\n")
					.append("		'" + JDBCConnectionPool.getTenantId(conn) + "',\n")
					.append("		'" + planNo + "', \n")
					.append("		1 ,\n")
					.append("		'" + instructionCount + "', \n")
					.append("		'" + instructionDate + "', \n")
					.append("		SYSDATETIME,\n")
					.append("		SYSDATETIME,\n")
					.append("		0,\n")
					.append("		1,\n")
					.append("		'',\n")
					.append("		'생산완료',\n")
					.append("		'N' \n")
					.append("	);\n")
					.toString();

			
	        int i = stmt.executeUpdate(sql);
	        
	        if(i == 1) {
	        	return true;
	        }

	    } catch (SQLException ex) {
	        ex.printStackTrace();
	    }

	    return false;
	}
	
	
	private ProductionPlan extractFromResultSet(ResultSet rs) throws SQLException {
		
		ProductionPlan plan = new ProductionPlan();
		
		plan.setPlanNo(rs.getString("plan_no"));
		plan.setPlanDate(rs.getString("plan_date"));
		plan.setProductId(rs.getString("product_id"));
		plan.setPlanCount(rs.getString("plan_count"));
		plan.setCustomerCode(rs.getString("customer_code"));
		plan.setOrderYn(rs.getString("order_yn"));
		plan.setCustomerName(rs.getString("customer_name"));
		plan.setProductName(rs.getString("product_name"));
		
		return plan;
	}
	
	private Order extractFromResultDetailSet(ResultSet rs) throws SQLException {
		
		Order order = new Order();
		
		order.setProductId(rs.getString("product_id"));
		order.setOrderCount(rs.getString("order_count"));
		order.setChulhaYn(rs.getString("chulha_yn"));
		
		return order;
	}
	
}
