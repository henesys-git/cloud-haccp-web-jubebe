package newest.mes.dao;

import java.sql.Connection;
import java.util.List;

import org.json.simple.JSONArray;

import newest.mes.model.Order;
import newest.mes.model.ProductionPlan;
import newest.mes.model.ProductionResult;

public interface ProductionResultDao {
	public List<ProductionResult> getAllResults(Connection conn);
	public List<Order> getOrderDetails(Connection conn, String orderNo);
	public Order getOrder(Connection conn, String id);
	public boolean insert(Connection conn, ProductionPlan plan);
	public boolean packingUpdate(Connection conn, String packingCount, String planNo);
	public boolean delete(Connection conn, String planNo);
}