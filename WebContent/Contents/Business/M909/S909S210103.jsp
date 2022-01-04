<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*,java.util.*,javax.servlet.http.*"%>
<%@ page import="mes.client.comm.*" %>
<%@ page import="mes.client.common.*" %>
<%@ page import="mes.client.guiComponents.*" %>
<%@ page import="mes.client.util.*" %>
<%@ page import="mes.client.conf.*" %>
<%@ page import="org.json.simple.*"%><%@ include file="/strings.jsp" %>
<%
/* 
S909AS210101.jsp
선반 정보 삭제
*/
	String loginID = session.getAttribute("login_id").toString();
	String member_key = session.getAttribute("member_key").toString();
	
	String shelf_type = "";
	
	if(request.getParameter("shelf_type") != null)
		shelf_type = request.getParameter("shelf_type");
%>

<script type="text/javascript">
	
	$(document).ready(function () {
		var obj = new Object();
		
		var pid = "M909S210100E124";
		var prmtr = {
				shelf_type : '<%=shelf_type%>'
		}
		
		prmtr = JSON.stringify(prmtr);
		
		$.ajax({
			type: "POST",
		    dataType: "json",
		 	url: "<%=Config.this_SERVER_path%>/Contents/CommonView/select_json.jsp",
		 	data:  {"prmtr":prmtr, "pid":pid},
		    success: function (data) {
	    		var inputList = new Array();
	    		
	    		$("#myForm :input").each(function(){
	    			inputList.push($(this));
	    		});
	    		
				data[0].forEach(function(val, idx, arr) {
					inputList[idx].val(val);
				});
		    },
		    error: function() {
	     		heneSwal.errorTimer("목록 조회 실패", "다시 시도해 주세요");
	     		$('#modalReport').modal('hide');
			}
		});
	});

	function deleteInfo() {
		var obj = new Object();
		obj = getFormDataJson('#myForm');
		obj = JSON.stringify(obj);
		
	    $.ajax({
	        type: "POST",
	        dataType: "json",
	        url: "<%=Config.this_SERVER_path%>/Contents/CommonView/insert_update_delete_json.jsp", 
	        data:  {"bomdata" : obj, "pid" : "M909S210100E103"},
			success: function (html) {
				if(html > -1) {
					$('#modalReport').modal('hide');
	        		parent.fn_MainInfo_List();
					heneSwal.success('선반 정보 삭제 완료되었습니다');
	         	} else {
					heneSwal.error('선반 정보 삭제 실패했습니다, 다시 시도해주세요');	         		
	         	}
	         }
	     });
	}
</script>

<form id="myForm">
<table class="table">
	<tr>
		<td>
			선반 타입
		</td>
	    <td>
			<input type="text" class="form-control" name="shelf_type" readonly>
		</td>
	</tr>
   	<tr>
   		<td>
			선반 줄? 개수
   		</td>
   		<td>
   			<input type="number" class="form-control" name="shelf_row" readonly>
   		</td>
   	</tr>
 	<tr>
 		<td>
			선반 줄별 쟁반 개수
  		</td>
  		<td>
  			<input type="number" class="form-control" name="shelf_column" readonly>
  		</td>
  	</tr>
</table>
</form>