package newest.mes.dao;

import java.sql.Connection;
import java.util.List;

import org.json.simple.JSONArray;

import newest.mes.model.Order;
import newest.mes.model.ProductionPlan;

public interface ProductionPlanDao {
	public List<ProductionPlan> getAllPlans(Connection conn);
	public List<Order> getOrderDetails(Connection conn, String orderNo);
	public Order getOrder(Connection conn, String id);
	public boolean insert(Connection conn, ProductionPlan plan);
	public boolean update(Connection conn, ProductionPlan plan);
	public boolean delete(Connection conn, String planNo);
	public boolean instructionInsert(Connection conn, String instructionDate, String productId, String planNo, String instructionCount, String lotNo);
}