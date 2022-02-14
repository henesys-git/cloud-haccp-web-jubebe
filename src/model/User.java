package model;

public class User {
	private String userId;
	private String userName;
	private String password;
	private String authority;
	
	public String getUserId() {
		return userId;
	}
	public String getUserName() {
		return userName;
	}
	public String getAuthority() {
		return authority;
	}
	public void setUserId(String userId) {
		this.userId = userId;
	}
	public String getPassword() {
		return password;
	}
	public void setPassword(String password) {
		this.password = password;
	}
	public void setUserName(String userName) {
		this.userName = userName;
	}
	public void setAuthority(String authority) {
		this.authority = authority;
	}
}
