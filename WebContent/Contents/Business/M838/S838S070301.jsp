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
S838S070301.jsp
검·교정 기록부
*/
	String loginID = session.getAttribute("login_id").toString();
	
	String checklist_id = "";
	
	if(request.getParameter("checklist_id") != null)
		checklist_id = request.getParameter("checklist_id");	
	
	JSONObject jArray = new JSONObject();
	
    DoyosaeTableModel TableModel = new DoyosaeTableModel("M838S070300E154", jArray);
 	MakeGridData tData = new MakeGridData(TableModel);
%>
<style>
#illu_table, .modal-body{
    margin-bottom: 0;
}

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

#illu_body .temp {
 	text-align: center;
    width: 57%;

}
</style>
<script type="text/javascript">
    $(document).ready(function () {
    	
		new SetSingleDate2("", "#check_date", 0);
		
		var data = <%= tData.getDataArray() %>;
		
		var html;
		for(var i=0; i<data.length; i++){
			
			html = "<tr> " +
				   "<th>"+data[i][0]+"</th>"+
				   "<td>"+data[i][2]+
				   "<input type = 'hidden' name = 'facility_id_"+i+"' value = '"+data[i][1]+"'/> "+
				   "</td>"+
				   "<td>"+data[i][4]+
				   "<input type = 'hidden' name = 'place_id_"+i+"' value = '"+data[i][3]+"'/> "+
				   "</td>"+
				   "<td>"+'<div class="input-group">'+
								'<input type = "number" name = "standard_value_'+i+'" class = "standard_temp temp"/>'+
								'<div class="input-group-append">'+
								     '<span class="input-group-text">&#8451;</span>'+
						        '</div>'+
						   '</div>'+
				   "</td>"+
				   "<td>"+'<div class="input-group">'+
				   				"<input type = 'number' name = 'check_value_"+i+"' class = 'temp'/> "+
								'<div class="input-group-append">'+
								     '<span class="input-group-text">&#8451;</span>'+
						        '</div>'+
						   '</div>'+
				   "</td>"+
				   "<td>"+"<input type = 'text' class = 'stdev_temp' id = 'stdev_temp_"+i+"' style = 'width: 100%;text-align: center;' disabled/> "+"</td>"+
				   "<td class='judge'> <label> 적합 <input type = 'radio' value = 'Y' name = 'judge_"+i+"' onclick='return false;' /> </label> " +
				   "<label> 부적합 <input type = 'radio'  value = 'N' name = 'judge_"+i+"' onclick='return false;' /> </label> </td>"+
				   "<td>"+"<input type = 'text' name = 'improve_action_"+i+"' style= 'width: 100%;' /> "+"</td>"+
				   "</tr>";

			$("#illu_body").append(html);
		}
		
		$('input:radio:input[value="Y"]').attr("checked", true);
		
		$(".temp").keyup(function() {
		
			var name = $(this).attr("name");
			var seq = name.split("_")[2];
			
			if(name.substr(0,5) == "check"){
				var result = $(this).val();
				var standard_temp = $("input[name='standard_value_"+seq+"']").val();
			} else {
				var standard_temp = $(this).val();
				var result =  $("input[name='check_value_"+seq+"']").val();				 
			}
			
			var stdev_temp = result - standard_temp;	
			$("#stdev_temp_"+seq).val(stdev_temp.toFixed(2));// 편차 값 입력(.toFixed(2) | 소숫점 둘째자리까지)
			
			var judgeInt = Math.abs(stdev_temp);
			
			if(judgeInt > 1){
				$("input:radio[name$='"+seq+"'][value='N']").prop("checked", true);
			} else {
				$("input:radio[name$='"+seq+"'][value='Y']").prop("checked", true);
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
    
	function SaveOderInfo() {

		var flag = true;
		
		$(".temp").each(function() {
			
			if($(this).val() == "" || $(this).val() == null){
				
				heneSwal.warning('빈 칸을 모두 입력해주세요.');
				$(this).focus();
			
				flag = false;
				return false;
			}
			
		})
		
		if(flag){
			
	        var dataJson = new Object();
	        
		 	dataJson.checklist_id = '<%=checklist_id%>';
		 	dataJson.check_date = $('#check_date').val();
		 	dataJson.person_write_id = '<%=loginID%>';
		 	dataJson.form = serializeObject($("#illu_frm"));
		 	
			var JSONparam = JSON.stringify(dataJson);
			var chekrtn = confirm("등록하시겠습니까?");
			
			if(chekrtn) {
				SendTojsp(JSONparam, "M838S070300E101");
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
					parent.fn_MainInfo_List();
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
			<td colspan = "4"></td>
			<td>
				점검일시
			</td>
		    <td colspan = "3">
				<input type="text" data-date-format="yyyy-mm-dd" id="check_date" class="form-control">
			</td>
		</tr>
		</thead>
		<tbody id = "illu_body">
			<tr>
				<th rowspan = 2>NO</th>
				<th rowspan = 2 style="width: 10%;">설비명</th>
				<th rowspan = 2 style="width: 14%;">사용장소</th>
				<th colspan = 2>온도</th>
				<th rowspan = 2 style="width: 10%;">편차</th>
				<th rowspan = 2>판정</th>
				<th rowspan = 2>개선조치</th>
			</tr>
			<tr>
				<th>표준값</th>
				<th>검사값</th>
			</tr>
		</tbody>
	</table>
</form>