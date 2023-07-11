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
				.append(" (SELECT MAX(create_time) FROM data_metal AA WHERE A.sensor_id = AA.sensor_id AND AA.process_code = 'PC10') AS cur_test_time,	\n")
				.append(" ADDTIME((SELECT MAX(create_time) FROM data_metal AA WHERE A.sensor_id = AA.sensor_id AND AA.process_code = 'PC10'), '02:00:00.000000') AS next_test_time,	\n")
				.append(" (SELECT COUNT(*) FROM data_metal AA WHERE A.sensor_id = AA.sensor_id AND AA.process_code = 'PC15' AND DATE_FORMAT(create_time, '%Y-%m-%d') = DATE_FORMAT(NOW(), '%Y-%m-%d') AND sensor_value = 1) AS detect_count 	\n")
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
	
	@Override
	public List<DashBoard> getDashBoardData1Graph(Connection conn) {
		
		try {
			stmt = conn.createStatement();
			
			String sql = new StringBuilder()
				.append("SELECT				\n")
				.append(" B.sensor_name,	\n")
				.append(" DATE_FORMAT(A.create_time, '%h') AS detect_time,	\n")
				.append(" (SELECT COUNT(*) FROM B16687005050.data_metal AA WHERE A.sensor_id = AA.sensor_id AND AA.process_code = 'PC15'  AND DATE_FORMAT(A.create_time, '%Y-%m-%d %h') = DATE_FORMAT(AA.create_time, '%Y-%m-%d %h') AND sensor_value = 1 )  AS detect_count	\n")
				.append("FROM data_metal A													\n")
				.append("INNER JOIN sensor B												\n")
				.append("	ON A.sensor_id = B.sensor_id									\n")
				.append("WHERE A.tenant_id = '" + JDBCConnectionPool.getTenantId(conn) + "'	\n")
				.append("AND A.sensor_id like '%CD%'								\n")
				.append("AND DATE_FORMAT(create_time, '%Y-%m-%d') = DATE_FORMAT(now(), '%Y-%m-%d')	\n")
				.append("GROUP BY A.sensor_id, DATE_FORMAT(A.create_time, '%h')								\n")
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
				.append("SELECT A.*															\n")
				.append("FROM data_metal A													\n")
				.append("INNER JOIN sensor B												\n")
				.append("	ON A.sensor_id = B.sensor_id									\n")
				.append("WHERE A.tenant_id = '" + JDBCConnectionPool.getTenantId(conn) + "'	\n")
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
	public List<DashBoard> getDashBoardData2Graph(Connection conn) {
		
		try {
			stmt = conn.createStatement();
			
			String sql = new StringBuilder()
				.append("SELECT A.*															\n")
				.append("FROM data_metal A													\n")
				.append("INNER JOIN sensor B												\n")
				.append("	ON A.sensor_id = B.sensor_id									\n")
				.append("WHERE A.tenant_id = '" + JDBCConnectionPool.getTenantId(conn) + "'	\n")
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
		dashData.setDetectTime(rs.getString("detect_time"));
		dashData.setDetectCount(rs.getString("detect_count"));
		
	    return dashData;
	}

}
