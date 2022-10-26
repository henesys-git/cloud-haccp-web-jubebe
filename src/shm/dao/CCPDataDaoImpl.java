package shm.dao;

import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;

import org.apache.log4j.Logger;

import mes.frame.database.JDBCConnectionPool;
import shm.viewmodel.CCPDataDetailViewModel;
import shm.viewmodel.CCPDataHeadViewModel;

public class CCPDataDaoImpl implements CCPDataDao {
	
	static final Logger logger = Logger.getLogger(CCPDataDaoImpl.class.getName());
	
	private Statement stmt;
	private ResultSet rs;
	
	public CCPDataDaoImpl() {}

	@Override
	public List<CCPDataHeadViewModel> getAllCCPDataHeadViewModel(
			Connection conn, String sensorId, 
			String startDate, String endDate, 
			String testYN) {
		
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
					.append("				INNER JOIN ccp_limit bb\n")
					.append("					ON aa.event_code = bb.event_code\n")
					.append("					AND aa.product_id = bb.object_id\n")
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
					.append("				INNER JOIN ccp_limit bb\n")
					.append("					ON aa.event_code = bb.event_code\n")
					.append("					AND aa.product_id = bb.object_id\n")
					.append("				WHERE aa.tenant_id = '" + JDBCConnectionPool.getTenantId(conn) + "'\n")
					.append("				  AND aa.sensor_key = A.sensor_key\n")
					.append("			 	  AND (aa.sensor_value > bb.max_value || aa.sensor_value < bb.min_value)\n")
					.append("			 	  AND aa.improvement_action is null \n")
					.append("			)\n")
					.append("			THEN '완료'\n")
					.append("			ELSE '미완료'\n")
					.append("			END\n")
					.append("	) AS improvement_completion, \n")
					.append("	A.shm_sent_yn,\n")
					.append("	E.shm_ccp_type\n")
					.append("FROM data_metal A\n")
					.append("INNER JOIN sensor B\n")
					.append("	ON A.sensor_id = B.sensor_id\n")
					.append("INNER JOIN common_code C\n")
					.append("	ON A.process_code = C.code\n")
					.append("INNER JOIN product D\n")
					.append("	ON A.product_id = D.product_id\n")
					.append("INNER JOIN event_info E\n")
					.append("	ON A.process_code = E.parent_code\n")
					.append("WHERE A.tenant_id = '" + JDBCConnectionPool.getTenantId(conn) + "'\n")
					.append("  AND CAST(A.create_time AS DATE) BETWEEN '" + startDate + "'\n")
					.append("  				   					  AND '" + endDate	+ "'\n")
					.append("  AND B.sensor_id LIKE '" + sensorId + "'\n")
					.append("  AND C.code_type = '" + testYN + "'\n")
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
	public Boolean updateShmSentYn(Connection conn, String sensorKey, String yn) {
		try {
			stmt = conn.createStatement();
			
			String sql = new StringBuilder()
					.append("UPDATE data_metal\n")
					.append("SET shm_sent_yn = '" + yn + "'\n")
					.append("WHERE tenant_id = '" + JDBCConnectionPool.getTenantId(conn) + "'\n")
					.append("	AND sensor_key = '" + sensorKey + "'\n")
					.toString();
			
			logger.debug("sql:\n" + sql);

			int i = stmt.executeUpdate(sql);

	        if(i == 1) {
	        	return new Boolean(true);
	        }
		} catch (SQLException ex) {
			ex.printStackTrace();
		} finally {
		    try { stmt.close(); } catch (Exception e) { /* Ignored */ }
		}
		
		return new Boolean(true);
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
		cvm.setShmSentYn(rs.getString("shm_sent_yn"));
		cvm.setShmCcpType(rs.getString("shm_ccp_type"));
		
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
