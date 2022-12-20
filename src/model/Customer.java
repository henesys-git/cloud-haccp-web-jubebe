package model;

public class Customer {
	private String customerId;
	private String customerName;
	
	public Customer(String customerId, String customerName) {
		super();
		this.customerId = customerId;
		this.customerName = customerName;
	}
	
	public String getCustomerId() {
		return customerId;
	}
	public void setCustomerId(String customerId) {
		this.customerId = customerId;
	}
	public String getCustomerName() {
		return customerName;
	}
	public void setCustomerName(String customerName) {
		this.customerName = customerName;
	}
	
}
