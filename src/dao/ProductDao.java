package dao;

import java.sql.Connection;
import java.util.List;

import model.Product;

public interface ProductDao {
	public List<Product> getAllProducts(Connection conn);
	public Product getProduct(Connection conn, String id);
	public boolean insert(Connection conn, Product product);
	public boolean update(Connection conn, Product product);
	public boolean delete(Connection conn, String id);
}