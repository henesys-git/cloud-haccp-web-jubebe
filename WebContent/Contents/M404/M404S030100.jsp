<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page language="java"
	import="java.sql.*,java.util.*,javax.servlet.http.*"%>
<%@ page import="mes.client.comm.*"%>
<%@ page import="mes.client.common.*"%>
<%@ page import="mes.client.guiComponents.*"%>
<%@ page import="mes.client.util.*"%>
<%@ page import="mes.client.conf.*"%>
<%
/* 
자주검사(M404S030100.jsp)
 */
	String loginID = session.getAttribute("login_id").toString();
	if(loginID==null||loginID.equals("")){                            // id가 Null 이거나 없을 경우
		response.sendRedirect(Config.this_SERVER_path + "/Contents/index.jsp");    // 로그인 페이지로 리다이렉트 한다.
	}

	String sMenuTitle = request.getParameter("MenuTitle").toString();
	String sProgramId = request.getParameter("programId").toString();
	String sHeadmenuID= request.getParameter("HeadmenuID").toString();
	String sHeadmenuName= request.getParameter("HeadmenuName").toString();
	
	Get_Program_button_Autho prg_autho = new Get_Program_button_Autho(loginID,sProgramId);

	CurrentPage jspPageName = new CurrentPage(request.getRequestURI());
	String JSPpage = jspPageName.GetJSP_FileName();
	ProcesStatusCheck prcStatusCheck = new ProcesStatusCheck(JSPpage+"|"+"ODPROCS"+"|");
	
	
	String GV_PROCESS_MODIFY	= prcStatusCheck.GV_PROCESS_MODIFY;
	String GV_PROCESS_DELETE	= prcStatusCheck.GV_PROCESS_DELETE;
	String GV_GET_NUM_PREFIX	= prcStatusCheck.GV_PROCESS_NUMBER_GUBUN;
%>

<script type="text/javascript">
 	  
 	var vInspectGubun = "";  
	var vCust_nm		= "";
	var vProduct_nm     = "";		
	var vProd_cd 		= "";
	var vProd_rev 		= "";
	var vProd_cd_rev	= "";
	var vCust_pono	   	= "";
	var vGugyuk		   	= "";
	var vOrder_no		= "";
	var vLotNo 		   	= "";
	var vLot_count	   	= "";
	var vProc_plan_no	= "";
	var vStart_dt 	   	= "";
	var vEnd_dt 		= "";
	var vSeolbi_nm 	   	= "";
	var vOrder_note 	= "";
	var vOrder_date	   	= "";
	var vDelivery_date 	= "";
	var vBigo		   	= "";
	
	// =====================
	// 위에는 예전 변수들, 필요한지 아닌지 확인 안해봄
	// 필요없으면 지우기 (2021 02 02 최현수)
	
	$(document).ready(function () {
	    
	    new SetRangeDate("dateParent", "dateRange", 180);
	    
		var startDate = $('#dateRange').data('daterangepicker').startDate.format('YYYY-MM-DD');
	    var endDate = $('#dateRange').data('daterangepicker').endDate.format('YYYY-MM-DD');
	    fn_MainInfo_List(startDate, endDate);
	  	
	  	$('#dateRange').on('apply.daterangepicker', function(ev, picker) {
			var startDate = picker.startDate.format('YYYY-MM-DD');
	    	var endDate = picker.endDate.format('YYYY-MM-DD');
	    	fn_MainInfo_List(startDate, endDate);
	  	});
	  	
		$("#InfoContentTitle").html("자주 검사 목록");
	    fn_MainSubMenuSelect("<%=sMenuTitle%>");
	    fn_tagProcess();
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
        }        
        if ($("#sub_SubInfo_List_contents").children().length > 0) {
            $("#sub_SubInfo_List_contents").children().remove();
        }
        if ($("#ProcessInfo_sibang").children().length > 0) {
            $("#ProcessInfo_sibang").children().remove();
        }
        if ($("#ProcessInfo_processcheck").children().length > 0) {
            $("#ProcessInfo_processcheck").children().remove();
        }        
    }

	function fn_MainInfo_List(startDate, endDate) {
        $.ajax({
            type: "POST",
            url: "<%=Config.this_SERVER_path%>/Contents/Business/M404/S404S030100.jsp",
            data: "From=" + startDate + "&To=" + endDate + "&JSPpage=" + "<%=JSPpage%>",
            success: function (html) {
                $("#MainInfo_List_contents").hide().html(html).fadeIn(100);
            }
        });
	}
    
	// 완제품 중량점검일지 등록
	function pop_fn_product_weight_Insert(obj) {
    	var url = "<%=Config.this_SERVER_path%>/Contents/Business/M404/S404S030101.jsp";
		var footer = '<button id="btn_Save" class="btn btn-info" onclick="SaveOderInfo();">저장</button>'
		var title = obj.innerText;
		var heneModal = new HenesysModal(url, 'standard', title, footer);
		heneModal.open_modal();
	}  
	
	var dt_Prod_cd = new Array();
	// 완제품 중량점검일지 수정
	function pop_fn_product_weight_Update(obj) {
		var vCheck_date = vStart_dt.substring(0,10);		
   		if(vProduct_nm.length < 1){
  			heneSwal.warning("<%=JSPpage%>!!! 일지를 수정할 제품을 선택하세요!!");
  			return false;
  		}
    	if(dt_Prod_cd[0] == ''){
			heneSwal.warning("<%=JSPpage%>!!! 중량점검일지가 등록되지 않았습니다!!");
			return false;
		}
 		alert("제품명 : "+ vProduct_nm);
     	var modalContentUrl;
     	var vDefault_weight = vGugyuk.replace(/[^0-9]/g, ''); 
     	modalContentUrl = "<%=Config.this_SERVER_path%>/Contents/Business/M404/S404S030202.jsp"
     		+ "?Proc_plan_no=" + vProc_plan_no
	     	+ "&Prod_cd=" + vProd_cd
 			+ "&Prod_rev=" + vProd_cd_rev
 			+ "&Product_nm=" + vProduct_nm
 			+ "&Start_dt=" + vStart_dt
			+ "&End_dt=" + vEnd_dt
			+ "&default_weight=" + vDefault_weight
			+ "&Order_no=" + vOrder_no
			+ "&Lotno=" + vLotno
			+ "&Check_date=" + vCheck_date
 			+ "&jspPage=" + "<%=JSPpage%>";
     	
 		var footer = "";
		var title = obj.innerText;
		var heneModal = new HenesysModal(modalContentUrl, 'large', title+"(S404S030202)", footer);
		heneModal.open_modal();
	}  

	// 완제품 중량점검일지 삭제
	function pop_fn_product_weight_Delete(obj) {
		var vCheck_date = vStart_dt.substring(0,10);		
		//console.log();
   		if(vProduct_nm.length < 1){
  			heneSwal.warning("<%=JSPpage%>!!! 일지를 삭제할 제품을 선택하세요!!");
  			return false;
  		} 
    	if(dt_Prod_cd[0] == ''){
			heneSwal.warning("<%=JSPpage%>!!! 중량점검일지가 등록되지 않았습니다!!");
			return false;
		}
 		alert("제품명 : "+ vProduct_nm);
     	var modalContentUrl;
     	var vDefault_weight = vGugyuk.replace(/[^0-9]/g, ''); 
     	modalContentUrl = "<%=Config.this_SERVER_path%>/Contents/Business/M404/S404S030203.jsp"
     		+ "?Proc_plan_no=" + vProc_plan_no
	     	+ "&Prod_cd=" + vProd_cd
 			+ "&Prod_rev=" + vProd_cd_rev
 			+ "&Product_nm=" + vProduct_nm
 			+ "&Start_dt=" + vStart_dt
			+ "&End_dt=" + vEnd_dt
			+ "&default_weight=" + vDefault_weight
			+ "&Order_no=" + vOrder_no
			+ "&Lotno=" + vLotno
			+ "&Check_date=" + vCheck_date
 			+ "&jspPage=" + "<%=JSPpage%>";
     	
 		var footer = "";
		var title = obj.innerText;
		var heneModal = new HenesysModal(modalContentUrl, 'large', title+"(S404S030203)", footer);
		heneModal.open_modal();
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
      	  <!-- <button type="button" onclick="pop_fn_product_weight_Insert(this)" id="insert" class="btn btn-outline-dark">중량점검 등록</button>
      	  <button type="button" onclick="pop_fn_product_weight_Update(this)" id="update" class="btn btn-outline-success">중량점검 수정</button>
      	  <button type="button" onclick="pop_fn_product_weight_Delete(this)" id="delete" class="btn btn-outline-danger">중량점검 삭제</button> -->
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
	</div><!-- /.container-fluid -->
</div>
<!-- /.content -->