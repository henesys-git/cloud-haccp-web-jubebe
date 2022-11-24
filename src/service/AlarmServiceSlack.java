package service;

import java.nio.charset.StandardCharsets;
import java.util.ArrayList;
import java.util.List;

import org.apache.http.NameValuePair;
import org.apache.http.client.entity.UrlEncodedFormEntity;
import org.apache.http.client.methods.CloseableHttpResponse;
import org.apache.http.client.methods.HttpPost;
import org.apache.http.impl.client.CloseableHttpClient;
import org.apache.http.impl.client.HttpClients;
import org.apache.http.message.BasicNameValuePair;
import org.apache.http.util.EntityUtils;
import org.apache.log4j.Logger;
import org.json.simple.JSONObject;
import org.json.simple.parser.JSONParser;

public class AlarmServiceSlack implements AlarmService {

	private String channelId;
	private String apiToken;
	
	static final Logger logger = Logger.getLogger(AlarmServiceSlack.class.getName());
	
	public AlarmServiceSlack() {}
	
	public AlarmServiceSlack(String channelId, String apiToken) {
		this.channelId = channelId;
		this.apiToken = apiToken;
	}
	
	@Override
	public boolean alert(String message) {
		
		try {
			HttpPost post = new HttpPost("https://slack.com/api/chat.postMessage");
	
	        // add request parameter, form parameters
	        List<NameValuePair> urlParameters = new ArrayList<>();
	        urlParameters.add(new BasicNameValuePair("token", apiToken));
	        urlParameters.add(new BasicNameValuePair("channel", channelId));
	        urlParameters.add(new BasicNameValuePair("text", message));
	
	        post.setEntity(new UrlEncodedFormEntity(urlParameters, StandardCharsets.UTF_8));
	
	        try (CloseableHttpClient httpClient = HttpClients.createDefault();
	             CloseableHttpResponse response = httpClient.execute(post)) {
	
	            String res = EntityUtils.toString(response.getEntity());
	            JSONParser parser = new JSONParser();  
	            JSONObject json = (JSONObject) parser.parse(res);
	            String result = json.get("ok").toString();
	            
	            if(result.equals("true")) {
	            	return true;
	            } else {
	            	logger.error("[알람서비스 슬랙] 응답:" + json.toJSONString());
	            	return false;
	            }
	        }
		} catch (Exception e) {
			e.printStackTrace();
			return false;
		}
	}
}
