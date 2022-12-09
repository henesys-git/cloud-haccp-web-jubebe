package shm.dao;

import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;

import org.apache.log4j.Logger;

import mes.frame.database.JDBCConnectionPool;
import shm.model.C0010;

public class ShmC0030DaoImpl implements ShmCCPDataDao {
	
	private Statement stmt;
	private ResultSet rs;
	
	static final Logger logger = Logger.getLogger(ShmC0030DaoImpl.class.getName());
	
	public ShmC0030DaoImpl() {
	}
	
	@Override
	public List<C0010> getCCPData(Connection conn, String sensorKey) {

		try {
			stmt = conn.createStatement();
			
			String sql = new StringBuilder()
					.append("SELECT\n")
					.append("	Q.shm_api_license_no AS lcns_no,\n")
					.append("	Q.customer_name AS company_nm,\n")
					.append("	SUBSTRING_INDEX(A.create_time, ' ', 1) AS create_date,\n")
					.append("	SUBSTRING_INDEX(A.create_time, ' ', -1) AS create_time,\n")
					.append("	C.shm_ccp_type AS rec_code,\n")
					.append("	D.code_name AS rec_nm,\n")
					.append("	@rownum3:= @rownum3 + 1 AS seq,\n")
					.append("	A.sensor_id AS equip_code,\n")
					.append("	B.sensor_name AS equip_nm,\n")
					.append("	C.shm_ccp_verificiation_type AS verf_type_code,\n")
					.append("	E.code_name AS verf_type_nm,\n")
					.append("	'productlist_type_cd' AS productlist_type_cd,\n")
					.append("	'productlist_type_nm' AS productlist_type_nm,\n")
					.append("	P.product_name AS productlist_nm,\n")
					.append("	F.code AS lmt_item_code,\n")
					.append("	F.code_name AS lmt_item_nm,\n")
					.append("	L.min_value AS lmt_min_val,\n")
					.append("	L.max_value AS lmt_max_val,\n")
					.append("	A.sensor_key AS process_no,\n")
					.append("	ifnull(A.create_time - Atemp.create_time, 0) AS prcs_progress_time,\n")
					.append("	SUBSTRING_INDEX(A.create_time, ' ', 1) AS meas_date,\n")
					.append("	SUBSTRING_INDEX(A.create_time, ' ', -1) AS meas_time,\n")
					.append("	A.sensor_value AS meas_val,\n")
					.append("	IF(A.sensor_value <= L.max_value && A.sensor_value >= L.min_value, 'N', 'Y') as break_yn,\n")
					.append("	A.improvement_action AS imprv_comm\n")
					.append("FROM\n")
					.append("	(\n")
					.append("		SELECT \n")
					.append("			*,\n")
					.append("			@rownum:= @rownum + 1 AS seq\n")
					.append("		FROM \n")
					.append("			data_metal,\n")
					.append("			(SELECT @rownum:=0 AS rownum) rn\n")
					.append("		WHERE tenant_id = '" + JDBCConnectionPool.getTenantId(conn) + "'\n")
					.append("	  	AND sensor_key = '" + sensorKey + "'\n")
					.append("	) AS A\n")
					.append("LEFT JOIN (\n")
					.append("			SELECT \n")
					.append("				*,\n")
					.append("				@rownum2:= @rownum2 + 1 AS seq\n")
					.append("			FROM \n")
					.append("				data_metal,\n")
					.append("				(SELECT @rownum2:=0 AS rownum) rn\n")
					.append("			WHERE tenant_id = '" + JDBCConnectionPool.getTenantId(conn) + "'\n")
					.append("	  		AND sensor_key = '" + sensorKey + "'\n")
					.append("		) AS Atemp\n")
					.append("	ON Atemp.seq = A.seq - 1\n")
					.append("LEFT JOIN (\n")
					.append("			SELECT\n")
					.append("				'' AS sensor_key, \n")
					.append("				@rownum3:=0 AS rownum\n")
					.append("		  ) AS rw\n")
					.append("	ON A.sensor_key = rw.sensor_key\n")
					.append("INNER JOIN sensor B\n")
					.append("	ON A.sensor_id = B.sensor_id\n")
					.append("LEFT JOIN event_info C\n")
					.append("	ON A.event_code = C.event_code\n")
					.append("INNER JOIN ccp_shm_code D\n")
					.append("	ON C.shm_ccp_type = D.code\n")
					.append("INNER JOIN ccp_shm_code E\n")
					.append("	ON C.shm_ccp_verificiation_type = E.code \n")
					.append("INNER JOIN ccp_shm_code F\n")
					.append("	ON C.shm_critical_limit_type = F.code \n")
					.append("INNER JOIN ccp_limit L\n")
					.append("	ON A.event_code = L.event_code \n")
					.append("	AND A.product_id = L.object_id \n")
					.append("INNER JOIN product P\n")
					.append("	ON A.product_id = P.product_id\n")
					.append("INNER JOIN customer Q\n")
					.append("	ON A.tenant_id = Q.tenant_id\n")
					.toString();
			
			logger.debug("sql:\n" + sql);
			
			rs = stmt.executeQuery(sql);
			
			List<C0010> list = new ArrayList<C0010>();
			
			while(rs.next()) {
				list.add(extractFromResultSet(rs));
			}
			
			return list;
		} catch (SQLException ex) {
			ex.printStackTrace();
		}
		
		return null;
	};
	
	private C0010 extractFromResultSet(ResultSet rs) throws SQLException {
		C0010 c0010 = new C0010();
		
		c0010.setLcnsNo(rs.getString("lcns_no"));
		c0010.setCompanyNm(rs.getString("company_nm"));
		c0010.setCreateDate(rs.getString("create_date"));
		c0010.setCreateTime(rs.getString("create_time"));
		c0010.setRecCode(rs.getString("rec_code"));
		c0010.setRecNm(rs.getString("rec_nm"));
		c0010.setSeq(rs.getString("seq"));
		c0010.setEquipCode(rs.getString("equip_code"));
		c0010.setEquipNm(rs.getString("equip_nm"));
		c0010.setVerfTypeCode(rs.getString("verf_type_code"));
		c0010.setVerfTypeNm(rs.getString("verf_type_nm"));
		c0010.setProductlistTypeCd(rs.getString("productlist_type_cd"));
		c0010.setProductlistTypeNm(rs.getString("productlist_type_nm"));
		c0010.setProductlistNm(rs.getString("productlist_nm"));
		c0010.setLmtItemCode(rs.getString("lmt_item_code"));
		c0010.setLmtItemNm(rs.getString("lmt_item_nm"));
		c0010.setLmtMinVal(rs.getString("lmt_min_val"));
		c0010.setLmtMaxVal(rs.getString("lmt_max_val"));
		c0010.setProcessNo(rs.getString("process_no"));
		c0010.setPrcsProgressTime(rs.getString("prcs_progress_time"));
		c0010.setMeasDate(rs.getString("meas_date"));
		c0010.setMeasTime(rs.getString("meas_time"));
		c0010.setMeasVal(rs.getString("meas_val"));
		c0010.setBreakYn(rs.getString("break_yn"));
		c0010.setImprvComm(rs.getString("imprv_comm"));
		
	    return c0010;
	}
}
