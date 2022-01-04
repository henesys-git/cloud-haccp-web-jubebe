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
	String  GV_JSPPAGE="", GV_NUM_GUBUN="", GV_ORDERNO="", GV_ORDER_DETAIL_SEQ="",GV_PROD_CD="",GV_PROD_REV="",GV_PROD_NM="",GV_LOTNO="";

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
	
	if(request.getParameter("OrderDetail")== null)
		GV_ORDER_DETAIL_SEQ="";
	else
		GV_ORDER_DETAIL_SEQ = request.getParameter("OrderDetail");	
	
	if(request.getParameter("prod_cd")== null)
		GV_PROD_CD="";
	else
		GV_PROD_CD = request.getParameter("prod_cd");
	
	if(request.getParameter("prod_rev")== null)
		GV_PROD_REV="";
	else
		GV_PROD_REV = request.getParameter("prod_rev");
	
	if(request.getParameter("prod_nm")== null)
		GV_PROD_NM="";
	else
		GV_PROD_NM = request.getParameter("prod_nm");
	
	if(request.getParameter("LotNo")== null)
		GV_LOTNO="";
	else
		GV_LOTNO = request.getParameter("LotNo");
	
	String loginID = session.getAttribute("login_id").toString();
	String member_key = session.getAttribute("member_key").toString();	
%>
<%-- <jsp:include page="../../Common/linkcss_js.jsp" flush="false"/> --%>
    
    <script type="text/javascript">
    
    $(document).ready(function () {
    	$("#Table_Checklist input").on("click",function(){
    		S303S040101Event(this);
      	});
    	
    	//탭 클릭시 처리하는 Function
		$( function() {$( "#tabs_p" ).tabs();});
        
		Pop_Order_List.click();
	});
    
    function fn_Order_List() {
    	$.ajax(
            {
                type: "POST",
                url: "<%=Config.this_SERVER_path%>/Contents/Business/M101/S101S020121.jsp",
                data: "OrderNo=" + "<%=GV_ORDERNO%>" + "&OrderDetail=" + "<%=GV_ORDER_DETAIL_SEQ%>"	+ "&jspPage=" + "<%=GV_JSPPAGE%>" + "&num_gubun=<%=GV_NUM_GUBUN%>" + "&LotNo=<%=GV_LOTNO%>" ,
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
                url: "<%=Config.this_SERVER_path%>/Contents/Business/M101/S101S020141.jsp",
                data: "prod_cd=" + "<%=GV_PROD_CD%>" + "&prod_cd_rev=" + "<%=GV_PROD_REV%>" + "&prod_nm=" + "<%=GV_PROD_NM%>"
                		+ "&OrderNo=" + "<%=GV_ORDERNO%>" + "&Lotno=" + "<%=GV_LOTNO%>" 
                		+ "&jspPage=" + "<%=GV_JSPPAGE%>" + "&num_gubun=<%=GV_NUM_GUBUN%>"  ,
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

    </script>
    
    
    <div class="panel panel-default">
    	<div id="tabs_p" style="float:left; width:100%">
			<ul>
				<li onclick='fn_Order_List()'><a id="Pop_Order_List"  href='#Pop_Order_List_contents'>주문문서등록</a></li>
				<li onclick='fn_Process_List()'><a id="Pop_Process_List"  href='#Pop_Process_List_contents'>주문별제품기본문서등록</a></li>
			</ul>
			<div id="Pop_Order_List_contents" ></div>
			<div id="Pop_Process_List_contents" ></div>
		
		</div>
	</div>

	
