package mes.frame.business.customer;

import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;

import mes.frame.database.JDBCConnectionPool;

public class CustomerDaoImpl implements CustomerDao {
	
	public CustomerDaoImpl() {
	}
	
	@Override
	public List<Customer> getAllCustomersByType(String type) {
		List<Customer> customerList = new ArrayList<Customer>();
		
		Connection con = JDBCConnectionPool.getConnection();
		
		try {
			StringBuffer sb = new StringBuffer();
			String sql = sb.append("SELECT *							\n")
						   .append("FROM tbm_customer					\n")
						   .append("WHERE company_type_b = '"+type+"'	\n")
						   .append("ORDER BY cust_nm \n")
						   .toString();
			
			Statement stmt = con.createStatement();
			ResultSet rs = stmt.executeQuery(sql);
			
			while(rs.next()) {
				Customer customer = new Customer();
				
				customer.setCode( rs.getString("cust_cd") );
				customer.setRevisionNo( rs.getInt("revision_no") );
				customer.setName( rs.getString("cust_nm") );
				
				customerList.add(customer);
			}
		} catch (SQLException ex) {
			ex.printStackTrace();
		}
		
		return customerList;
	}
	
}
