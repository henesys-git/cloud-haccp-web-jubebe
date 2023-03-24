package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;

import org.apache.log4j.Logger;

import mes.frame.database.JDBCConnectionPool;
import model.Customer;
import viewmodel.CustomerViewModel;

public class CustomerDaoImpl implements CustomerDao {
	
	private Statement stmt;
	private ResultSet rs;
	
	static final Logger logger = 
			Logger.getLogger(CustomerDaoImpl.class.getName());
	
	public CustomerDaoImpl() {
	}

	@Override
	public List<Customer> getAllCustomers(Connection conn) {
		
		try {
			stmt = conn.createStatement();
			
			String sql = new StringBuilder()
				.append("SELECT * 			\n")
				.append("FROM mes_product_customer	\n")
				.append("WHERE tenant_id = '" + JDBCConnectionPool.getTenantId(conn) + "'\n")
				.toString();
			
			logger.debug("sql:\n" + sql);
			
			rs = stmt.executeQuery(sql);
			
			List<Customer> list = new ArrayList<Customer>();
			
			while(rs.next()) {
				Customer data = extractFromResultSet(rs);
				list.add(data);
			}
			
			return list;
			
		} catch (SQLException ex) {
			ex.printStackTrace();
		} finally {
		    try { rs.close(); } catch (Exception e) { /* Ignored */ }
		    try { stmt.close(); } catch (Exception e) { /* Ignored */ }
		}
		
		return null;
	};
	
	@Override
	public Customer getCustomer(Connection conn, String customerId) {
		
		try {
			stmt = conn.createStatement();
			
			String sql = new StringBuilder()
				.append("SELECT * 		\n")
				.append("FROM mes_product_customer	\n")
				.append("WHERE tenant_id = '" + JDBCConnectionPool.getTenantId(conn) + "'\n")
				.append("  AND customer_code = '" + customerId + "'\n")
				.toString();
			
			logger.debug("sql:\n" + sql);
			
			rs = stmt.executeQuery(sql);
			
			Customer customer = null;
			
			if(rs.next()) {
				customer = extractFromResultSet(rs);
			}
			
			return customer;
		} catch (SQLException ex) {
			ex.printStackTrace();
		} finally {
		    try { rs.close(); } catch (Exception e) { /* Ignored */ }
		    try { stmt.close(); } catch (Exception e) { /* Ignored */ }
		}
		
		return null;
	};
	
	@Override
	public boolean insert(Connection conn, Customer customer) {
		try {
			String sql = new StringBuilder()
					.append("INSERT INTO\n")
					.append("	mes_product_customer (\n")
					.append("		tenant_id,\n")
					.append("		customer_code,\n")
					.append("		customer_name\n")
					.append("	)\n")
					.append("VALUES\n")
					.append("	(\n")
					.append("		?,\n")
					.append("		?,\n")
					.append("		?\n")
					.append("	);\n")
					.toString();

			PreparedStatement ps = conn.prepareStatement(sql);
			
			ps.setString(1, JDBCConnectionPool.getTenantId(conn));
			ps.setString(2, customer.getCustomerId());
			ps.setString(3, customer.getCustomerName());
			
	        int i = ps.executeUpdate();

	        if(i == 1) {
	        	return true;
	        }

	    } catch (SQLException ex) {
	        ex.printStackTrace();
	    }

	    return false;
	}
	
	@Override
	public boolean update(Connection conn, Customer customer) {
		try {
			stmt = conn.createStatement();
			
			String sql = new StringBuilder()
					.append("UPDATE mes_product_customer\n")
					.append("SET customer_name='" + customer.getCustomerName() + "'\n")
					.append("WHERE tenant_id='" + JDBCConnectionPool.getTenantId(conn) + "'\n")
					.append("  AND customer_code='" + customer.getCustomerId() + "';\n")
					.toString();
			
			logger.debug("sql:\n" + sql);
			
	        int i = stmt.executeUpdate(sql);

	        if(i == 1) {
	        	return true;
	        }

	    } catch (SQLException ex) {
	        ex.printStackTrace();
	    }

	    return false;
	}
	
	@Override
	public boolean delete(Connection conn, String customerId) {
		try {
			stmt = conn.createStatement();
			
			String sql = new StringBuilder()
					.append("DELETE FROM mes_product_customer\n")
					.append("WHERE tenant_id='" + JDBCConnectionPool.getTenantId(conn) + "'\n")
					.append("	AND customer_code='" + customerId + "';\n")
					.toString();
			
			logger.debug("sql:\n" + sql);
			
			int i = stmt.executeUpdate(sql);

	        if(i == 1) {
	        	return true;
	        }

	    } catch (SQLException ex) {
	        ex.printStackTrace();
	    }

	    return false;
	}
	
	@Override
	public List<CustomerViewModel> getAllCustomerViewModels(Connection conn) {
		
		try {
			stmt = conn.createStatement();
			
			String sql = new StringBuilder()
				.append("SELECT  									\n")
				.append("	c1.customer_code, 						\n")
				.append("	c2.customer_name AS customer_type,		\n")
				.append("	c1.customer_name						\n")
				.append("FROM mes_product_customer c1				\n")
				.append("INNER JOIN mes_product_customer c2			\n")
				.append("	ON c1.parent_id = c2.customer_code		\n")
				.append("WHERE c1.tenant_id = '" + JDBCConnectionPool.getTenantId(conn) + "'\n")
				.append("	AND c1.level = 1						\n")
				.toString();
			
			logger.debug("sql:\n" + sql);
			
			rs = stmt.executeQuery(sql);
			
			List<CustomerViewModel> list = new ArrayList<CustomerViewModel>();
			
			while(rs.next()) {
				CustomerViewModel data = extractViewModelFromResultSet(rs);
				list.add(data);
			}
			
			return list;
			
		} catch (SQLException ex) {
			ex.printStackTrace();
		} finally {
		    try { rs.close(); } catch (Exception e) { /* Ignored */ }
		    try { stmt.close(); } catch (Exception e) { /* Ignored */ }
		}
		
		return null;
	};
	
	@Override
	public Customer getCustomerByNm(Connection conn, String customerNm) {
		
		try {
			stmt = conn.createStatement();
			
			String sql = new StringBuilder()
				.append("SELECT * 		\n")
				.append("FROM mes_product_customer	\n")
				.append("WHERE tenant_id = '" + JDBCConnectionPool.getTenantId(conn) + "'\n")
				.append("  AND customer_name = '" + customerNm + "'\n")
				.toString();
			
			logger.debug("sql:\n" + sql);
			
			rs = stmt.executeQuery(sql);
			
			Customer customer = null;
			
			if(rs.next()) {
				customer = extractFromResultSet(rs);
			}
			
			return customer;
		} catch (SQLException ex) {
			ex.printStackTrace();
		} finally {
		    try { rs.close(); } catch (Exception e) { /* Ignored */ }
		    try { stmt.close(); } catch (Exception e) { /* Ignored */ }
		}
		
		return null;
	};
	
	
	private Customer extractFromResultSet(ResultSet rs) throws SQLException {
		return new Customer(
					rs.getString("customer_code"),
					rs.getString("customer_name")
				);
	}

	private CustomerViewModel extractViewModelFromResultSet(ResultSet rs) throws SQLException {
		return new CustomerViewModel(
				rs.getString("customer_code"),
				rs.getString("customer_type"),
				rs.getString("customer_name")
			);
	}
}
