package viewmodel;

public class CCPDataHeadViewModel {
	private String sensorKey;
	private String ccpType;
	private String productName;
	private String createTime;
	private String judge;
	private String improvementCompletion;
	
	public String getSensorKey() {
		return sensorKey;
	}
	public void setSensorKey(String sensorKey) {
		this.sensorKey = sensorKey;
	}
	public String getCcpType() {
		return ccpType;
	}
	public void setCcpType(String ccpType) {
		this.ccpType = ccpType;
	}
	public String getProductName() {
		return productName;
	}
	public void setProductName(String productName) {
		this.productName = productName;
	}
	public String getCreateTime() {
		return createTime;
	}
	public void setCreateTime(String createTime) {
		this.createTime = createTime;
	}
	public String getJudge() {
		return judge;
	}
	public void setJudge(String judge) {
		this.judge = judge;
	}
	public String getImprovementCompletion() {
		return improvementCompletion;
	}
	public void setImprovementCompletion(String improvementCompletion) {
		this.improvementCompletion = improvementCompletion;
	}
}
