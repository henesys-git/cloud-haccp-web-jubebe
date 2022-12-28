/**
 * 
 */
 
ProductionPlan = function () {}

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

