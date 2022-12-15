package viewmodel;

public class ProductViewModel {
	private String productId;
	private String productType;
	private String productName;
	
	public ProductViewModel() {}
	
	public ProductViewModel(String productId, String productType, String productName) {
		super();
		this.productId = productId;
		this.productType = productType;
		this.productName = productName;
	}
	
	public String getProductId() {
		return productId;
	}
	public String getProductName() {
		return productName;
	}
	public String getProductType() {
		return productType;
	}

	public void setProductId(String productId) {
		this.productId = productId;
	}
	public void setProductName(String productName) {
		this.productName = productName;
	}
	public void setProductType(String productType) {
		this.productType = productType;
	}

	@Override
	public String toString() {
		return "ProductViewModel [productId=" + productId + ", productType=" + productType + ", productName="
				+ productName + "]";
	}

}
