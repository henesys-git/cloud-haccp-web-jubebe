<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*,java.util.*,javax.servlet.http.*"%>
<%@ page import="mes.client.comm.*" %>
<%@ page import="mes.client.common.*" %>
<%@ page import="mes.client.guiComponents.*" %>
<%@ page import="mes.client.util.*" %>
<%@ page import="mes.client.conf.*" %>
<%@ page import="org.json.simple.*"%><%@ include file="/strings.jsp" %>
<!DOCTYPE html>

<%
	String loginID = session.getAttribute("login_id").toString();
	String member_key = session.getAttribute("member_key").toString();
	
	Vector optCode =  null;
	Vector optName =  null;
	Vector tIncongVector = CommonData.getDeptCode(member_key);	
	
	String  GV_JSPPAGE="", GV_NUM_GUBUN="",
			GV_ORDERNO="", GV_LOTNO="",
			GV_PROD_CD="", GV_PROD_CD_REV="", GV_PROD_NM="" ;
	
	if(request.getParameter("jspPage")== null)
		GV_JSPPAGE="";
	else
		GV_JSPPAGE = request.getParameter("jspPage");	

	if(request.getParameter("num_gubun")== null)
		GV_NUM_GUBUN="";
	else
		GV_NUM_GUBUN = request.getParameter("num_gubun");
	
	if(request.getParameter("OrderNo")== null)
		GV_ORDERNO = "";
	else
		GV_ORDERNO = request.getParameter("OrderNo");	
	
	if(request.getParameter("Lotno")== null)
		GV_LOTNO="";
	else
		GV_LOTNO = request.getParameter("Lotno");
	
	
	
	if(request.getParameter("prod_cd")== null)
		GV_PROD_CD="";
	else
		GV_PROD_CD = request.getParameter("prod_cd");
	
	if(request.getParameter("prod_cd_rev")== null)
		GV_PROD_CD_REV="";
	else
		GV_PROD_CD_REV = request.getParameter("prod_cd_rev");
	
	if(request.getParameter("prod_nm")== null)
		GV_PROD_NM="";
	else
		GV_PROD_NM = request.getParameter("prod_nm");
	
%>
    
    <script type="text/javascript">
	var M101S020100E141 = {
			PID:  "M101S020100E141", 
			totalcnt: 0,
			retnValue: 999,
			colcnt: 0,
			colname: ["","","",""], //insert, Update, Delete 문장을 처리할 때는 사용되지않음
			data: []
	};  
	var SQL_Param = {
			PID:  "M101S020100E141", 
			excute: "queryProcess",
			stream: "N",
			params: ""
	};  

	var vTableS101S020140;
    var S101S020140_Row_index = -1;
	var TableS101S020140_info;
    var TableS101S020140_RowCount = 0;

    $(document).ready(function () {
        $("#txt_prod_nm").val("<%=GV_PROD_NM%>");
        $("#txt_prod_cd").val("<%=GV_PROD_CD%>");
        $("#txt_prod_cd_rev").val("<%=GV_PROD_CD_REV%>");
        $("#txt_order_no").val("<%=GV_ORDERNO%>");
        $("#txt_lotno").val("<%=GV_LOTNO%>");
        
        call_S101S020140();
    });	

    function call_S101S020140(){
        $.ajax({
	        type: "POST",
            url: "<%=Config.this_SERVER_path%>/Contents/Business/M101/S101S020140.jsp", 
	        data: "prod_cd=" +  "<%=GV_PROD_CD%>"  + "&prod_cd_rev=" + "<%=GV_PROD_CD_REV%>", 
	        beforeSend: function () {
	            $("#inspect_result_body").children().remove();
	        },
	        success: function (html) {
	            $("#inspect_result_body").hide().html(html).fadeIn(100);
	        },
	        error: function (xhr, option, error) {
	        }
 		});
    }
	
    function fn_mius_body(obj){
		vTableS101S020140.row($(obj).parents('tr')).remove().draw();

	    TableS101S020140_info = vTableS101S020140.page.info();
	    TableS101S020140_RowCount = TableS101S020140_info.recordsTotal;
	    
	    call_S909S065120(); //삭제 후 왼쪽테이블 refresh
    }       
    
	function SaveOderInfoE141() {        
		TableS101S020140_info = vTableS101S020140.page.info();
        TableS101S020140_RowCount = TableS101S020140_info.recordsTotal;
		
		var parmHead= "" 
			+ "<%=Config.HEADTOKEN %>" 	;

		var parmBody= "" ;
	    for(var i=0; i<TableS101S020140_RowCount; i++){
	    	parmBody += vTableS101S020140.cell(i , 8).data()	+ "|" 	//reg_gubun 
	    			  + $("#txt_order_no").val()				+ "|" 	//order_no
	    			  + $("#txt_lotno").val()		+ "|" 	//order_detail_seq
	    			  + vTableS101S020140.cell(i , 10).data()	+ "|" 	//regist_no
					  + vTableS101S020140.cell(i , 11).data()	+ "|"	//regist_no_rev
	    			  + vTableS101S020140.cell(i , 5).data()	+ "|" 	//document_no
	    			  + vTableS101S020140.cell(i , 6).data()	+ "|" 	//document_no_rev
	    			  + vTableS101S020140.cell(i , 13).data() 	+ "|"	//file_real_name				
					  + vTableS101S020140.cell(i , 12).data()	+ "|"	//file_view_name
					  + '<%=member_key%>' 						+ "|"
					  + '<%=Config.DATATOKEN %>' 

					  ;
	    }
	    
		SQL_Param.params = parmHead + parmBody;
		
 		SendTojspE141(SQL_Param.params,SQL_Param.PID);
	}
    
	function SendTojspE141(bomdata, pid){
	    $.ajax({
	         type: "POST",
	         url: "<%=Config.this_SERVER_path%>/Contents/CommonView/insert_update_delete.jsp", 
	         data:  "bomdata=" + bomdata + "&pid=" + pid,
	         beforeSend: function () {
	         	 //alert(bomdata);
	         },
	         success: function (html) {	
	        	 if(html>-1){
	        		 parent.SubInfo_DOC_List.click();
	                parent.$("#ReportNote").children().remove();
	         		parent.$('#modalReport').hide();
	         	}
	         },
	         error: function (xhr, option, error) {
	         }
	     });		
	}       
    
    </script>

	<table class="table table-bordered" style="width: 100%; margin: 0 auto; align:center">
		<tr style="background-color: #fff; ">
			<td style="width: 13.33%%; font-weight: 900; font-size:14px; vertical-align: middle ;text-align:left">제품코드</td>
            <td style="width: 20%; font-weight: 900; font-size:14px; vertical-align: middle ;text-align:left">
            	<input type="text" class="form-control" id="txt_prod_cd" readonly></input>
				<input type="hidden" class="form-control" id="txt_prod_cd_rev" readonly></input>
            </td>
			<td style="width: 13.33%%; font-weight: 900; font-size:14px; vertical-align: middle ;text-align:left">제품명</td>
            <td style="width: 20%; font-weight: 900; font-size:14px; vertical-align: middle ;text-align:left">
            	<input type="text" class="form-control" id="txt_prod_nm" readonly></input>
            </td>
			<td style="width: 13.33%; font-weight: 900; font-size:14px; vertical-align: middle ;text-align:left">주문번호</td>
            <td style="width: 20%; font-weight: 900; font-size:14px; vertical-align: middle ;text-align:left">
            	<input type="text" class="form-control" id="txt_order_no" readonly></input>
            	<input type="hidden" class="form-control" id="txt_lotno" readonly></input>
			</td>
		</tr>
	</table>
	
	<div style="width:100%; text-align:center;clear:both" >
		<div id="inspect_result_body" style="width:100%; float:left"></div>
	</div>
	
	<div style="width:100%;clear:both">
        <p style="text-align:center;">
        	<button id="btn_Save"  class="btn btn-info"  onclick="SaveOderInfoE141();">저장</button>
            <button id="btn_Canc"  class="btn btn-info"  onclick="parent.$('#modalReport').hide();">취소</button>
        </p>
	</div>
	