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
import org.json.simple.JSONObject;
import org.json.simple.parser.JSONParser;
import org.json.simple.parser.ParseException;

import dao.ChecklistDataDaoImpl;
import dao.DocumentDataDaoImpl;
import model.ChecklistData;
import model.DocumentData;
import service.ChecklistDataService;
import service.DocumentDataService;
import utils.FormatTransformer;

@WebServlet("/document")
public class DocumentDataController extends HttpServlet {

	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;

	static final Logger logger = 
			Logger.getLogger(DocumentDataController.class.getName());
	
	public void doGet(HttpServletRequest req, HttpServletResponse res) 
			throws ServletException, IOException {
		HttpSession session = req.getSession();
		String bizNo = (String) session.getAttribute("bizNo");
		
		String documentId = req.getParameter("documentId");
		String seqNoStr = req.getParameter("seqNo");
		String seqNoStr2 = req.getParameter("seqNo2");
		
		System.out.println("seq no string:" + seqNoStr);
		
		if(seqNoStr.equals("all")) {
			DocumentDataService docService = new DocumentDataService(new DocumentDataDaoImpl(), bizNo);
			List<DocumentData> docDataList = docService.selectAll(documentId);
			String result = FormatTransformer.toJson(docDataList);
			
			res.setContentType("application/json; charset=UTF-8");
			PrintWriter out = res.getWriter();
			
			out.print(result);
		} 
		else {
			int seqNo = Integer.parseInt(seqNoStr);
			
			DocumentDataService docService = new DocumentDataService(new DocumentDataDaoImpl(), bizNo);
			DocumentData docData = docService.select(documentId, seqNo);
			String result = FormatTransformer.toJson(docData);
			
			res.setContentType("application/json; charset=UTF-8");
			PrintWriter out = res.getWriter();
			
			out.print(result);
		}
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
	
	public void insert(HttpServletRequest req, HttpServletResponse res) throws IOException{
		
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
	
	public void update(HttpServletRequest req, HttpServletResponse res) throws IOException{
		
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
			String seqNo = json.get("seqNo").toString();
			int revisionNoInt = Integer.parseInt(revisionNo);
			int seqNoInt = Integer.parseInt(seqNo);

			ChecklistData clData = new ChecklistData();
			clData.setChecklistId(checklistId);
			clData.setRevisionNo(revisionNoInt);
			clData.setCheckData(checkData);
			clData.setSeqNo(seqNoInt);
			
			System.out.println(clData.toString());
			
			ChecklistDataService cldService = new ChecklistDataService(new ChecklistDataDaoImpl(), bizNo);
			int result = cldService.update(clData);
			
			res.setContentType("text/html; charset=UTF-8");
			PrintWriter out = res.getWriter();
			
			out.print(result);
		} catch (ParseException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		
	}
	
	public void delete(HttpServletRequest req, HttpServletResponse res) throws IOException {
		
		HttpSession session = req.getSession();
		String bizNo = (String) session.getAttribute("bizNo");
		
		String checklistId = req.getParameter("checklistId");
		int seqNo = Integer.parseInt(req.getParameter("seqNo").toString());
		try {

			ChecklistData clData = new ChecklistData();
			clData.setChecklistId(checklistId);
			clData.setSeqNo(seqNo);
			
			System.out.println(clData.toString());
			
			ChecklistDataService cldService = new ChecklistDataService(new ChecklistDataDaoImpl(), bizNo);
			int result = cldService.delete(clData);
			
			res.setContentType("text/html; charset=UTF-8");
			PrintWriter out = res.getWriter();
			
			out.print(result);
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		
	}
	
}
