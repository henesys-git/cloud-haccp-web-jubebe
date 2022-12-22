package newest.mes.service;

import java.sql.Connection;
import java.util.List;

import org.apache.log4j.Logger;

import mes.frame.database.JDBCConnectionPool;
import newest.mes.dao.ProductStorageDao;
import newest.mes.model.ProductStorage;
import utils.ProductStockNoGenerator;

public class ProductStorageService {

	private ProductStorageDao productStorageDao;
	private String bizNo;
	private Connection conn;
	
	static final Logger logger = Logger.getLogger(ProductStorageService.class.getName());

	public ProductStorageService(ProductStorageDao productStorageDao, String bizNo) {
		this.productStorageDao = productStorageDao;
		this.bizNo = bizNo;
	}
	
	public List<ProductStorage> getStockGroupByProductId() {
		List<ProductStorage> productStorageList = null;
		
		try {
			conn = JDBCConnectionPool.getTenantDB(bizNo);
			productStorageList = productStorageDao.getStockGroupByProductId(conn);
		} catch(Exception e) {
			logger.error(e.getMessage());
		} finally {
		    try { conn.close(); } catch (Exception e) { /* Ignored */ }
		}
		
		return productStorageList;
	}
	
	public List<ProductStorage> getStockGroupByStockNo(String productId) {
		List<ProductStorage> productStorageList = null;
		
		try {
			conn = JDBCConnectionPool.getTenantDB(bizNo);
			productStorageList = productStorageDao.getStockGroupByStockNo(conn, productId);
		} catch(Exception e) {
			logger.error(e.getMessage());
		} finally {
		    try { conn.close(); } catch (Exception e) { /* Ignored */ }
		}
		
		return productStorageList;
	}
	
	public List<ProductStorage> getStock(String stockNo) {
		List<ProductStorage> productStorageList = null;
		
		try {
			conn = JDBCConnectionPool.getTenantDB(bizNo);
			productStorageList = productStorageDao.getStock(conn, stockNo);
		} catch(Exception e) {
			logger.error(e.getMessage());
		} finally {
		    try { conn.close(); } catch (Exception e) { /* Ignored */ }
		}
		
		return productStorageList;
	}
	
	public boolean ipgoChulgo(String productStockNo, 
							  String productId, 
							  String ioDatetime, 
							  int ioAmt) {
		try {
			ProductStorage storage = new ProductStorage();
			if(productStockNo.equals("")) {
				storage.setProductStockNo(ProductStockNoGenerator.generate());
			} else {
				storage.setProductStockNo(productStockNo);
			}
			storage.setProductId(productId);
			storage.setIoDatetime(ioDatetime);
			storage.setIoAmt(ioAmt);
			
			conn = JDBCConnectionPool.getTenantDB(bizNo);
			return productStorageDao.ipgoChulgo(conn, storage);
		} catch(Exception e) {
			logger.error(e.getMessage());
		} finally {
		    try { conn.close(); } catch (Exception e) { /* Ignored */ }
		}
		
		return false;
	};
	
	public boolean insert(ProductStorage productStorage) {
		try {
			conn = JDBCConnectionPool.getTenantDB(bizNo);
			return productStorageDao.insert(conn, productStorage);
		} catch(Exception e) {
			logger.error(e.getMessage());
		} finally {
		    try { conn.close(); } catch (Exception e) { /* Ignored */ }
		}
		
		return false;
	}
	
	public boolean update(ProductStorage productStorage) {
		try {
			conn = JDBCConnectionPool.getTenantDB(bizNo);
			return productStorageDao.update(conn, productStorage);
		} catch(Exception e) {
			logger.error(e.getMessage());
		} finally {
		    try { conn.close(); } catch (Exception e) { /* Ignored */ }
		}
		
		return false;
	}
	
	public boolean delete(String productStorageNo) {
		try {
			conn = JDBCConnectionPool.getTenantDB(bizNo);
			return productStorageDao.delete(conn, productStorageNo);
		} catch(Exception e) {
			logger.error(e.getMessage());
		} finally {
		    try { conn.close(); } catch (Exception e) { /* Ignored */ }
		}
		
		return false;
	}
	
}
