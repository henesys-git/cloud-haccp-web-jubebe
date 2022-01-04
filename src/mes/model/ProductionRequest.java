package mes.model;

public class ProductionRequest {
	private String manufacturingDate;
	private int requestRevNo;
	private String prodPlanDate;
	private int planRevNo;
	private String prodCd;
	private int prodRevNo;
	private String expirationDate;
	private String lossRate;
	private String workStatus;
	private String note;
	private String userId;
	private int userRevNo;
	private String workStartTime;
	private String workEndTime;

	public ProductionRequest() {
	}
	
	public ProductionRequest(String manufacturingDate, int requestRevNo, String prodPlanDate, int planRevNo,
			String prodCd, int prodRevNo, String expirationDate, String lossRate, String workStatus, String note,
			String userId, int userRevNo, String workStartTime, String workEndTime) {
		super();
		this.manufacturingDate = manufacturingDate;
		this.requestRevNo = requestRevNo;
		this.prodPlanDate = prodPlanDate;
		this.planRevNo = planRevNo;
		this.prodCd = prodCd;
		this.prodRevNo = prodRevNo;
		this.expirationDate = expirationDate;
		this.lossRate = lossRate;
		this.workStatus = workStatus;
		this.note = note;
		this.userId = userId;
		this.userRevNo = userRevNo;
		this.workStartTime = workStartTime;
		this.workEndTime = workEndTime;
	}

	public String getManufacturingDate() {
		return manufacturingDate;
	}

	public void setManufacturingDate(String manufacturingDate) {
		this.manufacturingDate = manufacturingDate;
	}

	public int getRequestRevNo() {
		return requestRevNo;
	}

	public void setRequestRevNo(int requestRevNo) {
		this.requestRevNo = requestRevNo;
	}

	public String getProdPlanDate() {
		return prodPlanDate;
	}

	public void setProdPlanDate(String prodPlanDate) {
		this.prodPlanDate = prodPlanDate;
	}

	public int getPlanRevNo() {
		return planRevNo;
	}

	public void setPlanRevNo(int planRevNo) {
		this.planRevNo = planRevNo;
	}

	public String getProdCd() {
		return prodCd;
	}

	public void setProdCd(String prodCd) {
		this.prodCd = prodCd;
	}

	public int getProdRevNo() {
		return prodRevNo;
	}

	public void setProdRevNo(int prodRevNo) {
		this.prodRevNo = prodRevNo;
	}

	public String getExpirationDate() {
		return expirationDate;
	}

	public void setExpirationDate(String expirationDate) {
		this.expirationDate = expirationDate;
	}

	public String getLossRate() {
		return lossRate;
	}

	public void setLossRate(String lossRate) {
		this.lossRate = lossRate;
	}

	public String getWorkStatus() {
		return workStatus;
	}

	public void setWorkStatus(String workStatus) {
		this.workStatus = workStatus;
	}

	public String getNote() {
		return note;
	}

	public void setNote(String note) {
		this.note = note;
	}

	public String getUserId() {
		return userId;
	}

	public void setUserId(String userId) {
		this.userId = userId;
	}

	public int getUserRevNo() {
		return userRevNo;
	}

	public void setUserRevNo(int userRevNo) {
		this.userRevNo = userRevNo;
	}

	public String getWorkStartTime() {
		return workStartTime;
	}

	public void setWorkStartTime(String workStartTime) {
		this.workStartTime = workStartTime;
	}

	public String getWorkEndTime() {
		return workEndTime;
	}

	public void setWorkEndTime(String workEndTime) {
		this.workEndTime = workEndTime;
	}

}
