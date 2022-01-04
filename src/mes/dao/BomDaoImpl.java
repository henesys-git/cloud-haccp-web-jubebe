package mes.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;

import mes.model.Bom;

public class BomDaoImpl implements BomDao {
	public BomDaoImpl() {
	}

	@Override
	public List<Bom> getAllBoms(Connection conn) {
		
		try {
			Statement stmt = conn.createStatement();
			
			String sql = new StringBuilder()
				.append("SELECT * 								\n")
				.append("FROM tbm_bom_info2 					\n")
				.append("WHERE SYSDATE BETWEEN start_date		\n")
				.append("  				   AND duration_date	\n")
				.toString();
			
			ResultSet rs = stmt.executeQuery(sql);
			
			List<Bom> bomList = new ArrayList<Bom>();
			
			if(rs.next()) {
				Bom bom = extractBomFromResultSet(rs);
				bomList.add(bom);
			}
			
			return bomList;
			
		} catch (SQLException ex) {
			ex.printStackTrace();
		}
		
		return null;
	};
	
	@Override
	public List<Bom> getAllBomsForProduct(Connection conn, String prodCd) {
		
		try {
			String sql = new StringBuilder()
					.append("SELECT * 							\n")
					.append("FROM tbm_bom_info2 				\n")
					.append("WHERE prod_cd = ?					\n")
					.append("  AND SYSDATE BETWEEN start_date	\n")
					.append("  	   		    AND duration_date	\n")
					.toString();

			PreparedStatement ps = conn.prepareStatement(sql);
			ps.setString(1, prodCd);

			ResultSet rs = ps.executeQuery();
			
			List<Bom> bomList = new ArrayList<Bom>();
			
			if(rs.next()) {
				Bom bom = extractBomFromResultSet(rs);
				bomList.add(bom);
			}
			
			return bomList;
			
		} catch (SQLException ex) {
			ex.printStackTrace();
		}
		
		return null;
	};
	
	@Override
	public Bom getBom(Connection conn, String prodCd, String partCd) {
		
		try {
			String sql = new StringBuilder()
					.append("SELECT *							\n")
					.append("FROM tbm_bom_info2					\n")
					.append("WHERE prod_cd = ?					\n")
					.append("  AND part_cd = ?					\n")
					.append("  AND SYSDATE BETWEEN start_date	\n")
					.append("  				AND duration_date	\n")
					.toString();

			PreparedStatement ps = conn.prepareStatement(sql);
			
			ps.setString(1, prodCd);
			ps.setString(2, partCd);
			
			ResultSet rs = ps.executeQuery();
			
			Bom bom = new Bom();
			
			if(rs.next()) {
				bom = extractBomFromResultSet(rs);
			}
			
			return bom;
			
		} catch (SQLException ex) {
			ex.printStackTrace();
		}
		
		return null;
	};
	
	@Override
	public boolean updateBom(Connection conn, Bom bom) {
	    return false;
	};
	
	@Override
	public boolean deleteBom(Connection conn, Bom bom) {
		
	    try {
	    	String sql = new StringBuilder()
					.append("UPDATE tbm_bom_list	\n")
					.append("SET delyn = 'Y'		\n")
					.append("WHERE prod_cd = ?		\n")
					.append("  AND part_cd = ?		\n")
					.toString();

			PreparedStatement ps = conn.prepareStatement(sql);
			
			ps.setString(1, bom.getProdCd());
			ps.setString(2, bom.getPartCd());
			
	        int i = ps.executeUpdate();

	        if(i == 1) {
	        	return true;
	        }

	    } catch (SQLException ex) {
	        ex.printStackTrace();
	    }

	    return false;
	};
	
	private Bom extractBomFromResultSet(ResultSet rs) throws SQLException {
	    Bom bom = new Bom();
	    
		bom.setProdCd(rs.getString("prod_cd"));
		bom.setPartCd(rs.getString("part_cd"));
		bom.setBlendingRatio(rs.getDouble("blending_ratio"));

	    return bom;
	}
}
