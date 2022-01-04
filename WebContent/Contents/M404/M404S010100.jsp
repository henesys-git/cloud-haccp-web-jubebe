<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*,java.util.*,javax.servlet.http.*"%>
<%@ page import="mes.client.comm.*" %>
<%@ page import="mes.client.guiComponents.*" %>
<%@ page import="mes.client.util.*" %>
<%@ page import="mes.client.conf.*" %>
<%  	
	String loginID = session.getAttribute("login_id").toString();
	String member_key = session.getAttribute("member_key").toString();
	
	if(loginID==null||loginID.equals("")){                            			// id가 Null 이거나 없을 경우
		response.sendRedirect(Config.this_SERVER_path + "/Contents/index.jsp"); // 로그인 페이지로 리다이렉트 한다.
	}

	String sMenuTitle = request.getParameter("MenuTitle").toString();
	String sProgramId = request.getParameter("programId").toString();
	String sHeadmenuID= request.getParameter("HeadmenuID").toString();
	String sHeadmenuName= request.getParameter("HeadmenuName").toString();
	
	Get_Program_button_Autho prg_autho = new Get_Program_button_Autho(loginID,sProgramId);	
%>

<script type="text/javascript">
 	
 	//메인테이블 변수모음
 	var checklist_id 		= "checklist11";		
	var checklist_rev_no 	= 0;
	var ipgo_date 			= "";
	var ipgo_part_count  	= "";
	var person_write_id  	= "";
	var person_writer  	    = "";
	var person_approve_id  	= "";
	var person_approver  	= "";
 	var unsuit_detail 		= "";
 	var improve_action 		= "";
	
	//서브테이블 변수모음
	var s_checklist_id 		= "";		
	var s_checklist_rev_no  = "";	
	var seq_no 				= "";
	var s_ipgo_date 		= "";	
	var part_cd 			= "";	
	var part_rev_no 		= "";
	var part_nm 			= "";
	var supplier 			= "";
	var ipgo_amount 		= "";
	var trace_key 			= "";
	var standard_yn 		= "";
	var packing_status 		= "";
	var visual_inspection 	= "";
	var temp_cold 			= "";
	var temp_freeze 		= "";
	var temp_room			= "";
	var car_clean 			= "";
	var docs_yn 			= "";
	var unsuit_action		= "";
	var check_yn 			= "";
	var expiration_date 	= "";
	
	var startDate;
	var endDate;
 	
    $(document).ready(function () {
    	var date = new SetRangeDate("dateParent", "dateRange", 30);
		startDate = date.start.format('YYYY-MM-DD');
	    endDate = date.end.format('YYYY-MM-DD');

	    fn_MainInfo_List(startDate, endDate);
		
		$("#InfoContentTitle").html("입고검사대장 조회");
		fn_MainSubMenuSelect("<%=sMenuTitle%>");        	
		fn_tagProcess();
		
		$('#dateRange').change(function() {
			fn_MainInfo_List(startDate, endDate);
		});
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
        
    function fn_MainInfo_List(startDate, endDate) {
        $.ajax({
            type: "POST",
            url: "<%=Config.this_SERVER_path%>/Contents/Business/M404/S404S010100.jsp",
            data: "From=" + startDate + "&To=" + endDate,
            success: function (html) {
                $("#MainInfo_List_contents").hide().html(html).fadeIn(100);
            }
        });
        $("#SubInfo_List_contents").children().remove(); 
    }
    
    function fn_DetailInfo_List() {     
    	$.ajax({
   	    	type: "POST",
   	        url: "<%=Config.this_SERVER_path%>/Contents/Business/M404/S404S010110.jsp",
   	        data: "ipgo_date=" + ipgo_date +
   	     		  "&checklist_id=" + checklist_id +
   	     		  "&checklist_rev_no=" + checklist_rev_no,
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
						          	  	<input type="text" class="form-control float-right" id="dateRange">
						          	  	<div class="input-group-append">
						          	  	  <button type="submit" class="btn btn-default">
						          	  	    <i class="fas fa-calendar"></i>
						          	  	  </button>
						          	  	</div>
	          	  					</div>
	          					</div>
         					</div>
          				<div class="card-body" id="MainInfo_List_contents"></div> 
        			</div>
      			</div>
      			<!-- /.col-md-6 -->
    </div>
    <!-- /.row -->
    <div class="card card-primary card-outline">
    	<div class="card-header">
    		<h3 class="card-title">
    			<i class="fas fa-edit">관리대장 명단</i>
    		</h3>
    		<div class="card-tools">      	  
          	</div>
    	</div>
    	<div class="card-body">
    		<ul class="nav nav-tabs" id="custom-tabs-one-tab" role="tablist">
	       		<li class="nav-item" onclick='fn_DetailInfo_List()'>
	       			<a class="nav-link" id="DetailInfo_List" data-toggle="pill" href="#SubInfo_List_contents" role="tab">상세정보</a>
	       		</li>
	        </ul>
	     	<div class="tab-content" id="custom-tabs-one-tabContent">
	     		<div class="tab-pane fade" id="SubInfo_List_contents" role="tabpanel"></div>
	     	</div>
	    </div>
    </div>
  </div><!-- /.container-fluid -->
</div>
<!-- /.content -->