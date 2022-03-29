package service;

import java.sql.Connection;
import java.util.List;

import org.apache.log4j.Logger;

import dao.MenuDao;
import mes.frame.database.JDBCConnectionPool;
import model.Menu;

public class MenuService {
	
	private MenuDao menuDao;
	private String tenantId;
	private Connection conn;
	
	static final Logger logger = Logger.getLogger(MenuService.class.getName());
	
    public MenuService(MenuDao menuDao, String tenantId) {
    	this.menuDao = menuDao;
    	this.tenantId = tenantId;
    }
    
    public List<Menu> getMenu() {
    	List<Menu> menuList = null;
    	
    	try {
    		conn = JDBCConnectionPool.getTenantDB(tenantId);
    		menuList = menuDao.getMenuByTenant(conn);
    	} catch(Exception e) {
    		logger.error(e.getMessage());
		} finally {
		    try { conn.close(); } catch (Exception e) { /* Ignored */ }
		}
    	
    	return menuList;
    }
    
    public List<Menu> getAllMenu() {
    	List<Menu> menuList = null;
    	
    	try {
    		conn = JDBCConnectionPool.getTenantDB(tenantId);
    		menuList = menuDao.getAllMenu(conn);
    	} catch(Exception e) {
    		logger.error(e.getMessage());
		} finally {
		    try { conn.close(); } catch (Exception e) { /* Ignored */ }
		}
    	
    	return menuList;
    }
    
    public Menu getMaxMenuId() {
    	Menu menu = null;
    	
    	try {
			conn = JDBCConnectionPool.getTenantDB(tenantId);
			menu = menuDao.getMaxMenuId(conn);
		} catch(Exception e) {
			logger.error(e.getMessage());
		} finally {
		    try { conn.close(); } catch (Exception e) { /* Ignored */ }
		}
		
		return menu;
    	
    }
    
    public boolean insert(Menu menu) {
		try {
			conn = JDBCConnectionPool.getTenantDB(tenantId);
			return menuDao.insert(conn, menu);
		} catch(Exception e) {
			logger.error(e.getMessage());
		} finally {
		    try { conn.close(); } catch (Exception e) { /* Ignored */ }
		}
		
		return false;
	}
	
	public boolean update(Menu menu) {
		try {
			conn = JDBCConnectionPool.getTenantDB(tenantId);
			return menuDao.update(conn, menu);
		} catch(Exception e) {
			logger.error(e.getMessage());
		} finally {
		    try { conn.close(); } catch (Exception e) { /* Ignored */ }
		}
		
		return false;
	}
	
	public boolean delete(String menuId) {
		try {
			conn = JDBCConnectionPool.getTenantDB(tenantId);
			return menuDao.delete(conn, menuId);
		} catch(Exception e) {
			logger.error(e.getMessage());
		} finally {
		    try { conn.close(); } catch (Exception e) { /* Ignored */ }
		}
		
		return false;
	}
}