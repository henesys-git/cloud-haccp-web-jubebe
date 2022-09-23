package shm;

import java.io.IOException;
import java.io.PrintWriter;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.apache.log4j.Logger;
import org.json.JSONException;
import org.json.JSONObject;

import shm.dao.C0010DaoImpl;
import shm.dao.CCPDataDaoImpl;
import shm.service.ShmApiService;

@WebServlet("/shm")
public class ShmApiController extends HttpServlet {

	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;

	static final Logger logger = 
			Logger.getLogger(ShmApiController.class.getName());
	
	public void doGet(HttpServletRequest req, HttpServletResponse res) 
			throws ServletException, IOException {
		HttpSession session = req.getSession();
		String tenantId = (String) session.getAttribute("bizNo");
		String sensorKey = req.getParameter("sensorKey");
		
		ShmApiService service = new ShmApiService(new C0010DaoImpl(), new CCPDataDaoImpl(), tenantId);
		JSONObject result = service.sendCCPDataToShm(sensorKey);

		try {
			if(result.get("code").toString().equals("200")) {
				service.updateShmSentYn(sensorKey, "Y");
			}
		} catch (JSONException e) {
			e.printStackTrace();
		}
		
		res.setContentType("application/json; charset=UTF-8");
		PrintWriter out = res.getWriter();
		out.print(result);
	}

	public void doPost(HttpServletRequest req, HttpServletResponse res) 
			throws ServletException, IOException {
		
	}
	
	public void doPut(HttpServletRequest req, HttpServletResponse res) 
			throws ServletException, IOException {
	}
}
