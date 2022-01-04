<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*,java.util.*,javax.servlet.http.*"%>
<%@ page import="mes.client.comm.*" %>
<%@ page import="mes.client.guiComponents.*" %>
<%@ page import="mes.client.util.*" %>
<%@ page import="mes.client.conf.*" %>
<%  	
	String loginID = session.getAttribute("login_id").toString();
	if(loginID==null||loginID.equals("")){                            // id가 Null 이거나 없을 경우
		response.sendRedirect(Config.this_SERVER_path + "/Contents/index.jsp");    // 로그인 페이지로 리다이렉트 한다.
	}

	String sMenuTitle = request.getParameter("MenuTitle").toString();
	String sProgramId = request.getParameter("programId").toString();
	String sHeadmenuID= request.getParameter("HeadmenuID").toString();
	String sHeadmenuName= request.getParameter("HeadmenuName").toString();
// 	String htmlsideMenu = MainMenu.GetsideMenu(sHeadmenuID,sHeadmenuName);
	
	Get_Program_button_Autho prg_autho = new Get_Program_button_Autho(loginID,sProgramId);
	
	CurrentPage jspPageName = new CurrentPage(request.getRequestURI());
	String JSPpage = jspPageName.GetJSP_FileName();
	ProcesStatusCheck prcStatusCheck = new ProcesStatusCheck(JSPpage+"|"+"ODPROCS"+"|");
	
	String GV_PROCESS_MODIFY	= prcStatusCheck.GV_PROCESS_MODIFY;
	String GV_PROCESS_DELETE	= prcStatusCheck.GV_PROCESS_DELETE;
	String GV_GET_NUM_PREFIX	= prcStatusCheck.GV_PROCESS_NUMBER_GUBUN;
%>

<script type="text/javascript">
	var vProc_exec_no 		= "";
	var vProc_plan_no 		= "";
	var vProd_cd 			= "";
	var vProd_cd_rev 		= "";
	var vProduct_nm 		= "";
	var vMix_recipe_cnt 	= "";
	var vStart_dt 			= "";
	var vEnd_dt				= "";
	var vProduction_status 	= "";
	var vCode_name 			= "";
	var vOrderNo="";
	var vLotno="";
	var vRevision_no="";
	var vBom_cd="";
	var vBom_cd_rev="";
	var vLast_no="";
	var vSys_bom_id="";
	var vType_no="";
	var vGeukyongpoommok ="";
	var vDept_code="";
	var vApproval_date="";
	var vApproval="";
	var vPart_cd="";
	var vPart_cd_rev="";
	var vBom_name="";
	var vPart_nm="";
	var vPart_cnt="";
	var vMesu="";
	var vGubun="";
	var vQar="";
	var vInspect_selbi="";
	var vPacking_jaryo="";
	var vModify_note
	var vCust_code="";
	var vCust_rev="";
	var vBigo ="";
	var vCreate_user_id ="";
	var vCreate_date ="";
	var vModify_user_id="";
	var vModify_date="";
	var vModify_reason="";
	var vReview_no ="";
	var vConfirm_no = "";
	var vOrder_detail_seq = "";
	var vMember_key ="";
	var vMeterage1 = "";
	var vMeterage2 = "";
	var vMeterage3 = "";
	var vMeterage4 = "";
	var vMeterage5 = "";
	var vMeterage6 = "";
	var vMeterage7 = "";
	var vMeterage8 = "";
	var vMeterage9 = "";
	var vMeterage10 = "";
	var vCustNm ="";
	var vProductNm = "";

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
    	
        fn_MainSubMenuSelect("<%=sMenuTitle%>");
		$("#InfoContentTitle").html("생산계획목록");
	    fn_tagProcess('<%=JSPpage%>');
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

    //배합운영정보
    function fn_MainInfo_List(startDate, endDate) {
        $.ajax(
        {
            type: "POST",
            url: "<%=Config.this_SERVER_path%>/Contents/Business/M353/S353S020100.jsp",
            data: "From=" + startDate + "&To=" + endDate,
            beforeSend: function () {
                $("#MainInfo_List_contents").children().remove();
            },
            success: function (html) {
                $("#MainInfo_List_contents").hide().html(html).fadeIn(100);
            },
            error: function (xhr, option, error) {

            }
        });
        $("#SubInfo_List_contents").children().remove();
        $("#SubInfo_BOM").children().remove();
    }

	function fn_DetailInfo_List() {
    	$.ajax(
    	    {
    	        type: "POST",
    	        url: "<%=Config.this_SERVER_path%>/Contents/Business/M353/S353S020110.jsp",
    	        data: "proc_plan_no=" + vProc_plan_no
    	        	+ "&bom_cd=" + vProd_cd + "&bom_cd_rev=" + vProd_cd_rev ,
    	        beforeSend: function () {
//     	            $("#SubInfo_List_contents").children().remove();
    	        },
    	        success: function (html) {
    	            $("#SubInfo_List_contents").hide().html(html).fadeIn(100);
    	        },
    	        error: function (xhr, option, error) {
    	        }
    	    });
		return;
	}   

    function pop_fn_BOMResultInfo_Insert(obj) {
    	if(vOrderNo.length < 1){
			$('#alertNote').html(obj.innerText + " <BR> <%=JSPpage%>!!! <BR><BR> 계량 정보를 선택하세요  !!!");
			$('#modalalert').show();
			return false;
		}
    	var modalContentUrl;
    	modalContentUrl = "<%=Config.this_SERVER_path%>/Contents/Business/M353/S353S020101.jsp"
    					+ "?proc_plan_no=" + vProc_plan_no + "&product_nm=" + vProduct_nm
    					+ "&prod_cd=" + vProd_cd + "&prod_cd_rev=" + vProd_cd_rev 
    					+ "&mix_recipe_cnt=" + vMix_recipe_cnt ;
    	
		modalFramePopup.setTitle(obj.innerText);
		pop_fn_popUpScr(modalContentUrl, obj.innerText+"(S353S020101)", "800px", "90%");
     }
    
    function pop_fn_BOMResultInfo_Delete(obj) {
    	if(vOrderNo.length < 1){
			$('#alertNote').html(obj.innerText + " <BR> <%=JSPpage%>!!! <BR><BR> 계량 정보를 선택하세요  !!!");
			$('#modalalert').show();
			return false;
		}
    	var modalContentUrl;
    	modalContentUrl = "<%=Config.this_SERVER_path%>/Contents/Business/M353/S353S020103.jsp"
			    		+ "?proc_plan_no=" + vProc_plan_no + "&product_nm=" + vProduct_nm
						+ "&prod_cd=" + vProd_cd + "&prod_cd_rev=" + vProd_cd_rev 
						+ "&mix_recipe_cnt=" + vMix_recipe_cnt ;
    	
		modalFramePopup.setTitle(obj.innerText);
		pop_fn_popUpScr(modalContentUrl, obj.innerText+"(S353S020103)", "800px", "90%");
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
      		<button type="button" onclick="pop_fn_BOMResultInfo_Insert(this)" id="insert" class="btn btn-outline-dark">계량정보등록</button>
        	<button type="button" onclick="pop_fn_BOMResultInfo_Delete(this)" id="delete" class="btn btn-outline-danger">발주서삭제</button>
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
       				<a class="nav-link" id="DetailInfo_List" data-toggle="pill" href="#SubInfo_List_contents" role="tab">계량정보상세</a>
       			</li>
       			<li class="nav-item" onclick='pop_fn_BomList(this, "<%=JSPpage%>")'>
       				<a class="nav-link" id="SubInfo_BomList" data-toggle="pill" href="#SubInfo_BOM" role="tab">배합(레시피)정보</a>
       			</li>
       		</ul>
       		<div class="tab-content" id="custom-tabs-one-tabContent">
       			<div class="tab-pane fade" id="SubInfo_List_contents" role="tabpanel"></div>
       			<div class="tab-pane fade" id="SubInfo_BOM" role="tabpanel"></div>
           	</div>
    	</div>
    </div>
  </div><!-- /.container-fluid -->
</div>
<!-- /.content -->
