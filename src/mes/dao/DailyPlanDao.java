package mes.dao;

import java.sql.Connection;
import java.util.List;

import mes.model.DailyPlan;

public interface DailyPlanDao {
	public List<DailyPlan> getAllDailyPlans(Connection conn);
	public DailyPlan getDailyPlan(Connection conn, String planDate);
	public boolean updateDailyPlan(Connection conn, DailyPlan plan);
	public boolean deleteDailyPlan(Connection conn, DailyPlan plan);
}