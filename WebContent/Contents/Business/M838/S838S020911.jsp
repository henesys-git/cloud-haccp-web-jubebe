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
S838S020911.jsp
제조시설 및 설비점검표 - 상세등록부분
*/
	String loginID = session.getAttribute("login_id").toString();
	
	String checklist_id = "", checklist_rev_no = "", regist_date = "";
	
	if(request.getParameter("checklist_id") != null)
		checklist_id = request.getParameter("checklist_id");	

	if(request.getParameter("checklist_rev_no") != null)
		checklist_rev_no = request.getParameter("checklist_rev_no");
	
	if(request.getParameter("regist_date") != null)
		regist_date = request.getParameter("regist_date");
	
%>
<style>
#test {
	position: absolute;
    top: 136.5px;
    right: 37px;
}
</style>    
    
<script type="text/javascript">
    $(document).ready(function () {
    	
		new SetSingleDate2("", "#check_date", 0);
		
		var cvs = new Image();

		cvs.onload = function() {
			
			var ctx = $("#myCanvas")[0].getContext("2d");
			ctx.drawImage(cvs, 0, 0);
			
		};
		cvs.src = "images/checklist_insert/checklist31_insert_update.jpg"
		
		// input radio
		for(var i=1; i<=21; i++){
			
			var mrbt = "18px";
			var quest = "question0";
			var type_id = "type01";
			var type_id_s = "type01_"+(i+1);
			
			if(i >= 3 && i <= 13){ mrbt = "15px";}
			else if( i >= 14){ mrbt = "12px"; }
			
			if(i > 11){ type_id = "type02"; type_id_s = "type02_"+(i-11);}
			if(i > 8) {  quest = "question"; }
			
			var html = "<div style = 'margin-bottom :"+mrbt+";'>"+
					   "<input type = 'hidden' name = 'question_id_"+(i+1)+"' value = '"+quest+(i+1)+"'/>"+
					   "<input type = 'hidden' name = 'type_id_"+(i+1)+"' value = '"+type_id+"'/>"+
					   "<input type = 'hidden' name = 'type_id_s_"+(i+1)+"' value = '"+type_id_s+"'/>"+
					   "<input type = 'radio' name = 'result_"+(i+1)+"' value = 'O'/> &nbsp; O &nbsp; "+
	 				   "<input type = 'radio' name = 'result_"+(i+1)+"' value = 'X' /> &nbsp;X "+
	 				   "</div>";
	 				   
	 		$("#test").append(html);
		}

		$("input:radio:input[value='O']").attr("checked",true);
		
    });	
	
	function SaveOderInfo() {
        var dataJson = new Object();
        
		dataJson.checklist_id = '<%=checklist_id%>';
		dataJson.checklist_rev_no = '<%=checklist_rev_no%>';
		dataJson.check_date = $("#check_date").val();
		dataJson.regist_date = '<%=regist_date%>';
	 	dataJson.form = $('#prodFac_frm').serializeArray();
	 	dataJson.person_write_id = '<%=loginID%>';
	 	
		var JSONparam = JSON.stringify(dataJson);
		var chekrtn = confirm("등록하시겠습니까?");
		
		if(chekrtn) {
			SendTojsp(JSONparam, "M838S020900E111");
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
					heneSwal.success('점검 기록 등록이 완료되었습니다');

					$('#modalReport').modal('hide');
	        		parent.fn_MainInfo_List(startDate, endDate);
	        		parent.$('#SubInfo_List_contents').hide();
	         	} else {
					heneSwal.error('점검 기록 등록 실패했습니다, 다시 시도해주세요');
	         	}
	         }
	     });
	}
</script>
 <form id = "prodFac_frm" onsubmit="return false;" style = "height : 900px;">
	<div align = "right" style = "margin-bottom : 7px;"> 
		점검일자 &nbsp;
		<input type="text" data-date-format="yyyy-mm-dd" id="check_date" class="form-control" style = "width:36%; display : inline-block;">
	</div>
	 <div style = "border : 2px gray" id = "test">
	 	<div class = "position"  style = 'margin-bottom : 20px;'>
	 		<input type = "hidden" name = "question_id_1" value = "question01"/>
	 		<input type = "hidden" name = "type_id_1" value = "type01"/> 
	 		<input type = "hidden" name = "type_id_s_1" value = "type01_1"/>  
	 		<input type = "radio" name = "result_1" value = 'O'/> &nbsp; O &nbsp;
	 		<input type = "radio" name = "result_1" value = 'X'/> &nbsp;X
	 	</div>
	 </div>
	 <div>
		<canvas id = "myCanvas" width = "571" height = "1000">
		</canvas>
	</div>
</form>