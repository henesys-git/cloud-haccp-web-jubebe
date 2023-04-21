package mes.model;

public class ChecklistSign {
	private String checklistId;
	private String checklistName;
	private String signWriter;
	private String signChecker;
	private String signApprover;
	private String signColumns;
	public String getChecklistId() {
		return checklistId;
	}
	public String getChecklistName() {
		return checklistName;
	}
	public String getSignWriter() {
		return signWriter;
	}
	public String getSignChecker() {
		return signChecker;
	}
	public String getSignApprover() {
		return signApprover;
	}
	public String getSignColumns() {
		return signColumns;
	}
	public void setChecklistId(String checklistId) {
		this.checklistId = checklistId;
	}
	public void setChecklistName(String checklistName) {
		this.checklistName = checklistName;
	}
	public void setSignWriter(String signWriter) {
		this.signWriter = signWriter;
	}
	public void setSignChecker(String signChecker) {
		this.signChecker = signChecker;
	}
	public void setSignApprover(String signApprover) {
		this.signApprover = signApprover;
	}
	public void setSignColumns(String signColumns) {
		this.signColumns = signColumns;
	}
	@Override
	public String toString() {
		return "ChecklistSign [checklistId=" + checklistId + ", checklistName=" + checklistName + ", signWriter="
				+ signWriter + ", signChecker=" + signChecker + ", signApprover=" + signApprover + "]";
	}
	
	
}

