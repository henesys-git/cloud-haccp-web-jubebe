<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*,java.util.*,javax.servlet.http.*"%>
<%@ page import="mes.client.comm.*" %>
<%@ page import="mes.client.common.*" %>
<%@ page import="mes.client.guiComponents.*" %>
<%@ page import="mes.client.util.*" %>
<%@ page import="mes.client.conf.*" %>
<%
/* 
수입검사결과등록(M404S010100.jsp)
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
	String GV_PROCESS_NAME		= prcStatusCheck.GV_PROCESS_NAME;
	String GV_GET_NUM_PREFIX	= prcStatusCheck.GV_PROCESS_NUMBER_GUBUN;
	
%>  

<script type="text/javascript">
 	var vBalju_req_date =""; 
 	var vBalju_no = ""; 
 	var vPart_cd = "";
	var vInspect_OrderNo="";
 	var vImport_inspect_seq = "";
	var vInspect_dt="";
	var vLotNo = "";

	var import_request_Count;
	var Import_inspect_count;
	var Import_inspect_request_doc_count;
	var Import_inspect_doc_count;
	
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
	  	
		$("#InfoContentTitle").html("주문목록(PO List)");
	    fn_MainSubMenuSelect("<%=sMenuTitle%>");        	
	    fn_tagProcess();
	    
	    //탭 클릭시 처리하는 Function
	    $(function() {
	    	
	    	$( "#tabs" ).tabs();
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
	            });
    		}
			if(vDelete == "0") {
			    $('button[id="delete"]').each(function () {
					$(this).prop("disabled",true);
	            });
    		}
    }
    
	function fn_CheckBox_Chaned(){	    
		var tr = $($("TableS404S010100 tr")[0]);
		var td = tr.children();

// 		var trNum = $(obj).closest('tr').prevAll().length;//현재 클릭한 TR의 순서 return
		$("input[id='checkbox1']").prop("checked", false);
		$($("input[id='checkbox1']")[0]).prop("checked", true);
		
// 		$(workOrderData).attr("style", "background-color:#ffffff");
// 		tr.attr("style", "background-color:#1c86ee");
	     ProcSeq	= td.eq(10).text().trim();
	     procCD		= td.eq(12).text().trim();
	     bomCode	= td.eq(15).text().trim();
    }
    
    function fn_clearList() { 
        if ($("#MainInfo_List_contents").children().length > 0) {
            $("#MainInfo_List_contents").children().remove();
        }
        if ($("#SubInfo_List_contents").children().length > 0) {
            //$("#SubInfo_List_contents").children().remove();
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
        
		var custcode = "";
        
        $.ajax({
            type: "POST",
            url: "<%=Config.this_SERVER_path%>/Contents/Business/M404/S404S010100.jsp",
            data: "custcode=" + custcode + "&From=" + startDate + "&To=" + endDate + "&JSPpage=" + "<%=JSPpage%>",
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
        $("#SubInfo_List_Doc").children().remove();
        $("#SubInfo_BOM").children().remove();
        $("#SubInfo_check").children().remove(); 
        
    }
    
	function fn_DetailInfo_List() {     
    	$.ajax(
    	    {
    	        type: "POST",
    	        url: "<%=Config.this_SERVER_path%>/Contents/Business/M404/S404S010110.jsp",
    	        data: "balju_no=" + vBalju_no + "&JSPpage=" + '<%=JSPpage%>',
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
	    
	function fn_Inspect_Detail() {     
    	$.ajax(
    	    {
    	        type: "POST",
    	        url: "<%=Config.this_SERVER_path%>/Contents/Business/M404/S404S010210.jsp",
    	        data: "OrderNo=" + vOrderNo   ,
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
/* 
	 수입검사요청
	  */
	function fn_Inspect_Request() {     
    	$.ajax(
    	    {
    	        type: "POST",
    	        url: "<%=Config.this_SERVER_path%>/Contents/Business/M404/S404S010220.jsp",
    	        data: "OrderNo=" + vOrderNo   ,
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
    
    // 수입검사등록
    function pop_fn_ImportInspect_Insert(obj) {
    	
		if(vOrderNo.length < 1){
			heneSwal.warning("<%=JSPpage%>!!! 검사할 제품을 선택하세요!!");
			return false;
		
		}
    	
    	var modalContentUrl;
//     	alert(vInspect_OrderNo);
    	modalContentUrl = "<%=Config.this_SERVER_path%>/Contents/Business/M404/S404S010101.jsp?OrderNo=" + vOrderNo
		+ "&lotno=" +vLotNo
		+ "&balju_no=" +vBalju_no
// 		+ "&Inspect_OrderNo=" + vInspect_OrderNo
		+ "&jspPage=" + "<%=JSPpage%>"
		+ "&num_gubun=<%=GV_GET_NUM_PREFIX%>";
    	
		var footer = "";
		var title = obj.innerText;
		var heneModal = new HenesysModal(modalContentUrl, 'large', title+"(S404S010101)", footer);
		heneModal.open_modal();
     }        
	
    // 시험성적서등록
    function pop_fn_JumunDoc_Insert(obj) {
		if(vOrderNo.length < 1){
			heneSwal.warning("<%=JSPpage%>!!! 등록할 제품을 선택하세요!!");
			return false;
		}
    	var modalContentUrl;
    	modalContentUrl = "<%=Config.this_SERVER_path%>/Contents/Business/M404/S404S010121.jsp?OrderNo=" + vOrderNo 
				+ "&OrderDetail=" + vOrderDetailSeq
				+ "&lotno=" + vLotNo
    			+ "&jspPage=" + "<%=JSPpage%>" 
    			+ "&num_gubun=<%=GV_GET_NUM_PREFIX%>"
    			+ "&innerText=" + "수입검사 " +obj.innerText;

    	var footer = "";
		var title = obj.innerText;
		var heneModal = new HenesysModal(modalContentUrl, 'large', title+"(S404S010121)", footer);
		heneModal.open_modal();
     }    
    
    function pop_fn_JumunInfo_Comlete(obj) {

    	if(vOrderNo.length < 1){
			<%-- $('#alertNote').html("<%=JSPpage%>!!! <BR><BR> 완료할 제품을 선택하세요!!"); --%>
			heneSwal.warning("<%=JSPpage%>!!! <BR><BR> 완료할 제품을 선택하세요!!");
			$('#modalalert').show();
			return;
		}
    	
		if(Import_inspect_count < import_request_Count){
			$('#alertNote').html($(obj).html() + " <BR> <%=JSPpage%>!!! <BR><BR> 수입검사결과의 수가 모자랍니다.  !!!");
			$('#modalalert').show();
			return;
		}
		if(Import_inspect_doc_count < Import_inspect_request_doc_count){
			$('#alertNote').html($(obj).html() + " <BR> <%=JSPpage%>!!! <BR><BR> 시험성적서 수가 모자랍니다.  !!!");
			$('#modalalert').show();
			return;
		}
		
    	var modalContentUrl = "<%=Config.this_SERVER_path%>/Contents/Business/M404/S404S010122.jsp?OrderNo=" + vOrderNo 
			+ "&OrderDetail=" + vOrderDetailSeq
			+ "&jspPage=" + "<%=JSPpage%>"
			+ "&lotno=" 	+ vLotNo ;

		pop_fn_popUpScr(modalContentUrl, obj.innerText+"(S404S010122)", "95%", "95%");
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
      		<button type="button" onclick="pop_fn_ImportInspect_Insert(this)" id="insert" class="btn btn-outline-dark">수입검사등록</button>
      		<button type="button" onclick="pop_fn_JumunDoc_Insert(this)" id="insert" class="btn btn-outline-dark">시험성적서등록</button>
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
	       			<a class="nav-link" id="DetailInfo_List" data-toggle="pill" href="#SubInfo_List_contents" role="tab">자재입고상세정보</a>
	       		</li>
	       		<li class="nav-item" onclick='com_fn_SubInfo_DOC_List(this,vOrderNo)'>
	       			<a class="nav-link" id="DetailInfo_List" data-toggle="pill" href="#SubInfo_List_contents" role="tab">문서목록</a>
	       		</li>
	       		<li class="nav-item" onclick='pop_fn_BomList(this, "<%=JSPpage%>")'>
	       			<a class="nav-link" id="DetailInfo_List" data-toggle="pill" href="#SubInfo_List_contents" role="tab">배합(BOM)정보</a>
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

   
<%-- 
    <div class="panel panel-default" style="margin-left:5px; margin-top:5px; margin-right:5px; margin-bottom:5px; width:100%" >
        <!-- Default panel contents -->
        <div class="panel-heading" style="font-weight: bold" id="MenuTitle">여기에메뉴타이틀</div>
        <div class="panel-body" >
           	<div style="float:left; width:100%;">
	        	<div>
		            <button data-author="mainBtn" type="button"  id="mainButton"  class="btn btn-primary active"
		            			style="width: auto; float: left; ">품질관리-수입검사</button>
		            <button data-author="insert" type="button" onclick="pop_fn_ImportInspect_Insert(this)" id="insert" class="btn btn-default" 
		            			style="width: auto;float: left; margin-left:30px;" >수입검사등록</button>		            			
					<button data-author="insert" type="button" onclick="pop_fn_JumunDoc_Insert(this)" id="insert" class="btn btn-default" 
								style="width: auto; float: left; margin-left:3px;">시험성적서등록</button>
<!-- 		            <button data-author="update" type="button" onclick="pop_fn_JumunInfo_Comlete(this)" id="update" class="btn btn-warning"  -->
<!-- 		            			style="width: auto; float: left;  margin-left:30px;">수입검사완료</button> -->
	            			
		            <label style="width: ; float: left; margin-left:3px;"></label>
	
	            </div>
	            <p style="width: auto; clear:both;">
	            </p>
	
	            <div class="panel panel-default">
	                <!-- Default panel contents -->
<!-- 	                <div class="panel-heading" style="font-size:16px; font-weight: bold"  id="InfoContentTitle"></div> -->
	                <div class="panel-body">
	                    <div style="float: left">
                        <table style="width: 100%; text-align:left; background-color:#e9e9e9;">
                            <tr><td style='width:15%; vertical-align: middle;'>
                            		<div class="panel-heading" style="font-size:16px; font-weight: bold"  id="InfoContentTitle"></div>
                            	</td>
                            	<td style='width:5%; vertical-align: middle'>등록일자 :</td>
                                <td style='width:6%;  vertical-align: middle'>
                                    <input type="text" data-date-format="yyyy-mm-dd" id="dateFrom" class="form-control" />
                                </td>
                                <td style='width:1%;vertical-align: middle'>
                                    &nbsp;~&nbsp;
                                </td>
                                <td style='width:6%; vertical-align: middle'>
                                    <input type="text" data-date-format="yyyy-mm-dd" id="dateTo" class="form-control" />
                                </td>
                                                               

                                <td style="width:52%; text-align:left">
                                    <button type="button" onclick="fn_MainInfo_List()" id="btn_Search" class="btn  btn-outline-success" style='width:100px;margin-left:10px;' >조 회</button>
                                </td>
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
	                	<li onclick='fn_DetailInfo_List()'><a id="DetailInfo_List"  href='#SubInfo_List_contents'>수입검사결과</a></li>
<!-- 	                	<li onclick='fn_Inspect_Detail()'> <a id="Inspect_Detail"   href='#SubInfo_List_contents'>수입검사결과상세</a></li> -->
<!-- 	                	<li onclick='fn_Inspect_Request()'> <a id="Inspect_Request"   href='#SubInfo_List_contents'>수입검사요청</a></li> -->
	                	<li onclick='com_fn_SubInfo_DOC_List(this,vOrderNo)'><a id="SubInfo_DOC_List"  href='#SubInfo_List_contents'>문서목록</a></li>
		                <li onclick='pop_fn_BomList(this, "<%=JSPpage%>")'><a id="SubInfo_BomList"  href='#SubInfo_BOM'>배합(BOM)정보</a></li>
			                <li id="Total_Info"></li> 
			                --%>
<%-- 		                <li onclick='pop_fn_ProcessCheckList(this, "<%=JSPpage%>")'><a id="SubInfo_checklist"  href='#SubInfo_check'>공정확인표</a></li> --%>
<!--  
		           </ul>
                    <div id="SubInfo_List_contents" ></div>
                    <div id="SubInfo_List_Doc" ></div>
                    <div id="SubInfo_BOM" ></div>
                    <div id="SubInfo_check"></div>
                </div>
                	
	        	</div>
			</div>
		</div>
    </div>  -->
    