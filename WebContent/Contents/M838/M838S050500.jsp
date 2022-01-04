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
 
 	var GV_PROCESS_MODIFY = "<%=GV_PROCESS_MODIFY%>";
	var GV_PROCESS_DELETE = "<%=GV_PROCESS_DELETE%>";
 
 	var vCleanerRegNo = "";
	var vCleanerRegRev = "";
 	var vCleanerRegDate = "";
 	var vCleanerBigo = "";
 
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
	  	
		$("#InfoContentTitle").html("세척소독제 관리현황");
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
		var custcode = "";
        
        $.ajax({
            type: "POST",
            url: "<%=Config.this_SERVER_path%>/Contents/Business/M838/S838S050500.jsp",
            data: "custcode=" + custcode + "&From=" + startDate + "&To=" + endDate + "&JSPpage=" + "<%=JSPpage%>",
            beforeSend: function () {
			//$("#MainInfo_List_contents").children().remove();
            },
            success: function (html) {
                $("#MainInfo_List_contents").hide().html(html).fadeIn(100);
            },
            error: function (xhr, option, error) {

            }
        });
        
        
        $("#SubInfo_List_contents").children().remove();
    }
   
    function fn_HACCP_View_Canvas(obj) {
    	var vCleanerRegDate	= $(obj).parent().parent().find("td").eq(2).text().trim();
    	var modalContentUrl  = "<%=Config.this_SERVER_path%>/Contents/Business/M838/S838S050500_canvas.jsp" 
    						 + "?page_start=" + 1 
    						 + "&cleaner_reg_date=" +  vCleanerRegDate; // 1페이지	
    	pop_fn_popUpScr(modalContentUrl, "<%=sMenuTitle%>"+"(S838S050500_canvas)", '800px', '1260px');
		
    	return false;
		
<%-- 		fn_HACCP_View("<%=sMenuTitle%>","<%=sProgramId%>"); --%>
    }
    
	// 세척, 소독제 관리내역 등록
    function pop_fn_Cleaner_Check_Insert(obj) {
		var modalContentUrl = "<%=Config.this_SERVER_path%>/Contents/Business/M838/S838S050501.jsp";
<%--     						+ "?jspPage=" + "<%=JSPpage%>" --%>
    			
		var footer = "";
		var title = obj.innerText;
		var heneModal = new HenesysModal(modalContentUrl, 'large', title+"(S838S050501)", footer);
		heneModal.open_modal();
    }    
    
    // 세척, 소독제 관리내역 수정
    function pop_fn_Cleaner_Check_Update(obj) {    	
		if(vCleanerRegDate.length < 1){
			heneSwal.warning(obj.innerText +" <%=JSPpage%> !! 점검상세정보 탭에서 데이터를 선택하세요  !!");
 			return false;
		}
		if(vCleanerBigo == "입고"){
			heneSwal.warning(obj.innerText +" <%=JSPpage%> !! 입고정보는 수정,삭제할수 없습니다");
 			return false;
		}
    	var modalContentUrl = "<%=Config.this_SERVER_path%>/Contents/Business/M838/S838S050502.jsp"
    						+ "?cleaner_reg_no=" + vCleanerRegNo 
    						+ "&cleaner_reg_rev=" + vCleanerRegRev		
    						+ "&cleaner_reg_date=" + vCleanerRegDate ;

    	var footer = "";
		var title = obj.innerText;
		var heneModal = new HenesysModal(modalContentUrl, 'large', title+"(S838S050502)", footer);
		heneModal.open_modal();
	}
    
 	// 세척, 소독제 관리내역 삭제
    function pop_fn_Cleaner_Check_Delete(obj) {    	
		if(vCleanerRegDate.length < 1){
			heneSwal.warning(obj.innerText +" <%=JSPpage%> !! 점검상세정보 탭에서 데이터를 선택하세요  !!");
 			return false;
		}
		if(vCleanerBigo == "입고"){
			heneSwal.warning(obj.innerText +" <%=JSPpage%> !! 입고정보는 수정,삭제할수 없습니다");
 			return false;
		}
    	var modalContentUrl = "<%=Config.this_SERVER_path%>/Contents/Business/M838/S838S050503.jsp" 
				    		+ "?cleaner_reg_no=" + vCleanerRegNo 
							+ "&cleaner_reg_rev=" + vCleanerRegRev		
							+ "&cleaner_reg_date=" + vCleanerRegDate ;

    	var footer = "";
		var title = obj.innerText;
		var heneModal = new HenesysModal(modalContentUrl, 'large', title+"(S838S050503)", footer);
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
      	  <button type="button" onclick="pop_fn_Cleaner_Check_Insert(this)" id="insert" class="btn btn-outline-dark">세척, 소독제 관리내역 등록</button>
		  <button type="button" onclick="pop_fn_Cleaner_Check_Update(this)" id="update" class="btn btn-outline-success">세척, 소독제 관리내역 수정</button>
		  <button type="button" onclick="pop_fn_Cleaner_Check_Delete(this)" id="delete" class="btn btn-outline-danger">세척, 소독제 관리내역 삭제</button>      	
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
    <!-- <div class="card card-primary card-outline">
    	<div class="card-header">
    		<h3 class="card-title">
    			<i class="fas fa-edit">세부 정보</i>
    		</h3>
    	</div>
    	<div class="card-body">
    		<ul class="nav nav-tabs" id="custom-tabs-one-tab" role="tablist">
	       		<li class="nav-item" onclick='fn_DetailInfo_List()'>
	       			<a class="nav-link" id="DetailInfo_List" data-toggle="pill" href="#SubInfo_List_contents" role="tab">점검상세정보</a>
	       		</li>
	        </ul>
	     	<div class="tab-content" id="custom-tabs-one-tabContent">
	     		<div class="tab-pane fade" id="SubInfo_List_contents" role="tabpanel"></div>
	     		
	        </div>
        </div>
    </div> -->
  </div><!-- /.container-fluid -->
</div>
<!-- /.content -->
 
    <%-- <div class="panel panel-default" style="margin-left:5px; margin-top:5px; margin-right:5px; margin-bottom:5px; width:100%">
<!--         Default panel contents -->
        <div class="panel-heading" style="font-weight: bold" id="MenuTitle">여기에메뉴타이틀</div>
        <div class="panel-body">
            <div>
	            <button data-author="mainBtn" type="button"  id="mainButton"  class="btn btn-primary active"
	            			style="width: auto; float: left; ">zzzzzzz</button>
	            <button data-author="select" type="button" onclick="fn_HACCP_View('<%=sMenuTitle%>','<%=sProgramId%>')" id="select" class="btn btn-outline-success" 
<!-- 	            			style="width: auto;float: left; margin-left:30px;" >세척, 소독제 관리대장 (양식)</button> -->
	            <button data-author="insert" type="button" onclick="pop_fn_Cleaner_Check_Insert(this)" id="insert" class="btn btn-default" 
	            			style="width: auto;float: left; margin-left:30px;">세척, 소독제 관리내역 등록</button>      			
	            <button data-author="update" type="button" onclick="pop_fn_Cleaner_Check_Update(this)" id="update" class="btn btn-outline-success" 
	            			style="width: auto; float: left; margin-left:3px;">세척, 소독제 관리내역 수정</button>
	            <button data-author="update" type="button" onclick="pop_fn_Cleaner_Check_Delete(this)" id="delete" class="btn btn-danger" 
	            			style="width: auto; float: left; margin-left:3px;">세척, 소독제 관리내역 삭제</button>
	            <label style="width: ;  clear:both; margin-left:3px;"></label>
            </div>
            <p style="width: auto; clear:both;">
            </p>
            <div class="panel panel-default">
<!--                 Default panel contents -->
                <div class="panel-body">
                    <div style="float:left">
                        <table style="width: 100%; text-align:left; background-color:#e0e0e0;">
                            <tr><td style='width:20%; vertical-align: middle;'>
                            		<div class="panel-heading" style="font-size:16px; font-weight: bold"  id="InfoContentTitle"></div>
                            	</td>
                            	<td style='width:5%; vertical-align: middle'>점검일자 :</td>
                                <td style='width:6%;  vertical-align: middle'>
                                    <input type="text" data-date-format="yyyy-mm-dd" id="dateFrom" class="form-control" />
                                </td>
                                <td style='width:1%;vertical-align: middle'>
                                    &nbsp;~&nbsp;
                                </td>
                                <td style='width:6%; vertical-align: middle'>
                                    <input type="text" data-date-format="yyyy-mm-dd" id="dateTo" class="form-control" />
                                </td>
                                <td style="width:62%; text-align:left">
                                    <button type="button" onclick="fn_MainInfo_List()" id="btn_Search" class="btn  btn-outline-success" style='margin-left:10px; width:100px'>조 회</button>
                                </td>
                            </tr>
                        </table>
                        <p>
                        </p>
                    </div>				
 					<div  style="clear:both; height:10px ;border-top: 1px solid #D2D6Df;" >
                    </div>
                    <div style="clear:both" id="MainInfo_List_contents" >
                    </div>
                </div>
                
	                <div id="tabs">
			         	<ul >
<!-- 			                <li><a id="btnExport"  type="button" class="btn btn-outline-success">엑셀다운</a></li> -->
<!-- 			                <li onclick='com_fn_SubInfo_DOC_List(this,vOrderNo)'><a id="SubInfo_DOC_List"  href='#SubInfo_List_Doc'>주문문서목록</a></li> -->
<!-- 			                <li onclick='fn_SubInfo_BomList()'><a id="SubInfo_BomList"  href='#SubInfo_bom'>주문별BOM</a></li> -->
			            </ul>
	                    <div id="SubInfo_List_Doc" ></div>
	                    <div id="SubInfo_bom" ></div>
	                    <div id="SubInfo_List_contents"></div>
	                </div>
	        	
            </div>
        </div>
    </div> --%>

