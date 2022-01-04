package mes.frame.servlet;

import java.io.IOException;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.json.simple.JSONObject;
import mes.client.guiComponents.DoyosaeTableModel;

public class WeightCheckerServlet extends HttpServlet { 
	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;
	
	public HttpServletResponse setAllowOrigin(HttpServletResponse response) {
        //response.setHeader("Access-Control-Allow-Methods", "POST, GET, OPTIONS, DELETE");
        response.setHeader("Access-Control-Allow-Methods", "POST, GET");
        response.setHeader("Access-Control-Max-Age", "3600");
        response.setHeader("Access-Control-Allow-Headers", "x-requested-with");
        response.setHeader("Access-Control-Allow-Origin", "*");

        return response ;
    }
	
	public void doGet(HttpServletRequest req, HttpServletResponse res) throws ServletException, IOException {
		saveDataFromTempDevice(req, res);
	}
		
	@SuppressWarnings("unchecked")
	public void saveDataFromTempDevice(HttpServletRequest req, HttpServletResponse res) throws ServletException, IOException {
		JSONObject jObj = new JSONObject();
		
		String censor_no = req.getParameter("censor_no");
		String censor_data_type = req.getParameter("censor_data_type");
		String prodId = req.getParameter("prodId");
		String censor_value0 = req.getParameter("censor_value0");
		String censor_value1 = req.getParameter("censor_value1");
		
		System.out.println(censor_no + "로 부터 " + censor_data_type
							+ "총 집계량:" + censor_value0 
							+ "정량 수:" + censor_value1
							+ " 를 받았습니다.");
		
		jObj.put("censor_no", censor_no);
		jObj.put("censor_data_type", censor_data_type);
		jObj.put("prodId", prodId);
		jObj.put("censor_value0", censor_value0);
		jObj.put("censor_value1", censor_value1);
		
		new DoyosaeTableModel("M404S030100E101", jObj);
		
		// 실시간 현황판 데이터 업데이트
//		res.setContentType("text/html");
//		res.sendRedirect("realtime-board/tempDisplay.jsp?censor_no="+censor_no+"&censor_value="+censor_value);
		
		jObj = null;	// to get garbage collected
	}
}