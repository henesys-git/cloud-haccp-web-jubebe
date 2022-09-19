package model;

public class User {
	private String userId;
	private String userName;
	private String password;
	private String authority;
	
	public User() {}
	
	public User(String userId, String userName, String password, String authority) {
		super();
		this.userId = userId;
		this.userName = userName;
		this.password = password;
		this.authority = authority;
	}

	public User(String userId, String userName, String authority) {
		super();
		this.userId = userId;
		this.userName = userName;
		this.authority = authority;
	}
	
	public User(String userId) {
		super();
		this.userId = userId;
	}
	
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
	
	@Override
	public String toString() {
		return "User [userId=" + userId + ", userName=" + userName + ", password=" + password + ", authority="
				+ authority + "]";
	}
}
