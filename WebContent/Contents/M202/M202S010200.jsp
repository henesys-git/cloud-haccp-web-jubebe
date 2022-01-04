<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, java.util.*, javax.servlet.http.*"%>
<%@ page import="mes.client.comm.*" %>
<%@ page import="mes.client.common.*" %>
<%@ page import="mes.client.guiComponents.*" %>
<%@ page import="mes.client.util.*" %>
<%@ page import="mes.client.conf.*" %>
<%
/* 
자재발주등록(M202S010200.jsp)
yumsam used
- 주석 처리된 버튼 기능들 확인하고 없애던지 마무리 짓기 
- makeQueueList 때문에 sql 에러 발생
(20201210 최현수) needtocheck
 */
	String loginID = session.getAttribute("login_id").toString();
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
	
	String GV_PROCESS_MODIFY = prcStatusCheck.GV_PROCESS_MODIFY;
	String GV_PROCESS_DELETE = prcStatusCheck.GV_PROCESS_DELETE;
	String GV_GET_NUM_PREFIX = prcStatusCheck.GV_PROCESS_NUMBER_GUBUN;

	makeQueueList MainQueue = new makeQueueList(JSPpage);
%>
	
<script type="text/javascript">
	var vOrderNo = "";
	var vOrderDetailSeq = "";
	
 	var vBalju_no = "";
 	var vBaljuRevNo = "";
 	var vBalju_status = "";
 	var vBalju_send_date = "";
 	var vBalju_nabgi_date = "";
 	var vTraceKey = "";
 	var vprod_cd = "";
 	var vproduct_nm = "";
 	var vCust_nm = "";
 	var vbom_no = "";
	var vJSPpage = '<%=JSPpage%>';
	var vTelNo = "";
	var vNote = "";
	var vCust_cd = "";			
	var vCust_rev_no = "";
	var vPart_cd = "";
	var vPart_rev_no = "";
	var vBalju_amt = "";
	
	var startDate;
	var endDate;
	
    $(document).ready(function () {
    		
    	var date = new SetRangeDate("dateParent", "dateRange", 30);
    	startDate = date.start.format('YYYY-MM-DD');
       	endDate = date.end.format('YYYY-MM-DD');
	    
       	fn_MainInfo_List(startDate, endDate);
    	
		$("#InfoContentTitle").html("원부자재 발주현황");
		
        makeMainQueue("<%=MainQueue.GetQueueList()%>");
        
        fn_MainSubMenuSelect("<%=sMenuTitle%>");
        
        $('#dateRange').change(function() {
           	fn_MainInfo_List(startDate, endDate);
        });
    });

    function fn_clearList() { 
        if ($("#MainInfo_List_contents").children().length > 0) {
            $("#MainInfo_List_contents").children().remove();
        }
        if ($("#SubInfo_List_contents").children().length > 0) {
            //$("#SubInfo_List_contents").children().remove();
        }        
        if ($("#SubInfo_bom").children().length > 0) {
            $("#SubInfo_bom").children().remove();
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
            url: "<%=Config.this_SERVER_path%>/Contents/Business/M202/S202S010200.jsp", 
            data: "custcode=" + custcode + "&From=" + startDate + 
            	  "&To=" + endDate + "&JSPpage=" + vJSPpage,
            beforeSend: function () {
                $("#MainInfo_List_contents").children().remove();
            },
            success: function (html) {
            	$("#MainInfo_List_contents").hide().html(html).fadeIn(100);
            }
        });
        
        $("#SubInfo_List_contents").children().remove();
    }
    
	function fn_DetailInfo_List() { 
    	$.ajax({
   	        type: "POST",
   	        url: "<%=Config.this_SERVER_path%>/Contents/Business/M202/S202S010210.jsp",
   	        data: "BaljuNo=" + vBalju_no + "&BaljuRevNo=" + vBaljuRevNo + "&TraceKey=" + vTraceKey,
    	    success: function (html) {
    	    	$("#SubInfo_List_contents").hide().html(html).fadeIn(100);
    	    }
    	});
		return;
	}

    //발주서등록
    function pop_fn_BauljuInfo_Insert(obj) {
    	var url = "<%=Config.this_SERVER_path%>/Contents/Business/M202/S202S010201.jsp?OrderNo=" + "NON"
    			+ "&order_detail_seq=" +vOrderDetailSeq
    			+ "&jspPage=" + "<%=JSPpage%>"
    			+ "&num_gubun=<%=GV_GET_NUM_PREFIX%>"
    			+ "&product_nm=" +vProdNm
    			+ "&cust_nm=" +vCustName
    			;
    	var footer = '<button type="button" class="btn btn-outline-primary" onclick="SaveOderInfo();">발주서저장</button>'
    	var title = obj.innerText;
		var heneModal = new HenesysModal(url, 'xlarge', title, footer);
		heneModal.open_modal();
    }

    //발주서수정
    function pop_fn_BauljuInfo_Update(obj) {  	
    	var modalContentUrl;
    	if(vBalju_no.length < 1) {
			heneSwal.warning('수정할 발주서를 선택해주세요')
    		return false;
		}
    	if(vBalju_status != '대기'){
    		heneSwal.warning('대기상태의 발주서만 수정가능합니다.')
    		return false;
    	}
    	
    	var url = "<%=Config.this_SERVER_path%>/Contents/Business/M202/S202S010202.jsp"
    				+ "?OrderNo=" + vOrderNo
					+ "&BaljuNo=" + vBalju_no
					+ "&CustNm=" + vCust_nm
					+ "&Telno=" + vTelNo
					+ "&Balju_send_date=" + vBalju_send_date
					+ "&Balju_nabgi_date=" + vBalju_nabgi_date
					+ "&Note=" + vNote
					+ "&CustCd=" + vCust_cd
					+ "&CustRevNo=" + vCust_rev_no
    				+ "&PartCd=" + vPart_cd
    				+ "&PartRevNo=" + vPart_rev_no
    				+ "&BaljuAmt=" + vBalju_amt
    				+ "&TraceKey=" + vTraceKey
    				+ "&Balju_status=" + vBalju_status
    				+ "&BaljuRevNo=" + vBaljuRevNo
    				
    				
		var footer = '<button id="btn_Save" class="btn btn-info" onclick="SaveOderInfo();">발주서수정</button>'
		var title = obj.innerText;
		var heneModal = new HenesysModal(url, 'xlarge', title, footer);
		heneModal.open_modal();
     }
 	
    //발주서 삭제
 	function fn_BaljuInfo_Delete(obj){
 		var modalContentUrl;
    	if(vBalju_no.length < 1){
			heneSwal.warning('삭제할 발주서를 선택해주세요')
			return false;
		}
    	if(vBalju_status != '대기'){
    		heneSwal.warning('대기상태의 발주서만 삭제가능합니다.')
    		return false;
    	}
    	
    	var M202S010100E203 = {
    			PID:  "M202S010100E203", 
    			totalcnt: 0,
    			retnValue: 999,
    			colcnt: 0,
    			colname: ["","","",""], //insert, Update, Delete 문장을 처리할 때는 사용되지않음
    			data: []
    	};  
    	
    	var SQL_Param = {
    			PID:  "M202S010100E203",
    			excute: "queryProcess",
    			stream: "N",
    			param: ""
    	};
    	var GV_RECV_DATA = "";
    	
    	
    	var dataJson = new Object();
    	dataJson.balju_no = vBalju_no;
    	dataJson.balju_rev_no = vBaljuRevNo;
    	
    	var JSONparam = JSON.stringify(dataJson);
    	
    	var chekrtn = confirm("발주서를 삭제하시겠습니까?");
    	if(chekrtn){
    	sendToJsp(JSONparam, SQL_Param.PID);
    	 } else{
    	}
      }
 	
 	function sendToJsp(bomdata, pid){
		$.ajax({
			type: "POST",
			dataType: "json",
	        url: "<%=Config.this_SERVER_path%>/Contents/CommonView/insert_update_delete_json.jsp", 
	        data: {"bomdata" : bomdata, "pid" : pid},
	        success: function (receive) {
				if(receive > -1) {
					heneSwal.success('발주 삭제가 완료되었습니다');
					parent.fn_MainInfo_List(startDate, endDate);
					 $("#SubInfo_List_contents").children().remove();
				} else {
					heneSwal.error('발주 삭제에 실패했습니다, 다시 시도해주세요');
				}
			},
			error: function() {
				heneSwal.error('발주 삭제에 실패했습니다, 다시 시도해주세요');
			}
		});
	}
 	
 	function SetRecvData(){
		DataPars(M202S010100E203,GV_RECV_DATA);  		
   		parent.fn_MainInfo_List();
	}
</script>
   
<!-- 캐시 비적용 -->
<meta http-equiv="Cache-Control" content="no-cache"/>
<meta http-equiv="Expires" content="0"/>
<meta http-equiv="Pragma" content="no-cache"/>

<!-- Content Header (Page header) -->
<div class="content-header">
  <div class="container-fluid">
    <div class="row mb-2">
      <div class="col-sm-6">
        <h1 class="m-0 text-dark" id="MenuTitle">여기에 메뉴 타이틀</h1>
      </div><!-- /.col -->
      <div class="col-sm-6">
      	<div class="float-sm-right">
      	 <button type="button" onclick="pop_fn_BauljuInfo_Insert(this)" id="insert" class="btn btn-outline-dark">발주서등록</button>
         <button type="button" onclick="pop_fn_BauljuInfo_Update(this)" id="update" class="btn btn-outline-success">발주서수정</button>
         <button type="button" onclick="fn_BaljuInfo_Delete(this)" id="delete" class="btn btn-outline-danger">발주서삭제</button>
         <!-- <button type="button" onclick="pop_fn_PartSoyo(this)" id="select" class="btn btn-outline-primary">원부자재 필요량 조회</button> -->
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
    
    <div class="card card-primary card-outline">
    	<div class="card-header">
    		<h3 class="card-title">
    			<i class="fas fa-edit">세부 정보</i>
    		</h3>
    	</div>
    	<div class="card-body">
    		<ul class="nav nav-tabs" id="custom-tabs-one-tab" role="tablist">
       			<li class="nav-item" onclick='fn_DetailInfo_List()'>
       				<a class="nav-link" id="DetailInfo_List" data-toggle="pill" href="#SubInfo_List_contents" role="tab">발주원부자재정보</a>
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