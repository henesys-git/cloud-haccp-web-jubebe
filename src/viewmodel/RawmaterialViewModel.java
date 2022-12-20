package viewmodel;

public class RawmaterialViewModel {
	private String rawmaterialId;
	private String rawmaterialType;
	private String rawmaterialName;
	
	public RawmaterialViewModel() {}
	
	public RawmaterialViewModel(String rawmaterialId, String rawmaterialType, String rawmaterialName) {
		super();
		this.rawmaterialId = rawmaterialId;
		this.rawmaterialType = rawmaterialType;
		this.rawmaterialName = rawmaterialName;
	}
	
	public String getProductId() {
		return rawmaterialId;
	}
	public String getProductName() {
		return rawmaterialName;
	}
	public String getProductType() {
		return rawmaterialType;
	}

	public void setProductId(String rawmaterialId) {
		this.rawmaterialId = rawmaterialId;
	}
	public void setProductName(String rawmaterialName) {
		this.rawmaterialName = rawmaterialName;
	}
	public void setProductType(String rawmaterialType) {
		this.rawmaterialType = rawmaterialType;
	}

	@Override
	public String toString() {
		return "RawmaterialViewModel [rawmaterialId=" + rawmaterialId + ", rawmaterialType=" + rawmaterialType + ", rawmaterialName="
				+ rawmaterialName + "]";
	}

}
