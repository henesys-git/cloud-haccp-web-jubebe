package model;

public class Rawmaterial {
	private String rawmaterialId;
	private String rawmaterialName;
	
	public Rawmaterial(String rawmaterialId, String rawmaterialName) {
		super();
		this.rawmaterialId = rawmaterialId;
		this.rawmaterialName = rawmaterialName;
	}
	
	public String getRawmaterialId() {
		return rawmaterialId;
	}
	public void setRawmaterialId(String rawmaterialId) {
		this.rawmaterialId = rawmaterialId;
	}
	public String getRawmaterialName() {
		return rawmaterialName;
	}
	public void setRawmaterialName(String rawmaterialName) {
		this.rawmaterialName = rawmaterialName;
	}
	
}
