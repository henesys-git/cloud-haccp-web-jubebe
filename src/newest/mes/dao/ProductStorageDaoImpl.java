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
import newest.mes.model.ProductStorage;

public class ProductStorageDaoImpl implements ProductStorageDao {
	
	private Statement stmt;
	private ResultSet rs;
	
	static final Logger logger = 
			Logger.getLogger(ProductStorageDaoImpl.class.getName());
	
	public ProductStorageDaoImpl() {
	}

	@Override
	public List<ProductStorage> getStockGroupByProductId(Connection conn) {
		
		try {
			stmt = conn.createStatement();
			
			String sql = new StringBuilder()
				.append("SELECT										\n")
				.append("	P.product_id,							\n")
				.append("	P.product_name,							\n")
				.append("	IFNULL(SUM(S.io_amt), 0) AS io_amt		\n")
				.append("FROM product P								\n")
				.append("LEFT JOIN mes_product_storage S			\n")
				.append("	ON P.product_id = S.product_id			\n")
				.append("WHERE P.tenant_id = '" + JDBCConnectionPool.getTenantId(conn) + "'\n")
				.append("GROUP BY P.product_id						\n")
				.toString();
			
			logger.debug("sql:\n" + sql);
			
			rs = stmt.executeQuery(sql);
			
			List<ProductStorage> list = new ArrayList<ProductStorage>();
			
			while(rs.next()) {
				ProductStorage data = extractFromResultSet1(rs);
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
	public List<ProductStorage> getStockGroupByStockNo(Connection conn, String productId) {
		
		try {
			stmt = conn.createStatement();
			
			String sql = new StringBuilder()
					.append("SELECT									\n")
					.append("	S.product_stock_no,					\n")
					.append("	P.product_id,						\n")
					.append("	P.product_name,						\n")
					.append("	S.io_datetime,						\n")
					.append("	IFNULL(SUM(S.io_amt), 0) AS io_amt,	\n")
					.append("	S.lotno,							\n")
					.append("	S.expiration_date,					\n")
					.append("	ST.storage_name						\n")
					.append("FROM product P							\n")
					.append("LEFT JOIN mes_product_storage S		\n")
					.append("	ON P.product_id = S.product_id		\n")
					.append("LEFT JOIN mes_storage ST				\n")
					.append("	ON ST.storage_no = S.storage_no		\n")
					.append("WHERE P.tenant_id = '" + JDBCConnectionPool.getTenantId(conn) + "'\n")
					.append("	AND P.product_id = '" + productId + "'\n")
					.append("GROUP BY S.product_stock_no		\n")
					.toString();
			
			logger.debug("sql:\n" + sql);
			
			rs = stmt.executeQuery(sql);
			
			List<ProductStorage> list = new ArrayList<ProductStorage>();
			
			while(rs.next()) {
				ProductStorage data = extractFromResultSet2(rs);
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
	public List<ProductStorage> getStockGroupByStockNoSortByIoDatetime(Connection conn, String productId) {
		
		try {
			stmt = conn.createStatement();
			
			String sql = new StringBuilder()
					.append("SELECT									\n")
					.append("	S.product_stock_no,					\n")
					.append("	P.product_id,						\n")
					.append("	P.product_name,						\n")
					.append("	S.io_datetime,						\n")
					.append("	IFNULL(SUM(S.io_amt), 0) AS io_amt,	\n")
					.append("	S.lotno,							\n")
					.append("	S.expiration_date,					\n")
					.append("	ST.storage_name						\n")
					.append("FROM product P							\n")
					.append("LEFT JOIN mes_product_storage S		\n")
					.append("	ON P.product_id = S.product_id		\n")
					.append("LEFT JOIN mes_storage ST				\n")
					.append("	ON ST.storage_no = S.storage_no		\n")
					.append("WHERE P.tenant_id = '" + JDBCConnectionPool.getTenantId(conn) + "'\n")
					.append("	AND P.product_id = '" + productId + "'\n")
					.append("GROUP BY S.product_stock_no			\n")
					.append("ORDER BY S.io_datetime ASC;			\n")
					.toString();
			
			logger.debug("sql:\n" + sql);
			
			rs = stmt.executeQuery(sql);
			
			List<ProductStorage> list = new ArrayList<ProductStorage>();
			
			while(rs.next()) {
				ProductStorage data = extractFromResultSet2(rs);
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
	public List<ProductStorage> getStock(Connection conn, String stockNo) {
		
		try {
			stmt = conn.createStatement();
			
			String sql = new StringBuilder()
				.append("SELECT 					\n")
				.append("	S.product_stock_no,		\n")
				.append("	S.product_id,			\n")
				.append("	P.product_name,			\n")
				.append("	S.io_datetime,			\n")
				.append("	S.io_amt,				\n")
				.append("	S.bigo					\n")
				.append("FROM mes_product_storage S	\n")
				.append("INNER JOIN product P		\n")
				.append("	ON S.product_id = P.product_id\n")
				.append("WHERE S.tenant_id = '" + JDBCConnectionPool.getTenantId(conn) + "'\n")
				.append("  AND S.product_stock_no = '" + stockNo + "'\n")
				.toString();
			
			logger.debug("sql:\n" + sql);
			
			rs = stmt.executeQuery(sql);
			
			List<ProductStorage> list = new ArrayList<ProductStorage>();
			
			while(rs.next()) {
				ProductStorage data = extractFromResultSet3(rs);
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
	public boolean ipgoChulgo(Connection conn, ProductStorage storage) {
		
		String sql = "";
		
		try {
			stmt = conn.createStatement();
			
			if(storage.getProdResultParam().equals("Y")) {
				
				sql = new StringBuilder()
						.append("UPDATE \n")
						.append("	mes_production_instruction \n")
						.append("SET ipgo_yn = 'Y'\n")
						.append("WHERE plan_no = '"+ storage.getPlanNo() + "'\n")
						.append("\n")
						.toString();
				
				
				logger.debug("sql:\n" + sql);
				int k = stmt.executeUpdate(sql);
				
			}
			
			sql = new StringBuilder()
					.append("INSERT INTO\n")
					.append("	mes_product_storage (\n")
					.append("		tenant_id, \n")
					.append("		product_stock_no,\n")
					.append("		seq_no,\n")
					.append("		product_id,\n")
					.append("		io_amt,\n")
					.append("		io_datetime,\n")
					.append("		lotno,\n")
					.append("		expiration_date,\n")
					.append("		expiration_date_bigo,\n")
					.append("		bigo,\n")
					.append("		storage_no,\n")
					.append("		rawmaterial_deduct_yn\n")
					.append("	)\n")
					.append("VALUES\n")
					.append("	(\n")
					.append("		'" + JDBCConnectionPool.getTenantId(conn) + "',\n")
					.append("		'" + storage.getProductStockNo() + "',\n")
					.append("		(																\n")
					.append("		 SELECT * FROM													\n")
					.append("		 (																\n")
					.append("		  SELECT IFNULL(MAX(seq_no) + 1, 0)								\n")
					.append("		  FROM mes_product_storage										\n")
					.append("		  WHERE product_stock_no = '" + storage.getProductStockNo() + "'\n")
					.append("		 ) tmp															\n")
					.append("		),																\n")
					.append("		'" + storage.getProductId() + "',\n")
					.append("		'" + storage.getIoAmt() + "',\n")
					.append("		'" + storage.getIoDatetime() + "',\n")
					.append("		'',\n")
					.append("		'2023-01-01',\n")
					.append("		'',\n")
					.append("		'',\n")
					.append("		'',\n")
					.append("		'N'\n")
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
	public boolean insert(Connection conn, ProductStorage storage) {
		try {
			String sql = new StringBuilder()
					.append("INSERT INTO\n")
					.append("	mes_product_storage (\n")
					.append("		tenant_id, \n")
					.append("		product_stock_no,\n")
					.append("		seq_no,\n")
					.append("		product_id,\n")
					.append("		io_amt,\n")
					.append("		io_datetime,\n")
					.append("		lotno,\n")
					.append("		expiration_date,\n")
					.append("		expiration_date_bigo,\n")
					.append("		bigo,\n")
					.append("		storage_no,\n")
					.append("		rawmaterial_deduct_yn,\n")
					.append("	)\n")
					.append("VALUES\n")
					.append("	(\n")
					.append("		?,\n")
					.append("		?,\n")
					.append("		(SELECT NVL(MAX(seq_no) + 1, 0)\n")
					.append("		 FROM mes_product_storage\n")
					.append("		 WHERE product_stock_no = ?,\n")
					.append("		?,\n")
					.append("		?,\n")
					.append("		?,\n")
					.append("		?,\n")
					.append("		?,\n")
					.append("		?,\n")
					.append("		?,\n")
					.append("		?,\n")
					.append("		'N'\n")
					.append("	);\n")
					.toString();

			PreparedStatement ps = conn.prepareStatement(sql);
			
			ps.setString(1, JDBCConnectionPool.getTenantId(conn));
			ps.setString(2, storage.getProductStockNo());
			ps.setString(3, storage.getProductStockNo());
			ps.setString(4, storage.getProductId());
			ps.setInt(5, storage.getIoAmt());
			ps.setString(6, storage.getIoDatetime());
			ps.setString(7, storage.getLotno());
			ps.setString(8, storage.getExpirationDate());
			ps.setString(9, storage.getExpirationDateBigo());
			ps.setString(10, storage.getBigo());
			ps.setString(11, storage.getStorageNo());
			
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
	public boolean update(Connection conn, ProductStorage productStorage) {
		try {
			stmt = conn.createStatement();
			
			String sql = new StringBuilder()
					.append("UPDATE mes_product_storage\n")
					.append("SET io_amt = '" + productStorage.getIoAmt() + "'\n")
					.append("WHERE tenant_id='" + JDBCConnectionPool.getTenantId(conn) + "'\n")
					.append("  AND product_stock_no='" + productStorage.getProductStockNo() + "';\n")
					.append("  AND seq_no='" + productStorage.getSeqNo() + "';\n")
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
					.append("DELETE FROM mes_product_storage \n")
					.append("WHERE tenant_id='" + JDBCConnectionPool.getTenantId(conn) + "'\n")
					.append("	AND product_stock_no='" + stockNo + "';\n")
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
	
	private ProductStorage extractFromResultSet1(ResultSet rs) throws SQLException {
		
		ProductStorage productStorage = new ProductStorage();
		
		productStorage.setProductId(rs.getString("product_id"));
		productStorage.setProductName(rs.getString("product_name"));
		productStorage.setIoAmt(rs.getInt("io_amt"));
		
		return productStorage;
	}

	private ProductStorage extractFromResultSet2(ResultSet rs) throws SQLException {
		
		ProductStorage productStorage = new ProductStorage();
		
		productStorage.setProductStockNo(rs.getString("product_stock_no"));
		productStorage.setProductId(rs.getString("product_id"));
		productStorage.setProductName(rs.getString("product_name"));
		productStorage.setIoDatetime(rs.getString("io_datetime"));
		productStorage.setIoAmt(rs.getInt("io_amt"));
		productStorage.setLotno(rs.getString("lotno"));
		productStorage.setExpirationDate(rs.getString("expiration_date"));
		productStorage.setStorageName(rs.getString("storage_name"));
		
		return productStorage;
	}

	private ProductStorage extractFromResultSet3(ResultSet rs) throws SQLException {
		
		ProductStorage productStorage = new ProductStorage();

		productStorage.setProductStockNo(rs.getString("product_stock_no"));
		productStorage.setProductId(rs.getString("product_id"));
		productStorage.setProductName(rs.getString("product_name"));
		productStorage.setIoDatetime(rs.getTimestamp("io_datetime").toString());
		productStorage.setIoAmt(rs.getInt("io_amt"));
		productStorage.setBigo(rs.getString("bigo"));
		
		return productStorage;
	}
	
}
