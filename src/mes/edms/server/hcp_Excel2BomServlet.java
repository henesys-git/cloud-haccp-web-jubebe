package mes.edms.server;
import java.io.DataInputStream;
import java.io.DataOutputStream;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.PrintWriter;
import java.io.UnsupportedEncodingException;
import java.net.HttpURLConnection;
import java.net.URL;
import java.util.Enumeration;
import java.util.List;
import java.util.StringTokenizer;
import java.util.Vector;
import java.nio.file.Files;
import java.nio.file.attribute.*;
import static java.nio.file.StandardCopyOption.*;


import javax.servlet.ServletConfig;
import javax.servlet.ServletContext;
import javax.servlet.ServletException;
import javax.servlet.ServletOutputStream;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.fileupload.FileItem;
import org.apache.commons.fileupload.FileItemFactory;
import org.apache.commons.fileupload.disk.DiskFileItemFactory;
import org.apache.commons.fileupload.servlet.ServletFileUpload;

import mes.client.comm.DBServletLink;
import mes.client.conf.Config;
import mes.edms.server.MultipartRequest;
import mes.frame.common.HashObject;
import mes.frame.database.Excel2MBom;
import mes.frame.util.CommonFunction;

public class hcp_Excel2BomServlet extends HttpServlet {
	HttpFileUploader httpFileUploader = null;
	
	// location to store file uploaded
    private String UPLOAD_DIRECTORY = "";
	
	// upload settings
    private static final int MEMORY_THRESHOLD   = 1024 * 1024 * 3;  // 3MB
    private static final int MAX_FILE_SIZE      = 1024 * 1024 * 5; // 20MB
    private static final int MAX_REQUEST_SIZE   = 1024 * 1024 * 50; // 50MB
	
	String line = "";
	String CONTENT_BOUNDARY_TAG = "boundary=";
	String CHARSET = "UTF-8"; //UTF-8 / EUC-KR
	String webServerUrl = Config.WEBSERVERURL; //"http://localhost:8080/FileServer/hcp_Excel2BomServlet";
	String edmsServerUploadUrl =  Config.EDMSSERVERUPLOADURL; //"http://182.162.141.176:8080/examples/doyosae/FileUpload.jsp";
	String edmsServerDownloadUrl =  Config.EDMSSERVERDOWNLOADURL; //"http://182.162.141.176:8080/examples/doyosae/FileDownload.jsp";

	public void init(ServletConfig config) throws ServletException {
		super.init(config);				
		System.out.println("Started hcp_Excel2BomServlet.....................");
		httpFileUploader = new HttpFileUploader();
	}

	public void doGet(HttpServletRequest req, HttpServletResponse res) throws ServletException, IOException {
		try {
			performTask(req, res);
		} catch (Exception e){}
	}
	public void doPost(HttpServletRequest req, HttpServletResponse res) throws ServletException, IOException {
		try {
			performTask(req, res);
		} catch (Exception e){}
	}
	
	void procDbUpdate() {
		try {
			
		} catch (Exception e) {
			e.printStackTrace();
		}
	}
	
	
//	public void performTask(HttpServletRequest request, HttpServletResponse resp) throws ServletException, IOException, Exception {
	public void performTask(HttpServletRequest request, HttpServletResponse resp) throws ServletException, IOException {
		System.out.println("hcp_Excel2BomServlet::service(HttpServletRequest,HttpServletResponse) called");
		
		String fileName = "";
		String filePath = "";
		String JopType = request.getParameter("pid");
		String BomCdRev = request.getParameter("bom_cd_rev");
		String BomNm = request.getParameter("bom_nm");
		String MemberKey = request.getParameter("member_key");
		
		//pid가 Excel to Bom일 경우 
		if(JopType.equals("M909S010100E201")) {  
			UPLOAD_DIRECTORY = "BOM_XLS";
		//pid가 img처리 일 경우	
		}else {
			UPLOAD_DIRECTORY = "images/SULBI";
		}
		
		// checks if the request actually contains upload file
        if (!ServletFileUpload.isMultipartContent(request)) {
            // if not, we stop here
            PrintWriter writer = resp.getWriter();
            writer.println("Error: Form must has enctype=multipart/form-data.");
            writer.flush();
            return;
        }
 
        // configures upload settings
        DiskFileItemFactory factory = new DiskFileItemFactory();
        // sets memory threshold - beyond which files are stored in disk
        factory.setSizeThreshold(MEMORY_THRESHOLD);
        // sets temporary location to store files
        factory.setRepository(new File(System.getProperty("java.io.tmpdir")));
 
        ServletFileUpload upload = new ServletFileUpload(factory);
         
        // sets maximum size of upload file
        upload.setFileSizeMax(MAX_FILE_SIZE);
         
        // sets maximum size of request (include file + form data)
        upload.setSizeMax(MAX_REQUEST_SIZE);
 
        // constructs the directory path to store upload file
        // this path is relative to application's directory
        String uploadPath = getServletContext().getRealPath("") + UPLOAD_DIRECTORY;
         
        // creates the directory if it does not exist
        File uploadDir = new File(uploadPath);
        if (!uploadDir.exists()) {
            uploadDir.mkdir();
        }
 
        try {
            // parses the request's content to extract file data
            @SuppressWarnings("unchecked")
            List<FileItem> formItems = upload.parseRequest(request);
 
            if (formItems != null && formItems.size() > 0) {
                // iterates over form's fields
                for (FileItem item : formItems) {
                    // processes only fields that are not form fields
                    if (!item.isFormField()) {
                        fileName = new File(item.getName()).getName();
                        filePath = uploadPath + File.separator + fileName;
                        File storeFile = new File(filePath);
 
                        // saves the file on disk
                        item.write(storeFile);
                        request.setAttribute("message",
                            "Upload has been done successfully!");
                        
                    }
                    item.getOutputStream().close();
                    item.getInputStream().close();
                }
                
            }
        } catch (Exception ex) {
            request.setAttribute("message",
                    "There was an error: " + ex.getMessage());
        }
        // redirects client to message page
        //getServletContext().getRequestDispatcher("/Contents/CommonView/Message.jsp").forward(request, resp);
        
        
		System.out.println("============"+fileName+"=============");
		System.out.println("============"+filePath+"=============");
        
        
        if(JopType.equals("M909S010100E201")) {
        	if(fileName.equals("")) {
            	return;
            }else {
            	 Excel2MBom bom = new Excel2MBom(fileName,filePath,BomCdRev,BomNm,MemberKey);
            	 bom.Excel2MBom();
            }
        }else {
        	return;
        }
        
        /*
        //이미지 
        if(JopType.equals("M909S020100E101")) {
        	if(fileName.equals("")) {
            	return;
            }else {
            	 Excel2MBom bom = new Excel2MBom(filePath,fileName);
            	 arr = bom.Excel2MBom();
            }
        }else {
        	return;
        }
        */
        
    }
	
}
