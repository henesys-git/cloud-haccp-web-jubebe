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
S838S070701.jsp
원료육 검사 기록 등록
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
		
		var keep_way = '<%= TableModel.getValueAt(0, 18) %>'
		
		if(keep_way.substr(0,2) == "냉장"){
			$("input:radio[value='1']").prop("checked", true);
			$("input:radio[value='2']").prop("disabled", true);
		} else {
			$("input:radio[value='2']").prop("checked", true);
			$("input:radio[value='1']").prop("disabled", true);
		}

		$("input:radio[value='O']").prop("checked", true);

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
			
		});
	
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

    function inputNullCheck() {

    	let flag = true; 
    	
		$(".notNull").each(function() {
			
			if($(this).val() == "" || $(this).val() == null){
				
				heneSwal.warningTimer('빈칸을 모두 입력해주세요.');
				$(this).focus();
				
				flag = false;
				return false;
			}
			
		})
		
		return flag;
	}
    
	function SendTojsp() {
		
		var flag = inputNullCheck();
		
		if(flag){
			var dataJson = new Object();
	
			dataJson.checklist_id = '<%=checklist_id%>';
		 	dataJson.input = serializeObject($("#meat_frm"));
		 	dataJson.balju_no = '<%=balju_no%>';
		 	dataJson.part_cd = '<%=part_cd%>';
		 	dataJson.person_write_id = '<%=loginID%>';
		 	
			var JSONparam = JSON.stringify(dataJson);
			var chekrtn = confirm("등록하시겠습니까?");
			
			if(chekrtn) {
				
				 $.ajax({
				        type: "POST",
				        dataType: "json",
				        url: "<%=Config.this_SERVER_path%>/Contents/CommonView/insert_update_delete_json.jsp", 
				        data:  {"bomdata" : JSONparam, "pid" : "M838S070700E101"},
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
					        				}
					        			},
					           	        error: function (e) {
					        				$("#result").text(e.responseText);
					           	        }
					           	    });
					                
								}
				        		
				         	} else {
								heneSwal.error('기록부 등록 실패했습니다, 다시 시도해주세요');
				         	}
				         }
				     });
			
			} // confirm
		}	//flag	
	}
</script>
<form id = "meat_frm" onsubmit="return false;">
	<table class="table" id="meat_table">
		<tr style = "border-top: 2px solid #dee2e6;">
			<td colspan=2>
				점검일자
			</td>
		    <td colspan=2>
				<input type="text" data-date-format="yyyy-mm-dd" id="check_date" name = "check_date" class="form-control">
			</td>
		</tr>
	  	<tr>
	  		<td>거래처</td>
	 		<td>
				<input type="text" id="cust_nm" name = "cust_nm" class="form-control" value = "<%= TableModel.getValueAt(0, 15) %>" readonly >
			</td>
	 		<td>제품명</td>
	  		<td>
	  			<input type="text" id="part_cd" name = "part_nm" class="form-control" value = "<%= TableModel.getValueAt(0, 16) %>" readonly >
	  		</td>
	  	</tr>
	  	<tr>
	  		<td>
				원산지
	  		</td>
	  		<td>
	  			<input type="text" name = "part_origin" class="form-control" id="part_origin" value = "<%= TableModel.getValueAt(0, 17) %>" readonly >
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
				<input type="number" id="ipgo_amount" name = "ipgo_amount" class="form-control notNull" min = 0 />
			</td>
			<td>
				검수수량(박스)
			</td>
		    <td>
				<input type="number" id="check_amount" name = "check_amount" class="form-control notNull" min = 0 />
			</td>
		</tr>
		<tr>
			<td>
				입고시작 시간
			</td>
		    <td>
		    	 <input type="time" id="ipgo_start_time" name = "ipgo_start_time" class="form-control notNull">
			</td>
			<td>
				입고완료 시간
			</td>
		    <td>
				<input type="time" id="ipgo_complete_time" name = "ipgo_complete_time" class="form-control notNull">
			</td>
		</tr>
		<tr></tr>
		<tr></tr>
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
		  			<input type="number" class="form-control notNull" id="temp_part" name = "temp_part" min = 0>
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
		  			<input type="number" class="form-control notNull" id="temp_car" name = "temp_car" min = 0>
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
		    	<textarea name = "unsuit_detail" ></textarea>
		    </td>
		    <td colspan = 2 style = "padding:0">
		    	<textarea name = "improve_action"></textarea>
		    </td>
		</tr>
	</table>
</form>
<table class="table" id = "fileUpload">
	<tr>
		<td>
			첨부자료
		</td>    
	    <td>
			<input type="hidden" class="form-control" id="txt_pid" name="pid"  value="M838S070700E111">
			<input type="hidden" class="form-control" id="txt_user_id" name="user_id"  value="henesys"> 
			<input type="hidden" class="form-control" id="txt_orderno" name="orderno" value="0" > 
			<input type="hidden" class="form-control" id="txt_order_detail" name="order_detail" value="1" > 
			<input type="hidden" class="form-control" id="txt_jspPage" name="jspPage"  value="M838S070701.jsp"> 
			<input type="hidden" class="form-control" id="txt_getnum_prefix" name="getnum_prefix"  value="HACCP"> 
			<input type="hidden" class="form-control" id="txt_JobType" name="JobType" value="INSERT" > 
			<input type="hidden" class="form-control" id="txt_doccode" name="doccode" value = "M838S070700" > 
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