package dao;

import java.sql.Connection;
import java.util.List;

import model.ItemList;
import model.Product;

public interface ItemListDao {
	public List<ItemList> getSensorList(Connection conn, String type_cd);
	public List<ItemList> getCCPList(Connection conn, String type_cd);
}