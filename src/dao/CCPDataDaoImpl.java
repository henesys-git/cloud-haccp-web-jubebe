package dao;

import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;

import org.apache.log4j.Logger;

import mes.frame.database.JDBCConnectionPool;
import model.CCPData;
import viewmodel.CCPDataDetailViewModel;
import viewmodel.CCPDataHeadViewModel;

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
				.append("SELECT A.*															\n")
				.append("FROM data_metal A													\n")
				.append("INNER JOIN sensor B												\n")
				.append("	ON A.sensor_id = B.sensor_id									\n")
				.append("WHERE A.tenant_id = '" + JDBCConnectionPool.getTenantId(conn) + "'	\n")
				.append("  AND CAST(A.create_time AS DATE) BETWEEN '" + startDate + "'		\n")
				.append("  				   					   AND '" + endDate	+ "'		\n")
				.append("  AND B.type_code LIKE '" + type + "'								\n")
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
	public List<CCPDataHeadViewModel> getAllCCPDataHeadViewModel(Connection conn, String type, String startDate, String endDate) {
		
		try {
			Statement stmt = conn.createStatement();
			
			String sql = new StringBuilder()
					.append("SELECT\n")
					.append("	A.sensor_key,\n")
					.append("	C.code_name AS process_name,\n")
					.append("	D.product_name,\n")
					.append("	DATE_FORMAT(A.create_time, \"%Y-%m-%d %H:%i\") AS create_time,\n")
					.append("	(\n")
					.append("		SELECT CASE\n")
					.append("			WHEN NOT EXISTS(\n")
					.append("				SELECT *\n")
					.append("				FROM data_metal aa\n")
					.append("				INNER JOIN sensor bb\n")
					.append("					ON aa.sensor_id = bb.sensor_id\n")
					.append("				WHERE aa.sensor_key = A.sensor_key\n")
					.append("			 	  AND aa.sensor_value > bb.value_max || aa.sensor_value < bb.value_min\n")
					.append("			)\n")
					.append("			THEN '利钦'\n")
					.append("			ELSE '何利钦'\n")
					.append("			END\n")
					.append("	) AS judge,\n")
					.append("	'on test' AS improvement_completion\n")
					.append("FROM data_metal A\n")
					.append("INNER JOIN sensor B\n")
					.append("	ON A.sensor_id = B.sensor_id\n")
					.append("LEFT JOIN common_code C\n")
					.append("	ON A.process_code = C.code\n")
					.append("INNER JOIN product D\n")
					.append("	ON A.product_id = D.product_id\n")
					.append("WHERE A.tenant_id = '" + JDBCConnectionPool.getTenantId(conn) + "'\n")
					.append("  AND CAST(A.create_time AS DATE) BETWEEN '" + startDate + "'\n")
					.append("  				   					  AND '" + endDate	+ "'\n")
					.append("  AND B.type_code LIKE '" + type + "'\n")
					.append("GROUP BY sensor_key\n")
					.toString();

			logger.debug("sql:\n" + sql);
			
			ResultSet rs = stmt.executeQuery(sql);
			
			List<CCPDataHeadViewModel> cvmList = new ArrayList<CCPDataHeadViewModel>();
			
			while(rs.next()) {
				CCPDataHeadViewModel data = extractHeadViewModelFromResultSet(rs);
				cvmList.add(data);
			}
			
			return cvmList;
			
		} catch (SQLException ex) {
			ex.printStackTrace();
		}
		
		return null;
	};
	
	@Override
	public List<CCPDataDetailViewModel> getAllCCPDataDetailViewModel(Connection conn, String sensorKey) {
		
		try {
			Statement stmt = conn.createStatement();
			
			String sql = new StringBuilder()
					.append("SELECT\n")
					.append("	B.sensor_name,\n")
//					.append("	DATE_FORMAT(A.create_time, \"%H:%i:%s\") AS create_time,\n")
					.append("	A.create_time,\n")
					.append("	C.event_name as event,\n")
					.append("	A.sensor_value,\n")
					.append("	IF(A.sensor_value <= B.value_max && A.sensor_value >= B.value_min, '利钦', '何利钦') as judge,\n")
					.append("	D.code_name as improvement_action\n")
					.append("FROM data_metal A\n")
					.append("INNER JOIN sensor B\n")
					.append("	ON A.sensor_id = B.sensor_id\n")
					.append("LEFT JOIN event_info C\n")
					.append("	ON A.event_code = C.event_code\n")
					.append("LEFT JOIN common_code D\n")
					.append("	ON A.improvement_code = D.code\n")
					.append("WHERE A.tenant_id = '" + JDBCConnectionPool.getTenantId(conn) + "'\n")
					.append("  AND A.sensor_key = '" + sensorKey + "'\n")
					.toString();
			
			logger.debug("sql:\n" + sql);
			
			ResultSet rs = stmt.executeQuery(sql);
			
			List<CCPDataDetailViewModel> cvmList = new ArrayList<CCPDataDetailViewModel>();
			
			while(rs.next()) {
				CCPDataDetailViewModel data = extractDetailViewModelFromResultSet(rs);
				cvmList.add(data);
			}
			
			return cvmList;
			
		} catch (SQLException ex) {
			ex.printStackTrace();
		}
		
		return null;
	};
	
	@Override
	public boolean fixLimitOut(Connection conn, String sensorKey, String createTime, String improvementCode) {
		try {
			Statement stmt = conn.createStatement();
			
			String sql = new StringBuilder()
					.append("UPDATE data_metal\n")
					.append("SET improvement_code = '" + improvementCode + "'\n")
					.append("WHERE tenant_id = '" + JDBCConnectionPool.getTenantId(conn) + "'\n")
					.append("	AND sensor_key = '" + sensorKey + "'\n")
					.append("	AND create_time = '" + createTime + "'\n")
					.toString();
			
			logger.debug("sql:\n" + sql);
			
//			PreparedStatement ps = conn.prepareStatement(sql);
//			
//			ps.setString(1, improvementCode);
//			ps.setString(2, JDBCConnectionPool.getTenantId(conn));
//			ps.setString(3, sensorKey);
//			ps.setString(4, createTime);
//			int i = ps.executeUpdate();

			int i = stmt.executeUpdate(sql);

	        if(i == 1) {
	        	return true;
	        }
		} catch (SQLException ex) {
			ex.printStackTrace();
		}
		
		return false;
	}
	
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
	
	private CCPDataHeadViewModel extractHeadViewModelFromResultSet(ResultSet rs) 
												throws SQLException {
		CCPDataHeadViewModel cvm = new CCPDataHeadViewModel();
		
		cvm.setSensorKey(rs.getString("sensor_key"));
		cvm.setProcessName(rs.getString("process_name"));
		cvm.setProductName(rs.getString("product_name"));
		cvm.setCreateTime(rs.getTimestamp("create_time").toString());
		cvm.setJudge(rs.getString("judge"));
		cvm.setImprovementCompletion(rs.getString("improvement_completion"));
		
		return cvm;
	}

	private CCPDataDetailViewModel extractDetailViewModelFromResultSet(ResultSet rs) throws SQLException {
		CCPDataDetailViewModel cvm = new CCPDataDetailViewModel();
		
		cvm.setSensorName(rs.getString("sensor_name"));
		cvm.setCreateTime(rs.getTimestamp("create_time").toString());
		cvm.setEvent(rs.getString("event"));
		cvm.setSensorValue(rs.getString("sensor_value"));
		cvm.setJudge(rs.getString("judge"));
		cvm.setImprovementAction(rs.getString("improvement_action"));
		
		return cvm;
	}
}
