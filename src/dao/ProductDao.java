package dao;

import java.sql.Connection;
import java.util.List;

import model.Product;
import viewmodel.ProductViewModel;

public interface ProductDao {
	public List<Product> getAllProducts(Connection conn);
	public Product getProduct(Connection conn, String id);
	public boolean insert(Connection conn, Product product);
	public boolean update(Connection conn, Product product);
	public boolean delete(Connection conn, String id);
	public List<ProductViewModel> getAllProductsViewModel(Connection conn);
	public List<ProductViewModel> getAllProductTypeViewModel(Connection conn);
}