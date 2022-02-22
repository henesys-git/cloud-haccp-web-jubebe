package service;

import java.sql.Connection;
import java.util.List;

import org.apache.log4j.Logger;

import dao.ProductDao;
import dao.SensorDao;
import mes.frame.database.JDBCConnectionPool;
import model.Product;
import model.Sensor;

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
	
	public boolean judgeValue(Sensor sensor, double value) {
		double min = sensor.getValueMin();
		double max = sensor.getValueMax();
		
		if( value < min || value > max ) {
			return false;
		}
		
		return true;
	}
}
