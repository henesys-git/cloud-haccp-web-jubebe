<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@page import="org.json.simple.JSONObject"%>
<%@ page import="java.sql.*,java.util.*,javax.servlet.http.*"%>
<%@ page import="mes.client.comm.*" %>
<%@ page import="mes.client.common.*" %>
<%@ page import="mes.client.guiComponents.*" %>
<%@ page import="mes.client.util.*" %>
<%@ page import="mes.client.conf.*" %>
<!-- 
온도 현황판
M707S010600.jsp
-->

<%
	String loginID = session.getAttribute("login_id").toString();
	if(loginID == null || loginID.equals("")) {         // id가 Null 이거나 없을 경우
		response.sendRedirect("Contents/index.jsp");    // 로그인 페이지로 리다이렉트 한다.
	}
%>  

<script>

$(document).ready(function () {
	
	fn_MainInfo_List();
	$("#InfoContentTitle").html("실시간 온도 현황판");
    fn_MainSubMenuSelect("CCP모니터링");
});

function fn_MainInfo_List() {
    $.ajax({
        type: "POST",
        url: "<%=Config.this_SERVER_path%>/Contents/Business/M707/S707S010600.jsp",
        beforeSend: function () {
			$("#MainInfo_List_contents").children().remove();
        },
        success: function (html) {
            $("#MainInfo_List_contents").hide().html(html).fadeIn(100);
        }
    });
}
</script>

<link rel="stylesheet" href="Lib/canvas-gauges-master/fonts/fonts.css">

<!-- Content Header (Page header) -->
<div class="content-header">
  <div class="container-fluid">
    <div class="row mb-2">
      <div class="col-sm-6">
        <h1 class="m-0 text-dark" id="MenuTitle">여기에 메뉴 타이틀</h1>
      </div>
      <div class="col-sm-6">
      	<div class="float-sm-right">
      	</div>
      </div>
    </div><!-- /.row -->
  </div><!-- /.container-fluid -->
</div>
<!-- /.content-header -->   
 
<!-- Main content -->
<div class="content">
  <div class="container-fluid">
    <div class="row">
      <div class="col-md-12">
        <div class="card card-primary card-outline">
          <div class="card-header">
          	<h3 class="card-title">
          		<i class="fas fa-edit" id="InfoContentTitle"></i>
          	</h3>
          	<div class="card-tools">
          	  <div id="digital-clock">
          	  	
          	  </div>
          	</div>
          </div>
          <div class="card-body" id="MainInfo_List_contents"></div> 
        </div>
      </div>
      <!-- /.col-md-12 -->
    </div>
    <!-- /.row -->
  </div><!-- /.container-fluid -->
</div>
<!-- /.content -->