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
S838S070101.jsp
부자재·부재료 입고검사기록 등록
*/
	String loginID = session.getAttribute("login_id").toString();
	
	String checklist_id = "", balju_no = "", part_cd = "";
	
	if(request.getParameter("checklist_id") != null)
		checklist_id = request.getParameter("checklist_id");	
	
	if(request.getParameter("balju_no") != null)
		balju_no = request.getParameter("balju_no");	
	
	if(request.getParameter("part_cd") != null)
		part_cd = request.getParameter("part_cd");
	
	JSONObject jArray = new JSONObject();
	jArray.put("balju_no", balju_no);
	jArray.put("part_cd", part_cd);
	
	DoyosaeTableModel TableModel = new DoyosaeTableModel("M838S070700E164", jArray);
	MakeGridData tData = new MakeGridData(TableModel);
%>
<style>
.modal-body {
	padding-bottom: 0;
}
#ipgo_check_table label {
    font-weight: normal;
    margin-left: 2%;
    width: 37%;
}

#ipgo_check_table label input{
    margin-right: 2%;
}
</style>    
<script type="text/javascript">
    $(document).ready(function () {
    	 console.log("<%= request.getContextPath() %>/hcp_EdmsServerServlet");
    	new SetSingleDate2("<%=TableModel.getValueAt(0, 19)%>", "#ipgo_date", 0);
    	
    	$("input:radio[value='O']").prop("checked", true);
		
    });
	
    function serializeObject(form) { 
    	var obj = null; 
   	
		var arr = form.serializeArray(); 
		
		if(arr){ 
			obj = {}; 
			jQuery.each(arr, function() { 
				obj[this.name] = this.value; 
			}); 
		}
		
    	return obj; 
    }
    
	function SendTojsp(bomdata, pid) {
		
		var dataJson = new Object();
        
		dataJson.checklist_id = '<%=checklist_id%>';
		dataJson.input_data = serializeObject($("#ipgo_check_frm"));
	 	dataJson.balju_no = '<%=balju_no%>';
		dataJson.person_write_id = '<%=loginID%>';
    	
		var JSONparam = JSON.stringify(dataJson);
		var chekrtn = confirm("등록하시겠습니까?"); 
		
		if(chekrtn) {
			
			 $.ajax({
				 
			        type: "POST",
			        dataType: "json",
			        url: "<%=Config.this_SERVER_path%>/Contents/CommonView/insert_update_delete_json.jsp", 
			        data:  {"bomdata" : JSONparam, "pid" : "M838S070100E101"},
					success: function (html) {	
						if(html > -1) {
							
							if($("#idFilename").val() == "" || $("#idFilename").val() == null){
								
			        			heneSwal.success('기록부 등록이 완료되었습니다');

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
								
				                console.log(data);
				               
				                
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

				        					heneSwal.success('기록부 등록이 완료되었습니다');

				        					$('#modalReport').modal('hide');
				        	        		parent.fn_MainInfo_List(startDate, endDate);
				        	        		parent.$('#SubInfo_List_contents').hide();
				        				} else {
				        					heneSwal.errorTimer("기록부 등록 실패했습니다, 다시 시도해주세요");
				        					return false;
				        				}
				        			},
				           	        error: function (e) {
				        				$("#result").text(e.responseText);
				           	        }
				           	    });
				                
							}
			         	} else {
							heneSwal.error('입고검사 대장 등록에 실패했습니다, 다시 시도해주세요');	         		
			         	}
			         }
			     });
			
		}
		
	}
	
</script>
<form id = "ipgo_check_frm" onsubmit="return false;">
	<table class="table" id="ipgo_check_table" style = "margin-bottom: 0;">
		<tr>
			<td style = "width: 35%;">
				입고일자
			</td>
		    <td colspan = 2>
				<input type="text" data-date-format="yyyy-mm-dd" id="ipgo_date" name="ipgo_date" class="form-control">
				<input type="hidden" name="ipgo_seq_no" class="form-control" value = "<%= TableModel.getValueAt(0, 22) %>">
				<input type="hidden" name="trace_key" class="form-control" value = "<%= TableModel.getValueAt(0, 2) %>">
				<input type="hidden" name="cust_cd" class="form-control" value = "<%= TableModel.getValueAt(0, 7) %>">
				<input type="hidden" name="cust_rev_no" class="form-control" value = "<%= TableModel.getValueAt(0, 8) %>">
				<input type="hidden" name="part_cd" class="form-control" value = "<%= TableModel.getValueAt(0, 10) %>">
				<input type="hidden" name="part_rev_no" class="form-control" value = "<%= TableModel.getValueAt(0, 11) %>">
			</td>
		</tr>
	 	<tr>
			<td>
				업체명
			</td>
		    <td colspan = 2>
				<input type="text" id="cust_nm" class="form-control" value = "<%= TableModel.getValueAt(0, 15) %>" readonly >
			</td>
		</tr>
		<tr>
			<td>
				제품명
			</td>
		    <td colspan = 2>
				<input type="text" id="part_nm" class="form-control" value = "<%= TableModel.getValueAt(0, 16) %>" readonly >
			</td>
		</tr>
		<tr>
			<td>
				입고량
			</td>
		    <td colspan = 2>
				<input type="text" id="ipgo_amount" class="form-control" value = "<%= TableModel.getValueAt(0, 21) %>" readonly >
			</td>
		</tr>
		<tr>
			<td>
				운송차량 청결상태
			</td>
		    <td colspan = 2>
				<label><input type="radio" value = "O" name="car_clean" > 적합</label>
				<label><input type="radio" value = "X" name="car_clean"> 부적합</label>
			</td>
		</tr>
		<tr>
			<td rowspan = 3>
				육안검사
			</td>
			<td style = "width: 20%;">색깔</td>
		    <td>
				<label><input type="radio" value = "O" name="visual_color" > 적합</label>
				<label><input type="radio" value = "X" name="visual_color"> 부적합</label>
			</td>
		</tr>
		<tr>
			<td>
				냄새
			</td>
		    <td>
				<label><input type="radio" value = "O" name="visual_smell" > 적합</label>
				<label><input type="radio" value = "X" name="visual_smell"> 부적합</label>
			</td>
		</tr>
		<tr>
			<td>
				기타
			</td>
		    <td>
				<label><input type="radio" value = "O" name="etc"> 적합</label>
				<label><input type="radio" value = "X" name="etc"> 부적합</label>
			</td>
		</tr>
		<tr>
			<td>
				성적서 확인
			</td>
		    <td colspan = 2>
				<label><input type="radio" value = "O" name="docs_yn"> 확인</label>
				<label><input type="radio" value = "X" name="docs_yn"> 미확인</label>
			</td>
		</tr>
		<tr>
			<td>
				비고(개선조치)
			</td>
		    <td colspan = 2>
				<textarea name = "bigo" style="width: 100%;height: 90px;" class="form-control" ></textarea>
			</td>
		</tr>
	</table>
</form>
<table class="table" id = "fileUpload">
	<tr>
		<td style = "width: 35%;">
			첨부자료
		</td>    
	    <td>
			<input type="hidden" class="form-control" id="txt_pid" name="pid"  value="M838S070100E111">
			<input type="hidden" class="form-control" id="txt_user_id" name="user_id"  value="henesys"> 
			<input type="hidden" class="form-control" id="txt_orderno" name="orderno" value="0" > 
			<input type="hidden" class="form-control" id="txt_order_detail" name="order_detail" value="1" > 
			<input type="hidden" class="form-control" id="txt_jspPage" name="jspPage"  value="M838S070101.jsp"> 
			<input type="hidden" class="form-control" id="txt_getnum_prefix" name="getnum_prefix"  value="HACCP"> 
			<input type="hidden" class="form-control" id="txt_JobType" name="JobType" value="INSERT" > 
			<input type="hidden" class="form-control" id="txt_doccode" name="doccode" value = "M838S070100" > 
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