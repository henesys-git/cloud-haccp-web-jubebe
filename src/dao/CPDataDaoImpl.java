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
import viewmodel.CCPDataMonitoringModel;
import viewmodel.CCPDataStatisticModel;
import viewmodel.CCPTestDataHeadViewModel;
import viewmodel.CCPTestDataViewModel;
import viewmodel.CPDataMonitoringModel;

public class CPDataDaoImpl implements CPDataDao {
	
	static final Logger logger = Logger.getLogger(CPDataDaoImpl.class.getName());
	
	private Statement stmt;
	private ResultSet rs;
	
	public CPDataDaoImpl() {}
	
	@Override
	public List<CPDataMonitoringModel> getCCPDataMonitoringModel(Connection conn) {
		
		try {
			stmt = conn.createStatement();
			
			String sql = new StringBuilder()
					.append("WITH narrow_data AS 								\n")
					.append("(													\n")
					.append("	SELECT * FROM data_metal						\n")
					.append("	WHERE sensor_id LIKE 'TM%'						\n")
					.append("	GROUP BY sensor_id								\n")
					.append("	ORDER BY create_time DESC						\n")
					.append("	LIMIT 50										\n")
					.append(")													\n")
					.append("SELECT												\n")
					.append("	a.sensor_id, 									\n")
					.append("	a.sensor_value,									\n")
					.append("	i.sensor_name,									\n")
					.append("	t.min_value,									\n")
					.append("	t.max_value,									\n")
					.append("	DATE_FORMAT(a.create_time, '%Y-%m-%d'),			\n")
					.append("	a.create_time									\n")
					.append("FROM narrow_data a									\n")
					.append("INNER JOIN sensor i								\n")
					.append("	ON a.sensor_id = i.sensor_id					\n")
					.append("INNER JOIN temperature_limit t						\n")
					.append("	ON a.sensor_id = t.sensor_id					\n")
					.append("WHERE a.create_time = (SELECT MAX(create_time)		\n")
					.append("								   	FROM data_metal a2					\n")
					.append("								   	WHERE a.sensor_id = a2.sensor_id	\n")
					.append("								   	  AND a.create_time = a2.create_time)	\n")
					.append("  AND i.type_code = 'TM'											 \n")
					.append("	AND A.tenant_id = '" + JDBCConnectionPool.getTenantId(conn) + "' \n")
					.append("ORDER BY a.sensor_id ASC														\n")
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
	
	private CPDataMonitoringModel extractMonitoringModelFromResultSet(ResultSet rs) throws SQLException {
		CPDataMonitoringModel cvm = new CPDataMonitoringModel();
		
		cvm.setSensorName(rs.getString("sensor_name"));
		cvm.setCcpDate(rs.getString("create_date"));
		cvm.setCountAll(rs.getString("all_count"));
		cvm.setCountDetect(rs.getString("detect_count"));
		
		return cvm;
	}
	
}
