package mes.service;

import java.sql.Connection;
import java.util.List;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.ObjectMapper;

import mes.dao.CCPDataDao;
import mes.frame.database.JDBCConnectionPool;
import mes.model.CCPData;

public class CCPDataService {

	private CCPDataDao ccpDataDao;
	private String bizNo;
	
	public CCPDataService(CCPDataDao ccpDataDao, String bizNo) {
		this.ccpDataDao = ccpDataDao;
		this.bizNo = bizNo;
	}
	
	public List<CCPData> getCCPData(String type, String startDate, String endDate) {
		Connection conn = JDBCConnectionPool.getTenantDB(bizNo);
		
		List<CCPData> ccpDataList = ccpDataDao.getAllCCPData(conn, type, startDate, endDate);
		
		return ccpDataList;
	}
	
	public String getListAsJson(List<CCPData> list) {
		JSONObject jsonObject = new JSONObject();
		ObjectMapper objectMapper = new ObjectMapper();
		
		JsonNode listNode = objectMapper.valueToTree(list);
		
		JSONArray jsonArray = new JSONArray();
		
		try {
			jsonArray = new JSONArray(listNode.toString());
			//jsonObject.put("list", request);
		} catch (JSONException e) {
			e.printStackTrace();
		}
		
		return jsonArray.toString();
	}
}
