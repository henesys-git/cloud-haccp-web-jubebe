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
	
	public String getRawmaterialId() {
		return rawmaterialId;
	}
	public String getRawmaterialName() {
		return rawmaterialName;
	}
	public String getRawmaterialType() {
		return rawmaterialType;
	}

	public void setRawmaterialId(String rawmaterialId) {
		this.rawmaterialId = rawmaterialId;
	}
	public void setRawmaterialName(String rawmaterialName) {
		this.rawmaterialName = rawmaterialName;
	}
	public void setRawmaterialType(String rawmaterialType) {
		this.rawmaterialType = rawmaterialType;
	}

	@Override
	public String toString() {
		return "RawmaterialViewModel [rawmaterialId=" + rawmaterialId + ", rawmaterialType=" + rawmaterialType + ", rawmaterialName="
				+ rawmaterialName + "]";
	}

}
