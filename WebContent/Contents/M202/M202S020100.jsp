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
	String member_key = session.getAttribute("member_key").toString();
	String history_yn = session.getAttribute("history_yn").toString();
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
	
	String GV_PROCESS_MODIFY	= prcStatusCheck.GV_PROCESS_MODIFY;
	String GV_PROCESS_DELETE	= prcStatusCheck.GV_PROCESS_DELETE;
	String GV_PROCESS_NAME		= prcStatusCheck.GV_PROCESS_NAME;
	String GV_GET_NUM_PREFIX	= prcStatusCheck.GV_PROCESS_NUMBER_GUBUN;
%>  

<script type="text/javascript">
	
	var balju_Inspect_Count;
	var balju_List_Count;
	var import_request_Count;
	
	balju_Inspect_Count = parseInt(balju_Inspect_Count);
	balju_List_Count = parseInt(balju_List_Count);
	import_request_Count = parseInt(import_request_Count);
	
 	var vBalju_req_date = ""; 
 	var vBalju_no = "";  	
 	
 	vOrderNo = "";
 	vOrderDetailSeq = "";
 	vPart_cd = "";
 	 
    $(document).ready(function () {
    	new SetRangeDate("dateParent", "dateRange", 180);
		
    	var startDate = $('#dateRange').data('daterangepicker').startDate.format('YYYY-MM-DD');
       	var endDate = $('#dateRange').data('daterangepicker').endDate.format('YYYY-MM-DD');
        fn_MainInfo_List(startDate, endDate);
        
        fn_MainSubMenuSelect("<%=sMenuTitle%>");
        $("#InfoContentTitle").html("원부자재 발주현황");
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
        if ($("#SubInfo_List_Doc").children().length > 0) {
            $("#SubInfo_List_Doc").children().remove();
        }
        if ($("#SubInfo_BomList_BOM").children().length > 0) {
            $("#SubInfo_BomList_BOM").children().remove();
        }        
        if ($("#SubInfo_Balju_info").children().length > 0) {
            $("#SubInfo_Balju_info").children().remove();
        }
        if ($("#SubInfo_List_Hist").children().length > 0) {
            $("#SubInfo_List_Hist").children().remove();
        }      
    }

    function fn_MainInfo_List(startDate, endDate) {
        var custcode = "";
        
        $.ajax({
            type: "POST",
            url: "<%=Config.this_SERVER_path%>/Contents/Business/M202/S202S020200.jsp", 
            data: "custcode=" + custcode + "&From=" + startDate + "&To=" + endDate + "&JSPpage=" + "<%=JSPpage%>",
            beforeSend: function () {
                $("#MainInfo_List_contents").children().remove();
            },
            success: function (html) {
            	$("#MainInfo_List_contents").hide().html(html).fadeIn(100);
            }
        });
        
        $("#SubInfo_List_contents").children().remove();
        $("#SubInfo_Balju_info").children().remove();
        $("#SubInfo_BomList_BOM").children().remove();
        $("#SubInfo_List_Doc").children().remove();
        $("#SubInfo_List_Hist").children().remove();
    }
    
	function fn_DetailInfo_List() {     
    	$.ajax({
   	        type: "POST",
   	        url: "<%=Config.this_SERVER_path%>/Contents/Business/M202/S202S020110.jsp",
   	        data: "OrderNo=" + vOrderNo   + "&LotNo=" +vLotNo + "&BaljuNo=" + vBalju_no,
   	        success: function (html) {
   	            $("#SubInfo_List_contents").hide().html(html).fadeIn(100);
   	        }
   	    });
		return;
	}
    
	function fn_Balju_info_List() {     
    	$.ajax({
   	        type: "POST",
   	        url: "<%=Config.this_SERVER_path%>/Contents/Business/M202/S202S020150.jsp",
   	        data: "OrderNo=" + vOrderNo  + "&LotNo=" +vLotNo+ "&BaljuNo=" + vBalju_no,
   	        success: function (html) {
   	            $("#SubInfo_List_contents").hide().html(html).fadeIn(100);
   	        }
   	    });
		return;
	}

	function fn_ImportInspect_Request_List() {     
    	$.ajax({
   	        type: "POST",
   	        url: "<%=Config.this_SERVER_path%>/Contents/Business/M202/S202S020130.jsp",
   	        data: "OrderNo=" + vOrderNo  + "&LotNo=" +vLotNo + "&BaljuNo=" + vBaljuNo,
   	        success: function (html) {
   	            $("#SubInfo_List_contents").hide().html(html).fadeIn(100);
   	        }
   	    });
		return;
	}
	
	// 자재 검수 등록 (사용 안함, 수입검사에 통합됨)
	function pop_fn_Part_Inspect_Info_Insert(obj) {
		if(vOrderNo.length < 1){
			$('#alertNote').html($(obj).html() + " <BR> <%=JSPpage%>! <BR><BR> 주문 정보를 선택 해주세요.");
			$('#modalalert').show();
			return false;
		}
		
		var url = "<%=Config.this_SERVER_path%>/Contents/Business/M202/S202S020101.jsp"
					+ "?OrderNo=" + vOrderNo
					+ "&LotNo=" +vLotNo
					+ "&BaljuNo=" + vBalju_no
					+ "&jspPage=" + "<%=JSPpage%>"
					+ "&num_gubun=<%=GV_GET_NUM_PREFIX%>";
		var footer = '<button id="btn_plus_all" class="btn btn-info"' +
					 'onclick="parent.select_Balju_List_Inspect(gvOrderNumber)">전체등록</button>';
		var title = obj.innerText;
		var heneModal = new HenesysModal(url, 'large', title, footer);
		henemodal.open_modal();
	}
    
    function pop_fn_ProcCd_Update(obj) {
    	var modalContentUrl;
    	
    	if(vOrderNo.length < 1){
			$('#alertNote').html($(obj).html() + " <BR> <%=JSPpage%>!!! <BR><BR> 주문 정보를 선택 해주세요.  !!!");
			$('#modalalert').show();
			return false;
		}
    	
    	modalContentUrl = "<%=Config.this_SERVER_path%>/Contents/Business/M202/S202S020102.jsp"
       					+ "?ProcCd="		+ vProcCd
						+ "&RevisionNo="	+ vRevisionNo;
    	
		modalFramePopup.setTitle(obj.innerText);
		pop_fn_popUpScr(modalContentUrl, obj.innerText+"(S909S120102)", "630px", "680px");

		return false;
    }
    
    //수입검사요청 등록
    function pop_fn_Import_Inspect_Insert(obj) {
		
    	if(vOrderNo.length < 1){
			$('#alertNote').html($(obj).html() + " <BR> <%=JSPpage%>!!! <BR><BR> 주문 정보를 선택 해주세요.  !!!");
			$('#modalalert').show();
			return false;
		}
 	
    	modalContentUrl = "<%=Config.this_SERVER_path%>/Contents/Business/M202/S202S020111.jsp?OrderNo=" + vOrderNo
		+ "&LotNo=" +vLotNo
		+ "&BaljuNo=" + vBalju_no
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
    
    //문서등록
    function pop_fn_JumunDoc_Insert(obj) {
    	if(vOrderNo.length < 1){
			$('#alertNote').html("<%=JSPpage%>! <BR><BR> PO List 하나를 선택하세요.");
			$('#modalalert').show();
			return;
		}
    	var modalContentUrl;
    	modalContentUrl = "<%=Config.this_SERVER_path%>/Contents/Business/M101/S101S020121.jsp?OrderNo=" + vOrderNo 
    			+ "&jspPage=" + "<%=JSPpage%>" 
    			+ "&num_gubun=<%=GV_GET_NUM_PREFIX%>"
    			+ "&innerText=" + obj.innerText
    			+ "&LotNo=" + vLotNo
    			;
    	pop_fn_popUpScr(modalContentUrl, obj.innerText+"(S101S020121)", '550px', '1000px');
		return false;
     }
    

// 	 //검수결과등록완료
//     function pop_fn_JumunInfo_Comlete(obj) {
//     	if(vOrderNo.length < 1){
<%-- 			$('#alertNote').html($(obj).html() + " <BR> <%=JSPpage%>!!! <BR><BR> 주문 정보를 선택 해주세요.  !!!"); --%>
// 			$('#modalalert').show();
// 			return false;
// 		}    	
		 
// 		if(balju_Inspect_Count < 1){
<%-- 			$('#alertNote').html($(obj).html() + " <BR> <%=JSPpage%>!!! <BR><BR> 자재 검수정보가 없습니다.  !!!"); --%>
// 			$('#modalalert').show();
// 			return false;
// 		}

// 		if(parseInt(balju_List_Count) > parseInt(balju_Inspect_Count)){
<%-- 			$('#alertNote').html($(obj).html() + " <BR> <%=JSPpage%>!!! <BR><BR> 검수수량 모자랍니다..  !!!"); --%>
// 			$('#modalalert').show();
// 			return false;
// 		}
//     	var modalContentUrl;
<%--     	modalContentUrl = "<%=Config.this_SERVER_path%>/Contents/Business/M202/S202S020122.jsp?OrderNo=" + vOrderNo  --%>
// 		+ "&BaljuNo=" + vBalju_no
// 		+ "&LotNo=" + vLotNo
<%-- 		+ "&jspPage=" + "<%=JSPpage%>"; --%>
    	
// 			pop_fn_popUpScr(modalContentUrl, obj.innerText+"(S202S020122)", "80%", "90%");
// 		return false;
//      }

	function pop_fn_Balju_form2(obj){   	
		if(vBalju_no.length < 1){
			$('#alertNote').html("<%=JSPpage%>! <BR><BR> 발주목록 하나를 선택하세요.");
			$('#modalalert').show();
			return;
		}
		var url = "<%=Config.this_SERVER_path%>/Contents/CommonView/Balju_form_view_canvas.jsp"
				  +"?OrderNo=" + vOrderNo+"&BaljuNo="+vBalju_no;
		pop_fn_popUpScr(url, obj.innerText +"(Balju Canvas)", '85%', '1210px');
	    return;
	}

	var vIpgo_date;
	
	// 원재료 입고검사대장 캔버스
    function fn_HACCP_View_Canvas(obj) {
    	if(vIpgo_date =='' || vIpgo_date =='미검수'){
			$('#alertNote').html("<%=JSPpage%>!!! <BR><BR> 자재검수를 먼저 해야합니다!!");
			$('#modalalert').show();
			return;
		}
    	var modalContentUrl  = "<%=Config.this_SERVER_path%>/Contents/Business/M838/S838S070100_canvas_tyens.jsp" 
							 + "?page_start=" + 1  // 1페이지	
    						 + "&check_gubun=" + "IMPORT"
    						 + "&ipgo_date=" + vIpgo_date;
    	
    	pop_fn_popUpScr(modalContentUrl, obj.innerText+"(S838S070100_canvas)", '800px', '1500px');
		
    	return false;
	}
	
 	// 수입검사등록(자재검수와 통합함)
    function pop_fn_ImportInspect_Insert(obj) {
		if(vOrderNo.length < 1) {
			$('#alertNote').html($(obj).html() + " <BR> <%=JSPpage%>! <BR><BR> 주문 정보를 선택 해주세요.");
			$('#modalalert').show();
			return false;
		}
		
		var url = "<%=Config.this_SERVER_path%>/Contents/Business/M404/S404S010101_tyn.jsp?OrderNo=" + vOrderNo
					+ "&lotno=" +vLotNo
					+ "&balju_no=" +vBalju_no
					+ "&jspPage=" + "<%=JSPpage%>"
					+ "&num_gubun=<%=GV_GET_NUM_PREFIX%>";
		var footer = "";
		var title = obj.innerText;
		var heneModal = new HenesysModal(url, 'large', title, footer);
		heneModal.open_modal();
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
         		<button type="button" onclick="pop_fn_ImportInspect_Insert(this)" id="insert" class="btn btn-outline-dark">
         			자재검수결과등록
         		</button>
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
          			<a class="nav-link" id="DetailInfo_List" data-toggle="pill" href="#SubInfo_List_contents" role="tab">자재검수정보</a>
          		</li>
              	<li class="nav-item" onclick='pop_fn_Balju_form2(this)'>
              		<a class="nav-link" id="Balju_info_List" data-toggle="pill" href='#SubInfo_List_contents' role="tab">발주서</a>
              	</li>
                <li class="nav-item" onclick="fn_HACCP_View_Canvas(this)">
                	<a class="nav-link" id="SubInfo_BomList" data-toggle="pill" href='#SubInfo_List_contents' role="tab">입고검사일지</a>
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