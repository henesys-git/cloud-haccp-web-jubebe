package mes.frame.servlet;

import java.io.IOException;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import mes.client.conf.SysConfig;

import mes.client.common.BarcodePrint;

public class PrintBarcodeServlet extends HttpServlet{

	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;

	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// set barcode ip and port
		SysConfig conf = new SysConfig();
		String barcodeIp = conf.barcode_print_ip;
		int barcodePort = conf.barcode_print_port;
		
		// parameters
		String printDate = request.getParameter("printDate").trim();
		String prodName = request.getParameter("prodName").trim();
		String prodCode = request.getParameter("prodCode").trim();
		
		// get current time
		LocalDateTime myDateObj = LocalDateTime.now();
	    DateTimeFormatter myFormatObj = DateTimeFormatter.ofPattern("yyyyMMddHHmmssSSS");
	    String curTime = myDateObj.format(myFormatObj);
		
	    // set barcode value
		String barcodeValue = prodCode + curTime;
		
		// return text
		String returnText = prodName + "에 대한 바코드 출력 완료";
		
		// start barcode print
		BarcodePrint bp = new BarcodePrint(barcodeIp, barcodePort, barcodeValue, prodName);
		String returnValue = bp.startPrint();
		
		response.setContentType("text/html; charset=UTF-8");
		response.getWriter().write(returnText);
	}
}
