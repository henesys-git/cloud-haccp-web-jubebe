package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

import mes.frame.database.JDBCConnectionPool;
import mes.model.ChecklistInfo;

public class ChecklistInfoDaoImpl implements ChecklistInfoDao {
	
//	@Override
//	public int insert(Connection conn, ChecklistData clData) {
//		
//	    try {
//	    	String sql = new StringBuilder()
//	    			.append("INSERT INTO checklist_data (\n")
//	    			.append("	checklist_id,\n")
//	    			.append("	seq_no,\n")
//	    			.append("	revision_no,\n")
//	    			.append("	check_data\n")
//	    			.append(")\n")
//	    			.append("VALUES (\n")
//	    			.append("	?,\n")
//	    			.append("	(SELECT * \n")
//	    			.append("	FROM (\n")
//	    			.append("		SELECT IFNULL((MAX(seq_no) + 1), 0) \n")
//	    			.append("		FROM checklist_data \n")
//	    			.append("		WHERE checklist_id = ?\n")
//	    			.append("	) AS A),\n")
//	    			.append("	?,\n")
//	    			.append("	?\n")
//	    			.append(");\n")
//	    			.toString();
//	    	
//			PreparedStatement ps = conn.prepareStatement(sql);
//			
//			ps.setString(1, clData.getChecklistId());
//			ps.setString(2, clData.getChecklistId());
//			ps.setInt(3, clData.getRevisionNo());
//			ps.setString(4, clData.getCheckData());
//			
//	        int i = ps.executeUpdate();
//
//	        if(i == 1) {
//	        	return 1;
//	        }
//
//	    } catch (SQLException ex) {
//	        ex.printStackTrace();
//	    }
//
//	    return -1;
//	};
	
	@Override
	public ChecklistInfo select(Connection conn, String checklistId) {
		try {
			String sql = new StringBuilder()
					.append("SELECT *\n")
					.append("FROM checklist_info\n")
					.append("WHERE tenant_id = '" + JDBCConnectionPool.getTenantId(conn) + "'\n")
					.append("  AND checklist_id = ?;\n")
					.toString();
			
			PreparedStatement ps = conn.prepareStatement(sql);
			ps.setString(1, checklistId);
			
			ResultSet rs = ps.executeQuery();
			
			ChecklistInfo clInfo = new ChecklistInfo();
					
			if(rs.next()) {
				clInfo = extractFromResultSet(rs);
			}
			
			return clInfo;
			
		} catch (SQLException ex) {
			ex.printStackTrace();
		}
		
		return null;
	}
	
//	@Override
//	public List<ChecklistData> selectAll(Connection conn, String checklistId) {
//		try {
//			Statement stmt = conn.createStatement();
//			
//			String sql = new StringBuilder()
//				.append("SELECT *									\n")
//				.append("FROM checklist_data						\n")
//				.append("WHERE checklist_id = '" + checklistId + "'	\n")
//				.toString();
//			
//			ResultSet rs = stmt.executeQuery(sql);
//			
//			List<ChecklistData> clDataList = new ArrayList<ChecklistData>();
//			
//			while(rs.next()) {
//				ChecklistData data = extractFromResultSet(rs);
//				clDataList.add(data);
//			}
//			
//			return clDataList;
//			
//		} catch (SQLException ex) {
//			ex.printStackTrace();
//		}
//		
//		return null;
//	}
	
	private ChecklistInfo extractFromResultSet(ResultSet rs) throws SQLException {
	    ChecklistInfo clInfo = new ChecklistInfo();
	    
	    clInfo.setChecklistId(rs.getString("checklist_id"));
	    clInfo.setRevisionNo(rs.getInt("revision_no"));
	    clInfo.setChecklistName(rs.getString("checklist_name"));
	    clInfo.setImagePath(rs.getString("image_path"));
	    clInfo.setMetaDataFilePath(rs.getString("meta_data_file_path"));
	    
	    return clInfo;
	}
}