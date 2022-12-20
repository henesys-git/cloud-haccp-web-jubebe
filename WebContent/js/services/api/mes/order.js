/**
 * 
 */
 
Order = function () {}

Order.prototype.getOrderById = function () {
 	var order = $.ajax({
        type: "GET",
        url: heneServerPath + "/mes-order",
        success: function (result) {
        	return result;
        }
    });
    
	return order;
}

Order.prototype.getOrders = function () {
 	var orders = $.ajax({
        type: "GET",
        url: heneServerPath + "/mes-order?id=all",
        success: function (result) {
        	return result;
        }
	});
    
	return orders;
}

Order.prototype.getOrderDetails = function (orderNo) {
 	var orders = $.ajax({
        type: "GET",
        url: heneServerPath + "/mes-order?id=detail" + "&orderNo=" + orderNo,
        success: function (result) {
        	return result;
        }
	});
    
	return orders;
}