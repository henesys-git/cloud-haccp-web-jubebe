package model;

public class LimitOutAlarmMessage {
	private String channelId;
	private String apiToken;
	private String sensorName;
	private String eventName;
	private String processName;
	private double minValue;
	private double maxValue;
	
	public String getChannelId() {
		return channelId;
	}
	public String getApiToken() {
		return apiToken;
	}
	public String getSensorName() {
		return sensorName;
	}
	public String getEventName() {
		return eventName;
	}
	public String getProcessName() {
		return processName;
	}
	public double getMinValue() {
		return minValue;
	}
	public double getMaxValue() {
		return maxValue;
	}
	public void setChannelId(String channelId) {
		this.channelId = channelId;
	}
	public void setApiToken(String apiToken) {
		this.apiToken = apiToken;
	}
	public void setSensorName(String sensorName) {
		this.sensorName = sensorName;
	}
	public void setEventName(String eventName) {
		this.eventName = eventName;
	}
	public void setProcessName(String processName) {
		this.processName = processName;
	}
	public void setMinValue(double minValue) {
		this.minValue = minValue;
	}
	public void setMaxValue(double maxValue) {
		this.maxValue = maxValue;
	}
	
	@Override
	public String toString() {
		return "LimitOutAlarmMessage [channelId=" + channelId + ", apiToken=" + apiToken + ", sensorName=" + sensorName
				+ ", eventName=" + eventName + ", processName=" + processName + ", minValue=" + minValue + ", maxValue="
				+ maxValue + "]";
	}
}
