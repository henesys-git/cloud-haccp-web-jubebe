package shm.service;

import java.io.BufferedReader;
import java.io.InputStreamReader;
import java.sql.Connection;

import org.apache.http.HttpResponse;
import org.apache.http.client.methods.HttpPost;
import org.apache.http.entity.StringEntity;
import org.apache.http.impl.client.CloseableHttpClient;
import org.apache.http.impl.client.HttpClients;
import org.apache.log4j.Logger;
import org.json.JSONObject;

import mes.frame.database.JDBCConnectionPool;
import shm.dao.SsfKPIDao;

public class SsfApiService {

	private SsfKPIDao ssfKpiDao;
	private String bizNo;
	private Connection conn;
	
	static final Logger logger = Logger.getLogger(SsfApiService.class.getName());
	
	public SsfApiService(String bizNo, SsfKPIDao ssfKpiDao) {
		this.bizNo = bizNo;
		this.ssfKpiDao = ssfKpiDao;
	}
	
	public JSONObject sendKpiToSsf(JSONObject jsonObj) {
		
		try {
			conn = JDBCConnectionPool.getTenantDB(bizNo);
			
			CloseableHttpClient httpclient = HttpClients.createDefault();

			try {
            	HttpPost httpPost = new HttpPost("http://www.ssf-kpi.kr:8080/kpiLv2/kpiLv2Insert");
            	
            	StringEntity entity = new StringEntity(jsonObj.toString(), "UTF-8");
            	httpPost.setEntity(entity);
            	httpPost.setHeader("Accept", "application/json");
            	httpPost.setHeader("Content-type", "application/json");
				HttpResponse res = httpclient.execute(httpPost);
				
				BufferedReader b = new BufferedReader(new InputStreamReader(res.getEntity().getContent(), "UTF-8"));
				String rsltStr = b.readLine();
				b.close();
				
				JSONObject rsltObj = new JSONObject(rsltStr);
				logger.debug("[생산성본부 API] 전송 결과: " + rsltObj.toString());

				return rsltObj;
	        } finally {
	            httpclient.close();
	        }
		} catch(Exception e) {
			logger.error(e.getMessage());
		} finally {
		    try { conn.close(); } catch (Exception e) { /* Ignored */ }
		}
		
		return null;
	}
	
	public void updateSsfSentYn(String sensorKey, String yn) {
		try {
			conn = JDBCConnectionPool.getTenantDB(bizNo);
			ssfKpiDao.updateSsfSentYn(conn, sensorKey, yn);
		} catch(Exception e) {
			logger.error(e.getMessage());
		} finally {
		    try { conn.close(); } catch (Exception e) { /* Ignored */ }
		}
	}
}
