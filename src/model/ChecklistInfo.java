package model;

public class ChecklistInfo {
	private String checklistId;
	private int revisionNo;
	private String checklistName;
	private String imagePath;
	private String metaDataFilePath;
	
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
	public String getMetaDataFilePath() {
		return metaDataFilePath;
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
	
	@Override
	public String toString() {
		return "ChecklistInfo [checklistId=" + checklistId + ", revisionNo=" + revisionNo + ", checklistName="
				+ checklistName + ", imagePath=" + imagePath + ", metaDataFilePath=" + metaDataFilePath + "]";
	}
}
