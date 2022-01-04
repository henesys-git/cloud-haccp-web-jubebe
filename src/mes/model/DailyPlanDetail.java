package mes.model;

public class DailyPlanDetail {
	private String planDate;
	private int planRevNo;
	private String prodCd;
	private int prodRevNo;
	private int planAmount;
	private int realAmount;
	private String prodJournalNote;
	private String ifWorkOrdered;
	private String planStorageMapper;
	private String planType;
	
	public DailyPlanDetail() {
	}

	public DailyPlanDetail(String planDate, int planRevNo, String prodCd, 
			int prodRevNo, int planAmount, int realAmount,
			String prodJournalNote, String ifWorkOrdered, 
			String planStorageMapper, String planType) {
		super();
		this.planDate = planDate;
		this.planRevNo = planRevNo;
		this.prodCd = prodCd;
		this.prodRevNo = prodRevNo;
		this.planAmount = planAmount;
		this.realAmount = realAmount;
		this.prodJournalNote = prodJournalNote;
		this.ifWorkOrdered = ifWorkOrdered;
		this.planStorageMapper = planStorageMapper;
		this.planType = planType;
	}

	public String getPlanDate() {
		return planDate;
	}

	public void setPlanDate(String planDate) {
		this.planDate = planDate;
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

	public int getPlanAmount() {
		return planAmount;
	}

	public void setPlanAmount(int planAmount) {
		this.planAmount = planAmount;
	}

	public int getRealAmount() {
		return realAmount;
	}

	public void setRealAmount(int realAmount) {
		this.realAmount = realAmount;
	}

	public String getProdJournalNote() {
		return prodJournalNote;
	}

	public void setProdJournalNote(String prodJournalNote) {
		this.prodJournalNote = prodJournalNote;
	}

	public String isIfWorkOrdered() {
		return ifWorkOrdered;
	}

	public void setIfWorkOrdered(String ifWorkOrdered) {
		this.ifWorkOrdered = ifWorkOrdered;
	}

	public String getPlanStorageMapper() {
		return planStorageMapper;
	}

	public void setPlanStorageMapper(String planStorageMapper) {
		this.planStorageMapper = planStorageMapper;
	}

	public String getPlanType() {
		return planType;
	}

	public void setPlanType(String planType) {
		this.planType = planType;
	}

}