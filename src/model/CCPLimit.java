package model;

public class CCPLimit {
	private String eventCode;
	private String productId;
	private double minValue;
	private double maxValue;
	private String valueUnit;
	
	public String getEventCode() {
		return eventCode;
	}
	public String getProductId() {
		return productId;
	}
	public double getMinValue() {
		return minValue;
	}
	public double getMaxValue() {
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
	public void setMinValue(double minValue) {
		this.minValue = minValue;
	}
	public void setMaxValue(double maxValue) {
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
