/**
 * 
 */
 
Customer = function () {}

Customer.prototype.getCustomerById = function () {
 	var customer = $.ajax({
        type: "GET",
        url: heneServerPath + "/customer",
        success: function (result) {
        	return result;
        }
    });
    
	return customer;
}

Customer.prototype.getCustomers = function () {
 	var customers = $.ajax({
        type: "GET",
        url: heneServerPath + "/customer?id=all",
        success: function (result) {
        	return result;
        }
	});
    
	return customers;
}