package mes.model;

public class ChecklistAlarm {
	private String checklistId;
	private int revisionNo;
	private String checklistName;
	private String checkInterVal;
	private String latestCheckDate;
	
	public String getChecklistId() {
		return checklistId;
	}
	public int getRevisionNo() {
		return revisionNo;
	}
	public String getChecklistName() {
		return checklistName;
	}
	public String getCheckInterVal() {
		return checkInterVal;
	}
	public String getLatestCheckDate() {
		return latestCheckDate;
	}
	public void setChecklistId(String checklistId) {
		this.checklistId = checklistId;
	}
	public void setRevisionNo(int revisionNo) {
		this.revisionNo = revisionNo;
	}
	public void setChecklistName(String checklistName) {
		this.checklistName = checklistName;
	}
	public void setCheckInterVal(String checkInterVal) {
		this.checkInterVal = checkInterVal;
	}
	public void setLatestCheckDate(String latestCheckDate) {
		this.latestCheckDate = latestCheckDate;
	}
	
	@Override
	public String toString() {
		return "ChecklistAlarm [checklistId=" + checklistId + ", revisionNo=" + revisionNo + ", checklistName="
				+ checklistName + ", checkInterVal=" + checkInterVal + ", latestCheckDate=" + latestCheckDate + "]";
	}
}

