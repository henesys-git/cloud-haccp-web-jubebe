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
S838S020102.jsp
일일위생점검일지 수정
*/
	String loginID = session.getAttribute("login_id").toString();
	
	String checklist_id = "", checklist_rev_no = "", check_date = "";
	
	if(request.getParameter("checklist_id") != null)
		checklist_id = request.getParameter("checklist_id");	

	if(request.getParameter("checklist_rev_no") != null)
		checklist_rev_no = request.getParameter("checklist_rev_no");
	
	if(request.getParameter("check_date") != null)
		check_date = request.getParameter("check_date");
	
	JSONObject jArray = new JSONObject();
	
 	jArray.put("check_date", check_date);
	
 	// 항목별 질문 ID
    DoyosaeTableModel table = new DoyosaeTableModel("M838S020100E114", jArray);
    MakeGridData questions = new MakeGridData(table);
	
    // 점검항목 결과
    DoyosaeTableModel table2 = new DoyosaeTableModel("M838S020100E144", jArray);
    
    // 결과 LIST
    String result = table2.getStrValueAt(0,5);
    result = result.substring(1, result.length()-1);
	
    List<String> list = new ArrayList<String>(Arrays.asList(result.split(",")));
    
    String jsonStr = JSONArray.toJSONString(list);
%>
<style>
#check_date {
	position: relative;
	left: 539.5px;
    bottom: 1042px;
    width: 193px;
    height: 81.49px;
    font-size: 24px;
    text-align: center;
}

#check_result {
    position: relative;
    bottom: 1039px;
    left: 542px;
}

#check_result label {
	margin: 0 30px;
    font-weight: normal;
    font-size: 18px;
}

@media screen and (max-height : 699px) {
    #check_result label {
	  	margin-bottom: 3.15px;
	}
}

@media screen and (min-height : 700px) {
    #check_result label {
	  	margin-bottom: 2.8px;
	}
}

#check_detail textarea {
	width: 300px;
    height: 70.3px;
    display: inline-block;
}

#check_result input {
	margin-right : 12px;
}

#check_detail {
	position: relative;
    bottom: 988px;
}
</style>
<script type="text/javascript">
    $(document).ready(function () {

    	new SetSingleDate2('<%=check_date%>', "#check_date", 0);
		
    	// results
    	var results = <%= jsonStr %>;
    	var questions = <%= questions.getDataArray() %>;
    	
    	for(idx in questions) {
    		$("input:radio[name='"+questions[idx][0]+"_"+questions[idx][1]+"']:input[value='"+results[idx].trim()+"']").attr("checked",true);
    	}
    	
		// 부적합 사항
		$('#unsuit_detail').val('<%=table2.getStrValueAt(0,6)%>');
		// 개선조치사항
		$('#improve_action').val('<%=table2.getStrValueAt(0,7)%>');
		
    });
    
	function getFormData(form) {
		
	    var array = form.serializeArray();
	
	    for (x in array) {
	    	var check_type_id = array[x].name.slice(0, 6);
	    	var check_detail_id =  array[x].name.slice(7);
	    	array[x].check_type_id = check_type_id;
	    	array[x].check_detail_id = check_detail_id;
	    }	   
	    	
	    return array;
	}
	
	function sendToJsp() {
		var chekrtn = confirm("등록하시겠습니까?");
		
		if(chekrtn) {
			var obj = new Object();
			
			obj.checklist_id = '<%=checklist_id%>';
			obj.checklist_rev_no = '<%=checklist_rev_no%>';
			obj.check_date = $('#check_date').val();
			obj.unsuit_detail = $('#unsuit_detail').val();
			obj.improve_action = $('#improve_action').val();
			obj.form = getFormData($('#form1'));
			obj.person_write_id = "<%=loginID%>";
			
			obj = JSON.stringify(obj);
			
			$.ajax({
		        type: "post",
		        url: "<%=Config.this_SERVER_path%>/Contents/CommonView/insert_update_delete_json.jsp", 
		        data: {bomdata:obj, pid:"M838S020100E102"},
				success: function (html) {
					if(html > -1) {
						heneSwal.success('점검표 수정이 완료되었습니다');

						$('#modalReport').modal('hide');
		        		parent.fn_MainInfo_List(startDate, endDate);
		        		parent.$('#SubInfo_List_contents').hide();
		         	} else {
						heneSwal.error('점검표 수정 실패했습니다, 다시 시도해주세요');
		         	}
		         }
			});
		}
	}
</script>

<div class="container">
	<img src="images/checklist_insert/checklist06_insert_update.jpg" style="width:734px; height: 1043px;">
	<input id = "check_date" type = "text" data-data-format="yyyy-mm-dd"/>
	<form id = "form1" onsubmit="return false;" style = "height: 0px;">
		<div id = 'check_result'>
			<% for(int i=0; i<table.getRowCount(); i++){ %>
				<label><input type = "radio" name = "<%=table.getValueAt(i, 0)%>_<%=table.getValueAt(i, 1)%>" value = "O"/>O</label><label><input type = "radio" name = '<%=table.getValueAt(i, 0)%>_<%=table.getValueAt(i, 1)%>' value = "X"/>X</label><br>
			<% } %>
		</div>
		<div id = 'check_detail'>
			<textarea id = "unsuit_detail" class="form-control" style = "margin-left: 67px;"></textarea>
			<textarea id = "improve_action" class="form-control" style = "margin-left: 62px;"></textarea>
		</div>
	</form>	
</div>