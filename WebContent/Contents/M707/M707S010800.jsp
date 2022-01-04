<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*,java.util.*,javax.servlet.http.*"%>
<%@ page import="mes.client.comm.*" %>
<%@ page import="mes.client.common.*" %>
<%@ page import="mes.client.guiComponents.*" %>
<%@ page import="mes.client.util.*" %>
<%@ page import="mes.client.conf.*" %>
<%
	String loginID = session.getAttribute("login_id").toString();

	if(loginID == null || loginID.equals("")) {                            			
		// id가 Null 이거나 없을 경우 로그인 페이지로 리다이렉트 한다.
		response.sendRedirect(Config.this_SERVER_path + "/Contents/index.jsp");
		return;
	}

	String sMenuTitle = request.getParameter("MenuTitle").toString();
	String sProgramId = request.getParameter("programId").toString();
	String sHeadmenuID= request.getParameter("HeadmenuID").toString();
	String sHeadmenuName= request.getParameter("HeadmenuName").toString();
%>  

<script>
	var selectedDate = "";
	
    $(document).ready(function () {
    	new SetSingleDate2("", "#date", 0);
    	selectedDate = $('#date').val();
	    fn_MainInfo_List(selectedDate);
       	
        fn_MainSubMenuSelect("<%=sMenuTitle%>");
        $("#InfoContentTitle").html("시각화모니터링-온도기록지");
   
     	// 날짜 변경 시 새로고침
	    $('#date').change(function() {
	    	selectedDate = $('#date').val();
        	fn_MainInfo_List(selectedDate);
        });
    });

    function fn_MainInfo_List(date) {
        $.ajax({
            type: "POST",
            url: "<%=Config.this_SERVER_path%>/Contents/Business/M707/S707S010800.jsp", 
            data: "date=" + date,
            beforeSend: function () {
                $("#MainInfo_List_contents").children().remove();
            },
            success: function (html) {
            	$("#MainInfo_List_contents").hide().html(html).fadeIn(100);
            }
        });
    }

</script>
    
   

<!-- Content Header (Page header) -->
<div class="content-header">
  <div class="container-fluid">
    <div class="row mb-2">
      <div class="col-sm-6">
        <h1 class="m-0 text-dark" id="MenuTitle">여기에 메뉴 타이틀</h1>
      </div><!-- /.col -->
      <div class="col-sm-6">
      	<div class="float-sm-right">
      		<!-- needtocheck, 나중에 구현할 예정 -->
      		<!-- <button type="button" onclick="" 
      				id="insert" class="btn btn-outline-dark">온도 상세 조회</button> -->
      	</div>
      </div><!-- /.col -->
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
          	  <div class="input-group input-group-sm" id="dateParent">
          	  	<div class="input-group-prepend">
          	  	  <button type="submit" class="btn btn-default">
          	  	    <i class="fa fas-calendar"></i>
          	  	  </button>
          	  	</div>
          	  	<input type="text" class="form-control float-right" id="date">
          	  </div>
          	</div>
          </div>
          <div class="card-body" id="MainInfo_List_contents"></div>
        </div>
      </div>
      <!-- /.col-md-6 -->
    </div>
    <!-- /.row -->
  </div><!-- /.container-fluid -->
</div>
<!-- /.content -->