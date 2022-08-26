package model;

public class Sensor {
	private String sensorId;
	private String sensorName;
	private String valueType;
	private String ipAddress;
	private String protocolInfo;
	private String packetInfo;
	private String typeCode;
	private String checklistId;
	
	public Sensor() {}
	
	public Sensor(String sensorId, String sensorName, 
				  String valueType, String ipAddress, String protocolInfo, 
				  String packetInfo, String typeCode, String checklistId) {
		super();
		this.sensorId = sensorId;
		this.sensorName = sensorName;
		this.valueType = valueType;
		this.ipAddress = ipAddress;
		this.protocolInfo = protocolInfo;
		this.packetInfo = packetInfo;
		this.typeCode = typeCode;
		this.checklistId = checklistId;
	}
	
	public String getSensorId() {
		return sensorId;
	}
	public String getSensorName() {
		return sensorName;
	}
	public String getValueType() {
		return valueType;
	}
	public String getIpAddress() {
		return ipAddress;
	}
	public String getProtocolInfo() {
		return protocolInfo;
	}
	public String getPacketInfo() {
		return packetInfo;
	}
	public String getTypeCode() {
		return typeCode;
	}
	public String getChecklistId() {
		return checklistId;
	}
	public void setSensorId(String sensorId) {
		this.sensorId = sensorId;
	}
	public void setSensorName(String sensorName) {
		this.sensorName = sensorName;
	}
	public void setValueType(String valueType) {
		this.valueType = valueType;
	}
	public void setIpAddress(String ipAddress) {
		this.ipAddress = ipAddress;
	}
	public void setProtocolInfo(String protocolInfo) {
		this.protocolInfo = protocolInfo;
	}
	public void setPacketInfo(String packetInfo) {
		this.packetInfo = packetInfo;
	}
	public void setTypeCode(String typeCode) {
		this.typeCode = typeCode;
	}
	public void setChecklistId(String checklistId) {
		this.checklistId = checklistId;
	}
}
