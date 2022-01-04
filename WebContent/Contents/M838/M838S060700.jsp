<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*,java.util.*,javax.servlet.http.*"%>
<%@ page import="mes.client.comm.*" %>
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
// 	String htmlsideMenu = MainMenu.GetsideMenu(sHeadmenuID,sHeadmenuName);
	
	Get_Program_button_Autho prg_autho = new Get_Program_button_Autho(loginID,sProgramId);	

	CurrentPage jspPageName = new CurrentPage(request.getRequestURI());
	String JSPpage = jspPageName.GetJSP_FileName();

	ProcesStatusCheck prcStatusCheck = new ProcesStatusCheck(JSPpage+"|"+"NON"+"|");
	
	
 	String GV_PROCESS_MODIFY	= prcStatusCheck.GV_PROCESS_MODIFY;
 	String GV_PROCESS_DELETE	= prcStatusCheck.GV_PROCESS_DELETE;
	String GV_GET_NUM_PREFIX = prcStatusCheck.GV_PROCESS_NUMBER_GUBUN;
%>

 <script type="text/javascript">
	// 복
 	var vVhclNo = "";
	var vVhclNoRev = "";
	var vVhclNm = "";
	var vServiceDate = "";
	// 붙
	
	var vPartCd		= "";
	var	vCustCd		= "";
	var	vCheckValue	= "";
	var vCheckDate	= "";
	
    $(document).ready(function () {
       <%--  $("#checkdate").datepicker({
        	format: 'yyyy-mm-dd',
        	autoclose: true,
        	language: 'ko'
        });

        var today = new Date();      

        $('#checkdate').datepicker('update', today);
        
        fn_MainSubMenuSelect("<%=sMenuTitle%>");
		$("#InfoContentTitle").html("원재료 매입업체 위반사항 점검표");

		fn_MainInfo_List();
		
		//탭 클릭시 처리하는 Function
		//$( function() {$( "#tabs" ).tabs();});
		
	    fn_tagProcess('<%=JSPpage%>'); --%>
	    
	    new SetRangeDate("dateParent", "dateRange", 180);
	      
		var startDate = $('#dateRange').data('daterangepicker').startDate.format('YYYY-MM-DD');
		var endDate = $('#dateRange').data('daterangepicker').endDate.format('YYYY-MM-DD');
		fn_MainInfo_List(startDate, endDate);
		  	
		$('#dateRange').on('apply.daterangepicker', function(ev, picker) {
		var startDate = picker.startDate.format('YYYY-MM-DD');
		var endDate = picker.endDate.format('YYYY-MM-DD');
		fn_MainInfo_List(startDate, endDate);
		});
		  	
		$("#InfoContentTitle").html("원재료 매입업체 위반사항 점검표");
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
            //$("#SubInfo_List_contents").children().remove();
        }
    }
        
    //주문기본정보
    function fn_MainInfo_List(startDate, endDate) {
    	vCheckDate = $("#checkdate").val();
        $.ajax(
        {
            type: "POST",
            url: "<%=Config.this_SERVER_path%>/Contents/Business/M838/S838S060700.jsp",
            data: "CheckDate=" + vCheckDate,
            beforeSend: function () {
                $("#MainInfo_List_contents").children().remove();
            },
            success: function (html) {
                $("#MainInfo_List_contents").hide().html(html).fadeIn(100);
                $("#SubInfo_List_contents").children().remove();
                $("#Transport_List_contents").children().remove();
            },
            error: function (xhr, option, error) {

            }
        });
    }
    
    // 점검표 canvas
    function fn_HACCP_View_Canvas(obj) {
    	vCheckDate	= $(obj).parent().parent().find("td").eq(6).text().trim();
    	console.log(vCheckDate + "???");
    	var modalContentUrl = "<%=Config.this_SERVER_path%>/Contents/Business/M838/S838S060700_canvas.jsp"
							+ "?check_date="	+ vCheckDate;
    	
    	pop_fn_popUpScr(modalContentUrl, "<%=sMenuTitle%>"+"(S838S060700_canvas)", '800px', '1260px');
		
    	return false;
		
<%-- 		fn_HACCP_View("<%=sMenuTitle%>","<%=sProgramId%>"); --%>
    }
    
 // 원재료 매입업체 위반사항 등록(팝업창)
   <%-- function pop_fn_Part_Check_Insert(obj) {
		var pageUrl = "<%=Config.this_SERVER_path%>/Contents/Business/M838/S838S060701.jsp";
    	//var paramData = "check_date=" + $("#checkdate").val();
    	var pageTitle = obj.innerText+"(S838S060701)";
    			
		$('#pageUrl').val(pageUrl);
   		$('#paramData').val(paramData);
   		$('#pageTitle').val(pageTitle);
   		
   		window.open("<%=Config.this_SERVER_path%>/Contents/CommonView/popupPage.jsp", 
   				"popup_window", ",top=0, left=0, width=900, height=900,fullscreen=yes, toolbars=no, status=no, scrollbars=no,resizable=yes,titlebar=no, location=no");
		$("#haccpPopform").submit();
    } --%>
    function pop_fn_Part_Check_Insert(obj) {
    	var modalContentUrl = "<%=Config.this_SERVER_path%>/Contents/Business/M838/S838S060701.jsp"

    	var footer = "";
		var title = obj.innerText;
		var heneModal = new HenesysModal(modalContentUrl, 'large', title+"(S838S060701)", footer);
		heneModal.open_modal();
	}
    // 위반사항 수정
    function pop_fn_Part_Check_Update(obj) {    	
		if(vPartCd.length < 1){
			heneSwal.warning(obj.innerText +" <%=JSPpage%> !! 수정할 원재료 위반사항 정보를 클릭하세요  !!");
 			return false;
		}
		
    	var modalContentUrl = "<%=Config.this_SERVER_path%>/Contents/Business/M838/S838S060702.jsp"
    							+ "?part_cd="		+ vPartCd
    							+ "&company_cd="	+ vCustCd
    							+ "&check_date="	+ vCheckDate;

    	var footer = "";
		var title = obj.innerText;
		var heneModal = new HenesysModal(modalContentUrl, 'large', title+"(S838S060702)", footer);
		heneModal.open_modal();
	}
    
 	// 위반사항 삭제
    <%-- function pop_fn_Part_Check_Delete(obj) {    	
		if(vVhclNo.length < 1){
			$('#alertNote').html(obj.innerText + " <BR> <%=JSPpage%>!!! <BR><BR> 삭제할 원재료 위반사항 정보를 목록에서 데이터를 선택하세요  !!!");
			$('#modalalert').show();
			return false;
		}
    	var modalContentUrl = "<%=Config.this_SERVER_path%>/Contents/Business/M838/S838S060703.jsp";

    	pop_fn_popUpScr(modalContentUrl, obj.innerText+"(S838S060703)", "90%", "40%");
		return false;
	} --%>
 
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
      		<button type="button" onclick="pop_fn_Part_Check_Insert(this)" id="insert" class="btn btn-outline-dark">위반사항등록</button>
      		<button type="button" onclick="pop_fn_Part_Check_Update(this)" id="update" class="btn btn-outline-success">위반사항수정</button>
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