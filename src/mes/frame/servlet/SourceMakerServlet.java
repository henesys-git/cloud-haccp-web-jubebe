package mes.frame.servlet;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletResponse;

import org.apache.log4j.Logger;
import mes.subserver.SourceMaker;

public class SourceMakerServlet extends HttpServlet { 
	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;
	
	static final Logger logger = Logger.getLogger(SourceMakerServlet.class.getName());
	
	public HttpServletResponse setAllowOrigin(HttpServletResponse response) {
        response.setHeader("Access-Control-Allow-Methods", "POST, GET");
        response.setHeader("Access-Control-Max-Age", "3600");
        response.setHeader("Access-Control-Allow-Headers", "x-requested-with");
        response.setHeader("Access-Control-Allow-Origin", "*");

        return response ;
    }
	
	public void init() throws ServletException {
		try {
			logger.info("[Source Maker] started detecting");
	    	SourceMaker sm = new SourceMaker();
	    	sm.start();
    	} catch (Exception e) {
    		logger.info("[Source Maker] Servlet Initialization failed");
    		e.printStackTrace();
    	}
    }
}