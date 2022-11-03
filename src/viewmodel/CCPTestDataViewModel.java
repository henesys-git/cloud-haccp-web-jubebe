package viewmodel;

public class CCPTestDataViewModel {
	private String productName;
	private String sensorKey;
	private String createTime;
	private String eventCode;
	private String sensorValue;
	private String minValue;
	private String maxValue;
	
	public String getProductName() {
		return productName;
	}
	public String getSensorKey() {
		return sensorKey;
	}
	public String getCreateTime() {
		return createTime;
	}
	public String getEventCode() {
		return eventCode;
	}
	public String getSensorValue() {
		return sensorValue;
	}
	public void setProductName(String productName) {
		this.productName = productName;
	}
	public void setSensorKey(String sensorKey) {
		this.sensorKey = sensorKey;
	}
	public void setCreateTime(String createTime) {
		this.createTime = createTime;
	}
	public void setEventCode(String eventCode) {
		this.eventCode = eventCode;
	}
	public void setSensorValue(String sensorValue) {
		this.sensorValue = sensorValue;
	}
	public String getMinValue() {
		return minValue;
	}
	public void setMinValue(String minValue) {
		this.minValue = minValue;
	}
	public String getMaxValue() {
		return maxValue;
	}
	public void setMaxValue(String maxValue) {
		this.maxValue = maxValue;
	}
	
}
