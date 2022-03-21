package service;

import java.sql.Connection;
import java.util.List;

import org.apache.log4j.Logger;

import dao.ItemListDao;
import dao.ProductDao;
import mes.frame.database.JDBCConnectionPool;
import model.ItemList;
import model.Product;

public class ItemListService {

	private ItemListDao itemListDao;
	private String bizNo;
	private Connection conn;
	
	static final Logger logger = Logger.getLogger(ItemListService.class.getName());

	public ItemListService(ItemListDao itemListDao, String bizNo) {
		this.itemListDao = itemListDao;
		this.bizNo = bizNo;
	}
	
	public List<ItemList> getSensorList(String type_cd) {
		List<ItemList> itemList = null;
		
		try {
			conn = JDBCConnectionPool.getTenantDB(bizNo);
			itemList = itemListDao.getSensorList(conn, type_cd);
		} catch(Exception e) {
			logger.error(e.getMessage());
		} finally {
		    try { conn.close(); } catch (Exception e) { /* Ignored */ }
		}
		
		return itemList;
	}
	
	
}
