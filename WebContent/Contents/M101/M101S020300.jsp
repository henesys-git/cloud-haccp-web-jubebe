<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*,java.util.*,javax.servlet.http.*"%>
<%@ page import="mes.client.comm.*" %>
<%@ page import="mes.client.guiComponents.*" %>
<%@ page import="mes.client.util.*" %>
<%@ page import="mes.client.conf.*" %>
<%    	
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
	String GV_GET_NUM_PREFIX = prcStatusCheck.GV_PROCESS_NUMBER_GUBUN;
%>

 <script type="text/javascript">
 	  
 	
 	var vProd_serial_no="";
 	var vOrder_cnt =""; 
 	var vCustCode = ""; 
 	var vCustName = ""; 
 	
    var GV_PROCESS_MODIFY="";
    var GV_PROCESS_DELETE="";
    

    $(document).ready(function () {
    	new SetDate("dateFrom", -180);
    	new SetDate("dateTo", 0);
        
        GV_PROCESS_MODIFY 	="<%=GV_PROCESS_MODIFY%>";
        GV_PROCESS_DELETE 	="<%=GV_PROCESS_DELETE%>";
        
        <%--         makeMenu("<%=htmlsideMenu%>"); --%>
                fn_MainSubMenuSelect("<%=sMenuTitle%>");
		$("#InfoContentTitle").html("주문목록(PO List)");
        
		fn_MainInfo_List(); 
	    //탭 클릭시 처리하는 Function
	    //$( function() {$( "#tabs" ).tabs();});
	      
	    fn_tagProcess('<%=JSPpage%>');
<%--     	makeMainQueue("<%=MainQueue.GetQueueList()%>"); --%>
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

    	
// 		if(vSelect == "0" && $("li").data("author") == "select") onclick
//         	$(this).attr("display", "none");
// 		if(vInsert == "1" && $("li").data("author") == "insert")
//         	$(this).parent().attr("display", "none");
// 		if(vUpdate == "0" && $("li").data("author") == "update")
//         	$(this).attr("display", "none");
// 		if(vDelete == "0" && $("li").data("author") == "delete")
//         	$(this).attr("display", "none");        	
    }
    function fn_btn_Search() {

		fn_MainInfo_List(); 
        fn_DetailInfo_List(0);
        
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
    function fn_MainInfo_List() {
//         var custcode = $("#txt_cust_code").val().toString(); 
        var custcode = "";
        var from = $("#dateFrom").val();
        var to = $("#dateTo").val();
        $.ajax(
        {
            type: "POST",
            url: "<%=Config.this_SERVER_path%>/Contents/Business/M101/S101S020100.jsp",
            data: "custcode=" + custcode + "&From=" + from + "&To=" + to + "&JSPpage=" + "<%=JSPpage%>",
            beforeSend: function () {
                $("#MainInfo_List_contents").children().remove();
            },
            success: function (html) {
                $("#MainInfo_List_contents").hide().html(html).fadeIn(100);
            },
            error: function (xhr, option, error) {

            }
        });
        
        $("#SubInfo_List_Doc").children().remove();
        $("#SubInfo_List_contents").children().remove();
    }

    //주문상세정보 
    function fn_DetailInfo_List() {    	
//         var custcode = $("#txt_cust_code").val().toString();
		var custcode = "";

        $.ajax(
        {
            type: "POST",
            url: "<%=Config.this_SERVER_path%>/Contents/Business/M101/S101S020110.jsp",
            data: "custcode=" + custcode + "&OrderNo=" + vOrderNo + "&OrderDetailNo=" + vOrderDetailSeq + "&LotNo=" + vLotNo ,
            beforeSend: function () {
//                 //$("#SubInfo_List_contents").children().remove();
            },
            success: function (html) {
                $("#SubInfo_List_contents").hide().html(html).fadeIn(100);
            },
            error: function (xhr, option, error) {

            }
        });
    }
    	
    //검토정보 (PopUp)
    function pop_Review_Confirm_Insert(obj) {
    	if(vOrderNo.length < 1) {
    		heneSwal.warning('PO List 하나를 선택하세요')
			return;
    	}
    	var mainKey = "order_no = '" + vOrderNo + "'";
    	var actionKey = "";  //inpect_no = '" + vOrderNo + "'"; 있으면 mainKey와 같은 방식으로 정의

    	fn_Process_Review_n_Confirm(obj, '<%=JSPpage%>',vOrderNo, vOrderDetailSeq, '<%=GV_PROCESS_NAME%>', mainKey, actionKey,'<%=GV_GET_NUM_PREFIX%>',"<%=prcStatusCheck.GV_PROCESS_GUBUN%>");
		return false;
     }
    
	
	function selectQueueEvent(obj){
    	var tr = $(obj);
		var td = tr.children();
		var trNum = $(obj).closest('tr').prevAll().length;//현재 클릭한 TR의 순서 return	
		$(QueueOrder).attr("class", "bg-warning");	
// 		$(QueueTD2).attr("class", "bg-warning");	
// 		$(QueueTD3).attr("class", "bg-warning");
// 		$(obj).attr("class", "hene-bg-color");
		$(obj).attr("class", "bg-danger");
// 		$(obj).attr("class", "bg-success"); 
		
        vOrderNo = td.eq(0).text().trim(); 
//         td.eq(0).attr("class", "bg-danger");
//         td.eq(1).attr("class", "bg-danger");
//         td.eq(2).attr("class", "bg-danger");
//         alert(vOrderNo);
	}
    </script>

    <div class="panel panel-default" style="margin-left:0px; margin-top:5px; margin-right:0px; margin-bottom:0px; width:100%">
        <!-- Default panel contents -->
        <div class="panel-heading" style="font-weight: bold" id="MenuTitle">여기에메뉴타이틀</div>
        <div class="panel-body"  style="margin-left:0px; margin-top:0px; margin-right:0px; margin-bottom:0px;">
<!--         	<div  class="panel panel-default" id="QueueDiv" style="float:left; width:11%; height:760px; margin-top: 0px;"></div> -->
<!-- 	        <p style="width: 0.2%; float:left;"> -->
<!--         	<div style="float:left; width:88.8%;"> -->
        	<div style="float:left; width:100%;">
	        	<div >
		            <button data-author="mainBtn" type="button"  id="mainButton"  class="btn btn-primary active"
		            			style="width: auto; float: left; ">주문납품관리-주문정보</button>
		            <button data-author="insert" type="button" onclick='pop_Review_Confirm_Insert(this)' id="insert" class="btn btn-default" 
		            style="width: auto; clear:both;  margin-left:30px;">주문등록검토</button>
	            </div>
	            <p style="width: auto; clear:both;">
	            </p>
	            <div class="panel panel-default">
	                <!-- Default panel contents -->
	                <div class="panel-body">
	                    <div style="float: left">
                        <table style="width: 100%; text-align:left; background-color:#e0e0e0;">
                            <tr><td style='width:20%; vertical-align: middle;'>
                            		<div class="panel-heading" style="font-size:16px; font-weight: bold" id="InfoContentTitle"></div>
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
	                    <!-- Table --> 					
	                	<div style="clear:both; height:10px ;border-top: 1px solid #D2D6Df;" >
                    	</div>
	                    <div style="clear:both" id="MainInfo_List_contents" >
	                    </div>
	                </div>
	                
	                <div id="tabs">
			         	<ul >
			                <li onclick='fn_DetailInfo_List()'><a id="DetailInfo_List" href=#SubInfo_List_contents>주문상세정보</a></li>
			                <li onclick='com_fn_SubInfo_DOC_List(this,vOrderNo)'><a id="SubInfo_DOC_List"  href='#SubInfo_List_Doc'>주문문서목록</a></li>
			            </ul>
	                    <div id="SubInfo_List_Doc"></div>
	                    <div id="SubInfo_List_contents"></div>
	                </div>

	            </div>
	        </div>
        </div>
    </div>
