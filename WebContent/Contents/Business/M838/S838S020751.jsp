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
S838S020751.jsp
부자재 창고 소독약품 점검일지
*/
	String loginID = session.getAttribute("login_id").toString();
	
	String checklist_id = "", checklist_rev_no = "", check_date = "";
	
	if(request.getParameter("checklist_id") != null)
		checklist_id = request.getParameter("checklist_id");	

	if(request.getParameter("checklist_rev_no") != null)
		checklist_rev_no = request.getParameter("checklist_rev_no");
	
	JSONObject jArray = new JSONObject();
	
	check_date = java.time.LocalDate.now().toString();
 	jArray.put("check_date", check_date);
	
    DoyosaeTableModel TableModel = new DoyosaeTableModel("M838S020750E114", jArray);
    MakeGridData data = new MakeGridData(TableModel);
    
%>

<style>
.form-check {
	border : none !important;
	font-size: 14px !important;
	margin : 0 auto;
	padding-left : 23px;
}

.form-input {
	width : 100%;
	Height : 32px;
	border : 0px;
}

.container div {
	font-size: 15px;
	vertical-align: middle;
}

.type_id_s { 
	text-align: center;
	padding : 1%; 
	font-weight: bold;
	vertical-align: middle;
}

.col-8, .others div > div {
	padding : 1%;
}
</style>
<script type="text/javascript">
    $(document).ready(function () {

		new SetSingleDate2("", "#check_date", 0);
    	
    	var questions = <%=data.getDataArray()%>;
		questions = setQuestions(questions);

		var cnt = 1;
		for(var i = 0; i < questions.length; i++) {
			
			var type_nm = questions[i][0];
			var type_id = questions[i][1];
			var type_id_s = questions[i][2];
			var arrQ = questions[i][3];
			
			if(type_nm == "정리정돈청소상태"){
				type_nm = type_nm.substr(0,4) + "<br>"+ type_nm.substr(4,4);
			}
			
			$('#' + type_id_s).html(type_nm);
			
			for(var j = 1; j <= arrQ.length; j++) {
				var sub_questions = arrQ[j-1];
				
				if(cnt <= 9){
					$('#question0' + cnt).text(sub_questions);
				} else {
					$('#question' + cnt).text(sub_questions);
				}
				
				cnt++;
			}
		}
    });
	
    function setQuestions(questions) {
    	
    	var outerArr = new Array();
    	
    	for (i in questions) {
	    	var arr = new Array();
	    	var arrQ = questions[i][3].slice(1, -1).split(",");
	    	
	    	arr.push(questions[i][0]);	// type_nm
			arr.push(questions[i][1]);	// type_id
			arr.push(questions[i][2]);	// type_id_s
			arr.push(arrQ);
			
			outerArr.push(arr);
    	}
    	
    	return outerArr;
    }

	function getFormData(form) {
	    var array = form.serializeArray();
	    
		var arr_type_id_s = ['type01_1', 'type01_2', 'type01_2', 'type01_2', 'type01_3', 'type01_4', 'type01_5', 'type01_5', 'type02_1', 'type02_1', 'type02_1'];
	    
	    for (x in array) {
	    	var question_id = array[x].name.slice(0);
	    	array[x].question_id = question_id;
	    	
	    	if(x <= 7){
	    		array[x].type_id = "type01";
	    	} else {
	    		array[x].type_id = "type02";
	    	}
	    	
	    	array[x].type_id_s = arr_type_id_s[x];
	    }
		
	    return array;
	}
	
	function SaveOderInfo() {
		var chekrtn = confirm("등록하시겠습니까?");
		
		if(chekrtn) {
			var obj = new Object();
			
			obj.checklist_id = '<%=checklist_id%>';
			obj.checklist_rev_no = '<%=checklist_rev_no%>';
			obj.check_date = $('#check_date').val();
			obj.unsuit_detail = $('#unsuit_detail').val();
			obj.improve_action = $('#improve_action').val();
			obj.types = getFormData($('#form1'));
			obj.person_write_id = '<%=loginID%>';
		
			obj = JSON.stringify(obj);
			
			$.ajax({
		        type: "post",
		        url: "<%=Config.this_SERVER_path%>/Contents/CommonView/insert_update_delete_json.jsp", 
		        data: {bomdata:obj, pid:"M838S020750E101"},
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
	}
</script>

<div class="container">
	<div class="row">
		<div class="col-5">
	  	</div>
	  	<div class="col-3" style = "text-align: right; position: relative; top: 7.5px;"> 
	  		점검일자
	  	</div>
	  	<div class="col-4">
		  	<input type="text" data-date-format="yyyy-mm-dd" id="check_date" class="form-control">
	  	</div>
	</div>
	
	<form id="form1" style = "margin-top : 2.5%;">	
		<div class="row type_id"  id="type01">
			<div class="col-2 border type_id_s" id="type01_1">
			</div>
		    <div class="col-10 border">
		      	<div class="row border" height = "100%">
			      	<div class="col-8 border" id="question01"></div>
			      	<div class="col-2 border form-check form-check-inline">
					  <input class="form-check-input" type="radio" id="question01_y" value="Y" checked name="question01">
					  <label class="form-check-label" for="question01_y">예</label>
					</div>
					<div class="col-2 border form-check form-check-inline">
					  <input class="form-check-input" type="radio" id="question01_n" value="N" name="question01">
					  <label class="form-check-label" for="question01_n">아니오</label>
					</div>
		      	</div>
		    </div>
		    
		    <div class="col-2 border type_id_s" id="type01_2"></div>
		    <div class="col-10 border">  	
			  	<div class="row border">
			      	<div class="col-8 border" id="question02"></div>
			      	<div class="col-2 border form-check form-check-inline">
					  <input class="form-check-input" type="radio" id="question02_y" value="Y" checked name="question02">
					  <label class="form-check-label" for="question02_y">예</label>
					</div>
					<div class="col-2 border form-check form-check-inline">
					  <input class="form-check-input" type="radio" id="question02_n" value="N" name="question02">
					  <label class="form-check-label" for="question02_n">아니오</label>
					</div>
		      	</div>
		      	<div class="row border">
			      	<div class="col-8 border" id="question03"></div>
			      	<div class="col-2 border form-check form-check-inline">
					  <input class="form-check-input" type="radio" id="question03_y" value="Y" checked name="question03">
					  <label class="form-check-label" for="question03_y">예</label>
					</div>
					<div class="col-2 border form-check form-check-inline">
					  <input class="form-check-input" type="radio" id="question03_n" value="N" name="question03">
					  <label class="form-check-label" for="question03_n">아니오</label>
					</div>
		      	</div>
		      	<div class="row border">
			      	<div class="col-8 border" id="question04"></div>
			      	<div class="col-2 border form-check form-check-inline">
					  <input class="form-check-input" type="radio" id="question04_y" value="Y" checked name="question04">
					  <label class="form-check-label" for="question04_y">예</label>
					</div>
					<div class="col-2 border form-check form-check-inline">
					  <input class="form-check-input" type="radio" id="question04_n" value="N" name="question04">
					  <label class="form-check-label" for="question04_n">아니오</label>
					</div>
				</div>
			</div>
			<div class="col-2 border type_id_s" id="type01_3">
			</div>
			<div class="col-10 border">	
				<div class="row border">
			      	<div class="col-8 border" id="question05"></div>
			      	<div class="col-2 border form-check form-check-inline">
					  <input class="form-check-input" type="radio" id="question05_y" value="Y" checked name="question05">
					  <label class="form-check-label" for="question05_n">예</label>
					</div>
					<div class="col-2 border form-check form-check-inline">
					  <input class="form-check-input" type="radio" id="question05_n" value="N" name="question05">
					  <label class="form-check-label" for="question05_n">아니오</label>
					</div>
		      	</div>
		   </div>
		   <div class="col-2 border type_id_s" id="type01_4">
			</div>
		   <div class="col-10 border">   	
			  	<div class="row border">
			      	<div class="col-8 border" id="question06"></div>
			      	<div class="col-2 border form-check form-check-inline">
					  <input class="form-check-input" type="radio" id="question06_y" value="Y" checked name="question06">
					  <label class="form-check-label" for="question06_y">예</label>
					</div>
					<div class="col-2 border form-check form-check-inline">
					  <input class="form-check-input" type="radio" id="question06_n" value="N" name="question06">
					  <label class="form-check-label" for="question06_n">아니오</label>
					</div>
		      	</div>
		  </div>
		  <div class="col-2 border type_id_s" id="type01_5"></div>
		  <div class="col-10 border">    	
		      	<div class="row border">
			      	<div class="col-8 border" id="question07"></div>
			      	<div class="col-2 border form-check form-check-inline">
					  <input class="form-check-input" type="radio" id="question07_y" value="Y" checked name="question07">
					  <label class="form-check-label" for="question07_y">예</label>
					</div>
					<div class="col-2 border form-check form-check-inline">
					  <input class="form-check-input" type="radio" id="question07_n" value="N" name="question07">
					  <label class="form-check-label" for="question07_n">아니오</label>
					</div>
		      	</div>
		      	<div class="row border">
			      	<div class="col-8 border" id="question08"></div>
			      	<div class="col-2 border form-check form-check-inline">
					  <input class="form-check-input" type="radio" id="question08_y" value="Y" checked name="question08">
					  <label class="form-check-label" for="question08_y">예</label>
					</div>
					<div class="col-2 border form-check form-check-inline">
					  <input class="form-check-input" type="radio" id="question08_n" value="N" name="question08">
					  <label class="form-check-label" for="question08_n">아니오</label>
					</div>
				</div>
			</div>		
		</div>
	
		<div class="row type_id" id="type02">
			<div class="col-2 border type_id_s" id = "type02_1"></div>
		    <div class="col-10 border">
		      	<div class="row border">
			      	<div class="col-8 border" id="question09"></div>
			      	<div class="col-2 border form-check form-check-inline">
					  <input class="form-check-input" type="radio" id="question09_y" value="Y" checked name="question09">
					  <label class="form-check-label" for="question09_y">예</label>
					</div>
					<div class="col-2 border form-check form-check-inline">
					  <input class="form-check-input" type="radio" id="question09_n" value="N" name="question09">
					  <label class="form-check-label" for="question09_n">아니오</label>
					</div>
		      	</div>
			  	<div class="row border">
			      	<div class="col-8 border" id="question10"></div>
			      	<div class="col-2 border form-check form-check-inline">
					  <input class="form-check-input" type="radio" id="question10_y" value="Y" checked name="question10">
					  <label class="form-check-label" for="question10_y">예</label>
					</div>
					<div class="col-2 border form-check form-check-inline">
					  <input class="form-check-input" type="radio" id="question10_n" value="N" name="question10">
					  <label class="form-check-label" for="question10_n">아니오</label>
					</div>
		      	</div>
		      	<div class="row border">
			      	<div class="col-8 border" id="question11"></div>
			      	<div class="col-2 border form-check form-check-inline">
					  <input class="form-check-input" type="radio" id="question11_y" value="Y" checked name="question11">
					  <label class="form-check-label" for="question11_y">예</label>
					</div>
					<div class="col-2 border form-check form-check-inline">
					  <input class="form-check-input" type="radio" id="question11_n" value="N" name="question11">
					  <label class="form-check-label" for="question11_n">아니오</label>
					</div>
		      	</div>
			</div>
		</div>
	</form>
	<div class="row border others">
		<div class="col-6 border">
			<div class="row border">
				부적합 사항
			</div>
		    <div class="row border">
		      <input class="form-input" type="text" id="unsuit_detail" placeholder="부적합 사항을 적어주세요.">
			</div>
		</div>
		<div class="col-6 border">
			<div class="row border">
				개선 및 예방조치
			</div>
		    <div class="row border">
		      <input class="form-input" type="text" id="improve_action" placeholder="개선조치 사항을 적어주세요.">
			</div>
		</div>
	</div>
</div>