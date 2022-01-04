<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*,java.util.*,javax.servlet.http.*"%>
<%@ page import="mes.client.comm.*" %>
<%@ page import="mes.client.common.*" %>
<%@ page import="mes.client.guiComponents.*" %>
<%@ page import="mes.client.util.*" %>
<%@ page import="mes.client.conf.*" %>
<%  	
	String loginID = session.getAttribute("login_id").toString();
	String member_key = session.getAttribute("member_key").toString();
	if(loginID==null||loginID.equals("")){                            // id가 Null 이거나 없을 경우
		response.sendRedirect(Config.this_SERVER_path + "/Contents/index.jsp");    // 로그인 페이지로 리다이렉트 한다.
	}
// 	makeMenu MainMenu = new makeMenu(loginID);

	String sMenuTitle = request.getParameter("MenuTitle").toString();
	String sProgramId = request.getParameter("programId").toString();
	String sHeadmenuID= request.getParameter("HeadmenuID").toString();
	String sHeadmenuName= request.getParameter("HeadmenuName").toString();

	
	Get_Program_button_Autho prg_autho = new Get_Program_button_Autho(loginID,sProgramId);	

	CurrentPage jspPageName = new CurrentPage(request.getRequestURI());
	String JSPpage = jspPageName.GetJSP_FileName();
	ProcesStatusCheck prcStatusCheck = new ProcesStatusCheck(JSPpage+"|"+"NON"+"|");
	
	String GV_PROCESS_MODIFY = prcStatusCheck.GV_PROCESS_MODIFY;
	String GV_PROCESS_DELETE = prcStatusCheck.GV_PROCESS_DELETE;
	String GV_GET_NUM_PREFIX = prcStatusCheck.GV_PROCESS_NUMBER_GUBUN; 
	
	Vector optCode =  null;
    Vector optName =  null;
    Vector Process_gubunVector = CommonData.getProcessGubun_CodeAll(member_key);
%>

 <script type="text/javascript">
	var GV_PROCESS_MODIFY	= "<%=GV_PROCESS_MODIFY%>";
	var GV_PROCESS_DELETE	= "<%=GV_PROCESS_DELETE%>";
 	var vProcCd				= "";
 	var vRevisionNo			= "";
 	var vProcess_gubun		= "";
 	var FLAG1				= false;
 	var FLAG2				= false;
	
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
	  	
		$("#InfoContentTitle").html("제품목록(PD List)");
	    fn_MainSubMenuSelect("<%=sMenuTitle%>");        	
	    fn_tagProcess();

		$("#select_CheckGubunCode").on("change", function(){
	    	vProcess_gubun = $(this).val();
	    	fn_MainInfo_List();
	    });
		
		$("#select_CheckGubunCode option:eq(0)").prop("selected", true);
	    vProcess_gubun = $("#select_CheckGubunCode").val(); 
		
	    fn_tagProcess('<%=JSPpage%>');
	    
	    $("#total_rev_check").change(function(){
			FLAG1 = !FLAG1;
	    	
	    	if( FLAG1 ) {
	    		alert("등록 / 삭제 기능이 제한됩니다.");
	    		
	    		$("#update").prop("disabled",true);
	    		$("#delete").prop("disabled",true);
	    	} else if( !(FLAG1 || FLAG2) ) {
	    		$("#update").prop("disabled",false);
	    		$("#delete").prop("disabled",false);
	    	}
	    	
	    	fn_MainInfo_List();
	    });
	    
	    $("#total_prod_cd").change(function(){
	    	fn_MainInfo_List();
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

    function fn_LoadSubPage() {
        fn_clearList();
        fn_MainInfo_List();
    }

    function fn_clearList() {
        if ($("#MainInfo_List_contents").children().length > 0) {
            $("#MainInfo_List_contents").children().remove();
        }
    }
    
    //표준공정정보관리
    function fn_MainInfo_List(startDate, endDate) {
    	var revCheck = $("#total_rev_check").is(":checked"); 
    	var prodCheck = $("#total_prod_cd").is(":checked"); 
    	
		var custcode = "";
        
        $.ajax({
            type: "POST",
            url: "<%=Config.this_SERVER_path%>/Contents/Business/M909/S909S121100.jsp",
            data: "custcode=" + custcode + "&From=" + startDate + 
            	  "&To=" + endDate + "&JSPpage=" + "<%=JSPpage%>" +
            	  "&total_rev_check=" + revCheck + "&",
            success: function (html) {
                $("#MainInfo_List_contents").hide().html(html).fadeIn(100);
            }
        });
        
        $("#SubInfo_List_contents").children().remove();
    }
    
    //주문상세정보 
    function fn_DetailInfo_List() {    	
        $.ajax({
            type: "POST",
            url: "<%=Config.this_SERVER_path%>/Contents/Business/M909/S909S121110.jsp",
            data: "Prod_cd=" + vProd_cd + "&Prod_cd_rev="+ vRevision_no,
            success: function (html) {
                $("#SubInfo_List_contents").hide().html(html).fadeIn(100);
            }
        });
    }

    function pop_fn_ProcCd_Update(obj) {    	
    	if(vProd_cd.length < 1){		
           	heneSwal.warning("공정정보를 선택하세요");
           	return false;
        }
    	var modalContentUrl;
		
       	modalContentUrl = "<%=Config.this_SERVER_path%>/Contents/Business/M909/S909S121102.jsp?ProdCd=" + vProd_cd + "&ProdCd_rev=" + vRevision_no;

		modalFramePopup.setTitle(obj.innerText);
        pop_fn_popUpScr(modalContentUrl, obj.innerText+"(S909S121102)", '750px', '1800px');
        
       	//console.log("선택 : "+ vProcess_nm + " | "+ vProd_cd);
		return false;
    }

    function pop_fn_ProcCd_Delete(obj) {
    	if(vProd_cd.length < 1){		
           	alert("공정정보를 선택하세요");
           	return false;
        } else {
        	//alert(vProcess_nm);
        }
    	var modalContentUrl;
		
       	modalContentUrl = "<%=Config.this_SERVER_path%>/Contents/Business/M909/S909S121103.jsp?ProdCd=" + vProd_cd + "&ProdCd_rev=" + vRevision_no;
   	
		modalFramePopup.setTitle(obj.innerText);
        pop_fn_popUpScr(modalContentUrl, obj.innerText+"(S909S121103)", '750px', '1800px');
		return false;
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
      		<button type="button" onclick="pop_fn_ProcCd_Update(this)" id="insert" class="btn btn-outline-dark">제품별 표준공정 등록</button>
      		<button type="button" onclick="pop_fn_ProcCd_Delete(this)" id="delete" class="btn btn-outline-success">제품별 표준공정 삭제</button>
      		<label style="width: auto; clear:both; margin-left:30px;">
	            	Rev. No 전체보기
	            	<input type="checkbox" id="total_rev_check"  />
	            </label>	     
				<label style="width: auto; clear:both; margin-left:30px;">
	            	공정 없는것도 보기
	            	<input type="checkbox" id="total_prod_cd" />
	            </label>       			
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
	       			<a class="nav-link" id="DetailInfo_List" data-toggle="pill" href="#SubInfo_List_contents" role="tab">주문상세정보</a>
	       		</li>
	        </ul>
	     	<div class="tab-content" id="custom-tabs-one-tabContent">
	     		<div class="tab-pane fade" id="SubInfo_List_contents" role="tabpanel"></div>
	     		<div class="tab-pane fade" id="SubInfo_List_Doc" role="tabpanel"></div>
	        </div>
        </div>
    </div>
  </div><!-- /.container-fluid -->
</div>
<!-- /.content -->