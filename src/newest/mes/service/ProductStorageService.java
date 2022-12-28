package newest.mes.service;

import java.sql.Connection;
import java.sql.Timestamp;
import java.text.SimpleDateFormat;
import java.util.List;

import org.apache.log4j.Logger;

import mes.frame.database.JDBCConnectionPool;
import newest.mes.dao.ProductStorageDao;
import newest.mes.model.ProductStorage;
import utils.StockNoGenerator;

public class ProductStorageService {

	private ProductStorageDao productStorageDao;
	private String bizNo;
	private Connection conn;
	
	static final Logger logger = Logger.getLogger(ProductStorageService.class.getName());

	public ProductStorageService(ProductStorageDao productStorageDao, String bizNo) {
		this.productStorageDao = productStorageDao;
		this.bizNo = bizNo;
	}
	
	public ProductStorageService(Connection conn, ProductStorageDao productStorageDao, String bizNo) {
		this.conn = conn;
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
	
	public List<ProductStorage> getStockGroupByStockNoSortByIoDatetime(String productId) {
		List<ProductStorage> productStorageList = null;
		
		try {
			conn = JDBCConnectionPool.getTenantDB(bizNo);
			productStorageList = productStorageDao.getStockGroupByStockNoSortByIoDatetime(conn, productId);
		} catch(Exception e) {
			logger.error(e.getMessage());
		} finally {
		    try { conn.close(); } catch (Exception e) { /* Ignored */ }
		}
		
		return productStorageList;
	}
	
	public List<ProductStorage> getStockGroupByStockNoSortByIoDatetime(Connection conn, String productId) {
		List<ProductStorage> productStorageList = null;
		
		try {
			conn = JDBCConnectionPool.getTenantDB(bizNo);
			productStorageList = productStorageDao.getStockGroupByStockNoSortByIoDatetime(conn, productId);
		} catch(Exception e) {
			logger.error(e.getMessage());
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
				storage.setProductStockNo(StockNoGenerator.generate());
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

	public boolean ipgoChulgo(Connection conn, 
			String productStockNo, 
			String productId, 
			String ioDatetime, 
			int ioAmt,
			String bigo) {
		try {
			ProductStorage storage = new ProductStorage();
			if(productStockNo.equals("")) {
				storage.setProductStockNo(StockNoGenerator.generate());
			} else {
				storage.setProductStockNo(productStockNo);
			}
			storage.setProductId(productId);
			storage.setIoDatetime(ioDatetime);
			storage.setIoAmt(ioAmt);
			storage.setBigo(bigo);
			
			return productStorageDao.ipgoChulgo(conn, storage);
		} catch(Exception e) {
			logger.error(e.getMessage());
		}
		
		return false;
	};

	public String chulha(String productId, int ioAmt) {
		SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
		Timestamp timestamp = new Timestamp(System.currentTimeMillis());
		String ioDatetime = sdf.format(timestamp);
		String productName = "";
		
		try {
			// product id에 맞는 재고 불러옴
			List<ProductStorage> prodList = getStockGroupByStockNoSortByIoDatetime(this.conn, productId);
			productName = prodList.get(0).getProductName();
			
			// ioAmt만큼 재고 차감
			int leftIoAmt = ioAmt;
			for(int i=0; i<prodList.size(); i++) {
				ProductStorage prodStock = prodList.get(i);
				String stockNo = prodStock.getProductStockNo();
				int curStock = prodStock.getIoAmt();
				
				if(curStock <= 0) {
					continue;
				}
				
				if(curStock >= ioAmt) {
					ipgoChulgo(this.conn, stockNo, productId, ioDatetime, ioAmt*-1, "고객출하");
					leftIoAmt = 0;
				} else {
					ipgoChulgo(this.conn, stockNo, productId, ioDatetime, curStock*-1, "고객출하");
					leftIoAmt = leftIoAmt - curStock;
				}
				
				if(leftIoAmt == 0) {
					return "success";
				}
			}
			
			if(leftIoAmt > 0) {
				return productName + " 재고 부족(" + leftIoAmt + "개)";
			}
		} catch(Exception e) {
			logger.error(e.getMessage());
			return "fail";
		}
		
		return "fail";
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
