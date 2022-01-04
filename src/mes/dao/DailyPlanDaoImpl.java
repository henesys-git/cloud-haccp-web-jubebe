package mes.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;

import mes.model.DailyPlan;

public class DailyPlanDaoImpl implements DailyPlanDao {
	@Override
	public List<DailyPlan> getAllDailyPlans(Connection conn) {
		
		try {
			Statement stmt = conn.createStatement();
			
			String sql = new StringBuilder()
				.append("SELECT * 								\n")
				.append("FROM tbm_bom_info2 					\n")
				.append("WHERE SYSDATE BETWEEN start_date		\n")
				.append("  				   AND duration_date	\n")
				.toString();
			
			ResultSet rs = stmt.executeQuery(sql);
			
			List<DailyPlan> planList = new ArrayList<DailyPlan>();
			
			if(rs.next()) {
				DailyPlan plan = extractPlanFromResultSet(rs);
				planList.add(plan);
			}
			
			return planList;
			
		} catch (SQLException ex) {
			ex.printStackTrace();
		}
		
		return null;
	};
	
	@Override
	public DailyPlan getDailyPlan(Connection conn, String planDate) {
		
		try {
			String sql = new StringBuilder()
					.append("SELECT *							\n")
					.append("FROM tbi_production_plan_daily		\n")
					.append("WHERE prod_plan_date = ?			\n")
					.append("  AND SYSDATE BETWEEN start_date	\n")
					.append("  				AND duration_date	\n")
					.toString();

			PreparedStatement ps = conn.prepareStatement(sql);
			
			ps.setString(1, planDate);
			
			ResultSet rs = ps.executeQuery();
			
			DailyPlan plan = new DailyPlan();
			
			if(rs.next()) {
				plan = extractPlanFromResultSet(rs);
			}
			
			return plan;
			
		} catch (SQLException ex) {
			ex.printStackTrace();
		}
		
		return null;
	};
	
	@Override
	public boolean updateDailyPlan(Connection conn, DailyPlan plan) {
		return false;
	};
	
	@Override
	public boolean deleteDailyPlan(Connection conn, DailyPlan plan) {
		
	    try {
	    	String sql = new StringBuilder()
					.append("UPDATE tbi_production_plan_daily	\n")
					.append("SET delyn = 'Y'					\n")
					.append("WHERE prod_plan_date = ?			\n")
					.toString();

			PreparedStatement ps = conn.prepareStatement(sql);
			
			ps.setString(1, plan.getPlanDate());
			
	        int i = ps.executeUpdate();

	        if(i == 1) {
	        	return true;
	        }

	    } catch (SQLException ex) {
	        ex.printStackTrace();
	    }

	    return false;
	};
	
	private DailyPlan extractPlanFromResultSet(ResultSet rs) throws SQLException {
		DailyPlan plan = new DailyPlan();
		
		plan.setPlanDate(rs.getString("prod_plan_date"));

	    return plan;
	}
	
}
