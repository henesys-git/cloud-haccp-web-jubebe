<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*,java.util.*,javax.servlet.http.*"%>
<%@ page import="mes.client.comm.*" %>
<%@ page import="mes.client.guiComponents.*" %>
<%@ page import="mes.client.util.*" %>
<%@ page import="mes.client.conf.*" %>
<!-- 
노무정보관리 (M909S200100)
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
 
 var vStandard_yearmonth = "";
 var vStandard_date = "";
 var vWorker_count = "";
 var vWorking_day_count = "";
 var vWorking_cost_hour = "";
 var vWorking_cost_day = "";
 var vWorking_cost_month = "";
 var vDuration_time_all = "";
 var vWorking_cost_all = "";
 var vWorking_cost_all_real = "";
 var vDirect_cost = "";
 var vIndirect_cost = "";
 var vProd_cost_all = "";
 var vBigo = "";
 var vWorking_rev_no = "";
 
    $(document).ready(function () {
		
    	new SetRangeDate("dateParent", "dateRange", 180);
	      
 		startDate = $('#dateRange').data('daterangepicker').startDate.format('YYYY-MM-DD');
 		endDate = $('#dateRange').data('daterangepicker').endDate.format('YYYY-MM-DD');
 		fn_MainInfo_List(startDate, endDate);
	
		$("#InfoContentTitle").html("노무정보 입력");
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

    function fn_clearList() {
        if ($("#MainInfo_List_contents").children().length > 0) {
            $("#MainInfo_List_contents").children().remove();
        }
    }
    
    //노무정보관리 메인페이지
    function fn_MainInfo_List(startDate, endDate) {
        
        $.ajax({
            type: "POST",
            url: "<%=Config.this_SERVER_path%>/Contents/Business/M909/S909S200100.jsp",
            data: "From=" + startDate + 
      	  			"&To=" + endDate,
            success: function (html) {
                $("#MainInfo_List_contents").hide().html(html).fadeIn(100);
            }
        });
        
    }
    
  //노무정보관리 서브페이지
    function fn_DetailInfo_List() {    	
        
        $.ajax({
            type: "POST",
            url: "<%=Config.this_SERVER_path%>/Contents/Business/M909/S909S200110.jsp",
            data: "standard_yearmonth=" + vStandard_yearmonth + "&working_rev_no=" + vWorking_rev_no,
            success: function (html) {
                $("#SubInfo_List_contents").hide().html(html).fadeIn(100);
            }
        });
    }

    
    // 노무정보 입력
    function insertWorkInfo(obj) {
    	
		var url = "<%=Config.this_SERVER_path%>/Contents/Business/M909/S909S200101.jsp";
		var footer = '<button id="btn_Save" class="btn btn-info" onclick="SaveOderInfo();">등록</button>';
		var title = obj.innerText;
		var heneModal = new HenesysModal(url, 'large', title, footer);
		heneModal.open_modal();
    }
    
    // 노무정보 수정
    function updateWorkInfo(obj) {
    	
    	if(vStandard_date.length < 1){
    		heneSwal.warning('수정할 노무정보를 선택하세요.');
			return false;
		}
    	
    	
		var url = "<%=Config.this_SERVER_path%>/Contents/Business/M909/S909S200102.jsp"
				+"?standard_date=" + vStandard_date
				+"&standard_yearmonth=" + vStandard_yearmonth
				+"&worker_count=" + vWorker_count
				+"&working_day_count=" + vWorking_day_count
				+"&duration_time_all=" + vDuration_time_all
				+"&working_cost_all_real=" + vWorking_cost_all_real
				+"&indirect_cost=" + vIndirect_cost
				+"&prod_cost_all=" + vProd_cost_all
				+"&bigo=" + vBigo
				+"&working_rev_no=" + vWorking_rev_no;
		var footer = '<button id="btn_Save" class="btn btn-info" onclick="SaveOderInfo();">수정</button>';
		var title = obj.innerText;
		var heneModal = new HenesysModal(url, 'large', title, footer);
		heneModal.open_modal();
    }
    
    // 노무정보 삭제
    function deleteWorkInfo(obj) {
    	if(vStandard_date.length < 1){
    		heneSwal.warning('삭제할 노무정보를 선택하세요.');
			return false;
		}
    	
    	var M909S200100E103 = {
    			PID:  "M909S200100E103", 
    			totalcnt: 0,
    			retnValue: 999,
    			colcnt: 0,
    			colname: ["","","",""], //insert, Update, Delete 문장을 처리할 때는 사용되지않음
    			data: []
    	};  
    	
    	var SQL_Param = {
    			PID:  "M909S200100E103",
    			excute: "queryProcess",
    			stream: "N",
    			param: ""
    	};
    	var GV_RECV_DATA = "";
    	
    	
    	var dataJson = new Object();
    	dataJson.Standard_Yearmonth 	= vStandard_yearmonth;
    	
    	var JSONparam = JSON.stringify(dataJson);
    	
    	var chekrtn = confirm("해당 정보를 삭제하시겠습니까?");
    	if(chekrtn){
    	sendToJsp(JSONparam, SQL_Param.PID);
    	 } else{
    	}
    }	
    
      function sendToJsp(bomdata, pid){
    	$.ajax({
    		type : "POST",
    		dataType : "json",
    		url : "<%=Config.this_SERVER_path%>/Contents/CommonView/insert_update_delete_json.jsp",
    		data: {"bomdata" : bomdata, "pid" : pid},
 	        success: function (rcvData) {
 	        	if(rcvData > -1) {
 	        		heneSwal.success("해당 정보가 삭제되었습니다.");
 	        		parent.fn_MainInfo_List(toDate);
 	        		
 	        	} else {
 	        		heneSwal.error("정보 삭제에 실패했습니다, 다시 시도해주세요");
 		        	parent.fn_MainInfo_List(toDate);
 	        	}
 	        },
 	        error : function(){
 	        	heneSwal.error("정보 삭제에 실패했습니다, 다시 시도해주세요");
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
		      	<div class="float-sm-right">
		      	  	<button type="button" onclick="insertWorkInfo(this)" id="insert" class="btn btn-outline-dark">노무정보등록</button>
		      	 	<button type="button" onclick="updateWorkInfo(this)" id="update" class="btn btn-outline-success">노무정보수정</button>
		      	  	<button type="button" onclick="deleteWorkInfo(this)" id="delete" class="btn btn-outline-danger">노무정보삭제</button>
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
	          	  			<div class="input-group input-group-sm" id="dateParent">
	          	  				<input type="text" class="form-control float-right" id="dateRange">
		          	  			<div class="input-group-append">
		          	  	  			<button type="submit" class="btn btn-default">
		          	  	    			<i class="fas fa-search"></i>
		          	  	  			</button>
		          	  			</div>
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
	   			<i class="fas fa-edit">월별 노무소요시간</i>
	   		</h3>
	   	</div>
	   	<div class="card-body" id="SubInfo_List_contents">
	   	</div>
	</div>
  </div><!-- /.container-fluid -->
</div>
<!-- /.content -->