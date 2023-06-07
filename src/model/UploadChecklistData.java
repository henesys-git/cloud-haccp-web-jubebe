package model;

public class UploadChecklistData {
	private String documentId;
	private int seqNo;
	private int revisionNo;
	private String documentData;
	private String registDate;
	private String bigo;
	
	public String getDocumentId() {
		return documentId;
	}
	public int getSeqNo() {
		return seqNo;
	}
	public int getRevisionNo() {
		return revisionNo;
	}
	public String getDocumentData() {
		return documentData;
	}
	public String getRegistDate() {
		return registDate;
	}
	public String getBigo() {
		return bigo;
	}
	public void setDocumentId(String documentId) {
		this.documentId = documentId;
	}
	public void setSeqNo(int seqNo) {
		this.seqNo = seqNo;
	}
	public void setRevisionNo(int revisionNo) {
		this.revisionNo = revisionNo;
	}
	public void setDocumentData(String documentData) {
		this.documentData = documentData;
	}
	public void setRegistDate(String registDate) {
		this.registDate = registDate;
	}
	public void setBigo(String bigo) {
		this.bigo = bigo;
	}
	
	
}
