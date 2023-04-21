package newest.mes.dao;

import java.sql.Connection;
import java.util.List;

import org.json.simple.JSONArray;

import newest.mes.model.Order;

public interface OrderDao {
	public List<Order> getAllOrders(Connection conn);
	public List<Order> getAllOrdersNoChulhaYet(Connection conn);
	public List<Order> getOrderDetails(Connection conn, String orderNo);
	public List<Order> getOrderDetailsNoChulhaYet(Connection conn, String orderNo);
	public List<Order> getOrderInfos(Connection conn);
	public Order getOrder(Connection conn, String id);
	public boolean insert(Connection conn, Order order, JSONArray param);
	public boolean update(Connection conn, Order order);
	public boolean delete(Connection conn, String OrderNo);
	public boolean chulha(Connection conn, Order order);
	public boolean excelInsert(Connection conn, Order order, JSONArray param);
}