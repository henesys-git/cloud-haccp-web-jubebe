package mes.frame.servlet;

import java.io.IOException;
import java.net.UnknownHostException;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;

import org.apache.log4j.Logger;

import mes.subserver.InterfaceConstants;
import mes.subserver.MetalDetector;

public class MetalDetectorInitService 
	extends HttpServlet implements Runnable {
	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;
	
	static final Logger logger = 
			Logger.getLogger(MetalDetectorInitService.class.getName());
	
	public void init() throws ServletException {
		MetalDetectorInitService mdInit = new MetalDetectorInitService();
		Thread th = new Thread(mdInit);
		th.start();
		logger.info("[Metal Detector] Servlet Initialized");
    }
	
	public void run() {
		try {
			boolean reset = false;
			int orgCnt;
			String metalDetectorId = InterfaceConstants.METAL_DETECTOR;
			String pid = "M808S010200E111";

			MetalDetector md = new MetalDetector();
			
			while(true) {
				try {
					md.connectDevice();
					reset = reset(md);
					
					if(reset) {
						logger.debug("===========reset============");
						orgCnt = md.detectMetal("operation");
						logger.debug("[Metal Detector] initial count: " + orgCnt);
						
						while(true) {
							String mode = md.getMode();

							Thread.sleep(1000);
							
							if(mode.equals("operation")) {
								logger.debug("[Metal Detector] ## OPERATION MODE");
								int newCnt = md.detectMetal(mode);
								
								if(orgCnt != newCnt && newCnt != -998) {
									md.insertData(metalDetectorId, pid);
									orgCnt = newCnt;
								}
							}
						}
					} else {
						logger.debug("	[Metal Detector] failed to connect to device");
						Thread.sleep(1000 * 2);
					}
		    	} catch (IOException e) {
		    		logger.error("[Metal Detector] failed to connect to device (IOException)");
		    		Thread.sleep(1000*2);
		    	} finally {
		    		md.closeResources();
		    	}
			}
		} catch (InterruptedException e1) {
			e1.printStackTrace();
		}
	}
	
	public boolean reset(MetalDetector md) {
		String changed;
		try {
			changed = md.changeMode("operation");
			if(changed.equals("15")) {
				logger.error("[Metal Detector] failed to change status");
	    		return false;
	    	}
			
//			int cnt = md.detectMetal("operation");
//			logger.debug("	##### °³¼ö: " + cnt);
//			md.setOrgCntOperatioin(cnt);
			
			return true;
		} catch (IOException e) {
			logger.error("[Metal Detector] failed to reset status");
			return false;
		}
	}
}