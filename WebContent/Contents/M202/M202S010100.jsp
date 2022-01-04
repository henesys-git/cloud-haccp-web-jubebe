<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*,java.util.*,javax.servlet.http.*"%>
<%@ page import="mes.client.comm.*" %>
<%@ page import="mes.client.common.*" %>
<%@ page import="mes.client.guiComponents.*" %>
<%@ page import="mes.client.util.*" %>
<%@ page import="mes.client.conf.*" %>
<%
/* 
자재발주등록(M202S010100.jsp)
 */
	String loginID = session.getAttribute("login_id").toString();
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
	
	String GV_PROCESS_MODIFY = prcStatusCheck.GV_PROCESS_MODIFY;
	String GV_PROCESS_DELETE = prcStatusCheck.GV_PROCESS_DELETE;
	String GV_GET_NUM_PREFIX = prcStatusCheck.GV_PROCESS_NUMBER_GUBUN;

	System.out.println(request.getRemoteAddr());
	makeQueueList MainQueue = new makeQueueList(JSPpage);
%>

<script type="text/javascript">

	vOrderNo = "";  
	vOrderDetailSeq = "";
	
 	var vBalju_no = "";  
 	var vprod_cd = "";  
 	var vproduct_nm = "";  
 	var vcust_nm = "";  
 	var vbom_no = "";  
 	
	var vJSPpage = '<%=JSPpage%>';
	
    $(document).ready(function () {
    	new SetDate("dateFrom", -180);
    	new SetDate("dateTo", 0);
    	
        fn_MainSubMenuSelect("<%=sMenuTitle%>");
        
		$("#InfoContentTitle").html("주문목록(PO List)");
		fn_MainInfo_List();
		
        fn_tagProcess('<%=JSPpage%>');;

    	makeMainQueue("<%=MainQueue.GetQueueList()%>");
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
        if ($("#SubInfo_bom").children().length > 0) {
            $("#SubInfo_bom").children().remove();
        }
        if ($("#ProcessInfo_sibang").children().length > 0) {
            $("#ProcessInfo_sibang").children().remove();
        }
        if ($("#ProcessInfo_processcheck").children().length > 0) {
            $("#ProcessInfo_processcheck").children().remove();
        }        
    }

    function fn_MainInfo_List() {
        var custcode = ""; 
        var from = $("#dateFrom").val();
        var to = $("#dateTo").val();
        $.ajax({
            type: "POST",
            url: "<%=Config.this_SERVER_path%>/Contents/Business/M202/S202S010100.jsp", 
            data: "custcode=" + custcode + "&From=" + from + "&To=" + to    + "&JSPpage=" + "<%=JSPpage%>",
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
        $("#SubInfo_Balju_seo").children().remove();
        $("#SubInfo_List_Doc").children().remove();
    }
        
	function fn_DetailInfo_List() { 
    	$.ajax(
    	    {
    	        type: "POST",
    	        url: "<%=Config.this_SERVER_path%>/Contents/Business/M202/S202S010110.jsp",
    	        data: "OrderNo=" + vOrderNo + "&LotNo=" +vLotNo,
    	        success: function (html) {
    	            $("#SubInfo_List_contents").hide().html(html).fadeIn(100);
    	        },
    	        error: function (xhr, option, error) {
    	        }
    	    });
		return;
	}

    //발주서등록
    function pop_fn_BauljuInfo_Insert(obj) {
    	if(vOrderNo.length < 1){
			$('#alertNote').html(obj.innerText + " <BR> <%=JSPpage%> <BR><BR> 주문정보를 선택하세요");
			$('#modalalert').show();
			return false;
		}
    	var modalContentUrl;
    	
    	modalContentUrl = "<%=Config.this_SERVER_path%>/Contents/Business/M202/S202S010101.jsp?OrderNo=" + vOrderNo
    			+ "&order_detail_seq=" +vOrderDetailSeq
    			+ "&jspPage=" + "<%=JSPpage%>"
    			+ "&num_gubun=<%=GV_GET_NUM_PREFIX%>"
    			+ "&product_nm=" +vProdNm
    			+ "&cust_nm=" +vCustName
    			+ "&LotNo=" +vLotNo
    			;
    			
		pop_fn_popUpScr(modalContentUrl, obj.innerText+"(S202S010101)", "90%", "90%");
    }
    
    //발주서수정
    function pop_fn_BauljuInfo_Update(obj) {  	
    	var modalContentUrl;
    	if(vBalju_no.length < 1){
    		$('#alertNote').html($(obj).html() + " <BR> <%=JSPpage%> <BR><BR> 발주정보가 없습니다. <BR> 발주정보 Tab의 발주서를 클릭하고 처리하세요");
			$('#modalalert').show();
			return false;
		}
    	
    	modalContentUrl = "<%=Config.this_SERVER_path%>/Contents/Business/M202/S202S010102.jsp?OrderNo=" + vOrderNo
    			+ "&BaljuNo=" + vBalju_no
    			+ "&LotNo=" +vLotNo
    			+ "&jspPage=" + "<%=JSPpage%>" ;
    	pop_fn_popUpScr(modalContentUrl, obj.innerText+"(S202S010102)", "90%", "90%");
     }
 
    //발주서삭제
    function pop_fn_BauljuInfo_Delete(obj) { 
    	var modalContentUrl;
    	if(vBalju_no.length < 1){
    		$('#alertNote').html($(obj).html() + " <BR> <%=JSPpage%> <BR><BR> 발주정보가 없습니다. <BR> 발주정보 Tab의 발주서를 클릭하고 처리하세요");
			$('#modalalert').show();
			return false;
		}
    	modalContentUrl = "<%=Config.this_SERVER_path%>/Contents/Business/M202/S202S010103.jsp?OrderNo=" + vOrderNo
    		+ "&BaljuNo=" + vBalju_no 
    		+ "&LotNo=" +vLotNo
			+ "&jspPage=" + "<%=JSPpage%>" ;
    	pop_fn_popUpScr(modalContentUrl, obj.innerText+"(S202S010103)", "90%", "90%");
     }
    
    //문서등록
    function pop_fn_JumunDoc_Insert(obj) {
		if(vOrderNo.length < 1){
			$('#alertNote').html("<%=JSPpage%> <BR><BR> PO List 하나를 선택하세요");
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
</script>
    
 <!-- 캐시 비적용 -->
    <meta http-equiv="Cache-Control" content="no-cache"/>
	<meta http-equiv="Expires" content="0"/>
	<meta http-equiv="Pragma" content="no-cache"/>

    <div class="panel panel-default" style="margin-left:5px; margin-top:5px; margin-right:5px; margin-bottom:5px; width:100%">
        <!-- Default panel contents -->
        <div class="panel-heading" style="font-weight: bold" id="MenuTitle">여기에메뉴타이틀</div>	                    
        <div class="panel-body">
        	<div style="float: left;">
	            <button data-author="mainBtn" type="button"  id="mainButton"  class="btn btn-primary active"
	            			style="width: auto; float: left; ">발주재고관리-자재발주관리</button>
	            <button data-author="insert" type="button" onclick="pop_fn_BauljuInfo_Insert(this)" id="insert" class="btn btn-default" 
	            			style="width: auto;float: left; margin-left:30px;">발주서등록</button>
	            <button data-author="update" type="button" onclick="pop_fn_BauljuInfo_Update(this)" id="update" class="btn btn-outline-success" 
	            			style="width: auto;float: left; margin-left:3px;">발주서수정</button>
	            <button data-author="delete" type="button" onclick="pop_fn_BauljuInfo_Delete(this)" id="delete" class="btn btn-danger" 
	            			style="width: auto; float: left; margin-left:3px;">발주서삭제</button>
	            <button data-author="insert" type="button" onclick="pop_fn_JumunDoc_Insert(this)" id="insert" class="btn btn-default" 
	            			style="width: auto; float: left; margin-left:3px;">문서등록</button>
            </div>
            <p style="width: auto; clear:both;">
            </p>

            <div class="panel panel-default">
                <!-- Default panel contents -->
                <div class="panel-body">
                    <div style="float: left">
                        <table style="width: 100%; text-align:left; background-color:#e0e0e0;">
                            <tr><td style='width:20%; vertical-align: middle;'>
                            		<div class="panel-heading" style="font-size:16px; font-weight: bold"  id="InfoContentTitle"></div>
                            	</td>
                            	<td style='width:5%; vertical-align: middle'>수행일자 :</td>
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
		                <li onclick='fn_DetailInfo_List()'><a id="DetailInfo_List"  href='#SubInfo_List_contents'>발주정보</a></li>
		                <li onclick='com_fn_SubInfo_DOC_List(this,vOrderNo)'><a id="SubInfo_DOC_List"  href='#SubInfo_List_Doc'>문서목록</a></li>
		            </ul>
                    <div id="SubInfo_List_contents"	></div>
                    <div id="SubInfo_Balju_seo" ></div>
                    <div id="SubInfo_List_Doc" ></div>
                </div>
        	
        	</div>
		</div>
    </div>