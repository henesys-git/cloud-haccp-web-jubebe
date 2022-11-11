package shm.viewmodel;

public class SsfKpiLevel2 {
	private String ssfKpiCertKey;
	private String ocrDttm;
	private String kpiFldCd;
	private String kpiDtlCd;
	private String kpiDtlNm;
	private String orgValue;
	private String targetValue;
	private String curValue;
	private String ssfSentYn;
	
	public String getSsfKpiCertKey() {
		return ssfKpiCertKey;
	}
	public String getOcrDttm() {
		return ocrDttm;
	}
	public String getKpiFldCd() {
		return kpiFldCd;
	}
	public String getKpiDtlCd() {
		return kpiDtlCd;
	}
	public String getKpiDtlNm() {
		return kpiDtlNm;
	}
	public String getOrgValue() {
		return orgValue;
	}
	public String getTargetValue() {
		return targetValue;
	}
	public String getCurValue() {
		return curValue;
	}
	public void setSsfKpiCertKey(String ssfKpiCertKey) {
		this.ssfKpiCertKey = ssfKpiCertKey;
	}
	public void setOcrDttm(String ocrDttm) {
		this.ocrDttm = ocrDttm;
	}
	public void setKpiFldCd(String kpiFldCd) {
		this.kpiFldCd = kpiFldCd;
	}
	public void setKpiDtlCd(String kpiDtlCd) {
		this.kpiDtlCd = kpiDtlCd;
	}
	public void setKpiDtlNm(String kpiDtlNm) {
		this.kpiDtlNm = kpiDtlNm;
	}
	public void setOrgValue(String orgValue) {
		this.orgValue = orgValue;
	}
	public void setTargetValue(String targetValue) {
		this.targetValue = targetValue;
	}
	public void setCurValue(String curValue) {
		this.curValue = curValue;
	}
	public String getSsfSentYn() {
		return ssfSentYn;
	}
	public void setSsfSentYn(String ssfSentYn) {
		this.ssfSentYn = ssfSentYn;
	}
	
	@Override
	public String toString() {
		return "SsfKpiLevel2 [ssfKpiCertKey=" + ssfKpiCertKey + ", ocrDttm=" + ocrDttm + ", kpiFldCd=" + kpiFldCd
				+ ", kpiDtlCd=" + kpiDtlCd + ", kpiDtlNm=" + kpiDtlNm + ", orgValue=" + orgValue + ", targetValue="
				+ targetValue + ", curValue=" + curValue + ", ssfSentYn=" + ssfSentYn + "]";
	}
}
