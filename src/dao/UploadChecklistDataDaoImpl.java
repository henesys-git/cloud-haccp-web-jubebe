package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;

import mes.frame.database.JDBCConnectionPool;
import model.ChecklistData;
import model.DocumentData;
import model.UploadChecklistData;

public class UploadChecklistDataDaoImpl implements UploadChecklistDataDao {
	
	private Statement stmt;
	private PreparedStatement ps;
	private ResultSet rs;
	
	@Override
	public int insert(Connection conn, UploadChecklistData docData) {
		
	    try {
	    	String sql = new StringBuilder()
	    			.append("INSERT INTO upload_checklist_data (\n")
	    			.append("	tenant_id,\n")
	    			.append("	upload_checklist_id,\n")
	    			.append("	seq_no,\n")
	    			.append("	revision_no,\n")
	    			.append("	upload_checklist_data,\n")
	    			.append("   regist_date, \n")
	    			.append("   bigo \n")
	    			.append(")\n")
	    			.append("VALUES (\n")
	    			.append("	?,\n")
	    			.append("	?,\n")
	    			.append("	(SELECT * \n")
	    			.append("	FROM (\n")
	    			.append("		SELECT IFNULL((MAX(seq_no) + 1), 0) \n")
	    			.append("		FROM upload_checklist_data \n")
	    			.append("		WHERE upload_checklist_id = ?\n")
	    			.append("	) AS A),\n")
	    			.append("	?,\n")
	    			.append("	?,\n")
	    			.append("	now(), \n")
	    			.append("	? \n")
	    			.append(");\n")
	    			.toString();
	    	
			ps = conn.prepareStatement(sql);
			
			ps.setString(1, JDBCConnectionPool.getTenantId(conn));
			ps.setString(2, docData.getUploadChecklistId());
			ps.setString(3, docData.getUploadChecklistId());
			ps.setInt(4, docData.getRevisionNo());
			ps.setString(5, docData.getUploadChecklistData());
			ps.setString(6, docData.getBigo());
			
	        int i = ps.executeUpdate();

	        if(i == 1) {
	        	return 1;
	        }
	    } catch (SQLException ex) {
	        ex.printStackTrace();
	    } finally {
		    try { ps.close(); } catch (Exception e) { /* Ignored */ }
		}

	    return -1;
	};
	
	@Override
	public int update(Connection conn, UploadChecklistData docData) {
		
		String sql = "";
		
	    try {
	    	sql = new StringBuilder()
	    			.append("UPDATE upload_checklist_data \n")
	    			.append("	SET upload_checklist_data = '"+docData.getUploadChecklistData().toString()+"',	\n")
	    			.append("	bigo = '"+docData.getBigo().toString()+"',	\n")
	    			.append("WHERE upload_checklist_id = '"+docData.getUploadChecklistId()+"' \n")
	    			.append("AND seq_no = '" +docData.getSeqNo() +"' \n")
	    			.toString();
	    	
			Statement ps = conn.createStatement();
			
	        int i = ps.executeUpdate(sql);

	        if(i == 1) {
	        	
	        	return 1;
	        }
	        
	    } catch (SQLException ex) {
	        ex.printStackTrace();
	    } finally {
		    try { ps.close(); } catch (Exception e) { /* Ignored */ }
		}

	    return -1;
	};
	
	@Override
	public int delete(Connection conn, UploadChecklistData docData) {
		System.out.println("daoImpl###########");
		System.out.println(docData.getUploadChecklistId());
		System.out.println(docData.getSeqNo());
	    try {
	    	String sql = new StringBuilder()
	    			.append("DELETE FROM upload_checklist_data \n")
	    			.append("WHERE upload_checklist_id = '"+docData.getUploadChecklistId()+"' \n")
	    			.append("AND seq_no = '" +docData.getSeqNo() +"' \n")
	    			.toString();
	    	
			Statement ps = conn.createStatement();
			
	        int i = ps.executeUpdate(sql);

	        if(i == 1) {
	        	return 1;
	        }
	        
	    } catch (SQLException ex) {
	        ex.printStackTrace();
	    } finally {
		    try { ps.close(); } catch (Exception e) { /* Ignored */ }
		}

	    return -1;
	};
	
	@Override
	public UploadChecklistData select(Connection conn, String documentId, int seqNo) {
		
		try {
			String sql = new StringBuilder()
					.append("SELECT *\n")
					.append("FROM upload_checklist_data\n")
					.append("WHERE tenant_id = '" + JDBCConnectionPool.getTenantId(conn) + "'\n")
					.append("  AND upload_checklist_id = ?\n")
					.append("  AND seq_no = ?;\n")
					.toString();
			
			ps = conn.prepareStatement(sql);
			ps.setString(1, documentId);
			ps.setInt(2, seqNo);
			
			rs = ps.executeQuery();
			
			UploadChecklistData docData = new UploadChecklistData();
					
			if(rs.next()) {
				docData = extractFromResultSet(rs);
			}
			
			return docData;
			
		} catch (SQLException ex) {
			ex.printStackTrace();
		} finally {
			try { ps.close(); } catch (Exception e) { /* Ignored */ }
		    try { rs.close(); } catch (Exception e) { /* Ignored */ }
		}
		
		return null;
	}
	
	@Override
	public List<UploadChecklistData> selectAll(Connection conn, String documentId) {
		try {
			stmt = conn.createStatement();
			
			String sql = new StringBuilder()
				.append("SELECT 									\n")
				.append("A.tenant_id, 								\n")
				.append("A.upload_checklist_id, 							\n")
				.append("A.seq_no, 									\n")
				.append("A.revision_no, 							\n")
				.append("A.upload_checklist_data, 							\n")
				.append("A.regist_date, 							\n")
				.append("A.bigo 									\n")
				.append("FROM upload_checklist_data A						\n")
				.append("WHERE A.tenant_id = '" + JDBCConnectionPool.getTenantId(conn) + "'\n")
				.append("  AND A.upload_checklist_id = '" + documentId + "'	\n")
				.toString();
			
			rs = stmt.executeQuery(sql);
			
			List<UploadChecklistData> docDataList = new ArrayList<UploadChecklistData>();
			
			while(rs.next()) {
				UploadChecklistData data = extractFromResultSet(rs);
				docDataList.add(data);
			}
			
			return docDataList;
			
		} catch (SQLException ex) {
			ex.printStackTrace();
		} finally {
		    try { rs.close(); } catch (Exception e) { /* Ignored */ }
		    try { stmt.close(); } catch (Exception e) { /* Ignored */ }
		}
		
		return null;
	}
	
	private UploadChecklistData extractFromResultSet(ResultSet rs) throws SQLException {
		UploadChecklistData clData = new UploadChecklistData();
	    
	    clData.setUploadChecklistId(rs.getString("upload_checklist_id"));
	    clData.setSeqNo(rs.getInt("seq_no"));
	    clData.setRevisionNo(rs.getInt("revision_no"));
	    clData.setUploadChecklistData(rs.getString("upload_checklist_data"));
	    clData.setRegistDate(rs.getString("regist_date"));
	    clData.setBigo(rs.getString("bigo"));
	    return clData;
	}
	
}