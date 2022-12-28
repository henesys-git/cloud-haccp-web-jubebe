package newest.mes.service;

import java.sql.Connection;
import java.util.List;

import org.apache.log4j.Logger;
import org.json.JSONArray;
import org.json.JSONObject;

import mes.frame.database.JDBCConnectionPool;
import newest.mes.dao.ChulhaDao;
import newest.mes.dao.OrderDaoImpl;
import newest.mes.dao.ProductStorageDaoImpl;
import newest.mes.model.ChulhaInfo;
import newest.mes.model.ChulhaInfoDetail;
import newest.mes.model.Order;
import newest.mes.viewmodel.ChulhaInfoViewModel;

public class ChulhaService {
	private ChulhaDao chulhaDao;
	private String bizNo;
	private Connection conn;
	
	static final Logger logger = Logger.getLogger(ChulhaService.class.getName());

	public ChulhaService(ChulhaDao chulhaDao, String bizNo) {
		this.chulhaDao = chulhaDao;
		this.bizNo = bizNo;
	}
	
	public List<ChulhaInfoViewModel> getChulhaInfo() {
		List<ChulhaInfoViewModel> chulhaList = null;
		
		try {
			conn = JDBCConnectionPool.getTenantDB(bizNo);
			chulhaList = chulhaDao.getChulhaInfo(conn);
		} catch(Exception e) {
			logger.error(e.getMessage());
		} finally {
		    try { conn.close(); } catch (Exception e) { /* Ignored */ }
		}
		
		return chulhaList;
	}

	public List<ChulhaInfoViewModel> getChulhaInfoDetail(String chulhaNo) {
		List<ChulhaInfoViewModel> chulhaList = null;
		
		try {
			conn = JDBCConnectionPool.getTenantDB(bizNo);
			chulhaList = chulhaDao.getChulhaInfoDetail(conn, chulhaNo);
		} catch(Exception e) {
			logger.error(e.getMessage());
		} finally {
			try { conn.close(); } catch (Exception e) { /* Ignored */ }
		}
		
		return chulhaList;
	}
	
	public boolean chulha(JSONObject obj) {
		try {
			conn = JDBCConnectionPool.getTenantDB(bizNo);
			conn.setAutoCommit(false);
			boolean inserted = false;
			OrderService orderService = new OrderService(new OrderDaoImpl(), this.bizNo);
			ProductStorageService psService = new ProductStorageService(conn, new ProductStorageDaoImpl(), this.bizNo);
			
			// 출하 메인 데이터 insert
			ChulhaInfo ci = new ChulhaInfo(obj.get("chulhaNo").toString(),
										   obj.get("chulhaDate").toString(),
										   obj.get("customerCode").toString());
			JSONArray detailList = (JSONArray) obj.get("detail");
			
			inserted = chulhaDao.insert(conn, ci);
			if(!inserted) {
				conn.rollback();
				return false;
			}
			
			for(int i=0; i<detailList.length(); i++) {
				// 출하 상세 데이터 insert
				JSONObject cidJson = (JSONObject) detailList.get(i);
				ChulhaInfoDetail cid = new ChulhaInfoDetail(
												cidJson.get("chulhaNo").toString(),
												cidJson.get("productId").toString(),
												cidJson.get("chulhaCount").toString()
											);
				inserted = chulhaDao.insert(conn, cid);
				if(!inserted) {
					conn.rollback();
					return false;
				}
				
				// 주문 상세 테이블 출하여부 update
				Order order = new Order(cidJson.get("orderNo").toString(),
										cidJson.get("orderDetailNo").toString());
				
				boolean chulhaChangeToY = orderService.chulha(order);
				if(!chulhaChangeToY) {
					conn.rollback();
					return false;
				}
				
				boolean chulha = psService.chulha(
										cidJson.get("productId").toString(),
										Integer.parseInt(cidJson.get("chulhaCount").toString()));
				if(!chulha) {
					conn.rollback();
					return false;
				}
			}
			
			conn.commit();
			return true;
		} catch(Exception e) {
			logger.error(e.getMessage());
		} finally {
		    try { conn.close(); } catch (Exception e) { /* Ignored */ }
		}
		
		return false;
	}
	
	public boolean update(ChulhaInfo ci, List<ChulhaInfoDetail> detailList) {
		try {
			conn = JDBCConnectionPool.getTenantDB(bizNo);
			conn.setAutoCommit(false);
			
			boolean updated = false;
			updated = chulhaDao.update(conn, ci);
			if(!updated) {
				conn.rollback();
				return false;
			}
			
			for(ChulhaInfoDetail cid : detailList) {
				updated = chulhaDao.update(conn, cid);
				if(!updated) {
					conn.rollback();
					return false;
				}
			}
			
			conn.commit();
			return true;
		} catch(Exception e) {
			logger.error(e.getMessage());
		} finally {
		    try { conn.close(); } catch (Exception e) { /* Ignored */ }
		}
		
		return false;
	}
	
	public boolean delete(String chulhaNo) {
		
		return false;
	}
}
