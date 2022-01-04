<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*,java.util.*,javax.servlet.http.*"%>
<%@ page import="mes.client.comm.*" %>
<%@ page import="mes.client.common.*" %>
<%@ page import="mes.client.guiComponents.*" %>
<%@ page import="mes.client.util.*" %>
<%@ page import="mes.client.conf.*" %>

<!-- 
KPI(제품별 불량률)
yumsam
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

    	var monthControl = document.querySelector('input[type="month"]');
    	monthControl.value = heneDate.getTodayYearMonth();
    	
    	console.log(monthControl.value);
    	
        fn_MainSubMenuSelect("<%=sMenuTitle%>");
        
		$("#InfoContentTitle").html("제품별 불량 조회");
		fn_MainInfo_List(monthControl.value);
		
		monthControl.onchange = function() {
			fn_MainInfo_List(monthControl.value);
		}
    });

    function fn_MainInfo_List(yearMonth) {
    	
        $.ajax({
            type: "POST",
            url: "<%=Config.this_SERVER_path%>/Contents/Business/M707/S707S020200.jsp"
            		+ "?yearMonth=" + yearMonth, 
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
        				<div class="card-tools">
        					<label for="start">조회 년월:</label>
							<input type="month" id="start" name="start">
      					</div>
					</div>
         			<div class="card-body" id="MainInfo_List_contents"></div> 
       			</div>
     		</div>
     		<!-- /.col-md-6 -->
   		</div>
   		<!-- /.row -->
    	<!-- <div class="card card-primary card-outline">
	    	<div class="card-header">
	    		<h3 class="card-title">
	    			<i class="fas fa-edit">세부 정보</i>
	    		</h3>
	    	</div>
	    	<div class="card-body">
	    		<ul class="nav nav-tabs" id="custom-tabs-one-tab" role="tablist">
		       		<li class="nav-item" onclick='fn_DetailInfo_List()'>
		       			<a class="nav-link" id="DetailInfo_List" data-toggle="pill" 
		       								href="#SubInfo_List_contents" role="tab">
		       				불량 합계 그래프
		       			</a>
		       		</li>
		        </ul>
		     	<div class="tab-content" id="custom-tabs-one-tabContent">
		     		<div class="tab-pane fade" id="SubInfo_List_contents" role="tabpanel">
		     		</div>
		     	</div>
		    </div>
    	</div> -->
	</div><!-- /.container-fluid -->
</div>
<!-- /.content -->