package controller;

import java.io.IOException;
import java.io.PrintWriter;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.apache.log4j.Logger;

import dao.SensorDaoImpl;
import model.Sensor;
import service.SensorService;
import utils.FormatTransformer;


@WebServlet("/sensor")
public class SensorController extends HttpServlet {
	
	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;

	static final Logger logger = 
			Logger.getLogger(SensorController.class.getName());
	
	public void doGet(HttpServletRequest req, HttpServletResponse res) 
			throws ServletException, IOException {
		HttpSession session = req.getSession();
		String bizNo = (String) session.getAttribute("bizNo");
		
		if(bizNo == null) {
			bizNo = req.getParameter("bizNo");
		}
		
		String id = req.getParameter("id");
		
		SensorService sensorService = new SensorService(new SensorDaoImpl(), bizNo);
		
		String result = "";
		
		if(id.equals("all")) {
			List<Sensor> list = sensorService.getAllSensors();
			result = FormatTransformer.toJson(list);
		} else {
			Sensor sensor = sensorService.getSensorById(id);
			result = FormatTransformer.toJson(sensor);
		}
		
		res.setContentType("application/json; charset=UTF-8");
		PrintWriter out = res.getWriter();
		
		out.print(result);
	}

	public void doPost(HttpServletRequest req, HttpServletResponse res) 
			throws ServletException, IOException {
		
		if(req.getParameter("type").equals("insert")) {
			insert(req, res);
		}
		
		if(req.getParameter("type").equals("update")) {
			update(req, res);
		}
		
		if(req.getParameter("type").equals("delete")) {
			delete(req, res);
		}
	}
	
	public void insert(HttpServletRequest req, HttpServletResponse res) {
		HttpSession session = req.getSession();
		String tenantId = (String) session.getAttribute("bizNo");
		
		Sensor sensor = new Sensor(
				req.getParameter("id"), 
				req.getParameter("name"),
				req.getParameter("valueType"),
				req.getParameter("IP"),
				req.getParameter("protocol"),
				req.getParameter("packet"),
				req.getParameter("typeCode"),
				req.getParameter("checklistId")
			);
		
		SensorService sensorService = new SensorService(new SensorDaoImpl(), tenantId);
		Boolean inserted = sensorService.insert(sensor);
		
		res.setContentType("html/text; charset=UTF-8");
		
		try {
			PrintWriter out = res.getWriter();
			out.print(inserted.toString());
		} catch(Exception e) {
			e.printStackTrace();
		}
	}

	public void update(HttpServletRequest req, HttpServletResponse res) {
		HttpSession session = req.getSession();
		String tenantId = (String) session.getAttribute("bizNo");
		
		Sensor sensor = new Sensor(
				req.getParameter("id"), 
				req.getParameter("name"),
				req.getParameter("valueType"),
				req.getParameter("IP"),
				req.getParameter("protocol"),
				req.getParameter("packet"),
				req.getParameter("typeCode"),
				req.getParameter("checklistId")
			);
		
		SensorService sensorService = new SensorService(new SensorDaoImpl(), tenantId);
		Boolean updated = sensorService.update(sensor);
		
		res.setContentType("html/text; charset=UTF-8");
		
		try {
			PrintWriter out = res.getWriter();
			out.print(updated.toString());
		} catch(Exception e) {
			e.printStackTrace();
		}
	}
	
	public void delete(HttpServletRequest req, HttpServletResponse res) {
		HttpSession session = req.getSession();
		String tenantId = (String) session.getAttribute("bizNo");
		
		String sensorId = req.getParameter("id");
		
		SensorService sensorService = new SensorService(new SensorDaoImpl(), tenantId);
		Boolean deleted = sensorService.delete(sensorId);
		
		res.setContentType("html/text; charset=UTF-8");
		
		try {
			PrintWriter out = res.getWriter();
			out.print(deleted.toString());
		} catch(Exception e) {
			e.printStackTrace();
		}
		
	}
}
