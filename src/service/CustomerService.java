package service;

import java.sql.Connection;
import java.util.List;

import org.apache.log4j.Logger;

import dao.CustomerDao;
import mes.frame.database.JDBCConnectionPool;
import model.Customer;
import viewmodel.CustomerViewModel;

public class CustomerService {

	private CustomerDao customerDao;
	private String bizNo;
	private Connection conn;
	
	static final Logger logger = Logger.getLogger(CustomerService.class.getName());

	public CustomerService(CustomerDao customerDao, String bizNo) {
		this.customerDao = customerDao;
		this.bizNo = bizNo;
	}
	
	public List<Customer> getAllCustomers() {
		List<Customer> customerList = null;
		
		try {
			conn = JDBCConnectionPool.getTenantDB(bizNo);
			customerList = customerDao.getAllCustomers(conn);
		} catch(Exception e) {
			logger.error(e.getMessage());
		} finally {
		    try { conn.close(); } catch (Exception e) { /* Ignored */ }
		}
		
		return customerList;
	}
	
	public Customer getCustomerById(String id) {
		Customer customer = null;
		
		try {
			conn = JDBCConnectionPool.getTenantDB(bizNo);
			customer = customerDao.getCustomer(conn, id);
		} catch(Exception e) {
			logger.error(e.getMessage());
		} finally {
		    try { conn.close(); } catch (Exception e) { /* Ignored */ }
		}
		
		return customer;
	}
	
	public boolean insert(Customer customer) {
		try {
			conn = JDBCConnectionPool.getTenantDB(bizNo);
			return customerDao.insert(conn, customer);
		} catch(Exception e) {
			logger.error(e.getMessage());
		} finally {
		    try { conn.close(); } catch (Exception e) { /* Ignored */ }
		}
		
		return false;
	}
	
	public boolean update(Customer customer) {
		try {
			conn = JDBCConnectionPool.getTenantDB(bizNo);
			return customerDao.update(conn, customer);
		} catch(Exception e) {
			logger.error(e.getMessage());
		} finally {
		    try { conn.close(); } catch (Exception e) { /* Ignored */ }
		}
		
		return false;
	}
	
	public boolean delete(String customerId) {
		try {
			conn = JDBCConnectionPool.getTenantDB(bizNo);
			return customerDao.delete(conn, customerId);
		} catch(Exception e) {
			logger.error(e.getMessage());
		} finally {
		    try { conn.close(); } catch (Exception e) { /* Ignored */ }
		}
		
		return false;
	}
	
	public List<CustomerViewModel> getAllCustomersViewModel() {
		List<CustomerViewModel> customerList = null;
		
		try {
			conn = JDBCConnectionPool.getTenantDB(bizNo);
			customerList = customerDao.getAllCustomerViewModels(conn);
		} catch(Exception e) {
			logger.error(e.getMessage());
		} finally {
		    try { conn.close(); } catch (Exception e) { /* Ignored */ }
		}
		
		return customerList;
	}
	
	public Customer getCustomerByNm(String nm) {
		Customer customer = null;
		
		try {
			conn = JDBCConnectionPool.getTenantDB(bizNo);
			customer = customerDao.getCustomerByNm(conn, nm);
		} catch(Exception e) {
			logger.error(e.getMessage());
		} finally {
		    try { conn.close(); } catch (Exception e) { /* Ignored */ }
		}
		
		return customer;
	}
}
