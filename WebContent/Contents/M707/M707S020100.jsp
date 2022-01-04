<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*,java.util.*,javax.servlet.http.*"%>
<%@ page import="mes.client.comm.*" %>
<%@ page import="mes.client.common.*" %>
<%@ page import="mes.client.guiComponents.*" %>
<%@ page import="mes.client.util.*" %>
<%@ page import="mes.client.conf.*" %>

<!-- 
모니터링 빈도
-->

<%
	String loginID = session.getAttribute("login_id").toString();
	String member_key = session.getAttribute("member_key").toString();
	if(loginID == null || loginID.equals("")) {         // id가 Null 이거나 없을 경우
		response.sendRedirect("Contents/index.jsp");    // 로그인 페이지로 리다이렉트 한다.
	}

	String sMenuTitle = request.getParameter("MenuTitle").toString();
	String sProgramId = request.getParameter("programId").toString();
	String sHeadmenuID= request.getParameter("HeadmenuID").toString();
	String sHeadmenuName= request.getParameter("HeadmenuName").toString();
	
	Get_Program_button_Autho prg_autho = new Get_Program_button_Autho(loginID,sProgramId);
	
	CurrentPage jspPageName = new CurrentPage(request.getRequestURI());
	String JSPpage = jspPageName.GetJSP_FileName();
	ProcesStatusCheck prcStatusCheck = new ProcesStatusCheck(JSPpage+"|"+"ODPROCS"+"|");
%>

<script type="text/javascript"> 
	
    $(document).ready(function () {
    	var heneDate = new HeneDate();
    	var selectDate = heneDate.getToday();
    	$("#date").val(selectDate);
    	var selectWeek = "";
    	
        fn_MainSubMenuSelect("<%=sMenuTitle%>");
        
		$("#InfoContentTitle").html("모니터링 빈도");
		fn_MainInfo_List(selectDate, selectWeek);
		
		$("#date").change(function() {
			selectDate = $(this).val();
			selectWeek = "";
			$("#week").val("");
			fn_MainInfo_List(selectDate, selectWeek);
		});
		
		$("#week").change(function() {
			selectWeek = $(this).val();
			selectDate = "";
			$("#date").val("");
			fn_MainInfo_List(selectDate, selectWeek);	
		});
		
    });

    function fn_MainInfo_List(selectDate, selectWeek) {
    	
        $.ajax({
            type: "POST",
            url: "<%=Config.this_SERVER_path%>/Contents/Business/M707/S707S020100.jsp"
            		+ "?selectDate=" + selectDate+"&selectWeek=" + selectWeek, 
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
	      	</div>
     			<div class="col-sm-6">
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
        				<div class="card-tools" style = "display: flex; align-items: baseline;">
        					<label for="date">일</label>
							<input type="date" id="date" name="date" class = "form-control" style = "margin: 0 9px;">
							<label for="week">주</label>
							<input type="week" id="week" name="week" class = "form-control" style = "margin: 0 9px;">
      					</div>
					</div>
         			<div class="card-body" id="MainInfo_List_contents"></div> 
       			</div>
     		</div><!-- /.col-md-6 -->
   		</div><!-- /.row -->
	</div><!-- /.container-fluid -->
</div>
<!-- /.content -->