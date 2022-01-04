package mes.frame.business.customer;

import java.util.List;

public interface CustomerDao {
	//public List<Customer> getAllCustomers();
	public List<Customer> getAllCustomersByType(String type);
	//public Customer getCustomer(String code, int revisionNo);
	//public void updateCustomer(Customer customer);
	//public void deleteCustomer(Customer customer);
}
