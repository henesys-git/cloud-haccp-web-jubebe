package viewmodel;

public class CCPDataHeadViewModel {
	private String sensorKey;
	private String processName;
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
	public String getProcessName() {
		return processName;
	}
	public void setProcessName(String processName) {
		this.processName = processName;
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
