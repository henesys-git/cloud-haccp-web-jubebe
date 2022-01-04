<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*,java.util.*,javax.servlet.http.*"%>
<%@ page import="mes.client.comm.*" %>
<%@ page import="mes.client.common.*" %>
<%@ page import="mes.client.guiComponents.*" %>
<%@ page import="mes.client.util.*" %>
<%@ page import="mes.client.conf.*" %>
<%@ page import="org.json.simple.*"%><%@ include file="/strings.jsp" %>
<!DOCTYPE html>
<!-- <html xmlns="http://www.w3.org/1999/xhtml"> -->
<!-- <head id="Head1" > -->
<%
	String  GV_JSPPAGE="", GV_NUM_GUBUN="", GV_ORDERNO="", GV_ORDER_DETAIL_SEQ="",
			GV_LOTNO="", GV_PROD_CD="", GV_PROD_CD_REV="";

	if(request.getParameter("jspPage")== null)
		GV_JSPPAGE="";
	else
		GV_JSPPAGE = request.getParameter("jspPage");
	
	if(request.getParameter("num_gubun")== null)
		GV_NUM_GUBUN="";
	else
		GV_NUM_GUBUN = request.getParameter("num_gubun");

	if(request.getParameter("OrderNo")== null)
		GV_ORDERNO="";
	else
		GV_ORDERNO = request.getParameter("OrderNo");	
	
	if(request.getParameter("OrderDetailSeq")== null)
		GV_ORDER_DETAIL_SEQ="";
	else
		GV_ORDER_DETAIL_SEQ = request.getParameter("OrderDetailSeq");
	
	if(request.getParameter("LotNo")== null)
		GV_LOTNO="";
	else
		GV_LOTNO = request.getParameter("LotNo");
	
	if(request.getParameter("prod_cd")== null)
		GV_PROD_CD="";
	else
		GV_PROD_CD = request.getParameter("prod_cd");
	
	if(request.getParameter("prod_cd_rev")== null)
		GV_PROD_CD_REV="";
	else
		GV_PROD_CD_REV = request.getParameter("prod_cd_rev");
	
	String loginID = session.getAttribute("login_id").toString();
	String member_key = session.getAttribute("member_key").toString();
		
%>
<%-- <jsp:include page="../../Common/linkcss_js.jsp" flush="false"/> --%>
    
    <script type="text/javascript">
//     웹소켓 통신을 위해서 필요한 변수들 ---시작
	var M303S040100E122 = {
			PID:  "M303S040100E122", 
			totalcnt: 0,
			retnValue: 999,
			colcnt: 0,
			colname: ["","","",""], //insert, Update, Delete 문장을 처리할 때는 사용되지않음
			data: []
	};  
	
	var SQL_Param = {
			PID:  "M303S040100E122", 
			excute: "queryProcess",
			stream: "N",
			param: ""
	};
	
//  웹소켓 통신을 위해서 필요한 변수들 ---끝	

    var vSeolbiCd;
    
    $(document).ready(function () {
    	//탭 클릭시 처리하는 Function
		$( function() {$( "#tabs_p" ).tabs();});
        
		Pop_Order_List.click();
	});
    
	
    function fn_Order_List() {
    	$.ajax(
            {
                type: "POST",
                url: "<%=Config.this_SERVER_path%>/Contents/Business/M303/S303S040130.jsp",
                data: "OrderNo=" + "<%=GV_ORDERNO%>" + "&LotNo=" + "<%=GV_LOTNO%>"
                	+ "&prod_cd=" + "<%=GV_PROD_CD%>" + "&prod_cd_rev=" + "<%=GV_PROD_CD_REV%>",
                beforeSend: function () {
     	            //$("#Pop_Order_List_contents").children().remove();
                },
                success: function (html) {
                    $("#Pop_Order_List_contents").hide().html(html).fadeIn(100);
                },
        	    error: function (xhr, option, error) {
        	    }
        	});
    	return;
    }
    
    function fn_Process_List() {
    	$.ajax(
			{
				type: "POST",
                url: "<%=Config.this_SERVER_path%>/Contents/Business/M303/S303S020110.jsp",
                data: "OrderNo=" + "<%=GV_ORDERNO%>" + "&LotNo=" + "<%=GV_LOTNO%>"
                	+ "&prod_cd=" + "<%=GV_PROD_CD%>" + "&prod_cd_rev=" + "<%=GV_PROD_CD_REV%>",
                beforeSend: function () {
         	        //$("#Pop_Process_List_contents").children().remove();
                },
                success: function (html) {
                    $("#Pop_Process_List_contents").hide().html(html).fadeIn(100);
                },
            	error: function (xhr, option, error) {
            	}
			});
		return;
    }
    
    function fn_BOM_List(obj) {
    	var url = "<%=Config.this_SERVER_path%>/Contents/CommonView/OrderBomList.jsp"
			+ "?OrderNo=" + "<%=GV_ORDERNO%>"
			+ "&lotno=" + "<%=GV_LOTNO%>" 
			;

   		pop_fn_popUpScr_nd(url, obj.innerText, '90%', '80%');
       	return;
    }
    
    function fn_Jaego_List() {
    	$.ajax(
			{
				type: "POST",
                url: "<%=Config.this_SERVER_path%>/Contents/Business/M303/S303S040140.jsp",
                data: "OrderNo=" + "<%=GV_ORDERNO%>" + "&LotNo=" + "<%=GV_LOTNO%>" ,
                beforeSend: function () {
         	        //$("#Pop_Jaego_List_contents").children().remove();
                },
                success: function (html) {
                    $("#Pop_Jaego_List_contents").hide().html(html).fadeIn(100);
                },
            	error: function (xhr, option, error) {
            	}
			});
		return;
    }
    
//     function fn_Seolbi_List() {
// 		$.ajax(
// 			{
// 				type: "POST",
<%-- 				url: "<%=Config.this_SERVER_path%>/Contents/Business/M505/S505S020100.jsp", --%>
// 				data: "SeolbiCd=" + vSeolbiCd    ,
// 				beforeSend: function () {
//          	        //$("#Pop_Seolbi_List_contents").children().remove();
//                 },
//                 success: function (html) {
//                     $("#Pop_Seolbi_List_contents").hide().html(html).fadeIn(100);
//                 },
//             	error: function (xhr, option, error) {
//             	}
//             });
//         return;
//     }
	
    function SaveOderInfo() {        
		var chekrtn = confirm("완료하시겠습니까?"); 
		
		var parmHead= '<%=Config.HEADTOKEN %>' ;
		if(chekrtn){
				parmHead += '<%=GV_JSPPAGE%>'			+ "|"
	    				  + '<%=loginID%>'				+ "|"	
	    				  + '<%=GV_ORDERNO%>'			+ "|"
<%-- 	    				  + '<%=GV_ORDER_DETAIL_SEQ%>'	+ "|"	//주문상세번호 --%>
	    				  + '0'							+ "|"	//주문상세번호
	    				  + '0' 						+ "|" 	//indGB
	    				  + '<%=GV_LOTNO%>'		//lotno	    				 		
	    				  ;
				parmHead +=  "|"  + '<%=member_key%>' + "|"  + '<%=Config.DATATOKEN %>';
	
			SQL_Param.param = parmHead ;

			SendTojsp(urlencode(SQL_Param.param), SQL_Param.PID);
		}
	}
 
	function SendTojsp(bomdata, pid){
	    $.ajax({
	         type: "POST",
	         url: "<%=Config.this_SERVER_path%>/Contents/CommonView/insert_update_delete.jsp", 
	         data:  "bomdata=" + bomdata + "&pid=" + pid,
	         beforeSend: function () {
	         	 //alert(bomdata);
	         },	         
	         success: function (html) {
	        	 if(html>-1){
	        		 parent.fn_MainInfo_List();
	        		 $("#SubInfo_List_contents").html("");
	                parent.$("#ReportNote").children().remove();
	         		parent.$('#modalReport').hide();
	         	}
	         },
	         error: function (xhr, option, error) {
	         }
	     });		
	}
	
    </script>
    <div class="panel panel-default">
    	<div id="tabs_p" >
			<ul>
				<li onclick='fn_Order_List()'><a id="Pop_Order_List"  href='#Pop_Order_List_contents'>주문정보</a></li>
				<li onclick='fn_Process_List()'><a id="Pop_Process_List"  href='#Pop_Process_List_contents'>생산계획</a></li>
				<li onclick='fn_BOM_List(this)'><a id="Pop_Bom_List"  href='#Pop_Bom_List_contents'>배합(BOM)목록</a></li>
				<li onclick='fn_Jaego_List()'><a id="Pop_Jaego_List"  href='#Pop_Jaego_List_contents'>재고현황</a></li>
<!-- 				<li onclick='fn_Seolbi_List()'><a id="Pop_Seolbi_List"  href='#Pop_Seolbi_List_contents'>설비목록</a></li> -->
			</ul>
			<div id="Pop_Order_List_contents" ></div>
			<div id="Pop_Process_List_contents" ></div>
			<div id="Pop_Bom_List_contents" ></div>
			<div id="Pop_Jaego_List_contents" ></div>
<!-- 			<div id="Pop_Seolbi_List_contents" ></div> -->
		</div>
	</div>
	<div style="width:100%; clear:both;">
        <p style="text-align:center;">
        	<button id="btn_Save"  class="btn btn-info"  onclick="SaveOderInfo();">등록완료</button>
            <button id="btn_Canc1"  class="btn btn-info"  onclick="parent.$('#modalReport').hide();">취소</button>
        </p>
	</div>
	
