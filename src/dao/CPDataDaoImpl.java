package dao;

import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;

import org.apache.log4j.Logger;

import mes.frame.database.JDBCConnectionPool;
import viewmodel.CPDataHeadViewModel;
import viewmodel.CPDataMonitoringModel;

public class CPDataDaoImpl implements CPDataDao {
	
	static final Logger logger = Logger.getLogger(CPDataDaoImpl.class.getName());
	
	private Statement stmt;
	private ResultSet rs;
	
	public CPDataDaoImpl() {}
	
	@Override
	public List<CPDataHeadViewModel> getAllCCPDataHeadViewModel(
			Connection conn, String sensorId, 
			String startDate, String endDate, 
			String processCode) {
		
		try {
			stmt = conn.createStatement();
			
			String sql = new StringBuilder()
					.append("SELECT\n")
					.append("	A.sensor_key,\n")
					.append("	B.sensor_name,\n")
					.append("	A.create_time,\n")
					.append("	D.event_name as event,\n")
					.append("	A.sensor_value,\n")
					.append("	IF(A.sensor_value <= C.max_value && A.sensor_value >= C.min_value, '적합', '부적합') as judge,\n")
					.append("	A.improvement_action\n")
					.append("FROM data_metal A\n")
					.append("INNER JOIN sensor B\n")
					.append("	ON A.sensor_id = B.sensor_id\n")
					.append("INNER JOIN ccp_limit C\n")
					.append("	ON A.sensor_id = C.object_id\n")
					.append("	AND A.event_code = C.event_code\n")
					.append("LEFT JOIN event_info D\n")
					.append("	ON A.event_code = D.event_code\n")
					.append("WHERE A.tenant_id = '" + JDBCConnectionPool.getTenantId(conn) + "'\n")
					.append("AND A.process_code = '" + processCode + "'\n")
					.append("AND CAST(A.create_time AS DATE) BETWEEN '" + startDate + "'\n")
					.append("  				   					  AND '" + endDate	+ "'\n")
					.append("AND A.sensor_id like '%" + sensorId	+ "%'\n")
					.toString();

			logger.debug("sql:\n" + sql);
			
			rs = stmt.executeQuery(sql);
			
			List<CPDataHeadViewModel> cvmList = new ArrayList<CPDataHeadViewModel>();
			
			while(rs.next()) {
				CPDataHeadViewModel data = extractHeadViewModelFromResultSet(rs);
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
	public List<CPDataMonitoringModel> getCCPDataMonitoringModel(Connection conn) {
		
		try {
			stmt = conn.createStatement();
			
			String sql = new StringBuilder()
					.append("SELECT												\n")
					.append("	a.sensor_id, 									\n")
					.append("	a.sensor_value,									\n")
					.append("	i.sensor_name,									\n")
					.append("	t.min_value,									\n")
					.append("	t.max_value,									\n")
					.append("	DATE_FORMAT(a.create_time, '%Y-%m-%d') AS sensor_date,	\n")
					.append("	a.create_time									\n")
					.append("FROM data_metal a									\n")
					.append("INNER JOIN sensor i								\n")
					.append("	ON a.sensor_id = i.sensor_id					\n")
					.append("INNER JOIN ccp_limit t						\n")
					.append("	ON a.sensor_id = t.object_id									\n")
					.append("WHERE a.create_time = (SELECT MAX(create_time)						\n")
					.append("					 	FROM data_metal a2							\n")
					.append("						WHERE a.sensor_id = a2.sensor_id			\n")
					.append("					   )											\n")
					.append("  AND i.type_code = 'TP'											\n")
					.append("  AND a.tenant_id = '" + JDBCConnectionPool.getTenantId(conn) + "' \n")
					.append("GROUP BY a.sensor_id \n")
					.append("ORDER BY a.create_time DESC, a.sensor_id ASC		\n")
					.toString();
			
			logger.debug("sql:\n" + sql);
			
			rs = stmt.executeQuery(sql);
			
			List<CPDataMonitoringModel> cvmList = new ArrayList<CPDataMonitoringModel>();
			
			while(rs.next()) {
				CPDataMonitoringModel data = extractMonitoringModelFromResultSet(rs);
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
	
	private CPDataHeadViewModel extractHeadViewModelFromResultSet(ResultSet rs) 
										throws SQLException {
			CPDataHeadViewModel cvm = new CPDataHeadViewModel();
			
			cvm.setSensorKey(rs.getString("sensor_key"));
			cvm.setSensorName(rs.getString("sensor_name"));
			cvm.setCreateTime(rs.getTimestamp("create_time").toString());
			cvm.setEvent(rs.getString("event"));
			cvm.setSensorValue(rs.getString("sensor_value"));
			cvm.setJudge(rs.getString("judge"));
			cvm.setImprovementAction(rs.getString("improvement_action"));

			return cvm;
	}
	
	private CPDataMonitoringModel extractMonitoringModelFromResultSet(ResultSet rs) throws SQLException {
		CPDataMonitoringModel cvm = new CPDataMonitoringModel();
		
		cvm.setSensorId(rs.getString("sensor_id"));
		cvm.setSensorValue(rs.getString("sensor_value"));
		cvm.setSensorName(rs.getString("sensor_name"));
		cvm.setMinValue(rs.getString("min_value"));
		cvm.setMaxValue(rs.getString("max_value"));
		cvm.setSensorDate(rs.getString("sensor_date"));
		cvm.setCreateTime(rs.getString("create_time"));
		//cvm.setCcpDate(rs.getString("create_date"));
		//cvm.setCountAll(rs.getString("all_count"));
		//cvm.setCountDetect(rs.getString("detect_count"));
		
		return cvm;
	}
	
}
