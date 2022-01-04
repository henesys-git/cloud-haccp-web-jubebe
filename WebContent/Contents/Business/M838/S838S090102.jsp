<%@page import="com.mysql.cj.result.Row"%>
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
	
	String regist_seq_no="", prod_cd="", prod_date="";
	
	if(request.getParameter("regist_seq_no") != null)
		regist_seq_no = request.getParameter("regist_seq_no");	
	
	if(request.getParameter("prod_cd") != null)
		prod_cd = request.getParameter("prod_cd");
	
	if(request.getParameter("prod_date")!= null)
		prod_date = request.getParameter("prod_date");
	
	JSONObject jArray = new JSONObject();
	jArray.put( "regist_seq_no", regist_seq_no);
	jArray.put( "prod_cd", prod_cd);
	jArray.put( "prod_date", prod_date);
	
    DoyosaeTableModel TableModel = new DoyosaeTableModel("M838S090100E134", jArray);	// 출고/회수내역 data
    DoyosaeTableModel TableModel2 = new DoyosaeTableModel("M838S090100E154", jArray); 	// haccp_recall	
%>    
<script type="text/javascript">

	function SendTojsp() {        
		var dataJson = new Object();
		
		dataJson.regist_seq_no 		= "<%=regist_seq_no%>";
		dataJson.prod_date 			= $("#prod_date").val();
		dataJson.prod_cd 			= $("#prod_cd").val();
		dataJson.action_result 		= $("#action_result").val();
		dataJson.action_plan 		= $("#action_plan").val();
		dataJson.person_write_id	= "<%=loginID%>";
		
		var JSONparam = JSON.stringify(dataJson);
		
		var chekrtn = confirm("수정하시겠습니까?"); 
		
		if(chekrtn){
			
			$.ajax({
				type: "POST",
		        dataType: "json", // Ajax로 json타입으로 보낸다.
		     	url: "<%=Config.this_SERVER_path%>/Contents/CommonView/insert_update_delete_json.jsp",
		     	data:  {"bomdata" : JSONparam, "pid" : "M838S090100E102" },
		        success: function (html) {	 
		        	if(html > -1) {

       					heneSwal.success('회수결과기록 수정이 완료되었습니다');

       					$('#modalReport').modal('hide');
       					parent.fn_MainInfo_List(startDate, endDate);
       				} else {
       					heneSwal.errorTimer("회수결과기록 수정을 실패했습니다, 다시 시도해주세요");
       				}
		        }
			});	
		}
	}
</script>

<table class="table table-hover" style="width: 100%; margin: 0 auto; align:left">
     <tr>
        <td style = "width: 15%;">제품명</td>
        <td>
			<input type="text" class="form-control" id="prod_nm" value = "<%= TableModel.getValueAt(0, 6) %>" readonly/>
        </td>
         <td style = "width: 15%;">제조일자</td>
        <td>
        	<input type="text" class="form-control" id="prod_date" value = "<%= TableModel.getValueAt(0, 5) %>" readonly/>
         	<input type="hidden" id = "prod_cd" value = "<%= TableModel.getValueAt(0, 7) %>"/>
        </td>
     </tr>
     <tr>
        <td>생산량</td>
        <td>
    		<input type="text" class="form-control" id="output" value = "<%= TableModel.getValueAt(0, 9) %>" readonly/>
        </td>
        <td>출고량</td>
        <td>
			<input type="text" class="form-control" id="deliveryAmount" value = "<%= TableModel.getValueAt(0, 10) %>" readonly/>
        </td>
     </tr>
     <tr>
     	<table class = "table" id = "Unstoring">
     		<tr>
     			<th rowspan = 8 style = "vertical-align: middle;">출고내역</th>
		       	<th>거래처</th>
		       	<th>수량</th>
		       	<th>규격</th>
		       	<th>출고지</th>
		       	<th>배송자</th>
     		</tr>
     		<% for(int i = 0; i < TableModel.getRowCount(); i++){ 
     				String plusReturn = (String)TableModel.getValueAt(i, 15);
     				if("".equals(plusReturn)) { plusReturn = "0"; } %>
	   			<tr>
	     			<td><%= TableModel.getValueAt(i, 11) %></td>
	     			<td><%= Integer.parseInt((String)TableModel.getValueAt(i, 14)) + Integer.parseInt(plusReturn) %></td>
	     			<td><%= TableModel.getValueAt(i, 16) %></td>
	     			<td>원우푸드</td>
	     			<td><%= TableModel.getValueAt(i, 17) %></td>
	     		</tr>
     		<% } %>
     	</table>
     </tr>
     <tr>
     	<table class = "table" id = "return">
     		<tr>
     			<th rowspan = 8 style = "vertical-align: middle;">회수내역</th>
		       	<th>거래처</th>
		       	<th>수량</th>
		       	<th>규격</th>
		       	<th>회수지</th>
		       	<th>배송자</th>
     		</tr>
     		<% for(int j = 0; j < TableModel.getRowCount(); j++){ 
     			if( "".equals(TableModel.getValueAt(j, 15)) ) { continue; }%>
	   			<tr>
	     			<td><%= TableModel.getValueAt(j, 11) %></td>
	     			<td><%= Integer.parseInt((String)TableModel.getValueAt(j, 15)) %></td>
	     			<td><%= TableModel.getValueAt(j, 16) %></td>
	     			<td><%= TableModel.getValueAt(j, 11) %></td>
	     			<td><%= TableModel.getValueAt(j, 17) %></td>
	     		</tr>
     		<% } %>
     	</table>
     </tr>
 </table>
 <table class = "table">
 	 <tr>
        <td style = "width: 15%;">처리결과</td>
       	<td>
           <textarea class="form-control" id = "action_result"><%= TableModel2.getValueAt(0, 5)%></textarea>
        </td>
     </tr>
     <tr>
        <td>미회수품<br>처리계획</td>
        <td>
 	      	<textarea class="form-control" id = "action_plan"><%= TableModel2.getValueAt(0, 6)%></textarea>
       	</td>
     </tr>
 </table>