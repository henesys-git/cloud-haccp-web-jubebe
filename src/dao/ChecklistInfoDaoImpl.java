package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;

import org.apache.log4j.Logger;

import mes.frame.database.JDBCConnectionPool;
import model.ChecklistInfo;

public class ChecklistInfoDaoImpl implements ChecklistInfoDao {
	
	private Statement stmt;
	private ResultSet rs;
	
	static final Logger logger = 
			Logger.getLogger(ChecklistInfoDaoImpl.class.getName());
	
	@Override
	public ChecklistInfo select(Connection conn, String checklistId) {
		try {
			String sql = new StringBuilder()
					.append("SELECT * \n")
					.append("FROM checklist_info\n")
					.append("WHERE tenant_id = '" + JDBCConnectionPool.getTenantId(conn) + "'\n")
					.append("  AND checklist_id = ?;\n")
					.toString();
			
			PreparedStatement ps = conn.prepareStatement(sql);
			ps.setString(1, checklistId);
			
			rs = ps.executeQuery();
			
			ChecklistInfo clInfo = new ChecklistInfo();
					
			if(rs.next()) {
				clInfo = extractFromResultSet2(rs);
			}
			
			return clInfo;
			
		} catch (SQLException ex) {
			ex.printStackTrace();
		}
		
		return null;
	}
	
	@Override
	public ChecklistInfo selectChecklistNoByProdAndSensor(Connection conn, String prodCd, String sensorId) {
		try {
			stmt = conn.createStatement();
			
			String sql = new StringBuilder()
					.append("SELECT  \n")
					.append("	checklist_id  \n")
					.append("FROM checklist_info\n")
					.append("WHERE tenant_id = '" + JDBCConnectionPool.getTenantId(conn) + "'\n")
					.append("  AND product_id LIKE '%"+ prodCd +"%'\n")
					.append("  AND sensor_id LIKE '%"+ sensorId +"%';\n")
					.toString();
			
			logger.debug("sql:\n" + sql);
			
			rs = stmt.executeQuery(sql);
			
			ChecklistInfo clInfo = new ChecklistInfo();
					
			if(rs.next()) {
				clInfo = extractFromResultSet3(rs);
			}
			
			return clInfo;
			
		} catch (SQLException ex) {
			ex.printStackTrace();
		} finally {
		    try { rs.close(); } catch (Exception e) { /* Ignored */ }
		    try { stmt.close(); } catch (Exception e) { /* Ignored */ }
		}
		
		return null;
	}
	
	@Override
	public List<ChecklistInfo> selectAll(Connection conn) {
		
		try {
			stmt = conn.createStatement();
			
			String sql = new StringBuilder()
				.append("SELECT  							\n")
				.append("A.tenant_id,						\n")
				.append("A.checklist_id,					\n")
				.append("A.revision_no,						\n")
				.append("A.checklist_name,					\n")
				.append("A.image_path,						\n")
				.append("A.meta_data_file_path,				\n")
				.append("B.check_interval,					\n")
				.append("GROUP_CONCAT(C.signature_type) AS signature_type \n")
				.append("FROM checklist_info A				\n")
				.append("LEFT OUTER JOIN checklist_alarm B	\n")
				.append("ON A.checklist_id = B.checklist_id	\n")
				.append("LEFT OUTER JOIN checklist_sign C	\n")
				.append("ON A.checklist_id = C.checklist_id	\n")
				.append("WHERE A.tenant_id = '" + JDBCConnectionPool.getTenantId(conn) + "'\n")
				.append("GROUP BY A.checklist_id \n")
				.toString();
			
			logger.debug("sql:\n" + sql);
			
			rs = stmt.executeQuery(sql);
			
			List<ChecklistInfo> list = new ArrayList<ChecklistInfo>();
			
			while(rs.next()) {
				ChecklistInfo data = extractFromResultSet(rs);
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
	public boolean insert(Connection conn, ChecklistInfo clInfo) {
		try {
			String sql = new StringBuilder()
					.append("INSERT INTO checklist_info (\n")
					.append("	tenant_id, \n")
					.append("	checklist_id, \n")
					.append("	revision_no, \n")
					.append("	checklist_name, \n")
					.append("	image_path, \n")
					.append("	meta_data_file_path\n")
					.append(") VALUES(\n")
					.append("	?, \n")
					.append("	?, \n")
					.append("	?, \n")
					.append("	?, \n")
					.append("	?, \n")
					.append("	?\n")
					.append(");\n")
					.toString();

			PreparedStatement ps = conn.prepareStatement(sql);
			
			ps.setString(1, JDBCConnectionPool.getTenantId(conn));
			ps.setString(2, clInfo.getChecklistId());
			ps.setInt(3, clInfo.getRevisionNo());
			ps.setString(4, clInfo.getChecklistName());
			ps.setString(5, clInfo.getImagePath());
			ps.setString(6, clInfo.getMetaDataFilePath());
			
	        int i = ps.executeUpdate();

	        if(i == 1) {
	        	return true;
	        }

	    } catch (SQLException ex) {
	        ex.printStackTrace();
	    }

	    return false;
	}
	
	@Override
	public boolean update(Connection conn, ChecklistInfo clInfo) {
		try {
			
			String tenantId = JDBCConnectionPool.getTenantId(conn);
			
			String sql = new StringBuilder()
					.append("INSERT INTO checklist_info (\n")
					.append("	tenant_id, \n")
					.append("	checklist_id, \n")
					.append("	revision_no, \n")
					.append("	checklist_name, \n")
					.append("	image_path, \n")
					.append("	meta_data_file_path\n")
					.append(") VALUES(\n")
					.append("	?, \n")
					.append("	?, \n")
					.append("	(SELECT * FROM (SELECT MAX(revision_no) + 1 AS next_rev_no\n")
					.append("	 			   FROM checklist_info \n")
					.append("	 			   WHERE tenant_id = '" + tenantId + "' \n")
					.append("	   				 AND checklist_id = '" + clInfo.getChecklistId() + "') AS c), \n")
					.append("	?, \n")
					.append("	?, \n")
					.append("	?\n")
					.append(");\n")
					.toString();

			PreparedStatement ps = conn.prepareStatement(sql);
			
			ps.setString(1, tenantId);
			ps.setString(2, clInfo.getChecklistId());
			ps.setString(3, clInfo.getChecklistName());
			ps.setString(4, clInfo.getImagePath());
			ps.setString(5, clInfo.getMetaDataFilePath());
			
	        int i = ps.executeUpdate();

	        if(i == 1) {
	        	return true;
	        }

	    } catch (SQLException ex) {
	        ex.printStackTrace();
	    }

	    return false;
	}
	
	@Override
	public boolean delete(Connection conn, String checklistId) {
		try {
			stmt = conn.createStatement();
			
			String sql = new StringBuilder()
					.append("DELETE FROM checklist_info\n")
					.append("WHERE tenant_id='" + JDBCConnectionPool.getTenantId(conn) + "'\n")
					.append("  AND checklist_id='" + checklistId + "';\n")
					.toString();
			
			logger.debug("sql:\n" + sql);
			
			int i = stmt.executeUpdate(sql);

	        if(i > 0) {
	        	return true;
	        }

	    } catch (SQLException ex) {
	        ex.printStackTrace();
	    }

	    return false;
	}
	
	public boolean sign(Connection conn, ChecklistInfo clInfo, String aa) {
		
		String sql = "";
		
		String [] aa2 = null;
		
		if(aa != null) {
			aa2 = aa.split(",");
		}
	
		try {
			
			
			sql = new StringBuilder()
					.append("DELETE FROM checklist_sign \n")
					.append("WHERE checklist_id = '"+ clInfo.getChecklistId().toString() + "' \n")
					.toString();
			
			Statement ps = conn.createStatement();
			
			int a = ps.executeUpdate(sql);
			
			 if(a < 0) {
		        	conn.rollback();
		        	return false;
		       }
				for (int b = 0; b < aa2.length; b++) {
					
					sql = new StringBuilder()
							.append("INSERT INTO checklist_sign (\n")
							.append("	tenant_id, \n")
							.append("	checklist_id, \n")
							.append("	signature_type \n")
							.append(") VALUES(\n")
							.append("	'"+ JDBCConnectionPool.getTenantId(conn) +"', \n")
							.append("	'"+ clInfo.getChecklistId() +"', \n")
							.append("	'"+ aa2[b] +"'\n")
							.append(");\n")
							.toString();

					
			        int i = ps.executeUpdate(sql);
			        
			        if(i == 1 && b < (aa2.length - 1) ) {
			        	continue;
			        }
			        else {
			        	return true;
			        }
			        
				}

	    } catch (SQLException ex) {
	        ex.printStackTrace();
	    }

	    return false;
	}
	
	private ChecklistInfo extractFromResultSet(ResultSet rs) throws SQLException {
	    ChecklistInfo clInfo = new ChecklistInfo();
	    
	    clInfo.setChecklistId(rs.getString("checklist_id"));
	    clInfo.setRevisionNo(rs.getInt("revision_no"));
	    clInfo.setChecklistName(rs.getString("checklist_name"));
	    clInfo.setImagePath(rs.getString("image_path"));
	    clInfo.setMetaDataFilePath(rs.getString("meta_data_file_path"));
	    clInfo.setCheckInterval(rs.getInt("check_interval"));
	    clInfo.setSignatureType(rs.getString("signature_type"));
	    
	    return clInfo;
	}
	
	
	private ChecklistInfo extractFromResultSet2(ResultSet rs) throws SQLException {
	    ChecklistInfo clInfo = new ChecklistInfo();
	    
	    clInfo.setPageCnt(rs.getInt("page_cnt"));
	    
	    return clInfo;
	}
	
	private ChecklistInfo extractFromResultSet3(ResultSet rs) throws SQLException {
	    ChecklistInfo clInfo = new ChecklistInfo();
	    
	    clInfo.setChecklistId(rs.getString("checklist_id"));
	    
	    return clInfo;
	}
}