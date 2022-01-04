<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*,java.util.*,javax.servlet.http.*"%>
<%@ page import="mes.client.comm.*" %>
<%@ page import="mes.client.common.*" %>
<%@ page import="mes.client.guiComponents.*" %>
<%@ page import="mes.client.util.*" %>
<%@ page import="mes.client.conf.*" %>
<%@ page import="org.json.simple.*"%><%@ include file="/strings.jsp" %>
<!DOCTYPE html>

<%
	// S838S070301.jsp 계측기 검교정 대장 등록 (PC)
	String loginID = session.getAttribute("login_id").toString();
	String member_key = session.getAttribute("member_key").toString();

	//로그인한 아이디의 개정번호(rev)를 가져오는 벡터
	Vector UserIDrev = CommonData.getUserRevDataID(loginID,member_key);
	Vector optCodeVector = (Vector)UserIDrev.get(0); 
	String optCode =  optCodeVector.get(0).toString();


%>

<script type="text/javascript">
	// 웹소켓 통신을 위해서 필요한 변수들 ---시작
	var SQL_Param = {
			PID:  "M838S070300E101", 
			excute: "queryProcess",
			stream: "N",
			param: ""
	};
	//웹소켓 통신을 위해서 필요한 변수들 ---끝	
	
	var checklist = $("#inscal_check_table_body tr"); 
	var vSeolbiGubunSeq = 0; // 설비cd,rev,nm 순서구분
	
	$(document).ready(function () {
		
		$("#txt_check_user").val("<%=loginID%>"); //로그인한 유저
		$("#txt_check_user_rev").val("<%=optCode%>"); //로그인한 유저rev		
		
		$("#txt_check_date").datepicker({
        	format: 'yyyy-mm-dd',
        	autoclose: true,
        	language: 'ko'
        });
		
		// 숫자만
	    $("input:text[numberOnly]").on("keyup", function() {
	        $(this).val($(this).val().replace(/[^0-9]/g,""));
	    });
		
// 		fn_plus_checklist(-1); //첫번째 항목 보여주기
		
	});


	function SaveOderInfo() {
		// check_date, check_time 체크 날짜 세팅
	    var today = new Date(); // 오늘날짜
		var write_date 	= today.getFullYear() 
						+ "-" + ("0" + (today.getMonth() + 1)).slice(-2) 
						+ "-" + ("0" + today.getDate()).slice(-2) ;
						
		if($("#txt_check_date").val().length < 1) { // 점검일 선택안하면 저장 X 
	    	alert("점검일을 선택하세요");
	    	return;
	    }
				
		checklist = $("#inscal_check_table_body tr");
		
	    var jArray = new Array(); // JSON Array 선언
	    for(var i=0; i<checklist.length; i++){
	    	var trInput = $(checklist[i]).find(":input");
			
			// 판단(적합/부적합)
			var judgment = $('input[name="txt_judgment'+i+'"]').filter(':checked').val();
			if(judgment==undefined) judgment='N'; // 체크 안되있을 경우 부적합(N)
			
			// JSON 파라미터 세팅
			var dataJson = new Object(); // jSON Object 선언 
			
			if(trInput.eq(2).val().length < 1) { // 계측기명 선택안하면 저장 X
				alert((i+1) + "번째 계측기명을 검색하여 선택하세요");
				return;
			}
			
			dataJson.seolbi_seq_no = trInput.eq(0).val();
			dataJson.seolbi_cd = trInput.eq(2).val();
			dataJson.seolbi_cd_rev = trInput.eq(3).val();
			
			dataJson.seolbi_location = trInput.eq(5).val();
			dataJson.standard_value = trInput.eq(6).val();
			dataJson.check_value = trInput.eq(7).val();
			dataJson.calibration_value = trInput.eq(8).val();
			dataJson.bigo = trInput.eq(9).val();
			dataJson.judgment = judgment;
			
			dataJson.check_date = $("#txt_check_date").val();
			dataJson.check_user = $("#txt_check_user").val();
			dataJson.check_user_rev = $("#txt_check_user_rev").val();
			dataJson.writor_main = $("#txt_check_user").val();
			dataJson.writor_main_rev = $("#txt_check_user_rev").val();
			dataJson.write_date = write_date;
			dataJson.approval = ""; // 물어보고 수정
			dataJson.approval_date = write_date;
			
			dataJson.member_key = "<%=member_key%>";

			jArray.push(dataJson); // 데이터를 배열에 담는다.
	    }
		  
	    var dataJsonMulti = new Object();
 		dataJsonMulti.param = jArray; // Array를 다시 Object형태로 변환 {"param":{Array...}}

		var JSONparam = JSON.stringify(dataJsonMulti); // JSON Object전송을 위해 문자열형태로 바꿔줌(stringify)
		
// 		console.log(JSONparam);
		
		var chekrtn = confirm("등록하시겠습니까?"); 
		if(chekrtn){
			SendTojsp(JSONparam, SQL_Param.PID); // SendToJSP를 통해 ajax로 데이터(JSONObject,PID) 보냄
		}
	}


	function SendTojsp(bomdata, pid){
	    $.ajax({
	         type: "POST",
	         dataType: "json", // Ajax로 json타입으로 보낸다.
	         url: "<%=Config.this_SERVER_path%>/Contents/CommonView/insert_update_delete_json.jsp", 
	         data:  {"bomdata" : bomdata, "pid" : pid },
	         beforeSend: function () {
// 	        	 alert(bomdata);
	         },
	         success: function (html) {	
	        	 if(html>-1){
	        		 opener.parent.fn_MainInfo_List();
		         	window.close();
	         	}
	         },
	         error: function (xhr, option, error) {
	
	         }
	     });		
	} 
	
	function fn_plus_checklist() {
		var tr_count = checklist.length;
		var htmlAppend = 
			"<tr>"
			+ "<td style='border-color: black; '>"
			+ "	CS-계측-" + ("0"+(tr_count+1)).slice(-2)
			+ "	<input type='hidden' class='form-control' id='txt_seolbi_seq_no' value='" + (tr_count+1) + "'></input>"
			+ "</td>"
			+ "<td style='border-color: black; '>"
			+ "	<input type='text'  id='txt_seolbi_nm' readonly ></input>"
			+ "	<input type='hidden'  id='txt_seolbi_cd' ></input>"
			+ "	<input type='hidden'  id='txt_seolbi_cd_rev' ></input>"
			+ "	<button type='button' onclick='parent.pop_fn_SeolbiList_View(1); vSeolbiGubunSeq=" + tr_count + ";' id='btn_SearchCust' class='btn btn-info' >"
			+ "		계측기검색</button>"
			+ "</td>"
			+ "<td style='border-color: black; '>"
			+ "	<input type='text'  id='txt_seolbi_location' ></input>"
			+ "</td>"
			+ "<td style='border-color: black; '>"
			+ "	<input type='text'  id='txt_standard_value' numberOnly ></input>"
			+ "</td>"
			+ "<td style='border-color: black; '>"
			+ "	<input type='text'  id='txt_check_value' numberOnly ></input>"
			+ "</td>"
			+ "<td style='border-color: black; '>"
			+ "	<input type='text'  id='txt_calibration_value' numberOnly ></input>"
			+ "</td>"
			+ "<td style='border-color: black; '>"
			+ "	<input type='radio' id='txt_judgment' name='txt_judgment" + tr_count + "' value='Y' style='width:30px;height:30px;vertical-align:middle;'>적합</input>"
			+ "	<input type='radio' id='txt_judgment' name='txt_judgment" + tr_count + "' value='N' style='width:30px;height:30px;vertical-align:middle;'>부적합</input>"
			+ "</td>"
			+ "<td style='border-color: black; '>"
			+ "	<input type='text'  id='txt_bigo' ></input>"
			+ "	</td>"
			+ "</tr>"
// 		console.log(htmlAppend);
		$("#inscal_check_table_body").append(htmlAppend);
		checklist = $("#inscal_check_table_body tr"); // 새로생긴 요소가 있기 때문에 전역변수 checklist 갱신
	}

	function SetSeolbiInfo(txt_seolbi_cd,txt_seolbi_rev, txt_seolbi_nm) {
		checklist = $("#inscal_check_table_body tr");
		$(checklist[vSeolbiGubunSeq]).find("input[id='txt_seolbi_cd']").val(txt_seolbi_cd);
		$(checklist[vSeolbiGubunSeq]).find("input[id='txt_seolbi_cd_rev']").val(txt_seolbi_rev);
		$(checklist[vSeolbiGubunSeq]).find("input[id='txt_seolbi_nm']").val(txt_seolbi_nm);
	}

</script>
	
<div>
   	<table class="table" style="width: 100%; margin: 0 auto; align:left">
		<tr>
            <td style="width: 160px; font-weight: 900; font-size:14px; vertical-align: middle ; text-align:left">점검일</td>
            <td style="width: auto;  font-weight: 900; font-size:14px; vertical-align: middle ;text-align:left" colspan="2">
				<input type="text" class="form-control" id="txt_check_date" readonly />
				<input type="hidden" id="txt_check_user" />
				<input type="hidden" id="txt_check_user_rev" />
           	</td>
		</tr>
	</table>
</div>   

<table class="table table-bordered" style="width: 100%; margin: 0 auto; text-align:center; border-color: black;" id="inscal_check_table">
	<thead>
	<tr>
        <td style="border-color: black; width:13%;" >계측기 번호</td>
        <td style="border-color: black; width:18%;" >계측기명</td>
        <td style="border-color: black; width:13%;" >사용장소</td>
        <td style="border-color: black; width:10%;" >표준값</td>
        <td style="border-color: black; width:10%;" >지시값</td>
        <td style="border-color: black; width:10%;" >교정값</td>
        <td style="border-color: black; width:13%;" >판정</td>
        <td style="border-color: black; width:13%;" >비고</td>
	</tr>
	</thead>
	<tbody id="inscal_check_table_body">
	<tr>
		<td style='border-color: black; '>
			CS-계측-01
			<input type='hidden' class='form-control' id='txt_seolbi_seq_no' value='1'></input>
		</td>
		<td style='border-color: black; '>
			<input type='text'  id='txt_seolbi_nm' readonly ></input>
			<input type='hidden'  id='txt_seolbi_cd' ></input>
			<input type='hidden'  id='txt_seolbi_cd_rev' ></input>
			<button type='button' onclick='parent.pop_fn_SeolbiList_View(1); vSeolbiGubunSeq=0;' id='btn_SearchCust' class='btn btn-info' >
				계측기검색</button>
		</td>
		<td style='border-color: black; '>
			<input type='text'  id='txt_seolbi_location' ></input>
		</td>
		<td style='border-color: black; '>
			<input type='text'  id='txt_standard_value' numberOnly ></input>
		</td>
		<td style='border-color: black; '>
			<input type='text'  id='txt_check_value' numberOnly ></input>
		</td>
		<td style='border-color: black; '>
			<input type='text'  id='txt_calibration_value' numberOnly ></input>
		</td>
		<td style='border-color: black; '>
			<input type='radio' id='txt_judgment' name='txt_judgment0' value='Y' style='width:30px;height:30px;vertical-align:middle;'>적합</input>
			<input type='radio' id='txt_judgment' name='txt_judgment0' value='N' style='width:30px;height:30px;vertical-align:middle;'>부적합</input>
		</td>
		<td style='border-color: black; '>
			<input type='text'  id='txt_bigo' ></input>
		</td>
	</tr>
	</tbody>
</table>
    
<div style="width:100%;clear:both">
	<p style="text-align:center;">
		<button class='btn btn-outline-success' style='margin-left:5px;' onclick='fn_plus_checklist()'>행추가</button>
	</p>
	<p style="text-align:center;">
		<button id="btn_Save"  class="btn btn-info"  onclick="SaveOderInfo();">저장</button>
		<button id="btn_Canc"  class="btn btn-info"  onclick="window.close();">취소</button>
	</p>
</div>