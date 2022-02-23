/**
 * 
 */
 
Product = function () {}

Product.prototype.getProductById = function () {
 	var product = $.ajax({
        type: "GET",
        url: heneServerPath + "/product",
        success: function (result) {
        	return result;
        }
    });
    
	return product;
}

Product.prototype.getProducts = function () {
 	var products = $.ajax({
        type: "GET",
        url: heneServerPath + "/product?id=all",
        success: function (result) {
        	return result;
        }
	});
    
	return products;
}