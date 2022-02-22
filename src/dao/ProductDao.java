package dao;

import java.sql.Connection;
import java.util.List;

import model.Product;

public interface ProductDao {
	public List<Product> getAllProducts(Connection conn);
	public Product getProduct(Connection conn, String sensor);
}