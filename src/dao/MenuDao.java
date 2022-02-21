package dao;

import java.sql.Connection;
import java.util.List;

import model.Menu;

public interface MenuDao {
	public List<Menu> getMenuByTenant(Connection conn);
}
