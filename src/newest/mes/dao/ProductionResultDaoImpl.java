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
import newest.mes.model.ProductionResult;
import viewmodel.ProductViewModel;

public class ProductionResultDaoImpl implements ProductionResultDao {
	
	private Statement stmt;
	private ResultSet rs;
	
	static final Logger logger = 
			Logger.getLogger(ProductionResultDaoImpl.class.getName());
	
	public ProductionResultDaoImpl() {
	}

	@Override
	public List<ProductionResult> getAllResults(Connection conn) {
		
		try {
			stmt = conn.createStatement();
			
			String sql = new StringBuilder()
				.append("SELECT  		\n")
				.append("A.plan_no,		\n")
				.append("A.work_line_no, 	\n")
				.append("A.plan_count_allocated, 	\n")
				.append("A.work_date, 	\n")
				.append("A.work_start_time, 	\n")
				.append("A.work_finish_time, \n")
				.append("A.packing_count, \n")
				.append("A.worker_count, \n")
				.append("A.rawmaterial_deduct_yn, \n")
				.append("A.work_status, \n")
				.append("A.ipgo_yn, \n")
				.append("C.product_name, \n")
				.append("B.product_id \n")
				.append("FROM mes_production_instruction A	\n")
				.append("INNER JOIN mes_production_plan B	\n")
				.append("ON A.plan_no = B.plan_no \n")
				.append("INNER JOIN product C	\n")
				.append("ON B.product_id = C.product_id \n")
				.append("WHERE A.tenant_id = '" + JDBCConnectionPool.getTenantId(conn) + "'\n")
				.toString();
			
			logger.debug("sql:\n" + sql);
			
			rs = stmt.executeQuery(sql);
			
			List<ProductionResult> list = new ArrayList<ProductionResult>();
			
			while(rs.next()) {
				ProductionResult data = extractFromResultSet(rs);
				list.add(data);
			}
			
			return list;
			
		} catch (SQLException ex) {
			ex.printStackTrace();
		} finally {
		    try { rs.close(); } catch (Exception e) { /* Ignored */ }
		    try { stmt.close(); } catch (Exception e) { /* Ig2222222222222222222222222222222222222222222222222nored */ }
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
	public boolean packingUpdate(Connection conn, String packingCount, String planNo) {
		try {
			stmt = conn.createStatement();
			
			String sql = new StringBuilder()
					.append("UPDATE mes_production_instruction\n")
					.append("SET packing_count ='" + packingCount + "' \n")
					.append("WHERE tenant_id='" + JDBCConnectionPool.getTenantId(conn) + "'\n")
					.append("  AND plan_no='" + planNo + "' \n")
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
	public List<ProductionResult> getPackingCountDB(Connection conn, String prod_cd) {
		
		try {
			stmt = conn.createStatement();
			
			String sql = new StringBuilder()
				.append("SELECT  		\n")
				.append("data_date, \n")
				.append("prev_product_id, \n")
				.append("prev_product_cnt, \n")
				.append("cur_product_id, \n")
				.append("cur_product_cnt \n")
				.append("FROM mes_packing_data	\n")
				.append("WHERE A.tenant_id = '" + JDBCConnectionPool.getTenantId(conn) + "'\n")
				.append("AND A.cur_product_id = '" + prod_cd + "' \n")
				.append("ORDER BY data_date DESC \n")
				.append("LIMIT 1 \n")
				.toString();
			
			logger.debug("sql:\n" + sql);
			
			rs = stmt.executeQuery(sql);
			
			List<ProductionResult> list = new ArrayList<ProductionResult>();
			
			while(rs.next()) {
				ProductionResult data = extractFromResultPackingCountDB(rs);
				list.add(data);
			}
			
			return list;
			
		} catch (SQLException ex) {
			ex.printStackTrace();
		} finally {
		    try { rs.close(); } catch (Exception e) { /* Ignored */ }
		    try { stmt.close(); } catch (Exception e) { /* Ig2222222222222222222222222222222222222222222222222nored */ }
		}
		
		return null;
	};
	
	
	private ProductionResult extractFromResultSet(ResultSet rs) throws SQLException {
		
		ProductionResult result = new ProductionResult();
		
		result.setPlanNo(rs.getString("plan_no"));
		result.setWorkLineNo(rs.getString("work_line_no"));
		result.setPlanCountAllocated(rs.getString("plan_count_allocated"));
		result.setWorkDate(rs.getString("work_date"));
		result.setWorkStartTime(rs.getString("work_start_time"));
		result.setWorkFinishTime(rs.getString("work_finish_time"));
		result.setPackingCount(rs.getString("packing_count"));
		result.setWorkerCount(rs.getString("worker_count"));
		result.setRawMaterialDeductYn(rs.getString("rawmaterial_deduct_yn"));
		result.setWorkStatus(rs.getString("work_status"));
		result.setIpgoYn(rs.getString("ipgo_yn"));
		result.setProductName(rs.getString("product_name"));
		result.setProductId(rs.getString("product_id"));
		
		return result;
	}
	
	private Order extractFromResultDetailSet(ResultSet rs) throws SQLException {
		
		Order order = new Order();
		
		order.setProductId(rs.getString("product_id"));
		order.setOrderCount(rs.getString("order_count"));
		order.setChulhaYn(rs.getString("chulha_yn"));
		
		return order;
	}
	
	private ProductionResult extractFromResultPackingCountDB(ResultSet rs) throws SQLException {
		
		ProductionResult result = new ProductionResult();
		
		result.setDataDate(rs.getString("data_date"));
		result.setPrevProductId(rs.getString("prev_product_id"));
		result.setPrevProductCnt(rs.getString("prev_product_cnt"));
		result.setCurProductId(rs.getString("cur_product_id"));
		result.setCurProductCnt(rs.getString("cur_product_cnt"));
		
		return result;
	}
	
}
