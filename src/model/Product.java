package model;

public class Product {
	private String productId;
	private String productName;
	private String productLevel;
	private String parentId;
	
	public Product() {}
	
	public Product(String productId, String productName) {
		super();
		this.productId = productId;
		this.productName = productName;
	}
	
	public Product(String productId, String productName, String parentId) {
		super();
		this.productId = productId;
		this.productName = productName;
		this.parentId = parentId;
	}

	public Product(String productId, String productName, String productLevel, String parentId) {
		super();
		this.productId = productId;
		this.productName = productName;
		this.productLevel = productLevel;
		this.parentId = parentId;
	}
	
	public String getProductId() {
		return productId;
	}
	public String getProductName() {
		return productName;
	}
	public String getProductLevel() {
		return productLevel;
	}
	public String getParentId() {
		return parentId;
	}

	public void setProductId(String productId) {
		this.productId = productId;
	}
	public void setProductName(String productName) {
		this.productName = productName;
	}
	public void setProductLevel(String productLevel) {
		this.productLevel = productLevel;
	}
	public void setParentId(String parentId) {
		this.parentId = parentId;
	}

	@Override
	public String toString() {
		return "Product [productId=" + productId + ", productName=" + productName + ", productLevel=" + productLevel
				+ ", parentId=" + parentId + "]";
	}	
}
