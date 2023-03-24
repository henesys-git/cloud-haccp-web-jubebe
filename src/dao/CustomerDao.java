package dao;

import java.sql.Connection;
import java.util.List;

import model.Customer;
import viewmodel.CustomerViewModel;

public interface CustomerDao {
	public List<Customer> getAllCustomers(Connection conn);
	public Customer getCustomer(Connection conn, String id);
	public boolean insert(Connection conn, Customer rawmaterial);
	public boolean update(Connection conn, Customer rawmaterial);
	public boolean delete(Connection conn, String id);
	public List<CustomerViewModel> getAllCustomerViewModels(Connection conn);
	public Customer getCustomerByNm(Connection conn, String customerNm);
}