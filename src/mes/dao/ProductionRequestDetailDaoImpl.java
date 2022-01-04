package mes.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;

import mes.model.ProductionRequestDetail;

public class ProductionRequestDetailDaoImpl implements ProductionRequestDetailDao {
	@Override
	public List<ProductionRequestDetail> getAllProductionRequestDetails(Connection conn) {
		
		try {
			Statement stmt = conn.createStatement();
			
			String sql = new StringBuilder()
					.append("SELECT\n")
					.append("	manufacturing_date,\n")
					.append("	request_rev_no,\n")
					.append("	prod_plan_date,\n")
					.append("	plan_rev_no,\n")
					.append("	prod_cd,\n")
					.append("	prod_rev_no,\n")
					.append("	part_cd,\n")
					.append("	part_rev_no,\n")
					.append("	bom_rev_no,\n")
					.append("	blending_amount_plan,\n")
					.append("	blending_amount_real,\n")
					.append("	reason_diff\n")
					.append("FROM\n")
					.append("	tbi_production_request_detail A\n")
					.append("WHERE\n")
					.append("	request_rev_no = (SELECT MAX(request_rev_no)\n")
					.append("						    FROM tbi_production_request_detail B\n")
					.append("						    WHERE A.manufacturing_date = B.manufacturing_date\n")
					.append("					            AND A.prod_plan_date = B.prod_plan_date\n")
					.append("					            AND A.plan_rev_no = B.plan_rev_no\n")
					.append("					            AND A.prod_cd = B.prod_cd\n")
					.append("					            AND A.prod_rev_no = B.prod_rev_no\n")
					.append("					            AND A.part_cd = B.part_cd\n")
					.append("					            AND A.part_rev_no = B.part_rev_no\n")
					.append("					            AND A.bom_rev_no = B.bom_rev_no)\n")
					.toString();

			ResultSet rs = stmt.executeQuery(sql);
			
			List<ProductionRequestDetail> list = new ArrayList<ProductionRequestDetail>();
			
			if(rs.next()) {
				ProductionRequestDetail productionRequestDetail 
									= extractProductionRequestDetailFromResultSet(rs);
				list.add(productionRequestDetail);
			}
			
			return list;
			
		} catch (SQLException ex) {
			ex.printStackTrace();
		}
		
		return null;
	};
	
	@Override
	public ProductionRequestDetail getProductionRequestDetail(Connection conn, 
							String manufacturingDate, String planDate, String prodCd, String partCd) {
		
		try {
			String sql = new StringBuilder()
					.append("SELECT								\n")
					.append("	manufacturing_date,				\n")
					.append("	request_rev_no,					\n")
					.append("	prod_plan_date,					\n")
					.append("	plan_rev_no,					\n")
					.append("	prod_cd,						\n")
					.append("	prod_rev_no,					\n")
					.append("	part_cd,						\n")
					.append("	part_rev_no,					\n")
					.append("	bom_rev_no,						\n")
					.append("	blending_amount_plan,			\n")
					.append("	blending_amount_real,			\n")
					.append("	reason_diff						\n")
					.append("FROM								\n")
					.append("	tbi_production_request_detail	\n")
					.append("WHERE								\n")
					.append("	manufacturing_date = ?			\n")
					.append("	AND prod_plan_date = ?			\n")
					.append("	AND prod_cd = ?					\n")
					.append("	AND part_cd = ?;				\n")
					.toString();
			
			PreparedStatement ps = conn.prepareStatement(sql);
			
			ps.setString(1, manufacturingDate);
			ps.setString(2, planDate);
			ps.setString(3, prodCd);
			ps.setString(4, partCd);
			
			ResultSet rs = ps.executeQuery();
			
			ProductionRequestDetail prd = new ProductionRequestDetail();
					
			if(rs.next()) {
				prd = extractProductionRequestDetailFromResultSet(rs);
			}
			
			return prd;
			
		} catch (SQLException ex) {
			ex.printStackTrace();
		}
		
		return null;
	};
	
	@Override
	public boolean saveProductionRequestDetail(Connection conn, ProductionRequestDetail prd) {
		
	    try {
	    	String sql = new StringBuilder()
	    			.append("INSERT INTO\n")
	    			.append("	tbi_production_request_detail (\n")
	    			.append("		manufacturing_date,\n")
	    			.append("		request_rev_no,\n")
	    			.append("		prod_plan_date,\n")
	    			.append("		plan_rev_no,\n")
	    			.append("		prod_cd,\n")
	    			.append("		prod_rev_no,\n")
	    			.append("		part_cd,\n")
	    			.append("		part_rev_no,\n")
	    			.append("		bom_rev_no,\n")
	    			.append("		blending_amount_plan,\n")
	    			.append("		blending_amount_real,\n")
	    			.append("		reason_diff\n")
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
	    			.append("		?\n")
	    			.append("	);\n")
	    			.toString();

			PreparedStatement ps = conn.prepareStatement(sql);
			
			ps.setString(1, prd.getManufacturingDate());
			ps.setInt(2, prd.getRequestRevNo());
			ps.setString(3, prd.getProdPlanDate());
			ps.setInt(4, prd.getPlanRevNo());
			ps.setString(5, prd.getProdCd());
			ps.setInt(6, prd.getProdRevNo());
			ps.setString(7, prd.getPartCd());
			ps.setInt(8, prd.getPartRevNo());
			ps.setInt(9, prd.getBomRevNo());
			ps.setFloat(10, prd.getBlendingAmountPlan());
			ps.setFloat(11, prd.getBlendingAmountReal());
			ps.setString(12, prd.getReasonDiff());
			
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
	public boolean updateProductionRequestDetail(Connection conn, ProductionRequestDetail prd) {
		return false;
	};
	
	@Override
	public boolean deleteProductionRequestDetail(Connection conn, ProductionRequestDetail prd) {
		
	    try {
	    	String sql = new StringBuilder()
	    			.append("DELETE FROM						\n")
	    			.append("	tbi_production_request_detail	\n")
	    			.append("WHERE								\n")
	    			.append("	manufacturing_date = ?			\n")
	    			.append("	AND request_rev_no = ?			\n")
	    			.append("	AND prod_plan_date = ?			\n")
	    			.append("	AND plan_rev_no = ?				\n")
	    			.append("	AND prod_cd = ?					\n")
	    			.append("	AND prod_rev_no = ?				\n")
	    			.append("	AND part_cd = ?					\n")
	    			.append("	AND part_rev_no = ?				\n")
	    			.append("	AND bom_rev_no = ?;				\n")
	    			.toString();

			PreparedStatement ps = conn.prepareStatement(sql);
			
			ps.setString(1, prd.getManufacturingDate());
			ps.setInt(2, prd.getRequestRevNo());
			ps.setString(3, prd.getProdPlanDate());
			ps.setInt(4, prd.getPlanRevNo());
			ps.setString(5, prd.getProdCd());
			ps.setInt(6, prd.getProdRevNo());
			ps.setString(7, prd.getPartCd());
			ps.setInt(8, prd.getPartRevNo());
			ps.setInt(9, prd.getBomRevNo());
			
	        int i = ps.executeUpdate();

	        if(i == 1) {
	        	return true;
	        }

	    } catch (SQLException ex) {
	        ex.printStackTrace();
	    }

	    return false;
	};
	
	private ProductionRequestDetail extractProductionRequestDetailFromResultSet(ResultSet rs) throws SQLException {
		ProductionRequestDetail prd = new ProductionRequestDetail();
		
		prd.setManufacturingDate(rs.getString("manufacturing_date"));
		prd.setRequestRevNo(rs.getInt("request_rev_no"));
		prd.setProdPlanDate(rs.getString("prod_plan_date"));
		prd.setPlanRevNo(rs.getInt("plan_rev_no"));
		prd.setProdCd(rs.getString("prod_cd"));
		prd.setProdRevNo(rs.getInt("prod_rev_no"));
		prd.setPartCd(rs.getString("part_cd"));
		prd.setPartRevNo(rs.getInt("part_rev_no"));
		prd.setBomRevNo(rs.getInt("bom_rev_no"));
		prd.setBlendingAmountPlan(rs.getFloat("blending_amount_plan"));
		prd.setBlendingAmountReal(rs.getFloat("blending_amount_real"));
		prd.setReasonDiff(rs.getString("reason_diff"));

	    return prd;
	}
}
