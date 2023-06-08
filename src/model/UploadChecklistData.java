package model;

public class UploadChecklistData {
	private String uploadChecklistId;
	private int seqNo;
	private int revisionNo;
	private String uploadChecklistData;
	private String registDate;
	private String bigo;
	
	
	public int getSeqNo() {
		return seqNo;
	}
	public int getRevisionNo() {
		return revisionNo;
	}
	public String getRegistDate() {
		return registDate;
	}
	public String getBigo() {
		return bigo;
	}
	public void setSeqNo(int seqNo) {
		this.seqNo = seqNo;
	}
	public void setRevisionNo(int revisionNo) {
		this.revisionNo = revisionNo;
	}
	public void setRegistDate(String registDate) {
		this.registDate = registDate;
	}
	public void setBigo(String bigo) {
		this.bigo = bigo;
	}
	public String getUploadChecklistId() {
		return uploadChecklistId;
	}
	public void setUploadChecklistId(String uploadChecklistId) {
		this.uploadChecklistId = uploadChecklistId;
	}
	public String getUploadChecklistData() {
		return uploadChecklistData;
	}
	public void setUploadChecklistData(String uploadChecklistData) {
		this.uploadChecklistData = uploadChecklistData;
	}
	
	
}
