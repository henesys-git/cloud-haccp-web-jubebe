<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*,java.util.*,javax.servlet.http.*"%>
<%@ page import="mes.client.comm.*" %>
<%@ page import="mes.client.common.*" %>
<%@ page import="mes.client.guiComponents.*" %>
<%@ page import="mes.client.util.*" %>
<%@ page import="mes.client.conf.*" %>
<%@ page import="org.json.simple.*"%><%@ include file="/strings.jsp" %>
<%
	String loginID = session.getAttribute("login_id").toString();
	String member_key = session.getAttribute("member_key").toString();
	
	String censor_no = "", censor_rev_no = "";
	
	if(request.getParameter("censor_no") != null) {
		censor_no = request.getParameter("censor_no");
	}

	if(request.getParameter("censor_rev_no") != null) {
		censor_rev_no = request.getParameter("censor_rev_no");
	}
%>

<script type="text/javascript">
	$(document).ready(function () {
		var obj = new Object();
		
		var pid = "M909S170100E114";
		var prmtr = {
				censor_no : '<%=censor_no%>',
				censor_rev_no : <%=censor_rev_no%>
		}
		
		prmtr = JSON.stringify(prmtr);
		
		$.ajax({
			type: "POST",
		    dataType: "json",
		 	url: "<%=Config.this_SERVER_path%>/Contents/CommonView/select_json.jsp",
		 	data:  {"prmtr":prmtr, "pid":pid},
		    success: function (data) {
		    		var inputList = new Array();
		    		$("form :input").each(function(){
		    		    console.log(this);
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
	
	function SaveOderInfo() {
		var obj = getFormDataJson("#formId");

		var JSONparam = JSON.stringify(obj);
		
		var chekrtn = confirm("수정하시겠습니까?");
		
		if(chekrtn){
			SendTojsp(JSONparam, "M909S170100E102");
		}
	}

	function SendTojsp(bomdata, pid) {
		$.ajax({
			type: "POST",
		    dataType: "json",
		 	url: "<%=Config.this_SERVER_path%>/Contents/CommonView/insert_update_delete_json.jsp",
		 	data:  {"bomdata" : bomdata, "pid" : pid },
		    success: function (html) {	 
		    	if(html > -1) {
		    	   	parent.fn_MainInfo_List();
		            $('#modalReport').modal('hide');
		            heneSwal.successTimer("수정 완료되었습니다");
		     	} else {
		     		heneSwal.error("다시 시도해주세요");
		     	}
			}
		});
	}
</script>

<form id="formId">
<table class="table table-hover" style="width:100%">
	<tr>
		<td>센서No</td>
		<td>
			<input type="text" class="form-control" name="censor_no" id="censor_no">
			<input type="hidden" class="form-control" name="censor_rev_no" id="censor_rev_no">
		</td>
	</tr>

	<tr>
		<td>센서이름</td>
		<td>
			<input type="text" class="form-control" name="censor_name" id="censor_name">
		</td>
	</tr>

	<tr>
		<td>센서 데이터 유형</td>
		<td>
			<input type="text" class="form-control" name="censor_type" id="censor_type">
		</td>
	</tr>


	<tr>
		<td>센서위치</td>
		<td>
			<input type="text" class="form-control" name="censor_location" id="censor_location">
		</td>
	</tr>
	
	<tr>
		<td>최소값</td>
		<td>
			<input type="number" class="form-control" name="min_value" id="min_value" placeholder="숫자만 입력 가능합니다">
		</td>
	</tr>
	
	<tr>
		<td>최대값</td>
		<td>
			<input type="number" class="form-control" name="max_value" id="max_value" placeholder="숫자만 입력 가능합니다">
		</td>
	</tr>
	
	<tr>
		<td>표준값</td>
		<td>
			<input type="number" class="form-control" name="standard_value" id="standard_value" placeholder="숫자만 입력 가능합니다">
		</td>
	</tr>
	
	<tr>
		<td>데이터 수집주기</td>
		<td>
			<div class="input-group">
		      <input type="number" class="form-control" placeholder="분 단위로 입력해주세요" id="collecting_period" name="collecting_period">
		      <div class="input-group-append">
		        <span class="input-group-text">분</span>
		      </div>
		    </div>
		</td>
	</tr>
	
	<tr>
		<td>적용시작날짜</td>
		<td>
			<input type="date" class="form-control" id="start_date" name="start_date">
		</td>
	</tr>
</table>
</form>