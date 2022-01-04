package mes.frame.servlet;

import java.io.IOException;
import java.util.stream.Collectors;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.http.HttpStatus;
import org.json.simple.JSONObject;
import org.json.simple.parser.JSONParser;
import org.json.simple.parser.ParseException;

import mes.webpush.AppProperties;
import mes.webpush.CryptoService;
import mes.webpush.ServerKeys;
import mes.webpush.dto.Subscription;
import mes.webpush.PushController;

import com.fasterxml.jackson.databind.ObjectMapper;

@WebServlet(
	name = "SubscriptionServlet",
	urlPatterns = "/subscribe"
)
public class SubscribtionServlet extends HttpServlet {

	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;
	
	private AppProperties ap = new AppProperties();
	private CryptoService cs = new CryptoService();
	private ServerKeys sk = new ServerKeys(ap, cs);
	
	private ObjectMapper om = new ObjectMapper();
	//private Subscription subscription;
	
	private PushController pc = new PushController(sk, cs, om);

	private void processRequest(HttpServletRequest req, HttpServletResponse res) {
		
		try {
			res.setStatus(HttpStatus.SC_CREATED);
	
			String subscriptionInfo = req.getReader().lines().collect(Collectors.joining());
			System.out.println("subscription info:" + subscriptionInfo);
			
			JSONParser parser = new JSONParser();
			JSONObject subscriptionInfoJson;
			subscriptionInfoJson = (JSONObject) parser.parse(subscriptionInfo);
			
			String keys = subscriptionInfoJson.get("keys").toString();
			System.out.println("keysSTr:" + keys);
			JSONObject keysJson = (JSONObject) parser.parse(keys);
	
			String endpoint = subscriptionInfoJson.get("endpoint").toString();
			String p256dh = (String) keysJson.get("p256dh");
			String auth = (String) keysJson.get("auth");
			
			Subscription subscription = new Subscription(
					endpoint, p256dh, auth);
			
			pc.subscribe(subscription);
		} catch(IOException e) {
			e.printStackTrace();
		} catch(ParseException e) {
			e.printStackTrace();
		}
	}
	
	public void doGet(HttpServletRequest req, HttpServletResponse res) 
		throws ServletException, IOException {
		doPost(req, res);
	}
	
	public void doPost(HttpServletRequest req, HttpServletResponse res) 
		throws ServletException, IOException {
		processRequest(req, res);
	}
}