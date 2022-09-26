package shm.service;

import java.io.BufferedReader;
import java.io.InputStreamReader;
import java.nio.charset.Charset;
import java.sql.Connection;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.http.HttpEntity;
import org.apache.http.HttpResponse;
import org.apache.http.client.methods.HttpPost;
import org.apache.http.entity.ContentType;
import org.apache.http.entity.mime.MultipartEntityBuilder;
import org.apache.http.impl.client.CloseableHttpClient;
import org.apache.http.impl.client.HttpClients;
import org.apache.log4j.Logger;
import org.json.JSONArray;
import org.json.JSONObject;

import mes.frame.database.JDBCConnectionPool;
import shm.dao.ShmCCPDataDao;
import shm.dao.CCPDataDao;
import shm.model.C0010;
import utils.FormatTransformer;

public class ShmApiService {

	private ShmCCPDataDao shmCcpDataDao;
	private CCPDataDao ccpDataDao;
	private String bizNo;
	private Connection conn;
	
	static final Logger logger = Logger.getLogger(ShmApiService.class.getName());
	
	public ShmApiService(ShmCCPDataDao shmCcpDataDao, String bizNo) {
		this.shmCcpDataDao = shmCcpDataDao;
		this.bizNo = bizNo;
	}

	public ShmApiService(ShmCCPDataDao shmCcpDataDao, CCPDataDao ccpDataDao, String bizNo) {
		this.shmCcpDataDao = shmCcpDataDao;
		this.ccpDataDao = ccpDataDao;
		this.bizNo = bizNo;
	}
	
	public JSONObject sendCCPDataToShm(String sensorKey, String shmCcpType) {
		List<C0010> list = null;
		
		try {
			conn = JDBCConnectionPool.getTenantDB(bizNo);
			list = shmCcpDataDao.getCCPData(conn, sensorKey);
			JSONArray jsonArr = FormatTransformer.toJsonArray(list);
			jsonArr = removeImprvCommIfBreakYnIsN(jsonArr);
			logger.debug("[인증원 API] 데이터: " + jsonArr.toString());
			
			Map<String, JSONArray> map = new HashMap<>();
			map.put(shmCcpType, jsonArr);
			JSONObject obj = new JSONObject(map);
			CloseableHttpClient httpclient = HttpClients.createDefault();

			try {
            	HttpPost httpPost = new HttpPost("https://shm.haccp.or.kr:5082/shm/api/dp");
				HttpEntity reqEntity = MultipartEntityBuilder.create()
						.addTextBody("jsonData", obj.toString(), ContentType.create("plain/text", Charset.forName("UTF-8")))
						.build();
				httpPost.setEntity(reqEntity);
				HttpResponse res = httpclient.execute(httpPost);
				
				BufferedReader b = new BufferedReader(new InputStreamReader(res.getEntity().getContent(), "UTF-8"));
				String rsltStr = b.readLine();
				b.close();
				
				JSONObject rsltObj = new JSONObject(rsltStr);
				logger.debug("[인증원 API] 전송 결과: " + rsltObj.toString());

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
	
	public void updateShmSentYn(String sensorKey, String yn) {
		conn = JDBCConnectionPool.getTenantDB(bizNo);
		ccpDataDao.updateShmSentYn(conn, sensorKey, yn);
	}
	
	private JSONArray removeImprvCommIfBreakYnIsN(JSONArray arr) {
		JSONArray newArr = new JSONArray();
		
		try {
			for(int i = 0; i < arr.length(); i++) {
				JSONObject obj = (JSONObject) arr.get(i);
				if( obj.get("BREAK_YN").equals("N") ) {
					obj.remove("IMPRV_COMM");
				}
				newArr.put(obj);
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
		
		return newArr;
	}
}
