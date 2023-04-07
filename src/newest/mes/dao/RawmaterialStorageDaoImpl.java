package newest.mes.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;

import org.apache.log4j.Logger;

import mes.frame.database.JDBCConnectionPool;
import newest.mes.model.RawmaterialStorage;

public class RawmaterialStorageDaoImpl implements RawmaterialStorageDao {
	
	private Statement stmt;
	private ResultSet rs;
	
	static final Logger logger = 
			Logger.getLogger(RawmaterialStorageDaoImpl.class.getName());
	
	public RawmaterialStorageDaoImpl() {
	}

	@Override
	public List<RawmaterialStorage> getStockGroupByRawmaterialId(Connection conn) {
		
		try {
			stmt = conn.createStatement();
			
			String sql = new StringBuilder()
				.append("SELECT									\n")
				.append("	P.rawmaterial_id,					\n")
				.append("	P.rawmaterial_name,					\n")
				.append("	IFNULL(SUM(S.io_amt), 0) AS io_amt				\n")
				//.append("FROM mes_rawmaterial_storage S			\n")
				//.append("INNER JOIN rawmaterial P				\n")
				.append("FROM rawmaterial P				\n")
				.append("LEFT JOIN mes_rawmaterial_storage S		\n")
				.append("	ON S.rawmaterial_id = P.rawmaterial_id	\n")
				.append("WHERE P.tenant_id = '" + JDBCConnectionPool.getTenantId(conn) + "'\n")
				.append("GROUP BY P.rawmaterial_id					\n")
				.toString();
			
			logger.debug("sql:\n" + sql);
			
			rs = stmt.executeQuery(sql);
			
			List<RawmaterialStorage> list = new ArrayList<RawmaterialStorage>();
			
			while(rs.next()) {
				RawmaterialStorage data = extractFromResultSet1(rs);
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
	public List<RawmaterialStorage> getStockGroupByStockNo(Connection conn, String rawmaterialId) {
		
		try {
			stmt = conn.createStatement();
			
			String sql = new StringBuilder()
					.append("SELECT										\n")
					.append("	S.rawmaterial_stock_no,					\n")
					.append("	S.rawmaterial_id,						\n")
					.append("	P.rawmaterial_name,						\n")
					.append("	IFNULL(SUM(S.io_amt),0) AS io_amt,		\n")
					.append("	S.where_to_use,							\n")
					.append("	S.prod_stock_no_for_backtrace,			\n")
					.append("	ST.storage_name							\n")
					.append("FROM mes_rawmaterial_storage S				\n")
					.append("INNER JOIN rawmaterial P					\n")
					.append("	ON S.rawmaterial_id = P.rawmaterial_id	\n")
					.append("LEFT JOIN mes_storage ST					\n")
					.append("	ON ST.storage_no = S.storage_no			\n")
					.append("WHERE S.tenant_id = '" + JDBCConnectionPool.getTenantId(conn) + "'	\n")
					.append("	AND S.rawmaterial_id = '" + rawmaterialId + "'					\n")
					.append("GROUP BY S.rawmaterial_stock_no			\n")
					.toString();
			
			logger.debug("sql:\n" + sql);
			
			rs = stmt.executeQuery(sql);
			
			List<RawmaterialStorage> list = new ArrayList<RawmaterialStorage>();
			
			while(rs.next()) {
				RawmaterialStorage data = extractFromResultSet2(rs);
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
	public List<RawmaterialStorage> getStock(Connection conn, String stockNo) {
		
		try {
			stmt = conn.createStatement();
			
			String sql = new StringBuilder()
				.append("SELECT 						\n")
				.append("	S.rawmaterial_stock_no,		\n")
				.append("	S.rawmaterial_id,			\n")
				.append("	P.rawmaterial_name,			\n")
				.append("	S.io_datetime,				\n")
				.append("	S.io_amt,					\n")
				.append("	S.where_to_use				\n")
				.append("FROM mes_rawmaterial_storage S	\n")
				.append("INNER JOIN rawmaterial P		\n")
				.append("	ON S.rawmaterial_id = P.rawmaterial_id\n")
				.append("WHERE S.tenant_id = '" + JDBCConnectionPool.getTenantId(conn) + "'\n")
				.append("  AND S.rawmaterial_stock_no = '" + stockNo + "'\n")
				.toString();
			
			logger.debug("sql:\n" + sql);
			
			rs = stmt.executeQuery(sql);
			
			List<RawmaterialStorage> list = new ArrayList<RawmaterialStorage>();
			
			while(rs.next()) {
				RawmaterialStorage data = extractFromResultSet3(rs);
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
	public boolean ipgoChulgo(Connection conn, RawmaterialStorage storage) {
		try {
			stmt = conn.createStatement();
			
			String sql = new StringBuilder()
					.append("INSERT INTO\n")
					.append("	mes_rawmaterial_storage (\n")
					.append("		tenant_id, \n")
					.append("		rawmaterial_stock_no,\n")
					.append("		seq_no,\n")
					.append("		rawmaterial_id,\n")
					.append("		io_amt,\n")
					.append("		io_datetime,\n")
					.append("		where_to_use,\n")
					.append("		storage_no,\n")
					.append("		prod_stock_no_for_backtrace\n")
					.append("	)\n")
					.append("VALUES\n")
					.append("	(\n")
					.append("		'" + JDBCConnectionPool.getTenantId(conn) + "',\n")
					.append("		'" + storage.getRawmaterialStockNo() + "',\n")
					.append("		(																\n")
					.append("		 SELECT * FROM													\n")
					.append("		 (																\n")
					.append("		  SELECT IFNULL(MAX(seq_no) + 1, 0)								\n")
					.append("		  FROM mes_rawmaterial_storage										\n")
					.append("		  WHERE rawmaterial_stock_no = '" + storage.getRawmaterialStockNo() + "'\n")
					.append("		 ) tmp															\n")
					.append("		),																\n")
					.append("		'" + storage.getRawmaterialId() + "',\n")
					.append("		'" + storage.getIoAmt() + "',\n")
					.append("		'" + storage.getIoDatetime() + "',\n")
					.append("		'',\n")
					.append("		'',\n")
					.append("		''\n")
					.append("	);\n")
					.toString();
			
			logger.debug("sql:\n" + sql);
			
			int i = stmt.executeUpdate(sql);

			if(i > -1) {
	        	return true;
	        }
	    } catch (SQLException ex) {
	        ex.printStackTrace();
	    } finally {
		    try { stmt.close(); } catch (Exception e) { /* Ignored */ }
		}

	    return false;
	}
	
	@Override
	public boolean insert(Connection conn, RawmaterialStorage storage) {
		try {
			String sql = new StringBuilder()
					.append("INSERT INTO\n")
					.append("	mes_rawmaterial_storage (\n")
					.append("		tenant_id, \n")
					.append("		rawmaterial_stock_no,\n")
					.append("		seq_no,\n")
					.append("		rawmaterial_id,\n")
					.append("		io_amt,\n")
					.append("		io_datetime,\n")
					.append("		where_to_use,\n")
					.append("		storage_no,\n")
					.append("		prod_stock_no_for_backtrace,\n")
					.append("	)\n")
					.append("VALUES\n")
					.append("	(\n")
					.append("		?,\n")
					.append("		?,\n")
					.append("		(SELECT NVL(MAX(seq_no) + 1, 0)\n")
					.append("		 FROM mes_rawmaterial_storage\n")
					.append("		 WHERE rawmaterial_stock_no = ?,\n")
					.append("		?,\n")
					.append("		?,\n")
					.append("		?,\n")
					.append("		?,\n")
					.append("		?,\n")
					.append("		?\n")
					.append("	);\n")
					.toString();

			PreparedStatement ps = conn.prepareStatement(sql);
			
			ps.setString(1, JDBCConnectionPool.getTenantId(conn));
			ps.setString(2, storage.getRawmaterialStockNo());
			ps.setString(3, storage.getRawmaterialStockNo());
			ps.setString(4, storage.getRawmaterialId());
			ps.setInt(5, storage.getIoAmt());
			ps.setString(6, storage.getIoDatetime());
			ps.setString(7, storage.getWhereToUse());
			ps.setString(8, storage.getStorageNo());
			ps.setString(9, storage.getProdStockNoForBacktrace());
			
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
	public boolean update(Connection conn, RawmaterialStorage rawmaterialStorage) {
		try {
			stmt = conn.createStatement();
			
			String sql = new StringBuilder()
					.append("UPDATE mes_rawmaterial_storage\n")
					.append("SET io_amt = '" + rawmaterialStorage.getIoAmt() + "'\n")
					.append("WHERE tenant_id='" + JDBCConnectionPool.getTenantId(conn) + "'\n")
					.append("  AND rawmaterial_stock_no='" + rawmaterialStorage.getRawmaterialStockNo() + "';\n")
					.append("  AND seq_no='" + rawmaterialStorage.getSeqNo() + "';\n")
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
	public boolean delete(Connection conn, String stockNo) {
		
		String sql = "";
		
		try {
			stmt = conn.createStatement();
			
			sql = new StringBuilder()
					.append("DELETE FROM mes_rawmaterial_storage \n")
					.append("WHERE tenant_id='" + JDBCConnectionPool.getTenantId(conn) + "'\n")
					.append("	AND rawmaterial_stock_no='" + stockNo + "';\n")
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
	
	private RawmaterialStorage extractFromResultSet1(ResultSet rs) throws SQLException {
		
		RawmaterialStorage rawmaterialStorage = new RawmaterialStorage();
		
		rawmaterialStorage.setRawmaterialId(rs.getString("rawmaterial_id"));
		rawmaterialStorage.setRawmaterialName(rs.getString("rawmaterial_name"));
		rawmaterialStorage.setIoAmt(rs.getInt("io_amt"));
		
		return rawmaterialStorage;
	}

	private RawmaterialStorage extractFromResultSet2(ResultSet rs) throws SQLException {
		
		RawmaterialStorage rawmaterialStorage = new RawmaterialStorage();
		
		rawmaterialStorage.setRawmaterialStockNo(rs.getString("rawmaterial_stock_no"));
		rawmaterialStorage.setRawmaterialId(rs.getString("rawmaterial_id"));
		rawmaterialStorage.setRawmaterialName(rs.getString("rawmaterial_name"));
		rawmaterialStorage.setIoAmt(rs.getInt("io_amt"));
		rawmaterialStorage.setWhereToUse(rs.getString("where_to_use"));
		rawmaterialStorage.setStorageName(rs.getString("storage_name"));
		rawmaterialStorage.setProdStockNoForBacktrace(rs.getString("prod_stock_no_for_backtrace"));
		
		return rawmaterialStorage;
	}

	private RawmaterialStorage extractFromResultSet3(ResultSet rs) throws SQLException {
		
		RawmaterialStorage rawmaterialStorage = new RawmaterialStorage();

		rawmaterialStorage.setRawmaterialStockNo(rs.getString("rawmaterial_stock_no"));
		rawmaterialStorage.setRawmaterialId(rs.getString("rawmaterial_id"));
		rawmaterialStorage.setRawmaterialName(rs.getString("rawmaterial_name"));
		rawmaterialStorage.setIoDatetime(rs.getTimestamp("io_datetime").toString());
		rawmaterialStorage.setIoAmt(rs.getInt("io_amt"));
		rawmaterialStorage.setWhereToUse(rs.getString("where_to_use"));
		
		return rawmaterialStorage;
	}
	
}
