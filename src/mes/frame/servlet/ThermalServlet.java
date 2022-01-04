package mes.frame.servlet;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.log4j.Logger;
import org.json.simple.JSONObject;
import mes.client.guiComponents.DoyosaeTableModel;
import mes.subserver.ThermalServerSerial;

public class ThermalServlet extends HttpServlet {
	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;
	
	static final Logger logger = Logger.getLogger(ThermalServlet.class.getName());
	
	public HttpServletResponse setAllowOrigin(HttpServletResponse response) {
        //response.setHeader("Access-Control-Allow-Methods", "POST, GET, OPTIONS, DELETE");
        response.setHeader("Access-Control-Allow-Methods", "POST, GET");
        response.setHeader("Access-Control-Max-Age", "3600");
        response.setHeader("Access-Control-Allow-Headers", "x-requested-with");
        response.setHeader("Access-Control-Allow-Origin", "*");

        return response;
    }
	
	public void init() throws ServletException {
		try {
			ThermalServerSerial r = new ThermalServerSerial("/dev/ttyUSB0");
    		Thread thread1 = new Thread(r, "Wonwoo Thread");
    		thread1.start();
    	} catch (Exception e) {
    		logger.info("[TEMPERATURE] Servlet Initialization failed");
    		e.printStackTrace();
    	}
    }
	
	public void doGet(HttpServletRequest req, HttpServletResponse res) 
			throws ServletException, IOException {
		//saveDataFromTempDevice(req, res);
	}
		
	@SuppressWarnings("unchecked")
	public void saveDataFromTempDevice(HttpServletRequest req, HttpServletResponse res) 
			throws ServletException, IOException {
		JSONObject jArray = new JSONObject();
		
		String censor_no = req.getParameter("censor_no");
		String censor_data_type = req.getParameter("censor_data_type");
		String censor_value = req.getParameter("censor_value");
		
		logger.debug("[TEMPERATURE] receive " + censor_data_type + censor_value + 
					 			  " from " + censor_no);
		
		jArray.put("censor_no", censor_no);
		jArray.put("censor_data_type", censor_data_type);
		jArray.put("censor_value", censor_value);
		
		new DoyosaeTableModel("M707S010800E001", jArray);
		
		res.setContentType("text/html");
		//res.sendRedirect("realtime-board/tempDisplay.jsp?censor_no="+censor_no+"&censor_value="+censor_value);
		
		jArray = null;	// to get garbage collected
	}
}