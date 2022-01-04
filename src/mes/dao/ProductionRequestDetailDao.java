package mes.dao;

import java.sql.Connection;
import java.util.List;

import mes.model.ProductionRequestDetail;

public interface ProductionRequestDetailDao {
	public List<ProductionRequestDetail> getAllProductionRequestDetails(Connection conn);
	public ProductionRequestDetail getProductionRequestDetail(Connection conn, String manufacturingDate, 
														String planDate, String prodCd, String partCd);
	public boolean saveProductionRequestDetail(Connection conn, ProductionRequestDetail productionRequestDetail);
	public boolean updateProductionRequestDetail(Connection conn, ProductionRequestDetail productionRequestDetail);
	public boolean deleteProductionRequestDetail(Connection conn, ProductionRequestDetail productionRequestDetail);
}