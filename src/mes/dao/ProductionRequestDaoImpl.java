package mes.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;

import mes.model.ProductionRequest;

public class ProductionRequestDaoImpl implements ProductionRequestDao {
	@Override
	public List<ProductionRequest> getAllProductionRequests(Connection conn) {
		
		try {
			Statement stmt = conn.createStatement();
			
			String sql = new StringBuilder()
					.append("SELECT																	\n")
					.append("	manufacturing_date,													\n")
					.append("	request_rev_no,														\n")
					.append("	prod_plan_date,														\n")
					.append("	plan_rev_no,														\n")
					.append("	prod_cd,															\n")
					.append("	prod_rev_no,														\n")
					.append("	expiration_date,													\n")
					.append("	loss_rate,															\n")
					.append("	work_status,														\n")
					.append("	note,																\n")
					.append("	user_id,															\n")
					.append("	user_rev_no,														\n")
					.append("	work_start_time,													\n")
					.append("	work_end_time														\n")
					.append("FROM																	\n")
					.append("	tbi_production_request A											\n")
					.append("WHERE																	\n")
					.append("	request_rev_no = (SELECT MAX(request_rev_no)						\n")
					.append("					  FROM tbi_production_request B						\n")
					.append("				      WHERE A.manufacturing_date = B.manufacturing_date	\n")
					.append("					    AND A.prod_plan_date = B.prod_plan_date			\n")
					.append("					    AND A.plan_rev_no = B.plan_rev_no				\n")
					.append("					    AND A.prod_cd = B.prod_cd						\n")
					.append("					    AND A.prod_rev_no = B.prod_rev_no)				\n")
					.toString();
			
			ResultSet rs = stmt.executeQuery(sql);
			
			List<ProductionRequest> productionRequestList = new ArrayList<ProductionRequest>();
			
			if(rs.next()) {
				ProductionRequest productionRequest = extractProductionRequestFromResultSet(rs);
				productionRequestList.add(productionRequest);
			}
			
			return productionRequestList;
			
		} catch (SQLException ex) {
			ex.printStackTrace();
		}
		
		return null;
	};
	
	@Override
	public ProductionRequest getProductionRequest(Connection conn, 
			String manufacturingDate, String planDate, String prodCd) {
		
		try {
			
			String sql = new StringBuilder()
					.append("SELECT																	\n")
					.append("	manufacturing_date,													\n")
					.append("	request_rev_no,														\n")
					.append("	prod_plan_date,														\n")
					.append("	plan_rev_no,														\n")
					.append("	prod_cd,															\n")
					.append("	prod_rev_no,														\n")
					.append("	expiration_date,													\n")
					.append("	loss_rate,															\n")
					.append("	work_status,														\n")
					.append("	note,																\n")
					.append("	user_id,															\n")
					.append("	user_rev_no,														\n")
					.append("	work_start_time,													\n")
					.append("	work_end_time														\n")
					.append("FROM																	\n")
					.append("	tbi_production_request A											\n")
					.append("WHERE																	\n")
					.append("	manufacturing_date = ?												\n")
					.append("	palnDate= ?															\n")
					.append("	prodCd = ?															\n")
					.append("	request_rev_no = (SELECT MAX(request_rev_no)						\n")
					.append("					  FROM tbi_production_request B						\n")
					.append("				      WHERE A.manufacturing_date = B.manufacturing_date	\n")
					.append("					    AND A.prod_plan_date = B.prod_plan_date			\n")
					.append("					    AND A.plan_rev_no = B.plan_rev_no				\n")
					.append("					    AND A.prod_cd = B.prod_cd						\n")
					.append("					    AND A.prod_rev_no = B.prod_rev_no)				\n")
					.toString();
			
			PreparedStatement ps = conn.prepareStatement(sql);
			
			ps.setString(1, manufacturingDate);
			ps.setString(2, planDate);
			ps.setString(3, prodCd);
			
			ResultSet rs = ps.executeQuery();
			
			ProductionRequest productionRequest = new ProductionRequest();
					
			if(rs.next()) {
				productionRequest = extractProductionRequestFromResultSet(rs);
			}
			
			return productionRequest;
			
		} catch (SQLException ex) {
			ex.printStackTrace();
		}
		
		return null;
	};
	
	@Override
	public boolean saveProductionRequest(Connection conn, ProductionRequest productionRequest) {
		
	    try {
	    	String sql = new StringBuilder()
	    			.append("INSERT INTO\n")
	    			.append("	tbi_production_request (\n")
	    			.append("		manufacturing_date,\n")
	    			.append("		request_rev_no,\n")
	    			.append("		prod_plan_date,\n")
	    			.append("		plan_rev_no,\n")
	    			.append("		prod_cd,\n")
	    			.append("		prod_rev_no,\n")
	    			.append("		expiration_date,\n")
	    			.append("		loss_rate,\n")
	    			.append("		work_status,\n")
	    			.append("		note,\n")
	    			.append("		user_id,\n")
	    			.append("		user_rev_no,\n")
	    			.append("		work_start_time,\n")
	    			.append("		work_end_time\n")
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
	    			.append("		?,\n")
	    			.append("		?,\n")
	    			.append("		?,\n")
	    			.append("		?,\n")
	    			.append("		?,\n")
	    			.append("		?,\n")
	    			.append("		?\n")
	    			.append("	);\n")
	    			.toString();

			PreparedStatement ps = conn.prepareStatement(sql);
			
			ps.setString(1, productionRequest.getManufacturingDate());
			ps.setInt(2, productionRequest.getRequestRevNo());
			ps.setString(3, productionRequest.getProdPlanDate());
			ps.setInt(4, productionRequest.getPlanRevNo());
			ps.setString(5, productionRequest.getProdCd());
			ps.setInt(6, productionRequest.getProdRevNo());
			ps.setString(7, productionRequest.getExpirationDate());
			ps.setString(8, productionRequest.getLossRate());
			ps.setString(9, productionRequest.getWorkStatus());
			ps.setString(10, productionRequest.getNote());
			ps.setString(11, productionRequest.getUserId());
			ps.setInt(12, productionRequest.getUserRevNo());
			ps.setString(13, productionRequest.getWorkStartTime());
			ps.setString(14, productionRequest.getWorkEndTime());
			
	        int i = ps.executeUpdate();

	        if(i == 1) {
	        	return true;
	        }

	    } catch (SQLException ex) {
	        ex.printStackTrace();
	    }

	    return false;
	};
	
	@Override
	public boolean updateProductionRequest(Connection conn, ProductionRequest productionRequest) {
		return false;
	};
	
	@Override
	public boolean deleteProductionRequest(Connection conn, ProductionRequest productionRequest) {
		
	    try {
	    	String sql = new StringBuilder()
	    			.append("DELETE FROM				\n")
	    			.append("	tbi_production_request	\n")
	    			.append("WHERE						\n")
	    			.append("	manufacturing_date = ?	\n")
	    			.append("	AND request_rev_no = ?	\n")
	    			.append("	AND prod_plan_date = ?	\n")
	    			.append("	AND plan_rev_no = ?		\n")
	    			.append("	AND prod_cd = ?			\n")
	    			.append("	AND prod_rev_no = ?;	\n")
	    			.toString();

			PreparedStatement ps = conn.prepareStatement(sql);
			
			ps.setString(1, productionRequest.getManufacturingDate());
			ps.setInt(2, productionRequest.getRequestRevNo());
			ps.setString(3, productionRequest.getProdPlanDate());
			ps.setInt(4, productionRequest.getPlanRevNo());
			ps.setString(5, productionRequest.getProdCd());
			ps.setInt(6, productionRequest.getProdRevNo());
			
	        int i = ps.executeUpdate();

	        if(i == 1) {
	        	return true;
	        }

	    } catch (SQLException ex) {
	        ex.printStackTrace();
	    }

	    return false;
	};
	
	private ProductionRequest extractProductionRequestFromResultSet(ResultSet rs) throws SQLException {
		ProductionRequest productionRequest = new ProductionRequest();
		
		productionRequest.setManufacturingDate(rs.getString("manufacturing_date"));
		productionRequest.setRequestRevNo(rs.getInt("request_rev_no"));
		productionRequest.setProdPlanDate(rs.getString("prod_plan_date"));
		productionRequest.setPlanRevNo(rs.getInt("plan_rev_no"));
		productionRequest.setProdCd(rs.getString("prod_cd"));
		productionRequest.setProdRevNo(rs.getInt("prod_rev_no"));
		productionRequest.setExpirationDate(rs.getString("expiration_date"));
		productionRequest.setLossRate(rs.getString("loss_rate"));
		productionRequest.setWorkStatus(rs.getString("work_status"));
		productionRequest.setNote(rs.getString("note"));
		productionRequest.setUserId(rs.getString("user_id"));
		productionRequest.setUserRevNo(rs.getInt("user_rev_no"));
		productionRequest.setWorkStartTime(rs.getString("work_start_time"));
		productionRequest.setWorkEndTime(rs.getString("work_end_time"));

	    return productionRequest;
	}
}
