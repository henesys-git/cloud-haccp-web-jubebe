package newest.mes.dao;

import java.sql.Connection;
import java.util.List;

import newest.mes.model.RawmaterialStorage;

public interface RawmaterialStorageDao {
	public List<RawmaterialStorage> getStockGroupByRawmaterialId(Connection conn);
	public List<RawmaterialStorage> getStockGroupByStockNo(Connection conn, String StockNo);
	public List<RawmaterialStorage> getStock(Connection conn, String stockNo);
	public boolean ipgoChulgo(Connection conn, RawmaterialStorage rawmaterialStorage);
	public boolean insert(Connection conn, RawmaterialStorage rawmaterialStorage);
	public boolean update(Connection conn, RawmaterialStorage rawmaterialStorage);
	public boolean delete(Connection conn, String rawmaterialStorageNo);
}