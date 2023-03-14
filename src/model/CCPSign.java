package model;

public class CCPSign {
	private String signDate;
	private String processCode;
	private String checkerId;
	private String signType;
	private String userName;
	
	public String getSignDate() {
		return signDate;
	}
	public String getProcessCode() {
		return processCode;
	}
	public String getCheckerId() {
		return checkerId;
	}
	public String getSignType() {
		return signType;
	}
	public String getUserName() {
		return userName;
	}
	public void setSignDate(String signDate) {
		this.signDate = signDate;
	}
	public void setProcessCode(String processCode) {
		this.processCode = processCode;
	}
	public void setCheckerId(String checkerId) {
		this.checkerId = checkerId;
	}
	public void setSignType(String signType) {
		this.signType = signType;
	}
	public void setUserName(String userName) {
		this.userName = userName;
	}
}