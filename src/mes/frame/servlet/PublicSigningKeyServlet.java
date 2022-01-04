package mes.frame.servlet;

import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;

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
	name = "PublicSigningKeyServlet",
	urlPatterns = "/publicSigningKey"
)
public class PublicSigningKeyServlet extends HttpServlet {

	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;
	
	private AppProperties ap = new AppProperties();
	private CryptoService cs = new CryptoService();
	private ServerKeys sk = new ServerKeys(ap, cs);
	
	private ObjectMapper om = new ObjectMapper();
	
	private PushController pc = new PushController(sk, cs, om);
	
	private void processRequest(HttpServletRequest req, HttpServletResponse res) 
			throws IOException {
		
		res.setContentType("application/octet-stream");
		
		byte[] publicKeyBytes = pc.publicSigningKey();

		OutputStream os = res.getOutputStream();
		
		try {
			os.write(publicKeyBytes, 0, publicKeyBytes.length);
		} catch (IOException e) {
			e.printStackTrace();
		} finally {
			try {
				os.close();
			} catch (IOException e) {
				e.printStackTrace();
			}
		}
	}
	
	public void doGet(HttpServletRequest req, HttpServletResponse res) 
		throws ServletException, IOException {
		
		System.out.println("publicSigningKey servlet start");
		
		processRequest(req, res);
	}
	
	public void doPost(HttpServletRequest req, HttpServletResponse res) 
		throws ServletException, IOException {
		doGet(req, res);
	}
}