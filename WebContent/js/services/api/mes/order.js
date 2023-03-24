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

Order.prototype.getOrderInfos = function () {
 	var orders = $.ajax({
        type: "GET",
        url: heneServerPath + "/mes-order?id=info",
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

Order.prototype.getOrdersNoChulhaYet = function () {
 	var orders = $.ajax({
        type: "GET",
        url: heneServerPath + "/mes-order?id=allNoChulhaYet",
        success: function (result) {
        	return result;
        }
	});
    
	return orders;
}

Order.prototype.getOrderDetailsNoChulhaYet = function (orderNo) {
 	var orders = $.ajax({
        type: "GET",
        url: heneServerPath + "/mes-order?id=detailNoChulhaYet" + "&orderNo=" + orderNo,
        success: function (result) {
        	return result;
        }
	});
    
	return orders;
}

//get Excel Order ProdCd 
Order.prototype.getOrderExcelProdcd = function (prodNm) {
 	var orders = $.ajax({
        type: "GET",
        url: heneServerPath + "/mes-order?id=getProdCd" + "&prodNm=" + prodNm,
        success: function (result) {
        	return result;
        }
	});
    
	return orders;
}

//get Excel Order CustCd 
Order.prototype.getOrderExcelCustcd = function (custNm) {
 	var orders = $.ajax({
        type: "GET",
        url: heneServerPath + "/mes-order?id=getCustCd" + "&custNm=" + custNm,
        success: function (result) {
        	return result;
        }
	});
    
	return orders;
}