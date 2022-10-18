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
import viewmodel.CCPDataHeatingMonitoringGraphModel;
import viewmodel.CCPDataHeatingMonitoringModel;
import viewmodel.CCPDataMonitoringModel;
import viewmodel.CCPDataStatisticModel;
import viewmodel.CCPTestDataHeadViewModel;
import viewmodel.CCPTestDataViewModel;

public class CCPDataDaoImpl implements CCPDataDao {
	
	static final Logger logger = Logger.getLogger(CCPDataDaoImpl.class.getName());
	
	private Statement stmt;
	private ResultSet rs;
	
	public CCPDataDaoImpl() {}

	@Override
	public List<CCPData> getAllCCPData(Connection conn, String type, String startDate, String endDate) {
		
		try {
			stmt = conn.createStatement();
			
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
			
			rs = stmt.executeQuery(sql);
			
			List<CCPData> ccpDataList = new ArrayList<CCPData>();
			
			while(rs.next()) {
				CCPData data = extractFromResultSet(rs);
				ccpDataList.add(data);
			}
			
			return ccpDataList;
			
		} catch (SQLException ex) {
			ex.printStackTrace();
		} finally {
		    try { rs.close(); } catch (Exception e) { /* Ignored */ }
		    try { stmt.close(); } catch (Exception e) { /* Ignored */ }
		}
		
		return null;
	};
	
	@Override
	public List<CCPTestDataHeadViewModel> getCCPTestDataHead(Connection conn, String startDate, String endDate, String processCode) {
		
		try {
			stmt = conn.createStatement();
			
			String sql = new StringBuilder()
					.append("SELECT \n")
					.append("	CAST(A.create_time AS DATE) AS create_date,\n")
					.append("	A.sensor_id,\n")
					.append("	B.sensor_name\n")
					.append("FROM data_metal A\n")
					.append("INNER JOIN sensor B\n")
					.append("	ON A.sensor_id = B.sensor_id\n")
					.append("WHERE A.tenant_id = '" + JDBCConnectionPool.getTenantId(conn) + "'	\n")
					.append("	AND CAST(A.create_time as date) between '" + startDate + "' and '" + endDate + "'\n")
					.append("	AND A.process_code = '" + processCode + "'\n")
					.append("GROUP BY cast(A.create_time as date), A.sensor_id;\n")
					.toString();
			
			logger.debug("sql:\n" + sql);
			
			rs = stmt.executeQuery(sql);
			
			List<CCPTestDataHeadViewModel> list= new ArrayList<CCPTestDataHeadViewModel>();
			
			while(rs.next()) {
				CCPTestDataHeadViewModel data = extractTestDataHeadFromResultSet(rs);
				list.add(data);
			}
			
			return list;
			
		} catch (SQLException ex) {
			ex.printStackTrace();
		} finally {
			try { rs.close(); } catch (Exception e) { /* Ignored */ }
			try { stmt.close(); } catch (Exception e) { /* Ignored */ }
		}
		
		return null;
	};
	
	@Override
	public List<CCPTestDataViewModel> getCCPTestData(Connection conn, String date, String processCode, String sensorId) {
		
		try {
			stmt = conn.createStatement();
			
			String sql = new StringBuilder()
					.append("SELECT\n")
					.append("  B.product_name,\n")
					.append("  A.sensor_key,\n")
					.append("  A.create_time,\n")
					.append("  A.event_code,\n")
					.append("  A.sensor_value\n")
					.append("FROM data_metal A\n")
					.append("INNER JOIN product B\n")
					.append("  ON A.product_id = B.product_id\n")
					.append("WHERE A.tenant_id = '" + JDBCConnectionPool.getTenantId(conn) + "'	\n")
					.append("  AND CAST(create_time AS DATE) = '" + date + "' \n")
					.append("  AND process_code = '" + processCode + "'\n")
					.append("  AND sensor_id = '" + sensorId + "'\n")
					.append("ORDER BY create_time ASC;\n")
					.toString();
			
			logger.debug("sql:\n" + sql);
			
			rs = stmt.executeQuery(sql);
			
			List<CCPTestDataViewModel> ccpDataList = new ArrayList<CCPTestDataViewModel>();
			
			while(rs.next()) {
				CCPTestDataViewModel data = extractTestDataFromResultSet(rs);
				ccpDataList.add(data);
			}
			
			return ccpDataList;
			
		} catch (SQLException ex) {
			ex.printStackTrace();
		} finally {
		    try { rs.close(); } catch (Exception e) { /* Ignored */ }
		    try { stmt.close(); } catch (Exception e) { /* Ignored */ }
		}
		
		return null;
	};
	
	@Override
	public List<CCPDataHeadViewModel> getAllCCPDataHeadViewModel(
			Connection conn, String sensorId, 
			String startDate, String endDate, 
			String processCode) {
		
		try {
			stmt = conn.createStatement();
			
			String sql = new StringBuilder()
					.append("SELECT\n")
					.append("	A.sensor_key,\n")
					.append("	C.code_name AS process_name,\n")
					.append("	B.sensor_name,\n")
					.append("	D.product_name,\n")
					.append("	DATE_FORMAT(A.create_time, \"%Y-%m-%d %H:%i\") AS create_time,\n")
					.append("	(\n")
					.append("		SELECT CASE\n")
					.append("			WHEN NOT EXISTS(\n")
					.append("				SELECT *\n")
					.append("				FROM data_metal aa\n")
					.append("				INNER JOIN event_info bb\n")
					.append("					ON aa.event_code = bb.event_code\n")
					.append("				WHERE aa.tenant_id = '" + JDBCConnectionPool.getTenantId(conn) + "'\n")
					.append("				  AND aa.sensor_key = A.sensor_key\n")
					.append("			 	  AND (aa.sensor_value > bb.max_value || aa.sensor_value < bb.min_value)\n")
					.append("			)\n")
					.append("			THEN '적합'\n")
					.append("			ELSE '부적합'\n")
					.append("			END\n")
					.append("	) AS judge,\n")
					.append("	(\n")
					.append("		SELECT CASE \n")
					.append("			WHEN NOT EXISTS(\n")
					.append("				SELECT *\n")
					.append("				FROM data_metal aa\n")
					.append("				INNER JOIN event_info bb\n")
					.append("					ON aa.event_code = bb.event_code\n")
					.append("				WHERE aa.tenant_id = '" + JDBCConnectionPool.getTenantId(conn) + "'\n")
					.append("				  AND aa.sensor_key = A.sensor_key\n")
					.append("			 	  AND (aa.sensor_value > bb.max_value || aa.sensor_value < bb.min_value)\n")
					.append("			 	  AND aa.improvement_action is null \n")
					.append("			)\n")
					.append("			THEN '완료'\n")
					.append("			ELSE '미완료'\n")
					.append("			END\n")
					.append("	) AS improvement_completion \n")
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
					.append("  AND A.process_code LIKE '" + processCode	+ "'\n")
					.append("  AND B.sensor_id LIKE '" + sensorId + "'\n")
					.append("GROUP BY sensor_key\n")
					.toString();

			logger.debug("sql:\n" + sql);
			
			rs = stmt.executeQuery(sql);
			
			List<CCPDataHeadViewModel> cvmList = new ArrayList<CCPDataHeadViewModel>();
			
			while(rs.next()) {
				CCPDataHeadViewModel data = extractHeadViewModelFromResultSet(rs);
				cvmList.add(data);
			}
			
			return cvmList;
			
		} catch (SQLException ex) {
			ex.printStackTrace();
		} finally {
		    try { rs.close(); } catch (Exception e) { /* Ignored */ }
		    try { stmt.close(); } catch (Exception e) { /* Ignored */ }
		}
		
		return null;
	};
	
	@Override
	public List<CCPDataDetailViewModel> getAllCCPDataDetailViewModel(Connection conn, String sensorKey) {
		
		try {
			stmt = conn.createStatement();
			
			String sql = new StringBuilder()
					.append("SELECT\n")
					.append("	B.sensor_name,\n")
					.append("	A.create_time,\n")
					.append("	C.event_name as event,\n")
					.append("	A.sensor_value,\n")
					.append("	IF(A.sensor_value <= D.max_value && A.sensor_value >= D.min_value, '적합', '부적합') as judge,\n")
					.append("	A.improvement_action\n")
					.append("FROM data_metal A\n")
					.append("INNER JOIN sensor B\n")
					.append("	ON A.sensor_id = B.sensor_id\n")
					.append("LEFT JOIN event_info C\n")
					.append("	ON A.event_code = C.event_code\n")
					.append("INNER JOIN ccp_limit D\n")
					.append("	ON A.event_code = D.event_code\n")
					.append("	AND A.product_id = D.product_id\n")
					.append("WHERE A.tenant_id = '" + JDBCConnectionPool.getTenantId(conn) + "'\n")
					.append("  AND A.sensor_key = '" + sensorKey + "'\n")
					.toString();
			
			logger.debug("sql:\n" + sql);
			
			rs = stmt.executeQuery(sql);
			
			List<CCPDataDetailViewModel> cvmList = new ArrayList<CCPDataDetailViewModel>();
			
			while(rs.next()) {
				CCPDataDetailViewModel data = extractDetailViewModelFromResultSet(rs);
				cvmList.add(data);
			}
			
			return cvmList;
			
		} catch (SQLException ex) {
			ex.printStackTrace();
		} finally {
		    try { rs.close(); } catch (Exception e) { /* Ignored */ }
		    try { stmt.close(); } catch (Exception e) { /* Ignored */ }
		}
		
		return null;
	};
	
	@Override
	public boolean fixLimitOut(Connection conn, String sensorKey, String createTime, String improvementAction) {
		try {
			stmt = conn.createStatement();
			
			String sql = new StringBuilder()
					.append("UPDATE data_metal\n")
					.append("SET improvement_action = '" + improvementAction + "'\n")
					.append("WHERE tenant_id = '" + JDBCConnectionPool.getTenantId(conn) + "'\n")
					.append("	AND sensor_key = '" + sensorKey + "'\n")
					.append("	AND create_time = '" + createTime + "'\n")
					.toString();
			
			logger.debug("sql:\n" + sql);

			int i = stmt.executeUpdate(sql);

	        if(i == 1) {
	        	return true;
	        }
		} catch (SQLException ex) {
			ex.printStackTrace();
		} finally {
		    try { stmt.close(); } catch (Exception e) { /* Ignored */ }
		}
		
		return false;
	}
	
	@Override
	public List<CCPDataStatisticModel> getCCPDataStatisticModel(Connection conn, String toDate, String sensorId) {
		
		try {
			stmt = conn.createStatement();
			
			String sql = new StringBuilder()
					.append("SELECT\n")
					.append("	DATE_FORMAT(A.create_time, '%Y-%m-%d') AS create_date, \n")
					.append("	COUNT(*) AS all_count, \n")
					.append("	COUNT(*) - (select count(*) \n")
					.append("	FROM data_metal B \n")
					.append("	INNER JOIN sensor C ON B.sensor_id = C.sensor_id \n")
					.append("	LEFT JOIN event_info D ON B.event_code = D.event_code \n")
					.append("	WHERE B.tenant_id = '" + JDBCConnectionPool.getTenantId(conn) + "' \n")
					.append("	AND B.sensor_value <= D.max_value && B.sensor_value >= D.min_value \n")
					.append("	AND DATE_FORMAT(B.create_time, '%Y-%m-%d') = '"+ toDate +"' AND B.sensor_id like '"+sensorId+"%') AS detect_count \n")
					.append("	FROM data_metal A \n")
					.append("	WHERE DATE_FORMAT(A.create_time, '%Y-%m-%d') = '"+ toDate +"' \n")
					.append("	AND A.sensor_id like '"+sensorId+"%' \n")
					.append("  	GROUP BY DATE_FORMAT(A.create_time, '%Y-%m-%d') \n")
					.toString();
			
			logger.debug("sql:\n" + sql);
			
			rs = stmt.executeQuery(sql);
			
			List<CCPDataStatisticModel> cvmList = new ArrayList<CCPDataStatisticModel>();
			
			while(rs.next()) {
				CCPDataStatisticModel data = extractStatisticModelFromResultSet(rs);
				cvmList.add(data);
			}
			
			return cvmList;
			
		} catch (SQLException ex) {
			ex.printStackTrace();
		} finally {
		    try { rs.close(); } catch (Exception e) { /* Ignored */ }
		    try { stmt.close(); } catch (Exception e) { /* Ignored */ }
		}
		
		return null;
	};
	
	@Override
	public List<CCPDataMonitoringModel> getCCPDataMonitoringModel(Connection conn, String toDate) {
		
		try {
			stmt = conn.createStatement();
			
			String sql = new StringBuilder()
					.append("SELECT\n")
					.append("	A2.sensor_name, \n")
					.append("	DATE_FORMAT(A.create_time, '%Y-%m-%d') AS create_date, \n")
					.append("	COUNT(*) AS all_count, \n")
					.append("	IFNULL(COUNT(*) - (select count(*) \n")
					.append("	FROM data_metal B \n")
					.append("	INNER JOIN sensor C ON B.sensor_id = C.sensor_id \n")
					.append("	LEFT JOIN event_info D ON B.event_code = D.event_code \n")
					.append("	WHERE B.tenant_id = '" + JDBCConnectionPool.getTenantId(conn) + "' \n")
					.append("	AND B.sensor_value <= D.max_value && B.sensor_value >= D.min_value \n")
					.append("	AND DATE_FORMAT(B.create_time, '%Y-%m-%d') = '"+ toDate +"'			\n")
					//.append("	AND DATE_FORMAT(B.create_time, '%Y-%m-%d') = '2022-03-02'			\n")
					.append("	AND B.sensor_id like A.sensor_id||'%' \n")
					.append("	GROUP BY DATE_FORMAT(B.create_time, '%Y-%m-%d'), C.sensor_id), 0) AS detect_count \n")
					.append("	FROM data_metal A \n")
					.append("	INNER JOIN sensor A2 \n")
					.append("	ON A.sensor_id = A2.sensor_id \n")
					.append("	WHERE DATE_FORMAT(A.create_time, '%Y-%m-%d') = '"+ toDate +"' \n")
					//.append("	WHERE DATE_FORMAT(A.create_time, '%Y-%m-%d') = '2022-03-02' \n")
					.append("	AND A.tenant_id = '" + JDBCConnectionPool.getTenantId(conn) + "' \n")
					.append("	AND A.sensor_id like '%' \n")
					.append("  	GROUP BY DATE_FORMAT(A.create_time, '%Y-%m-%d'), A2.sensor_id \n")
					.toString();
			
			logger.debug("sql:\n" + sql);
			
			rs = stmt.executeQuery(sql);
			
			List<CCPDataMonitoringModel> cvmList = new ArrayList<CCPDataMonitoringModel>();
			
			while(rs.next()) {
				CCPDataMonitoringModel data = extractMonitoringModelFromResultSet(rs);
				cvmList.add(data);
			}
			
			return cvmList;
			
		} catch (SQLException ex) {
			ex.printStackTrace();
		} finally {
		    try { rs.close(); } catch (Exception e) { /* Ignored */ }
		    try { stmt.close(); } catch (Exception e) { /* Ignored */ }
		}
		
		return null;
	};
	
	@Override
	public List<CCPDataDetailViewModel> getMetalBreakAwayList(Connection conn, String sensorKey, String sensorId, String processCode, String toDate, String fromDate) {
		
		try {
			stmt = conn.createStatement();
			
			if(sensorId.equals("undefined")) {
				sensorId = "";
			}
			
			String sql = new StringBuilder()
					.append("SELECT\n")
					.append("	A.sensor_key,\n")
					.append("	B.sensor_name,\n")
					.append("	A.create_time,\n")
					.append("	C.event_name as event,\n")
					.append("	A.sensor_value,\n")
					.append("	IF(A.sensor_value <= C.max_value && A.sensor_value >= C.min_value, '적합', '부적합') as judge,\n")
					.append("	A.improvement_action \n")
					.append("FROM data_metal A\n")
					.append("INNER JOIN sensor B\n")
					.append("	ON A.sensor_id = B.sensor_id\n")
					.append("LEFT JOIN event_info C\n")
					.append("	ON A.event_code = C.event_code\n")
					.append("INNER JOIN ccp_limit D\n")
					.append("	ON A.event_code = D.event_code\n")
					.append("	AND A.product_id = D.product_id\n")
					.append("WHERE A.tenant_id = '" + JDBCConnectionPool.getTenantId(conn) + "'\n")
					.append("	AND DATE_FORMAT(A.create_time, '%Y-%m-%d') BETWEEN '"+ toDate +"' \n")
					.append("	AND '"+ fromDate +"' \n")
					.append("	AND A.sensor_id LIKE '%" + sensorId + "%'\n")
					.append("	AND A.process_code LIKE '" + processCode	+ "'\n")
					.append("	AND (A.sensor_value > C.max_value \n")
					.append("	OR A.sensor_value < C.min_value) \n")
					.toString();
			
			logger.debug("sql:\n" + sql);
			
			rs = stmt.executeQuery(sql);
			
			List<CCPDataDetailViewModel> cvmList = new ArrayList<CCPDataDetailViewModel>();
			
			while(rs.next()) {
				CCPDataDetailViewModel data = extractMetalBreakAwayFromResultSet(rs);
				cvmList.add(data);
			}
			
			return cvmList;
			
		} catch (SQLException ex) {
			ex.printStackTrace();
		} finally {
		    try { rs.close(); } catch (Exception e) { /* Ignored */ }
		    try { stmt.close(); } catch (Exception e) { /* Ignored */ }
		}
		
		return null;
	};
	
	@Override
	public List<CCPDataHeatingMonitoringModel> getAllCCPDataHeatingMonitoringModel(
			Connection conn, String sensorId, 
			String startDate, String endDate, 
			String processCode) {
		
		try {
			stmt = conn.createStatement();
			
			String sql = new StringBuilder()
					.append("SELECT\n")
					.append("	A.sensor_key,\n")
					.append("	B.sensor_name,\n")
					.append("	D.product_name,\n")
					.append("	DATE_FORMAT(A.create_time, \"%Y-%m-%d %H:%i\") AS create_time,\n")
					/*
					.append("	(\n")
					.append("		SELECT CASE\n")
					.append("			WHEN NOT EXISTS(\n")
					.append("				SELECT *\n")
					.append("				FROM data_metal aa\n")
					.append("				INNER JOIN event_info bb\n")
					.append("					ON aa.event_code = bb.event_code\n")
					.append("				WHERE aa.tenant_id = '" + JDBCConnectionPool.getTenantId(conn) + "'\n")
					.append("				  AND aa.sensor_key = A.sensor_key\n")
					.append("			 	  AND (aa.sensor_value > bb.max_value || aa.sensor_value < bb.min_value)\n")
					.append("			)\n")
					.append("			THEN '적합'\n")
					.append("			ELSE '부적합'\n")
					.append("			END\n")
					.append("	) AS complete_time,\n")
					*/
					.append("	IFNULL((SELECT DATE_FORMAT(A.create_time, \"%Y-%m-%d %H:%i\") FROM data_metal cc WHERE A.sensor_key = cc.sensor_key AND cc.event_code = 'HT40'), '') AS complete_time,\n")
					.append("	(\n")
					.append("		SELECT CASE \n")
					.append("			WHEN NOT EXISTS(\n")
					.append("				SELECT *\n")
					.append("				FROM data_metal aa\n")
					.append("				WHERE aa.tenant_id = '" + JDBCConnectionPool.getTenantId(conn) + "'\n")
					.append("				  AND aa.sensor_key = A.sensor_key\n")
					.append("				  AND aa.event_code = 'HT40' \n")
					.append("			)\n")
					.append("			THEN '미완료'\n")
					.append("			ELSE '완료'\n")
					.append("			END\n")
					.append("	) AS state \n")
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
					.append("  AND A.process_code LIKE '" + processCode	+ "'\n")
					.append("  AND B.sensor_id LIKE '" + sensorId + "'\n")
					.append("GROUP BY sensor_key\n")
					.toString();

			logger.debug("sql:\n" + sql);
			
			rs = stmt.executeQuery(sql);
			
			List<CCPDataHeatingMonitoringModel> cvmList = new ArrayList<CCPDataHeatingMonitoringModel>();
			
			while(rs.next()) {
				CCPDataHeatingMonitoringModel data = extractHeatingMonitoringModelFromResultSet(rs);
				cvmList.add(data);
			}
			
			return cvmList;
			
		} catch (SQLException ex) {
			ex.printStackTrace();
		} finally {
		    try { rs.close(); } catch (Exception e) { /* Ignored */ }
		    try { stmt.close(); } catch (Exception e) { /* Ignored */ }
		}
		
		return null;
	};
	
	@Override
	public List<CCPDataHeatingMonitoringGraphModel> getAllCCPDataHeatingMonitoringGraphModel(
			Connection conn, String sensorKey) {
			
		String sql = "";
		
		try {
			stmt = conn.createStatement();
			
			sql = new StringBuilder()
					.append("SELECT\n")
					.append("	 B.sensor_name,\n")
					.append("	 EXTRACT(MINUTE FROM A.create_time) - (SELECT EXTRACT(MINUTE FROM bb.create_time) FROM data_metal bb WHERE A.sensor_key = bb.sensor_key AND bb.event_code = 'HT10') AS each_minute,\n") //경과 시간
					.append("	 A.sensor_value, \n")
					.append("	 C.min_value, \n")
					.append("	 C.max_value \n")
					.append("FROM data_metal A\n")
					.append("INNER JOIN sensor B\n")
					.append("	ON A.sensor_id = B.sensor_id\n")
					.append("LEFT JOIN ccp_limit C\n")
					.append("	ON A.event_code = C.event_code \n")
					.append("	AND A.product_id = C.product_id \n")
					.append("WHERE A.tenant_id = '" + JDBCConnectionPool.getTenantId(conn) + "'\n")
					.append("AND A.sensor_key = '" + sensorKey + "'\n")
					.append("  AND A.event_code IN ('HT10', 'HT50') \n")
					.append("GROUP BY EXTRACT(MINUTE FROM A.create_time) \n")
					.append("ORDER BY EXTRACT(HOUR FROM A.create_time), EXTRACT(MINUTE FROM A.create_time) \n")
					.toString();

			logger.debug("sql:\n" + sql);
			
			rs = stmt.executeQuery(sql);
			
			List<CCPDataHeatingMonitoringGraphModel> cvmList = new ArrayList<CCPDataHeatingMonitoringGraphModel>();
			
			while(rs.next()) {
				CCPDataHeatingMonitoringGraphModel data = extractHeatingMonitoringGraphModelFromResultSet(rs);
				cvmList.add(data);
			}
			
			return cvmList;
			
		} catch (SQLException ex) {
			ex.printStackTrace();
		} finally {
		    try { rs.close(); } catch (Exception e) { /* Ignored */ }
		    try { stmt.close(); } catch (Exception e) { /* Ignored */ }
		}
		
		return null;
	};
	
	private CCPData extractFromResultSet(ResultSet rs) throws SQLException {
		CCPData ccpData = new CCPData();
		
		ccpData.setSensorKey(rs.getString("sensor_key"));
		ccpData.setSeqNo(rs.getInt("seq_no"));
		ccpData.setCreateTime(rs.getString("create_time"));
		ccpData.setSensorId(rs.getString("sensor_id"));
		ccpData.setSensorValue(Double.parseDouble(rs.getString("sensor_value")));
		ccpData.setImprovementAction(rs.getString("improvement_action"));
		ccpData.setUserId(rs.getString("user_id"));
		ccpData.setEventCode(rs.getString("event_code"));
		ccpData.setProductId(rs.getString("product_id"));
		
	    return ccpData;
	}
	
	private CCPTestDataHeadViewModel extractTestDataHeadFromResultSet(ResultSet rs) throws SQLException {
		CCPTestDataHeadViewModel ccpData = new CCPTestDataHeadViewModel();
		
		ccpData.setCreateDate(rs.getString("create_date"));
		ccpData.setSensorId(rs.getString("sensor_id"));
		ccpData.setSensorName(rs.getString("sensor_name"));
		
		return ccpData;
	}

	private CCPTestDataViewModel extractTestDataFromResultSet(ResultSet rs) throws SQLException {
		CCPTestDataViewModel ccpData = new CCPTestDataViewModel();
		
		ccpData.setSensorKey(rs.getString("sensor_key"));
		ccpData.setCreateTime(rs.getString("create_time"));
		ccpData.setSensorValue(rs.getString("sensor_value"));
		ccpData.setEventCode(rs.getString("event_code"));
		ccpData.setProductName(rs.getString("product_name"));
		
	    return ccpData;
	}
	
	private CCPDataHeadViewModel extractHeadViewModelFromResultSet(ResultSet rs) 
												throws SQLException {
		CCPDataHeadViewModel cvm = new CCPDataHeadViewModel();
		
		cvm.setSensorKey(rs.getString("sensor_key"));
		cvm.setProcessName(rs.getString("process_name"));
		cvm.setSensorName(rs.getString("sensor_name"));
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
	
	private CCPDataStatisticModel extractStatisticModelFromResultSet(ResultSet rs) throws SQLException {
		CCPDataStatisticModel cvm = new CCPDataStatisticModel();
		
		cvm.setCcpDate(rs.getString("create_date"));
		cvm.setCountAll(rs.getString("all_count"));
		cvm.setCountDetect(rs.getString("detect_count"));
		
		return cvm;
	}
	
	private CCPDataMonitoringModel extractMonitoringModelFromResultSet(ResultSet rs) throws SQLException {
		CCPDataMonitoringModel cvm = new CCPDataMonitoringModel();
		
		cvm.setSensorName(rs.getString("sensor_name"));
		cvm.setCcpDate(rs.getString("create_date"));
		cvm.setCountAll(rs.getString("all_count"));
		cvm.setCountDetect(rs.getString("detect_count"));
		
		return cvm;
	}
	
	// 이탈내용관리 - 금속검출
	private CCPDataDetailViewModel extractMetalBreakAwayFromResultSet(ResultSet rs) throws SQLException {
		CCPDataDetailViewModel cvm = new CCPDataDetailViewModel();
		
		cvm.setSensorKey(rs.getString("sensor_key"));
		cvm.setSensorName(rs.getString("sensor_name"));
		cvm.setCreateTime(rs.getTimestamp("create_time").toString());
		cvm.setEvent(rs.getString("event"));
		cvm.setSensorValue(rs.getString("sensor_value"));
		cvm.setJudge(rs.getString("judge"));
		cvm.setImprovementAction(rs.getString("improvement_action"));
		
		return cvm;
	}
	
	private CCPDataHeatingMonitoringModel extractHeatingMonitoringModelFromResultSet(ResultSet rs) 
			throws SQLException {
		CCPDataHeatingMonitoringModel cvm = new CCPDataHeatingMonitoringModel();

		cvm.setSensorKey(rs.getString("sensor_key"));
		cvm.setSensorName(rs.getString("sensor_name"));
		cvm.setProductName(rs.getString("product_name"));
		cvm.setCreateTime(rs.getTimestamp("create_time").toString());
		cvm.setCompleteTime(rs.getString("complete_time").toString());
		cvm.setState(rs.getString("state").toString());

		return cvm;
	}
	
	private CCPDataHeatingMonitoringGraphModel extractHeatingMonitoringGraphModelFromResultSet(ResultSet rs) 
			throws SQLException {
		CCPDataHeatingMonitoringGraphModel cvm = new CCPDataHeatingMonitoringGraphModel();

		cvm.setSensorName(rs.getString("sensor_name"));
		cvm.setEachMinute(rs.getString("each_minute"));
		cvm.setSensorValue(rs.getString("sensor_value"));
		cvm.setMinValue(rs.getString("min_value"));
		cvm.setMaxValue(rs.getString("max_value"));

		return cvm;
	}
	
}
