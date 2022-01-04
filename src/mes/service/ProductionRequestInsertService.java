package mes.service;

import java.util.List;

import mes.dao.BomDao;
import mes.dao.BomDaoImpl;
import mes.dao.DailyPlanDetailDao;
import mes.dao.DailyPlanDetailDaoImpl;
import mes.dao.ProductionRequestDao;
import mes.dao.ProductionRequestDaoImpl;
import mes.dao.ProductionRequestDetailDao;
import mes.dao.ProductionRequestDetailDaoImpl;
import mes.model.Bom;

public class ProductionRequestInsertService {
	
	private DailyPlanDetailDao dailyPlanDetailDao = new DailyPlanDetailDaoImpl();
	private ProductionRequestDao productionReqDao = new ProductionRequestDaoImpl();
	private ProductionRequestDetailDao productionReqDetailDao = new ProductionRequestDetailDaoImpl();
	private BomDao bomDao = new BomDaoImpl();
	
	
//	private ProductionRequest pr;
//	private ProductionRequestDetail prd;
//	private Product product;
//	제품명
//	제조년월일
//	유통기한
//	규격
//	계획 생산량
//	수율
//	비고
	 
}