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
S838S020551.jsp
조도 점검표
*/
	String loginID = session.getAttribute("login_id").toString();
	
	String checklist_id = "", checklist_rev_no = "";
	
	if(request.getParameter("checklist_id") != null)
		checklist_id = request.getParameter("checklist_id");	

	if(request.getParameter("checklist_rev_no") != null)
		checklist_rev_no = request.getParameter("checklist_rev_no");
	
	JSONObject jArray = new JSONObject();
	jArray.put("checklist_id", checklist_id);
	jArray.put("checklist_rev_no", checklist_rev_no);
	
    DoyosaeTableModel TableModel = new DoyosaeTableModel("M838S020550E114", jArray);
 	MakeGridData tData = new MakeGridData(TableModel);
    tData.htmlTable_ID = "TableS838S020550";
	
%>
<style>
#illu_table td, #illu_table th {
	vertical-align:middle !important;
	text-align: center;
}

.judge label {
	font-weight: normal !important;
	margin-bottom: 0;
}

.judge {
	text-align: left !important;
	padding : 0px;
	width : 13%;
}

.judge label:first-child input {
	 margin-left : 15.75px; 
}

.judge label:nth-child(2) input {
	 margin-left : 2px; 
}
</style>
<script type="text/javascript">
    $(document).ready(function () {
    	
    	var data = <%= tData.getDataArray() %>;
    	
		new SetSingleDate2("", "#check_date", 0);
		
		var html;
		
		for(var i=0; i<data.length; i++){
			
			var place_datail = data[i][4];
			var place_datail_s = "";
			var rowspan = "rowspan = '2'";
			var colspan = "colspan = '2'";
			var pArr = place_datail.split(",");
			var LUX = "220LUX";
			
			if(pArr.length == 2){
				
				colspan = "";
				
				place_detail = pArr[0];
				place_datail_s = "<td>" + pArr[1]+"</td>";				
			}
			
			if(data[i][3] == "place05"){ LUX = "540LUX"; }
			else if(data[i][3] == "place07" || data[i][3] == "place13" || data[i][3] == "place14") { LUX = "75LUX"; }
			
			if(data[i][2].length == 6){
				data[i][2] = data[i][2].substr(0,3) + "<br>" + data[i][2].substr(3,3); 
			} else if(data[i][2].length == 5){
				data[i][2] = data[i][2].substr(0,2) + "<br>" + data[i][2].substr(2,3);
			}
			
			html = "<tr> " +
				   "<th>"+data[i][2]+
				   "<input type = 'hidden' name = 'type_id_"+i+"' value = '"+data[i][0]+"'/> "+
				   "<input type = 'hidden' name = 'type_rev_no_"+i+"' value = '"+data[i][1]+"'/> "+
				   "</th>"+
				   "<td "+colspan+">"+pArr[0]+	
				   "<input type = 'hidden' name = 'place_id_"+i+"' value = '"+data[i][3]+"'/> </td> "+
				    place_datail_s+
				   "<td>"+LUX+"</td>"+
				   "<td class='result'> <input type = 'text'  name = 'result_"+i+"' required /> </td>"+
				   "<td class='judge'> <label> 적합 <input type = 'radio'  value = 'Y' name = 'judge_"+i+"' required /> </label> " +
				   "<label> 부적합 <input type = 'radio'  value = 'N' name = 'judge_"+i+"' required /> </label> </td>"+
				   "</tr>";

			$("#illu_body").append(html);
		}
		
		$('input:radio:input[value="Y"]').attr("checked", true);
		
		$("#illu_body th").each(function () {

			var rows = $("#illu_body th:contains(" +  $(this).text() + ")");
							
	            if (rows.length > 1) {
	                rows.eq(0).attr("rowspan", rows.length);
	                rows.not(":eq(0)").hide();
	            }
		 }); 
		
    });	
		
	function SaveOderInfo() {

		var flag = true;
		
		$("input[name^='result_']").each(function() {
			
			if($(this).val() == "" || $(this).val() == null){
				
				heneSwal.warning('빈 칸을 모두 입력해주세요.');
				$(this).focus();
			
				flag = false;
				
				return false;
			}
			
		})
		
		if(flag){
			
			var dataArr = $("#illu_frm").serializeArray();
		 	
	        var dataJson = new Object();
	        
			dataJson.checklist_id = '<%=checklist_id%>';
			dataJson.checklist_rev_no = '<%=checklist_rev_no%>';
		 	dataJson.check_date = $('#check_date').val();
		 	dataJson.person_write_id = '<%=loginID%>';
		 	dataJson.form = dataArr;
		 	
			var JSONparam = JSON.stringify(dataJson);
			var chekrtn = confirm("등록하시겠습니까?");
			
			if(chekrtn) {
				SendTojsp(JSONparam, "M838S020550E101");
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
					heneSwal.success('점검표 등록이 완료되었습니다');

					$('#modalReport').modal('hide');
	        		parent.fn_MainInfo_List(startDate, endDate);
	        		parent.$('#SubInfo_List_contents').hide();
	         	} else {
					heneSwal.error('점검표 등록 실패했습니다, 다시 시도해주세요');
	         	}
	         }
	     });
	}
</script>
<form id = "illu_frm" onsubmit="return false;">
	<table class="table" id="illu_table">
		<thead>
		<tr>
			<td colspan = "3"></td>
			<td>
				점검일시
			</td>
		    <td colspan = "2">
				<input type="text" data-date-format="yyyy-mm-dd" id="check_date" class="form-control">
			</td>
		</tr>
		</thead>
		<tbody id = "illu_body">
			<tr>
				<th style='width: 12%;'>작업장명</th>
				<th colspan = "2" style='width: 36%;'>작업장 구분</th>
				<th style='width: 12%;'>조도기준</th>
				<th>점검결과</th>
				<th>판정</th>
			</tr>
		</tbody>
	</table>
</form>