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
S838S020402.jsp
방충 방서 점검표 수정
*/
	String loginID = session.getAttribute("login_id").toString();
	
	String checklist_id = "", checklist_rev_no = "", regist_date = "";
	
	if(request.getParameter("checklist_id") != null)
		checklist_id = request.getParameter("checklist_id");	

	if(request.getParameter("checklist_rev_no") != null)
		checklist_rev_no = request.getParameter("checklist_rev_no");
	
	if(request.getParameter("regist_date") != null)
		regist_date = request.getParameter("regist_date");
	
	JSONObject jArray = new JSONObject();
	
 	jArray.put("regist_date", regist_date);
	
	DoyosaeTableModel TableModel = new DoyosaeTableModel("M838S020400E144", jArray);
	MakeGridData makeGridData = new MakeGridData(TableModel);
    
%>
<style>
#regist_date {
	position: relative;
    bottom: 1053px;
    left: 514px;
    width: 219px;
    height: 74px;
    font-size: 24px;
    text-align: center;
}

#form1 {
	width: 530px;
	position:relative;
    bottom: 975px;
	left: 208px;
}

#insect_result2 {
    position: relative;
	right: 103.5px;
    width: 630px;
}

.result {
	width: 43.84px;
	height : 59.5px;
}

.position {
	width: 103.5px;
    height: 59.5px;
    margin-right: 438.3px;
    text-align: center;
}

#others {
	position:absolute;
	top: 921px;
}

#others input {
	height:37px;
}
</style>
<script type="text/javascript">
    $(document).ready(function () {
    	
    	new SetSingleDate2("<%=regist_date%>", "#regist_date", 0);
    	
    	var dataArr = <%= makeGridData.getDataArray() %>;

    	// result
    	var resultArr = dataArr[0][3].slice(1, -1).split(",");
    	var positionArr = dataArr[0][4].slice(1, -1).split(",");
    	
    	var cnt = 0;
		for(var i=1; i<=6; i++){
			
			for(var j=1; j<=12; j++){
				
				var dis = "";
				
				if(j==6 || j==10 || j==12){
					
					dis = "disabled";	
				}
				
				var html = '<input type = "number" min = "0" name = "result_0'+i+'_'+j+'" class = "result" '+dis+' value = "'+resultArr[cnt].toString().trim()+'"/>';
				
				if(j==12) html += '<br>';
				
				$("#insect_result").append(html);
				
				cnt++;
			}
			
		}
 
		var cnt2 = 72, p=0;
		for(var a=7; a<=10; a++){
						
			if(a<10) a = "0"+a;
			
			var html = '<input type = "text" id = "facility'+a+'_position" class = "position" value = "'+positionArr[p]+'" /><input type = "number" min = "0" name = "result_'+a+'_11" class = "result" value = "'+resultArr[cnt2].toString().trim()+'"/><input type = "number" name = "result_'+a+'_12" class = "result" value = "'+resultArr[++cnt2].toString().trim()+'" disabled/><br>';
			
			$("#insect_result2").append(html);

			cnt2++;
			p++;
						
		}

		//detail
		var detailArr = dataArr[0][5].slice(1, -1).split(",");
		
		$("#others input").each(function(idx) {
			
			$(this).val(detailArr[idx]);
			
		});
		
		// 자동계산
		$(".result").keyup(function() {
    		
    		var name = $(this).attr("name");
    		var val = 0;
    		
    		// 설비id, 해충id
    		var facId = name.slice(7,9);
    		var insId = name.slice(10);
    		
    		var min = 0, max = 0;
    		if(parseInt(insId) < 6){
    			min = 1, max = 6; 
    		} else if(parseInt(insId) > 6 && parseInt(insId) < 10){
    			min = 7, max = 10;
    		} else if(parseInt(insId) == 11){
    			min = 11, max = 12;
    		}
    		
    		for(let i = min; i< max; i++){
				
    			var strVal = $("input[name = 'result_"+facId+"_"+i+"']").val();
    			
    			if(strVal == "" || strVal == null){
    				
    				strVal = "0";
    				$("input[name = 'result_"+facId+"_"+i+"']").val("0");
    			}
    			
				val += parseInt(strVal);
			}
			
			$("input[name = 'result_"+facId+"_"+max+"']").val(val);
    		
    	});

    });
	
	function getFormData(form) {
		
	    var array = form.serializeArray();

	    for(var i=0; i<array.length; i++){
	    	
	    	if(array[i].value == ""){
	    		array.splice(i, 1);
	    		i--;
	    	} else {
		    	if(array[i].name.slice(-1) == "6" || array[i].name.slice(-2) == "10" || array[i].name.slice(-2) == "12"){
		    		array.splice(i, 1);
		    		i--;
		    	}
		    }
	    }
	    
	    if(array.length == 0){
	    	return false;
	    }
	    
	    if(array[0].name.slice(0,6) == "result"){
	    
		    for (x in array) {
		    	
		    	var facility_name = array[x].name.slice(7, 9);
		    	var insect_name = array[x].name.slice(-1);
		    	
		    	var nameLen = array[x].name.length;
		    	
		    	if(nameLen > 11){		    		
		    		
		    		insect_name = array[x].name.slice(-2);
		    				    		
		    	}
		    		
		    	switch (insect_name) {
				case "7":	
					insect_name = "6"
					break;

				case "8":
					insect_name = "7"
					break;
					
				case "9":
					insect_name = "8"
					break;
					
				case "11":
					insect_name = "9"
					break;
				}

	    		var facility_id = "facility"+facility_name;
		    	var insect_id =  "insect0"+insect_name;
		    	array[x].facility_id = facility_id;
		    	array[x].insect_id = insect_id;	
			    
		    }	    
	    	
	    }
	    return array;
	}
	
	function sendToJsp() {
		var chekrtn = confirm("수정하시겠습니까?");
		
		if(chekrtn) {
			var obj = new Object();
			
			obj.person_write_id = "<%=loginID%>";
			obj.checklist_id = '<%=checklist_id%>';
			obj.checklist_rev_no = '<%=checklist_rev_no%>';
			obj.regist_date = $('#regist_date').val();
			obj.result = getFormData($('#form1'));
			obj.detail = getFormData($('#form2'));
			
			var positionArr = new Array();
			$(".position").each(function() {
				
				if( $(this).val() != null || $(this).val() != "" ){
					
					positionArr.push($(this).val());
					
				}
				
			});

			obj.position = positionArr;
			
			obj = JSON.stringify(obj);
			
			$.ajax({
		        type: "post",
		        url: "<%=Config.this_SERVER_path%>/Contents/CommonView/insert_update_delete_json.jsp", 
		        data: {bomdata:obj, pid:"M838S020400E102"},
				success: function (html) {
					if(html > -1) {
						heneSwal.success('점검표 수정이 완료되었습니다');

						$('#modalReport').modal('hide');
		        		parent.fn_MainInfo_List(startDate, endDate);
		        		parent.fn_DetailInfo_List();
		         	} else {
						heneSwal.error('점검표 수정을 실패했습니다, 다시 시도해주세요');
		         	}
		         }
			});
		} 
	}
</script>

<div class="container" style="height: 1053.5px;">
	<img src="images/checklist_insert/checklist09_insert_update.jpg" style="width: 735px;height: 1054px;">
	<input id = "regist_date" type = "text" data-data-format="yyyy-mm-dd"/>
	<form id = "form1" onsubmit="return false;">
		<div id = 'insect_result'></div>
		<div id = 'insect_result2'></div>
	</form>	
	<form id = "form2" onsubmit="return false;">
		<div id = 'others'>
		<% 
		for(int l=0; l<4; l++){
		%>
			<input type ="text" name = 'detail_<%=l%>_1' style = "width:164px;margin-left: 1px;"/><input type ="text" name = 'detail_<%=l%>_2' style = "width:218px;"/><input type ="text"  name = 'detail_<%=l%>_3' style = "width:152px;"  /><input type ="text"  name = 'detail_<%=l%>_4' style = "width:198px;"  />
		<% } %>
		</div>
	</form>
</div>