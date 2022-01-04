package mes.dao;

import java.util.ArrayList;
import java.util.List;

import mes.model.Part;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;

public class PartDaoImpl implements PartDao {
	public PartDaoImpl() {
	}

	@Override
	public List<Part> getAllParts(Connection conn) {
		
		try {
			Statement stmt = conn.createStatement();
			String sql = "SELECT * FROM vtbm_part_list";
			ResultSet rs = stmt.executeQuery(sql);
			
			List<Part> partList = new ArrayList<Part>();
			
			if(rs.next()) {
				Part part = extractPartFromResultSet(rs);
				partList.add(part);
			}
			
			return partList;
			
		} catch (SQLException ex) {
			ex.printStackTrace();
		}
		
		return null;
	};
	
	@Override
	public Part getPart(Connection conn, String partCd, int revisionNo) {
		
		try {
			String sql = new StringBuilder()
					.append("SELECT *				\n")
					.append("FROM vtbm_part_list	\n")
					.append("WHERE part_cd = ?		\n")
					.append("  AND revision_no = ?	\n")
					.toString();

			PreparedStatement ps = conn.prepareStatement(sql);
			
			ps.setString(1, partCd);
			ps.setInt(2, revisionNo);
			
			ResultSet rs = ps.executeQuery();
			
			Part part = new Part();
			
			if(rs.next()) {
				part = extractPartFromResultSet(rs);
			}
			
			return part;
			
		} catch (SQLException ex) {
			ex.printStackTrace();
		}
		
		return null;
	};
	
	@Override
	public boolean updatePart(Connection conn, Part part) {
	    return false;
	};
	
	@Override
	public boolean deletePart(Connection conn, Part part) {
		
	    try {
	    	String sql = new StringBuilder()
					.append("UPDATE tbm_part_list	\n")
					.append("SET delyn = 'Y'		\n")
					.append("WHERE part_cd = ?		\n")
					.append("  AND revision_no = ?	\n")
					.toString();

			PreparedStatement ps = conn.prepareStatement(sql);
			
			ps.setString(1, part.getPartCd());
			ps.setInt(2, part.getRevisionNo());
			
	        int i = ps.executeUpdate();

	        if(i == 1) {
	        	return true;
	        }

	    } catch (SQLException ex) {
	        ex.printStackTrace();
	    }

	    return false;
	};
	
	private Part extractPartFromResultSet(ResultSet rs) throws SQLException {
	    Part part = new Part();
	    
		part.setMemberKey(rs.getString("member_key"));
		part.setPartCd(rs.getString("part_cd"));
		part.setRevisionNo(rs.getInt("revision_no"));
		part.setPartGubun(rs.getString("part_gubun"));
		part.setPartNm(rs.getString("partNm"));
		part.setPartGubunBig(rs.getString("part_gubun_b"));
		part.setPartGubunMid(rs.getString("part_gubun_m"));
		part.setPartGubunSmall(rs.getString("part_gubun_s"));
		part.setGyugyeok(rs.getString("gyugyeok"));
		part.setPackingQtty(rs.getFloat("packing_qtty"));
		part.setUnitType(rs.getString("unit_type"));

	    return part;
	}
}
