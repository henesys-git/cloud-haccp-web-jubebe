package service;

import java.sql.Connection;
import java.util.List;

import dao.MenuDao;
import mes.frame.database.JDBCConnectionPool;
import model.Menu;

public class MenuService {
	
	private MenuDao menuDao;
	private String tenantId;
	
    public MenuService(MenuDao menuDao, String tenantId) {
    	this.menuDao = menuDao;
    	this.tenantId = tenantId;
    }
    
    public List<Menu> getMenu() {
    	Connection conn = JDBCConnectionPool.getTenantDB(tenantId);
    	return menuDao.getMenuByTenant(conn);
    }
}