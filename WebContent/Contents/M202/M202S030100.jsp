<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*,java.util.*,javax.servlet.http.*"%>
<%@ page import="mes.client.comm.*" %>
<%@ page import="mes.client.common.*" %>
<%@ page import="mes.client.guiComponents.*" %>
<%@ page import="mes.client.util.*" %>
<%@ page import="mes.client.conf.*" %>
<%
/* 
검수원부자재입고관리(M202S030100)
 */
	String loginID = session.getAttribute("login_id").toString();
	if(loginID == null || loginID.equals("")) {         // id가 Null 이거나 없을 경우
		response.sendRedirect("Contents/index.jsp");	// 로그인 페이지로 리다이렉트 한다.
	}

	String sMenuTitle = request.getParameter("MenuTitle").toString();
	String sProgramId = request.getParameter("programId").toString();
	String sHeadmenuID = request.getParameter("HeadmenuID").toString();
	String sHeadmenuName = request.getParameter("HeadmenuName").toString();
	
	Get_Program_button_Autho prg_autho = new Get_Program_button_Autho(loginID,sProgramId);	

	CurrentPage jspPageName = new CurrentPage(request.getRequestURI());
	String JSPpage = jspPageName.GetJSP_FileName();
	ProcesStatusCheck prcStatusCheck = new ProcesStatusCheck(JSPpage+"|"+"ODPROCS"+"|");
	
	String GV_PROCESS_MODIFY = prcStatusCheck.GV_PROCESS_MODIFY;
	String GV_PROCESS_DELETE = prcStatusCheck.GV_PROCESS_DELETE;
	String GV_GET_NUM_PREFIX = prcStatusCheck.GV_PROCESS_NUMBER_GUBUN;
%>

<!-- Content Header (Page header) -->
<div class="content-header">
  <div class="container-fluid">
    <div class="row mb-2">
      <div class="col-sm-6">
        <h1 class="m-0 text-dark" id="MenuTitle">여기에 메뉴 타이틀</h1>
      </div>
      <div class="col-sm-6">
      	<div class="float-sm-right">
      		<button type="button" onclick="pop_fn_PartIpgo_Insert(this)" id="insert" class="btn btn-outline-dark">자재입고등록</button>
      		<button type="button" onclick="haccpInsert(this)" 
			  		  id="haccp_insert" class="btn btn-outline-info">
				입고 검사기록 등록
			</button>
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
          <div class="card-body" id="MainInfo_List_contents"></div> 
        </div>
      </div>
      <!-- /.col-md-6 -->
    </div>
    <!-- /.row -->
  </div><!-- /.container-fluid -->
</div>
<!-- /.content -->
    
<script type="text/javascript">
	
	var vTraceKey = "";
	var vBaljuNo = "";	//발주번호
	var vPartcd = "";
	var vPartRevNo = "";
	var vBaljuRevNo = "";
	var vPartNm = "";
	var vBaljuAmt = "";
	
	var vBaljuStatus = "";
	var vDocRegistYn = "";
	
	var startDate;
	var endDate;
	
    $(document).ready(function () {	

    	var rangedate = new SetRangeDate("dateParent", "dateRange", 180);
		
		startDate = rangedate.start.format('YYYY-MM-DD');
		endDate = rangedate.end.format('YYYY-MM-DD');
	    
		fn_MainInfo_List(startDate, endDate);
	  
		$("#InfoContentTitle").html("발주 원부재료/부자재 목록");
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
        if ($("#SubInfo_List_contents").children().length > 0) {
            //$("#SubInfo_List_contents").children().remove();
        }
        if ($("#ProcessInfo_seolbi").children().length > 0) {
            $("#ProcessInfo_seolbi").children().remove();
        }
        if ($("#ProcessInfo_sibang").children().length > 0) {
            $("#ProcessInfo_sibang").children().remove();
        }
        if ($("#ProcessInfo_processcheck").children().length > 0) {
            $("#ProcessInfo_processcheck").children().remove();
        }   
    }
    
    function fn_MainInfo_List(startDate, endDate) {
        
		var custcode = "";
        
        $.ajax({
            type: "POST",
            url: "<%=Config.this_SERVER_path%>/Contents/Business/M202/S202S030100.jsp",
            data: "custcode=" + custcode + "&From=" + startDate + 
            	  "&To=" + endDate + "&JSPpage=" + "<%=JSPpage%>",
            beforeSend: function () {
				$("#MainInfo_List_contents").children().remove();
            },
            success: function (html) {
                $("#MainInfo_List_contents").hide().html(html).fadeIn(100);
            }
        });
        
        $("#SubInfo_List_contents").children().remove();
    }
	
    // 자재입고 등록
    function pop_fn_PartIpgo_Insert(obj) {
    	console.log(vBaljuNo);
    	
    	if(vBaljuNo.length < 1) {
			heneSwal.warning("입고정보 목록을 선택하세요");
			return false;
		}
    	
    	var url = "<%=Config.this_SERVER_path%>/Contents/Business/M202/S202S030101.jsp"
				   + "?TraceKey=" + vTraceKey
				   + "&BaljuNo=" + vBaljuNo
				   + "&PartCd=" + vPartCd
				   + "&PartRevNo=" + vPartRevNo
				   + "&BaljuRevNo=" + vBaljuRevNo
				   + "&PartNm=" + vPartNm
				   + "&BaljuAmt=" + vBaljuAmt;
    	
		var footer = '<button id="btn_Save" class="btn btn-info" onclick="SaveOderInfo();">입고저장</button>';
		var title = obj.innerText;
		var heneModal = new HenesysModal(url, 'standard', title, footer);
		heneModal.open_modal();
    }
    
    // 등록
    function haccpInsert(obj) {
    	
    	if(vBaljuNo.length < 1){
    		heneSwal.warning('검사할 입고목록를 선택하세요');
    		return false;
    	}
    	
    	var haccp_div = vPartCd.substr(0,1);
    	
    	if(haccp_div == "A"){
    		
    		var url = "<%=Config.this_SERVER_path%>/Contents/Business/M838/S838S070701.jsp"
				+ '?checklist_id=checklist29'
				+ "&balju_no=" + vBaljuNo
    			+ "&part_cd="  + vPartCd;
    		
    		var size = "large";
    		
    	} else if(haccp_div == "B"){
    		
    		var url = "<%=Config.this_SERVER_path%>/Contents/Business/M838/S838S070101.jsp"
				+ '?checklist_id=checklist11'
				+ "&balju_no=" + vBaljuNo
    			+ "&part_cd="  + vPartCd;
    		
    		var size = "standard";
    	}
    	
		var footer = '<button id="btn_Save" class="btn btn-info" onclick="SendTojsp();">저장</button>';
		var title = obj.innerText;
		var heneModal = new HenesysModal(url, size, title, footer);
		heneModal.open_modal();
    }
</script>