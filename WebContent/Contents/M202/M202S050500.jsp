<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*,java.util.*,javax.servlet.http.*"%>
<%@ page import="mes.client.comm.*" %>
<%@ page import="mes.client.common.*" %>
<%@ page import="mes.client.guiComponents.*" %>
<%@ page import="mes.client.util.*" %>
<%@ page import="mes.client.conf.*" %>
<%
/* 
업체별자재품질현황(M202S050500)
 */
	String loginID = session.getAttribute("login_id").toString();
	if(loginID==null||loginID.equals("")){                            // id가 Null 이거나 없을 경우
		response.sendRedirect("Contents/index.jsp");    // 로그인 페이지로 리다이렉트 한다.
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
	ProcesStatusCheck prcStatusCheck = new ProcesStatusCheck(JSPpage+"|"+"ODPROCS"+"|");
	
	
	String GV_PROCESS_MODIFY	= prcStatusCheck.GV_PROCESS_MODIFY;
	String GV_PROCESS_DELETE	= prcStatusCheck.GV_PROCESS_DELETE;
	String GV_GET_NUM_PREFIX = prcStatusCheck.GV_PROCESS_NUMBER_GUBUN;
%>  

<script type="text/javascript">
 	  
 	
 	var vProd_serial_no="";
 	var vOrder_cnt =""; 
 	var vCustCode = ""; 

 	var vBalju_req_date = ""; 
 	var vBalju_no = ""; 
    
    var ProcSeq ="";
     
    var procCD ="";
    var procBigCD ="";
    var procMidCD ="";
    var bomCode ="";
 	
 	

    $(document).ready(function () {
    	<%-- new SetDate("dateFrom", -180);
    	new SetDate("dateTo", 0);
    	
        makeMenu("<%=htmlsideMenu%>");
        fn_MainSubMenuSelect("<%=sMenuTitle%>");
        
		$("#InfoContentTitle").html("업체별품질현황");		

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
       	
     	$("#InfoContentTitle").html("업체별품질현황");
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
		var cust = $("#txt_cust_code").val();
		var cust_cd_rev = $("#txt_cust_code_rev").val();
		
        $.ajax(
        {
            type: "POST",
            url: "<%=Config.this_SERVER_path%>/Contents/Business/M202/S202S050500.jsp", 
            data: "From=" + from + "&To=" + to  + "&custcode=" + cust + "&cust_cd_rev=" + cust_cd_rev,
            beforeSend: function () {
                $("#MainInfo_List_contents").children().remove();
            },
            success: function (html) {
//                 $("#MainInfo_List_contents").hide().html(html).fadeIn(100);
                $("#MainInfo_List_contents").hide().html(html).fadeIn(100);
            },
            error: function (xhr, option, error) {

            }
        });
        
        $("#SubInfo_List_contents").children().remove(); --%>
        
        var custcode = "";
	    
		 $.ajax({
		 type: "POST",
		 url: "<%=Config.this_SERVER_path%>/Contents/Business/M202/S202S050500.jsp",
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
    	
    	if(vBalju_No.length < 1){
			$('#alertNote').html(obj.innerText + " <BR> <%=JSPpage%>!!! <BR><BR> 발주정보를 선택하세요  !!!");
			$('#modalalert').show();
			return false;
		}
		
		$.ajax(
    	    {
    	        type: "POST",
    	        url: "<%=Config.this_SERVER_path%>/Contents/Business/M202/S202S050510.jsp",
    	        data: "Balju_no=" + vBalju_No,
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

    </script>
    
     <!-- Content Header (Page header) -->
<div class="content-header">
  <div class="container-fluid">
    <div class="row mb-2">
      <div class="col-sm-6">
        <h1 class="m-0 text-dark" id="MenuTitle">여기에 메뉴 타이틀</h1>
      </div><!-- /.col -->
      <div class="col-sm-6">
      	<div class="float-sm-right"></div>
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
	       			<a class="nav-link" id="DetailInfo_List" data-toggle="pill" href="#SubInfo_List_contents" role="tab">자재품질현황</a>
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
    
    
    <%-- <div class="panel panel-default" style="margin-left:5px; margin-top:5px; margin-right:5px; margin-bottom:5px; width:100%" >
        <!-- Default panel contents -->
        <div class="panel-heading" style="font-weight: bold" id="MenuTitle">여기에메뉴타이틀</div>
        <div class="panel-body" >
        
        	<div>
	            <button data-author="mainBtn" type="button"  id="mainButton"  class="btn btn-primary active"
	            			style="width: auto; float: left; ">발주재고관리-자재발주관리</button>
<!-- 	            <button data-author="insert" type="button" onclick="pop_fn_BauljuInfo_Insert(this)" id="insert" class="btn btn-default"  -->
<!-- 	            			style="width: auto;float: left; margin-left:30px;">발주서등록</button> -->
<!-- 	            <button data-author="update" type="button" onclick="pop_fn_BauljuInfo_Update(this)" id="update" class="btn btn-outline-success"  -->
<!-- 	            			style="width: auto;float: left; margin-left:3px;">발주서수정</button> -->
<!-- 	            <button data-author="update" type="button" onclick="pop_fn_Baulju_Part_Insert(this)" id="insert" class="btn btn-warning"  -->
<!-- 	            			style="width: auto; float: left; margin-left:3px;">발주원부자재등록</button> -->
<!-- 	            <button data-author="update" type="button" onclick="pop_fn_Baulju_Part_Update(this)" id="update" class="btn btn-outline-success"  -->
<!-- 	            			style="width: auto; float: left; margin-left:3px;">발주원부자재수정</button> -->
<!-- 	            <button data-author="delete" type="button" onclick="pop_fn_BauljuInfo_Delete(this)" id="delete" class="btn btn-danger"  -->
<!-- 	            			style="width: auto; float: left; margin-left:3px;">발주서삭제</button> -->

<!-- 	            <label style="width: 100px; clear:both; margin-left:3px;"></label> -->
            </div>
            <p style="width: auto; clear:both;">
            </p>

            <div class="panel panel-default">
                <!-- Default panel contents -->
<!--                 <div class="panel-heading" style="font-size:16px; font-weight: bold"  id="InfoContentTitle">업체별품질현황</div> -->
                <div class="panel-body">
                    <div style="float: left">
                        <table style="width: 100%; text-align:left; background-color:#e0e0e0;">
                            <tr><td style='width:20%; vertical-align: middle;'>
                            		<div class="panel-heading" style="font-size:16px; font-weight: bold"  id="InfoContentTitle"></div>
                            	</td>
                            	<td style='width:5%; vertical-align: middle'>검사일자 :</td>
                                <td style='width:6%;  vertical-align: middle'>
                                    <input type="text" data-date-format="yyyy-mm-dd" id="dateFrom" class="form-control" />
                                </td>
                                <td style='width:1%;vertical-align: middle'>
                                    &nbsp;~&nbsp;
                                </td>
                                <td style='width:6%; vertical-align: middle'>
                                    <input type="text" data-date-format="yyyy-mm-dd" id="dateTo" class="form-control" />
                                </td>
                                                               
<!--  								<td style='width:7%;text-align:right; vertical-align: middle'>  -->
<!--                                     <h5> 협력사 : &nbsp;</h5> -->
<!--                                 </td> -->
                                <td style='width:55%;vertical-align: middle ;text-align: left;'>
<!--                                     <input type="text" class="form-control" id="txt_CustName" style="width: 180px; float:left"  /> -->
                                    <input type="hidden" class="form-control" id="txt_cust_code" style="width: 120px" />
                                    <input type="hidden" class="form-control" id="txt_cust_code_rev" style="width: 120px" />
<!--                                     <label style="float:left">&nbsp;</label> -->
<!--                                     <button type="button" onclick="pop_fn_CustName_View(0,'O')" id="btn_SearchCust" class="btn btn-info" style="float:left"> -->
<!--                                         협력사검색</button>  -->
                                    <button type="button" onclick="fn_MainInfo_List()" id="btn_Search" class="btn  btn-outline-success" style='margin-left:30px;float:left'>조 회</button>
                                 </td>  
                                
                            </tr>
                        </table>
                        <p>
                        </p>
                        
                    </div>
 					<div  style="clear:both; height:10px ;border-top: 1px solid #D2D6Df;" >
                    </div>
                    <div id="MainInfo_List_contents"  style="clear:both; " >
                    </div>
                </div>

	                <div id="tabs">
			         	<ul >
			                <li onclick='fn_DetailInfo_List()'><a id="DetailInfo_List"  href=#SubInfo_List_contents>자재품질현황</a></li>
			                <li onclick='pop_fn_BomList(this, "<%=JSPpage%>")'><a id="SubInfo_BomList"  href='#SubInfo_bom'>자료목록(BOM)</a></li>
			            </ul>
<!-- 	                    <div id="SubInfo_List_Doc" ></div> -->
<!-- 	                    <div id="SubInfo_bom" ></div> -->
	                    <div id="SubInfo_List_contents"></div>
	                </div>
        	</div>
		</div>
    </div> --%>