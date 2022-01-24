package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

import mes.model.ChecklistData;
import mes.model.DailyPlanDetail;

public class ChecklistDataDaoImpl implements ChecklistDataDao {
	
	@Override
	public int insert(Connection conn, ChecklistData clData) {
		
	    try {
	    	String sql = new StringBuilder()
	    			.append("INSERT INTO checklist_data (\n")
	    			.append("	checklist_id,\n")
	    			.append("	seq_no,\n")
	    			.append("	revisison_no,\n")
	    			.append("	check_data\n")
	    			.append(")\n")
	    			.append("VALUES (\n")
	    			.append("	?,\n")
	    			.append("	(SELECT * \n")
	    			.append("	FROM (\n")
	    			.append("		SELECT IFNULL((MAX(seq_no) + 1), 0) \n")
	    			.append("		FROM checklist_data \n")
	    			.append("		WHERE checklist_id = ?\n")
	    			.append("	) AS A),\n")
	    			.append("	?,\n")
	    			.append("	?\n")
	    			.append(");\n")
	    			.toString();
	    	
			PreparedStatement ps = conn.prepareStatement(sql);
			
			ps.setString(1, clData.getChecklistId());
			ps.setString(2, clData.getChecklistId());
			ps.setInt(3, clData.getRevisionNo());
			ps.setString(4, clData.getCheckData());
			
	        int i = ps.executeUpdate();

	        if(i == 1) {
	        	return 1;
	        }

	    } catch (SQLException ex) {
	        ex.printStackTrace();
	    }

	    return -1;
	};
	
	@Override
	public ChecklistData select(Connection conn, String checklistId, int seqNo) {
		try {
			String sql = new StringBuilder()
					.append("SELECT *\n")
					.append("FROM checklist_data\n")
					.append("WHERE checklist_id = ?\n")
					.append("AND seq_no = ?;\n")
					.toString();
			
			PreparedStatement ps = conn.prepareStatement(sql);
			ps.setString(1, checklistId);
			ps.setInt(2, seqNo);
			
			ResultSet rs = ps.executeQuery();
			
			ChecklistData clData = new ChecklistData();
					
			if(rs.next()) {
				clData = extractFromResultSet(rs);
			}
			
			return clData;
			
		} catch (SQLException ex) {
			ex.printStackTrace();
		}
		
		return null;
	}
	
	private ChecklistData extractFromResultSet(ResultSet rs) throws SQLException {
	    ChecklistData clData = new ChecklistData();
	    
	    clData.setChecklistId(rs.getString("checklist_id"));
	    clData.setSeqNo(rs.getInt("seq_no"));
	    clData.setRevisionNo(rs.getInt("revision_no"));
	    clData.setCheckData(rs.getString("check_data"));
	    clData.setSignWriter(rs.getString("sign_writer"));
	    clData.setSignChecker(rs.getString("sign_checker"));
	    clData.setSignApprover(rs.getString("sign_approver"));
	    
	    return clData;
	}
}