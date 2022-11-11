package shm.dao;

import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;

import org.apache.log4j.Logger;

import mes.frame.database.JDBCConnectionPool;
import shm.viewmodel.SsfKpiLevel2;

public class SsfKPIDaoImpl implements SsfKPIDao {
	
	private Statement stmt;
	private ResultSet rs;
	
	static final Logger logger = Logger.getLogger(SsfKPIDaoImpl.class.getName());
	
	public SsfKPIDaoImpl() {
	}
	
	@Override
	public List<SsfKpiLevel2> getKPIData(Connection conn) {

		try {
			stmt = conn.createStatement();
			
			String sql = new StringBuilder()
					.append("SELECT \n")
					.append("	d.sensor_key,\n")
					.append("	c.ssf_kpi_cert_key,\n")
					.append("	MIN(d.create_time) AS ocr_dttm,\n")
					.append("	s.kpi_fld_cd,\n")
					.append("	s.kpi_dtl_cd,\n")
					.append("	s.kpi_dtl_nm,\n")
					.append("	s.org_value,\n")
					.append("	s.target_value,\n")
					.append("	ROUND(SUM(d.sensor_value) / (TIMESTAMPDIFF(SECOND, MIN(d.create_time), MAX(d.create_time)) / 60), 2) AS cur_value,\n")
					.append("	d.ssf_sent_yn\n")
					.append("FROM data_metal d\n")
					.append("INNER JOIN ssf_kpi_code s\n")
					.append("	ON d.process_code = s.process_code\n")
					.append("INNER JOIN customer c\n")
					.append("	ON d.tenant_id = c.tenant_id \n")
					.append("WHERE d.tenant_id = '" + JDBCConnectionPool.getTenantId(conn) + "'\n")
//					.append("	AND DATE_FORMAT(d.create_time, '%Y-%m-%d') BETWEEN '2022-10-19' \n")
//					.append("												   AND '2022-10-19'\n")
					.append("	AND d.process_code = 'PC70'\n")
					.append("GROUP BY d.sensor_key\n")
					.append("UNION ALL\n")
					.append("SELECT\n")
					.append("	d.sensor_key,\n")
					.append("	c.ssf_kpi_cert_key,\n")
					.append("	MIN(d.create_time) AS ocr_dttm,\n")
					.append("	s.kpi_fld_cd,\n")
					.append("	s.kpi_dtl_cd,\n")
					.append("	s.kpi_dtl_nm,\n")
					.append("	s.org_value,\n")
					.append("	s.target_value,\n")
					.append("	(SELECT count(*) FROM data_metal bb WHERE process_code = 'PC15' AND sensor_id LIKE '%%' AND month(bb.create_time) = month(d.create_time) AND bb.sensor_value = 1) AS cur_value,\n")
					.append("	d.ssf_sent_yn\n")
					.append("FROM data_metal d\n")
					.append("INNER JOIN ssf_kpi_code s\n")
					.append("	ON d.process_code = s.process_code\n")
					.append("INNER JOIN customer c\n")
					.append("	ON d.tenant_id = c.tenant_id \n")
					.append("WHERE d.tenant_id = '" + JDBCConnectionPool.getTenantId(conn) + "'\n")
//					.append("	AND YEAR(d.create_time) = '2022' \n")
					.append("	AND d.process_code = 'PC15'\n")
					.append("GROUP BY MONTH(d.create_time);\n")
					.toString();

			logger.debug("sql:\n" + sql);
			
			rs = stmt.executeQuery(sql);
			
			List<SsfKpiLevel2> list = new ArrayList<SsfKpiLevel2>();
			
			while(rs.next()) {
				list.add(extractFromResultSet(rs));
			}
			
			return list;
		} catch (SQLException ex) {
			ex.printStackTrace();
		}
		
		return null;
	};
	
	@Override
	public Boolean updateSsfSentYn(Connection conn, String sensorKey, String yn) {
		try {
			stmt = conn.createStatement();
			
			String sql = new StringBuilder()
					.append("UPDATE data_metal\n")
					.append("SET ssf_sent_yn = '" + yn + "'\n")
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
	
	private SsfKpiLevel2 extractFromResultSet(ResultSet rs) throws SQLException {
		SsfKpiLevel2 ssfKpiLevel2 = new SsfKpiLevel2();
		
		ssfKpiLevel2.setSensorKey(rs.getString("sensor_key"));
		ssfKpiLevel2.setSsfKpiCertKey(rs.getString("ssf_kpi_cert_key"));
		ssfKpiLevel2.setOcrDttm(rs.getString("ocr_dttm"));
		ssfKpiLevel2.setKpiFldCd(rs.getString("kpi_fld_cd"));
		ssfKpiLevel2.setKpiDtlCd(rs.getString("kpi_dtl_cd"));
		ssfKpiLevel2.setKpiDtlNm(rs.getString("kpi_dtl_nm"));
		ssfKpiLevel2.setOrgValue(rs.getString("org_value"));
		ssfKpiLevel2.setTargetValue(rs.getString("target_value"));
		ssfKpiLevel2.setCurValue(rs.getString("cur_value"));
		ssfKpiLevel2.setSsfSentYn(rs.getString("ssf_sent_yn"));
		
	    return ssfKpiLevel2;
	}
}
