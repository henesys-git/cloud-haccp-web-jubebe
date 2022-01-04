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
S838S020202.jsp
자동 기록관리 시스템 점검일지 수정
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
	
 	// 항목별 질문 데이터
    DoyosaeTableModel table = new DoyosaeTableModel("M838S020200E114", jArray);
    MakeGridData questions = new MakeGridData(table);
	
    // 항목별 Y,N 데이터 및 기타
    DoyosaeTableModel table2 = new DoyosaeTableModel("M838S020200E154", jArray);
    
    String result = table2.getStrValueAt(0,1);	// 항목별 Y,N값 배열
    result = result.substring(1, result.length()-1);	// 처음과 끝의 [ ] 제거
    
    List<String> list = new ArrayList<String>(Arrays.asList(result.split(",")));
    
    String jsonStr = JSONArray.toJSONString(list);
%>
    
<script type="text/javascript">
    $(document).ready(function () {
    	// 항목별 질문 데이터
    	var questions = <%=questions.getDataArray()%>;
		questions = setQuestions(questions);
		
		// 항목별 Y or N 값
    	var radioValue = <%=jsonStr%>;
		
    	console.log(radioValue[5]);
    	
    	// 마지막 2개의 값은 온도값이라서 따로 저장
    	var temperature2 = radioValue.pop();
		var temperature1 = radioValue.pop();
		
		// DB에서 받아온 Y,N 기준으로 초기 라디오 버튼 위치 세팅
		var idx = 0;
		for (x in radioValue) {
			var yn = radioValue[x].trim();
			
			
			if(yn == 'Y') {
				$('.form-check-input')[idx].checked = true;
			} else {
				$('.form-check-input')[idx+1].checked = true;
			}
			
			idx += 2;
		}
		
		// 항목별 질문들 표시
		for(var i = 0; i < questions.length; i++) {
			var id = questions[i][0];
			var category = questions[i][1];
			var subs = questions[i][2];
			
			$('#' + id).text(category);
			
			for(var j = 1; j <= subs.length; j++) {
				var sub_questions = subs[j-1];
				$('#' + id + "_" + j).text(sub_questions);
			}
		}
		
		// 부적합 사항
		$('#unsuit_detail').val('<%=table2.getStrValueAt(0,2)%>');
		// 개선조치사항
		$('#improve_action').val('<%=table2.getStrValueAt(0,3)%>');
		
		new SetSingleDate2('<%=check_date%>', "#check_date", 0);
		
		$('#personWriteId').val('<%=loginID%>');
    });
	
    function setQuestions(questions) {
    	var outerArr = new Array();
    	
    	for (i in questions) {
	    	var arr = new Array();
	    	
	    	var key = questions[i][1];
	    	var category = questions[i][0];
	    	var subs = questions[i][2].slice(1, -1).split(",");
	    	
	    	for (x in subs) {
	    		subs[x] = subs[x].replaceAll("comma", ",");
	    	}
	    	
			arr.push(key);
			arr.push(category);	
			arr.push(subs);
			
			outerArr.push(arr);
    	}
    	
    	return outerArr;
    }
    
	function getFormData(form) {
	    var array = form.serializeArray();

	    for (x in array) {
	    	var check_type = array[x].name.slice(0, -2);
	    	array[x].check_type = check_type;
	    }
		
	    return array;
	}
	
	function sendToJsp() {
		var chekrtn = confirm("수정하시겠습니까?");
		
		if(!chekrtn) {
			return false;
		} else {
			var obj = new Object();
			
			obj.person_write_id = "<%=loginID%>";
			obj.checklist_id = '<%=checklist_id%>';
			obj.checklist_rev_no = '<%=checklist_rev_no%>';
			obj.check_date = $('#check_date').val();
			obj.unsuit_detail = $('#unsuit_detail').val();
			obj.improve_action = $('#improve_action').val();
			obj.types = getFormData($('#form1'));
			
			obj = JSON.stringify(obj);
			
			$.ajax({
		        type: "post",
		        url: "<%=Config.this_SERVER_path%>/Contents/CommonView/insert_update_delete_json.jsp", 
		        data: {bomdata:obj, pid:"M838S020200E102"},
				success: function (html) {
					if(html > -1) {
						heneSwal.success('점검일지 수정이 완료되었습니다');

						$('#modalReport').modal('hide');
		        		parent.fn_MainInfo_List(startDate, endDate);
		        		parent.$('#SubInfo_List_contents').hide();
		         	} else {
						heneSwal.error('점검일지 수정 실패했습니다, 다시 시도해주세요');
		         	}
		         }
			});
		}
	}
</script>

<div class="container">
	<div class="row">
		<div class="col-5">
	  	</div>
	  	<div class="col-3">
	  		점검일자
	  	</div>
	  	<div class="col-4">
		  	<input type="text" data-date-format="yyyy-mm-dd" id="check_date" class="form-control">
	  	</div>
	</div>
	
	<form id="form1">
		<div class="row">
			<div class="col-2 border" id="type01"></div>
		    <div class="col-10 border">
		      	<div class="row border">
			      	<div class="col-7 border" id="type01_1">
			      		
			      	</div>
			      	<div class="col-2 border form-check form-check-inline">
					  <input class="form-check-input" type="radio" id="type01_1_y" value="Y" checked name="type01_1">
					  <label class="form-check-label" for="type01_1_y">Y</label>
					</div>
					<div class="col-2 border form-check form-check-inline">
					  <input class="form-check-input" type="radio" id="type01_1_n" value="N" name="type01_1">
					  <label class="form-check-label" for="type01_1_n">N</label>
					</div>
		      	</div>
			  	<div class="row border">
			      	<div class="col-7 border" id="type01_2">
			      		
			      	</div>
			      	<div class="col-2 border form-check form-check-inline">
					  <input class="form-check-input" type="radio" id="type01_2_y" value="Y" checked name="type01_2">
					  <label class="form-check-label" for="type01_2_y">Y</label>
					</div>
					<div class="col-2 border form-check form-check-inline">
					  <input class="form-check-input" type="radio" id="type01_2_n" value="N" name="type01_2">
					  <label class="form-check-label" for="type01_2_n">N</label>
					</div>
		      	</div>
		      	<div class="row border">
			      	<div class="col-7 border" id="type01_3">
			      		
			      	</div>
			      	<div class="col-2 border form-check form-check-inline">
					  <input class="form-check-input" type="radio" id="type01_3_y" value="Y" checked name="type01_3">
					  <label class="form-check-label" for="type01_3_y">Y</label>
					</div>
					<div class="col-2 border form-check form-check-inline">
					  <input class="form-check-input" type="radio" id="type01_3_n" value="N" name="type01_3">
					  <label class="form-check-label" for="type01_3_n">N</label>
					</div>
		      	</div>
		      	<div class="row border">
			      	<div class="col-7 border" id="type01_4">
			      		
			      	</div>
			      	<div class="col-2 border form-check form-check-inline">
					  <input class="form-check-input" type="radio" id="type01_4_y" value="Y" checked name="type01_4">
					  <label class="form-check-label" for="type01_4_y">Y</label>
					</div>
					<div class="col-2 border form-check form-check-inline">
					  <input class="form-check-input" type="radio" id="type01_4_n" value="N" name="type01_4">
					  <label class="form-check-label" for="type01_4_n">N</label>
					</div>
				</div>
				<div class="row border">
			      	<div class="col-7 border" id="type01_5">
			      		
			      	</div>
			      	<div class="col-2 border form-check form-check-inline">
					  <input class="form-check-input" type="radio" id="type01_5_y" value="Y" checked name="type01_5">
					  <label class="form-check-label" for="type01_5_y">Y</label>
					</div>
					<div class="col-2 border form-check form-check-inline">
					  <input class="form-check-input" type="radio" id="type01_5_n" value="N" name="type01_5">
					  <label class="form-check-label" for="type01_5_n">N</label>
					</div>
				</div>
			</div>
		</div>
	
	
		<div class="row">
			<div class="col-2 border" id="type02"></div>
		    <div class="col-10 border">
		      	<div class="row border">
			      	<div class="col-7 border" id="type02_1">
			      		
			      	</div>
			      	<div class="col-2 border form-check form-check-inline">
					  <input class="form-check-input" type="radio" id="type02_1_y" value="Y" checked name="type02_1">
					  <label class="form-check-label" for="type02_1_y">Y</label>
					</div>
					<div class="col-2 border form-check form-check-inline">
					  <input class="form-check-input" type="radio" id="type02_1_n" value="N" name="type02_1">
					  <label class="form-check-label" for="type02_1_n">N</label>
					</div>
		      	</div>
			</div>
		</div>
	
	
	
		<div class="row">
			<div class="col-2 border" id="type03"></div>
		    <div class="col-10 border">
		      	<div class="row border">
			      	<div class="col-7 border" id="type03_1">
			      		
			      	</div>
			      	<div class="col-2 border form-check form-check-inline">
					  <input class="form-check-input" type="radio" id="type03_1_y" value="Y" checked name="type03_1">
					  <label class="form-check-label" for="type03_1_y">Y</label>
					</div>
					<div class="col-2 border form-check form-check-inline">
					  <input class="form-check-input" type="radio" id="type03_1_n" value="N" name="type03_1">
					  <label class="form-check-label" for="type03_1_n">N</label>
					</div>
		      	</div>
			</div>
		</div>
		
	</form>
	
	
	<div class="row border">
		<div class="col-6 border">
			<div class="row border">
				부적합 사항
			</div>
		    <div class="row border">
		      <input class="form-input" type="text" id="unsuit_detail">
			</div>
		</div>
		<div class="col-6 border">
			<div class="row border">
				개선조치사항
			</div>
		    <div class="row border">
		      <input class="form-input" type="text" id="improve_action">
			</div>
		</div>
	</div>
		
</div>