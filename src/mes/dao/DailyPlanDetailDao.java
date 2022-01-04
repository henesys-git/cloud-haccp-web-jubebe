package mes.dao;

import java.sql.Connection;
import java.util.List;

import mes.model.DailyPlanDetail;

public interface DailyPlanDetailDao {
	public List<DailyPlanDetail> getAllDailyPlanDetails(Connection conn);
	public DailyPlanDetail getDailyPlanDetail(Connection conn, String planDate);
	public boolean updateDailyPlanDetail(Connection conn, DailyPlanDetail detailedPlan);
	public boolean deleteDailyPlanDetail(Connection conn, DailyPlanDetail detailedPlan);
}