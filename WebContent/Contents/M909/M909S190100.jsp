<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*,java.util.*,javax.servlet.http.*"%>
<%@ page import="mes.client.comm.*" %>
<%@ page import="mes.client.guiComponents.*" %>
<%@ page import="mes.client.util.*" %>
<%@ page import="mes.client.conf.*" %>
<!-- 

원가관리(M909S190100)
yumsam
-->

<%  
	String loginID = session.getAttribute("login_id").toString();
	String member_key = session.getAttribute("member_key").toString();
	if(loginID==null||loginID.equals("")){                            				// id가 Null 이거나 없을 경우
		response.sendRedirect(Config.this_SERVER_path + "/Contents/index.jsp");    	// 로그인 페이지로 리다이렉트 한다."NON"
	}

	String sMenuTitle = request.getParameter("MenuTitle").toString();
	String sProgramId = request.getParameter("programId").toString();
	String sHeadmenuID= request.getParameter("HeadmenuID").toString();
	String sHeadmenuName= request.getParameter("HeadmenuName").toString();
	
	Get_Program_button_Autho prg_autho = new Get_Program_button_Autho(loginID, sProgramId);	
	
	CurrentPage jspPageName = new CurrentPage(request.getRequestURI());
	String JSPpage = jspPageName.GetJSP_FileName();
	ProcesStatusCheck prcStatusCheck = new ProcesStatusCheck(JSPpage+"|"+"ODPROCS"+"|");

	String GV_PROCESS_MODIFY	= prcStatusCheck.GV_PROCESS_MODIFY;
	String GV_PROCESS_DELETE	= prcStatusCheck.GV_PROCESS_DELETE;
	String GV_PROCESS_NAME		= prcStatusCheck.GV_PROCESS_NAME;
	String GV_GET_NUM_PREFIX	= prcStatusCheck.GV_PROCESS_NUMBER_GUBUN;
%>

<script>
  var vStandard_date = "";
  var yearMonth = "";
  
    $(document).ready(function () {
		
    	var heneDate = new HeneDate();
    	
    	var monthControl = document.querySelector('input[type="month"]');
    	monthControl.value = heneDate.getTodayYearMonth();
		
    	var yearMonth = monthControl.value
    	
		fn_MainInfo_List(monthControl.value);
		console.log(monthControl.value);
		$("#InfoContentTitle").html("원가정보 요약");
 		fn_MainSubMenuSelect("<%=sMenuTitle%>");
		fn_tagProcess();
		
		monthControl.onchange = function() {
           	fn_MainInfo_List(monthControl.value);
        };
    });

    function fn_tagProcess(){
    	
    	var vSelect = <%=prg_autho.vSelect%>;
    	var vInsert = <%=prg_autho.vInsert%>;
    	var vUpdate = <%=prg_autho.vUpdate%>;
    	var vDelete = <%=prg_autho.vDelete%>;

		if(vSelect == "0") {
	    	$('button[id="select"]').each(function () {
                $(this).prop("disabled",true);
            });
   		}
		if(vInsert == "0") {
	    	$('button[id="insert"]').each(function () {
                $(this).prop("disabled",true);
            });
   		}
		if(vUpdate == "0") {
	    	$('button[id="update"]').each(function () {
                $(this).prop("disabled",true);
                $(this).attr("onclick", " ");
            });
   		}
		if(vDelete == "0") {
	    	$('button[id="delete"]').each(function () {
                $(this).prop("disabled",true);

            });
   		}
    }

    function fn_clearList() {
        if ($("#MainInfo_List_contents").children().length > 0) {
            $("#MainInfo_List_contents").children().remove();
        }
    }
    
    //원가관리 메인페이지
    function fn_MainInfo_List(a) {
        
        $.ajax({
            type: "POST",
            url: "<%=Config.this_SERVER_path%>/Contents/Business/M909/S909S190100.jsp",
            data: "yearMonth=" + a,
            success: function (html) {
                $("#MainInfo_List_contents").hide().html(html).fadeIn(100);
            }
        });
        
        $("#SubInfo_List_contents").children().remove();
    }

    
    //원가관리 서브페이지
    function fn_DetailInfo_List() {    	
        
        $.ajax({
            type: "POST",
            url: "<%=Config.this_SERVER_path%>/Contents/Business/M909/S909S190110.jsp",
            data: "standard_date=" + standard_date, 
            success: function (html) {
                $("#SubInfo_List_contents").hide().html(html).fadeIn(100);
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
	          	  			<div class="input-group input-group-sm" id="dateParent">
	          	  			<label for="dataRange">조회 년월:</label>
	          	  				<input type="month" class="form-control float-right" id="dateRange">
	          	  			</div>
          				</div>
					</div>
          			<div class="card-body" id="MainInfo_List_contents">
          			</div> 
				</div>
			</div>
		<!-- /.col-md-6 -->
		</div>
	<!-- /.row -->
	<div class="card card-primary card-outline">
	   	<div class="card-header">
	   		<h3 class="card-title">
	   			<i class="fas fa-edit">월별 원가 정보</i>
	   		</h3>
	   	</div>
	   	<div class="card-body" id="SubInfo_List_contents">
	   	</div>
	</div>
  </div><!-- /.container-fluid -->
</div>
<!-- /.content -->