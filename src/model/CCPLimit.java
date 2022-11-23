package model;

public class CCPLimit {
	private String eventCode;
	private String productId;
	private String minValue;
	private String maxValue;
	private String valueUnit;
	
	public String getEventCode() {
		return eventCode;
	}
	public String getProductId() {
		return productId;
	}
	public String getMinValue() {
		return minValue;
	}
	public String getMaxValue() {
		return maxValue;
	}
	public String getValueUnit() {
		return valueUnit;
	}
	public void setEventCode(String eventCode) {
		this.eventCode = eventCode;
	}
	public void setProductId(String productId) {
		this.productId = productId;
	}
	public void setMinValue(String minValue) {
		this.minValue = minValue;
	}
	public void setMaxValue(String maxValue) {
		this.maxValue = maxValue;
	}
	public void setValueUnit(String valueUnit) {
		this.valueUnit = valueUnit;
	}
	
	@Override
	public String toString() {
		return "CCPLimit [eventCode=" + eventCode + ", productId=" + productId + ", minValue=" + minValue
				+ ", maxValue=" + maxValue + ", valueUnit=" + valueUnit + "]";
	}
}
