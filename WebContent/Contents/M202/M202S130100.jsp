<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page language="java"
	import="java.sql.*,java.util.*,javax.servlet.http.*"%>
<%@ page import="mes.client.comm.*"%>
<%@ page import="mes.client.common.*"%>
<%@ page import="mes.client.guiComponents.*"%>
<%@ page import="mes.client.util.*"%>
<%@ page import="mes.client.conf.*"%>
<%
/* 
부적합관리(M202S130100.jsp)
 */
	String loginID = session.getAttribute("login_id").toString();
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
	ProcesStatusCheck prcStatusCheck = new ProcesStatusCheck(JSPpage+"|"+"ICRPRC"+"|");
	
	
	String GV_PROCESS_MODIFY	= prcStatusCheck.GV_PROCESS_MODIFY;
	String GV_PROCESS_DELETE	= prcStatusCheck.GV_PROCESS_DELETE;
	String GV_GET_NUM_PREFIX	= prcStatusCheck.GV_PROCESS_NUMBER_GUBUN;

%>

<script type="text/javascript">
 	  
 	
 	var vOrderNo = "";
	var vLotNo = ""; 
	var vProd_cd = "";
	var vProd_rev = "";
	var vProduct_nm = "";
	var vCustCode = ""; 
 	var vCustName = ""; 
 	var vRequestDate ="";
 	var vLdelivDate ="";
	var vStatus="";		//리스트 선택시 세팅
	var vIncong_no="";
	var vProc_cd = "";
	var vProc_cd_rev = "";
	var vProcess_name="";
	var vPart_name="";
	var vIncong_reason_code="";
	var vProc_method="";
	var vIncong_note="";
	var vDamdang_user="";

	
    $(document).ready(function () {
    	new SetDate("dateFrom", -180);
    	new SetDate("dateTo", 0);        
    	
<%--         makeMenu("<%=htmlsideMenu%>"); --%>
        fn_MainSubMenuSelect("<%=sMenuTitle%>");
		$("#InfoContentTitle").html("주문목록(PO List)");

    	fn_MainInfo_List();
		
      //탭 클릭시 처리하는 Function
	    //$( function() {$( "#tabs" ).tabs();});

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
		var tr = $($("TableS202S130100 tr")[0]);
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
    

    function fn_LoadSubPage() {
        fn_clearList();
        fn_MainInfo_List();
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

    function fn_MainInfo_List() {
//     	var custcode = $("#txt_cust_code").val().toStrCing(); 
    	var custcode	= $("#txt_cust_code").val(); 
        var from = $("#dateFrom").val();
        var to = $("#dateTo").val();
//         vCustCode = $("#txt_cust_code").val();
        $.ajax(
        {
            type: "POST",
            url: "<%=Config.this_SERVER_path%>/Contents/Business/M202/S202S130100.jsp", 
<%--        data: "From=" + from + "&To=" + to  + "&JSPpage=" + "<%=JSPpage%>"  "custcode=" + custcode, --%>
			data: "custcode=" + custcode + "&From=" + from + "&To=" + to    + "&JSPpage=" + "<%=JSPpage%>" ,
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
        
        $("#SubInfo_List_contents").children().remove();
        $("#SubInfo_List_Doc").children().remove();
        $("#SubInfo_BOM").children().remove();
        $("#SubInfo_check").children().remove();
    }
    
	function fn_DetailInfo_List() {     

        var custcode = $("#txt_cust_code").val().toString(); 
    	$.ajax(
    	    {
    	        type: "POST",
    	        url: "<%=Config.this_SERVER_path%>/Contents/Business/M202/S202S130110.jsp",
    	        data: "&OrderNo=" + vOrderNo + "&lotno=" + vLotNo + "&prod_cd=" + vProd_cd + "&incong_no=" + vIncong_no + "&JSPpage=" + "<%=JSPpage%>",
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


    //부적합등록
    function pop_fn_incong_Insert(obj) {
		if(vOrderNo.length < 1){
			$('#alertNote').html("<%=JSPpage%>!!! <BR><BR> 부적합 목록을 선택하세요!!");
			$('#modalalert').show();
			return;
		}
    	var modalContentUrl;
    	//GV_JSPPAGE="",GV_NUM_GUBUN="", GV_ORDER_NO="", GV_lotno="",GV_PROD_CD="",GV_PROD_CD_REV="",GV_PRODUCT_NM="",GV_LOT_NO
    	modalContentUrl = "<%=Config.this_SERVER_path%>/Contents/Business/M202/S202S130101.jsp?OrderNo=" + vOrderNo
				+ "&lotno=" + vLotNo
    			+ "&prod_cd=" + vProd_cd
    			+ "&prod_rev=" + vProd_rev
    			+ "&product_nm=" + vProduct_nm
    			+ "&proc_cd=" + vProc_cd
    			+ "&proc_cd_rev=" + vProc_cd_rev
    			+ "&process_name=" + vProcess_name
    			+ "&jspPage=" + "<%=JSPpage%>" 
    			+ "&num_gubun=<%=GV_GET_NUM_PREFIX%>";
    	pop_fn_popUpScr(modalContentUrl, obj.innerText+"(S202S130101)", '550px', '800px');
     }  
    
    function pop_fn_JumunDoc_Insert(obj) {
		if(vOrderNo.length < 1){
			$('#alertNote').html("<%=JSPpage%>!!! <BR><BR> PO List 하나를 선택하세요!!");
			$('#modalalert').show();
			return;
		}
    	var modalContentUrl;
    	modalContentUrl = "<%=Config.this_SERVER_path%>/Contents/Business/M101/S202S130121.jsp?OrderNo=" + vOrderNo 
				+ "&lotno=" + vLotNo
    			+ "&jspPage=" + "<%=JSPpage%>" 
    			+ "&num_gubun=<%=GV_GET_NUM_PREFIX%>"
    			+ "&LotNo=" + vLotNo
    			;

    	pop_fn_popUpScr(modalContentUrl, obj.innerText+"(S202S130121)", '550px', '1000px');
//     	pop_fn_popUpScr(modalContentUrl, obj.innerText+"(S202S130121)", '420px', '960px');
		return false;
     }
    
    //부적합수정
    function pop_fn_incong_Update(obj) {
//     	alert(vProc_cd);
//     	if(vProc_cd==false){
//     		alert("부적합 제품을 선택하세요")
//     		return false;
//     	}
    	
		if(vIncong_no.length < 1){
			$('#alertNote').html("<%=JSPpage%>!!! <BR><BR> 부적합 상세 목록을 선택하세요!!");
			$('#modalalert').show();
			return;
		}
		if(vProc_cd==false){
			$('#alertNote').html("<%=JSPpage%>!!! <BR><BR> 부적합 상세 목록을 선택하세요!!");
			$('#modalalert').show();
			return;
		}
    	var  modalContentUrl = "<%=Config.this_SERVER_path%>/Contents/Business/M202/S202S130102.jsp?OrderNo=" + vOrderNo
				+ "&lotno=" + vLotNo
				+ "&prod_cd=" + vProd_cd
				+ "&prod_rev=" + vProd_rev
				+ "&product_nm=" + vProduct_nm
				+ "&proc_cd=" + vProc_cd
				+ "&prod_cd=" + vProd_cd
				+ "&part_cd=" + vPart_cd
				+ "&process_name=" + vProcess_name
				+ "&part_name=" + vPart_name
				+ "&incong_reason_code=" + vIncong_reason_code
				+ "&proc_method=" + vProc_method
				+ "&incong_note=" + vIncong_note
				+ "&incong_no=" + vIncong_no
				+ "&damdang_user=" + vDamdang_user
				+ "&jspPage=" + "<%=JSPpage%>" 
				+ "&num_gubun=<%=GV_GET_NUM_PREFIX%>";
    	pop_fn_popUpScr(modalContentUrl, obj.innerText+"(S202S130102)", '550px', '800px');
     }
    
    //부적합삭제
    function pop_fn_incong_Delete(obj) {		

//     	if(vIncong_no==false){
//     		alert("삭제할 제품을 선택하세요")
//     		return false;
//     	}
		if(vIncong_no.length < 1){
			$('#alertNote').html("<%=JSPpage%>!!! <BR><BR> 부적합 상세 목록을 선택하세요!!");
			$('#modalalert').show();
			return;
		}
		if(vProc_cd==false){
			$('#alertNote').html("<%=JSPpage%>!!! <BR><BR> 부적합 상세 목록을 선택하세요!!");
			$('#modalalert').show();
			return;
		}
    	
    	var modalContentUrl;
    	modalContentUrl = "<%=Config.this_SERVER_path%>/Contents/Business/M202/S202S130103.jsp?OrderNo=" + vOrderNo
				+ "&lotno=" + vLotNo
				+ "&prod_cd=" + vProd_cd
				+ "&prod_rev=" + vProd_rev
				+ "&product_nm=" + vProduct_nm
				+ "&proc_cd=" + vProc_cd
				+ "&prod_cd=" + vProd_cd
				+ "&part_cd=" + vPart_cd
				+ "&process_name=" + vProcess_name
				+ "&part_name=" + vPart_name
				+ "&incong_reason_code=" + vIncong_reason_code
				+ "&proc_method=" + vProc_method
				+ "&incong_note=" + vIncong_note
				+ "&incong_no=" + vIncong_no
				+ "&damdang_user=" + vDamdang_user
				+ "&jspPage=" + "<%=JSPpage%>" 
				+ "&num_gubun=<%=GV_GET_NUM_PREFIX%>";
    	pop_fn_popUpScr(modalContentUrl, obj.innerText+"(S202S130103)", '550px', '800px');
     }
  
    function pop_fn_JumunInfo_Comlete(obj) {
    	
		if(vIncong_no.length < 1){
			$('#alertNote').html("<%=JSPpage%>!!! <BR><BR> 부적합 상세 목록을 선택하세요!!");
			$('#modalalert').show();
			return;
		}

    	var modalContentUrl = "<%=Config.this_SERVER_path%>/Contents/Business/M202/S202S130122.jsp?OrderNo=" + vOrderNo
		+ "&lotno=" + vLotNo
		+ "&prod_cd=" + vProd_cd
		+ "&prod_rev=" + vProd_rev
		+ "&product_nm=" + vProduct_nm
		+ "&proc_cd=" + vProc_cd
		+ "&prod_cd=" + vProd_cd
		+ "&part_cd=" + vPart_cd
		+ "&process_name=" + vProcess_name
		+ "&part_name=" + vPart_name
		+ "&incong_reason_code=" + vIncong_reason_code
		+ "&proc_method=" + vProc_method
		+ "&incong_note=" + vIncong_note
		+ "&incong_no=" + vIncong_no
		+ "&damdang_user=" + vDamdang_user
		+ "&jspPage=" + "<%=JSPpage%>" 
		+ "&num_gubun=<%=GV_GET_NUM_PREFIX%>";
		pop_fn_popUpScr(modalContentUrl, obj.innerText+"(S405S030122)", '550px', '800px');
		return false;
     }
 
    </script>
<div class="panel panel-default"
	style="margin-left: 5px; margin-top: 5px; margin-right: 5px; margin-bottom: 5px; width: 100%">
	<!-- Default panel contents -->
	<div class="panel-heading" style="font-weight: bold" id="MenuTitle">여기에메뉴타이틀</div>
	<div class="panel-body">

		<div>
			<button data-author="mainBtn" type="button" id="mainButton"
				class="btn btn-primary active" style="width: auto; float: left;">품질관리-부적합</button>
<!-- 			<button data-author="insert" type="button" -->
<!-- 				onclick="pop_fn_incong_Insert(this)" id="insert" class="btn btn-default" -->
<!-- 				style="width: auto; float: left; margin-left: 30px;">부적합등록</button> -->
            <button data-author="insert" type="button" onclick="pop_fn_JumunDoc_Insert(this)" id="insert" class="btn btn-default" 
            			style="width: auto; float: left; margin-left:30px;">문서등록</button>
			<button data-author="update" type="button"
				onclick="pop_fn_incong_Update(this)" id="update" class="btn btn-outline-success"
				style="width: auto; float: left; margin-left: 3px;">부적합수정</button>
			<button data-author="delete" type="button"
				onclick="pop_fn_incong_Delete(this)" id="delete" class="btn btn-danger"
				style="width: auto; float: left; margin-left: 3px;">부적합삭제</button>
<!-- 	        <button data-author="update" type="button" onclick="pop_fn_JumunInfo_Comlete(this)" id="update"  -->
<!-- 	        	class="btn btn-warning"  style="width: auto; float: left;  margin-left:30px;">부적합등록완료</button> -->
			<label style="width:; float: left; margin-left: 3px;"></label>

		</div>
		<p style="width: auto; clear: both;"></p>

		<div class="panel panel-default">
			<!-- Default panel contents -->
<!-- 			<div class="panel-heading" style="font-size: 16px; font-weight: bold" id="InfoContentTitle"></div> -->
			<div class="panel-body">
				<div style="float: left">
					<table style="width: 100%; text-align: left; background-color:#e9e9e9; " >
						<tr>
							<td style='width:15%; vertical-align: middle;'>
                            	<div class="panel-heading" style="font-size:16px; font-weight: bold"  id="InfoContentTitle"></div>
                            </td>
                            <td style='width:6%; vertical-align: middle'>발생일자 : </td>
<!-- 							<td style='width:6%; vertical-align: middle'> -->
<!-- 								<h5>&nbsp; 발생일자 : &nbsp;</h5> -->
<!-- 							</td> -->
							<td style='width:6%; vertical-align: middle'>
								<input type="text" data-date-format="yyyy-mm-dd" id="dateFrom" class="form-control" style="width: 110px; border: solid 1px #cccccc;" />
							</td>
							<td style='width:1%; vertical-align: middle'>&nbsp;~&nbsp;</td>
							<td style='width:6%; vertical-align: middle'>
								<input type="text" data-date-format="yyyy-mm-dd" id="dateTo" class="form-control" style="width: 110px; border: solid 1px #cccccc;" />
							</td>

<!-- 							<td style='vertical-align: middle'> -->
<!-- 								<h5>&nbsp;&nbsp;&nbsp; 검색어 : &nbsp;</h5> -->
<!-- 							</td> -->
							<td style='vertical-align: middle'>
<!-- 								<input type="text" class="form-control" id="txt_CustName" style="width: 180px; float: left" />  -->
								<input type="hidden" class="form-control" id="txt_cust_code" style="width: 120px" />
<!-- 								<label style="float: left">&nbsp;</label> -->
<!-- 								<button type="button" onclick="pop_fn_CustName_View(0,'O')" id="btn_SearchCust" class="btn btn-info" style="float: left"> 검색</button> -->
							</td>
							<td style='vertical-align: middle'>&nbsp;</td>
							<td style="width:62%; text-align:left">&nbsp;
								<button type="button" onclick="fn_MainInfo_List()" id="btn_Search" class="btn btn-outline-success" style="width: 110px;">조회</button>
							</td>
						</tr>
					</table>
					<p></p>

				</div>
				<div style="clear: both; height: 10px; border-top: 1px solid #D2D6Df;">
				</div>
				<div id="MainInfo_List_contents" style="clear: both;"></div>
			</div>

			<div id="tabs">
				<ul >
					<li onclick='fn_DetailInfo_List()'><a id="DetailInfo_List"  href='#SubInfo_List_contents'>부적합</a></li>
<!-- 					<li onclick='com_fn_SubInfo_DOC_List(this,vOrderNo)'><a id="SubInfo_DOC_List"  href='#SubInfo_List_Doc'>기술문서목록</a></li> -->
<%-- 					<li onclick='pop_fn_BomList(this, "<%=JSPpage%>")'><a id="SubInfo_BomList"  href='#SubInfo_BOM'>BOM정보</a></li> --%>
<%-- 					<li onclick='pop_fn_ProcessCheckList(this, "<%=JSPpage%>")'><a id="SubInfo_checklist"  href='#SubInfo_check'>공정확인표</a></li> --%>
				</ul>
				<div id="SubInfo_List_contents" ></div>
				<div id="SubInfo_List_Doc" ></div>
				<div id="SubInfo_BOM" ></div>
				<div id="SubInfo_check"></div>
		  	</div>
		  	
		</div>
	</div>
</div>