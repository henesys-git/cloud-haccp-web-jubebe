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
S838S070102.jsp
원부재료 입고검사 대장 수정
*/
	String loginID = session.getAttribute("login_id").toString();
	
	String seq_no = "", cust_nm = "", part_nm = "", ipgo_amount = "";
	
	if(request.getParameter("seq_no") != null)
		seq_no = request.getParameter("seq_no");	
	
	if(request.getParameter("cust_nm") != null)
		cust_nm = request.getParameter("cust_nm");	
	
	if(request.getParameter("part_nm") != null)
		part_nm = request.getParameter("part_nm");	

	if(request.getParameter("ipgo_amount") != null)
		ipgo_amount = request.getParameter("ipgo_amount");	
	
	JSONObject jArray = new JSONObject();
	jArray.put("seq_no", seq_no);
	
	DoyosaeTableModel TableModel = new DoyosaeTableModel("M838S070100E154", jArray);
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
		
    	new SetSingleDate2("<%=TableModel.getValueAt(0, 2)%>", "#ipgo_date", 0);
    	
		$('#ipgo_date').attr('disabled', true);
		
		// 데이터 넣기
		var dataArr = <%= tData.getDataArray() %>;
		dataArr = dataArr[0];
		dataArr.splice(8, 0, '<%= cust_nm %>', '<%= part_nm %>', '<%= ipgo_amount %>')
		
		var plus = 2;
		$("#ipgo_check_frm input").each(function(idx) {
 						
			if(idx > 8){
	
				if(idx%2==0){
					plus = plus - 1;
				}  
				
				var nm = $(this).attr("name");
				$("input:radio[name = '"+nm+"'][value='"+dataArr[(plus + idx)]+"']").prop("checked", true);
				
				return true;
			}
		
			$(this).val(dataArr[(2 + idx)]);
			
		});
		
		$("textarea[name = 'bigo']").val(dataArr[16]);
		
		var fileFrmShow = '<%=TableModel.getValueAt(0, 15)%>';
		
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
				        data:  {"bomdata" : JSONparam, "pid" : "M838S070100E113"},
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
	
    function serializeObject(frm) { 
    	var obj = null; 
   	
		var arr = frm.serializeArray(); 
		
		if(arr){ 
			obj = {}; 
			jQuery.each(arr, function() { 
				obj[this.name] = this.value; 
			}); 
		}
		
    	return obj; 
    }
    
	function SendTojsp() {
    	
	        var dataJson = new Object();
	        
	        dataJson.seq_no = '<%=seq_no%>';
	    	dataJson.input_data = serializeObject($("#ipgo_check_frm"));
			dataJson.person_write_id = '<%=loginID%>';
        	
			var JSONparam = JSON.stringify(dataJson);
			var chekrtn = confirm("수정하시겠습니까?"); 
			
			if(chekrtn) {
				
				 $.ajax({
				        type: "POST",
				        dataType: "json",
				        url: "<%=Config.this_SERVER_path%>/Contents/CommonView/insert_update_delete_json.jsp", 
				        data:  {"bomdata" : JSONparam, "pid" : "M838S070100E102"},
						success: function (html) {	
							if(html > -1) {

								if($("#idFilename").val() == "" || $("#idFilename").val() == null){
									
									heneSwal.success('기록부 수정이 완료되었습니다');
									
			    					$('#modalReport').modal('hide');
			    	        		parent.parent.fn_MainInfo_List(toDate);
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
					                data.append("seq_no", '<%=seq_no%>'); 		// 관리본여부
				
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
					        	        		parent.parent.fn_MainInfo_List(toDate);
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
								heneSwal.error('기록부 수정을 실패했습니다, 다시 시도해주세요');
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
		<!-- 		<input type="hidden" name="ipgo_seq_no" class="form-control"> -->
				<input type="hidden" name="trace_key" class="form-control">
				<input type="hidden" name="cust_cd" class="form-control">
				<input type="hidden" name="cust_rev_no" class="form-control" >
				<input type="hidden" name="part_cd" class="form-control">
				<input type="hidden" name="part_rev_no" class="form-control" >
			</td>
		</tr>
	 	<tr>
			<td>
				업체명
			</td>
		    <td colspan = 2>
				<input type="text" id="cust_nm" class="form-control"  readonly >
			</td>
		</tr>
		<tr>
			<td>
				제품명
			</td>
		    <td colspan = 2>
				<input type="text" id="part_nm" class="form-control" readonly >
			</td>
		</tr>
		<tr>
			<td>
				입고량
			</td>
		    <td colspan = 2>
				<input type="text" id="ipgo_amount" class="form-control" readonly >
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
			<input type="hidden" class="form-control" id="txt_pid" name="pid"  value="M838S070100E112"> 
			<input type="hidden" class="form-control" id="txt_user_id" name="user_id"  value="henesys"> 
			<input type="hidden" class="form-control" id="txt_orderno" name="orderno" value="0" > 
			<input type="hidden" class="form-control" id="txt_order_detail" name="order_detail" value="1" > 
			<input type="hidden" class="form-control" id="txt_jspPage" name="jspPage"  value="M838S070102.jsp"> 
			<input type="hidden" class="form-control" id="txt_getnum_prefix" name="getnum_prefix"  value="수정시 prefix 필요 없음"> 
			<input type="hidden" class="form-control" id="txt_JobType" name="JobType" value="UPDATE" > 
			<input type="hidden" class="form-control" id="txt_docname" name="docname" value="<%= TableModel.getValueAt(0, 15) %>">
			<input type="hidden" class="form-control" id="txt_regist_no" name="regist_no" value="<%= TableModel.getValueAt(0, 14) %>">
			<input type="hidden" class="form-control" id="txt_doccode" name="doccode" value = "M838S070100" > 
			<input type="hidden" class="form-control" id="txt_rev_no" name="rev_no" value = "<%= TableModel.getValueAt(0, 17) %>" > 
			<input type="hidden" class="form-control" id="txt_doc_gubun" name="doc_gubun"  value="<%= TableModel.getValueAt(0, 15) %>" > 
	    <!-- ///////////////////////////////////////////////////////////////////////////////////  -->	
			<form id="update_form" enctype="multipart/form-data" action="<%= request.getContextPath() %>/hcp_EdmsServerServlet" method="post">
				<input type="file" id="idFilename" name="filenames" multiple="multiple" class="form-control" style = "height: 0%;">
			</form>		
			<input type="text" id="attached_document" name = "attached_document" value = "<%= TableModel.getValueAt(0, 15) %>" class="form-control" disabled>
			<i id = "fileDelete" class="fas fa-times" style = "left: 92%;"></i>
		</td>
	</tr>
</table>