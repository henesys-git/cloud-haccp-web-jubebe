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
S838S080401.jsp
건강검진 관리대장 등록
*/
	String loginID = session.getAttribute("login_id").toString();
	String member_key = session.getAttribute("member_key").toString();
	
	String checklist_id = "", checklist_rev_no = "";
	
	if(request.getParameter("checklist_id") != null)
		checklist_id = request.getParameter("checklist_id");	

	if(request.getParameter("checklist_rev_no") != null)
		checklist_rev_no = request.getParameter("checklist_rev_no");
%>  
<script type="text/javascript">
    $(document).ready(function () {
    	
		new SetSingleDate2("", "#checkup_date", 0);
		new SetSingleDate2("", "#next_checkup_date", 365);
 		
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
		 
    });
    	
	function SaveOderInfo() {
		
		if($('#checkup_nm').val() == null || $('#checkup_nm').val() == ""){
			
			heneSwal.errorTimer('검진자를 입력해주세요.');	
			
			return false;
		}
			
        var dataJson = new Object();
        							
		dataJson.checklistId = '<%=checklist_id%>';
		dataJson.checklistRevNo = '<%=checklist_rev_no%>';
		dataJson.checkup_date = $('#checkup_date').val();
		dataJson.checkup_id = $('#checkup_id').val();
		dataJson.next_checkup_date = $('#next_checkup_date').val();
		dataJson.person_write_id = '<%= loginID %>';
       	
		var JSONparam = JSON.stringify(dataJson);
		var chekrtn = confirm("등록하시겠습니까?"); 
		
		if(chekrtn) {
			SendTojsp(JSONparam, "M838S080400E101");
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
						
	        			heneSwal.success('건강진단 관리대장 등록이 완료되었습니다');

						$('#modalReport').modal('hide');
		        		parent.fn_MainInfo_List(startDate, endDate);
		        		parent.$('#SubInfo_List_contents').hide();
						
					} else {
						
		            	var form = $('#upload_form')[0];
		            	
						var data = new FormData(form);
		                
		                data.append("pid", 			$('#txt_pid').val());
		                data.append("user_id", 		$('#txt_user_id').val());
		                data.append("orderno", 		$('#txt_orderno').val());
		                data.append("order_detail", $('#txt_order_detail').val());
		                data.append("jspPage", 		$('#txt_jspPage').val());
		                data.append("getnum_prefix",$('#txt_getnum_prefix').val());
		                data.append("JobType", 		$('#txt_JobType').val());

		                data.append("regist_no", 	"");
		                data.append("docname", 		$('#txt_docname').val());
		                data.append("doccode", 		$('#txt_doccode').val());
		                data.append("rev_no", 		$('#txt_rev_no').val());
		                data.append("doc_gubun", 	$('#txt_doc_gubun').val());
		                
		                data.append("member_key", '107-86-81841'); 		// 관리본여부

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

		        					heneSwal.success('건강진단 관리대장 등록이 완료되었습니다');

		        					$('#modalReport').modal('hide');
		        	        		parent.fn_MainInfo_List(startDate, endDate);
		        	        		parent.$('#SubInfo_List_contents').hide();
		        				} else {
		        					heneSwal.errorTimer("건강진단 관리대장 등록 실패했습니다, 다시 시도해주세요");
		        				}
		        			},
		           	        error: function (e) {
		        				$("#result").text(e.responseText);
		           	        }
		           	    });
		                
					}
	         	} else {
					heneSwal.error('건강진단 관리대장 등록 실패했습니다, 다시 시도해주세요');	         		
	         	}
	         }
	     });
	}
</script>

<table class="table" id="bom_table">
	<tr>
		<td>
			건강검진일자
		</td>
	    <td>
			<input type="text" data-date-format="yyyy-mm-dd" id="checkup_date" class="form-control">
		</td>
	</tr>
	<tr>
		<td>
			검진자 성명
		</td>
	    <td>
			<input type="text" id="checkup_nm" class="form-control" placeholder = "Click Here">
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
			<input type="hidden" class="form-control" id="txt_pid" name="pid"  value="M838S080400E111">
			<input type="hidden" class="form-control" id="txt_user_id" name="user_id"  value="henesys"> 
			<input type="hidden" class="form-control" id="txt_orderno" name="orderno" value="0" > 
			<input type="hidden" class="form-control" id="txt_order_detail" name="order_detail" value="1" > 
			<input type="hidden" class="form-control" id="txt_jspPage" name="jspPage"  value="M838S080401.jsp"> 
			<input type="hidden" class="form-control" id="txt_getnum_prefix" name="getnum_prefix"  value="HACCP"> 
			<input type="hidden" class="form-control" id="txt_JobType" name="JobType" value="INSERT" > 
			<input type="hidden" class="form-control" id="txt_doccode" name="doccode" value = "M838S080400" > 
			<input type="hidden" class="form-control" id="txt_rev_no" name="rev_no" > 
			<input type="hidden" class="form-control" id="txt_doc_gubun" name="doc_gubun" > 
	   		<!-- ///////////////////////////////////////////////////////////////////////////////////  -->
			<input type="hidden" id="attached_document" class="form-control">
			<form id="upload_form" enctype="multipart/form-data" action="<%= request.getContextPath() %>/hcp_EdmsServerServlet" method="post">
				<input type="file" id="idFilename" name="filenames" multiple="multiple" class="form-control" style = "height: 0%;">
			</form>
		</td>
	</tr>
</table>