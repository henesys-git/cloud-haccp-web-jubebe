package mes.frame.business.product;

import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;

import mes.frame.database.JDBCConnectionPool;

public class ProductPacking {
	
	public int getInnerPackingCount(String prodCd, int revNo) {
		Connection con = JDBCConnectionPool.getConnection();
		
		try {
			Statement stmt = con.createStatement();
			ResultSet rs = stmt.executeQuery(
					"SELECT * 							\n" +
					"FROM tbm_product 					\n" +
					"WHERE prod_cd = '" + prodCd + "'	\n" +
					"  AND revision_no = " + revNo + "		");
			
			if(rs.next()) {
				int innerPackingCount = rs.getInt("count_in_pack");
				return innerPackingCount;
			}
			
		} catch (SQLException ex) {
			ex.printStackTrace();
		}
		
		return -1;
	}
	
	public int getOuterPackingCount(String prodCd, int revNo) {
		Connection con = JDBCConnectionPool.getConnection();
		
		try {
			Statement stmt = con.createStatement();
			ResultSet rs = stmt.executeQuery(
					"SELECT * 							\n" +
					"FROM tbm_product 					\n" +
					"WHERE prod_cd = '" + prodCd + "'	\n" +
					"  AND revision_no = " + revNo + "		");
			
			if(rs.next()) {
				int outerPackingCount = rs.getInt("count_in_box");
				return outerPackingCount;
			}
			
		} catch (SQLException ex) {
			ex.printStackTrace();
		}
		
		return -1;
	}
	
	public int getTotalPackingCount(String prodCd, int revNo) {
		Connection con = JDBCConnectionPool.getConnection();
		
		try {
			Statement stmt = con.createStatement();
			ResultSet rs = stmt.executeQuery(
					"SELECT * 							\n" +
					"FROM tbm_product 					\n" +
					"WHERE prod_cd = '" + prodCd + "'	\n" +
					"  AND revision_no = " + revNo + "		");
			
			if(rs.next()) {
				int innerPackingCount = rs.getInt("count_in_pack");
				int outerPackingCount = rs.getInt("count_in_box");
				int ttlCnt = innerPackingCount * outerPackingCount;
				
				return ttlCnt;
			}
			
		} catch (SQLException ex) {
			ex.printStackTrace();
		}
		
		return -1;
	}
}
