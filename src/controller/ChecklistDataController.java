package controller;

import java.io.IOException;
import java.io.PrintWriter;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.apache.log4j.Logger;
import org.json.simple.JSONObject;
import org.json.simple.parser.JSONParser;
import org.json.simple.parser.ParseException;

import dao.ChecklistDataDaoImpl;
import mes.model.ChecklistData;
import mes.service.ChecklistDataService;

@WebServlet("/checklist")
public class ChecklistDataController extends HttpServlet {

	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;

	static final Logger logger = 
			Logger.getLogger(ChecklistDataController.class.getName());
	
	public void doGet(HttpServletRequest req, HttpServletResponse res) 
			throws ServletException, IOException {
		doPost(req, res);
	}

	public void doPost(HttpServletRequest req, HttpServletResponse res) 
			throws ServletException, IOException {
		HttpSession session = req.getSession();
		String bizNo = (String) session.getAttribute("bizNo");

		String data = req.getParameter("data");
		
		JSONParser parser = new JSONParser();  
		JSONObject json;
		try {
			json = (JSONObject) parser.parse(data);
			String checkData = json.get("checklistData").toString();
			String checklistId = json.get("checklistId").toString();
			String revisionNo = json.get("revisionNo").toString();
			int revisionNoInt = Integer.parseInt(revisionNo);

			ChecklistData clData = new ChecklistData();
			clData.setChecklistId(checklistId);
			clData.setRevisionNo(revisionNoInt);
			clData.setCheckData(checkData);
			
			System.out.println(clData.toString());
			
			ChecklistDataService cldService = new ChecklistDataService(new ChecklistDataDaoImpl(), bizNo);
			int result = cldService.insert(clData);
			
			res.setContentType("text/html; charset=UTF-8");
			PrintWriter out = res.getWriter();
			
			out.print(result);
		} catch (ParseException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
	}
}
