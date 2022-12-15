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
import model.Product;
import viewmodel.ProductViewModel;

public class ProductDaoImpl implements ProductDao {
	
	private Statement stmt;
	private ResultSet rs;
	
	static final Logger logger = 
			Logger.getLogger(ProductDaoImpl.class.getName());
	
	public ProductDaoImpl() {
	}

	@Override
	public List<Product> getAllProducts(Connection conn) {
		
		try {
			stmt = conn.createStatement();
			
			String sql = new StringBuilder()
				.append("SELECT * 		\n")
				.append("FROM product	\n")
				.append("WHERE tenant_id = '" + JDBCConnectionPool.getTenantId(conn) + "'\n")
				.toString();
			
			logger.debug("sql:\n" + sql);
			
			rs = stmt.executeQuery(sql);
			
			List<Product> list = new ArrayList<Product>();
			
			while(rs.next()) {
				Product data = extractFromResultSet(rs);
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
	public Product getProduct(Connection conn, String productId) {
		
		try {
			stmt = conn.createStatement();
			
			String sql = new StringBuilder()
				.append("SELECT * 		\n")
				.append("FROM product	\n")
				.append("WHERE tenant_id = '" + JDBCConnectionPool.getTenantId(conn) + "'\n")
				.append("  AND product_id = '" + productId + "'\n")
				.toString();
			
			logger.debug("sql:\n" + sql);
			
			rs = stmt.executeQuery(sql);
			
			Product product = new Product();
			
			if(rs.next()) {
				product = extractFromResultSet(rs);
			}
			
			return product;
		} catch (SQLException ex) {
			ex.printStackTrace();
		} finally {
		    try { rs.close(); } catch (Exception e) { /* Ignored */ }
		    try { stmt.close(); } catch (Exception e) { /* Ignored */ }
		}
		
		return null;
	};
	
	@Override
	public boolean insert(Connection conn, Product product) {
		try {
			String sql = new StringBuilder()
					.append("INSERT INTO\n")
					.append("	product (\n")
					.append("		tenant_id,\n")
					.append("		product_id,\n")
					.append("		product_name\n")
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
			ps.setString(2, product.getProductId());
			ps.setString(3, product.getProductName());
			
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
	public boolean update(Connection conn, Product product) {
		try {
			stmt = conn.createStatement();
			
			String sql = new StringBuilder()
					.append("UPDATE product\n")
					.append("SET product_name='" + product.getProductName() + "'\n")
					.append("WHERE tenant_id='" + JDBCConnectionPool.getTenantId(conn) + "'\n")
					.append("  AND product_id='" + product.getProductId() + "';\n")
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
	public boolean delete(Connection conn, String productId) {
		try {
			stmt = conn.createStatement();
			
			String sql = new StringBuilder()
					.append("DELETE FROM product\n")
					.append("WHERE tenant_id='" + JDBCConnectionPool.getTenantId(conn) + "'\n")
					.append("	AND product_id='" + productId + "';\n")
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
	public List<ProductViewModel> getAllProductsViewModel(Connection conn) {
		
		try {
			stmt = conn.createStatement();
			
			String sql = new StringBuilder()
				.append("SELECT  								\n")
				.append("	p1.product_id, 						\n")
				.append("	p2.product_name AS product_type, 	\n")
				.append("	p1.product_name						\n")
				.append("FROM product p1						\n")
				.append("INNER JOIN product p2					\n")
				.append("	ON p1.parent_id = p2.product_id		\n")
				.append("WHERE p1.tenant_id = '" + JDBCConnectionPool.getTenantId(conn) + "'\n")
				.append("	AND p1.product_level = 1			\n")
				.toString();
			
			logger.debug("sql:\n" + sql);
			
			rs = stmt.executeQuery(sql);
			
			List<ProductViewModel> list = new ArrayList<ProductViewModel>();
			
			while(rs.next()) {
				ProductViewModel data = extractViewModelFromResultSet(rs);
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
	
	private Product extractFromResultSet(ResultSet rs) throws SQLException {
		return new Product(
					rs.getString("product_id"),
					rs.getString("product_name")
				);
	}

	private ProductViewModel extractViewModelFromResultSet(ResultSet rs) throws SQLException {
		return new ProductViewModel(
				rs.getString("product_id"),
				rs.getString("product_type"),
				rs.getString("product_name")
				);
	}
}
