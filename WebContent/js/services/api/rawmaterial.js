/**
 * 
 */
 
Rawmaterial = function () {}

Rawmaterial.prototype.getRawmaterialById = function () {
 	var rawmaterial = $.ajax({
        type: "GET",
        url: heneServerPath + "/rawmaterial",
        success: function (result) {
        	return result;
        }
    });
    
	return rawmaterial;
}

Rawmaterial.prototype.getRawmaterials = function () {
 	var rawmaterials = $.ajax({
        type: "GET",
        url: heneServerPath + "/rawmaterial?id=all",
        success: function (result) {
        	return result;
        }
	});
    
	return rawmaterials;
}