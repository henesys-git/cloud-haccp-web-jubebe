package model;

public class ChecklistInfo {
	private String checklistId;
	private int revisionNo;
	private String checklistName;
	private String imagePath;
	private String metaDataFilePath;
	private int checkInterval;
	private String signatureType;
	
	public ChecklistInfo() {}
	
	public ChecklistInfo(String checklistId, 
			int revisionNo, 
			String checklistName, 
			String imagePath,
			String metaDataFilePath) {
		super();
		this.checklistId = checklistId;
		this.revisionNo = revisionNo;
		this.checklistName = checklistName;
		this.imagePath = imagePath;
		this.metaDataFilePath = metaDataFilePath;
	}

	public ChecklistInfo(String checklistId, 
			String checklistName, 
			String imagePath,
			String metaDataFilePath) {
		super();
		this.checklistId = checklistId;
		this.checklistName = checklistName;
		this.imagePath = imagePath;
		this.metaDataFilePath = metaDataFilePath;
	}
	
	public ChecklistInfo(String checklistId) {
		super();
		this.checklistId = checklistId;
	}
	
	public String getChecklistId() {
		return checklistId;
	}
	public int getRevisionNo() {
		return revisionNo;
	}
	public String getChecklistName() {
		return checklistName;
	}
	public String getImagePath() {
		return imagePath;
	}
	public int getCheckInterval() {
		return checkInterval;
	}
	public String getMetaDataFilePath() {
		return metaDataFilePath;
	}
	public String getSignatureType() {
		return signatureType;
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
	public void setImagePath(String imagePath) {
		this.imagePath = imagePath;
	}
	public void setMetaDataFilePath(String metaDataFilePath) {
		this.metaDataFilePath = metaDataFilePath;
	}
	public void setCheckInterval(int checkInterval) {
		this.checkInterval = checkInterval;
	}
	public void setSignatureType(String signatureType) {
		this.signatureType = signatureType;
	}

	@Override
	public String toString() {
		return "ChecklistInfo [checklistId=" + checklistId + ", revisionNo=" + revisionNo + ", checklistName="
				+ checklistName + ", imagePath=" + imagePath + ", metaDataFilePath=" + metaDataFilePath + "]";
	}
}
