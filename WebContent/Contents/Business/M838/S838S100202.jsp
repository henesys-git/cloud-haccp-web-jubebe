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
S838S100202.jsp
차량 관리기록 기록 수정
*/
	String loginID=session.getAttribute("login_id").toString();
	
	String regist_seq_no = "", drive_date = "";
	
	if(request.getParameter("regist_seq_no") != null)
		regist_seq_no=request.getParameter("regist_seq_no");
	if(request.getParameter("drive_date") != null)
		drive_date = request.getParameter("drive_date");	
	
	JSONObject jArray = new JSONObject();
	jArray.put("regist_seq_no", regist_seq_no);
	jArray.put("drive_date", drive_date);
	
    DoyosaeTableModel TableModel = new DoyosaeTableModel("M838S100200E154", jArray);
 	MakeGridData tData = new MakeGridData(TableModel);
 	
 	DoyosaeTableModel TableModel2 = new DoyosaeTableModel("M838S100200E134", jArray);
%> 
<style>
#car_textarea textarea {
	width:100%;
}

#car_table, #fileUpload, #car_textarea {
	margin-bottom: 0;
} 

#car_table label {
	font-weight: normal;
}

#fileDelete {
    position: relative;
    bottom: 31px;
    left: 95%;
    color: lightslategrey;
    cursor: pointer;
}
</style>
<script type="text/javascript">
    $(document).ready(function () {
    	
    	var data = <%= tData.getDataArray() %>;
    	
		new SetSingleDate2('<%=drive_date%>', "#drive_date", 0);
		$('#drive_date').attr('disabled', true);
		
		// data
		$("input:radio[name='check_yn1'][value='"+data[0][4]+"']").prop("checked", true);
		$("input:radio[name='check_yn2'][value='"+data[0][5]+"']").prop("checked", true);
		
		$("#car_textarea textarea").each(function(idx) {
			$(this).val(data[0][6+idx]);			
		})
		
		// detail data
		for(x in data){
			$("input[name='drive_course_start_"+x+"']").val(data[x][9]);
			$("input[name='drive_course_end_"+x+"']").val(data[x][10]);
			
			$("input[name='departure_time_"+x+"']").val(data[x][11]);
			$("input[name='arrive_time_"+x+"']").val(data[x][12]);

			$("select[name^='vehicle_id_']").val(data[x][13]).prop("selected", true);
			$("select[name='temp_gubun_"+x+"']").val(data[x][14]).prop("selected", true);
		}
			
		// change vehicle
		$("select[name^='vehicle_id_']").change(function() {
			$("select[name^='vehicle_id_']").val($(this).val());
		});
		
		// 자동 채우기
		$("input[name^='drive_course_end_']").keyup(function() {
			
			var endToStart = $(this).val();
			
			var name = $(this).attr("name");
			var num = parseInt(name.slice(-1)) + 1;
			
			$("input[name^='drive_course_start_"+num+"']").val(endToStart);
			
		});
		
		$("input[name^='arrive_time_']").change(function() {
			
			// 약간에 텀을 원하면 val + 10 추가로 수정 가능
			var endToStartTime = $(this).val();
						
			var name = $(this).attr("name");
			var num = parseInt(name.slice(-1)) + 1;
			
			$("input[name^='departure_time_"+num+"']").val(endToStartTime);
			
		});
		
		// file show & hide
		var fileFrmShow = '<%=TableModel.getValueAt(0, 17)%>';
		
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
				 dataJson.regist_seq_no = '<%= regist_seq_no%>';
				 var JSONparam = JSON.stringify(dataJson);
				
				 $.ajax({
				        type: "POST",
				        dataType: "json",
				        url: "<%= Config.this_SERVER_path%>/Contents/CommonView/insert_update_delete_json.jsp", 
				        data:  {"bomdata" : JSONparam, "pid" : "M838S100200E113"},
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
	
    function inputNullCheck() {

    	let flag = true; 
    	
		$("#car_table input[name$='_0']").each(function() {
			
			if($(this).val() == "" || $(this).val() == null){
				
				heneSwal.warningTimer('첫 줄은 입력이 필요합니다.');
				$(this).focus();
				
				flag = false;
				return false;
			}
			
		})
		
		return flag;
	}
    
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

	function sendToJsp() {
		
		var flag = inputNullCheck();
		
		if(flag){
			
			var dataJson = new Object();

	        dataJson.regist_seq_no = '<%= regist_seq_no%>';
	        dataJson.drive_date = '<%= drive_date%>';
		 	dataJson.form = serializeObject($("#car_frm"));        
		 	dataJson.unsuit_detail = $('#unsuit_detail').val();
		 	dataJson.improve_action = $('#improve_action').val();
		 	dataJson.bigo = $('#bigo').val();
		 	dataJson.person_write_id = '<%= loginID%>';
		 	
			var JSONparam = JSON.stringify(dataJson);
			var chekrtn = confirm("수정하시겠습니까?");
			
			if(chekrtn) {
				
				 $.ajax({
				        type: "POST",
				        dataType: "json",
				        url: "<%=Config.this_SERVER_path%>/Contents/CommonView/insert_update_delete_json.jsp", 
				        data:  {"bomdata" : JSONparam, "pid" : "M838S100200E102"},
						success: function (html) {	
							if(html > -1) {

								if($("#idFilename").val() == "" || $("#idFilename").val() == null){
									
									heneSwal.success('기록부 수정이 완료되었습니다');
									
			    					$('#modalReport').modal('hide');
			    	        		parent.fn_MainInfo_List(startDate, endDate);
			    	        		parent.$('#SubInfo_List_contents').hide();
									
								} else {
									
									var form=$('#update_form')[0];
					                var data=new FormData(form);
					                
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
					                data.append("seq_no", '<%=regist_seq_no%>'); 		
				
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
				
			} //end confirm
			
		} //end if(flag) 
		
	}
</script>
<form id="car_frm" onsubmit="return false;">
	<table class="table" id="car_table">
		<tr>
			<td colspan=3>
				운행일자
			</td>
		    <td colspan=3>
				<input type="text" data-date-format="yyyy-mm-dd" id="drive_date" name="drive_date" class="form-control">
			</td>
		</tr>
		<tr>
	 		<td rowspan=2 style="width:20%;">
				확인사항
	  		</td>
	  		<td colspan=3>
				1. 탑차내부는 이물, 이취가 없으며 청결한가?
	  		</td>
	  		<td colspan=2 align="center">
	  			<label><input type="radio" name="check_yn1" value="O"/> &nbsp; 적합</label>&nbsp;&nbsp;
	  			<label><input type="radio" name="check_yn1" value="X" />&nbsp; 부적합</label>
	  		</td>
	  	</tr>
	   	<tr>
	 		<td colspan=3>
				2. 차량냉동기는 정상적으로 작동되는가?
	  		</td>
	  		<td colspan=2 align="center">
	  			<label><input type="radio" name="check_yn2" value="O"/> &nbsp; 적합</label>&nbsp;&nbsp;
	  			<label><input type="radio" name="check_yn2" value="X" />&nbsp; 부적합</label>
	  		</td>
	  	</tr>
	  	<tbody id="car_body">
		 	<tr>
		 		<td colspan=2>
					운행구간
		  		</td>
		  		<td>
		  			출발시간
		  		</td>
		  		<td>
		  			도착시간
		  		</td>
		  		<td style="width:22%;">
		  			차량/운전자
		  		</td>
		  		<td style="width:24%;">
		  			냉장/냉동
		  		</td>
		  	</tr>
	<% for(int i=0; i < 8; i++) { %>
			<tr>
		  		<td>
		  			<input type="text" name="drive_course_start_<%= i %>" class="form-control">
		  		</td>
		  		<td style="width:20%;">
		  			<input type="text" name="drive_course_end_<%= i %>" class="form-control">
		  		</td>
		  		<td>
					<input type="time" name="departure_time_<%= i %>" class="form-control">
				</td>
				<td>
					<input type="time" name="arrive_time_<%= i %>" class="form-control">
				</td>
			    <td>
					<select class="form-control" name="vehicle_id_<%= i %>" style="padding:0;">
					<% for(int j=0; j < TableModel2.getRowCount(); j++) { %>
						<option value="<%= TableModel2.getValueAt(j, 0) %>"><%= TableModel2.getValueAt(j, 1) %></option>
					<% }%>
					</select>
				</td>
				<td>
					<select class="form-control" name="temp_gubun_<%= i %>" style="padding:0;">
						<option value="1">냉장/냉동</option>
						<option value="2">냉장</option>
						<option value="3">냉동</option>
					</select>
				</td>
		  	</tr>
	<%	} %>
	  	</tbody>
	</table>
</form>
<table class="table" id="fileUpload">
	<tr>
		<td style="width:25%">
			첨부자료
		</td>    
	    <td>
			<input type="hidden" class="form-control" id="txt_pid" name="pid"  value="M838S100200E112"> 
			<input type="hidden" class="form-control" id="txt_user_id" name="user_id"  value="henesys"> 
			<input type="hidden" class="form-control" id="txt_orderno" name="orderno" value="0" > 
			<input type="hidden" class="form-control" id="txt_order_detail" name="order_detail" value="1" > 
			<input type="hidden" class="form-control" id="txt_jspPage" name="jspPage"  value="M838S100200.jsp"> 
			<input type="hidden" class="form-control" id="txt_getnum_prefix" name="getnum_prefix"  value="수정시 prefix 필요 없음"> 
			<input type="hidden" class="form-control" id="txt_JobType" name="JobType" value="UPDATE" > 
			<input type="hidden" class="form-control" id="txt_docname" name="docname" value="<%= TableModel.getValueAt(0, 16) %>">
			<input type="hidden" class="form-control" id="txt_regist_no" name="regist_no" value="<%= TableModel.getValueAt(0, 15) %>">
			<input type="hidden" class="form-control" id="txt_doccode" name="doccode" value="M838S100200" > 
			<input type="hidden" class="form-control" id="txt_rev_no" name="rev_no" value="<%= TableModel.getValueAt(0, 18) %>" > 
			<input type="hidden" class="form-control" id="txt_doc_gubun" name="doc_gubun"  value="<%= TableModel.getValueAt(0, 16) %>" > 
	   		<!-- ///////////////////////////////////////////////////////////////////////////////////  -->	
			<form id="update_form" enctype="multipart/form-data" action="<%= request.getContextPath() %>/hcp_EdmsServerServlet" method="post">
				<input type="file" id="idFilename" name="filenames" multiple="multiple" class="form-control" style="height: 0%;">
			</form>		
			<input type="text" id="attached_document" name="attached_document" value="<%= TableModel.getValueAt(0, 16) %>" class="form-control" disabled><i id="fileDelete" class="fas fa-times"></i>
		</td>
	</tr>
</table>
<table id="car_textarea" class="table">
		<tr>
		    <td style="width:25%">
		    	부적합 사항
		    </td>
		   <td>
		    	<textarea id="unsuit_detail" class="form-control"></textarea>
		    </td>
		</tr>
		<tr>
		    <td style="width:25%">
		    	개선조치 사항
		    </td>
		    <td>
		    	<textarea id="improve_action" class="form-control"></textarea>
		    </td>
		</tr>
		<tr>
		    <td style="width:25%">
		    	특기사항
		    </td>
		    <td>
		    	<textarea id="bigo" class="form-control"></textarea>
		    </td>
		</tr>
</table>