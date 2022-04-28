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

public class ChecklistDataDaoImpl implements ChecklistDataDao {
	
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
	public ChecklistData select(Connection conn, String checklistId, int seqNo) {
		
		try {
			String sql = new StringBuilder()
					.append("SELECT *\n")
					.append("FROM checklist_data\n")
					.append("WHERE tenant_id = '" + JDBCConnectionPool.getTenantId(conn) + "'\n")
					.append("  AND checklist_id = ?\n")
					.append("  AND seq_no = ?;\n")
					.toString();
			
			ps = conn.prepareStatement(sql);
			ps.setString(1, checklistId);
			ps.setInt(2, seqNo);
			
			rs = ps.executeQuery();
			
			ChecklistData clData = new ChecklistData();
					
			if(rs.next()) {
				clData = extractFromResultSet(rs);
			}
			
			return clData;
			
		} catch (SQLException ex) {
			ex.printStackTrace();
		} finally {
			try { ps.close(); } catch (Exception e) { /* Ignored */ }
		    try { rs.close(); } catch (Exception e) { /* Ignored */ }
		}
		
		return null;
	}
	
	@Override
	public ChecklistData selectSignData(Connection conn, String checklistId, int seqNo) {
		
		try {
			String sql = new StringBuilder()
					.append("SELECT \n")
					.append("A.checklist_id, \n")
					.append("B.user_name AS sign_writer, \n")
					.append("C.user_name AS sign_checker, \n")
					.append("D.user_name AS sign_approver \n")
					.append("FROM checklist_data A \n")
					.append("LEFT OUTER JOIN user B \n")
					.append("ON A.sign_writer = B.user_id \n")
					.append("LEFT OUTER JOIN user C \n")
					.append("ON A.sign_checker = C.user_id \n")
					.append("LEFT OUTER JOIN user D \n")
					.append("ON A.sign_approver = D.user_id \n")
					.append("WHERE A.tenant_id = '" + JDBCConnectionPool.getTenantId(conn) + "'\n")
					.append("  AND A.checklist_id = ?\n")
					.append("  AND A.seq_no = ?;\n")
					.toString();
			
			ps = conn.prepareStatement(sql);
			ps.setString(1, checklistId);
			ps.setInt(2, seqNo);
			
			rs = ps.executeQuery();
			
			ChecklistData clData = new ChecklistData();
					
			if(rs.next()) {
				clData = extractSignDataFromResultSet(rs);
			}
			
			return clData;
			
		} catch (SQLException ex) {
			ex.printStackTrace();
		} finally {
			try { ps.close(); } catch (Exception e) { /* Ignored */ }
		    try { rs.close(); } catch (Exception e) { /* Ignored */ }
		}
		
		return null;
	}
	
	@Override
	public List<ChecklistData> selectAll(Connection conn, String checklistId) {
		try {
			stmt = conn.createStatement();
			
			String sql = new StringBuilder()
				.append("SELECT 									\n")
				.append("A.tenant_id, 								\n")
				.append("A.checklist_id, 							\n")
				.append("A.seq_no, 									\n")
				.append("A.revision_no, 							\n")
				.append("A.check_data, 								\n")
				.append("A.write_date, 								\n")
				//.append("A.sign_writer, 							\n")
				//.append("A.sign_checker, 							\n")
				//.append("A.sign_approver 							\n")
				.append("B.user_name AS sign_writer, 				\n")
				.append("C.user_name AS sign_checker, 				\n")
				.append("D.user_name AS sign_approver 				\n")
				.append("FROM checklist_data A						\n")
				.append("LEFT OUTER JOIN user B						\n")
				.append("ON A.sign_writer = B.user_id				\n")
				.append("LEFT OUTER JOIN user C						\n")
				.append("ON A.sign_checker = C.user_id				\n")
				.append("LEFT OUTER JOIN user D						\n")
				.append("ON A.sign_approver = D.user_id				\n")
				.append("WHERE A.tenant_id = '" + JDBCConnectionPool.getTenantId(conn) + "'\n")
				.append("  AND A.checklist_id = '" + checklistId + "'	\n")
				//.append("  AND A.checklist_id = '" + checklistId + "'	\n")
				.toString();
			
			rs = stmt.executeQuery(sql);
			
			List<ChecklistData> clDataList = new ArrayList<ChecklistData>();
			
			while(rs.next()) {
				ChecklistData data = extractFromResultSet(rs);
				clDataList.add(data);
			}
			
			return clDataList;
			
		} catch (SQLException ex) {
			ex.printStackTrace();
		} finally {
		    try { rs.close(); } catch (Exception e) { /* Ignored */ }
		    try { stmt.close(); } catch (Exception e) { /* Ignored */ }
		}
		
		return null;
	}
	
	@Override
	public int doSign(Connection conn, ChecklistData clData, String signTarget, String loginId) {
		
	    try {
	    	String sql = new StringBuilder()
	    			.append("UPDATE checklist_data \n")
	    			.append("	SET "+signTarget+" = '"+loginId+"'	\n")
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
	public List<ChecklistData> selectSignColumn(Connection conn, String checklistId) {
		try {
			stmt = conn.createStatement();
			
			String sql = new StringBuilder()
				.append("SELECT 									\n")
				.append("A.checklist_id, 							\n")
				.append("A.signature_type							\n")
				.append("FROM checklist_sign A						\n")
				.append("WHERE A.tenant_id = '" + JDBCConnectionPool.getTenantId(conn) + "'\n")
				.append("  AND A.checklist_id = '" + checklistId + "'	\n")
				.append("ORDER BY A.signature_type DESC 			\n")
				.toString();
			
			rs = stmt.executeQuery(sql);
			
			List<ChecklistData> clDataList = new ArrayList<ChecklistData>();
			
			while(rs.next()) {
				ChecklistData data = extractSignFromResultSet(rs);
				clDataList.add(data);
			}
			
			return clDataList;
			
		} catch (SQLException ex) {
			ex.printStackTrace();
		} finally {
		    try { rs.close(); } catch (Exception e) { /* Ignored */ }
		    try { stmt.close(); } catch (Exception e) { /* Ignored */ }
		}
		
		return null;
	}
	
	private ChecklistData extractFromResultSet(ResultSet rs) throws SQLException {
	    ChecklistData clData = new ChecklistData();
	    
	    clData.setChecklistId(rs.getString("checklist_id"));
	    clData.setSeqNo(rs.getInt("seq_no"));
	    clData.setRevisionNo(rs.getInt("revision_no"));
	    clData.setCheckData(rs.getString("check_data"));
	    clData.setWriteDate(rs.getString("write_date"));
	    clData.setSignWriter(rs.getString("sign_writer"));
	    clData.setSignChecker(rs.getString("sign_checker"));
	    clData.setSignApprover(rs.getString("sign_approver"));
	    
	    return clData;
	}
	
	private ChecklistData extractSignFromResultSet(ResultSet rs) throws SQLException {
	    ChecklistData clData = new ChecklistData();
	    
	    clData.setChecklistId(rs.getString("checklist_id"));
	    clData.setSignatureType(rs.getString("signature_type"));
	    
	    return clData;
	}
	
	private ChecklistData extractSignDataFromResultSet(ResultSet rs) throws SQLException {
	    ChecklistData clData = new ChecklistData();
	    
	    clData.setChecklistId(rs.getString("checklist_id"));
	    clData.setSignWriter(rs.getString("sign_writer"));
	    clData.setSignChecker(rs.getString("sign_checker"));
	    clData.setSignApprover(rs.getString("sign_approver"));
	    
	    return clData;
	}
}