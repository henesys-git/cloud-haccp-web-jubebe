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
import viewmodel.KPIProductionViewModel;
import viewmodel.KPIQualityViewModel;

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
	public List<CCPTestDataHeadViewModel> getCCPTestDataHeadBySensorAndProd(
			Connection conn, String startDate, String endDate, String processCode) {
		
		try {
			stmt = conn.createStatement();
			
			String sql = new StringBuilder()
					.append("SELECT \n")
					.append("	CAST(A.create_time AS DATE) AS create_date,\n")
					.append("	A.sensor_id,\n")
					.append("	B.sensor_name,\n")
					.append("	A.product_id, \n")
					.append("	P.parent_id, \n")
					.append("	(SELECT product_name FROM product P2 WHERE P.parent_id = P2.product_id) AS parent_name \n")
					.append("FROM data_metal A\n")
					.append("INNER JOIN sensor B\n")
					.append("	ON A.sensor_id = B.sensor_id\n")
					.append("INNER JOIN product P\n")
					.append("	ON A.product_id = P.product_id\n")
					.append("WHERE A.tenant_id = '" + JDBCConnectionPool.getTenantId(conn) + "'	\n")
					.append("	AND CAST(A.create_time as date) BETWEEN '" + startDate + "' AND '" + endDate + "'\n")
					.append("	AND A.process_code = '" + processCode + "'\n")
					.append("GROUP BY CAST(A.create_time as date), A.sensor_id, A.product_id;\n")
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
	public List<CCPTestDataHeadViewModel> getCCPTestDataHeadBySensor(
			Connection conn, String startDate, String endDate, String processCode) {
		
		try {
			stmt = conn.createStatement();
			
			String sql = new StringBuilder()
					.append("SELECT \n")
					.append("	CAST(A.create_time AS DATE) AS create_date,\n")
					.append("	A.sensor_id,\n")
					.append("	B.sensor_name,\n")
					.append("	A.product_id, \n")
					.append("	P.parent_id, \n")
					.append("	(SELECT product_name FROM product P2 WHERE P.parent_id = P2.product_id) AS parent_name \n")
					.append("FROM data_metal A\n")
					.append("INNER JOIN sensor B\n")
					.append("	ON A.sensor_id = B.sensor_id\n")
					.append("INNER JOIN product P\n")
					.append("	ON A.product_id = P.product_id\n")
					.append("WHERE A.tenant_id = '" + JDBCConnectionPool.getTenantId(conn) + "'	\n")
					.append("	AND CAST(A.create_time as date) BETWEEN '" + startDate + "' AND '" + endDate + "'\n")
					.append("	AND A.process_code = '" + processCode + "'\n")
					.append("GROUP BY CAST(A.create_time as date), A.sensor_id;\n")
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
	public List<CCPTestDataHeadViewModel> getCCPTestDataHeadByProd(
			Connection conn, String startDate, String endDate, String processCode) {
		
		try {
			stmt = conn.createStatement();
			
			String sql = new StringBuilder()
					.append("SELECT \n")
					.append("	CAST(A.create_time AS DATE) AS create_date,\n")
					.append("	A.sensor_id,\n")
					.append("	B.sensor_name,\n")
					.append("	A.product_id, \n")
					.append("	P.parent_id, \n")
					.append("	(SELECT product_name FROM product P2 WHERE P.parent_id = P2.product_id) AS parent_name \n")
					.append("FROM data_metal A\n")
					.append("INNER JOIN sensor B\n")
					.append("	ON A.sensor_id = B.sensor_id\n")
					.append("INNER JOIN product P\n")
					.append("	ON A.product_id = P.product_id\n")
					.append("WHERE A.tenant_id = '" + JDBCConnectionPool.getTenantId(conn) + "'	\n")
					.append("	AND CAST(A.create_time as date) BETWEEN '" + startDate + "' AND '" + endDate + "'\n")
					.append("	AND A.process_code = '" + processCode + "'\n")
					.append("GROUP BY CAST(A.create_time as date), A.product_id;\n")
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
		/*
		String groupWhere = "";
		
		if(processCode.substring(0,2).equals("PC") == true) {
			groupWhere = "AND A.event_code != 'TEST' GROUP BY A.event_code";
		}
		*/
		
		try {
			stmt = conn.createStatement();
			
			String sql = new StringBuilder()
					.append("SELECT\n")
					.append("  B.product_name,\n")
					.append("  A.sensor_key,\n")
					.append("  A.create_time,\n")
					.append("  A.event_code,\n")
					//.append("  IF(A.event_code = 'MC30' && A.sensor_value = 1, '1.1', A.sensor_value) AS sensor_value \n") //금속검출기의 제품의 경우 결과값 검출(1) 일때, 판정을 위해 쿼리 결과값 1.1로 세팅
					.append("  (SELECT CASE \n")
					.append("   	WHEN A.event_code = 'MC30' && A.sensor_value = 1 THEN '1.1' \n")
					//.append("   	WHEN A.event_code = 'MC30' && A.sensor_value = 0 THEN '0.1' \n")
					.append("   	ELSE A.sensor_value \n")
					.append("   END) AS sensor_value, \n")
					.append("   C.min_value, \n")
					.append("   C.max_value \n")
					.append("FROM data_metal A\n")
					.append("INNER JOIN product B\n")
					.append("  ON A.product_id = B.product_id\n")
					.append("INNER JOIN ccp_limit C\n")
					.append("  ON A.event_code = C.event_code \n")
					.append("  AND A.product_id = C.object_id\n")
					.append("WHERE A.tenant_id = '" + JDBCConnectionPool.getTenantId(conn) + "'	\n")
					.append("  AND CAST(create_time AS DATE) = '" + date + "' \n")
					.append("  AND process_code = '" + processCode + "'\n")
					.append("  AND sensor_id = '" + sensorId + "'\n")
					//.append(" " + groupWhere + "\n")
					.append("ORDER BY sensor_key, create_time ASC;\n")
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
			
			String targetTable = "";
			
			if(processCode.equals("PC20")) {
				targetTable = "data_process2";
			}
			else {
				targetTable = "data_metal";
			}
			
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
					//.append("				FROM data_metal aa\n")
					.append("				FROM " +targetTable+ " aa \n")
					.append("				INNER JOIN ccp_limit bb\n")
					.append("					ON aa.event_code = bb.event_code\n")
					.append("					AND aa.product_id = bb.object_id\n")
					.append("				WHERE aa.tenant_id = '" + JDBCConnectionPool.getTenantId(conn) + "'\n")
					.append("				  AND aa.sensor_key = A.sensor_key\n")
					//.append("			 	  AND (aa.sensor_value > bb.max_value || aa.sensor_value < bb.min_value)\n")
					.append("                 AND IF(aa.event_code = 'CR10' || aa.event_code = 'CR20' || aa.event_code = 'CR50' || aa.event_code = 'HT10' || aa.event_code = 'HT15' || aa.event_code = 'HT50' || aa.event_code = 'HT55', CAST(aa.sensor_value AS double) > CAST(bb.max_value AS double) || CAST(aa.sensor_value AS double) < CAST(bb.min_value AS double), aa.sensor_value > bb.max_value || aa.sensor_value < bb.min_value) \n")
					.append("			)\n")
					.append("			THEN '적합'\n")
					.append("			ELSE '부적합'\n")
					.append("			END\n")
					.append("	) AS judge,\n")
					.append("	(\n")
					.append("		SELECT CASE \n")
					.append("			WHEN NOT EXISTS(\n")
					.append("				SELECT *\n")
					//.append("				FROM data_metal aa\n")
					.append("				FROM " +targetTable+ " aa \n")
					.append("				INNER JOIN ccp_limit bb\n")
					.append("					ON aa.event_code = bb.event_code\n")
					.append("					AND aa.product_id = bb.object_id\n")
					.append("				WHERE aa.tenant_id = '" + JDBCConnectionPool.getTenantId(conn) + "'\n")
					.append("				  AND aa.sensor_key = A.sensor_key\n")
					//.append("			 	  AND (aa.sensor_value > bb.max_value || aa.sensor_value < bb.min_value)\n")
					.append("                 AND IF(aa.event_code = 'CR10' || aa.event_code = 'CR20' || aa.event_code = 'CR50' || aa.event_code = 'HT10' || aa.event_code = 'HT15' || aa.event_code = 'HT50' || aa.event_code = 'HT55', CAST(aa.sensor_value AS double) > CAST(bb.max_value AS double) || CAST(aa.sensor_value AS double) < CAST(bb.min_value AS double), aa.sensor_value > bb.max_value || aa.sensor_value < bb.min_value) \n")
					.append("			 	  AND aa.improvement_action is null \n")
					.append("			)\n")
					.append("			THEN '완료'\n")
					.append("			ELSE '미완료'\n")
					.append("			END\n")
					.append("	) AS improvement_completion \n")
					//.append("FROM data_metal A\n")
					.append("				FROM " +targetTable+ " A \n")
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
	
	//2023-03-24 한계기준 값 비교 안되는 현상 때문에 비교절 수정 (event_code 하드코딩 방식)
	@Override
	public List<CCPDataDetailViewModel> getAllCCPDataDetailViewModel(Connection conn, String sensorKey, String processCode) {
		
		try {
			stmt = conn.createStatement();
			
			String targetTable = "";
			
			System.out.println("processCode : " + processCode);
			
			if(processCode.equals("PC20")) {
				targetTable = "data_process2";
			}
			else {
				targetTable = "data_metal";
			}
			
			String sql = new StringBuilder()
					.append("SELECT\n")
					.append("	B.sensor_name,\n")
					.append("	A.create_time,\n")
					.append("	C.event_name as event,\n")
					.append("	A.sensor_value,\n")
					.append("	D.min_value,\n")
					.append("	D.max_value,\n")
					.append("   IF(A.event_code = 'CR10' || A.event_code = 'CR20' || A.event_code = 'CR50' || A.event_code = 'HT10' || A.event_code = 'HT15' || A.event_code = 'HT50' || A.event_code = 'HT55', \n")
					.append("   IF(CAST(A.sensor_value AS double) <= CAST(D.max_value AS double) && CAST(A.sensor_value AS double) >= CAST(D.min_value AS double), '적합', '부적합'), \n")
					.append("   IF(A.sensor_value <= D.max_value && A.sensor_value >= D.min_value, '적합', '부적합') \n")
					.append("   ) AS judge, \n")
					.append("	A.improvement_action\n")
					//.append("FROM data_metal A\n")
					.append("FROM " + targetTable + " A \n")
					.append("INNER JOIN sensor B\n")
					.append("	ON A.sensor_id = B.sensor_id\n")
					.append("LEFT JOIN event_info C\n")
					.append("	ON A.event_code = C.event_code\n")
					.append("INNER JOIN ccp_limit D\n")
					.append("	ON A.event_code = D.event_code\n")
					.append("	AND A.product_id = D.object_id\n")
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
	public boolean fixLimitOutAll(Connection conn, String date, String date2, String improvementAction, String processCode) {
		try {
			stmt = conn.createStatement();
			
			String sql = new StringBuilder()
					.append("UPDATE data_metal\n")
					.append("SET improvement_action = '" + improvementAction + "'\n")
					.append("WHERE tenant_id = '" + JDBCConnectionPool.getTenantId(conn) + "'\n")
					.append("	AND DATE_FORMAT(create_time, '%Y-%m-%d') BETWEEN '" + date + "'\n")
					.append("	AND '" + date2 + "'\n")
					.append("	AND process_code like '%" + processCode + "%'\n")
					.append("	AND improvement_action IS NULL \n")
					.toString();
			
			logger.debug("sql:\n" + sql);

			int i = stmt.executeUpdate(sql);

	        if(i >= 1) {
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
	public List<CCPDataMonitoringModel> getCCPDataMonitoringModel(Connection conn, String toDate, String processCode) {
		
		try {
			stmt = conn.createStatement();
			
			String sql = new StringBuilder()
					.append("SELECT\n")
					.append("	A2.sensor_name, \n")
					.append("	DATE_FORMAT(A.create_time, '%Y-%m-%d') AS create_date, \n")
					.append("	COUNT(*) AS all_count, \n")
					.append("	IFNULL(COUNT(*) - (select count(*) \n")
					.append("	FROM data_metal B \n")
					.append("	LEFT JOIN event_info D ON B.event_code = D.event_code \n")
					.append("	WHERE B.tenant_id = '" + JDBCConnectionPool.getTenantId(conn) + "' \n")
					.append("	AND B.sensor_value <= D.max_value && B.sensor_value >= D.min_value \n")
					.append("	AND DATE_FORMAT(B.create_time, '%Y-%m-%d') = '"+ toDate +"'			\n")
					.append("	AND B.sensor_id like A.sensor_id||'%' \n")
					.append("	GROUP BY DATE_FORMAT(B.create_time, '%Y-%m-%d'), B.sensor_id), 0) AS detect_count \n")
					.append("	FROM data_metal A \n")
					.append("	INNER JOIN sensor A2 \n")
					.append("	ON A.sensor_id = A2.sensor_id \n")
					.append("	WHERE DATE_FORMAT(A.create_time, '%Y-%m-%d') = '"+ toDate +"' \n")
					.append("	AND A.tenant_id = '" + JDBCConnectionPool.getTenantId(conn) + "' \n")
					.append("	AND A.sensor_id like '%' \n")
					.append("	AND A.process_code = '" + processCode + "' \n")
					.append("  	GROUP BY DATE_FORMAT(A.create_time, '%Y-%m-%d'), A.sensor_id \n")
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
	
	//부적합, 적합 여부 하드코딩 방식으로 변경(2023.04.07)
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
					.append("	E.product_name,\n")
					.append("	A.create_time,\n")
					.append("	C.event_name as event,\n")
					.append("	A.sensor_value,\n")
					.append("   IF(A.event_code = 'CR10' || A.event_code = 'CR20' || A.event_code = 'CR50' || A.event_code = 'HT10' || A.event_code = 'HT15' || A.event_code = 'HT50' || A.event_code = 'HT55', \n")
					.append("   IF(CAST(A.sensor_value AS double) <= CAST(D.max_value AS double) && CAST(A.sensor_value AS double) >= CAST(D.min_value AS double), '적합', '부적합'), \n")
					.append("   IF(A.sensor_value <= D.max_value && A.sensor_value >= D.min_value, '적합', '부적합') \n")
					.append("   ) AS judge, \n")
					//.append("	IF(A.sensor_value <= D.max_value && A.sensor_value >= D.min_value, '적합', '부적합') as judge,\n")
					.append("	A.improvement_action, \n")
					.append("	A.sensor_id \n")
					.append("FROM data_metal A\n")
					.append("INNER JOIN sensor B\n")
					.append("	ON A.sensor_id = B.sensor_id\n")
					.append("LEFT JOIN event_info C\n")
					.append("	ON A.event_code = C.event_code\n")
					.append("INNER JOIN ccp_limit D\n")
					.append("	ON A.event_code = D.event_code\n")
					.append("	AND A.product_id = D.object_id\n")
					.append("INNER JOIN product E\n")
					.append("	ON A.product_id = E.product_id \n")
					.append("WHERE A.tenant_id = '" + JDBCConnectionPool.getTenantId(conn) + "'\n")
					.append("	AND DATE_FORMAT(A.create_time, '%Y-%m-%d') BETWEEN '"+ toDate +"' \n")
					.append("	AND '"+ fromDate +"' \n")
					.append("	AND A.sensor_id LIKE '%" + sensorId + "%'\n")
					.append("	AND A.process_code LIKE '%" + processCode	+ "%'\n")
					.append("	AND IF(A.event_code = 'CR10' || A.event_code = 'CR20' || A.event_code = 'CR50' || A.event_code = 'HT10' || A.event_code = 'HT15' || A.event_code = 'HT50' || A.event_code = 'HT55', \n")
					.append("	CAST(A.sensor_value AS double) > CAST(D.max_value AS double) || CAST(A.sensor_value AS double) < CAST(D.min_value AS double), A.sensor_value > D.max_value || A.sensor_value < D.min_value) \n")
					//.append("	AND (A.sensor_value > D.max_value \n")
					//.append("	OR A.sensor_value < D.min_value) \n")
					.append("	AND A.sensor_id NOT LIKE '%TP%' \n")
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
					.append("	IFNULL((SELECT DATE_FORMAT(cc.create_time, \"%Y-%m-%d %H:%i\") FROM data_metal cc WHERE A.sensor_key = cc.sensor_key AND cc.event_code = 'HT30'), '') AS create_time, \n")
					.append("	IFNULL((SELECT DATE_FORMAT(cc.create_time, \"%Y-%m-%d %H:%i\") FROM data_metal cc WHERE A.sensor_key = cc.sensor_key AND cc.event_code = 'HT40'), '') AS complete_time, \n")
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
					.append("	) AS state, \n")
					.append("	A.sensor_id \n")
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
			Connection conn, String sensorKey, String sensorId) {
			
		String sql = "";
		String startTime = "";
		String endTime = "";
		
		try {
			stmt = conn.createStatement();
			
			sql = new StringBuilder()
					.append("SELECT \n")
					.append("create_time \n")
					.append("FROM data_metal \n")
					.append("WHERE sensor_key = '"+sensorKey +"' \n")
					.append("AND event_code = 'HT30' \n")
					.toString();
			
			rs = stmt.executeQuery(sql);
			
			while(rs.next()) {
				startTime = rs.getString("create_time");
			}
			
			//stmt.close();
			rs.close();
			
			sql = new StringBuilder()
					.append("SELECT \n")
					.append("create_time \n")
					.append("FROM data_metal \n")
					.append("WHERE sensor_key = '"+sensorKey +"' \n")
					.append("AND event_code = 'HT40' \n")
					.toString();
			
			rs = stmt.executeQuery(sql);
			
			while(rs.next()) {
				endTime = rs.getString("create_time");
			}
			
			//stmt.close();
			rs.close();
			
			//해당 채번키의 종료시간 없으면 온도 데이터 쌓인 것 중 MAX 시간 가져옴
			if(endTime.equals("")) {
				sql = new StringBuilder()
						.append("SELECT \n")
						.append("MAX(create_time) AS create_time \n")
						.append("FROM data_metal \n")
						.append("WHERE process_code = 'PC60'\n")
						.append("AND event_code = 'TP10'\n")
						.toString();
				
				rs = stmt.executeQuery(sql);
				
				while(rs.next()) {
					endTime = rs.getString("create_time");
				}
				
				//stmt.close();
				rs.close();
				
			}
			
			//2분마다 추가되는 온도 데이터들 앞에 시작 시간 데이터 추가
			sql = new StringBuilder()
					.append("SELECT\n")
					.append("	 B.sensor_name,\n")
					.append("	 DATE_FORMAT(A.create_time, '%Y-%m-%d %H:%i') AS each_minute,\n") //경과 시간
					.append("	 A.sensor_value, \n")
					.append("	 C.min_value, \n")
					.append("	 C.max_value, \n")
					.append("	 A.tenant_id \n")
					.append("FROM data_metal A\n")
					.append("INNER JOIN sensor B\n")
					.append("	ON A.sensor_id = B.sensor_id\n")
					.append("LEFT JOIN ccp_limit C\n")
					.append("	ON A.event_code = C.event_code \n")
					.append("	AND A.product_id = C.object_id \n")
					.append("WHERE A.tenant_id = '" + JDBCConnectionPool.getTenantId(conn) + "'\n")
					//.append("AND A.create_time BETWEEN '"+ startTime +"' AND '"+endTime+"' \n")
					.append("AND A.process_code = 'PC30'\n")
					.append("AND A.event_code = 'HT10'\n")
					//.append("AND A.sensor_id = '"+ sensorId+"' \n")
					.append("AND A.sensor_key = '" + sensorKey + "'\n")
					//.append("  AND A.event_code IN ('HT10', 'HT50') \n")
					//.append("GROUP BY EXTRACT(MINUTE FROM A.create_time) \n")
					//.append("ORDER BY EXTRACT(HOUR FROM A.create_time), EXTRACT(MINUTE FROM A.create_time) \n")
					//.append("LIMIT 30 \n")
					.toString();
					
			logger.debug("sql:\n" + sql);
			
			rs = stmt.executeQuery(sql);
			
			List<CCPDataHeatingMonitoringGraphModel> cvmList = new ArrayList<CCPDataHeatingMonitoringGraphModel>();
			
			while(rs.next()) {
				CCPDataHeatingMonitoringGraphModel data2 = extractHeatingMonitoringGraphModelFromResultSet(rs);
				cvmList.add(data2);
			}
			
			rs.close();
			
			//2분마다 추가되는 온도 데이터
			sql = new StringBuilder()
					/*
					.append("SELECT\n")
					.append("	 B.sensor_name,\n")
					//.append("	 EXTRACT(MINUTE FROM A.create_time) - (SELECT EXTRACT(MINUTE FROM bb.create_time) FROM data_metal bb WHERE A.sensor_key = bb.sensor_key AND bb.event_code = 'HT10') AS each_minute,\n") //경과 시간
					//.append("	 SELECT DATE_FORMAT(create_time, '%Y-%m-%d %H:%i') FROM data_metal bb where EXTRACT(MINUTE FROM A.create_time) - (SELECT EXTRACT(MINUTE FROM bb.create_time) FROM data_metal bb WHERE A.sensor_key = bb.sensor_key AND bb.event_code = 'HT10') AS each_minute,\n") //경과 시간
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
					//.append("AND A.sensor_key = '" + sensorKey + "'\n")
					//.append("  AND A.event_code IN ('HT10', 'HT50') \n")
					.append("GROUP BY EXTRACT(MINUTE FROM A.create_time) \n")
					.append("ORDER BY EXTRACT(HOUR FROM A.create_time), EXTRACT(MINUTE FROM A.create_time) \n")
					.toString();
					*/
					.append("SELECT\n")
					.append("	 B.sensor_name,\n")
					.append("	 DATE_FORMAT(A.create_time, '%Y-%m-%d %H:%i') AS each_minute,\n") //경과 시간
					.append("	 A.sensor_value, \n")
					.append("	 C.min_value, \n")
					.append("	 C.max_value, \n")
					.append("	 A.tenant_id \n")
					.append("FROM data_metal A\n")
					.append("INNER JOIN sensor B\n")
					.append("	ON A.sensor_id = B.sensor_id\n")
					.append("LEFT JOIN ccp_limit C\n")
					.append("	ON A.event_code = C.event_code \n")
					.append("	AND A.sensor_id = C.object_id \n")
					.append("WHERE A.tenant_id = '" + JDBCConnectionPool.getTenantId(conn) + "'\n")
					.append("AND A.create_time BETWEEN '"+ startTime +"' AND '"+endTime+"' \n")
					.append("AND A.process_code = 'PC60'\n")
					.append("AND A.event_code = 'TP10'\n")
					.append("AND A.sensor_id = '"+ sensorId+"' \n")
					//.append("AND A.sensor_key = '" + sensorKey + "'\n")
					//.append("  AND A.event_code IN ('HT10', 'HT50') \n")
					.append("GROUP BY EXTRACT(MINUTE FROM A.create_time) \n")
					.append("ORDER BY EXTRACT(HOUR FROM A.create_time), EXTRACT(MINUTE FROM A.create_time) \n")
					//.append("LIMIT 30 \n")
					.toString();
					
			logger.debug("sql:\n" + sql);
			
			rs = stmt.executeQuery(sql);
			
			while(rs.next()) {
				CCPDataHeatingMonitoringGraphModel data = extractHeatingMonitoringGraphModelFromResultSet(rs);
				cvmList.add(data);
			}
			
			rs.close();
			
			
			/*
			//2분마다 추가되는 온도 데이터들 맨 뒤에 종료 시간 데이터 추가
			sql = new StringBuilder()
					.append("SELECT\n")
					.append("	 B.sensor_name,\n")
					.append("	 DATE_FORMAT(A.create_time, '%Y-%m-%d %H:%i') AS each_minute,\n") //경과 시간
					.append("	 A.sensor_value, \n")
					.append("	 C.min_value, \n")
					.append("	 C.max_value, \n")
					.append("	 A.tenant_id \n")
					.append("FROM data_metal A\n")
					.append("INNER JOIN sensor B\n")
					.append("	ON A.sensor_id = B.sensor_id\n")
					.append("LEFT JOIN ccp_limit C\n")
					.append("	ON A.event_code = C.event_code \n")
					.append("	AND A.product_id = C.object_id \n")
					.append("WHERE A.tenant_id = '" + JDBCConnectionPool.getTenantId(conn) + "'\n")
					//.append("AND A.create_time BETWEEN '"+ startTime +"' AND '"+endTime+"' \n")
					.append("AND A.process_code = 'PC30'\n")
					.append("AND A.event_code = 'HT50'\n")
					//.append("AND A.sensor_id = '"+ sensorId+"' \n")
					.append("AND A.sensor_key = '" + sensorKey + "'\n")
					.append("ORDER BY each_minute DESC \n")
					.append("LIMIT 1 \n")
					//.append("  AND A.event_code IN ('HT10', 'HT50') \n")
					//.append("GROUP BY EXTRACT(MINUTE FROM A.create_time) \n")
					//.append("ORDER BY EXTRACT(HOUR FROM A.create_time), EXTRACT(MINUTE FROM A.create_time) \n")
					//.append("LIMIT 30 \n")
					.toString();
					
			logger.debug("sql:\n" + sql);
			
			rs = stmt.executeQuery(sql);
			
			while(rs.next()) {
				CCPDataHeatingMonitoringGraphModel data3 = extractHeatingMonitoringGraphModelFromResultSet(rs);
				cvmList.add(data3);
			}
			
			rs.close();
			*/
			
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
	public List<CCPDataHeatingMonitoringGraphModel> getAllCCPDataHeatingMonitoringGraphModel2(
			Connection conn, String sensorKey, String sensorId) {
			
		String sql = "";
		String startTime = "";
		String endTime = "";
		
		try {
			stmt = conn.createStatement();
			
			sql = new StringBuilder()
					.append("SELECT \n")
					.append("create_time \n")
					.append("FROM data_metal \n")
					.append("WHERE sensor_key = '"+sensorKey +"' \n")
					.append("AND event_code = 'HT30' \n")
					.toString();
			
			rs = stmt.executeQuery(sql);
			
			while(rs.next()) {
				startTime = rs.getString("create_time");
			}
			
			//stmt.close();
			rs.close();
			
			sql = new StringBuilder()
					.append("SELECT \n")
					.append("create_time \n")
					.append("FROM data_metal \n")
					.append("WHERE sensor_key = '"+sensorKey +"' \n")
					.append("AND event_code = 'HT40' \n")
					.toString();
			
			rs = stmt.executeQuery(sql);
			
			while(rs.next()) {
				endTime = rs.getString("create_time");
			}
			
			//stmt.close();
			rs.close();
			
			//해당 채번키의 종료시간 없으면 온도 데이터 쌓인 것 중 MAX 시간 가져옴
			if(endTime.equals("")) {
				sql = new StringBuilder()
						.append("SELECT \n")
						.append("MAX(create_time) AS create_time \n")
						.append("FROM data_metal \n")
						.append("WHERE process_code = 'PC60'\n")
						.append("AND event_code = 'TP10'\n")
						.append("AND sensor_id = '"+sensorId +"' \n")
						.toString();
				
				rs = stmt.executeQuery(sql);
				
				while(rs.next()) {
					endTime = rs.getString("create_time");
				}
				
				//stmt.close();
				rs.close();
				
			}
			
			//2분마다 추가되는 온도 데이터들 앞에 시작 시간 데이터 추가
			sql = new StringBuilder()
					.append("SELECT\n")
					.append("	 B.sensor_name,\n")
					.append("	 DATE_FORMAT(A.create_time, '%Y-%m-%d %H:%i') AS each_minute,\n") //경과 시간
					.append("	 A.sensor_value, \n")
					.append("	 C.min_value, \n")
					.append("	 C.max_value \n")
					.append("FROM data_metal A\n")
					.append("INNER JOIN sensor B\n")
					.append("	ON A.sensor_id = B.sensor_id\n")
					.append("LEFT JOIN ccp_limit C\n")
					.append("	ON A.event_code = C.event_code \n")
					.append("	AND A.product_id = C.object_id \n")
					.append("WHERE A.tenant_id = '" + JDBCConnectionPool.getTenantId(conn) + "'\n")
					//.append("AND A.create_time BETWEEN '"+ startTime +"' AND '"+endTime+"' \n")
					.append("AND A.process_code = 'PC30'\n")
					.append("AND A.event_code = 'HT15'\n")
					//.append("AND A.sensor_id = '"+ sensorId+"' \n")
					.append("AND A.sensor_key = '" + sensorKey + "'\n")
					//.append("  AND A.event_code IN ('HT10', 'HT50') \n")
					//.append("GROUP BY EXTRACT(MINUTE FROM A.create_time) \n")
					//.append("ORDER BY EXTRACT(HOUR FROM A.create_time), EXTRACT(MINUTE FROM A.create_time) \n")
					//.append("LIMIT 30 \n")
					.toString();
					
			logger.debug("sql:\n" + sql);
			
			rs = stmt.executeQuery(sql);
			
			List<CCPDataHeatingMonitoringGraphModel> cvmList = new ArrayList<CCPDataHeatingMonitoringGraphModel>();
			
			while(rs.next()) {
				CCPDataHeatingMonitoringGraphModel data2 = extractHeatingMonitoringGraphModelFromResultSet(rs);
				cvmList.add(data2);
			}
			
			rs.close();
			
			//2분마다 추가되는 온도 데이터
			sql = new StringBuilder()
					.append("SELECT\n")
					.append("	 B.sensor_name,\n")
					.append("	 DATE_FORMAT(A.create_time, '%Y-%m-%d %H:%i') AS each_minute,\n") //경과 시간
					.append("	 A.sensor_value, \n")
					.append("	 C.min_value, \n")
					.append("	 C.max_value \n")
					.append("FROM data_metal A\n")
					.append("INNER JOIN sensor B\n")
					.append("	ON A.sensor_id = B.sensor_id\n")
					.append("LEFT JOIN ccp_limit C\n")
					.append("	ON A.event_code = C.event_code \n")
					.append("	AND A.sensor_id = C.object_id \n")
					.append("WHERE A.tenant_id = '" + JDBCConnectionPool.getTenantId(conn) + "'\n")
					.append("AND A.create_time BETWEEN '"+ startTime +"' AND '"+endTime+"' \n")
					.append("AND A.process_code = 'PC60'\n")
					.append("AND A.event_code = 'TP10'\n")
					.append("AND A.sensor_id = '"+ sensorId+"' \n")
					//.append("AND A.sensor_key = '" + sensorKey + "'\n")
					//.append("  AND A.event_code IN ('HT10', 'HT50') \n")
					.append("GROUP BY EXTRACT(MINUTE FROM A.create_time) \n")
					.append("ORDER BY EXTRACT(HOUR FROM A.create_time), EXTRACT(MINUTE FROM A.create_time) \n")
					//.append("LIMIT 30 \n")
					.toString();
					
			logger.debug("sql:\n" + sql);
			
			rs = stmt.executeQuery(sql);
			
			while(rs.next()) {
				CCPDataHeatingMonitoringGraphModel data = extractHeatingMonitoringGraphModelFromResultSet(rs);
				cvmList.add(data);
			}
			
			rs.close();
			
			
			/*
			//2분마다 추가되는 온도 데이터들 맨 뒤에 종료 시간 데이터 추가
			sql = new StringBuilder()
					.append("SELECT\n")
					.append("	 B.sensor_name,\n")
					.append("	 DATE_FORMAT(A.create_time, '%Y-%m-%d %H:%i') AS each_minute,\n") //경과 시간
					.append("	 A.sensor_value, \n")
					.append("	 C.min_value, \n")
					.append("	 C.max_value \n")
					.append("FROM data_metal A\n")
					.append("INNER JOIN sensor B\n")
					.append("	ON A.sensor_id = B.sensor_id\n")
					.append("LEFT JOIN ccp_limit C\n")
					.append("	ON A.event_code = C.event_code \n")
					.append("	AND A.product_id = C.object_id \n")
					.append("WHERE A.tenant_id = '" + JDBCConnectionPool.getTenantId(conn) + "'\n")
					//.append("AND A.create_time BETWEEN '"+ startTime +"' AND '"+endTime+"' \n")
					.append("AND A.process_code = 'PC30'\n")
					.append("AND A.event_code = 'HT55'\n")
					//.append("AND A.sensor_id = '"+ sensorId+"' \n")
					.append("AND A.sensor_key = '" + sensorKey + "'\n")
					.append("ORDER BY each_minute DESC \n")
					.append("LIMIT 1 \n")
					//.append("  AND A.event_code IN ('HT10', 'HT50') \n")
					//.append("GROUP BY EXTRACT(MINUTE FROM A.create_time) \n")
					//.append("ORDER BY EXTRACT(HOUR FROM A.create_time), EXTRACT(MINUTE FROM A.create_time) \n")
					//.append("LIMIT 30 \n")
					.toString();
					
			logger.debug("sql:\n" + sql);
			
			rs = stmt.executeQuery(sql);
			
			while(rs.next()) {
				CCPDataHeatingMonitoringGraphModel data3 = extractHeatingMonitoringGraphModelFromResultSet(rs);
				cvmList.add(data3);
			}
			
			rs.close();
			*/
			
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
	public List<KPIProductionViewModel> getKPIProduction(Connection conn, String processCode, String toDate, String fromDate) {
		
		try {
			stmt = conn.createStatement();
			
			String sql = new StringBuilder()
					.append("SELECT\n")
					.append("	A.sensor_key,\n")
					.append("	MIN(A.create_time) AS start_time,\n")
					.append("	MAX(A.create_time) AS finish_time,\n")
					.append("	B.product_name,\n")
					.append("	ROUND(TIMESTAMPDIFF(SECOND, MIN(A.create_time), MAX(A.create_time)) / 60, 2) AS spent_time,\n")
					.append("	SUM(A.sensor_value) AS total_production,\n")
					.append("	ROUND(SUM(A.sensor_value) / (TIMESTAMPDIFF(SECOND, MIN(A.create_time), MAX(A.create_time)) / 60), 2) AS production_per_minute \n")
					.append("FROM data_metal A\n")
					.append("INNER JOIN product B\n")
					.append("	ON A.product_id = B.product_id\n")
					.append("WHERE A.tenant_id = '" + JDBCConnectionPool.getTenantId(conn) + "'\n")
					.append("	AND DATE_FORMAT(A.create_time, '%Y-%m-%d') BETWEEN '"+ toDate +"' \n")
					.append("												   AND '"+ fromDate +"' \n")
					.append("	AND A.process_code = '" + processCode	+ "'\n")
					.append("GROUP BY sensor_key \n")
					.toString();
			
			logger.debug("sql:\n" + sql);
			
			rs = stmt.executeQuery(sql);
			
			List<KPIProductionViewModel> list = new ArrayList<KPIProductionViewModel>();
			
			while(rs.next()) {
				KPIProductionViewModel data = extractKPIProductionViewModelFromResultSet(rs);
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
	public List<KPIQualityViewModel> getKPIQuality(Connection conn, String processCode, String toDate, String fromDate, String sensorId) {
		
		try {
			stmt = conn.createStatement();
			
			String sql = new StringBuilder()
					.append("SELECT\n")
					.append("	DATE_FORMAT(create_time, '%Y-%m') AS data_month,\n")
					.append("	COUNT(*) AS total_count,\n")
					.append("	COUNT(CASE WHEN sensor_value = 1 THEN 1 END) AS total_detection\n")
					.append("FROM data_metal\n")
					.append("WHERE tenant_id = '" + JDBCConnectionPool.getTenantId(conn) + "'\n")
					.append("	AND YEAR(create_time) = '"+ toDate +"' \n")
					.append("	AND process_code = '" + processCode	+ "'\n")
					.append("	AND sensor_id LIKE '%" + sensorId	+ "%' \n")
					.append("GROUP BY MONTH(create_time) \n")
					.toString();
			
			logger.debug("sql:\n" + sql);
			
			rs = stmt.executeQuery(sql);
			
			List<KPIQualityViewModel> list = new ArrayList<KPIQualityViewModel>();
			
			while(rs.next()) {
				KPIQualityViewModel data = extractKPIQualityViewModelFromResultSet(rs);
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
		ccpData.setProductId(rs.getString("product_id"));
		ccpData.setParentId(rs.getString("parent_id"));
		ccpData.setParentName(rs.getString("parent_name"));
		
		return ccpData;
	}

	private CCPTestDataViewModel extractTestDataFromResultSet(ResultSet rs) throws SQLException {
		CCPTestDataViewModel ccpData = new CCPTestDataViewModel();
		
		ccpData.setSensorKey(rs.getString("sensor_key"));
		ccpData.setCreateTime(rs.getString("create_time"));
		ccpData.setSensorValue(rs.getString("sensor_value"));
		ccpData.setEventCode(rs.getString("event_code"));
		ccpData.setProductName(rs.getString("product_name"));
		ccpData.setMinValue(rs.getString("min_value"));
		ccpData.setMaxValue(rs.getString("max_value"));
		
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
		cvm.setMinValue(rs.getString("min_value"));
		cvm.setMaxValue(rs.getString("max_value"));
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
		cvm.setProductName(rs.getString("product_name"));
		cvm.setCreateTime(rs.getTimestamp("create_time").toString());
		cvm.setEvent(rs.getString("event"));
		cvm.setSensorValue(rs.getString("sensor_value"));
		cvm.setJudge(rs.getString("judge"));
		cvm.setImprovementAction(rs.getString("improvement_action"));
		cvm.setSensorId(rs.getString("sensor_id"));
		
		return cvm;
	}
	
	private CCPDataHeatingMonitoringModel extractHeatingMonitoringModelFromResultSet(ResultSet rs) 
			throws SQLException {
		CCPDataHeatingMonitoringModel cvm = new CCPDataHeatingMonitoringModel();

		cvm.setSensorKey(rs.getString("sensor_key"));
		cvm.setSensorName(rs.getString("sensor_name"));
		cvm.setProductName(rs.getString("product_name"));
		cvm.setCreateTime(rs.getString("create_time").toString());
		cvm.setCompleteTime(rs.getString("complete_time").toString());
		cvm.setState(rs.getString("state").toString());
		cvm.setSensorId(rs.getString("sensor_id").toString());
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
		cvm.setTenantId(rs.getString("tenant_id"));

		return cvm;
	}
	
	private KPIProductionViewModel extractKPIProductionViewModelFromResultSet(ResultSet rs) 
			throws SQLException {
		KPIProductionViewModel vm = new KPIProductionViewModel();
		
		vm.setSensorKey(rs.getString("sensor_key"));
		vm.setStartTime(rs.getTimestamp("start_time").toString());
		vm.setFinishTime(rs.getTimestamp("finish_time").toString());
		vm.setProductName(rs.getString("product_name"));
		vm.setSpentTime(rs.getString("spent_time"));
		vm.setTotalProduction(rs.getString("total_production"));
		vm.setProductionPerMinute(rs.getString("production_per_minute"));
		
		return vm;
	}
	
	private KPIQualityViewModel extractKPIQualityViewModelFromResultSet(ResultSet rs) 
			throws SQLException {
		KPIQualityViewModel vm = new KPIQualityViewModel();
		
		vm.setDataMonth(rs.getString("data_month"));
		vm.setTotalCount(rs.getString("total_count"));
		vm.setTotalDetection(rs.getString("total_detection"));
		
		return vm;
	}
}
