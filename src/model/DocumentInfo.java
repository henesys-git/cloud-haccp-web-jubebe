package model;

public class DocumentInfo {
	private String documentId;
	private int revisionNo;
	private String documentName;
	
	public String getDocumentId() {
		return documentId;
	}
	public int getRevisionNo() {
		return revisionNo;
	}
	public String getDocumentName() {
		return documentName;
	}
	public void setDocumentId(String documentId) {
		this.documentId = documentId;
	}
	public void setRevisionNo(int revisionNo) {
		this.revisionNo = revisionNo;
	}
	public void setDocumentName(String documentName) {
		this.documentName = documentName;
	}
	
	public DocumentInfo() {}
	
	
}
