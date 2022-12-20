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
import model.Rawmaterial;
import viewmodel.RawmaterialViewModel;

public class RawmaterialDaoImpl implements RawmaterialDao {
	
	private Statement stmt;
	private ResultSet rs;
	
	static final Logger logger = 
			Logger.getLogger(RawmaterialDaoImpl.class.getName());
	
	public RawmaterialDaoImpl() {
	}

	@Override
	public List<Rawmaterial> getAllRawmaterials(Connection conn) {
		
		try {
			stmt = conn.createStatement();
			
			String sql = new StringBuilder()
				.append("SELECT * 			\n")
				.append("FROM rawmaterial	\n")
				.append("WHERE tenant_id = '" + JDBCConnectionPool.getTenantId(conn) + "'\n")
				.toString();
			
			logger.debug("sql:\n" + sql);
			
			rs = stmt.executeQuery(sql);
			
			List<Rawmaterial> list = new ArrayList<Rawmaterial>();
			
			while(rs.next()) {
				Rawmaterial data = extractFromResultSet(rs);
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
	public Rawmaterial getRawmaterial(Connection conn, String rawmaterialId) {
		
		try {
			stmt = conn.createStatement();
			
			String sql = new StringBuilder()
				.append("SELECT * 		\n")
				.append("FROM product	\n")
				.append("WHERE tenant_id = '" + JDBCConnectionPool.getTenantId(conn) + "'\n")
				.append("  AND rawmaterial_id = '" + rawmaterialId + "'\n")
				.toString();
			
			logger.debug("sql:\n" + sql);
			
			rs = stmt.executeQuery(sql);
			
			Rawmaterial rawmaterial = null;
			
			if(rs.next()) {
				rawmaterial = extractFromResultSet(rs);
			}
			
			return rawmaterial;
		} catch (SQLException ex) {
			ex.printStackTrace();
		} finally {
		    try { rs.close(); } catch (Exception e) { /* Ignored */ }
		    try { stmt.close(); } catch (Exception e) { /* Ignored */ }
		}
		
		return null;
	};
	
	@Override
	public boolean insert(Connection conn, Rawmaterial rawmaterial) {
		try {
			String sql = new StringBuilder()
					.append("INSERT INTO\n")
					.append("	rawmaterial (\n")
					.append("		tenant_id,\n")
					.append("		rawmaterial_id,\n")
					.append("		rawmaterial_name\n")
					.append("	)\n")
					.append("VALUES\n")
					.append("	(\n")
					.append("		?,\n")
					.append("		?,\n")
					.append("		?\n")
					.append("	);\n")
					.toString();

			PreparedStatement ps = conn.prepareStatement(sql);
			
			ps.setString(1, JDBCConnectionPool.getTenantId(conn));
			ps.setString(2, rawmaterial.getRawmaterialId());
			ps.setString(3, rawmaterial.getRawmaterialName());
			
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
	public boolean update(Connection conn, Rawmaterial rawmaterial) {
		try {
			stmt = conn.createStatement();
			
			String sql = new StringBuilder()
					.append("UPDATE rawmaterial\n")
					.append("SET rawmaterial_name='" + rawmaterial.getRawmaterialName() + "'\n")
					.append("WHERE tenant_id='" + JDBCConnectionPool.getTenantId(conn) + "'\n")
					.append("  AND rawmaterial_id='" + rawmaterial.getRawmaterialId() + "';\n")
					.toString();
			
			logger.debug("sql:\n" + sql);
			
	        int i = stmt.executeUpdate(sql);

	        if(i == 1) {
	        	return true;
	        }

	    } catch (SQLException ex) {
	        ex.printStackTrace();
	    }

	    return false;
	}
	
	@Override
	public boolean delete(Connection conn, String rawmaterialId) {
		try {
			stmt = conn.createStatement();
			
			String sql = new StringBuilder()
					.append("DELETE FROM rawmaterial\n")
					.append("WHERE tenant_id='" + JDBCConnectionPool.getTenantId(conn) + "'\n")
					.append("	AND rawmaterial_id='" + rawmaterialId + "';\n")
					.toString();
			
			logger.debug("sql:\n" + sql);
			
			int i = stmt.executeUpdate(sql);

	        if(i == 1) {
	        	return true;
	        }

	    } catch (SQLException ex) {
	        ex.printStackTrace();
	    }

	    return false;
	}
	
	@Override
	public List<RawmaterialViewModel> getAllRawmaterialsViewModels(Connection conn) {
		
		try {
			stmt = conn.createStatement();
			
			String sql = new StringBuilder()
				.append("SELECT  									\n")
				.append("	r1.rawmaterial_id, 						\n")
				.append("	r2.rawmaterial_name AS rawmaterial_type,\n")
				.append("	r1.rawmaterial_name						\n")
				.append("FROM rawmaterial r1						\n")
				.append("INNER JOIN rawmaterial r2					\n")
				.append("	ON r1.parent_id = r2.rawmaterial_id		\n")
				.append("WHERE r1.tenant_id = '" + JDBCConnectionPool.getTenantId(conn) + "'\n")
				.append("	AND r1.level = 1				\n")
				.toString();
			
			logger.debug("sql:\n" + sql);
			
			rs = stmt.executeQuery(sql);
			
			List<RawmaterialViewModel> list = new ArrayList<RawmaterialViewModel>();
			
			while(rs.next()) {
				RawmaterialViewModel data = extractViewModelFromResultSet(rs);
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
	
	private Rawmaterial extractFromResultSet(ResultSet rs) throws SQLException {
		return new Rawmaterial(
					rs.getString("rawmaterial_id"),
					rs.getString("rawmaterial_name")
				);
	}

	private RawmaterialViewModel extractViewModelFromResultSet(ResultSet rs) throws SQLException {
		return new RawmaterialViewModel(
				rs.getString("rawmaterial_id"),
				rs.getString("rawmaterial_type"),
				rs.getString("rawmaterial_name")
			);
	}
}
