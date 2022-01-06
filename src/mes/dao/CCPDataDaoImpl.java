package mes.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;

import org.apache.log4j.Logger;

import mes.model.CCPData;
import viewmodel.CCPDataViewModel;

public class CCPDataDaoImpl implements CCPDataDao {
	
	static final Logger logger = 
			Logger.getLogger(CCPDataDaoImpl.class.getName());
	
	public CCPDataDaoImpl() {
	}

	@Override
	public List<CCPData> getAllCCPData(Connection conn, String type, String startDate, String endDate) {
		
		try {
			Statement stmt = conn.createStatement();
			
			String sql = new StringBuilder()
				.append("SELECT A.*														\n")
				.append("FROM data_metal A												\n")
				.append("INNER JOIN sensor B											\n")
				.append("	ON A.sensor_id = B.sensor_id								\n")
				.append("WHERE CAST(A.create_time AS DATE) BETWEEN '" + startDate + "'	\n")
				.append("  				   					   AND '" + endDate	+ "'	\n")
				.append("  AND B.type_code LIKE '" + type + "'							\n")
				.toString();
			
			logger.debug("sql:\n" + sql);
			
			ResultSet rs = stmt.executeQuery(sql);
			
			List<CCPData> ccpDataList = new ArrayList<CCPData>();
			
			while(rs.next()) {
				CCPData data = extractFromResultSet(rs);
				ccpDataList.add(data);
			}
			
			return ccpDataList;
			
		} catch (SQLException ex) {
			ex.printStackTrace();
		}
		
		return null;
	};
	
	@Override
	public List<CCPDataViewModel> getAllCCPDataViewModel(Connection conn, String type, String startDate, String endDate) {
		
		try {
			Statement stmt = conn.createStatement();
			
			String sql = new StringBuilder()
					.append("SELECT 					\n")
					.append("	A.sensor_key,			\n")
					.append("	A.create_time,			\n")
					.append("	B.sensor_name,			\n")
					.append("	D.product_name,			\n")
					.append("	C.code_name AS event,	\n")
					.append("	A.sensor_value,			\n")
					.append("	IF(A.sensor_value <= B.value_max && A.sensor_value >= B.value_min, '적합', '부적합') AS value_judge,\n")
					.append("	E.code_name AS improvement									\n")
					.append("FROM data_metal A												\n")
					.append("INNER JOIN sensor B											\n")
					.append("	ON A.sensor_id = B.sensor_id								\n")
					.append("LEFT JOIN common_code C										\n")
					.append("	ON A.event_code = C.code									\n")
					.append("INNER JOIN product D											\n")
					.append("	ON A.product_id = D.product_id 								\n")
					.append("LEFT JOIN common_code E										\n")
					.append("	ON A.improvement_code = E.code								\n")
					.append("WHERE CAST(A.create_time AS DATE) BETWEEN '" + startDate + "'	\n")
					.append("  				   					  AND '" + endDate	+ "'	\n")
					.append("  AND B.type_code LIKE '" + type + "'							\n")
					.toString();

			logger.debug("sql:\n" + sql);
			
			ResultSet rs = stmt.executeQuery(sql);
			
			List<CCPDataViewModel> cvmList = new ArrayList<CCPDataViewModel>();
			
			while(rs.next()) {
				CCPDataViewModel data = extractViewModelFromResultSet(rs);
				cvmList.add(data);
			}
			
			return cvmList;
			
		} catch (SQLException ex) {
			ex.printStackTrace();
		}
		
		return null;
	};
	
//	@Override
//	public List<Bom> getAllBomsForProduct(Connection conn, String prodCd) {
//		
//		try {
//			String sql = new StringBuilder()
//					.append("SELECT * 							\n")
//					.append("FROM tbm_bom_info2 				\n")
//					.append("WHERE prod_cd = ?					\n")
//					.append("  AND SYSDATE BETWEEN start_date	\n")
//					.append("  	   		    AND duration_date	\n")
//					.toString();
//
//			PreparedStatement ps = conn.prepareStatement(sql);
//			ps.setString(1, prodCd);
//
//			ResultSet rs = ps.executeQuery();
//			
//			List<Bom> bomList = new ArrayList<Bom>();
//			
//			if(rs.next()) {
//				Bom bom = extractBomFromResultSet(rs);
//				bomList.add(bom);
//			}
//			
//			return bomList;
//			
//		} catch (SQLException ex) {
//			ex.printStackTrace();
//		}
//		
//		return null;
//	};
//	
//	@Override
//	public Bom getBom(Connection conn, String prodCd, String partCd) {
//		
//		try {
//			String sql = new StringBuilder()
//					.append("SELECT *							\n")
//					.append("FROM tbm_bom_info2					\n")
//					.append("WHERE prod_cd = ?					\n")
//					.append("  AND part_cd = ?					\n")
//					.append("  AND SYSDATE BETWEEN start_date	\n")
//					.append("  				AND duration_date	\n")
//					.toString();
//
//			PreparedStatement ps = conn.prepareStatement(sql);
//			
//			ps.setString(1, prodCd);
//			ps.setString(2, partCd);
//			
//			ResultSet rs = ps.executeQuery();
//			
//			Bom bom = new Bom();
//			
//			if(rs.next()) {
//				bom = extractBomFromResultSet(rs);
//			}
//			
//			return bom;
//			
//		} catch (SQLException ex) {
//			ex.printStackTrace();
//		}
//		
//		return null;
//	};
//	
//	@Override
//	public boolean updateBom(Connection conn, Bom bom) {
//	    return false;
//	};
//	
//	@Override
//	public boolean deleteBom(Connection conn, Bom bom) {
//		
//	    try {
//	    	String sql = new StringBuilder()
//					.append("UPDATE tbm_bom_list	\n")
//					.append("SET delyn = 'Y'		\n")
//					.append("WHERE prod_cd = ?		\n")
//					.append("  AND part_cd = ?		\n")
//					.toString();
//
//			PreparedStatement ps = conn.prepareStatement(sql);
//			
//			ps.setString(1, bom.getProdCd());
//			ps.setString(2, bom.getPartCd());
//			
//	        int i = ps.executeUpdate();
//
//	        if(i == 1) {
//	        	return true;
//	        }
//
//	    } catch (SQLException ex) {
//	        ex.printStackTrace();
//	    }
//
//	    return false;
//	};
	
	private CCPData extractFromResultSet(ResultSet rs) throws SQLException {
		CCPData ccpData = new CCPData();
		
		ccpData.setSensorKey(rs.getString("sensor_key"));
		ccpData.setSeqNo(rs.getInt("seq_no"));
		ccpData.setCreateTime(rs.getString("create_time"));
		ccpData.setSensorId(rs.getString("sensor_id"));
		ccpData.setSensorValue(Double.parseDouble(rs.getString("sensor_value")));
		ccpData.setImprovementCode(rs.getString("improvement_code"));
		ccpData.setUserId(rs.getString("user_id"));
		ccpData.setEventCode(rs.getString("event_code"));
		ccpData.setProductId(rs.getString("product_id"));
		
	    return ccpData;
	}
	
	private CCPDataViewModel extractViewModelFromResultSet(ResultSet rs) throws SQLException {
		CCPDataViewModel cvm = new CCPDataViewModel();
		
		cvm.setSensorKey(rs.getString("sensor_key"));
		cvm.setCreateTime(rs.getTimestamp("create_time").toString());
		cvm.setSensorName(rs.getString("sensor_name"));
		cvm.setProductName(rs.getString("product_name"));
		cvm.setEvent(rs.getString("event"));
		cvm.setSensorValue(rs.getString("sensor_value"));
		cvm.setValueJudge(rs.getString("value_judge"));
		cvm.setImprovement(rs.getString("improvement"));
		
		return cvm;
	}
}
