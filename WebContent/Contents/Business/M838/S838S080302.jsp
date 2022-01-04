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
S838S080302.jsp
교육/훈련 기록부 수정
*/
	String loginID = session.getAttribute("login_id").toString();
	String member_key = session.getAttribute("member_key").toString();
	
	String checklist_id = "", checklist_rev_no = "" , seq_no ="", edu_date = "";
			
	if(request.getParameter("checklist_id") != null)
		checklist_id = request.getParameter("checklist_id");	

	if(request.getParameter("checklist_rev_no") != null)
		checklist_rev_no = request.getParameter("checklist_rev_no");
	
	if(request.getParameter("edu_date") != null)
		edu_date = request.getParameter("edu_date");
	
	if(request.getParameter("seq_no") != null)
		seq_no = request.getParameter("seq_no");
	
	JSONObject jArray = new JSONObject();
	
 	jArray.put("edu_date", edu_date);
 	jArray.put("seq_no", seq_no);
	
	DoyosaeTableModel TableModel = new DoyosaeTableModel("M838S080300E144", jArray);
	MakeGridData makeGridData = new MakeGridData(TableModel);
%>
<style>
#edu_table .input-group {
	width: 30%;
	display: inline-flex;
}

#edu_table input[type="time"] {
	width : 36%;
	display: inline-block;
	margin-left: 2%;
}

#edu_table input[type="radio"] {
	margin-right : 3%;
}

#edu_table label {
	width : 19%;
	font-weight: normal;
}

#fileDelete {
    left: 96%;
}
</style>
<script type="text/javascript">
    $(document).ready(function () {
    	
		new SetSingleDate2("<%=edu_date%>", "#edu_date", 0);
		
		var dataArr = <%= makeGridData.getDataArray() %>;
		dataArr = dataArr[0];
		var cnt = 0;
		$("#edu_table input").each(function(idx) {
		
			if(idx <= 1 || (idx >= 10 && idx <= 13)){
				return true;
			} else if(idx == 9 && cnt == 7){
				
				$("input:radio[value='"+dataArr[(6 + cnt)]+"']").attr("checked",true);
				cnt++;
				return true;
			}
			if(cnt == 8){
				cnt++; 
			} else if(cnt == 10){
				$("textarea").val(dataArr[(6 + cnt)]);
				cnt++; 
			}
			
			$(this).val(dataArr[(6 + cnt)]);
			cnt++;
			
		});
		
		var fileFrmShow = '<%=TableModel.getValueAt(0, 24)%>';
		
		if(fileFrmShow == "" || fileFrmShow == null){
			$("#update_form").show();
			$("#attached_document").hide();
			$("#fileDelete").hide();
		} else {
			$("#attached_document").show();
			$("#fileDelete").show();
			$("#update_form").hide();
		}
		
		// 파일 삭제
		$("#fileDelete").click(function() {
			
			var chekrtn = confirm("파일을 삭제하시겠습니까?");
			
			if(chekrtn) {
			
				 var dataJson = new Object();
				 dataJson.seq_no = '<%=seq_no%>';
				 var JSONparam = JSON.stringify(dataJson);
				
				 $.ajax({
				        type: "POST",
				        dataType: "json",
				        url: "<%=Config.this_SERVER_path%>/Contents/CommonView/insert_update_delete_json.jsp", 
				        data:  {"bomdata" : JSONparam, "pid" : "M838S080300E113"},
						success: function (html) {	
							if(html > -1) {
								alert("파일이 삭제되었습니다.");
								$("#attached_document").hide();
								$("#fileDelete").hide();
								$("#update_form").show();
							} else {
								alert("파일 삭제에 실패했습니다.");
				         	}
				         }
			     }); // ajax
			} // if
			
		}); //click
		
    });	
	
	function SaveOderInfo() {
    	
		var flag = true;
		
		$("input[name^='edu_']").each(function() {
			
			if($(this).val() == "" || $(this).val() == null){
				
				heneSwal.warning('빈칸을 입력해주세요.');
				$(this).focus();
				flag = false;
				return false;
			}
			
		})
		
		if(flag){
			
			var dataJson = new Object();
 			
			dataJson.checklist_id = '<%=checklist_id%>';
			dataJson.checklist_rev_no = '<%=checklist_rev_no%>';
			dataJson.seq_no = '<%=seq_no%>';
			dataJson.org_edu_date = $('#org_edu_date').val();
			dataJson.form = $("#edu_frm").serializeArray();
			dataJson.person_write_id = '<%=loginID%>';
        	
			var JSONparam = JSON.stringify(dataJson);
			var chekrtn = confirm("수정하시겠습니까?"); 
			
			if(chekrtn) {
				SendTojsp(JSONparam, "M838S080300E102");
			}
		}
		
	}

	function SendTojsp(bomdata, pid) {
	    $.ajax({
	        type: "POST",
	        dataType: "json",
	        url: "<%=Config.this_SERVER_path%>/Contents/CommonView/insert_update_delete_json.jsp", 
	        data:  {"bomdata" : bomdata, "pid" : pid},
			success: function (html) {	
				if(html > -1) {
					
					if($("#idFilename").val() == "" || $("#idFilename").val() == null){
						
						heneSwal.success('기록부 수정이 완료되었습니다');
						
    					$('#modalReport').modal('hide');
    	        		parent.fn_MainInfo_List(startDate, endDate);
    	        		parent.$('#SubInfo_List_contents').hide();
						
					} else {
						
						var form = $('#update_form')[0];
		                var data = new FormData(form);
		                
		                data.append("pid", 			$('#txt_pid').val());
		                data.append("user_id", 		$('#txt_user_id').val());
		                data.append("orderno", 		$('#txt_orderno').val());
		                data.append("order_detail", $('#txt_order_detail').val());
		                data.append("jspPage", 		$('#txt_jspPage').val());
		                data.append("getnum_prefix", "HACCP");
		                data.append("regist_no", $('#txt_regist_no').val());
		                data.append("JobType", $('#txt_JobType').val());
		                
		                data.append("docname", 		$('#txt_docname').val());
		                data.append("doccode", 		$('#txt_doccode').val());
		                data.append("rev_no", 		parseInt($('#txt_rev_no').val()) + 1);
		                data.append("doc_gubun", 	$('#txt_doc_gubun').val());
		                
		                data.append("member_key", '107-86-81841'); 		// 관리본여부
		                data.append("seq_no", '<%=seq_no%>'); 		
	
		           	    $.ajax({
		        			type: "POST",
		        			async: true,
		           	        enctype: "multipart/form-data",
		           	        acceptcharset: "UTF-8",
		           	        url: "<%= request.getContextPath() %>/hcp_EdmsServerServlet", 
		           	        data: data,
		           	        processData: false,
		           	        contentType: false,
		        			cache: false,
		           	        timeout: 600000,
		           	        success: function (data) {
		        				if(data.length > 0) {
	
		        					heneSwal.success('기록부 수정이 완료되었습니다');
	
		        					$('#modalReport').modal('hide');
		        	        		parent.fn_MainInfo_List(startDate, endDate);
		        	        		parent.$('#SubInfo_List_contents').hide();
		        				} else {
		        					heneSwal.errorTimer("기록부 수정 실패했습니다, 다시 시도해주세요");
		        				}
		        			},
		           	        error: function (e) {
		        				$("#result").text(e.responseText);
		           	        }
		           	    });
		                
					}
	    
	         	} else {
					heneSwal.error('기록일지 수정 실패했습니다, 다시 시도해주세요');	         		
	         	}
	         }
	     });
	}
</script>
<form id = "edu_frm" onsubmit = "return false;">
	<table class="table" id="edu_table" style = "margin-bottom: 0; ">
		<tr>
			<td width = "13%">
				교육일자
			</td>
		    <td width = "23%">
				<input type="text" data-date-format="yyyy-mm-dd" id="edu_date" name = "edu_date" class="form-control">
				<input type="hidden" data-date-format="yyyy-mm-dd" id="org_edu_date" class="form-control" value = '<%= edu_date %>'>
			</td>
			<td width = "12%">
				교육시간
			</td>
		    <td>
		    	시작
				<input type="time" id="edu_start_time" name = "edu_start_time" class="form-control" style = "margin-right : 4%;">
				종료
				<input type="time" id="edu_end_time" name = "edu_end_time" class="form-control">
			</td>
		</tr>
		<tr>
			<td>
				강사/주관
	  		</td>
	  		<td>
	  			<input type="text" class="form-control" id="edu_lecturer" name="edu_lecturer"/>
	  		</td>
	  		<td>
				교육장소
	  		</td>
	  		<td>
	  			<input type="text" class="form-control" id="edu_place" name="edu_place"/>
	  		</td>
		</tr>
	   	<tr>
	  		<td>
				교육대상
	  		</td>
	  		<td>
	  			<input type="text" class="form-control" id="edu_target" name="edu_target"/>
	  		</td>
	  		<td>
				참석인원
	  		</td>
	  		<td>
	  			참석자 &nbsp;
	  			<div class="input-group" style = "margin-right : 9%">
		  			<input type="number" class="form-control" id="edu_person_count"  name="edu_person_count" min = "0" value = "0">
		  			<div class="input-group-append">
					     <span class="input-group-text">명</span>
			        </div>
		        </div>
	  			불참자&nbsp;
	  			<div class="input-group">
		  			<input type="number" class="form-control" id="non_edu_person_count" name="non_edu_person_count" min = "0" value = "0">
		  			<div class="input-group-append">
					     <span class="input-group-text">명</span>
			        </div>
		        </div>
	  		</td>
	  	</tr>  		
	 	<tr>
			<td>
				교육종류
			</td>
		    <td colspan = 3>
				<label><input type="radio" name="edu_type"  value = "1"> 위생교육</label>
				<label><input type="radio" name="edu_type"  value = "2"> HACCP교육</label>
				<label><input type="radio" name="edu_type"  value = "3"> 직무교육</label>
				<label><input type="radio" name="edu_type"  value = "4"> 보관운반교육</label>
				<label><input type="radio" name="edu_type"  value = "5"> 기타</label>
			</td>
		</tr>
		<tr>
			<td>
				교육주제
			</td>
		    <td colspan = 3>
				<input type="text" id="edu_topic" name="edu_topic" class="form-control">
			</td>
		</tr>
		<tr>
			<td>
				교육내용
			</td>
		    <td colspan = 3>
				<textarea id="edu_detail" name="edu_detail" style = "width : 100%; height: 100px;"></textarea>
			</td>
		</tr>
		<tr>
			<td>
				불참자 <br>조치사항
			</td>
		    <td colspan = 3>
				<input type="text" id="absentee_action" name="absentee_action" class="form-control">
			</td>
		</tr>	
	</table>
</form>
<table class="table" id = "fileUpload">
	<tr>
		<td style = "width : 13%">
			첨부자료
		</td>
	    <td colspan = 2>
			<input type="hidden" class="form-control" id="txt_pid" name="pid"  value="M838S080300E112"> 
			<input type="hidden" class="form-control" id="txt_user_id" name="user_id"  value="henesys"> 
			<input type="hidden" class="form-control" id="txt_orderno" name="orderno" value="0" > 
			<input type="hidden" class="form-control" id="txt_order_detail" name="order_detail" value="1" > 
			<input type="hidden" class="form-control" id="txt_jspPage" name="jspPage"  value="M838S080302.jsp"> 
			<input type="hidden" class="form-control" id="txt_getnum_prefix" name="getnum_prefix"  value="수정시 prefix 필요 없음"> 
			<input type="hidden" class="form-control" id="txt_JobType" name="JobType" value="UPDATE" > 
			<input type="hidden" class="form-control" id="txt_docname" name="docname" value="<%= TableModel.getValueAt(0, 23) %>">
			<input type="hidden" class="form-control" id="txt_regist_no" name="regist_no" value="<%= TableModel.getValueAt(0, 22) %>">
			<input type="hidden" class="form-control" id="txt_doccode" name="doccode" value = "M838S080300" > 
			<input type="hidden" class="form-control" id="txt_rev_no" name="rev_no" value = "<%= TableModel.getValueAt(0, 25) %>" > 
			<input type="hidden" class="form-control" id="txt_doc_gubun" name="doc_gubun"  value="<%= TableModel.getValueAt(0, 23) %>" > 
	    <!-- ///////////////////////////////////////////////////////////////////////////////////  -->	
			<form id="update_form" enctype="multipart/form-data" action="<%= request.getContextPath() %>/hcp_EdmsServerServlet" method="post">
				<input type="file" id="idFilename" name="filenames" multiple="multiple" class="form-control" style = "height: 0%;">
			</form>		
			<input type="text" id="attached_document" name = "attached_document" value = "<%= TableModel.getValueAt(0, 23) %>" class="form-control" disabled><i id = "fileDelete" class="fas fa-times"></i>
		</td>
	</tr>
</table>