package viewmodel;

public class CustomerViewModel {
	private String customerId;
	private String customerType;
	private String customerName;
	
	public CustomerViewModel() {}
	
	public CustomerViewModel(String customerId, String customerType, String customerName) {
		super();
		this.customerId = customerId;
		this.customerType = customerType;
		this.customerName = customerName;
	}
	
	public String getCustomerId() {
		return customerId;
	}
	public String getCustomerName() {
		return customerName;
	}
	public String getCustomerType() {
		return customerType;
	}

	public void setCustomerId(String customerId) {
		this.customerId = customerId;
	}
	public void setCustomerName(String customerName) {
		this.customerName = customerName;
	}
	public void setCustomerType(String customerType) {
		this.customerType = customerType;
	}

	@Override
	public String toString() {
		return "RawmaterialViewModel [customerId=" + customerId + ", customerType=" + customerType + ", customerName="
				+ customerName + "]";
	}

}
