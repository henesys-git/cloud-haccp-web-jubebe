<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*,java.util.*,javax.servlet.http.*"%>
<%@ page import="mes.client.comm.*" %>
<%@ page import="mes.client.common.*" %>
<%@ page import="mes.client.guiComponents.*" %>
<%@ page import="mes.client.util.*" %>
<%@ page import="mes.client.conf.*" %>
<%
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
	ProcesStatusCheck prcStatusCheck = new ProcesStatusCheck(JSPpage+"|"+"ODPROCS"+"|");
	
	
	String GV_PROCESS_MODIFY	= prcStatusCheck.GV_PROCESS_MODIFY;
	String GV_PROCESS_DELETE	= prcStatusCheck.GV_PROCESS_DELETE;
	String GV_PROCESS_NAME		= prcStatusCheck.GV_PROCESS_NAME;
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
		var tr = $($("tableS202S010001 tr")[0]);
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


    
    //발주서
    function fn_MainInfo_List() {
        var from = $("#dateFrom").val();
        var to = $("#dateTo").val();
        var custcode = '';

        $.ajax(
        {
            type: "POST",
            url: "<%=Config.this_SERVER_path%>/Contents/Business/M303/S303S050300.jsp", 
            data: "custcode=" + custcode + "&From=" + from + "&To=" + to    + "&JSPpage=" + "<%=JSPpage%>",
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
    	$.ajax(
    	    {
    	        type: "POST",
    	        url: "<%=Config.this_SERVER_path%>/Contents/Business/M303/S303S050110.jsp",
    	        data: "OrderNo=" + vOrderNo    + "&order_detail_seq=" + vOrderDetailSeq 
    	        		+ "&lotno=" + vLotNo + "&JSPpage=" + "<%=JSPpage%>",
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

	function fn_work_complete_list() {     
    	$.ajax(
    	    {
    	        type: "POST",
    	        url: "<%=Config.this_SERVER_path%>/Contents/Business/M303/S303S050150.jsp",
    	        data: "OrderNo=" + vOrderNo + "&order_detail_seq=" + vOrderDetailSeq 
    	        		+ "&lotno=" + vLotNo + "&JSPpage=" + "<%=JSPpage%>",
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

    //검토정보 (PopUp)
    function pop_Review_Confirm_Insert(obj) {
    	if(vOrderNo.length < 1){
			$('#alertNote').html($(obj).html() + " <BR> <%=JSPpage%>!!! <BR><BR> PO List 하나를 선택하세요!!");
			$('#modalalert').show();
			return;
    	}
    	var mainKey = "order_no = '" + vOrderNo + "'";
    	var actionKey = "";  //inpect_no = '" + vOrderNo + "'"; 있으면 mainKey와 같은 방식으로 정의

    	fn_Process_Review_n_Confirm(obj, '<%=JSPpage%>',vOrderNo, vOrderDetailSeq, '<%=GV_PROCESS_NAME%>', mainKey, actionKey,'<%=GV_GET_NUM_PREFIX%>',"<%=prcStatusCheck.GV_PROCESS_GUBUN%>");
		return false;
     }
    
  //공정확인표결과
	function pop_fn_ProcessCheckListResult(obj) {         	
		if(vOrderNo.length < 1){
   			$('#alertNote').html($(obj).innerText + " <BR> " + "<%=JSPpage%>" + "!!! <BR><BR> 주문정보를 선택하세요  !!!");
   			$('#modalalert').show();
   			return false;
   		} 
   		var url = "<%=Config.this_SERVER_path%>/Contents/Business/M303/S303S050160.jsp"
   				+ "?OrderNo=" + vOrderNo + "&order_detail_seq=" + vOrderDetailSeq
        		+ "&proc_cd=" + vProcCd + "&proc_cd_rev=" + vProcCdRev;
   		
       	pop_fn_popUpScr(url, obj.innerText+"(S303S050160)", '80%', '90%');
   		return;
   		
   	}
  
	//제품검사요청내역
	function fn_ProductInspectRequest(obj) {         	
		$.ajax(
	    	    {
	    	        type: "POST",
	    	        url: "<%=Config.this_SERVER_path%>/Contents/Business/M303/S303S050180.jsp",
	    	        data: "OrderNo=" + vOrderNo + "&order_detail_seq=" + vOrderDetailSeq
	    	        	+ "&proc_cd=" + vProcCd + "&proc_cd_rev=" + vProcCdRev,
	    	        beforeSend: function () {
	     	            //$("#SubInfo_List_contents").children().remove();
	    	        },
	    	        success: function (html) {
	    	            $("#SubInfo_List_contents").hide().html(html).fadeIn(100);
	    	        },
	    	        error: function (xhr, option, error) {
	    	        }
	    	    });
			return;
   	}
	
	//제품검사결과
	function fn_ProductInspectResult(obj) {         	
		$.ajax(
	    	    {
	    	        type: "POST",
	    	        url: "<%=Config.this_SERVER_path%>/Contents/Business/M303/S303S050190.jsp",
	    	        data: "OrderNo=" + vOrderNo + "&order_detail_seq=" + vOrderDetailSeq
	    	        	+ "&proc_cd=" + vProcCd + "&proc_cd_rev=" + vProcCdRev,
	    	        beforeSend: function () {
	     	            //$("#SubInfo_List_contents").children().remove();
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
    <div class="panel panel-default" style="margin-left:5px; margin-top:5px; margin-right:5px; margin-bottom:5px; width:100%" >
        <!-- Default panel contents -->
        <div class="panel-heading" style="font-weight: bold" id="MenuTitle">여기에메뉴타이틀</div>
        <div class="panel-body" >
        
        	<div>
	            <button data-author="mainBtn" type="button"  id="mainButton"  class="btn btn-primary active"
	            			style="width: auto; float: left; ">발주재고관리-자재발주관리</button>
	            <button data-author="insert" type="button" onclick="pop_Review_Confirm_Insert(this)" id="insert" class="btn btn-default" 
	            			style="width: auto;float: left; margin-left:30px;">생산실적검토</button>
	            <label style="width: 100px; clear:both; margin-left:3px;"></label>
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
                    <div id="MainInfo_List_contents"  style="clear:both; " >
                    </div>
                </div>

                <div id="tabs">
		         	<ul >
	                	<li onclick='fn_DetailInfo_List()'><a id="DetailInfo_List"  href='#SubInfo_List_contents'>생산공정실적</a></li>
	                	<li onclick='fn_work_complete_list()'><a id="WorkComplete_List"  href='#SubInfo_List_contents'>공정완료목록</a></li>
	                	<li onclick='com_fn_SubInfo_DOC_List_Process(this,vOrderNo)'><a id="SubInfo_DOC_List"  href='#SubInfo_List_Doc'>생산문서목록</a></li>
		                <li onclick='pop_fn_BomList(this, "<%=JSPpage%>")'><a id="SubInfo_BomList"  href='#SubInfo_BOM'>BOM정보</a></li>
		                <li onclick='pop_fn_ProcessCheckList(this, "<%=JSPpage%>")'><a id="SubInfo_checklist"  href='#SubInfo_check'>공정확인표(LOT CARS)</a></li>
		                <li onclick='pop_fn_ProcessCheckListResult(this)'><a id="SubInfo_checklist_result"  href='#SubInfo_check'>공정확인표 결과</a></li>
		                <li onclick='fn_ProductInspectRequest(this)'><a id="SubInfo_inspect_request"  href='#SubInfo_List_contents'>제품검사요청내역</a></li>
		                <li onclick='fn_ProductInspectResult(this)'><a id="SubInfo_inspect_result"  href='#SubInfo_List_contents'>제품검사결과</a></li>
		            </ul>
                    <div id="SubInfo_List_contents" ></div>
                    <div id="SubInfo_List_Doc" ></div>
                    <div id="SubInfo_BOM" ></div>
                    <div id="SubInfo_check"></div>
                </div>
        	</div>
		</div>
    </div>