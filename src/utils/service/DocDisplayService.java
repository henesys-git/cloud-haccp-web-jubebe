package utils.service;

import java.io.*;
import java.net.URLEncoder;

import javax.servlet.*;
import javax.servlet.http.*;

import org.apache.log4j.Logger;

public class DocDisplayService extends HttpServlet {
 
	private static final long serialVersionUID = 1L;

	static final Logger logger = Logger.getLogger(DocDisplayService.class.getName());
	
	public void doGet(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		
		String filePath = request.getParameter("filePath").toString();
		logger.debug("	[문서뷰어] 파일 경로:" + filePath);
		
		response = setResponseOptions(response, filePath);
		OutputStream out = response.getOutputStream();
		
		try (FileInputStream in = new FileInputStream(filePath)) {
			int content;
			while ((content = in.read()) != -1) {
				out.write(content);
			}
			out.flush();
			out.close();
		} catch (IOException e) {
			logger.error("	[문서뷰어] file read error:");
			e.printStackTrace();
			response.sendRedirect(request.getContextPath() + "/ErrorHandler");
		} finally {
            try {
                if (out != null) {
                    out.close();
                }
            } catch (IOException e) {
            	logger.error("	[문서뷰어] error on closing output stream");
                e.printStackTrace();
            }
        }
	}
	
	public void doPost(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		doGet(request, response);
	}
	
	private String getFileExtension(String f) {
		
		int index = f.lastIndexOf(".");
		int beginIndex = index + 1;
		String contentType = f.substring(beginIndex);
		return contentType;
	}
	
	private String getFileName(String f) {
		
		int index = f.lastIndexOf("/");
		int beginIndex = index + 1;
		String fileName = f.substring(beginIndex);
		logger.debug("	[문서뷰어] 파일명:" + fileName);
		return fileName;
	}
	
	private HttpServletResponse setResponseOptions(HttpServletResponse response, String f) {
		
		String fileExtension = getFileExtension(f);
		logger.debug("	[문서뷰어] 파일 확장자:" + fileExtension);

		String fileName = getFileName(f);
		try {
			fileName = URLEncoder.encode(fileName, "UTF-8");
		} catch (UnsupportedEncodingException e) {
			e.printStackTrace();
		}
		
		switch(fileExtension) {
		
			case "pdf":
				response.setContentType("application/pdf");
				response.setHeader("Content-Disposition", "inline; filename=" + fileName);
				break;
			case "xls":
				response.setContentType("application/vnd.ms-sheet");
				response.setHeader("Content-Disposition", "attachment; filename=" + fileName);
				break;
			case "doc":
				response.setContentType("application/msword");
				response.setHeader("Content-Disposition", "attachment; filename=" + fileName);
				break;
			case "hwp":
				response.setContentType("application/unknown");
				response.setHeader("Content-Disposition", "attachment; filename=" + fileName);
				break;
			default :
				response.setContentType("text/plain");
				response.setHeader("Content-Disposition", "attachment; filename=" + fileName);
				break;
		}
		
		return response;
	}
}