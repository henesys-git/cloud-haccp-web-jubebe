/**
 * 
 */
 
ProductionPlan = function () {}

ProductionPlan.prototype.getOrderById = function () {
 	var order = $.ajax({
        type: "GET",
        url: heneServerPath + "/mes-order",
        success: function (result) {
        	return result;
        }
    });
    
	return order;
}

ProductionPlan.prototype.getProductionPlans = function () {
 	var plans = $.ajax({
        type: "GET",
        url: heneServerPath + "/mes-productionPlan?id=all",
        success: function (result) {
        	return result;
        }
	});
    
	return plans;
}

ProductionPlan.prototype.getOrderDetails = function (orderNo) {
 	var orders = $.ajax({
        type: "GET",
        url: heneServerPath + "/mes-order?id=detail" + "&orderNo=" + orderNo,
        success: function (result) {
        	return result;
        }
	});
    
	return orders;
}