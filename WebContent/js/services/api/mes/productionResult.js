/**
 * 
 */
 
ProductionResult = function () {}

ProductionResult.prototype.getProductionResults = function () {
 	var results = $.ajax({
        type: "GET",
        url: heneServerPath + "/mes-productionResult?id=all",
        success: function (result) {
        	return result;
        }
	});
    
	return results;
}

