package newest.mes.model;

public class ChulhaInfoDetail {
	private String chulhaNo;
	private String productId;
	private int chulhaCount;
	private int returnCount;
	private String returnType;
	
	public ChulhaInfoDetail() {
	}
	
	public ChulhaInfoDetail(String chulhaNo, String productId, String chulhaCount) {
		this.chulhaNo = chulhaNo;
		this.productId = productId;
		this.chulhaCount = Integer.parseInt(chulhaCount);
	}
	
	public String getChulhaNo() {
		return chulhaNo;
	}
	public String getProductId() {
		return productId;
	}
	public int getChulhaCount() {
		return chulhaCount;
	}
	public int getReturnCount() {
		return returnCount;
	}
	public String getReturnType() {
		return returnType;
	}
	public void setChulhaNo(String chulhaNo) {
		this.chulhaNo = chulhaNo;
	}
	public void setProductId(String productId) {
		this.productId = productId;
	}
	public void setChulhaCount(int chulhaCount) {
		this.chulhaCount = chulhaCount;
	}
	public void setReturnCount(int returnCount) {
		this.returnCount = returnCount;
	}
	public void setReturnType(String returnType) {
		this.returnType = returnType;
	}
	
	
}
