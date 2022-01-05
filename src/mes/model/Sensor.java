package mes.model;

public class Sensor {
	private String sensorId;
	private String sensorName;
	private double valueMax;
	private double valueMin;
	private String valueType;
	private String ipAddress;
	private String protocolInfo;
	private String packetInfo;
	private String typeCode;
	
	public String getSensorId() {
		return sensorId;
	}
	public String getSensorName() {
		return sensorName;
	}
	public double getValueMax() {
		return valueMax;
	}
	public double getValueMin() {
		return valueMin;
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
	public void setSensorId(String sensorId) {
		this.sensorId = sensorId;
	}
	public void setSensorName(String sensorName) {
		this.sensorName = sensorName;
	}
	public void setValueMax(double valueMax) {
		this.valueMax = valueMax;
	}
	public void setValueMin(double valueMin) {
		this.valueMin = valueMin;
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
}
