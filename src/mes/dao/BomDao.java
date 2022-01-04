package mes.dao;

import java.sql.Connection;
import java.util.List;

import mes.model.Bom;

public interface BomDao {
	public List<Bom> getAllBoms(Connection conn);
	public List<Bom> getAllBomsForProduct(Connection conn, String prodCd);
	public Bom getBom(Connection conn, String prodCd, String partCd);
	public boolean updateBom(Connection conn, Bom Bom);
	public boolean deleteBom(Connection conn, Bom Bom);
}