<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="com.oreilly.servlet.*" %>
<%@ page import="com.oreilly.servlet.multipart.*" %>
<%@ page import="java.util.*" %>
<%@ page import="java.io.*" %>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Insert title here</title>
</head>
<body>
<%
	String OS = System.getProperty("os.name").toLowerCase();
	String docPath = "";
	String docPaths = "/DocServer/upload/files";
	String fileRealName = "";
	
	ServletContext context =  this.getServletContext();
	
	if (OS.indexOf("win") >= 0) {
	    docPath = "C:/DocServer";
	    
	    File f = new File(docPath);
	    if(!f.exists()) {
	    	f.mkdir();
	    }
	} else {
	    docPath = "/home/henesys/DocServer";
	    
	    File f = new File(docPath);
	    if(!f.exists()) {
	    	f.mkdir();
	    }
	}
	
	// 서블릿상의 upload 폴더 경로를 알아온다.
	String realFolder = context.getRealPath(docPaths);
	System.out.println("실제 서블릿 상 경로 : " + realFolder);
	
	MultipartRequest multi = new MultipartRequest(request, realFolder, 20*1024*1024, "UTF-8", new DefaultFileRenamePolicy());

	Enumeration params = multi.getParameterNames();
	
	while(params.hasMoreElements()) {
		String name = (String) params.nextElement();
		String value = multi.getParameter(name);
		System.out.println(name + " = "+ value + "<br>");
		fileRealName = value;
	}
	System.out.println("-------------------------------<br>");
	
	Enumeration files = multi.getFileNames();
	System.out.println(files);
	while(files.hasMoreElements()) {
		String name = (String) files.nextElement();
		String filename = multi.getFilesystemName(name);
		String original = multi.getOriginalFileName(name);
		String type = multi.getContentType(name);
		File file = multi.getFile(name);
		File renameFile = new File(realFolder + "/" + fileRealName); 	
		renameFile.delete();
		file.renameTo(renameFile);
		
		System.out.println("요청 파라미터 이름 : "+name+"<br>");
		System.out.println("실제 파일 이름 : "+original+"<br>");
		//System.out.println("저장 파일 이름 : "+filename+"<br>");
		System.out.println("저장 파일 이름 : "+fileRealName+"<br>");
		System.out.println("파일 콘텐츠 유형 : "+type+"<br>");
		
		if(file != null) {
			System.out.println("파일 크기 : "+ file.length());
			System.out.println("<br>");
		}
	}
	
%>
</body>
</html>