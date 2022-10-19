package viewmodel;

public class KPIProductionViewModel {
	private String sensorKey;
	private String startTime;
	private String finishTime;
	private String productName;
	private String spentTime;
	private String totalProduction;
	private String productionPerMinute;
	public String getSensorKey() {
		return sensorKey;
	}
	public String getStartTime() {
		return startTime;
	}
	public String getFinishTime() {
		return finishTime;
	}
	public String getProductName() {
		return productName;
	}
	public String getSpentTime() {
		return spentTime;
	}
	public String getTotalProduction() {
		return totalProduction;
	}
	public String getProductionPerMinute() {
		return productionPerMinute;
	}
	public void setSensorKey(String sensorKey) {
		this.sensorKey = sensorKey;
	}
	public void setStartTime(String startTime) {
		this.startTime = startTime;
	}
	public void setFinishTime(String finishTime) {
		this.finishTime = finishTime;
	}
	public void setProductName(String productName) {
		this.productName = productName;
	}
	public void setSpentTime(String spentTime) {
		this.spentTime = spentTime;
	}
	public void setTotalProduction(String totalProduction) {
		this.totalProduction = totalProduction;
	}
	public void setProductionPerMinute(String productionPerMinute) {
		this.productionPerMinute = productionPerMinute;
	}
	
	@Override
	public String toString() {
		return "KPIProductionViewModel [sensorKey=" + sensorKey + ", startTime=" + startTime + ", finishTime="
				+ finishTime + ", productName=" + productName + ", spentTime=" + spentTime + ", totalProduction="
				+ totalProduction + ", productionPerMinute=" + productionPerMinute + "]";
	}
}
