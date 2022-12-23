package newest.mes.model;

public class RawmaterialStorage {
	private String rawmaterialStockNo;
	private int seqNo;
	private String rawmaterialId;
	private String rawmaterialName;
	private int ioAmt;
	private String ioDatetime;
	private String whereToUse;
	private String storageNo;
	private String storageName;
	private String prodStockNoForBacktrace;
	
	public RawmaterialStorage() {}

	public String getRawmaterialStockNo() {
		return rawmaterialStockNo;
	}

	public int getSeqNo() {
		return seqNo;
	}

	public String getRawmaterialId() {
		return rawmaterialId;
	}

	public String getRawmaterialName() {
		return rawmaterialName;
	}

	public int getIoAmt() {
		return ioAmt;
	}

	public String getIoDatetime() {
		return ioDatetime;
	}

	public String getWhereToUse() {
		return whereToUse;
	}

	public String getStorageNo() {
		return storageNo;
	}

	public String getStorageName() {
		return storageName;
	}

	public String getProdStockNoForBacktrace() {
		return prodStockNoForBacktrace;
	}

	public void setRawmaterialStockNo(String rawmaterialStockNo) {
		this.rawmaterialStockNo = rawmaterialStockNo;
	}

	public void setSeqNo(int seqNo) {
		this.seqNo = seqNo;
	}

	public void setRawmaterialId(String rawmaterialId) {
		this.rawmaterialId = rawmaterialId;
	}

	public void setRawmaterialName(String rawmaterialName) {
		this.rawmaterialName = rawmaterialName;
	}

	public void setIoAmt(int ioAmt) {
		this.ioAmt = ioAmt;
	}

	public void setIoDatetime(String ioDatetime) {
		this.ioDatetime = ioDatetime;
	}

	public void setWhereToUse(String whereToUse) {
		this.whereToUse = whereToUse;
	}

	public void setStorageNo(String storageNo) {
		this.storageNo = storageNo;
	}

	public void setStorageName(String storageName) {
		this.storageName = storageName;
	}

	public void setProdStockNoForBacktrace(String prodStockNoForBacktrace) {
		this.prodStockNoForBacktrace = prodStockNoForBacktrace;
	}
}
