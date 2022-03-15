package viewmodel;

public class CCPDataMonitoringModel {
	private String sensorName;
	private String ccpDate;
	private String countAll;
	private String countDetect;
	
	public String getSensorName() {
		return sensorName;
	}
	public void setSensorName(String sensorName) {
		this.sensorName = sensorName;
	}
	public String getCcpDate() {
		return ccpDate;
	}
	public void setCcpDate(String ccpDate) {
		this.ccpDate = ccpDate;
	}
	public String getCountAll() {
		return countAll;
	}
	public void setCountAll(String countAll) {
		this.countAll = countAll;
	}
	public String getCountDetect() {
		return countDetect;
	}
	public void setCountDetect(String countDetect) {
		this.countDetect = countDetect;
	}
	
}
