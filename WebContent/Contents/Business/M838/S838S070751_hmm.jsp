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
S838S020401.jsp
방충 방서 점검표 등록
*/
	String loginID = session.getAttribute("login_id").toString();
	
	String checklist_id = "", checklist_rev_no = "";
	
	if(request.getParameter("checklist_id") != null)
		checklist_id = request.getParameter("checklist_id");	

	if(request.getParameter("checklist_rev_no") != null)
		checklist_rev_no = request.getParameter("checklist_rev_no");
    
%>
<script type="text/javascript">
    $(document).ready(function () {
    	
    	new SetSingleDate2("", "#check_date", 0);
    	new SetSingleDate2("", "#judge_date", 0);

    	$("input:radio:input[value='O']").attr("checked",true);
    	$("input:radio:input[value='1']").attr("checked",true);
    	
    	$("select").change(function() {
    		
    		var type_id = $(this).val();
    		
    		$(this).closest("tr").next().children("td").children("select").val(type_id);
    		$(this).closest("tr").next().next().children("td").children("select").val(type_id);
    		$(this).closest("tr").next().next().next().children("td").children("select").val(type_id);
    		
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
		var chekrtn = confirm("등록하시겠습니까?");
		
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
		        data: {bomdata:obj, pid:"M838S020400E101"},
				success: function (html) {
					if(html > -1) {
						heneSwal.success('점검표 등록이 완료되었습니다');

						$('#modalReport').modal('hide');
		        		parent.fn_MainInfo_List(startDate, endDate);
		        		parent.fn_DetailInfo_List();
		         	} else {
						heneSwal.error('점검표 등록 실패했습니다, 다시 시도해주세요');
		         	}
		         }
			});
		} 
	}
</script>

<table class="table" style = "text-align: center; vertical-align: middle;">
	<thead>
		<tr>
			<td>
				검사일자
			</td>
			<td colspan = 2>
				<input type="text" data-date-format="yyyy-mm-dd" id="check_date" class="form-control">
			</td>
			<td></td>
			<td>
				판독일자
			</td>
			<td colspan = 2>
				<input type="text" data-date-format="yyyy-mm-dd" id="judge_date" class="form-control">
			</td>
		</tr>
	</thead>
	<tbody>
		<tr>
			<th colspan = 3>구분</th>
			<th colspan = 3>검사결과</th>
			<th rowspan = 2>평가</th>
		</tr>
		<tr>
			<th>항목</th>
			<th>검체명</th>
			<th>냉장/냉동</th>
			<th>일반세균</th>
			<th>대장균</th>
			<th>살모넬라</th>
		</tr>
	<% for(int i=0; i<12; i++) {
		
		String rowspan = " style = 'display : none;' ";
		
		if(i%4 == 0) { rowspan = "rowspan = 4"; }	
	%>
		<tr>
			<td <%= rowspan %> >
				<select name = "type_id_<%=i%>">
					<option>항목선택</option>
					<option value = "type01" >제품</option>
					<option value = "type02" >작업도구</option>
				</select>
			</td>
			<td>
				<input type = "text" name = "specimen_nm_<%=i%>" class="form-control"/>
			</td>
			<td>
				<input type = "radio" name = "status_gubun_<%=i%>" value = "1"/> 냉장
				<input type = "radio" name = "status_gubun_<%=i%>" value = "2"/> 냉동
			</td>
			<td>
				<input type = "text" name = "result1_<%=i%>" class="form-control"/>
			</td>
			<td>
				<input type = "text" name = "result2_<%=i%>" class="form-control"/>
			</td>
			<td>
				<input type = "radio" name = "result3_<%=i%>" value = "O"/> 검출
				<input type = "radio" name = "result3_<%=i%>" value = "X"/> 불검출
			</td>
			<td>
				<input type = "radio" name = "evaluation_<%=i%>" value = "O"/> 적합
				<input type = "radio" name = "evaluation_<%=i%>" value = "X"/> 부적합
			</td>
		</tr>
	<% } %>
	</tbody>
</table>