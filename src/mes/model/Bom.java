package mes.model;

public class Bom {
	
	private String prodCd;
	private String partCd;
	private double blendingRatio;
	
	public Bom() {
	}
	
	public Bom(String prodCd, String partCd, double blendingRatio) {
		super();
		this.prodCd = prodCd;
		this.partCd = partCd;
		this.blendingRatio = blendingRatio;
	}

	public String getProdCd() {
		return prodCd;
	}
	
	public void setProdCd(String prodCd) {
		this.prodCd = prodCd;
	}
	
	public String getPartCd() {
		return partCd;
	}
	
	public void setPartCd(String partCd) {
		this.partCd = partCd;
	}
	
	public double getBlendingRatio() {
		return blendingRatio;
	}
	
	public void setBlendingRatio(double blendingRatio) {
		this.blendingRatio = blendingRatio;
	}

}
