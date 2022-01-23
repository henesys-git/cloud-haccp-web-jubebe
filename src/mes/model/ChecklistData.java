package mes.model;

public class ChecklistData {
	private String checklistId;
	private int seqNo;
	private int revisionNo;
	private String checkData;
	private String signWriter;
	private String signChecker;
	
	private String signApprover;
	
	public String getChecklistId() {
		return checklistId;
	}
	public int getSeqNo() {
		return seqNo;
	}
	public int getRevisionNo() {
		return revisionNo;
	}
	public String getCheckData() {
		return checkData;
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
	public void setChecklistId(String checklistId) {
		this.checklistId = checklistId;
	}
	public void setSeqNo(int seqNo) {
		this.seqNo = seqNo;
	}
	public void setRevisionNo(int revisionNo) {
		this.revisionNo = revisionNo;
	}
	public void setCheckData(String checkData) {
		this.checkData = checkData;
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
	
	@Override
	public String toString() {
		return "ChecklistData [checklistId=" + checklistId + ", seqNo=" + seqNo + ", revisionNo=" + revisionNo
				+ ", checkData=" + checkData + ", signWriter=" + signWriter + ", signChecker=" + signChecker
				+ ", signApprover=" + signApprover + "]";
	}
}
