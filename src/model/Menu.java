package model;

import java.util.List;

public class Menu {
	private String menuId;
	private String menuName;
	private int menuLevel;
	private String path;
	private String parentMenuId;
	private List<Menu> children;
	
	public Menu(String menuId, String menuName, int menuLevel, String path, String parentMenuId) {
		super();
		this.menuId = menuId;
		this.menuName = menuName;
		this.menuLevel = menuLevel;
		this.path = path;
		this.parentMenuId = parentMenuId;
	}

	public String getMenuId() {
		return menuId;
	}
	public String getMenuName() {
		return menuName;
	}
	public int getMenuLevel() {
		return menuLevel;
	}
	public String getPath() {
		return path;
	}
	public String getParentMenuId() {
		return parentMenuId;
	}
	public List<Menu> getChildren() {
		return children;
	}
	public void setMenuId(String menuId) {
		this.menuId = menuId;
	}
	public void setMenuName(String menuName) {
		this.menuName = menuName;
	}
	public void setMenuLevel(int menuLevel) {
		this.menuLevel = menuLevel;
	}
	public void setPath(String path) {
		this.path = path;
	}
	public void setParentMenuId(String parentMenuId) {
		this.parentMenuId = parentMenuId;
	}
	public void setChildren(List<Menu> children) {
		this.children = children;
	}

	@Override
	public String toString() {
		return "Menu [menuId=" + menuId + ", menuName=" + menuName + ", menuLevel=" + menuLevel + ", path=" + path
				+ ", parentMenuId=" + parentMenuId + ", children=" + children + "]";
	}
}
