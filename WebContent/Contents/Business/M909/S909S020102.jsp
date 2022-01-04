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
S909S020102.jsp
점검표 수정
*/
	String loginID = session.getAttribute("login_id").toString();
	String member_key = session.getAttribute("member_key").toString();
	
	String GV_CHECKLIST_ID = "", GV_CHECKLIST_REV_NO = "", 
			GV_CHECKLIST_NAME = "", GV_CHECK_TERM = "";
	
	if(request.getParameter("checklist_id") != null)
		GV_CHECKLIST_ID = request.getParameter("checklist_id");
	
	if(request.getParameter("checklist_rev_no") != null)
		GV_CHECKLIST_REV_NO = request.getParameter("checklist_rev_no");
	
	if(request.getParameter("checklist_name") != null)
		GV_CHECKLIST_NAME = request.getParameter("checklist_name");
	
	if(request.getParameter("check_term") != null)
		GV_CHECK_TERM = request.getParameter("check_term");
%>

<script>
	
	$(document).ready(function () {
		
		console.log('<%=GV_CHECKLIST_ID%>');
		
		$("#checklist_id").val('<%=GV_CHECKLIST_ID%>');
		$("#checklist_name").val('<%=GV_CHECKLIST_NAME%>');
		$("#check_term").val('<%=GV_CHECK_TERM%>');
		
		let updateChecklist = function() {
			var obj = new Object();
			obj = getFormDataJson('#myForm');
			obj.checklist_rev_no = '<%=GV_CHECKLIST_REV_NO%>';
			obj = JSON.stringify(obj);
			
			var chekrtn = confirm("수정하시겠습니까?");
			
			if(chekrtn) {
				$.ajax({
			        type: "POST",
			        dataType: "json",
			        url: "<%=Config.this_SERVER_path%>/Contents/CommonView/insert_update_delete_json.jsp", 
			        data:  {"bomdata" : obj, "pid" : "M909S020100E102"},
					success: function (rtnVal) {
						if(rtnVal > -1) {
							$('#modalReport').modal('hide');
			        		parent.fn_MainInfo_List();
							heneSwal.success('점검표 정보 수정이 완료되었습니다');
			         	} else {
							heneSwal.error('점검표 정보 수정에 실패했습니다, \n다른 점검표 아이디로 다시 시도해주세요');	         		
			         	}
			         }
				});
			} 
				else {
			       return false;
				}
			
		    
		}
		
		$('#btnUpdate').click(function() {
			updateChecklist();
		})
		
	});

</script>

<form id="myForm">
	<table class="table">
		<tr>
			<td>
				점검표 아이디
			</td>
		    <td>
				<input type="text" class="form-control" name="checklist_id" id="checklist_id" readonly>
			</td>
		</tr>
	   	<tr>
	   		<td>
				점검표명
	   		</td>
	   		<td>
	   			<input type="text" class="form-control" name="checklist_name" id="checklist_name">
	   		</td>
	   	</tr>
	 	<tr>
	 		<td>
				점검 주기
	  		</td>
	  		<td>
	  			<div class="input-group">
		  			<input type="number" class="form-control" name="check_term" id="check_term">
			      	<div class="input-group-append">
			        	<span class="input-group-text">일</span>
			      	</div>
			    </div>
	  		</td>
	  	</tr>
	</table>
</form>