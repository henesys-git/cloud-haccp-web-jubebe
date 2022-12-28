package newest.mes.dao;

import java.sql.Connection;
import java.util.List;

import newest.mes.model.ProductStorage;

public interface ProductStorageDao {
	public List<ProductStorage> getStockGroupByProductId(Connection conn);
	public List<ProductStorage> getStockGroupByStockNo(Connection conn, String StockNo);
	public List<ProductStorage> getStockGroupByStockNoSortByIoDatetime(Connection conn, String StockNo);
	public List<ProductStorage> getStock(Connection conn, String stockNo);
	public boolean ipgoChulgo(Connection conn, ProductStorage productStorage);
	public boolean insert(Connection conn, ProductStorage productStorage);
	public boolean update(Connection conn, ProductStorage productStorage);
	public boolean delete(Connection conn, String productStorageNo);
}