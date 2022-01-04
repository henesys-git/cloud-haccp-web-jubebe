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
S909S020101.jsp
점검표 등록
*/
	String loginID = session.getAttribute("login_id").toString();
	String member_key = session.getAttribute("member_key").toString();
%>

<script>
	
	$(document).ready(function () {
		
		let insertChecklist = function () {
			var obj = new Object();
			obj = getFormDataJson('#myForm');
			obj = JSON.stringify(obj);
			
		var chekrtn = confirm("등록하시겠습니까?");	
			
			if(chekrtn) {
				
				$.ajax({
			        type: "POST",
			        dataType: "json",
			        url: "<%=Config.this_SERVER_path%>/Contents/CommonView/insert_update_delete_json.jsp", 
			        data:  {"bomdata" : obj, "pid" : "M909S020100E101"},
					success: function (rtnVal) {
						if(rtnVal > -1) {
							$('#modalReport').modal('hide');
			        		parent.fn_MainInfo_List();
							heneSwal.success('점검표 정보 등록이 완료되었습니다');
			         	} else {
							heneSwal.error('점검표 정보 등록에 실패했습니다, \n다른 점검표 아이디로 다시 시도해주세요');	         		
			         	}
			         }
				});
				
			} 
			else {
			      return false;
			}	
		    
		}
		
		$('#btnInsert').click(function() {
			insertChecklist();
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
				<input type="text" class="form-control" name="checklist_id" placeholder="ex) checklistXX">
			</td>
		</tr>
	   	<tr>
	   		<td>
				점검표명
	   		</td>
	   		<td>
	   			<input type="text" class="form-control" name="checklist_name" placeholder="점검표명을 입력해주세요">
	   		</td>
	   	</tr>
	 	<tr>
	 		<td>
				점검 주기
	  		</td>
	  		<td>
	  			<div class="input-group">
		  			<input type="number" class="form-control" name="check_term" placeholder="ex) 180 (일 단위)">
			      	<div class="input-group-append">
			        	<span class="input-group-text">일</span>
			      	</div>
			    </div>
	  		</td>
	  	</tr>
	</table>
</form>