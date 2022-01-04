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
S838S020801.jsp
소독약품 관리대장 - 상세수정
*/
	String loginID = session.getAttribute("login_id").toString();
	
	String checklist_id = "", checklist_rev_no = "", regist_seq_no = "", check_date = "";
	
	if(request.getParameter("checklist_id") != null)
		checklist_id = request.getParameter("checklist_id");	

	if(request.getParameter("checklist_rev_no") != null)
		checklist_rev_no = request.getParameter("checklist_rev_no");
	
	if(request.getParameter("regist_seq_no") != null)
		regist_seq_no = request.getParameter("regist_seq_no");
	
	if(request.getParameter("check_date") != null)
		check_date = request.getParameter("check_date");
	
	JSONObject jArray = new JSONObject();
	jArray.put("regist_seq_no", regist_seq_no);
	jArray.put("check_date", check_date);	
	
	DoyosaeTableModel TableModel = new DoyosaeTableModel("M838S020800E154", jArray);
 	MakeGridData tData = new MakeGridData(TableModel);
    tData.htmlTable_ID = "TableS838S020810";
	
%> 
<script type="text/javascript">
    $(document).ready(function () {
    	
		new SetSingleDate2("<%=check_date%>", "#check_date", 0);
		
		$("#check_date").attr("disabled",true);
		
		var dataArr = <%=tData.getDataArray()%>;
		
		for(var i=1; i<=dataArr.length; i++){
			
			$('#purchase_amount_'+i).val(dataArr[i-1][3]);
			$('#use_amount_'+i).val(dataArr[i-1][4]);
			$('#stock_amount_'+i).val(dataArr[i-1][5]);
			$('#check_detail_'+i).val(dataArr[i-1][6]);
			$('input:radio[name=result_'+i+']:input[value='+dataArr[i-1][7]+']').attr("checked",true);
				
		}
		
    });	
	
	function SaveOderInfo() {
		
		var flag = true;
		$("#bom_table input").each(function() {
			
			if($(this).val() == "" || $(this).val() == null){
				
				flag = false;
				$(this).focus();
				heneSwal.warning('빈칸을 모두 입력해주세요.');
				return false;
			}
			
		});
		
		if(flag){
		
	        var dataJson = new Object();
	        
			dataJson.checklist_id = '<%=checklist_id%>';
			dataJson.checklist_rev_no = '<%=checklist_rev_no%>';
		 	dataJson.check_date ='<%=check_date%>';
		 	dataJson.person_write_id = '<%=loginID%>';
		 	dataJson.form = $('#formTest').serializeArray();
		 	
		 	dataJson.regist_seq_no = '<%=regist_seq_no%>';
		 	
			var JSONparam = JSON.stringify(dataJson);
			var chekrtn = confirm("수정하시겠습니까?");
			
			if(chekrtn) {
				SendTojsp(JSONparam, "M838S020800E112");
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
					heneSwal.success('점검 기록 수정이 완료되었습니다');

					$('#modalReport').modal('hide');
					parent.fn_MainInfo_List(startDate, endDate);
					parent.$('#SubInfo_List_contents').hide();
	         	} else {
					heneSwal.error('점검 기록 수정 실패했습니다, 다시 시도해주세요');
	         	}
	         }
	     });
	}
</script>

<form id = "formTest" >
	<table class="table" id="bom_table">
		<tr>
			<td>
				
			</td>
		    <td align = "right">
		    	점검일자 &nbsp;
				<input type="text" data-date-format="yyyy-mm-dd" id="check_date" class="form-control" style = "width:36%; display:inline-block;">
			</td>
		</tr>
	   	<tr>
	 		<td>
				바이오<br>크린콜
	  		</td>
	  		<td>
	  			<input type="hidden" class="form-control" id="disinfectant_id_1" name="disinfectant_id_1"  value = "dinfec01">
	  			<table>
	  				<tr>
	  					<th>구입량</th>
	  					<th>사용량</th>
	  					<th>재고량</th>
	  				</tr>
	  				<tr>
	  					<td><input type="number" class="form-control" id="purchase_amount_1" name="purchase_amount_1" min="0" ></td>
	  					<td><input type="number" class="form-control" id="use_amount_1" name="use_amount_1" min="0" ></td>
	  					<td><input type="number" class="form-control" id="stock_amount_1" name="stock_amount_1" min="0" ></td>
	  				</tr>
	  				<tr>
	  					<th colspan = "2">내용</th>
	  					<th>결과</th>
	  				</tr>
	  				<tr>
	  					<td colspan = "2"><input type="text" class="form-control" id="check_detail_1" name="check_detail_1"></td>
	  					<td style= "text-align: center; vertical-align: middle;">
	  						<input type="radio" name="result_1" value = 'O'><span style= "margin: 0 7%;">양호</span>
	  						<input type="radio" name="result_1" value = 'X'> <span style= "margin: 0 7%;">불량</span>
	  					</td>
	  				</tr>
	  			</table>
	  		</td>
	  	</tr>
	  	<tr>
	 		<td>
				유한<br>락스
	  		<td>
	  			<input type="hidden" class="form-control" id="disinfectant_id_2" name="disinfectant_id_2" value = "dinfec02">
	  			<table>
	  				<tr>
	  					<th>구입량</th>
	  					<th>사용량</th>
	  					<th>재고량</th>
	  				</tr>
	  				<tr>
	  					<td><input type="number" class="form-control" id="purchase_amount_2" name="purchase_amount_2" min="0" ></td>
	  					<td><input type="number" class="form-control" id="use_amount_2" name="use_amount_2" min="0" ></td>
	  					<td><input type="number" class="form-control" id="stock_amount_2" name="stock_amount_2" min="0" ></td>
	  				</tr>
	  				<tr>
	  					<th colspan = "2">내용</th>
	  					<th>결과</th>
	  				</tr>
	  				<tr>
	  					<td colspan = "2"><input type="text" class="form-control" id="check_detail_2" name="check_detail_2"></td>
	  					<td style= "text-align: center; vertical-align: middle;">
	  						<input type="radio" name="result_2" value = 'O'><span style= "margin: 0 7%;">양호</span>
	  						<input type="radio" name="result_2" value = 'X'> <span style= "margin: 0 7%;">불량</span>
	  					</td>
	  				</tr>
	  			</table>
	  		</td>
	  	</tr>
	  	<tr>
	 		<td>
				하이롱
	  		</td>
	  		<td>
	  			<input type="hidden" class="form-control" id="disinfectant_id_3" value = "dinfec03" name ="disinfectant_id_3">
	  			<table>
	  				<tr>
	  					<th>구입량</th>
	  					<th>사용량</th>
	  					<th>재고량</th>
	  				</tr>
	  				<tr>
	  					<td><input type="number" class="form-control" id="purchase_amount_3" name="purchase_amount_3" min="0" ></td>
	  					<td><input type="number" class="form-control" id="use_amount_3" name="use_amount_3" min="0" ></td>
	  					<td><input type="number" class="form-control" id="stock_amount_3" name="stock_amount_3" min="0" ></td>
	  				</tr>
	  				<tr>
	  					<th colspan = "2">내용</th>
	  					<th>결과</th>
	  				</tr>
	  				<tr>
	  					<td colspan = "2"><input type="text" class="form-control" id="check_detail_3" name="check_detail_3"></td>
	  					<td style= "text-align: center; vertical-align: middle;">
	  						<input type="radio" name="result_3" value = 'O'><span style= "margin: 0 7%;">양호</span>
	  						<input type="radio" name="result_3" value = 'X'> <span style= "margin: 0 7%;">불량</span>
	  					</td>
	  				</tr>
	  			</table>
	  		</td>
	  	</tr>
	  	<tr>
	 		<td>
				포미
	  		</td>
	  		<td>
	  			<input type="hidden" class="form-control" id="disinfectant_id_4" value = "dinfec04" name="disinfectant_id_4">
	  			<table>
	  				<tr>
	  					<th>구입량</th>
	  					<th>사용량</th>
	  					<th>재고량</th>
	  				</tr>
	  				<tr>
	  					<td><input type="number" class="form-control" id="purchase_amount_4" name="purchase_amount_4" min="0" ></td>
	  					<td><input type="number" class="form-control" id="use_amount_4" name="use_amount_4" min="0" ></td>
	  					<td><input type="number" class="form-control" id="stock_amount_4" name="stock_amount_4" min="0" ></td>
	  				</tr>
	  				<tr>
	  					<th colspan = "2">내용</th>
	  					<th>결과</th>
	  				</tr>
	  				<tr>
	  					<td colspan = "2"><input type="text" class="form-control" id="check_detail_4" name="check_detail_4"></td>
	  					<td style= "text-align: center; vertical-align: middle;">
	  						<input type="radio" name="result_4" value = 'O'><span style= "margin: 0 7%;">양호</span>
	  						<input type="radio" name="result_4" value = 'X'> <span style= "margin: 0 7%;">불량</span>
	  					</td>
	  				</tr>
	  			</table>
	  		</td>
	  	</tr>
	</table>
</form>