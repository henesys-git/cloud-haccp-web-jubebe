package newest.mes.model;

public class ProductStorage {
	private String productStockNo;
	private int seqNo;
	private String productId;
	private String productName;
	private int ioAmt;
	private String ioDatetime;
	private String lotno;
	private String expirationDate;
	private String expirationDateBigo;
	private String bigo;
	private String storageNo;
	private String storageName;
	private String rawmaterialDeductYn;
	
	public ProductStorage() {}
	
	public String getProductStockNo() {
		return productStockNo;
	}
	public int getSeqNo() {
		return seqNo;
	}
	public String getProductId() {
		return productId;
	}
	public String getProductName() {
		return productName;
	}
	public int getIoAmt() {
		return ioAmt;
	}
	public String getIoDatetime() {
		return ioDatetime;
	}
	public String getLotno() {
		return lotno;
	}
	public String getExpirationDate() {
		return expirationDate;
	}
	public String getExpirationDateBigo() {
		return expirationDateBigo;
	}
	public String getBigo() {
		return bigo;
	}
	public String getStorageNo() {
		return storageNo;
	}
	public String getRawmaterialDeductYn() {
		return rawmaterialDeductYn;
	}
	public void setProductStockNo(String productStockNo) {
		this.productStockNo = productStockNo;
	}
	public void setSeqNo(int seqNo) {
		this.seqNo = seqNo;
	}
	public void setProductId(String productId) {
		this.productId = productId;
	}
	public void setProductName(String productName) {
		this.productName = productName;
	}
	public void setIoAmt(int ioAmt) {
		this.ioAmt = ioAmt;
	}
	public void setIoDatetime(String ioDatetime) {
		this.ioDatetime = ioDatetime;
	}
	public void setLotno(String lotno) {
		this.lotno = lotno;
	}
	public void setExpirationDate(String expirationDate) {
		this.expirationDate = expirationDate;
	}
	public void setExpirationDateBigo(String expirationDateBigo) {
		this.expirationDateBigo = expirationDateBigo;
	}
	public void setBigo(String bigo) {
		this.bigo = bigo;
	}
	public void setStorageNo(String storageNo) {
		this.storageNo = storageNo;
	}
	public void setRawmaterialDeductYn(String rawmaterialDeductYn) {
		this.rawmaterialDeductYn = rawmaterialDeductYn;
	}

	public String getStorageName() {
		return storageName;
	}

	public void setStorageName(String storageName) {
		this.storageName = storageName;
	}

	@Override
	public String toString() {
		return "ProductStorage [productStockNo=" + productStockNo + ", seqNo=" + seqNo + ", productId=" + productId
				+ ", productName=" + productName + ", ioAmt=" + ioAmt + ", ioDatetime=" + ioDatetime + ", lotno="
				+ lotno + ", expirationDate=" + expirationDate + ", expirationDateBigo=" + expirationDateBigo
				+ ", bigo=" + bigo + ", storageNo=" + storageNo + ", storageName=" + storageName
				+ ", rawmaterialDeductYn=" + rawmaterialDeductYn + "]";
	}
	
}
