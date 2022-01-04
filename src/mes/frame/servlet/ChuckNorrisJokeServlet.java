package mes.frame.servlet;

import java.io.IOException;

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
	name = "ChuckNorrisJokeServlet",
	urlPatterns = "/chuckNorrisJoke"
)
public class ChuckNorrisJokeServlet extends HttpServlet {

	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;
	
	private AppProperties ap = new AppProperties();
	private CryptoService cs = new CryptoService();
	private ServerKeys sk = new ServerKeys(ap, cs);
	
	private ObjectMapper om = new ObjectMapper();
	
	private PushController pc = new PushController(sk, cs, om);

	public void doGet(HttpServletRequest req, HttpServletResponse res) 
		throws ServletException, IOException {
		
		System.out.println("ChuckNorrisJoke servlet start");
		//pc.chuckNorrisJoke();
	}
	
	public void doPost(HttpServletRequest req, HttpServletResponse res) 
		throws ServletException, IOException {
		
		doGet(req, res);
	}
}