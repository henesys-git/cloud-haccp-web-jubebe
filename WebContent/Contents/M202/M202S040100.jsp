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
	
	
	String GV_PROCESS_MODIFY	= prcStatusCheck.GV_PROCESS_MODIFY;
	String GV_PROCESS_DELETE	= prcStatusCheck.GV_PROCESS_DELETE;
	String GV_GET_NUM_PREFIX = prcStatusCheck.GV_PROCESS_NUMBER_GUBUN;
%>  

<script type="text/javascript">
 	  
	var GV_PROCESS_MODIFY = "<%=GV_PROCESS_MODIFY%>";
	var GV_PROCESS_DELETE = "<%=GV_PROCESS_DELETE%>";
 	
 	var vPartNo="";

    $(document).ready(function () {
    	<%-- new SetDate("dateFrom", -180);
    	new SetDate("dateTo", 0);
    	
        fn_MainSubMenuSelect("<%=sMenuTitle%>");
        
		$("#InfoContentTitle").html("원부자재 발주현황");
		fn_MainInfo_List();

	    //탭 클릭시 처리하는 Function tbi_part_storage
	    //$( function() {$( "#tabs" ).tabs();});

        fn_tagProcess('<%=JSPpage%>');
         --%>
         
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
        <%-- var from = $("#dateFrom").val();
        var to = $("#dateTo").val();

        $.ajax({
        	type: "POST",
            url: "<%=Config.this_SERVER_path%>/Contents/Business/M202/S202S040100.jsp", 
            data: "From=" + from + "&To=" + to + "&JSPpage=" + '<%=JSPpage%>' + "&custcode=" , 
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
		 url: "<%=Config.this_SERVER_path%>/Contents/Business/M202/S202S040100.jsp",
		 data: "custcode=" + custcode + "&From=" + startDate + "&To=" + endDate + "&JSPpage=" + "<%=JSPpage%>",
		 beforeSend: function () {
//		      	$("#MainInfo_List_contents").children().remove();
		 },
		 success: function (html) {
		 $("#MainInfo_List_contents").hide().html(html).fadeIn(100);
		 },
		 error: function (xhr, option, error) {
			 
		 }
		 });
		    
		$("#SubInfo_List_Doc").children().remove();
        $("#ImportInspect_Request").children().remove();
        $("#SubInfo_List_contents").children().remove();
    }
        
	function fn_DetailInfo_List() { 
		if(vOrderNo.length < 1){
			$('#alertNote').html( " <BR> <%=JSPpage%>!!! <BR><BR> 주문정보를 선택하세요  !!!");
			$('#modalalert').show();
			return false;
		}
		
    	$.ajax(
    	    {
    	        type: "POST",
    	        url: "<%=Config.this_SERVER_path%>/Contents/Business/M202/S202S040110.jsp",
    	        data: "order_no=" + vOrderNo + "&lotno=" +vLotNo + "&BaljuNo=" + vBaljuNo ,
    	        beforeSend: function () {
//     	            //$("#SubInfo_List_contents").children().remove();
    	        },
    	        success: function (html) {
    	            $("#SubInfo_List_contents").hide().html(html).fadeIn(100);
    	        },
    	        error: function (xhr, option, error) {
    	        }
    	    });
		return;
	}

    //출고등록
    function pop_fn_PartChulgo_Insert(obj) {
    	var modalContentUrl;
    	
    	if(vOrderNo.length < 1){
			$('#alertNote').html(obj.innerText + " <BR> <%=JSPpage%>!!! <BR><BR> 주문정보를 선택하세요  !!!");
			$('#modalalert').show();
			return false;
		}
    	
    	modalContentUrl = "<%=Config.this_SERVER_path%>/Contents/Business/M202/S202S040101.jsp"
    					+ "?OrderNo=" + vOrderNo
						+ "&LotNo=" + vLotNo
						+ "&jspPage=" + "<%=JSPpage%>"
						+ "&BaljuNo=" + vBaljuNo
						;
						
		pop_fn_popUpScr(modalContentUrl, obj.innerText+"(S202S040101)", "80%", "1320px");
     }    
    
    //자재입출고보정
    function pop_fn_PartIpchulgo_Update(obj) {
    	var modalContentUrl;
    	if(vOrderNo.length < 1){
			$('#alertNote').html(obj.innerText + " <BR> <%=JSPpage%>!!! <BR><BR> 주문정보를 선택하세요  !!!");
			$('#modalalert').show();
			return false;
		}
    	modalContentUrl = "<%=Config.this_SERVER_path%>/Contents/Business/M202/S202S040102.jsp?OrderNo=" + vOrderNo
    	+ "&LotNo=" + vLotNo
		+ "&jspPage=" + "<%=JSPpage%>"
		+ "&BaljuNo=" + vBaljuNo ;
		modalFramePopup.setTitle(obj.innerText);
		pop_fn_popUpScr(modalContentUrl, obj.innerText+"(S202S040102)", "90%", "80%");
     }

//     function pop_fn_PartChulgo_Comlete(obj) {
//     	if(vOrderNo.length < 1){
<%-- 			$('#alertNote').html(obj.innerText + " <BR> <%=JSPpage%>!!! <BR><BR> 주문정보를 선택하세요  !!!"); --%>
// 			$('#modalalert').show();
// 			return false;
// 		}
//     	var modalContentUrl;
<%--     	modalContentUrl = "<%=Config.this_SERVER_path%>/Contents/Business/M202/S202S040122.jsp?OrderNo=" + vOrderNo  --%>
// 		+ "&part_cd=" + vPartCode
<%-- 		+ "&jspPage=" + "<%=JSPpage%>"; --%>
    	
// 		modalFramePopup.setTitle(obj.innerText);
// 		pop_fn_popUpScr(modalContentUrl, obj.innerText+"(S202S040122)", "90%", "80%");
// 		return false;
//      }
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
      		<button type="button" onclick="pop_fn_PartChulgo_Insert(this)" id="insert" class="btn btn-outline-dark">자재불출등록</button>
      		<button type="button" onclick="pop_fn_PartChulgo_Update(this)" id="update" class="btn btn-outline-success">자재불출수정</button>
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
	       			<a class="nav-link" id="DetailInfo_List" data-toggle="pill" href="#SubInfo_List_contents" role="tab">자재불출상세정보</a>
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
    
    
    <!-- <div class="panel panel-default" style="margin-left:5px; margin-top:5px; margin-right:5px; margin-bottom:5px; width:100%" >
        Default panel contents
        <div class="panel-heading" style="font-weight: bold" id="MenuTitle">여기에메뉴타이틀</div>
        <div class="panel-body" >
        
        	<div>
	            <button data-author="mainBtn" type="button"  id="mainButton"  class="btn btn-primary active"
	            			style="width: auto; float: left; ">발주재고관리-자재불출관리</button>
	            <button data-author="insert" type="button" onclick="pop_fn_PartChulgo_Insert(this)" id="insert" class="btn btn-default" 
	            			style="width: auto;float: left; margin-left:30px;">자재불출등록</button>
	            <button data-author="update" type="button" onclick="pop_fn_PartIpchulgo_Update(this)" id="update" class="btn btn-outline-success" 
	            			style="width: auto;float: left; margin-left:3px;">자재입출고 보정</button>
	            <button data-author="update" type="button" onclick="pop_fn_PartChulgo_Comlete(this)" id="update" class="btn btn-warning" 
	            			style="width: auto; float: left;  margin-left:30px;">불출처리완료</button>
            </div>
            <p style="width: auto; clear:both;">
            </p>

            <div class="panel panel-default">
                <div style="width: 100%; float: left">
						<table style="width: 100%; text-align:left; background-color:#f5f5f5;">
							<tr>
	                           	<td style='width:20%; vertical-align: middle;'>
	                           		<div class="panel-heading" style="font-size:16px; font-weight: bold"  id="InfoContentTitle"></div>
	                           	</td>
								<td style='width:6%; vertical-align: middle; text-align:right;'>주문일자 :</td>
                                <td style='width:6%;  vertical-align: middle'>
                                    <input type="text" data-date-format="yyyy-mm-dd" id="dateFrom" class="form-control" />
                                </td>
                                <td style='width:1%;vertical-align: middle'>
                                    &nbsp;~&nbsp;
                                </td>
                                <td style='width:6%; vertical-align: middle'>
                                    <input type="text" data-date-format="yyyy-mm-dd" id="dateTo" class="form-control" />
                                </td>
                                <td style="width:6%; text-align:left; vertical-align: middle;">
                                    <button type="button" onclick="fn_MainInfo_List()" id="btn_Search" class="btn  btn-outline-success" style='width:100px; margin-left: 20px;'>조 회</button>
                                </td>
								<td style='width:55%; vertical-align: middle;'></td>	       
							</tr>
						</table>
                    </div>
 					<div  style="clear:both; height:10px ;border-top: 1px solid #D2D6Df;" >
                    </div>
                    <div id="MainInfo_List_contents"  style="clear:both; " >
                    </div>
                </div>
	            <div id="tabs">
			        <ul >
			            <li onclick='fn_DetailInfo_List()'><a id="DetailInfo_List"  href=#SubInfo_List_contents>자재불출상세정보</a></li>
			        </ul>
	                <div id="SubInfo_List_Doc" ></div>
	                <div id="ImportInspect_Request" ></div>
	                <div id="SubInfo_List_contents"></div>
	            </div>
        	</div>
		</div>
    </div> -->