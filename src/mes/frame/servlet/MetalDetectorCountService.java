package mes.frame.servlet;

import java.io.IOException;
import java.io.PrintWriter;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.log4j.Logger;
import mes.subserver.MetalDetector;

public class MetalDetectorCountService extends HttpServlet { 
	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;
	
	static final Logger logger = 
			Logger.getLogger(MetalDetectorCountService.class.getName());
	
	public void doGet(HttpServletRequest req, HttpServletResponse res) 
			throws ServletException, IOException {
		doPost(req, res);
	}

	public void doPost(HttpServletRequest req, HttpServletResponse res) 
			throws ServletException, IOException {
		String mode;

		res.setContentType("text/html;charset=UTF-8");
		PrintWriter out = res.getWriter();

		if(req.getParameter("mode") != null) {
			mode = req.getParameter("mode");
			MetalDetector md = new MetalDetector();
			
			try {
				md.connectDevice();
			} catch (IOException e) {
				logger.error("[Metal Detector] 장비 연결 실패");
			}

			double dCnt = md.detectMetal(mode);
			String sCnt = String.valueOf(dCnt);
			
			logger.debug("[Metal Detector] count: " + sCnt);
			
			out.print(sCnt);
		} else {
			out.print("-999");
		}
	}
}