package model;

public class Notice {
	private String registerDatetime;
	private String noticeTitle;
	private String noticeContent;
	private String active;
	
	public Notice() {}
	
	public Notice(String registerDatetime, String noticeTitle, String noticeContent, String active) {
		super();
		this.registerDatetime = registerDatetime;
		this.noticeTitle = noticeTitle;
		this.noticeContent = noticeContent;
		this.active = active;
	}

	public String getRegisterDatetime() {
		return registerDatetime;
	}

	public String getNoticeTitle() {
		return noticeTitle;
	}

	public String getNoticeContent() {
		return noticeContent;
	}

	public String getActive() {
		return active;
	}

	public void setRegisterDatetime(String registerDatetime) {
		this.registerDatetime = registerDatetime;
	}

	public void setNoticeTitle(String noticeTitle) {
		this.noticeTitle = noticeTitle;
	}

	public void setNoticeContent(String noticeContent) {
		this.noticeContent = noticeContent;
	}

	public void setActive(String active) {
		this.active = active;
	}

	@Override
	public String toString() {
		return "Notice [registerDatetime=" + registerDatetime + ", noticeTitle=" + noticeTitle + ", noticeContent="
				+ noticeContent + ", active=" + active + "]";
	}
}
