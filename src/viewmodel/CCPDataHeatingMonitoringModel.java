package viewmodel;

public class CCPDataHeatingMonitoringModel {
	private String sensorKey;
	private String sensorName;
	private String processName;
	private String productName;
	private String createTime;
	private String completeTime;
	private String state;
	private String judge;
	private String improvementCompletion;
	
	public String getSensorKey() {
		return sensorKey;
	}
	public String getSensorName() {
		return sensorName;
	}
	public String getProcessName() {
		return processName;
	}
	public String getProductName() {
		return productName;
	}
	public String getCreateTime() {
		return createTime;
	}
	public String getJudge() {
		return judge;
	}
	public String getImprovementCompletion() {
		return improvementCompletion;
	}
	public void setSensorKey(String sensorKey) {
		this.sensorKey = sensorKey;
	}
	public void setSensorName(String sensorName) {
		this.sensorName = sensorName;
	}
	public void setProcessName(String processName) {
		this.processName = processName;
	}
	public void setProductName(String productName) {
		this.productName = productName;
	}
	public void setCreateTime(String createTime) {
		this.createTime = createTime;
	}
	public void setJudge(String judge) {
		this.judge = judge;
	}
	public void setImprovementCompletion(String improvementCompletion) {
		this.improvementCompletion = improvementCompletion;
	}
	public String getCompleteTime() {
		return completeTime;
	}
	public void setCompleteTime(String completeTime) {
		this.completeTime = completeTime;
	}
	public String getState() {
		return state;
	}
	public void setState(String state) {
		this.state = state;
	}
	
}
