package shm.controller;

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

import shm.dao.ShmCCPDataDao;
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
		try {
			HttpSession session = req.getSession();
			String tenantId = (String) session.getAttribute("bizNo");
			String sensorKey = req.getParameter("sensorKey");
			String shmCcpType = req.getParameter("shmCcpType");
			
			Class<ShmCCPDataDao> c = (Class<ShmCCPDataDao>) Class.forName("shm.dao.Shm" + shmCcpType + "DaoImpl");
			ShmCCPDataDao instance = c.newInstance();
			logger.debug("[인증원 API] CCP 클래스 명: " + instance.getClass().getName());
			
			ShmApiService service = new ShmApiService(instance, new CCPDataDaoImpl(), tenantId);
			JSONObject result = service.sendCCPDataToShm(sensorKey);
	
			if(result.get("code").toString().equals("200")) {
				service.updateShmSentYn(sensorKey, "Y");
			}
			
			res.setContentType("application/json; charset=UTF-8");
			PrintWriter out = res.getWriter();
			out.print(result);
		} catch (ClassNotFoundException e1) {
			e1.printStackTrace();
		} catch (JSONException e2) {
			e2.printStackTrace();
		} catch (InstantiationException | IllegalAccessException e) {
			e.printStackTrace();
		}
	}

	public void doPost(HttpServletRequest req, HttpServletResponse res) 
			throws ServletException, IOException {
		
	}
	
	public void doPut(HttpServletRequest req, HttpServletResponse res) 
			throws ServletException, IOException {
	}
}
