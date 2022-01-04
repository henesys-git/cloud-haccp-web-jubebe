<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*,java.util.*,javax.servlet.http.*"%>
<%@ page import="mes.client.comm.*" %>
<%@ page import="mes.client.common.*" %>
<%@ page import="mes.client.guiComponents.*" %>
<%@ page import="mes.client.util.*" %>
<%@ page import="mes.client.conf.*" %>
<%
/* 
발주자재검수(M202S020100.jsp)
 */
	String loginID = session.getAttribute("login_id").toString();
	if(loginID==null||loginID.equals("")){              // id가 Null 이거나 없을 경우
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
	
	String GV_PROCESS_MODIFY = prcStatusCheck.GV_PROCESS_MODIFY;
	String GV_PROCESS_DELETE = prcStatusCheck.GV_PROCESS_DELETE;
	String GV_PROCESS_NAME = prcStatusCheck.GV_PROCESS_NAME;
	String GV_GET_NUM_PREFIX = prcStatusCheck.GV_PROCESS_NUMBER_GUBUN;
%>  

<script type="text/javascript">
	var balju_Inspect_Count;
	var import_request_Count;
		
 	var vBalju_req_date = ""; 
 	var vBalju_no = "";
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

        fn_MainSubMenuSelect("<%=sMenuTitle%>");
		$("#InfoContentTitle").html("주문목록(PO List)");
		fn_tagProcess();
		
	    //탭 클릭시 처리하는 Function
	    //$( function() {$( "#tabs" ).tabs();});
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
    
	function fn_CheckBox_Chaned(){	    
		var tr = $($("tableS202S020001 tr")[0]);
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
        if ($("#ImportInspect_Request").children().length > 0) {
            $("#ImportInspect_Request").children().remove();
        }
    }

    function fn_MainInfo_List(startDate, endDate) {
        var custcode = ""; 
        
        $.ajax({
            type: "POST",
            url: "<%=Config.this_SERVER_path%>/Contents/Business/M202/S202S020500.jsp", 
            data: "custcode=" + custcode + "&From=" + startDate + "&To=" + endDate + "&JSPpage=" + vJSPpage,
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
    	$.ajax({
    	        type: "POST",
    	        url: "<%=Config.this_SERVER_path%>/Contents/Business/M202/S202S020110.jsp",
    	        data: "OrderNo=" + vOrderNo   + "&order_detail_seq=" +vOrderDetailSeq	+ "&BaljuNo=" +vBaljuNo	 +	"&LotNo=" +vLotNo,
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
    
	function fn_Balju_info_List() {     
    	$.ajax(
    	    {
    	        type: "POST",
    	        url: "<%=Config.this_SERVER_path%>/Contents/Business/M202/S202S010110.jsp",
    	        data: "OrderNo=" + vOrderNo ,
    	        beforeSend: function () {
//     	            //$("#SubInfo_List_contents").children().remove();
    	        },
    	        success: function (html) {
    	            $("#SubInfo_List_contents").hide().html(html).fadeIn(1000);
    	        },
    	        error: function (xhr, option, error) {
    	        }
    	    });
		return;
	}

	function fn_ImportInspect_Request_List() {     
    	$.ajax(
    	    {
    	        type: "POST",
    	        url: "<%=Config.this_SERVER_path%>/Contents/Business/M202/S202S020130.jsp",
    	        data: "OrderNo=" + vOrderNo ,
    	        beforeSend: function () {
//     	            $("#SubInfo_List_contents").children().remove();
    	        },
    	        success: function (html) {
    	            $("#SubInfo_List_contents").hide().html(html).fadeIn(1000);
    	        },
    	        error: function (xhr, option, error) {
    	        }
    	    });
		return;
	}
	
    //자재검수등록
    function pop_fn_Part_Inspect_Info_Insert(obj) {
    	var modalContentUrl;
    	
    	if(vOrderNo.length < 1){
			$('#alertNote').html($(obj).html() + " <BR> <%=JSPpage%>!!! <BR><BR> PO List 하나를 선택하세요!!  !!!");
			$('#modalalert').show();
			return false;
		}
    	
    	modalContentUrl = "<%=Config.this_SERVER_path%>/Contents/Business/M202/S202S020501.jsp?OrderNo=" + vOrderNo
		+ "&order_detail_seq=" +vOrderDetailSeq
		+"&lotno=" +vLotNo
		+"&balju_no=" +vBaljuNo
		+ "&jspPage=" + "<%=JSPpage%>"
		+ "&num_gubun=<%=GV_GET_NUM_PREFIX%>"
		;
    	pop_fn_popUpScr(modalContentUrl, obj.innerText+"(S202S020501)", "80%", "90%");
    }
    
    //수입검사요청 등록
    function pop_fn_Import_Inspect_Insert(obj) {
		
    	if(vOrderNo.length < 1){
			$('#alertNote').html($(obj).html() + " <BR> <%=JSPpage%>!!! <BR><BR> 주문 정보를 선택 해주세요.  !!!");
			$('#modalalert').show();
			return false;
		}
 	
    	modalContentUrl = "<%=Config.this_SERVER_path%>/Contents/Business/M202/S202S020111.jsp?OrderNo=" + vOrderNo
		+ "&order_detail_seq=" +vOrderDetailSeq
		+ "&jspPage=" + "<%=JSPpage%>"
		+ "&num_gubun=<%=GV_GET_NUM_PREFIX%>";
    	pop_fn_popUpScr(modalContentUrl, obj.innerText+"(S202S020111)",  "80%", "90%");
     }    
    
    //수입검사요청 수정
    function pop_fn_Import_Inspect_Update(obj) {
    	var modalContentUrl;
    	
    	modalContentUrl = "<%=Config.this_SERVER_path%>/Contents/Business/M202/S202S020112.jsp";
    	pop_fn_popUpScr(modalContentUrl, obj.innerText+"(S202S020112)", "450px", "1500px");
     }

    //수입검사요청 삭제
    function pop_fn_Import_Inspect_Delete(obj) {
    	var modalContentUrl;
    	
    	modalContentUrl = "<%=Config.this_SERVER_path%>/Contents/Business/M202/S202S010113.jsp";
    	pop_fn_popUpScr(modalContentUrl, obj.innerText+"(S202S010113)", "430px", "800px");
     }
    
    function pop_fn_JumunDoc_Insert(obj) {
    	if(vOrderNo.length < 1){
			$('#alertNote').html("<%=JSPpage%>! <BR><BR> PO List 하나를 선택하세요.");
			$('#modalalert').show();
			return;
		}
    	var modalContentUrl;
    	modalContentUrl = "<%=Config.this_SERVER_path%>/Contents/Business/M101/S101S020121.jsp?OrderNo=" + vOrderNo 
// 				+ "&OrderDetail=" + vOrderDetailSeq
    			+ "&jspPage=" + "<%=JSPpage%>" 
    			+ "&num_gubun=<%=GV_GET_NUM_PREFIX%>"
    			+ "&innerText=" + obj.innerText
    			+ "&LotNo=" + vLotNo
    			;

    	pop_fn_popUpScr(modalContentUrl, obj.innerText+"(S101S020121)", '550px', '1000px');
		return false;
     }

	 //
    function pop_fn_JumunInfo_Comlete(obj) {
		
    	if(vOrderNo.length < 1){
			$('#alertNote').html($(obj).html() + " <BR> <%=JSPpage%>!!! <BR><BR> 주문 정보를 선택 해주세요.  !!!");
			$('#modalalert').show();
			return false;
		}    	
		 
// 		if(balju_Inspect_Count < 1){
<%-- 			$('#alertNote').html($(obj).html() + " <BR> <%=JSPpage%>!!! <BR><BR> 자재 검수정보가 없습니다.  !!!"); --%>
// 			$('#modalalert').show();
// 			return false;
// 		}
		
    	var modalContentUrl;
    	modalContentUrl = "<%=Config.this_SERVER_path%>/Contents/Business/M202/S202S020122.jsp?OrderNo=" + vOrderNo 
		+ "&OrderDetail=" + vOrderDetailSeq
			+ "&jspPage=" + "<%=JSPpage%>";
    	
			pop_fn_popUpScr(modalContentUrl, obj.innerText+"(S202S020122)", "80%", "90%");
		return false;
     }
</script>
    
    
    <!-- <div class="panel panel-default" style="margin-left:5px; margin-top:5px; margin-right:5px; margin-bottom:5px; width:100%" >
        Default panel contents
        <div class="panel-heading" style="font-weight: bold" id="MenuTitle">여기에메뉴타이틀</div>
        <div class="panel-body" >
        
        	<div>
	            <button data-author="main" type="button"  id="mainButton"  class="btn btn-primary active"
	            			style="width: auto; float: left; ">메인버튼</button>
	            <button data-author="insert" type="button" onclick="pop_fn_Part_Inspect_Info_Insert(this)" id="insert" class="btn btn-default" 
	            			style="width: auto;float: left; margin-left:30px;">자재추가검수등록</button>
	            <button data-author="insert" type="button" onclick="pop_fn_JumunDoc_Insert(this)" id="insert" class="btn btn-default" 
	            			style="width: auto; float: left; margin-left:3px;">문서등록</button>
            </div>
            <p style="width: auto; clear:both;">
            </p>

            <div class="panel panel-default">
                Default panel contents
                <div class="panel-body">
                    <div style="float: left">
                        <table style="width: 100%; text-align:left; background-color:#e0e0e0;">
                            <tr><td style='width:20%; vertical-align: middle;'>
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
                                <td style="width:62%; text-align:left">
                                    <button type="button" onclick="fn_MainInfo_List()" id="btn_Search" class="btn  btn-outline-success" style='width:100px; margin-left: 20px;'>조 회</button>
                                </td>
                            </tr>
                        </table>
                        <p>
                        </p>
                        
                    </div>
 					<div  style="clear:both; height:10px ;border-top: 1px solid #D2D6Df;" >
                    </div>
                    <div id="MainInfo_List_contents"  style="clear:both;" >
                    </div>
                </div>

	                <div id="tabs">
			         	<ul >
			                <li onclick='fn_DetailInfo_List()'><a id="DetailInfo_List"  href=#SubInfo_List_contents>자재검수정보</a></li>
			                <li onclick='com_fn_SubInfo_DOC_List(this,vOrderNo)'><a id="SubInfo_DOC_List"  href='#SubInfo_List_Doc'>문서목록</a></li>
			                <li id="Total_Info"></li>
			            </ul>
	                    <div id="SubInfo_List_contents"></div>
	                    <div id="ImportInspect_Request" ></div>
	                    <div id="SubInfo_BomList_BOM" ></div>
                    	<div id="SubInfo_Balju_info"	></div>
	                </div>

        	</div>
		</div>
    </div> -->
    
    
    

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
      		<button type="button" onclick="pop_fn_Part_Inspect_Info_Insert(this)" id="insert" class="btn btn-outline-dark">자재추가검수등록</button>
         	<button type="button" onclick="pop_fn_JumunDoc_Insert(this)" id="insert" class="btn btn-outline-dark">문서등록</button>
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
       				<a class="nav-link" id="DetailInfo_List" data-toggle="pill" href='#SubInfo_List_contents' role="tab">자재검수정보</a>
       			</li>
                <li class="nav-item" onclick='com_fn_SubInfo_DOC_List(this, vOrderNo)'>
                	<a class="nav-link" id="SubInfo_DOC_List" data-toggle="pill" href='#SubInfo_List_Doc' role="tab">문서목록</a>
                </li>
                <li class="nav-item" id="Total_Info"></li>
       		</ul>
       		<div class="tab-content" id="custom-tabs-one-tabContent">
       			<div class="tab-pane fade" id="SubInfo_List_contents" role="tabpanel"></div>
           	</div>
    	</div>
    </div>
  </div><!-- /.container-fluid -->
</div>
<!-- /.content -->