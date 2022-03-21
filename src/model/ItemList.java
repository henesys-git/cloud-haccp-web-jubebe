package model;

public class ItemList {
	private String metalSensorId;
	private String metalSensorName;
	
	public ItemList() {}
	
	public ItemList(String metalSensorId, String metalSensorName) {
		super();
		this.metalSensorId = metalSensorId;
		this.metalSensorName = metalSensorName;
	}
	
	public String getMetalSensorId() {
		return metalSensorId;
	}
	
	public String getMetalSensorName() {
		return metalSensorName;
	}
	
	public void setMetalSensorId(String metalSensorId) {
		this.metalSensorId = metalSensorId;
	}

	public void setMetalSensorName(String metalSensorName) {
		this.metalSensorName = metalSensorName;
	}

	@Override
	public String toString() {
		return "ItemList [metalSensorId=" + metalSensorId + ", metalSensorName=" + metalSensorName + "]";
	}

	
	
}
