package mes.model;

public class ChecklistAlarm {
	private String checklistId;
	private int revisionNo;
	private String checklistName;
	private String checkInterVal;
	private String timeDiff;
	private String alarmYear;
	private String alarmMonth;
	private String alarmDay;
	private String alarmHour;
	
	public String getChecklistId() {
		return checklistId;
	}
	public int getRevisionNo() {
		return revisionNo;
	}
	public String getChecklistName() {
		return checklistName;
	}
	public String getCheckInterVal() {
		return checkInterVal;
	}
	public String getTimeDiff() {
		return timeDiff;
	}
	public String getAlarmYear() {
		return alarmYear;
	}
	public String getAlarmMonth() {
		return alarmMonth;
	}
	public String getAlarmDay() {
		return alarmDay;
	}
	public String getAlarmHour() {
		return alarmHour;
	}
	public void setChecklistId(String checklistId) {
		this.checklistId = checklistId;
	}
	public void setRevisionNo(int revisionNo) {
		this.revisionNo = revisionNo;
	}
	public void setChecklistName(String checklistName) {
		this.checklistName = checklistName;
	}
	public void setCheckInterVal(String checkInterVal) {
		this.checkInterVal = checkInterVal;
	}
	public void setLatestCheckDate(String timeDiff) {
		this.timeDiff = timeDiff;
	}
	public void setAlarmYear(String alarmYear) {
		this.alarmYear = alarmYear;
	}
	public void setAlarmMonth(String alarmMonth) {
		this.alarmMonth = alarmMonth;
	}
	public void setAlarmDay(String alarmDay) {
		this.alarmDay = alarmDay;
	}
	public void setAlarmHour(String alarmHour) {
		this.alarmHour = alarmHour;
	}
	
	@Override
	public String toString() {
		return "ChecklistAlarm [checklistId=" + checklistId + ", revisionNo=" + revisionNo + ", checklistName="
				+ checklistName + ", checkInterVal=" + checkInterVal + ", timeDiff=" + timeDiff + ", alarmYear="
				+ alarmYear + ", alarmMonth=" + alarmMonth + ", alarmDay=" + alarmDay + ", alarmHour=" + alarmHour
				+ "]";
	}
	
}

