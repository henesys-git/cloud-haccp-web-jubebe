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
			Logger.getLogger(CCPDataController.class.getName());
	
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
		HttpSession session = req.getSession();
		String bizNo = (String) session.getAttribute("bizNo");
		
		SensorService sensorService = new SensorService(new SensorDaoImpl(), bizNo);
		List<Sensor> sensorList = sensorService.getAllSensors();
		String result = FormatTransformer.toJson(sensorList);
		
		res.setContentType("application/json; charset=UTF-8");
		PrintWriter out = res.getWriter();
		
		out.print(result);
	}
}
