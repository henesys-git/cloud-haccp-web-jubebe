package mes.dao;

import java.sql.Connection;
import java.util.List;

import mes.model.CCPData;
import viewmodel.CCPDataDetailViewModel;
import viewmodel.CCPDataHeadViewModel;

public interface CCPDataDao {
	public List<CCPData> getAllCCPData(Connection conn, String type, String startDate, String endDate);
	public List<CCPDataHeadViewModel> getAllCCPDataHeadViewModel(Connection conn, String type, String startDate, String endDate);
	public List<CCPDataDetailViewModel> getAllCCPDataDetailViewModel(Connection conn, String sensorKey);
//	public List<Bom> getAllBomsForProduct(Connection conn, String prodCd);
//	public Bom getBom(Connection conn, String prodCd, String partCd);
//	public boolean updateBom(Connection conn, Bom Bom);
//	public boolean deleteBom(Connection conn, Bom Bom);
}