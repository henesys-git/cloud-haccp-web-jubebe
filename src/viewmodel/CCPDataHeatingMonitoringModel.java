package viewmodel;

public class CCPDataHeatingMonitoringModel {
	private String sensorKey;
	private String sensorName;
	private String productName;
	private String createTime;
	private String completeTime;
	private String state;
	
	public String getSensorKey() {
		return sensorKey;
	}
	public String getSensorName() {
		return sensorName;
	}
	
	public String getProductName() {
		return productName;
	}
	public String getCreateTime() {
		return createTime;
	}
	public void setSensorKey(String sensorKey) {
		this.sensorKey = sensorKey;
	}
	public void setSensorName(String sensorName) {
		this.sensorName = sensorName;
	}
	
	public void setProductName(String productName) {
		this.productName = productName;
	}
	public void setCreateTime(String createTime) {
		this.createTime = createTime;
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
