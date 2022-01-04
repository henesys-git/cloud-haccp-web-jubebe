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
S909S020110.jsp
점검표 양식 조회 및 등록/변경
*/
	String loginID = session.getAttribute("login_id").toString();
	String member_key = session.getAttribute("member_key").toString();
	
	String checklist_id = "", 
		   checklist_rev_no = "", 
		   format_rev_no = "";

		if(request.getParameter("checklist_id") != null)
			checklist_id = request.getParameter("checklist_id");
		
		if (request.getParameter("checklist_rev_no") != null)
			checklist_rev_no = request.getParameter("checklist_rev_no");
		
		if (request.getParameter("format_rev_no") != null)
			format_rev_no = request.getParameter("format_rev_no");
%>

<script>
	
	$(document).ready(function () {
		
		let pid = '';
		
		/* 최초 등록 시 -> E111 (only insert)
		 * 변경 시 -> E121 (update old, insert new)
		*/
		let setPid = function () {
			let checklist_id = $('#checklist_id').val();
			if(checklist_id == '') {
				pid = "M909S020100E111";
			} else {
				pid = "M909S020100E112";
			}
		}
		
		let adjustFormat = function () {
			let obj = new Object();
			obj = getFormDataJson('#checklistMngTable');
			obj = JSON.stringify(obj);
			
		    $.ajax({
		        type: "POST",
		        dataType: "json",
		        url: "<%=Config.this_SERVER_path%>/Contents/CommonView/insert_update_delete_json.jsp", 
		        data:  {"bomdata" : obj, "pid" : pid},
				success: function (rtnVal) {
					if(rtnVal > -1) {
						$('#modalReport').modal('hide');
		        		parent.fn_MainInfo_List();
						heneSwal.success('저장 되었습니다');
		         	} else {
						heneSwal.error('저장 실패했습니다, 다시 시도해주세요');
		         	}
		         }
			});
		}
		
		let fillChecklistInfoWhenFormatNotExist = function () {
			let obj = new Object();
			obj.checklist_id = "<%=checklist_id%>";
			obj.checklist_rev_no = "<%=checklist_rev_no%>";
			
			$.ajax({
		        type: "POST",
		        dataType: "json",
		        url: "<%=Config.this_SERVER_path%>/Contents/CommonView/select_json.jsp",
		        data: {"prmtr" : JSON.stringify(obj), "pid" : "M909S020100E124"},
		        success: function (rcvData) {
		        	let len = rcvData.length;
		        	
		        	if(len > 0) {
		        		$('#checklist_id').val(rcvData[0][0]);
		        		$('#checklist_rev_no').val(rcvData[0][1]);
		        		$('#checklist_name').val(rcvData[0][2]);
		        		
		        		let heneDate = new HeneDate();
		        		let today = heneDate.getTodayNoHyphen();
		        		let img = rcvData[0][0] + "_" + today + ".jpg";
		        		
		        		let imgLoc = "images/checklist/" + img;
		        		let jspLoc = "/Contents/Checklist/" + img;
		        		$('#img_location').val(imgLoc);
		        		$('#jsp_location').val(jspLoc);
		        	} else {
						heneSwal.error('서버 연결 오류, 관리자에게 문의해 주세요');
		        	}
		        },
		        error: function(rcvData) {
					heneSwal.error('서버 연결 오류, 관리자에게 문의해 주세요');
		        }
		    });
		}
		
		let retrieveInitData = function () {
			let obj = new Object();
			obj.checklist_id = "<%=checklist_id%>";
			obj.checklist_rev_no = "<%=checklist_rev_no%>";
			obj.format_rev_no = "<%=format_rev_no%>";
			
			$.ajax({
		        type: "POST",
		        dataType: "json",
		        url: "<%=Config.this_SERVER_path%>/Contents/CommonView/select_json.jsp",
		        data: {"prmtr" : JSON.stringify(obj), "pid" : "M909S020100E114"},
		        success: function (rcvData) {
		        	let len = rcvData.length;
		        	
		        	if(len > 0) {
		        		setValueInputTag("#checklistMngTable", rcvData[0]);
		        		setPid();
		        		$('#btnSave').attr('disabled', true);
		        	} else if(len == 0) {
						heneSwal.warning('등록된 양식이 없습니다\n양식을 등록해 주세요');
						setPid();
		        		$('#btnUpdate').attr('disabled', true);
		        		fillChecklistInfoWhenFormatNotExist();
		        	} else {
						heneSwal.error('조회 실패, 관리자에게 문의해 주세요');
		        	}
		        },
		        error: function(rcvData) {
					heneSwal.error('조회 실패, 관리자에게 문의해 주세요');
		        }
		    });
		}
		
		retrieveInitData();
		
		$('#btnSave').click(function() {
			adjustFormat();
		});
		
		$('#btnUpdate').click(function() {
			adjustFormat();
		});
	});

</script>

<form id="checklistMngTable">
	<table class="table">
		<tr>
			<td>
				점검표 아이디
			</td>
		    <td>
				<input type="text" class="form-control" name="checklist_id" id="checklist_id" readonly>
				<input type="hidden" class="form-control" name="checklist_rev_no" id="checklist_rev_no">
				<input type="hidden" class="form-control" name="format_rev_no" id="format_rev_no">
			</td>
		</tr>
	   	<tr>
	   		<td>
				점검표명
	   		</td>
	   		<td>
	   			<input type="text" class="form-control" name="checklist_name" id="checklist_name" readonly>
	   		</td>
	   	</tr>
	 	<tr>
	 		<td>
				이미지 저장 위치
	  		</td>
	  		<td>
	  			<input type="text" class="form-control" name="img_location" id="img_location">
	  		</td>
	  	</tr>
	  	<tr>
	 		<td>
				JSP 파일 위치
	  		</td>
	  		<td>
	  			<input type="text" class="form-control" name="jsp_location" id="jsp_location">
	  		</td>
	  	</tr>
	</table>
</form>