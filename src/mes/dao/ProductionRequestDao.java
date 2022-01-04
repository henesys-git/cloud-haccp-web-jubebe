package mes.dao;

import java.sql.Connection;
import java.util.List;

import mes.model.ProductionRequest;

public interface ProductionRequestDao {
	public List<ProductionRequest> getAllProductionRequests(Connection conn);
	public ProductionRequest getProductionRequest(Connection conn, String manufacturingDate, String planDate, String prodCd);
	public boolean saveProductionRequest(Connection conn, ProductionRequest productionRequest);
	public boolean updateProductionRequest(Connection conn, ProductionRequest productionRequest);
	public boolean deleteProductionRequest(Connection conn, ProductionRequest productionRequest);
}