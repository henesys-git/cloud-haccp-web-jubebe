package model;

public class CommonCode {
	private String commonCodeId;
	private String commonCodeName;
	private String commonCodeType;
	
	public CommonCode() {}
	
	public CommonCode(String commonCodeId, String commonCodeName, String commonCodeType) {
		super();
		this.commonCodeId = commonCodeId;
		this.commonCodeName = commonCodeName;
		this.commonCodeType = commonCodeType;
	}

	public String getCommonCodeId() {
		return commonCodeId;
	}
	public String getCommonCodeName() {
		return commonCodeName;
	}
	public String getCommonCodeType() {
		return commonCodeType;
	}
	public void setCommonCodeId(String commonCodeId) {
		this.commonCodeId = commonCodeId;
	}
	public void setCommonCodeName(String commonCodeName) {
		this.commonCodeName = commonCodeName;
	}
	public void setCommonCodeType(String commonCodeType) {
		this.commonCodeType = commonCodeType;
	}
	
	
}
