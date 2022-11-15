/*
 * 
 * 생산성본부 KPI 연계 시스템
 * 
 * */

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

import shm.dao.SsfKPIDaoImpl;
import shm.service.SsfApiService;

@WebServlet("/ssf")
public class SsfApiController extends HttpServlet {

	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;

	static final Logger logger = 
			Logger.getLogger(SsfApiController.class.getName());
	
	public void doGet(HttpServletRequest req, HttpServletResponse res) 
			throws ServletException, IOException {
		try {
			HttpSession session = req.getSession();
			String tenantId = (String) session.getAttribute("bizNo");
			String sensorKey = req.getParameter("sensorKey");
			String data = req.getParameter("data");
			JSONObject json = new JSONObject(data);
			
			SsfApiService service = new SsfApiService(tenantId, new SsfKPIDaoImpl());
			JSONObject result = service.sendKpiToSsf(json);

			if(result.has("okMsg")) {
				service.updateSsfSentYn(sensorKey, "Y");
			}
			
			res.setContentType("application/json; charset=UTF-8");
			PrintWriter out = res.getWriter();
			out.print(result);
		} catch (JSONException e2) {
			e2.printStackTrace();
		}
	}

	public void doPost(HttpServletRequest req, HttpServletResponse res) 
			throws ServletException, IOException {
		
	}
	
	public void doPut(HttpServletRequest req, HttpServletResponse res) 
			throws ServletException, IOException {
	}
}
