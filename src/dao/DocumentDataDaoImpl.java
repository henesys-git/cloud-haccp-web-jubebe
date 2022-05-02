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

public class DocumentDataDaoImpl implements DocumentDataDao {
	
	private Statement stmt;
	private PreparedStatement ps;
	private ResultSet rs;
	
	@Override
	public int insert(Connection conn, ChecklistData clData) {
		
	    try {
	    	String sql = new StringBuilder()
	    			.append("INSERT INTO checklist_data (\n")
	    			.append("	tenant_id,\n")
	    			.append("	checklist_id,\n")
	    			.append("	seq_no,\n")
	    			.append("	revision_no,\n")
	    			.append("	check_data,\n")
	    			.append("   write_date \n")
	    			.append(")\n")
	    			.append("VALUES (\n")
	    			.append("	?,\n")
	    			.append("	?,\n")
	    			.append("	(SELECT * \n")
	    			.append("	FROM (\n")
	    			.append("		SELECT IFNULL((MAX(seq_no) + 1), 0) \n")
	    			.append("		FROM checklist_data \n")
	    			.append("		WHERE checklist_id = ?\n")
	    			.append("	) AS A),\n")
	    			.append("	?,\n")
	    			.append("	?,\n")
	    			.append("	now() \n")
	    			.append(");\n")
	    			.toString();
	    	
			ps = conn.prepareStatement(sql);
			
			ps.setString(1, JDBCConnectionPool.getTenantId(conn));
			ps.setString(2, clData.getChecklistId());
			ps.setString(3, clData.getChecklistId());
			ps.setInt(4, clData.getRevisionNo());
			ps.setString(5, clData.getCheckData());
			
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
	public int update(Connection conn, ChecklistData clData) {
		
		String sql = "";
		
	    try {
	    	System.out.println("clData.getCheckData()===================");
	    	System.out.println(clData.getCheckData());
	    	System.out.println(clData.getCheckData().toString().replaceAll("\r\n", "\n"));
	    	System.out.println(clData.getCheckData().replaceAll("\r\n", "<br>"));
	    	System.out.println(clData.getCheckData().replaceAll("\n", "<br>"));
	    	sql = new StringBuilder()
	    			.append("UPDATE checklist_data \n")
	    			.append("	SET check_data = '"+clData.getCheckData().toString()+"'	\n")
	    			.append("WHERE checklist_id = '"+clData.getChecklistId()+"' \n")
	    			.append("AND seq_no = '" +clData.getSeqNo() +"' \n")
	    			.toString();
	    	
			Statement ps = conn.createStatement();
			
	        int i = ps.executeUpdate(sql);

	        if(i < 0) {
	        	conn.rollback();
	        	return -1;
	        }
	        
	        sql = new StringBuilder()
	    			.append("UPDATE checklist_data \n")
	    			.append("	SET sign_writer = NULL,	\n")
	    			.append("		sign_checker = NULL,\n")
	    			.append("		sign_approver = NULL \n")
	    			.append("WHERE checklist_id = '"+clData.getChecklistId()+"' \n")
	    			.append("AND seq_no = '" +clData.getSeqNo() +"' \n")
	    			.toString();
	        
	        int j = ps.executeUpdate(sql);
	        
	        if(j == 1) {
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
	public int delete(Connection conn, ChecklistData clData) {
		
	    try {
	    	String sql = new StringBuilder()
	    			.append("DELETE FROM checklist_data \n")
	    			.append("WHERE checklist_id = '"+clData.getChecklistId()+"' \n")
	    			.append("AND seq_no = '" +clData.getSeqNo() +"' \n")
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
	public DocumentData select(Connection conn, String documentId, int seqNo) {
		
		try {
			String sql = new StringBuilder()
					.append("SELECT *\n")
					.append("FROM document_data\n")
					.append("WHERE tenant_id = '" + JDBCConnectionPool.getTenantId(conn) + "'\n")
					.append("  AND document_id = ?\n")
					.append("  AND seq_no = ?;\n")
					.toString();
			
			ps = conn.prepareStatement(sql);
			ps.setString(1, documentId);
			ps.setInt(2, seqNo);
			
			rs = ps.executeQuery();
			
			DocumentData docData = new DocumentData();
					
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
	public List<DocumentData> selectAll(Connection conn, String documentId) {
		try {
			stmt = conn.createStatement();
			
			String sql = new StringBuilder()
				.append("SELECT 									\n")
				.append("A.tenant_id, 								\n")
				.append("A.document_id, 							\n")
				.append("A.seq_no, 									\n")
				.append("A.revision_no, 							\n")
				.append("A.document_data, 							\n")
				.append("A.regist_date 								\n")
				.append("FROM document_data A						\n")
				.append("WHERE A.tenant_id = '" + JDBCConnectionPool.getTenantId(conn) + "'\n")
				.append("  AND A.document_id = '" + documentId + "'	\n")
				.toString();
			
			rs = stmt.executeQuery(sql);
			
			List<DocumentData> docDataList = new ArrayList<DocumentData>();
			
			while(rs.next()) {
				DocumentData data = extractFromResultSet(rs);
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
	
	private DocumentData extractFromResultSet(ResultSet rs) throws SQLException {
	    DocumentData clData = new DocumentData();
	    
	    clData.setDocumentId(rs.getString("document_id"));
	    clData.setSeqNo(rs.getInt("seq_no"));
	    clData.setRevisionNo(rs.getInt("revision_no"));
	    clData.setDocumentData(rs.getString("document_data"));
	    clData.setRegistDate(rs.getString("regist_date"));
	    
	    return clData;
	}
	
}