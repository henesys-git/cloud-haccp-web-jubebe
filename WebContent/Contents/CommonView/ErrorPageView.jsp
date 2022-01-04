<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*,java.util.*,javax.servlet.http.*"%>
<%@ page import="mes.client.conf.*" %>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>프로그램 에러 페이지</title>
	<link rel="shotcut icon" type="image/x-icon" href="${ctx }/henesys.jpg"/>
	<!-- <jsp:include page="/Contents/Common/linkcss_js.jsp" flush="false"/> -->
</head>
<%
	String loginID = session.getAttribute("login_id").toString();
	String member_key = session.getAttribute("member_key").toString();
	if(loginID==null||loginID.equals("")){              // id가 Null 이거나 없을 경우
		response.sendRedirect("Contents/index.jsp");    // 로그인 페이지로 리다이렉트 한다.
	}
%>

<body>

프로그램에 문제가 있습니다.<br>
관리자에게 문의하여 주세요.<br>

<a href="javascript:window.close()">창닫기</A>

</body>
</html>