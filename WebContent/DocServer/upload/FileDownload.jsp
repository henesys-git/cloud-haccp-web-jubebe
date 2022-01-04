<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.net.URLEncoder" %>
<%@ page import="java.io.File" %>
<%@ page import="java.io.FileInputStream" %>
<%@ page import="mes.client.conf.*" %>
<%
	// 관례적인 표현
	// 파일읽기 <-- 파일의 MIME(유형) <--> 유형이 없을때
%>

<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>FileDownload.jsp</title>
</head>
<body>	
<h3>파일 다운로드</h3>
<%
	// 파일을 다운로드 할 때 파일의 제목이 인코딩에 따라 제목이 깨질 수 있다. 따라서 제목 인코딩이 필요하다.
	// 유형을 파악해야 한다.
	// FileInputStream: byte stream- 여러 유형의 byte 단위 일기 전송
	// FileReader: char Stream 문자 최적화
			
	System.out.println("sFilePath:-----------------------Start Down");
	// 다운로드할 파일을 JSP에서 받아온다.
// 	request.setCharacterEncoding("UTF-8");
// 	response.setCharacterEncoding("UTF-8");

	String fileName = request.getParameter("fileName");
	System.out.println("sFilePath:" + fileName);
	String codedoc = request.getParameter("codedoc");
	String revno = request.getParameter("revno");
	// 업로드 폴더 위치와 폴더 이름을 알아야 한다.
	String savePath =  Config.DOC_SAVEPATH;   // "/DocWebServer/DocUpload";
	ServletContext context =  this.getServletContext();

	// 갖고 온 위치에 연결해서  파일을 다운로드 받으면 된다.
	String sDownPath = context.getRealPath(savePath);
			
	// 문자열 ex) c:\\data\\image.pdf를 만들었다.
	String sFilePath = sDownPath + "/" + codedoc + "/" + fileName + "/" + revno + "/" + fileName;
	System.out.println("sFilePath:" + sFilePath);

	// 위 문자열을 파일로 인식해야 한다.
	File oFile = new File(sFilePath);

	System.out.println("oFile:" + oFile.toString());
	// 읽어와야 할 용량은 최대 업로드 용량을 초과하지 않는다.
	byte[] buf = new byte[50*1024*1024];
	FileInputStream inStream = new FileInputStream(oFile);
			
	// 유형확인 - 읽어올 경로의 파일의 유형 - 페이지 생성할 떼 타입을 설정해야 한다.
	String sMimeType = getServletContext().getMimeType(sFilePath);
			
	System.out.println("유형: " +sMimeType);
			
	// 지정되지 않은 유형 예외처리
	if (sMimeType == null) {
		// 관례적인 표현
		// 일련된 8bit 스트림형식
		// 유형이 알려지지 않은 파일에 대한 일기 형식 지정
		sMimeType = "application/octet-stream";
	}
			
	// 파일 다운로드 시작
	// 유형을 알려준다.
	// text/html; charset=utf-8을 대체
	response.setContentType(sMimeType);
	System.out.println("sMimeType=" + sMimeType);
			
	// 업로드 파일의 제목이 깨질 수 있다. URLEncode
	String A = new String(fileName.getBytes("euc-kr"), "8859_1");
	String B = "utf-8";
	String sEncoding = URLEncoder.encode(A,B);
			
	// 기타 내용을 헤드에 올려야 한다.
	// 기타 내용을 보고 브라우저에서 다운로드 시 화면에 출력시켜 준다.
	String AA = "Content-Disposition";
	String BB = "attachment; filename=" + sEncoding;
	response.setHeader(AA, BB);

	System.out.println("AA+BB==" + AA + BB);
	// 브라우저에 쓰기

	out.clear();
    out = pageContext.pushBody();
	ServletOutputStream out2 = response.getOutputStream();
	int numRead = 0;
			
	// 바이트 배열 buf의 0본부터 numRead번까지 브라우저로 출력
	while((numRead=inStream.read(buf, 0, buf.length)) != -1) {
// 		System.out.println(new String(buf, 0, numRead));
		out2.write(buf, 0, numRead);
	}
	out2.flush();
	System.out.println("1111111");
	out2.close();
	System.out.println("2222222");
	inStream.close();
	System.out.println("33333333");
%>
</body>
</html>
