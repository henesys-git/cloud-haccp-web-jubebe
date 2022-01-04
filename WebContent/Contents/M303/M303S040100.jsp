<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*,java.util.*,javax.servlet.http.*"%>
<%@ page import="mes.client.comm.*" %>
<%@ page import="mes.client.common.*" %>
<%@ page import="mes.client.guiComponents.*" %>
<%@ page import="mes.client.util.*" %>
<%@ page import="mes.client.conf.*" %>
<%
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
%>  

<script type="text/javascript">
	var vProductNm = "";
	var vGugyuk = "";
	var vManufacturingDate = "";
	var vRequestRevNo = "";
	var vProdPlanDate = "";
	var vPlanAmount = "";
	var vPlanNote = "";
	var vPlanRevNo = "";
	var vProdCd = "";
	var vProdRevNo = "";
	var vExpirationDate = 0;
	var vWorkStatus = "";
	var vPlanAmount	= "";
	var vExpirationDate	= "";
	var vLossRate = "";
	var vTotalBlendingAmount = "";
	var vNote = "";
	
	var startDate;
	var endDate;
	
    $(document).ready(function () {
    	
    	var date = new SetRangeDate("dateParent", "dateRange", 7);
    	startDate = date.start.format('YYYY-MM-DD');
       	endDate = date.end.format('YYYY-MM-DD');
       	
	    fn_MainInfo_List(startDate, endDate);
	    
		$("#InfoContentTitle").html("생산작업 요청서 목록");
	    fn_MainSubMenuSelect("<%=sMenuTitle%>");
	    
	    $('#dateRange').change(function() {
           	fn_MainInfo_List(startDate, endDate);
        });
    });

    function fn_MainInfo_List(startDate, endDate) {
        
        $.ajax({
            type: "POST",
            url: "<%=Config.this_SERVER_path%>/Contents/Business/M303/S303S040100.jsp",
            data: "From=" + startDate + "&To=" + endDate,
            beforeSend: function () {
				$("#MainInfo_List_contents").children().remove();
            },
            success: function (html) {
                $("#MainInfo_List_contents").hide().html(html).fadeIn(100);
            }
        });
        
        $("#SubInfo_List_contents").children().remove();
        $("#SubInfo_List_Doc").children().remove();
        $("#SubInfo_BOM").children().remove(); 
    }
    
	function fn_DetailInfo_List() {     
    	$.ajax({
   	    	type: "POST",
   	        url: "<%=Config.this_SERVER_path%>/Contents/Business/M303/S303S040110.jsp",
   	        data: "requestRevNo=" + vRequestRevNo + "&prodPlanDate=" + vProdPlanDate +
   	        	  "&planRevNo=" + vPlanRevNo + "&prodCd=" + vProdCd +
   	        	  "&prodRevNo=" + vProdRevNo + "&manufacturingDate=" + vManufacturingDate,
   	        success: function (html) {
   	            $("#SubInfo_List_contents").hide().html(html).fadeIn(100);
   	        }
   	    });
	}

    //작업지시등록
    function pop_fn_prod_req_Insert(obj) {
    	
    	var url = "<%=Config.this_SERVER_path%>/Contents/Business/M303/S303S040101.jsp";
    	var footer = '<button id="btn_Save" class="btn btn-info"' +
		 					 'onclick="SaveOderInfo();">저장</button>';
    	var title = '생산작업 지시서 등록';
    	var heneModal = new HenesysModal(url, 'xlarge', title, footer);
    	heneModal.open_modal();
    }
    
    //작업지시수정
    function pop_fn_prod_req_Update(obj){
     
    	if(vProductNm.length < 1) {
			heneSwal.error("수정할 지시서를 선택하세요");
			return false;
		}
    	
    	if(vWorkStatus != '요청') {
			heneSwal.error("요청 상태의 지시서만 수정 가능합니다");
			return false;
		}
    	
    	var url = "<%=Config.this_SERVER_path%>/Contents/Business/M303/S303S040102.jsp?"
    			  + "prod_plan_date=" + vProdPlanDate
    			  + "&plan_rev_no=" + vPlanRevNo
    			  + "&product_nm=" + vProductNm
    			  + "&gugyuk=" + encodeURIComponent(vGugyuk)
    			  + "&manufacturing_date=" + vManufacturingDate
    			  + "&expiration_date=" + vExpirationDate
    			  + "&plan_amount=" + vPlanAmount
    			  + "&loss_rate=" + vLossRate
    			  + "&total_blending_amount=" + vTotalBlendingAmount
    			  + "&note=" + vNote
    			  + "&prod_cd=" +vProdCd
    			  + "&prod_rev_no=" +vProdRevNo
    			  + "&request_rev_no=" +vRequestRevNo;
    	
    	var footer = '<button id="btn_Save" class="btn btn-info"' +
		 					 'onclick="SaveOderInfo();">수정</button>';
    	var title = '생산작업 지시서 수정';
    	var heneModal = new HenesysModal(url, 'xlarge', title, footer);
    	heneModal.open_modal();  	
    }
    
    //작업지시삭제
    function pop_fn_prod_req_Delete(obj) {
    	
    	if(vProductNm.length < 1){
			heneSwal.error("삭제할 지시서를 선택하세요 ");
			return false;
		}
    	
    	if(vWorkStatus != '요청'){
			heneSwal.error("요청 상태의 지시서만 삭제 가능합니다");
			return false;
		}
		
    	var M303S040100E203 = {
    			PID:  "M303S040100E103", 
    			totalcnt: 0,
    			retnValue: 999,
    			colcnt: 0,
    			colname: ["","","",""], //insert, Update, Delete 문장을 처리할 때는 사용되지않음
    			data: []
    	};  
    	
    	var SQL_Param = {
    			PID:  "M303S040100E103",
    			excute: "queryProcess",
    			stream: "N",
    			param: ""
    	};
    	
    	var GV_RECV_DATA = "";
    	
    	var dataJson = new Object();
    	dataJson.request_rev_no 	= vRequestRevNo;
    	dataJson.manufacturing_date = vManufacturingDate;
    	dataJson.prod_plan_date 	= vProdPlanDate;
    	dataJson.prod_cd 			= vProdCd;
    	dataJson.prod_rev_no		= vProdRevNo;
    	dataJson.plan_rev_no		= vPlanRevNo
    	
    	var JSONparam = JSON.stringify(dataJson);
    	
    	var chekrtn = confirm("지시서를 삭제하시겠습니까?");
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
					heneSwal.success('지시서 삭제가 완료되었습니다');
					parent.fn_MainInfo_List(startDate, endDate);
				} else {
					heneSwal.error('지시서 삭제에 실패했습니다, 다시 시도해주세요');
				}
			},
			error: function() {
				heneSwal.error('지시서 삭제에 실패했습니다, 다시 시도해주세요');
			}
		});
	}
 	
 	function SetRecvData(){
		DataPars(M202S010100E203,GV_RECV_DATA);  		
   		parent.fn_MainInfo_List();
	}
    
    function pop_fn_prod_req_Comlete(obj) {
		if(vOrderNo.length < 1){
			$('#alertNote').html(obj.innerText + " <BR> <%=JSPpage%>!!! <BR><BR> 주문정보를 선택하세요  !!!");
			$('#modalalert').show();
			return false;
		}
		
		var TableS303S040110_tr = $($("#TableS303S040110_tbody tr")[0]).find("td");
		if(TableS303S040110_tr.eq(2).text().trim().length < 1){ // job_order_no
			$('#alertNote').html(obj.innerText + " <BR> <%=JSPpage%>!!! <BR><BR> 해당 주문에 작업지시가 없습니다  !!!");
			$('#modalalert').show();
			return false;
		}
		
    	var modalContentUrl = "<%=Config.this_SERVER_path%>/Contents/Business/M303/S303S040122.jsp"
    						+ "?OrderNo=" + vOrderNo
    						+ "&LotNo=" + vLotNo
    						+ "&jspPage=" + "<%=JSPpage%>"
							+ "&num_gubun=" + "<%=GV_GET_NUM_PREFIX%>"
							+ "&prod_cd=" + vProdCd
	    					+ "&prod_cd_rev=" + vProdRev
							;

		pop_fn_popUpScr(modalContentUrl, obj.innerText+"(S303S040122)", '80%', '90%');
		return false;
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
      		<button type="button" onclick="pop_fn_prod_req_Insert(this)" id="insert" class="btn btn-outline-dark">지시서 등록</button>
      		<button type="button" onclick="pop_fn_prod_req_Update(this)" id="update" class="btn btn-outline-success">지시서 수정</button>
      		<button type="button" onclick="pop_fn_prod_req_Delete(this)" id="delete" class="btn btn-outline-danger">지시서 삭제</button>
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
    <div class="card card-primary card-outline">
    	<div class="card-header">
    		<h3 class="card-title">
    			<i class="fas fa-edit">세부 정보</i>
    		</h3>
    	</div>
    	<div class="card-body">
    		<ul class="nav nav-tabs" id="custom-tabs-one-tab" role="tablist">
	       		<li class="nav-item" onclick='fn_DetailInfo_List()'>
	       			<a class="nav-link" id="DetailInfo_List" data-toggle="pill" 
	       				href="#SubInfo_List_contents" role="tab">작업지시정보</a>
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