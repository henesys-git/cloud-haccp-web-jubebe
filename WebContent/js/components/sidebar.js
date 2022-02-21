/**
 * 
 */
 
Sidebar = function () {}
 
Sidebar.prototype.getMenu = function () {
 	var menu = $.ajax({
        type: "GET",
        url: heneServerPath + "/menu",
        success: function (result) {
        	return result;
        }
    });
    
	return menu;
}