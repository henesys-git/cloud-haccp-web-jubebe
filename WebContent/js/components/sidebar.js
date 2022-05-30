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

Sidebar.prototype.generateMenu = function (menus) {

	var _generateLiElement = function (tree, menus) {
		
		var ul = document.createElement('ul');
		tree.appendChild(ul);
		
		for (let menu of menus) {
			var li = document.createElement('li');
			
			var a = document.createElement('a');
			a.setAttribute('href', '#');
			a.setAttribute('class', 'nav-link');
			
			var i = document.createElement('i');
			i.setAttribute('class', 'far fa-circle nav-icon');
			
			var p = document.createElement('p');
			p.appendChild(document.createTextNode(menu.menuName));
			
			a.appendChild(i);
			a.appendChild(p);
			li.appendChild(a);
			
			// if menu has children, recursion
			// else add onclick event
			if(menu.children.length > 0) {
				li.setAttribute('class', 'nav-item has-treeview');
				
				var i = document.createElement('i');
				i.setAttribute('class', 'right fas fa-angle-left');
				p.appendChild(i);
				
				_generateLiElement(li, menu.children);
				
			} else {
				li.setAttribute('class', 'nav-item');
				li.setAttribute("onclick", "return fn_MainSubMenuSelected(this,'" + menu.path + "', '', '', '');");
			}
			
			ul.appendChild(li);
		}
	}
	
	var tree = document.createDocumentFragment();
	_generateLiElement(tree, menus);
	
	document.getElementById('sidebar-nav-id').appendChild(tree);
	var uls = document.getElementById('sidebar-nav-id').getElementsByTagName('ul');
	
	for(let i=0; i<uls.length; i++) {
		let ul = uls[i];
	
		if(i === 0) {
			ul.setAttribute('id', 'menu-parent-ul');
			ul.setAttribute('class', 'nav nav-pills nav-sidebar nav-child-indent flex-column');
			ul.setAttribute('data-widget', 'treeview');
			ul.setAttribute('role', 'menu');
			ul.setAttribute('data-accordion', 'true');
		} else {
			ul.setAttribute('class', 'nav-item nav-treeview');
		}
	}
}