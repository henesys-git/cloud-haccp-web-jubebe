package mes.model;

public class CCPData {
	private String sensorKey;
	private int seqNo;
	private String createTime;
	private String sensorId;
	private String sensorValue;
	private String improvementCode;
	private String userId;
	private String eventCode;
	private String productId;
	
	public String getSensorKey() {
		return sensorKey;
	}
	public int getSeqNo() {
		return seqNo;
	}
	public String getCreateTime() {
		return createTime;
	}
	public String getSensorId() {
		return sensorId;
	}
	public String getSensorValue() {
		return sensorValue;
	}
	public String getImprovementCode() {
		return improvementCode;
	}
	public String getUserId() {
		return userId;
	}
	public String getEventCode() {
		return eventCode;
	}
	public String getProductId() {
		return productId;
	}
	public void setSensorKey(String sensorKey) {
		this.sensorKey = sensorKey;
	}
	public void setSeqNo(int seqNo) {
		this.seqNo = seqNo;
	}
	public void setCreateTime(String createTime) {
		this.createTime = createTime;
	}
	public void setSensorId(String sensorId) {
		this.sensorId = sensorId;
	}
	public void setSensorValue(String sensorValue) {
		this.sensorValue = sensorValue;
	}
	public void setImprovementCode(String improvementCode) {
		this.improvementCode = improvementCode;
	}
	public void setUserId(String userId) {
		this.userId = userId;
	}
	public void setEventCode(String eventCode) {
		this.eventCode = eventCode;
	}
	public void setProductId(String productId) {
		this.productId = productId;
	}
}
