package model;

public class ItemList {
	private String sensorId;
	private String sensorName;
	
	public ItemList() {}
	
	public ItemList(String sensorId, String sensorName) {
		super();
		this.sensorId = sensorId;
		this.sensorName = sensorName;
	}
	
	public String getMetalSensorId() {
		return sensorId;
	}
	public String getMetalSensorName() {
		return sensorName;
	}
	public void setMetalSensorId(String metalSensorId) {
		this.sensorId = metalSensorId;
	}
	public void setMetalSensorName(String metalSensorName) {
		this.sensorName = metalSensorName;
	}

	@Override
	public String toString() {
		return "ItemList [sensorId=" + sensorId + ", sensorName=" + sensorName + "]";
	}
	
	
}
