/**
 * 
 */
 
RawmaterialStorage = function () {}

RawmaterialStorage.prototype.getStockGroupByRawmaterialId = function () {
 	var stocks = $.ajax({
        type: "GET",
        url: heneServerPath + "/rawmaterial-storage?id=groupByRawmaterialId",
        success: function (result) {
        	return result;
        }
    });
    
	return stocks;
}

RawmaterialStorage.prototype.getStockGroupByStockNo = function (rawmaterialId) {
 	var stocks = $.ajax({
        type: "GET",
        url: heneServerPath + "/rawmaterial-storage?id=groupByStockNo"
        					+ "&rawmaterialId=" + rawmaterialId,
        success: function (result) {
        	return result;
        }
	});
    
	return stocks;
}

RawmaterialStorage.prototype.getStock = function (stockNo) {
 	var stocks = $.ajax({
        type: "GET",
        url: heneServerPath + "/rawmaterial-storage?id=stock"
        					+ "&stockNo=" + stockNo,
        success: function (result) {
        	return result;
        }
	});
    
	return stocks;
}

RawmaterialStorage.prototype.ipgoChulgo = function (obj) {
 	var result = $.ajax({
        type: "GET",
        url: heneServerPath + "/rawmaterial-storage?id=ipgoChulgo"
        					+ "&rawmaterialStockNo=" + obj.rawmaterialStockNo
        					+ "&rawmaterialId=" + obj.rawmaterialId
        					+ "&ioDatetime=" + obj.ioDatetime
        					+ "&ioAmt=" + obj.ioAmt,
        success: function (result) {
        	return result;
        }
	});
    
	return result;
}