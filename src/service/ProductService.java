package service;

import java.sql.Connection;
import java.util.List;

import org.apache.log4j.Logger;

import dao.ProductDao;
import mes.frame.database.JDBCConnectionPool;
import model.Product;
import viewmodel.ProductViewModel;

public class ProductService {

	private ProductDao productDao;
	private String bizNo;
	private Connection conn;
	
	static final Logger logger = Logger.getLogger(ProductService.class.getName());

	public ProductService(ProductDao productDao, String bizNo) {
		this.productDao = productDao;
		this.bizNo = bizNo;
	}
	
	public List<Product> getAllProducts() {
		List<Product> productList = null;
		
		try {
			conn = JDBCConnectionPool.getTenantDB(bizNo);
			productList = productDao.getAllProducts(conn);
		} catch(Exception e) {
			logger.error(e.getMessage());
		} finally {
		    try { conn.close(); } catch (Exception e) { /* Ignored */ }
		}
		
		return productList;
	}
	
	public Product getProductById(String id) {
		Product product = null;
		
		try {
			conn = JDBCConnectionPool.getTenantDB(bizNo);
			product = productDao.getProduct(conn, id);
		} catch(Exception e) {
			logger.error(e.getMessage());
		} finally {
		    try { conn.close(); } catch (Exception e) { /* Ignored */ }
		}
		
		return product;
	}
	
	public Product getProductByNm(String nm) {
		Product product = null;
		
		try {
			conn = JDBCConnectionPool.getTenantDB(bizNo);
			product = productDao.getProductByNm(conn, nm);
		} catch(Exception e) {
			logger.error(e.getMessage());
		} finally {
		    try { conn.close(); } catch (Exception e) { /* Ignored */ }
		}
		
		return product;
	}
	
	public boolean insert(Product product) {
		try {
			conn = JDBCConnectionPool.getTenantDB(bizNo);
			return productDao.insert(conn, product);
		} catch(Exception e) {
			logger.error(e.getMessage());
		} finally {
		    try { conn.close(); } catch (Exception e) { /* Ignored */ }
		}
		
		return false;
	}
	
	public boolean update(Product product) {
		try {
			conn = JDBCConnectionPool.getTenantDB(bizNo);
			return productDao.update(conn, product);
		} catch(Exception e) {
			logger.error(e.getMessage());
		} finally {
		    try { conn.close(); } catch (Exception e) { /* Ignored */ }
		}
		
		return false;
	}
	
	public boolean delete(String productId) {
		try {
			conn = JDBCConnectionPool.getTenantDB(bizNo);
			return productDao.delete(conn, productId);
		} catch(Exception e) {
			logger.error(e.getMessage());
		} finally {
		    try { conn.close(); } catch (Exception e) { /* Ignored */ }
		}
		
		return false;
	}
	
	public List<ProductViewModel> getAllProductsViewModel() {
		List<ProductViewModel> productList = null;
		
		try {
			conn = JDBCConnectionPool.getTenantDB(bizNo);
			productList = productDao.getAllProductsViewModel(conn);
		} catch(Exception e) {
			logger.error(e.getMessage());
		} finally {
		    try { conn.close(); } catch (Exception e) { /* Ignored */ }
		}
		
		return productList;
	}
	
	public List<ProductViewModel> getAllProductTypeViewModel() {
		List<ProductViewModel> productList = null;
		
		try {
			conn = JDBCConnectionPool.getTenantDB(bizNo);
			productList = productDao.getAllProductTypeViewModel(conn);
		} catch(Exception e) {
			logger.error(e.getMessage());
		} finally {
		    try { conn.close(); } catch (Exception e) { /* Ignored */ }
		}
		
		return productList;
	}
}
