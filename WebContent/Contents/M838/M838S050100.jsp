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
	String GV_GET_NUM_PREFIX	= prcStatusCheck.GV_PROCESS_NUMBER_GUBUN;
%>

 <script type="text/javascript">
 
 	var GV_PROCESS_MODIFY = "<%=GV_PROCESS_MODIFY%>";
	var GV_PROCESS_DELETE = "<%=GV_PROCESS_DELETE%>";
 	
 	var vCheckDuration	= "";
	var vCheckDate 		= "";
	var vCheckTime 		= "";

    $(document).ready(function () {
    	<%-- new SetDate("dateFrom", -180);
    	new SetDate("dateTo", 0);
        
        fn_MainSubMenuSelect("<%=sMenuTitle%>");
		$("#InfoContentTitle").html("일일위생점검 목록");

		fn_MainInfo_List();
		fn_HACCP_View("<%=sMenuTitle%>","<%=sProgramId%>");
        		
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
	  	
		$("#InfoContentTitle").html("일일위생점검 목록");
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
       <%--  var from = $("#dateFrom").val();
        var to = $("#dateTo").val();
        $.ajax(
        {
            type: "POST",
            url: "<%=Config.this_SERVER_path%>/Contents/Business/M838/S838S050100.jsp",
            data: "From=" + from + "&To=" + to,
            beforeSend: function () {
                $("#MainInfo_List_contents").children().remove();
            },
            success: function (html) {
                $("#MainInfo_List_contents").hide().html(html).fadeIn(100);
            },
            error: function (xhr, option, error) {

            }
        }); --%>
        
		var custcode = "";
        
        $.ajax({
            type: "POST",
            url: "<%=Config.this_SERVER_path%>/Contents/Business/M838/S838S050100.jsp",
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
    	vCheckDuration	= $(obj).parent().parent().find("td").eq(0).text().trim();
    	var modalContentUrl  = "<%=Config.this_SERVER_path%>/Contents/Business/M838/S838S050100_canvas.jsp" 
    						 + "?check_duration=" + vCheckDuration
    						 + "&check_gubun=" + "<%=GV_GET_NUM_PREFIX%>" 
    						 + "&page_start=" + 1 ; // 1페이지	
    	pop_fn_popUpScr(modalContentUrl, "<%=sMenuTitle%>"+"(S838S050100_canvas)", '800px', '1260px');
		return false;
    }
    
    function fn_DetailInfo_List() {    	
		$.ajax(
		{
			type: "POST",
			url: "<%=Config.this_SERVER_path%>/Contents/Business/M838/S838S050110.jsp",
			data: "check_duration=" + vCheckDuration,
			beforeSend: function () {
// 				$("#SubInfo_List_contents").children().remove();
			},
			success: function (html) {
				$("#SubInfo_List_contents").hide().html(html).fadeIn(100);
			},
			error: function (xhr, option, error) {
	
			}
		});
	}
    
    function pop_fn_DetailInfo_List(obj) {
		vCheckDuration	= $(obj).parent().parent().find("td").eq(0).text().trim();
    	vCheckDate 		= $(obj).parent().parent().find("td").eq(1).text().trim();
    	vCheckTime 		= $(obj).parent().parent().find("td").eq(2).text().trim();
    	
    	var modalContentUrl  = "<%=Config.this_SERVER_path%>/Contents/Business/M838/S838S050120.jsp"
    						 + "?check_duration=" + vCheckDuration
    						 + "&check_date=" + vCheckDate
    						 + "&check_time=" + vCheckTime ;

    	pop_fn_popUpScr(modalContentUrl, "<%=sMenuTitle%>"+"(S838S050120)", '80%', '80%');
		return false;
	}
   
 	// 일일위생 점검일지 등록(팝업창)
    function pop_fn_DLYHYG_Check_Insert(obj) {
		var pageUrl = "<%=Config.this_SERVER_path%>/Contents/Business/M838/S838S050101.jsp";
    	var paramData = "check_gubun=" + "<%=GV_GET_NUM_PREFIX%>";
    	var pageTitle = obj.innerText+"(S838S050101)";
    			
		$('#pageUrl').val(pageUrl);
   		$('#paramData').val(paramData);
   		$('#pageTitle').val(pageTitle);
   		
   		window.open("<%=Config.this_SERVER_path%>/Contents/CommonView/popupPage.jsp", 
   				"popup_window", ",top=0, left=0, width=1200, height=900,fullscreen=yes, toolbars=no, status=no, scrollbars=no,resizable=yes,titlebar=no, location=no");
		$("#haccpPopform").submit();
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
      	  <button type="button" onclick="pop_fn_DLYHYG_Check_Insert(this)" id="insert" class="btn btn-outline-dark">일일위생 점검일지 등록</button>
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
	       			<a class="nav-link" id="DetailInfo_List" data-toggle="pill" href="#SubInfo_List_contents" role="tab">점검상세정보</a>
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

 
   <%--  <div class="panel panel-default" style="margin-left:5px; margin-top:5px; margin-right:5px; margin-bottom:5px; width:100%">
<!--         Default panel contents -->
        <div class="panel-heading" style="font-weight: bold" id="MenuTitle">여기에메뉴타이틀</div>
        <div class="panel-body">
            <div>
	            <button data-author="mainBtn" type="button"  id="mainButton"  class="btn btn-primary active"
	            			style="width: auto; float: left; ">zzzzzzz</button>
	            <button data-author="select" type="button" onclick="fn_HACCP_View('<%=sMenuTitle%>','<%=sProgramId%>')" id="select" class="btn btn-outline-success" 
<!-- 	            			style="width: auto;float: left; margin-left:30px;" >일일위생 점검일지 (양식)</button> -->
	            <button data-author="insert" type="button" onclick="pop_fn_DLYHYG_Check_Insert(this)" id="insert" class="btn btn-default" 
	            			style="width: auto;float: left; margin-left:30px;">일일위생 점검일지 등록</button>
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
		         		<li onclick='fn_DetailInfo_List()'><a id="DetailInfo_List"  href=#SubInfo_List_contents>점검상세정보</a></li>
		            </ul>
                    <div id="SubInfo_List_contents"></div>
                </div>
	        	
            </div>
        </div>
    </div>
 --%>