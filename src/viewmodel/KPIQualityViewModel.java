package viewmodel;

public class KPIQualityViewModel {
	private String sensorKey;
	private String dataMonth;
	private String productName;
	private String totalCount;
	private String totalDetection;
	
	public String getSensorKey() {
		return sensorKey;
	}
	public void setSensorKey(String sensorKey) {
		this.sensorKey = sensorKey;
	}
	public String getDataMonth() {
		return dataMonth;
	}
	public void setDataMonth(String dataMonth) {
		this.dataMonth = dataMonth;
	}
	public String getProductName() {
		return productName;
	}
	public void setProductName(String productName) {
		this.productName = productName;
	}
	public String getTotalCount() {
		return totalCount;
	}
	public void setTotalCount(String totalCount) {
		this.totalCount = totalCount;
	}
	public String getTotalDetection() {
		return totalDetection;
	}
	public void setTotalDetection(String totalDetection) {
		this.totalDetection = totalDetection;
	}
	
	@Override
	public String toString() {
		return "KPIQualityViewModel [sensorKey=" + sensorKey + ", dataMonth=" + dataMonth + ", productName="
				+ productName + ", totalCount=" + totalCount + ", totalDetection=" + totalDetection + "]";
	}
	
	
	
}
