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
S838S020852.jsp
작업장 낙하세균 기록부 - 수정부분 
*/
	String loginID = session.getAttribute("login_id").toString();
	
	String checklist_id = "", checklist_rev_no = "";
	String check_date = "", judge_date = "";
	
	if(request.getParameter("checklist_id") != null)
		checklist_id = request.getParameter("checklist_id");	

	if(request.getParameter("checklist_rev_no") != null)
		checklist_rev_no = request.getParameter("checklist_rev_no");
		
	if(request.getParameter("check_date") != null)
		check_date = request.getParameter("check_date");
	
	if(request.getParameter("judge_date") != null)
		judge_date = request.getParameter("judge_date");
	
	JSONObject jArray = new JSONObject();
	jArray.put("check_date", check_date);	
	
	DoyosaeTableModel TableModel = new DoyosaeTableModel("M838S020850E154", jArray);
 	MakeGridData tData = new MakeGridData(TableModel);
%>
<style>
#colspan5 input {
	display : inline-block;
	width : 28%;
	margin : 0px 7px;
}
#colspan5 span {
	margin-left : 21%;
}
</style>  
<script type="text/javascript">
    $(document).ready(function () {
    	
    	var dataArr = <%=tData.getDataArray()%> 
    	
 		new SetSingleDate2("<%=check_date%>", "#check_date", 0);
		new SetSingleDate2(dataArr[0][1], "#judge_date", 0);
		
		$("#check_date").attr("disabled",true);
		
		var html;
		
		for(var a=0; a<dataArr.length; a++){
			var pls= "";
	 		
			if(dataArr[a][3] == "준청결구역"){
				
				dataArr[a][3] = "악";
			}
	 	
			html += "<tr>" +
					"<th class = 'type_id' align = 'center' "+ pls +" >" +
					"<input type='hidden' value = "+dataArr[a][2]+" name = 'type_id' />" +
					dataArr[a][3]+
					"</th>" +
					"<td>" +
					"<input type='text' class='form-control' name = 'LOCATION' value = "+dataArr[a][5]+">" +
					"</td>" +
					"<td>" +
					"<input type='text' class='form-control' name = 'result' value = "+dataArr[a][6]+">" +
					"</td>" +
					"<td>" +
					"<input type='text' class='form-control' name = 'evaluation'  value = "+dataArr[a][7]+">" +
					"</td>" +
					"<td>" +
					"<input type='text' class='form-control' name = 'bigo_detail' value = "+dataArr[a][8]+">" +
					"</td>" +
					"</tr>";
		}
	
		$("#germ_body").html(html);
		
		$(".type_id").each(function () {

			var rows = $(".type_id:contains(" +  $(this).text() + ")");
							
            if (rows.length > 1) {
                rows.eq(0).attr("rowspan", rows.length);
                rows.not(":eq(0)").hide();
            }
            
		 }); 

		var type02Html = "<input type='hidden' value = 'type02' name = 'type_id' /> 준청결구역";
		
		$("#germ_body input[value='type02']").closest("th").html(type02Html);
		
		var fileFrmShow = dataArr[0][11];
		
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
				 dataJson.seq_no = '<%=check_date%>';
				 var JSONparam = JSON.stringify(dataJson);
				
				 $.ajax({
				        type: "POST",
				        dataType: "json",
				        url: "<%=Config.this_SERVER_path%>/Contents/CommonView/insert_update_delete_json.jsp", 
				        data:  {"bomdata" : JSONparam, "pid" : "M838S020850E113"},
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
        var dataJson = new Object();
        
 		dataJson.checklist_id = '<%=checklist_id%>';
 	 	dataJson.check_date = $('#check_date').val();
 	 	dataJson.judge_date = $('#judge_date').val();
		//dataJson.form = getFormData($("#germ_frm"));
		dataJson.form = $("#germ_frm").serializeArray();
		//return false;
	 	
		var JSONparam = JSON.stringify(dataJson);
		var chekrtn = confirm("수정하시겠습니까?");
		
		if(chekrtn) {
			SendTojsp(JSONparam, "M838S020850E102");
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
		                data.append("seq_no", '<%=check_date%>'); 		
	
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
					heneSwal.error('기록부 수정 실패했습니다, 다시 시도해주세요');
	         	}
	         }
	     });
	}
</script>
<form id = "germ_frm"  onSubmit = "return false;"> 
	<table class="table" id="germ_table">
		<tr>
			<td colspan = "5" id = "colspan5">
				검사일자
				<input type="text" data-date-format="yyyy-mm-dd" id="check_date" min = "<%= check_date %>" class="form-control">
				<span>판독일자</span>
				<input type="text" data-date-format="yyyy-mm-dd" id="judge_date" min = "<%= judge_date %>" class="form-control">
			</td>
		</tr>
		<tr>
			<th>구분</th>
			<th>
				위치
			</th>
		    <th>
				낙하세균 결과
			</th>
			<th>
				낙하세균 평가
			</th>
		    <th>
				비고
			</th>
		</tr>
		<tbody id = "germ_body"></tbody>
	</table>
</form> 
<table class = "table">
	<tr>
		<td style = "width: 10.5%;">
			첨부파일
		</td>    
	    <td>
			<input type="hidden" class="form-control" id="txt_pid" name="pid"  value="M838S020850E112"> 
			<input type="hidden" class="form-control" id="txt_user_id" name="user_id"  value="henesys"> 
			<input type="hidden" class="form-control" id="txt_orderno" name="orderno" value="0" > 
			<input type="hidden" class="form-control" id="txt_order_detail" name="order_detail" value="1" > 
			<input type="hidden" class="form-control" id="txt_jspPage" name="jspPage"  value="M838S020852.jsp"> 
			<input type="hidden" class="form-control" id="txt_getnum_prefix" name="getnum_prefix"  value="수정시 prefix 필요 없음"> 
			<input type="hidden" class="form-control" id="txt_JobType" name="JobType" value="UPDATE" >
			<input type="hidden" class="form-control" id="txt_docname" name="docname" value="<%= TableModel.getValueAt(0, 10) %>">
			<input type="hidden" class="form-control" id="txt_regist_no" name="regist_no" value="<%= TableModel.getValueAt(0, 9) %>">
			<input type="hidden" class="form-control" id="txt_doccode" name="doccode" value = "M838S020850" > 
			<input type="hidden" class="form-control" id="txt_rev_no" name="rev_no" value = "<%= TableModel.getValueAt(0, 12) %>" > 
			<input type="hidden" class="form-control" id="txt_doc_gubun" name="doc_gubun"  value="<%= TableModel.getValueAt(0, 10) %>" > 
	    <!-- ///////////////////////////////////////////////////////////////////////////////////  -->	
			<form id="update_form" enctype="multipart/form-data" action="<%= request.getContextPath() %>/hcp_EdmsServerServlet" method="post">
				<input type="file" id="idFilename" name="filenames" multiple="multiple" class="form-control" style = "height: 0%;">
			</form>		
			<input type="text" id="attached_document" name = "attached_document" value = "<%= TableModel.getValueAt(0, 10) %>" class="form-control" disabled>
			<i id = "fileDelete" class="fas fa-times" style= "left:47.2%;"></i>
		</td>
	</tr>
</table>