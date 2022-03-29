/**
 * 
 */

if(!HENESYS_API) {
	var HENESYS_API = {}
}

HENESYS_API.menu = function () {}

HENESYS_API.menu.prototype.getMenus = function () {
 	var menus = $.ajax({
        type: "GET",
        url: heneServerPath + "/menu?id=all",
        success: function (result) {
        	return result;
        }
	});
    
	return menus;
}

HENESYS_API.menu.prototype.getMaxMenuId = function () {
 	var menus = $.ajax({
        type: "GET",
        url: heneServerPath + "/menu?id=max",
		async : false,
        success: function (result) {
        	return result;
        }
	});
    
	return menus;
}