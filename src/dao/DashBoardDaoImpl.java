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
import model.DashBoard;
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

public class DashBoardDaoImpl implements DashBoardDao {
	
	static final Logger logger = Logger.getLogger(DashBoardDaoImpl.class.getName());
	
	private Statement stmt;
	private ResultSet rs;
	
	public DashBoardDaoImpl() {}

	@Override
	public List<DashBoard> getDashBoardData1Table(Connection conn) {
		
		try {
			stmt = conn.createStatement();
			
			String sql = new StringBuilder()
				.append("SELECT															\n")
				.append(" B.sensor_name,	\n")
				.append(" IFNULL(DATE_FORMAT((SELECT MAX(create_time) FROM data_metal AA WHERE A.sensor_id = AA.sensor_id AND AA.process_code = 'PC10'), '%h:%i:%s'), '') AS cur_test_time,	\n")
				.append(" IFNULL(ADDTIME((SELECT MAX(create_time) FROM data_metal AA WHERE A.sensor_id = AA.sensor_id AND AA.process_code = 'PC10'), '02:00:00.000000'), '') AS next_test_time,	\n")
				.append(" IFNULL((SELECT COUNT(*) FROM data_metal AA WHERE A.sensor_id = AA.sensor_id AND AA.process_code = 'PC15' AND DATE_FORMAT(create_time, '%Y-%m-%d') = DATE_FORMAT(NOW(), '%Y-%m-%d') AND sensor_value = 1), 0) AS detect_count 	\n")
				.append("FROM data_metal A													\n")
				.append("INNER JOIN sensor B												\n")
				.append("	ON A.sensor_id = B.sensor_id									\n")
				.append("WHERE A.tenant_id = '" + JDBCConnectionPool.getTenantId(conn) + "'	\n")
				.append("AND A.sensor_id like '%CD%' \n")
				.append("AND DATE_FORMAT(create_time, '%Y-%m-%d') = DATE_FORMAT(now(), '%Y-%m-%d')	\n")
				.append("GROUP BY A.sensor_id \n")
				.toString();
			
			logger.debug("sql:\n" + sql);
			
			rs = stmt.executeQuery(sql);
			
			List<DashBoard> dashList = new ArrayList<DashBoard>();
			
			while(rs.next()) {
				DashBoard data = extractFromResultSet(rs);
				dashList.add(data);
			}
			
			return dashList;
			
		} catch (SQLException ex) {
			ex.printStackTrace();
		} finally {
		    try { rs.close(); } catch (Exception e) { /* Ignored */ }
		    try { stmt.close(); } catch (Exception e) { /* Ignored */ }
		}
		
		return null;
	};
	
	@Override
	public List<DashBoard> getDashBoardData1Graph(Connection conn) {
		
		try {
			stmt = conn.createStatement();
			
			String sql = new StringBuilder()
				.append("SELECT				\n")
				.append(" B.sensor_name,	\n")
				.append(" (SELECT COUNT(*) FROM data_metal AA WHERE A.sensor_id = AA.sensor_id AND AA.process_code = 'PC15'  AND DATE_FORMAT(A.create_time, '%Y-%m-%d') = DATE_FORMAT(AA.create_time, '%Y-%m-%d') AND DATE_FORMAT(AA.create_time, '%h') = '09' AND sensor_value = 1 )  AS detect_count_09h,	\n")
				.append(" (SELECT COUNT(*) FROM data_metal AA WHERE A.sensor_id = AA.sensor_id AND AA.process_code = 'PC15'  AND DATE_FORMAT(A.create_time, '%Y-%m-%d') = DATE_FORMAT(AA.create_time, '%Y-%m-%d') AND DATE_FORMAT(AA.create_time, '%h') = '10' AND sensor_value = 1 )  AS detect_count_10h,	\n")
				.append(" (SELECT COUNT(*) FROM data_metal AA WHERE A.sensor_id = AA.sensor_id AND AA.process_code = 'PC15'  AND DATE_FORMAT(A.create_time, '%Y-%m-%d') = DATE_FORMAT(AA.create_time, '%Y-%m-%d') AND DATE_FORMAT(AA.create_time, '%h') = '11' AND sensor_value = 1 )  AS detect_count_11h,	\n")
				.append(" (SELECT COUNT(*) FROM data_metal AA WHERE A.sensor_id = AA.sensor_id AND AA.process_code = 'PC15'  AND DATE_FORMAT(A.create_time, '%Y-%m-%d') = DATE_FORMAT(AA.create_time, '%Y-%m-%d') AND DATE_FORMAT(AA.create_time, '%h') = '12' AND sensor_value = 1 )  AS detect_count_12h,	\n")
				.append(" (SELECT COUNT(*) FROM data_metal AA WHERE A.sensor_id = AA.sensor_id AND AA.process_code = 'PC15'  AND DATE_FORMAT(A.create_time, '%Y-%m-%d') = DATE_FORMAT(AA.create_time, '%Y-%m-%d') AND DATE_FORMAT(AA.create_time, '%h') = '13' AND sensor_value = 1 )  AS detect_count_13h,	\n")
				.append(" (SELECT COUNT(*) FROM data_metal AA WHERE A.sensor_id = AA.sensor_id AND AA.process_code = 'PC15'  AND DATE_FORMAT(A.create_time, '%Y-%m-%d') = DATE_FORMAT(AA.create_time, '%Y-%m-%d') AND DATE_FORMAT(AA.create_time, '%h') = '14' AND sensor_value = 1 )  AS detect_count_14h,	\n")
				.append(" (SELECT COUNT(*) FROM data_metal AA WHERE A.sensor_id = AA.sensor_id AND AA.process_code = 'PC15'  AND DATE_FORMAT(A.create_time, '%Y-%m-%d') = DATE_FORMAT(AA.create_time, '%Y-%m-%d') AND DATE_FORMAT(AA.create_time, '%h') = '15' AND sensor_value = 1 )  AS detect_count_15h,	\n")
				.append(" (SELECT COUNT(*) FROM data_metal AA WHERE A.sensor_id = AA.sensor_id AND AA.process_code = 'PC15'  AND DATE_FORMAT(A.create_time, '%Y-%m-%d') = DATE_FORMAT(AA.create_time, '%Y-%m-%d') AND DATE_FORMAT(AA.create_time, '%h') = '16' AND sensor_value = 1 )  AS detect_count_16h,	\n")
				.append(" (SELECT COUNT(*) FROM data_metal AA WHERE A.sensor_id = AA.sensor_id AND AA.process_code = 'PC15'  AND DATE_FORMAT(A.create_time, '%Y-%m-%d') = DATE_FORMAT(AA.create_time, '%Y-%m-%d') AND DATE_FORMAT(AA.create_time, '%h') = '17' AND sensor_value = 1 )  AS detect_count_17h,	\n")
				.append(" (SELECT COUNT(*) FROM data_metal AA WHERE A.sensor_id = AA.sensor_id AND AA.process_code = 'PC15'  AND DATE_FORMAT(A.create_time, '%Y-%m-%d') = DATE_FORMAT(AA.create_time, '%Y-%m-%d') AND DATE_FORMAT(AA.create_time, '%h') = '18' AND sensor_value = 1 )  AS detect_count_18h	\n")
				.append("FROM data_metal A													\n")
				.append("INNER JOIN sensor B												\n")
				.append("	ON A.sensor_id = B.sensor_id									\n")
				.append("WHERE A.tenant_id = '" + JDBCConnectionPool.getTenantId(conn) + "'	\n")
				.append("AND A.sensor_id like '%CD%'								\n")
				.append("AND DATE_FORMAT(create_time, '%Y-%m-%d') = DATE_FORMAT(now(), '%Y-%m-%d')	\n")
				.append("GROUP BY A.sensor_id 	\n")
				.toString();
			
			logger.debug("sql:\n" + sql);
			
			rs = stmt.executeQuery(sql);
			
			List<DashBoard> dashList = new ArrayList<DashBoard>();
			
			while(rs.next()) {
				DashBoard data = extractFromResultSet2(rs);
				dashList.add(data);
			}
			
			return dashList;
			
		} catch (SQLException ex) {
			ex.printStackTrace();
		} finally {
		    try { rs.close(); } catch (Exception e) { /* Ignored */ }
		    try { stmt.close(); } catch (Exception e) { /* Ignored */ }
		}
		
		return null;
	};
	
	@Override
	public List<DashBoard> getDashBoardData2Table(Connection conn) {
		
		try {
			stmt = conn.createStatement();
			
			String sql = new StringBuilder()
					.append("SELECT				\n")
					.append(" B.sensor_name,	\n")
					.append(" (SELECT sensor_value FROM data_metal AA WHERE A.sensor_id = AA.sensor_id AND AA.process_code = 'PC90' AND AA.event_code = 'JS10' AND DATE_FORMAT(A.create_time, '%Y-%m-%d') = DATE_FORMAT(AA.create_time, '%Y-%m-%d'))  AS first_temp,	\n")
					.append(" (SELECT sensor_value FROM data_metal AA WHERE A.sensor_id = AA.sensor_id AND AA.process_code = 'PC90' AND AA.event_code = 'JS20' AND DATE_FORMAT(A.create_time, '%Y-%m-%d') = DATE_FORMAT(AA.create_time, '%Y-%m-%d'))  AS first_rpm,	\n")
					.append(" (SELECT sensor_value FROM data_metal AA WHERE A.sensor_id = AA.sensor_id AND AA.process_code = 'PC90' AND AA.event_code = 'JS30' AND DATE_FORMAT(A.create_time, '%Y-%m-%d') = DATE_FORMAT(AA.create_time, '%Y-%m-%d'))  AS second_rpm,	\n")
					.append(" (SELECT sensor_value FROM data_metal AA WHERE A.sensor_id = AA.sensor_id AND AA.process_code = 'PC90' AND AA.event_code = 'JS40' AND DATE_FORMAT(A.create_time, '%Y-%m-%d') = DATE_FORMAT(AA.create_time, '%Y-%m-%d'))  AS second_temp	\n")
					.append("FROM data_metal A													\n")
					.append("INNER JOIN sensor B												\n")
					.append("	ON A.sensor_id = B.sensor_id									\n")
					.append("WHERE A.tenant_id = '" + JDBCConnectionPool.getTenantId(conn) + "'	\n")
					.append("AND A.sensor_id like '%JS%'								\n")
					.append("AND DATE_FORMAT(create_time, '%Y-%m-%d') = DATE_FORMAT(now(), '%Y-%m-%d')	\n")
					.append("GROUP BY A.sensor_id 	\n")
					.toString();
			
			logger.debug("sql:\n" + sql);
			
			rs = stmt.executeQuery(sql);
			
			List<DashBoard> dashList = new ArrayList<DashBoard>();
			
			while(rs.next()) {
				DashBoard data = extractFromResultSet3(rs);
				dashList.add(data);
			}
			
			return dashList;
			
		} catch (SQLException ex) {
			ex.printStackTrace();
		} finally {
		    try { rs.close(); } catch (Exception e) { /* Ignored */ }
		    try { stmt.close(); } catch (Exception e) { /* Ignored */ }
		}
		
		return null;
	};
	
	@Override
	public List<DashBoard> getDashBoardData2Graph(Connection conn) {
		
		try {
			stmt = conn.createStatement();
			
			String sql = new StringBuilder()
					.append("SELECT															\n")
					.append(" B.sensor_name,	\n")
					.append(" IFNULL((SELECT MAX(create_time) FROM data_metal AA WHERE A.sensor_id = AA.sensor_id AND AA.process_code = 'PC10'), '') AS cur_test_time,	\n")
					.append(" IFNULL(ADDTIME((SELECT MAX(create_time) FROM data_metal AA WHERE A.sensor_id = AA.sensor_id AND AA.process_code = 'PC10'), '02:00:00.000000'), '') AS next_test_time,	\n")
					.append(" IFNULL((SELECT COUNT(*) FROM data_metal AA WHERE A.sensor_id = AA.sensor_id AND AA.process_code = 'PC15' AND DATE_FORMAT(create_time, '%Y-%m-%d') = DATE_FORMAT(NOW(), '%Y-%m-%d') AND sensor_value = 1), 0) AS detect_count 	\n")
					.append("FROM data_metal A													\n")
					.append("INNER JOIN sensor B												\n")
					.append("	ON A.sensor_id = B.sensor_id									\n")
					.append("WHERE A.tenant_id = '" + JDBCConnectionPool.getTenantId(conn) + "'	\n")
					.append("AND A.sensor_id like '%CD%' \n")
					.append("GROUP BY A.sensor_id \n")
				.toString();
			
			logger.debug("sql:\n" + sql);
			
			rs = stmt.executeQuery(sql);
			
			List<DashBoard> dashList = new ArrayList<DashBoard>();
			
			while(rs.next()) {
				DashBoard data = extractFromResultSet(rs);
				dashList.add(data);
			}
			
			return dashList;
			
		} catch (SQLException ex) {
			ex.printStackTrace();
		} finally {
		    try { rs.close(); } catch (Exception e) { /* Ignored */ }
		    try { stmt.close(); } catch (Exception e) { /* Ignored */ }
		}
		
		return null;
	};
	
	
	
	private DashBoard extractFromResultSet(ResultSet rs) throws SQLException {
		DashBoard dashData = new DashBoard();
		
		dashData.setSensorName(rs.getString("sensor_name"));
		dashData.setCurTestTime(rs.getString("cur_test_time"));
		dashData.setNextTestTime(rs.getString("next_test_time"));
		dashData.setDetectCount(rs.getString("detect_count"));
	
		
	    return dashData;
	}
	
	private DashBoard extractFromResultSet2(ResultSet rs) throws SQLException {
		DashBoard dashData = new DashBoard();
		
		dashData.setSensorName(rs.getString("sensor_name"));
		dashData.setDetectCountHour9(rs.getString("detect_count_09h"));
		dashData.setDetectCountHour10(rs.getString("detect_count_10h"));
		dashData.setDetectCountHour11(rs.getString("detect_count_11h"));
		dashData.setDetectCountHour12(rs.getString("detect_count_12h"));
		dashData.setDetectCountHour13(rs.getString("detect_count_13h"));
		dashData.setDetectCountHour14(rs.getString("detect_count_14h"));
		dashData.setDetectCountHour15(rs.getString("detect_count_15h"));
		dashData.setDetectCountHour16(rs.getString("detect_count_16h"));
		dashData.setDetectCountHour17(rs.getString("detect_count_17h"));
		dashData.setDetectCountHour18(rs.getString("detect_count_18h"));
		
	    return dashData;
	}
	
	private DashBoard extractFromResultSet3(ResultSet rs) throws SQLException {
		DashBoard dashData = new DashBoard();
		
		dashData.setSensorName(rs.getString("sensor_name"));
		dashData.setFirstTemp(rs.getString("first_temp"));
		dashData.setFirstRpm(rs.getString("first_rpm"));
		dashData.setSecondRpm(rs.getString("second_rpm"));
		dashData.setSecondTemp(rs.getString("second_temp"));
	
		
	    return dashData;
	}
	
}
