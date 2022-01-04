package mes.frame.business.product;

public class Product {
	
	private String code;
	private int revNo;
	private String name;
	private float gugyuk;
	private int innerPackingCount;
	private int outerPackingCount;
	
	public Product() {
	}
	
	public Product(String code, int revNo, String name) {
		this.code = code;
		this.revNo = revNo;
		this.name = name;
	}
	
	public String getCode() {
		return code;
	}
	
	public void setCode(String code) {
		this.code = code;
	}
	
	public int getRevNo() {
		return revNo;
	}
	
	public void setRevNo(int revNo) {
		this.revNo = revNo;
	}
	
	public float getGugyuk() {
		return gugyuk;
	}
	
	public void setGugyuk(int gugyuk) {
		this.gugyuk = gugyuk;
	}
	
	public int getInnerPackingCount() {
		return innerPackingCount;
	}
	
	public void setInnerPackingCount(int innerPackingCount) {
		this.innerPackingCount = innerPackingCount;
	}
	
	public int getOuterPackingCount() {
		return outerPackingCount;
	}
	
	public void setOuterPackingCount(int outerPackingCount) {
		this.outerPackingCount = outerPackingCount;
	}
	
}
