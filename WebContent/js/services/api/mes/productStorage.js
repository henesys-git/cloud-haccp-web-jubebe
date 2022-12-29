/**
 * 
 */
 
ProductStorage = function () {}

ProductStorage.prototype.getStockGroupByProductId = function () {
 	var stocks = $.ajax({
        type: "GET",
        url: heneServerPath + "/product-storage?id=groupByProductId",
        success: function (result) {
        	return result;
        }
    });
    
	return stocks;
}

ProductStorage.prototype.getStockGroupByStockNo = function (productId) {
 	var stocks = $.ajax({
        type: "GET",
        url: heneServerPath + "/product-storage?id=groupByStockNo"
        					+ "&productId=" + productId,
        success: function (result) {
        	return result;
        }
	});
    
	return stocks;
}

ProductStorage.prototype.getStock = function (stockNo) {
 	var stocks = $.ajax({
        type: "GET",
        url: heneServerPath + "/product-storage?id=stock"
        					+ "&stockNo=" + stockNo,
        success: function (result) {
        	return result;
        }
	});
    
	return stocks;
}

ProductStorage.prototype.ipgoChulgo = function (obj) {
 	var result = $.ajax({
        type: "GET",
        url: heneServerPath + "/product-storage?id=ipgoChulgo"
        					+ "&productStockNo=" + obj.productStockNo
        					+ "&productId=" + obj.productId
        					+ "&ioDatetime=" + obj.ioDatetime
        					+ "&ioAmt=" + obj.ioAmt
							+ "&prodResultParam=" + obj.prodResultParam
							+ "&planNo=" + obj.planNo,
        success: function (result) {
        	return result;
        }
	});
    
	return result;
}