<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, java.util.*, javax.servlet.http.*"%>
<%@ page import="mes.client.comm.*" %>
<%@ page import="mes.client.common.*" %>
<%@ page import="mes.client.guiComponents.*" %>
<%@ page import="mes.client.util.*" %>
<%@ page import="mes.client.conf.*" %>
<%
/* 원부자재 발주현황
 */
	String loginID = session.getAttribute("login_id").toString();
	if(loginID==null||loginID.equals("")){              // id가 Null 이거나 없을 경우
		response.sendRedirect("Contents/index.jsp");    // 로그인 페이지로 리다이렉트 한다.
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
	String GV_PROCESS_NAME		= prcStatusCheck.GV_PROCESS_NAME;
	String GV_GET_NUM_PREFIX	= prcStatusCheck.GV_PROCESS_NUMBER_GUBUN;
%>  

<script type="text/javascript">
	var vJSPpage = '<%=JSPpage%>';

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

		$("#InfoContentTitle").html("원부자재 발주현황");
        fn_tagProcess(vJSPpage);
        fn_MainSubMenuSelect("<%=sMenuTitle%>");
		
	    //탭 클릭시 처리하는 Function
	    ////$( function() {$( "#tabs" ).tabs();});
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
            url: "<%=Config.this_SERVER_path%>/Contents/Business/M202/S202S010300.jsp", 
            data: "&From=" + startDate + "&To=" + endDate,
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
    }
    
	function fn_DetailInfo_List() { 
    	$.ajax(
    	    {
    	        type: "POST",
    	        url: "<%=Config.this_SERVER_path%>/Contents/Business/M202/S202S010310.jsp",
    	        data: "order_no=" + vOrderNo + "&BaljuNo=" + vBalju_no,
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

   	function pop_fn_Balju_form_button(obj) {
    	var tr = $(obj).parent().parent();
		var td = tr.children();

// 		vOrderNo 			= td.eq(0).text().trim();

    	var url = "<%=Config.this_SERVER_path%>/Contents/CommonView/Balju_form_view.jsp?OrderNo=" + td.eq(0).text().trim()
    			+ "&BaljuNo="+ td.eq(1).text().trim();
   		pop_fn_popUpScr(url, obj.innerText, '80%', '80%');
  	    return;
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
          		<!-- <button type="button" onclick="pop_fn_BauljuInfo_Insert(this)" id="insert" class="btn btn-outline-dark">발주서등록</button>
	            <button type="button" onclick="pop_fn_BauljuInfo_Update(this)" id="update" class="btn btn-outline-success">발주서수정</button>
	            <button type="button" onclick="pop_fn_BauljuInfo_Delete(this)" id="delete" class="btn btn-outline-danger">발주서삭제</button>
	            <button type="button" onclick="pop_fn_PartSoyo(this)" id="select" class="btn btn-outline-primary">원부자재 필요량 조회</button> -->
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
           				<a class="nav-link" id="DetailInfo_List" data-toggle="pill" href="#SubInfo_List_contents" role="tab" aria-controls="SubInfo_List_contents" aria-selected="false">발주원부자재정보</a>
           			</li>
           		</ul>
           		<div class="tab-content" id="custom-tabs-one-tabContent">
           			<div class="tab-pane fade" id="SubInfo_List_contents" role="tabpanel" aria-labelledby="SubInfo_List_contents"></div>
               	</div>
        	</div>
        </div>
      </div><!-- /.container-fluid -->
    </div>
    <!-- /.content -->
    
    
    