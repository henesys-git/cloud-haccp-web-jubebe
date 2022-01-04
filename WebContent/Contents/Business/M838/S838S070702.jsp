<%@page import="com.mysql.cj.xdevapi.Table"%>
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
S838S070702.jsp
원료육 검사 기록 수정
*/
	String loginID = session.getAttribute("login_id").toString();
	
	String seq_no = "";
	
	if(request.getParameter("seq_no") != null)
		seq_no = request.getParameter("seq_no");	
	
	JSONObject jArray = new JSONObject();
	jArray.put("seq_no", seq_no);
	
    DoyosaeTableModel TableModel = new DoyosaeTableModel("M838S070700E154", jArray);
 	MakeGridData tData = new MakeGridData(TableModel);
%> 
<style>
#meat_table .result {

	vertical-align: middle;
	text-align: center;
	background-color: #dee2e6;
}

#meat_table .result label{
    margin: 0;
    width: 41%;
}

#meat_table tr td {
	
	width : 25%;
	vertical-align: middle;

}

#meat_table .label {
	text-align: center;
}

#meat_table label {
	font-weight: normal;
	margin : 0 4%;
    width: 31%;
	display: inline-block;
}

#meat_table label input {
	
	margin-right : 3%;
}

#meat_table textarea {

	width : 100%;
	border:1px solid #dee2e6;"
}
</style>
<script type="text/javascript">
    $(document).ready(function () {
    	
    	var data = <%= tData.getDataArray() %>;
		new SetSingleDate2("", "#check_date", 0);
		
		//검사목록
		var plus = 4;
		$("#meat_table input").each(function(idx) {
			if(idx == 4){		
				$("input:radio[value='"+data[0][idx + plus]+"']").prop("checked", true);
				if(data[0][idx + plus] == 1){
					$("input:radio[value='2']").prop("disabled", true);
				} else {
					$("input:radio[value='1']").prop("disabled", true);
				}
				plus = plus-1;
				return true;
			} else if(idx > 9){  return false; }
			
			$(this).val(data[0][idx + plus]);
		});
		
		//점검항목		
		$("input:radio[name$='_yn']").each(function(idx) {
			
			var name = $(this).attr("name");
			$("input[name='"+name+"'][value='"+data[0][idx/2+13]+"']").prop("checked", true);
							
		});
		
		$("input[name='temp_part']").val(data[0][20]);
		$("input[name='temp_car']").val(data[0][21]);
		
		$("input:radio[name='result'][value='"+data[0][22]+"']").prop("checked", true);
		
		//textarea
		$("textarea").each(function(y) {
			
			$(this).val(data[0][y+23]);
		})
		
		$("input:radio[name$='_yn']").change(function() {
			
			if($(this).val() == 'X'){
				
				$("input:radio[name='result'][value='X']").prop("checked", true);
				
			} else {
				
				$("input:radio[name$='_yn']").each(function() {
					
					if($(this).prop("checked") == true){
						
						if($(this).val() == "X"){
							$("input:radio[name='result'][value='X']").prop("checked", true);
							return false;	
						}
						
					}
					
					$("input:radio[name='result'][value='O']").prop("checked", true);
					
				});
				
			}
			
		}); // 판정결과[적합/부적합]
	
		var fileFrmShow = '<%=TableModel.getValueAt(0, 25)%>';
		
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
				        data:  {"bomdata" : JSONparam, "pid" : "M838S070700E113"},
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
	
    function serializeObject() { 
    	var obj = null; 
   	
		var arr = $("#meat_frm").serializeArray(); 
		
		if(arr){ 
			obj = {}; 
			jQuery.each(arr, function() { 
				obj[this.name] = this.value; 
			}); 
		}
		
    	return obj; 
    }

	function sendToJsp() {
		
		var dataJson = new Object();

		dataJson.seq_no = '<%=seq_no%>';
	 	dataJson.input = serializeObject();
	 	dataJson.person_write_id = '<%=loginID%>';
	 	
		var JSONparam = JSON.stringify(dataJson);
		var chekrtn = confirm("수정하시겠습니까?");
		
		if(chekrtn) {
			
			 $.ajax({
			        type: "POST",
			        dataType: "json",
			        url: "<%=Config.this_SERVER_path%>/Contents/CommonView/insert_update_delete_json.jsp", 
			        data:  {"bomdata" : JSONparam, "pid" : "M838S070700E102"},
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
							heneSwal.error('기록부 수정을 실패했습니다, 다시 시도해주세요');
			         	}
			         }
			     });
			
		}
		
	}
</script>
<form id = "meat_frm" onsubmit="return false;">
	<table class="table" id="meat_table">
		<tr style = "border-top: 2px solid #dee2e6;">
			<td>점검일자</td>
			<td>
				
			</td>
		    <td colspan=2>
				<input type="text" data-date-format="yyyy-mm-dd" id="check_date" name = "check_date" class="form-control">
			</td>
		</tr>
	  	<tr>
	  		<td>거래처</td>
	 		<td>
				<input type="text" id="cust_nm" name = "cust_nm" class="form-control" readonly >
			</td>
	 		<td>제품명</td>
	  		<td>
	  			<input type="text" id="part_cd" name = "part_cd" class="form-control" readonly >
	  		</td>
	  	</tr>
	  	<tr>
	  		<td>
				원산지
	  		</td>
	  		<td>
	  			<input type="text" name = "part_origin" class="form-control" id="part_origin" readonly >
	  		</td>
			<td>
				보관방법
			</td>
		    <td>
				<label><input type="radio" name = "keep_way" value = "1" onclick="return(false);" > 냉장</label>
				<label><input type="radio" name = "keep_way" value = "2" onclick="return(false);" > 냉동</label>
			</td>
		</tr>
		<tr>
			<td>
				입고수량(박스/kg)
			</td>
		    <td>
				<input type="text" id="ipgo_amount" name = "ipgo_amount" class="form-control">
			</td>
			<td>
				검수수량(박스)
			</td>
		    <td>
				<input type="text" id="check_amount" name = "check_amount" class="form-control">
			</td>
		</tr>
		<tr>
			<td>
				입고시작 시간
			</td>
		    <td>
		    	 <input type="time" id="ipgo_start_time" name = "ipgo_start_time" class="form-control">
			</td>
			<td>
				입고완료 시간
			</td>
		    <td>
				<input type="time" id="ipgo_complete_time" name = "ipgo_complete_time" class="form-control">
			</td>
		</tr>
		<tr style = "border-top: 2px solid #dee2e6;">
			<td>
				항목
			</td>
		    <td>
		    	평가내용
			</td>
		    <td>
		    	적합 : O  부적합 : X
			</td>
			<td class = "result">
		    	판정결과
			</td>
		</tr>
		<tr>
			<td>
				색깔(육질)
			</td>
		    <td>
		    	고유의 색택
			</td>
		    <td class = "label">
		    	<label><input type="radio" id="color_yn_O" name = "color_yn" value = "O"> O</label>
		    	<label><input type="radio" id="color_yn_X" name = "color_yn" value = "X"> X</label>
			</td>
			
		    <td rowspan = 9 class = "result">
		    	<label><input type="radio"  name = "result" value = "O" onclick="return(false);" /> 적합</label>
				<label><input type="radio"  name = "result" value = "X" onclick="return(false);" /> 부적합</label>
			</td>
		</tr>
		<tr>
			<td>
				이물질
			</td>
		    <td>
		    	유무
			</td>
		    <td class = "label">
		    	<label><input type="radio"  name = "foreign_matter_yn" value = "O"> O</label>
				<label><input type="radio"  name = "foreign_matter_yn" value = "X"> X</label>
			</td>
		</tr>
		<tr>
			<td>
				냄새
			</td>
		    <td>
		    	이취여부
			</td>
		    <td class = "label">
		    	<label><input type="radio"  name = "smell_yn" value = "O"> O</label>
				<label><input type="radio"  name = "smell_yn" value = "X"> X</label>
			</td>
		</tr>
		<tr>
			<td rowspan = 2>
				포장상태
			</td>
		    <td>
		    	파손 없음
			</td>
		    <td class = "label">
		    	<label><input type="radio"  name = "destroy_yn" value = "O"> O</label>
				<label><input type="radio"  name = "destroy_yn" value = "X"> X</label>
			</td>
		</tr>
		<tr>
		    <td>
		    	육즙침출 없음
			</td>
		    <td class = "label">
		    	<label><input type="radio"  name = "meat_juice_yn" value = "O"> O</label>
				<label><input type="radio"  name = "meat_juice_yn" value = "X"> X</label>
			</td>
		</tr>
		<tr>
			<td rowspan = 2>
				온도기록
			</td>
		    <td>
		    	심부온도
			</td>
		    <td>
		    	<div class="input-group">
		  			<input type="number" class="form-control" id="temp_part" name = "temp_part" value = '<%= TableModel.getValueAt(0, 18) %>'>
		  			<div class="input-group-append">
					     <span class="input-group-text">&#8451;</span>
			        </div>
		        </div>
			</td>
		</tr>
		<tr>
		    <td>
		    	차량온도
			</td>
		    <td>
				<div class="input-group">
		  			<input type="number" class="form-control" id="temp_car" name = "temp_car" value = '<%= TableModel.getValueAt(0, 19) %>'>
		  			<div class="input-group-append">
					     <span class="input-group-text">&#8451;</span>
			        </div>
		        </div>
			</td>
		</tr>
		<tr>
			<td rowspan = 2>
				서류검사
			</td>
		    <td>
		    	도축증명서
			</td>
		    <td class = "label">
		    	<label><input type="radio"  name = "document1_yn" value = "O"> O</label>
				<label><input type="radio"  name = "document1_yn" value = "X"> X</label>
			</td>
		</tr>
		<tr>
		    <td>
		    	거래명세서
			</td>
		    <td class = "label">
		    	<label><input type="radio"  name = "document2_yn" value = "O"> O</label>
				<label><input type="radio"  name = "document2_yn" value = "X"> X</label>
			</td>
		</tr>
		<tr style = "border-top: 2px solid #dee2e6;">
		    <td colspan = 2 style = "border-right: 1px solid #dee2e6;">부적합내역</td>
		    <td colspan = 2>개선조치결과</td>
		</tr>
		<tr>
		    <td colspan = 2 style = "padding:0;">
		    	<textarea name = "unsuit_detail"></textarea>
		    </td>
		    <td colspan = 2 style = "padding:0">
		    	<textarea name = "improve_action"></textarea>
		    </td>
		</tr>
	</table>
</form>
<table class="table" id = "fileUpload">
	<tr>
		<td style = "width : 23%">
			첨부자료
		</td>
	    <td colspan = 2>
			<input type="hidden" class="form-control" id="txt_pid" name="pid"  value="M838S070700E112"> 
			<input type="hidden" class="form-control" id="txt_user_id" name="user_id"  value="henesys"> 
			<input type="hidden" class="form-control" id="txt_orderno" name="orderno" value="0" > 
			<input type="hidden" class="form-control" id="txt_order_detail" name="order_detail" value="1" > 
			<input type="hidden" class="form-control" id="txt_jspPage" name="jspPage"  value="M838S070702.jsp"> 
			<input type="hidden" class="form-control" id="txt_getnum_prefix" name="getnum_prefix"  value="수정시 prefix 필요 없음"> 
			<input type="hidden" class="form-control" id="txt_JobType" name="JobType" value="UPDATE" > 
			<input type="hidden" class="form-control" id="txt_docname" name="docname" value="<%= TableModel.getValueAt(0, 26) %>">
			<input type="hidden" class="form-control" id="txt_regist_no" name="regist_no" value="<%= TableModel.getValueAt(0, 25) %>">
			<input type="hidden" class="form-control" id="txt_doccode" name="doccode" value = "M838S070700" > 
			<input type="hidden" class="form-control" id="txt_rev_no" name="rev_no" value = "<%= TableModel.getValueAt(0, 28) %>" > 
			<input type="hidden" class="form-control" id="txt_doc_gubun" name="doc_gubun"  value="<%= TableModel.getValueAt(0, 26) %>" > 
	    <!-- ///////////////////////////////////////////////////////////////////////////////////  -->	
			<form id="update_form" enctype="multipart/form-data" action="<%= request.getContextPath() %>/hcp_EdmsServerServlet" method="post">
				<input type="file" id="idFilename" name="filenames" multiple="multiple" class="form-control" style = "height: 0%;">
			</form>		
			<input type="text" id="attached_document" name = "attached_document" value = "<%= TableModel.getValueAt(0, 26) %>" class="form-control" disabled>
			<i id = "fileDelete" class="fas fa-times" style = "left:95%;"></i>
		</td>
	</tr>
</table>