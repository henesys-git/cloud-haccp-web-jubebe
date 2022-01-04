package mes.frame.business.customer;

public class Customer {
	private String code;
	private int revisionNo;
	private String name;
	
	public Customer() {
	}
	
	public Customer(String code, int revisionNo, String name) {
		this.code = code;
		this.revisionNo = revisionNo;
		this.name = name;
	}
	
	public String getCode() {
		return code;
	}
	
	public void setCode(String code) {
		this.code = code;
	}
	
	public int getRevisionNo() {
		return revisionNo;
	}
	
	public void setRevisionNo(int revisionNo) {
		this.revisionNo = revisionNo;
	}
	
	public String getName() {
		return name;
	}
	
	public void setName(String name) {
		this.name = name;
	}
}
