<%@page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@page import="java.io.File" %>
<%@page import="java.util.Enumeration" %>
<%@page import="mes.edms.server.*" %>
<%@page import="mes.edms.server.MultipartRequest" %>
<%@ page import="mes.client.conf.*" %>
<%@ page import="mes.client.common.*" %>
<%@ page import="mes.frame.common.*" %>
<%
	String realFolder = "";

// 해쉬테이블
	HashObject hashObject = new HashObject();
	
	// 업로드용 폴더 이름
	String saveFolder =  "/images/Company";  
// 	String saveFolder = mes.client.conf.Config.this_SERVER_path + "/images/SULBI";  
	String encType = "utf-8";
	int max_content_length = 20 * 1024 * 1024; // 5MByte
	// 서버에서(서블릿) 어디에 어느 폴더에서 서블릿으로 변환되나?
	ServletContext context =  this.getServletContext();

	// 서블릿상의 upload 폴더 경로를 알아온다.
	realFolder = context.getRealPath(saveFolder);
	// 콘솔/브라우즈에 실제 경로를 출력
	System.out.println("실제 서블릿 상 결로 : " + realFolder);
	
	// 파일을 받아와서 폴더에 업로드 하면 된다.
	MultipartRequest multipart = null;
	
	try {
		// MultipartRequest 생성하기 전에, 실제경로(realFolder)가 없을때 경로(폴더)생성
		File SERVER_path 	= new File(realFolder);
		if(!SERVER_path.exists()) {
			SERVER_path.mkdir();
		}
		
		/*
		multipart = new MultipartRequest(
				request
				,realFolder
				,maxSize
				,encType
				,new DefaultFileRenamePolicy()
		);
		*/
		multipart = new MultipartRequest(response.getWriter(), 
				request.getContentType(),
				request.getContentLength(),
				request.getInputStream(),
				realFolder,
				(int)max_content_length,
				encType);

// 		HashMap<String, String> map = new HashMap<String, String>();//해쉬맵 생성

		Enumeration all_enumer = multipart.getParameterNames();
		while(all_enumer.hasMoreElements()) {
			String key = all_enumer.nextElement().toString();
			String value = multipart.getURLParameter(key);
			System.out.println("<br>" + key + " : " + value);
            hashObject.put(key, value);
		}				


		// 전송된 파일이름 filename1, filename2를 가져온다.
		Enumeration enumer = multipart.getFileParameterNames();
		
// 		enumer = multipart.getFileParameterNames();
		while(enumer.hasMoreElements()) {
			
			String fileName = String.valueOf(hashObject.get("fileName", HashObject.YES));
			
			String name = enumer.nextElement().toString();
			// name 파라미터에는 file의 이름이 들어있다.
			// 그 이름을 주면 실제 값(업로드 "할"file)을 가져온다.
			
			String originFile = multipart.getBaseFilename(name);
			
			// 만약 업로드 폴더에 똑같은 파일이 있으면.. 현재 올리는 파일이름을 바꾼다.(중복회피정책)
			// 그래서 시스템에 있는 이름을 알려준다. strSaveDirectory
			String systemFile = multipart.getFileSystemName(name);
			// 전송된 파일의 타입-MIME타입 (기계어, 이미지, HTML, txt, ...)
			
			String fileType = multipart.getContentType(name);
			// 문자열 "파일이름"이 name에 들어온 상태
			// 문자열 파일이름을 통해 실제 파일 객체를 가져온다.
			if(multipart.getFile(name) != null) {
				File file = multipart.getFile(name);	
				String realFileName="";	

				File renameFile = new File(realFolder + "/" + fileName);	
				renameFile.delete();
				boolean rnrtn = file.renameTo(renameFile);
// 				System.out.println("-------------renameFile=" + renameFile.toString() );
// 				System.out.println("-------------renameFile rnrtn =" +rnrtn  );
// 				System.out.println("-------------renameFile=" +rnrtn + "==" + renameFile.toString() );
			
				if (renameFile!= null) {
					if (renameFile.length() > 0) {
						out.println("" + fileName);
					}
				}
			}
		}
		
	} catch (Exception e) {
		e.printStackTrace();
	}
	
	
%>
