package mes.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;

import mes.model.DailyPlanDetail;

public class DailyPlanDetailDaoImpl implements DailyPlanDetailDao {
	@Override
	public List<DailyPlanDetail> getAllDailyPlanDetails(Connection conn) {
		
		try {
			Statement stmt = conn.createStatement();
			
			String sql = new StringBuilder()
					.append("SELECT																\n")
					.append("	prod_plan_date,													\n")
					.append("	plan_rev_no,													\n")
					.append("	prod_cd,														\n")
					.append("	prod_rev_no,													\n")
					.append("	plan_amount,													\n")
					.append("	real_amount,													\n")
					.append("	prod_journal_note,												\n")
					.append("	work_ordered_yn,												\n")
					.append("	plan_storage_mapper,											\n")
					.append("	plan_type														\n")
					.append("FROM																\n")
					.append("	tbi_production_plan_daily_detail A								\n")
					.append("WHERE plan_rev_no = (SELECT MAX(plan_rev_no)						\n")
					.append("					  FROM tbi_production_plan_daily_detail B		\n")
					.append("					  WHERE A.prod_plan_date = B.prod_plan_date)	\n")
					.toString();
			
			ResultSet rs = stmt.executeQuery(sql);
			
			List<DailyPlanDetail> planList = new ArrayList<DailyPlanDetail>();
			
			if(rs.next()) {
				DailyPlanDetail detailedPlan = extractPlanDetailFromResultSet(rs);
				planList.add(detailedPlan);
			}
			
			return planList;
			
		} catch (SQLException ex) {
			ex.printStackTrace();
		}
		
		return null;
	};
	
	@Override
	public DailyPlanDetail getDailyPlanDetail(Connection conn, String planDate) {
		
		try {
			
			String sql = new StringBuilder()
					.append("SELECT																\n")
					.append("	prod_plan_date,													\n")
					.append("	plan_rev_no,													\n")
					.append("	prod_cd,														\n")
					.append("	prod_rev_no,													\n")
					.append("	plan_amount,													\n")
					.append("	real_amount,													\n")
					.append("	prod_journal_note,												\n")
					.append("	work_ordered_yn,												\n")
					.append("	plan_storage_mapper,											\n")
					.append("	plan_type														\n")
					.append("FROM																\n")
					.append("	tbi_production_plan_daily_detail A								\n")
					.append("WHERE 																\n")
					.append("	prod_plan_date = ?												\n")
					.append("	AND plan_rev_no = (SELECT MAX(plan_rev_no)						\n")
					.append("				       FROM tbi_production_plan_daily_detail B		\n")
					.append("					   WHERE A.prod_plan_date = B.prod_plan_date)	\n")
					.toString();
			
			PreparedStatement ps = conn.prepareStatement(sql);
			ps.setString(1, planDate);
			
			ResultSet rs = ps.executeQuery();
			
			DailyPlanDetail detailedPlan = new DailyPlanDetail();
					
			if(rs.next()) {
				detailedPlan = extractPlanDetailFromResultSet(rs);
			}
			
			return detailedPlan;
			
		} catch (SQLException ex) {
			ex.printStackTrace();
		}
		
		return null;
	};
	
	@Override
	public boolean updateDailyPlanDetail(Connection conn, DailyPlanDetail detailedPlan) {
		return false;
	};
	
	@Override
	public boolean deleteDailyPlanDetail(Connection conn, DailyPlanDetail detailedPlan) {
		
	    try {
	    	String sql = new StringBuilder()
	    			.append("DELETE FROM tbi_production_plan_daily_detail	\n")
	    			.append("WHERE prod_plan_date = ?						\n")
	    			.append("	AND plan_rev_no = ?							\n")
	    			.append("	AND prod_cd = ?								\n")
	    			.append("	AND prod_rev_no = ?							\n")
	    			.toString();

			PreparedStatement ps = conn.prepareStatement(sql);
			
			ps.setString(1, detailedPlan.getPlanDate());
			ps.setInt(2, detailedPlan.getPlanRevNo());
			ps.setString(3, detailedPlan.getProdCd());
			ps.setInt(4, detailedPlan.getProdRevNo());
			
	        int i = ps.executeUpdate();

	        if(i == 1) {
	        	return true;
	        }

	    } catch (SQLException ex) {
	        ex.printStackTrace();
	    }

	    return false;
	};
	
	private DailyPlanDetail extractPlanDetailFromResultSet(ResultSet rs) throws SQLException {
		DailyPlanDetail detailedPlan = new DailyPlanDetail();
		
		detailedPlan.setPlanDate(rs.getString("prod_plan_date"));
		detailedPlan.setPlanRevNo(rs.getInt("plan_rev_no"));
		detailedPlan.setProdCd(rs.getString("prod_cd"));
		detailedPlan.setProdRevNo(rs.getInt("prod_rev_no"));
		detailedPlan.setPlanAmount(rs.getInt("plan_amount"));
		detailedPlan.setRealAmount(rs.getInt("real_amount"));
		detailedPlan.setProdJournalNote(rs.getString("prod_journal_note"));
		detailedPlan.setIfWorkOrdered(rs.getString("work_ordered_yn"));
		detailedPlan.setPlanStorageMapper(rs.getString("plan_storage_mapper"));
		detailedPlan.setPlanType(rs.getString("plan_type"));

	    return detailedPlan;
	}
}
