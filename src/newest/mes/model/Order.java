package newest.mes.model;

public class Order {
	private String orderNo;
	private String orderDate;
	private String customerCode;
	private String orderDetailNo;
	private String productId;
	private String orderCount;
	private String chulhaYn;
	private String customerName;
	private String productName;
	
	public Order() {}
	
	public Order(String orderNo, String orderDetailNo) {
		this.orderNo = orderNo;
		this.orderDetailNo = orderDetailNo;
	}
	
	public String getOrderNo() {
		return orderNo;
	}

	public void setOrderNo(String orderNo) {
		this.orderNo = orderNo;
	}

	public String getOrderDate() {
		return orderDate;
	}

	public void setOrderDate(String orderDate) {
		this.orderDate = orderDate;
	}

	public String getCustomerCode() {
		return customerCode;
	}

	public void setCustomerCode(String customerCode) {
		this.customerCode = customerCode;
	}

	public String getOrderDetailNo() {
		return orderDetailNo;
	}

	public void setOrderDetailNo(String orderDetailNo) {
		this.orderDetailNo = orderDetailNo;
	}

	public String getProductId() {
		return productId;
	}

	public void setProductId(String productId) {
		this.productId = productId;
	}

	public String getOrderCount() {
		return orderCount;
	}

	public void setOrderCount(String orderCount) {
		this.orderCount = orderCount;
	}

	public String getChulhaYn() {
		return chulhaYn;
	}

	public void setChulhaYn(String chulhaYn) {
		this.chulhaYn = chulhaYn;
	}

	public String getCustomerName() {
		return customerName;
	}

	public void setCustomerName(String customerName) {
		this.customerName = customerName;
	}

	public String getProductName() {
		return productName;
	}

	public void setProductName(String productName) {
		this.productName = productName;
	}
	
	
	
}
