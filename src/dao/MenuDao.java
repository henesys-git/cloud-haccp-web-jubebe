package dao;

import java.sql.Connection;
import java.util.List;

import model.Menu;

public interface MenuDao {
	public List<Menu> getMenuByTenant(Connection conn);
	public List<Menu> getAllMenu(Connection conn);
	public boolean insert(Connection conn, Menu menu);
	public boolean update(Connection conn, Menu menu);
	public boolean delete(Connection conn, String menuId);
	public Menu getMaxMenuId(Connection conn);
}
