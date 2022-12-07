package viewmodel;

public class CCPTestDataHeadViewModel {
	private String createDate;
	private String sensorId;
	private String sensorName;
	private String productId;
	private String parentId;
	private String parentName;
	
	public String getCreateDate() {
		return createDate;
	}
	public String getSensorId() {
		return sensorId;
	}
	public String getSensorName() {
		return sensorName;
	}
	public void setCreateDate(String createDate) {
		this.createDate = createDate;
	}
	public void setSensorId(String sensorId) {
		this.sensorId = sensorId;
	}
	public void setSensorName(String sensorName) {
		this.sensorName = sensorName;
	}
	public String getProductId() {
		return productId;
	}
	public void setProductId(String productId) {
		this.productId = productId;
	}
	public String getParentName() {
		return parentName;
	}
	public void setParentName(String parentName) {
		this.parentName = parentName;
	}
	public String getParentId() {
		return parentId;
	}
	public void setParentId(String parentId) {
		this.parentId = parentId;
	}
	
}
