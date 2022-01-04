
<%@page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@page import="java.io.File" %>
<%@page import="java.net.*" %>
<%@page import="java.util.Enumeration" %>
<%@page import="mes.edms.server.*" %>
<%@page import="mes.edms.server.MultipartRequest" %>
<%@ page import="mes.client.conf.*" %>
<%@ page import="mes.frame.common.*" %>
<%
	String realFolder = "";
	request.setCharacterEncoding("UTF-8");

// 해쉬테이블 java.net
// 	HashObject hashObject = new HashObject();
	
	String codedoc = request.getParameter("codedoc");
	String revno = request.getParameter("revno");
	
	// 업로드용 폴더 이름
	String saveFolder = mes.client.conf.Config.DOC_SAVEPATH;   // "DocServer/DocUpload";
	String encType = "utf-8";
	int max_content_length = 50 * 1024 * 1024; // 5MByte

	System.out.println("DOC_SAVEPATH : " +  mes.client.conf.Config.DOC_SAVEPATH);
	// 서버에서(서블릿) 어디에 어느 폴더에서 서블릿으로 변환되나?
	ServletContext context =  this.getServletContext();

	// 서블릿상의 upload 폴더 경로를 알아온다.
	realFolder = context.getRealPath(saveFolder);
	// 콘솔/브라우즈에 실제 경로를 출력
	System.out.println("실제 서블릿 상 결로 : " + realFolder);
	
	// 파일을 받아와서 폴더에 업로드 하면 된다.
	MultipartRequest multipart = null;
	
	try {
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

// 		System.out.println("1111--------------codedoc=" + codedoc );
		Enumeration enumer = multipart.getParameterNames();
		while(enumer.hasMoreElements()) {
			String name = enumer.nextElement().toString();
			String value = multipart.getURLParameter(name);
//             hashObject.put(name, value);
//             map.put(name, value);
    		System.out.println("name=" + name + "   value=" + value );
		}				
		
// 		hashObject.print();
// 		String pid = String.valueOf(map.get(key));
// 		String codedoc = String.valueOf(map.get("codedoc"));
// 		String revno = String.valueOf(map.get("revno"));
		System.out.println("--------------codedoc=" + codedoc );
		System.out.println("-------------evno=" + revno );

		// 전송된 파일이름 filename1, filename2를 가져온다.
		enumer = multipart.getFileParameterNames();
		while(enumer.hasMoreElements()) {
			String name = enumer.nextElement().toString();
			// name 파라미터에는 file의 이름이 들어있다.
			// 그 이름을 주면 실제 값(업로드 "할"file)을 가져온다.
// 			String originFile = URLEncoder.encode(multipart.getBaseFilename(name),"utf-8"); //2018-12-18 JH 수정
			String originFile = multipart.getBaseFilename(name);
			
			// 만약 업로드 폴더에 똑같은 파일이 있으면.. 현재 올리는 파일이름을 바꾼다.(중복회피정책)
			// 그래서 시스템에 있는 이름을 알려준다. strSaveDirectory
			String systemFile = multipart.getFileSystemName(name);
			
			// 전송된 파일의 타입-MIME타입 (기계어, 이미지, HTML, txt, ...)
			String fileType = multipart.getContentType(name);
			
			// 문자열 "파일이름"이 name에 들어온 상태
			// 문자열 파일이름을 통해 실제 파일 객체를 가져온다.
			String makeDir ="";
			makeDir = realFolder + "/" + codedoc + "/" + originFile + "/" + revno ;
			File codedocffile 	= new File(realFolder + "/" + codedoc);
			File fileNamefile 	= new File(realFolder + "/" + codedoc + "/" + originFile);
			File revnofile 		= new File(realFolder + "/" + codedoc + "/" + originFile + "/" + revno);
// 			/DocUpload/PSQM-01/18-8KUHCReport.pdf/0/PSQM-01/PSQM-01/18-8KUHCReport.pdf/PSQM-01/18-8KUHCReport.pdf/0/18-8KUHCReport.pdf
			if(!codedocffile.exists())
				codedocffile.mkdir();
			if(!fileNamefile.exists())
				fileNamefile.mkdir();
			if(!revnofile.exists())
				revnofile.mkdir();
			
			File renameFile = new File(makeDir + "/" + originFile);	
			File file = multipart.getFile(name);		
			boolean rnrtn = file.renameTo(renameFile);

			System.out.println("-------------renameFile rnrtn =" +rnrtn  );
			System.out.println("-------------renameFile=" +rnrtn + "==" + renameFile.toString() );
		
			if (renameFile!= null) {
				if (renameFile.length() > 0) {
					out.println("" + renameFile.length());
				}
			}
		}
		
	} catch (Exception e) {
		e.printStackTrace();
	}
	
	
%>
