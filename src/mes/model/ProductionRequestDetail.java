package mes.model;

public class ProductionRequestDetail {
	private String manufacturingDate;
	private int requestRevNo;
	private String prodPlanDate;
	private int planRevNo;
	private String prodCd;
	private int prodRevNo;
	private String partCd;
	private int partRevNo;
	private int bomRevNo;
	private float blendingAmountPlan;
	private float blendingAmountReal;
	private String reasonDiff;
	
	public ProductionRequestDetail() {
	}
	
	public ProductionRequestDetail(String manufacturingDate, int requestRevNo, String prodPlanDate, int planRevNo,
			String prodCd, int prodRevNo, String partCd, int partRevNo, int bomRevNo, float blendingAmountPlan,
			float blendingAmountReal, String reasonDiff) {
		super();
		this.manufacturingDate = manufacturingDate;
		this.requestRevNo = requestRevNo;
		this.prodPlanDate = prodPlanDate;
		this.planRevNo = planRevNo;
		this.prodCd = prodCd;
		this.prodRevNo = prodRevNo;
		this.partCd = partCd;
		this.partRevNo = partRevNo;
		this.bomRevNo = bomRevNo;
		this.blendingAmountPlan = blendingAmountPlan;
		this.blendingAmountReal = blendingAmountReal;
		this.reasonDiff = reasonDiff;
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

	public String getPartCd() {
		return partCd;
	}

	public void setPartCd(String partCd) {
		this.partCd = partCd;
	}

	public int getPartRevNo() {
		return partRevNo;
	}

	public void setPartRevNo(int partRevNo) {
		this.partRevNo = partRevNo;
	}

	public int getBomRevNo() {
		return bomRevNo;
	}

	public void setBomRevNo(int bomRevNo) {
		this.bomRevNo = bomRevNo;
	}

	public float getBlendingAmountPlan() {
		return blendingAmountPlan;
	}

	public void setBlendingAmountPlan(float blendingAmountPlan) {
		this.blendingAmountPlan = blendingAmountPlan;
	}

	public float getBlendingAmountReal() {
		return blendingAmountReal;
	}

	public void setBlendingAmountReal(float blendingAmountReal) {
		this.blendingAmountReal = blendingAmountReal;
	}

	public String getReasonDiff() {
		return reasonDiff;
	}

	public void setReasonDiff(String reasonDiff) {
		this.reasonDiff = reasonDiff;
	}
	
	
}
