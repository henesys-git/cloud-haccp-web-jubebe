package mes.model;

import java.util.List;

public class DailyPlan {
	private String planDate;
	private List<DailyPlanDetail> detailedPlans;
	
	public DailyPlan() {
	}
	
	public DailyPlan(String planDate) {
		this.planDate = planDate;
	}
	
	public DailyPlan(String planDate, List<DailyPlanDetail> detailedPlans) {
		this.planDate = planDate;
		this.detailedPlans = detailedPlans;
	}

	public List<DailyPlanDetail> getDetailedPlans() {
		return detailedPlans;
	}

	public void setDetailedPlans(List<DailyPlanDetail> detailedPlans) {
		this.detailedPlans = detailedPlans;
	}

	public String getPlanDate() {
		return planDate;
	}
	
	public void setPlanDate(String planDate) {
		this.planDate = planDate;
	}
}
