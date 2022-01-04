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
S838S080300_edu_person_list.jsp
교육/훈련 기록부 참여자 명단
*/

	String date = "";
	
	String edu_person_list = "";
	String val = "";

	if(request.getParameter("date") != null)
		date = request.getParameter("date");
	
	if(request.getParameter("edu_person_list") != null)
		edu_person_list = request.getParameter("edu_person_list");
	
	if(request.getParameter("val") != null)
		val = request.getParameter("val");

	JSONObject jArray = new JSONObject();
	
 	jArray.put("date", date);

 	// user 정보 가져오기
	DoyosaeTableModel TableModel = new DoyosaeTableModel("M838S080300E124", jArray);
	MakeGridData makeGridData = new MakeGridData(TableModel);
	makeGridData.htmlTable_ID = "TableS838S080320";
%>
<style>
#modalReport2 {
	position : absolute;
	left : -35%;
	font-family: sans-serif;
	font-weight: 600;
	text-align: center;
}

#TableS838S080320_length {
	display : none;
}

</style>
<script type="text/javascript">
    $(document).ready(function () {
        	
		var htmlTable_ID_modal2 = '<%=makeGridData.htmlTable_ID%>';
    	
    	var dataArr_modal2 = <%=makeGridData.getDataArray()%>;
    	
    	dataArr_modal2.map(function (arr) {
    		arr.splice(0, 1, '<input type = "checkbox" class = "user_id" value = "'+arr[1]+'" />');
    	})
    	
    	var customOpts_modal2 = {
				data : dataArr_modal2,
				columnDefs : [{
					'targets': [1, 2, 4, 5, 6],
					'createdCell': function (td) {
			  			$(td).attr('style', 'display: none;'); 
					}
				}],
				pageLength: 10
		}
		
		var table_modal2 = $('#<%=makeGridData.htmlTable_ID%>').DataTable(
			mergeOptions(heneMainTableOpts, customOpts_modal2)
		);
    	
    	setTimeout(function(){table_modal2.columns.adjust().draw();},200);
    	
    	//////////////////////
    	var edu_person_list = "<%= edu_person_list %>";
    	
    	if(edu_person_list != ""){
    		
    		var listArr = edu_person_list.split(",");
        	
    		$(".user_id").each(function() {
    			
    			for(x in listArr){
    				
    				if($(this).val().trim() == listArr[x].trim()){
        				
        				$(this).prop("checked", true);
        				
        			}
    				
    			}
    			
    		});
    		
    	}
    	
    	var val = '<%= val %>';
    	
    	if(val != 2){
    		
        	$(".user_id").click(function() {
        		
    		   if($('input:checkbox[class=user_id]:checked').length == $(".user_id").length){ 
    		   
    			   $('#all_btn').prop("checked",true); 
    		    
    		   } else { 
    		       
    			   $('#all_btn').prop("checked",false); 
    		    
    		   } 
       		
        	});
        	
    	} else if(val == 2){
    		      		
        	$(".user_id").click(function() {
        		
        		$('input:checkbox[class=user_id]').prop("checked", false);
        		$(this).prop("checked", true);
        		
        	});
    		
        	$("#all_btn").attr("disabled", true);

    	}

    });	
    
    function allPush() {
    	
    	if(!$("input:checkbox[id = 'all_btn']").is(":checked")){
    		
    		$("input:checkbox").prop("checked", false);	
    		
    	} else {
    		
    		$("input:checkbox").prop("checked", true);
    	}
    	
    }
    
    function addList() {
    	
    	var attend_IDlist = new Array();
    	var attend_NAMElist = new Array();
    	
    	$(".user_id").each(function() {
    		
    		if($(this).prop("checked")){
    			
    			attend_IDlist.push($(this).val());	
    			attend_NAMElist.push($(this).closest("td").next().next().next().text());
    		}
    		
    	});

    	$('#modalReport2').modal("hide");
    	
		if(attend_IDlist.length != 0){
			
			if(attend_NAMElist.length > 5){
				
				attend_NAMElist.splice(5, attend_NAMElist.length-1);
				
				attend_NAMElist = attend_NAMElist + " 외";
			}
			
			$("#edu_person_list").val(attend_NAMElist);
			$("input[name='edu_person_list']").val(attend_IDlist);
			
		}
		
    }
    
    function addCheckup() {
    	
		$(".user_id").each(function() {
    		
    		if($(this).prop("checked")){
    			$("#checkup_id").val($(this).val());
    			$("#checkup_nm").val($(this).closest("td").next().next().next().text());
    		}
    		
    	});
		
		$('#modalReport2').modal("hide");
    	
    }
</script>

<table class='table table-bordered nowrap table-hover' 
		  id="<%=makeGridData.htmlTable_ID%>" style="width:100%">
	<thead>
		<tr>
		     <th id = "all_check">
		     	<input type = "checkbox" id = "all_btn" onclick = "allPush();"/>
		     </th>
		     <th style='width:0px; display:none;'>유저아이디</th>
		     <th style='width:0px; display:none;'>수정번호</th>
		     <th>성명</th>
			 <th style='width:0px; display:none;'>그룹코드</th>
			 <th style='width:0px; display:none;'>부서코드</th>
			 <th style='width:0px; display:none;'>직위</th>
		</tr>
	</thead>
	<tbody id="<%=makeGridData.htmlTable_ID%>_body">
	</tbody>
</table>

<div id="UserList_pager" class="text-center">
</div>