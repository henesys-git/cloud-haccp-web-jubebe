package mes.frame.business.product;

public class ProductCountCalculator {
	private String prodCd;
	private int revNo;
	private int count;
	private String packingType;
	
	public ProductCountCalculator(String prodCd, int revNo, int count, String packingType) {
		this.prodCd = prodCd;
		this.revNo = revNo;
		this.count = count;
		this.packingType = packingType;
	}
	
	public int calculate() {
		
		ProductPacking pp = new ProductPacking();
		
		switch(packingType) {
			case "single":
				// do nothing
				break;
			case "innerPacking":
				int innerPackingCount = pp.getInnerPackingCount(prodCd, revNo);				
				count = count * innerPackingCount;
				break;
			case "outerPacking":
				int totalPackingCount = pp.getTotalPackingCount(prodCd, revNo);				
				count = count * totalPackingCount;
				break;
		}
		
		return count;
	}
}
