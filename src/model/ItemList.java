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
	
	public String getSensorId() {
		return sensorId;
	}
	public String getSensorName() {
		return sensorName;
	}
	public void setSensorId(String sensorId) {
		this.sensorId = sensorId;
	}
	public void setSensorName(String sensorName) {
		this.sensorName = sensorName;
	}

	@Override
	public String toString() {
		return "ItemList [sensorId=" + sensorId + ", sensorName=" + sensorName + "]";
	}
	
	
}
