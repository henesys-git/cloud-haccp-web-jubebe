package model;

public class Limit {
	private String eventCode;
	private String objectId;
	private String minValue;
	private String maxValue;
	private String valueUnit;
	private String eventName;
	private String objectName;
	
	public Limit() {}

	public Limit(String eventCode, String objectId, 
			  String minValue, String maxValue, String valueUnit) {
	super();
	this.eventCode = eventCode;
	this.objectId = objectId;
	this.minValue = minValue;
	this.maxValue = maxValue;
	this.valueUnit = valueUnit;
}
	
	
	public String getEventCode() {
		return eventCode;
	}
	public void setEventCode(String eventCode) {
		this.eventCode = eventCode;
	}
	public String getObjectId() {
		return objectId;
	}
	public void setObjectId(String objectId) {
		this.objectId = objectId;
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
	public String getValueUnit() {
		return valueUnit;
	}
	public void setValueUnit(String valueUnit) {
		this.valueUnit = valueUnit;
	}
	public String getEventName() {
		return eventName;
	}
	public void setEventName(String eventName) {
		this.eventName = eventName;
	}
	public String getObjectName() {
		return objectName;
	}
	public void setObjectName(String objectName) {
		this.objectName = objectName;
	}
	
}
