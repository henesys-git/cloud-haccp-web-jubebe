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
S838080402.jsp
건강검진 관리대장 수정
*/
	String loginID = session.getAttribute("login_id").toString();
	String member_key = session.getAttribute("member_key").toString();

 	String checklist_id = "", checklist_rev_no = "", checkup_date = "",
 		   seq_no = "", regist_seq_no = "", next_checkup_date = "";
 
 	String checkup_nm = "", user_id = "", revision_no = "";
 
	if(request.getParameter("checklist_id") != null)
		checklist_id = request.getParameter("checklist_id");	

	if(request.getParameter("checklist_rev_no") != null)
		checklist_rev_no = request.getParameter("checklist_rev_no");
	
	if(request.getParameter("checkup_date") != null)
		checkup_date = request.getParameter("checkup_date");
	
	if(request.getParameter("seq_no") != null)
		seq_no = request.getParameter("seq_no");
	
	if(request.getParameter("regist_seq_no") != null)
		regist_seq_no = request.getParameter("regist_seq_no");
	
	if(request.getParameter("checkup_nm") != null)
		checkup_nm = request.getParameter("checkup_nm");
	
	if(request.getParameter("user_id") != null)
		user_id = request.getParameter("user_id");
	
	if(request.getParameter("revision_no") != null)
		revision_no = request.getParameter("revision_no");
	
	if(request.getParameter("next_checkup_date") != null)
		next_checkup_date = request.getParameter("next_checkup_date");
	
	String regist_no = "", file_name = "", file_path = "", file_rev_no = "";
	
	if(request.getParameter("regist_no") != null)
		regist_no = request.getParameter("regist_no");
	
	if(request.getParameter("file_name") != null)
		file_name = request.getParameter("file_name");
	
	if(request.getParameter("file_path") != null)
		file_path = request.getParameter("file_path");
	
	if(request.getParameter("file_rev_no") != null)
		file_rev_no = request.getParameter("file_rev_no");
%>
    
<script type="text/javascript">
    $(document).ready(function () {
    	
		new SetSingleDate2("", "#checkup_date", 0);
		new SetSingleDate2("", "#next_checkup_date", 0);
		
		$('#checkup_date').val('<%=checkup_date%>');
		$('#checkup_date2').val('<%=checkup_date%>');
		
		$("#checkup_nm").val('<%=checkup_nm%>');
		$("#checkup_id").val('<%=user_id%>');
		$("#next_checkup_date").val('<%=next_checkup_date%>');
<%-- 	
		// 검진자는 수정 x	
		$("#checkup_nm").click(function() {
			
			var url = "<%=Config.this_SERVER_path%>/Contents/Business/M838/S838S080301_edu_person_list.jsp"
					+ "?date="+$('#checkup_date').val()
					+ "&edu_person_list="+$('#checkup_id').val()
					+ "&val=2";
						
			var footer = '<button id="btn_Add" class="btn btn-info" onclick="addCheckup();">확인</button>';
			var title = "건강검진 관리 명단"
			var heneModal2 = new HenesysModal2(url, 'small', title, footer);
			heneModal2.open_modal();
		});
 --%>		
		
		var fileFrmShow = '<%=file_path%>';
		
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
				        data:  {"bomdata" : JSONparam, "pid" : "M838S080400E113"},
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
    	
			if($('#checkup_nm').val() == null || $('#checkup_nm').val() == ""){
				heneSwal.errorTimer('검진자를 입력해주세요');	
				return false;
			}
		
	        var dataJson = new Object();
	        				
			dataJson.checklist_id = '<%=checklist_id%>';
			dataJson.checklist_rev_no = '<%=checklist_rev_no%>';
			dataJson.regist_seq_no = '<%=regist_seq_no%>';
			dataJson.seq_no = '<%=seq_no%>';
			dataJson.checkup_date = $('#checkup_date').val();
			dataJson.checkup_date2 = $('#checkup_date2').val();
			dataJson.checkup_id = $('#checkup_id').val();
			dataJson.next_checkup_date = $('#next_checkup_date').val();
			dataJson.person_write_id = '<%= loginID %>';
			
			var JSONparam = JSON.stringify(dataJson);
			var chekrtn = confirm("수정하시겠습니까?"); 
			
			if(chekrtn) {
				SendTojsp(JSONparam, "M838S080400E102");
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
						
						heneSwal.success('건강검진 관리대장 수정이 완료되었습니다');
						
    					$('#modalReport').modal('hide');
    	        		parent.fn_MainInfo_List(startDate, endDate);
						
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
	
		        					heneSwal.success('건강검진 관리대장 수정이 완료되었습니다');
	
		        					$('#modalReport').modal('hide');
		        	        		parent.fn_MainInfo_List(startDate, endDate);
		        				} else {
		        					heneSwal.errorTimer("건강검진 관리대장 수정 실패했습니다, 다시 시도해주세요");
		        				}
		        			},
		           	        error: function (e) {
		        				$("#result").text(e.responseText);
		           	        }
		           	    });
		                
					}
	         	} else {
					heneSwal.error('건강검진 관리대장 수정 실패했습니다, 다시 시도해주세요');	         		
	         	}
	         }
	     });
	}
</script>

<table class="table" id="bom_table">
	<tr>
		<td style = "width:34%;">
			건강검진 기준일자
		</td>
	    <td>
			<input type="text" data-date-format="yyyy-mm-dd" id="checkup_date" class="form-control">
			<input type="hidden" id="checkup_date2" class="form-control">
		</td>
	</tr>
	<tr>
		<td>
			검진자 성명
		</td>
	    <td>
			<input type="text" id="checkup_nm" class="form-control" placeholder = "Click Here" disabled>
			<input type="hidden" id="checkup_id" class="form-control">
		</td>
	</tr>
	<tr>
		<td>
			차기 검진일자
		</td>
	    <td>
			<input type="text" data-date-format="yyyy-mm-dd" id="next_checkup_date" class="form-control">
		</td>
	</tr>
	<tr>
		<td>
			첨부파일
		</td>
	    <td>
			<input type="hidden" class="form-control" id="txt_pid" name="pid"  value="M838S080400E112"> 
			<input type="hidden" class="form-control" id="txt_user_id" name="user_id"  value="henesys"> 
			<input type="hidden" class="form-control" id="txt_orderno" name="orderno" value="0" > 
			<input type="hidden" class="form-control" id="txt_order_detail" name="order_detail" value="1" > 
			<input type="hidden" class="form-control" id="txt_jspPage" name="jspPage"  value="M838S080402.jsp"> 
			<input type="hidden" class="form-control" id="txt_getnum_prefix" name="getnum_prefix"  value="수정시 prefix 필요 없음"> 
			<input type="hidden" class="form-control" id="txt_JobType" name="JobType" value="UPDATE" > 
			<input type="hidden" class="form-control" id="txt_docname" name="docname" value="<%= file_name %>">
			<input type="hidden" class="form-control" id="txt_regist_no" name="regist_no" value="<%= regist_no %>">
			<input type="hidden" class="form-control" id="txt_doccode" name="doccode" value = "M838S080400" > 
			<input type="hidden" class="form-control" id="txt_rev_no" name="rev_no" value = "<%= file_rev_no %>" > 
			<input type="hidden" class="form-control" id="txt_doc_gubun" name="doc_gubun"  value="<%= file_name %>" > 
	    <!-- ///////////////////////////////////////////////////////////////////////////////////  -->	
			<form id="update_form" enctype="multipart/form-data" action="<%= request.getContextPath() %>/hcp_EdmsServerServlet" method="post">
				<input type="file" id="idFilename" name="filenames" multiple="multiple" class="form-control" style = "height: 0%;">
			</form>		
			<input type="text" id="attached_document" name = "attached_document" value = "<%= file_name %>" class="form-control" disabled>
			<i id = "fileDelete" class="fas fa-times" style = "left : 91%;"></i>
		</td>
	</tr>
</table>