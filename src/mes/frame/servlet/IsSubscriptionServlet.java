package mes.frame.servlet;

import java.io.IOException;
import java.io.PrintWriter;
import java.util.stream.Collectors;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import mes.webpush.AppProperties;
import mes.webpush.CryptoService;
import mes.webpush.ServerKeys;
import mes.webpush.PushController;

import com.fasterxml.jackson.databind.ObjectMapper;

@WebServlet(
	name = "IsSubscriptionServlet",
	urlPatterns = "/isSubscribed"
)
public class IsSubscriptionServlet extends HttpServlet {

	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;
	
	private AppProperties ap = new AppProperties();
	private CryptoService cs = new CryptoService();
	private ServerKeys sk = new ServerKeys(ap, cs);
	
	private ObjectMapper om = new ObjectMapper();
	
	private PushController pc = new PushController(sk, cs, om);

	private void processRequest(HttpServletRequest req, HttpServletResponse res) {
		
		try {
			String endpoint = req.getReader().lines().collect(Collectors.joining());
			System.out.println("[endpoint] " + endpoint);

			boolean isSubscribed = pc.isSubscribed(endpoint);
			
		    PrintWriter pw = res.getWriter();
		    pw.println(isSubscribed);
		} catch (IOException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
	}
	
	public void doGet(HttpServletRequest req, HttpServletResponse res) 
		throws ServletException, IOException {
		
		doPost(req, res);
	}
	
	public void doPost(HttpServletRequest req, HttpServletResponse res) 
		throws ServletException, IOException {
		
		System.out.println("isSubscribed servlet start");
		processRequest(req, res);
	}
}