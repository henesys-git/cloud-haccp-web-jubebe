package mes.model;

public class Part {
	private String memberKey;
	private String partCd;
	private int revisionNo;
	private String partGubun;
	private String partNm;
	private String partGubunBig;
	private String partGubunMid;
	private String partGubunSmall;
	private String gyugyeok;
	private float packingQtty;
	private String unitType;
	
	public Part() {
	}
	
	public Part(String memberKey, String partCd, int revisionNo) {
		super();
		this.memberKey = memberKey;
		this.partCd = partCd;
		this.revisionNo = revisionNo;
	}

	public String getMemberKey() {
		return memberKey;
	}

	public void setMemberKey(String memberKey) {
		this.memberKey = memberKey;
	}

	public String getPartCd() {
		return partCd;
	}

	public void setPartCd(String partCd) {
		this.partCd = partCd;
	}

	public int getRevisionNo() {
		return revisionNo;
	}

	public void setRevisionNo(int revisionNo) {
		this.revisionNo = revisionNo;
	}

	public String getPartGubun() {
		return partGubun;
	}

	public void setPartGubun(String partGubun) {
		this.partGubun = partGubun;
	}

	public String getPartNm() {
		return partNm;
	}

	public void setPartNm(String partNm) {
		this.partNm = partNm;
	}

	public String getPartGubunBig() {
		return partGubunBig;
	}

	public void setPartGubunBig(String partGubunBig) {
		this.partGubunBig = partGubunBig;
	}

	public String getPartGubunMid() {
		return partGubunMid;
	}

	public void setPartGubunMid(String partGubunMid) {
		this.partGubunMid = partGubunMid;
	}

	public String getPartGubunSmall() {
		return partGubunSmall;
	}

	public void setPartGubunSmall(String partGubunSmall) {
		this.partGubunSmall = partGubunSmall;
	}

	public String getGyugyeok() {
		return gyugyeok;
	}

	public void setGyugyeok(String gyugyeok) {
		this.gyugyeok = gyugyeok;
	}

	public float getPackingQtty() {
		return packingQtty;
	}

	public void setPackingQtty(float packingQtty) {
		this.packingQtty = packingQtty;
	}

	public String getUnitType() {
		return unitType;
	}

	public void setUnitType(String unitType) {
		this.unitType = unitType;
	}
	
}
