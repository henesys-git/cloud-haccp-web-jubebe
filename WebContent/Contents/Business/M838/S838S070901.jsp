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
	// S838S070901.jsp 해동육점검일지 등록 (PC)
	String loginID = session.getAttribute("login_id").toString();
	String member_key = session.getAttribute("member_key").toString();
	
	//로그인한 아이디의 개정번호(rev)를 가져오는 벡터
	Vector UserIDrev = CommonData.getUserRevDataID(loginID,member_key);
	Vector optCodeVector = (Vector)UserIDrev.get(0); 
	String loginIDrev =  optCodeVector.get(0).toString();
%>

<script type="text/javascript">
	//웹소켓 통신을 위해서 필요한 변수들 ---시작
	var SQL_Param = {
			PID:  "M838S070900E101", 
			excute: "queryProcess",
			stream: "N",
			param: ""
	};
	//웹소켓 통신을 위해서 필요한 변수들 ---끝	
	
	var checklist = $("div[id=input_tr]"); // input_tr div 체크항목개수
	
	$(document).ready(function () {
		
// 		// 숫자만
// 		$("input:text[numberOnly]").on("keyup", function() {
// 	        $(this).val($(this).val().replace(/[^0-9]/g,""));
// 	    });
		
		// 숫자만(마이너스포함)
		$("input:text[numberOnly]").on("change", function() {
			var pattern = /^[-]?\d*$/;
	        var input = $(this).val();
	        if(!pattern.test(input)) {
	        	alert("보통 숫자나 마이너스 숫자만 입력가능");
	        	$(this).val('');
	        	return;
	        }
	    });
		
		// 날짜&시간선택
		$('#txt_thaw_start_datetime').daterangepicker({
        	singleDatePicker:true,
        	timePicker: true,
        	timePicker24Hour: true,
        	locale: {
        		format: 'YYYY-MM-DD HH:mm'
        	}
        });
		$('#txt_thaw_end_datetime').daterangepicker({
        	singleDatePicker:true,
        	timePicker: true,
        	timePicker24Hour: true,
        	locale: {
        		format: 'YYYY-MM-DD HH:mm'
        	}
        });
//         var today = new Date();
//         today.setHours(9,0,0);
//         $('#txt_start_dt').data('daterangepicker').setStartDate(today);
		
        // 로그인한 id,rev
		$("#txt_writor").val("<%=loginID%>");
		$("#txt_writor_rev").val("<%=loginIDrev%>");
	});

	function SaveOderInfo() {
		// write_date 등록 날짜 세팅
// 	    var today = new Date("2019-06-02"); // 특정날짜
	    var today = new Date(); // 오늘날짜
		var check_datetime 	= today.getFullYear() 
							+ "-" + ("0" + (today.getMonth() + 1)).slice(-2) 
							+ "-" + ("0" + today.getDate()).slice(-2) 
							+ " " + ("0" + today.getHours()).slice(-2)
							+ ":" + ("0" + today.getMinutes()).slice(-2) ;
// 							+ ":" + ("0" + today.getSeconds()).slice(-2) ;
		
		// JSON 파라미터 세팅
		var dataJson = new Object(); // jSON Object 선언 
		
		if($("#txt_item_cd").val().length<1) { // 품목 선택 안하면
			alert("품목를 검색하여 선택하세요");
			return;
		}
		
		dataJson.item_cd = $("#txt_item_cd").val();
		dataJson.item_cd_rev = $("#txt_item_cd_rev").val();
		dataJson.orign_country = $("#txt_orign_country").val();
		dataJson.thaw_start_datetime = $("#txt_thaw_start_datetime").val();
		dataJson.thaw_end_datetime = $("#txt_thaw_end_datetime").val();
		
		dataJson.temperature = $("#txt_temperature").val();
		if($("#txt_sign_matter").prop("checked"))
			var v_sign_matter ="Y";
		else
			var v_sign_matter="N";
		dataJson.sign_matter = v_sign_matter;
		if($("#txt_packing_shape").prop("checked"))
			var v_packing_shape ="Y";
		else
			var v_packing_shape="N";
		dataJson.packing_shape = v_packing_shape;
		
		dataJson.incong_note = $("#txt_incong_note").val();
		dataJson.improve_note = $("#txt_improve_note").val();
		dataJson.bigo_note = $("#txt_bigo_note").val();
		
		dataJson.check_datetime = check_datetime;
		dataJson.writor = $("#txt_writor").val();
		dataJson.writor_rev = $("#txt_writor_rev").val();
		dataJson.write_date = check_datetime;
		dataJson.approval = "";
		dataJson.approval_rev = 0;
		dataJson.approve_date = check_datetime;
		
		dataJson.member_key = "<%=member_key%>";
		
		var JSONparam = JSON.stringify(dataJson); // JSON Object전송을 위해 문자열형태로 바꿔줌(stringify)
		
// 		console.log(JSONparam);
		
		SendTojsp(JSONparam, SQL_Param.PID); // SendToJSP를 통해 ajax로 데이터(JSONObject,PID) 보냄
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

	function fn_check_value_event(index, type) {
		if(type=='text') { // 결과값(텍스트박스) onkeydown event
			if(event.keyCode == 13) { // 엔터키 쳤을때만 tr 감추기
				$(checklist[index]).hide(0,function(){
					if(index+1 < checklist.length)
						$(checklist[index+1]).show(0);
				});
			}
		} else if(type=='checkbox') { // 결과값(체크박스) onchange event
			$(checklist[index]).hide(0,function(){
				if(index+1 < checklist.length)
					$(checklist[index+1]).show(0);
			});
		} else { // '다음' 버튼 onclick event (값입력 또는 체크 안하고 넘어감)
			$(checklist[index]).hide(0,function(){
				if(index+1 < checklist.length)
					$(checklist[index+1]).show(0);
			});
		}
	}
	
	function SetpartName_code(txt_part_name, txt_part_cd,txt_part_revision_no,txt_gyugeok,txt_unit_price,txt_wonsanji) {
		$("#txt_part_nm").val(txt_part_name);
		$("#txt_item_cd").val(txt_part_cd);
		$("#txt_item_cd_rev").val(txt_part_revision_no);
		$("#txt_orign_country").val(txt_wonsanji);
	}

</script>

<style>
 	#thawMeat { 
 	  font-family: "Trebuchet MS", Arial, Helvetica, sans-serif; 
 	  border-collapse: collapse; 
 	  width: 100%; 
 	} 
	
 	#thawMeat td, #thawMeat th { 
 	  border: 1px solid #ddd; 
 	  padding: 8px; 
 	}
	
 	#thawMeat th { 
 	  padding-top: 12px;
 	  padding-bottom: 12px;
 	  text-align: center;
 	} 
</style>

<body>
    <table id="thawMeat">
         <tbody>
         	<tr>
                 <td>품명/원산지</td>
                 <td>해동시작</td>
                 <td>해동종료</td>
                 <td>측정온도</td>
                 <td>표시사항</td>
                 <td>제품포장상태</td>
            </tr>
            <tr>
                 <td>
                    <h3 style="display:inline-block; margin-right:10px;">품명&nbsp;&nbsp;&nbsp;</h3>
					<input type="text" id="txt_part_nm" readonly></input>
					<input type="hidden" id="txt_item_cd"></input>
					<input type="hidden" id="txt_item_cd_rev"></input>
 					<button type="button" onclick="parent.pop_fn_PartList_View(2)" id="btn_SearchCust" class="btn btn-info" >품목검색</button><br/>
					<h3 style="display:inline-block; margin-right:10px;">원산지</h3>
					<input type="text" id="txt_orign_country" readonly></input>
                 </td>
                 <td>
                    <input type="text" id="txt_thaw_start_datetime" readonly></input>
                 </td>
                 <td>
                    <input type="text" id="txt_thaw_end_datetime" readonly></input>
                 </td>
                 <td>
                    <input type="text" id="txt_temperature" onkeydown="fn_check_value_event(3,'text')" numberOnly></input>
                 </td>
                 <td>
                    <input type="checkbox" id="txt_sign_matter" value="CHECK" onchange="fn_check_value_event(4,'checkbox')"
		style="width:30px; height:30px; vertical-align:middle;" ></input>양호
                 </td>
				 <td>
				 	<input type="checkbox" id="txt_packing_shape" value="CHECK" onchange="fn_check_value_event(5,'checkbox')" style="width:30px; height:30px; vertical-align:middle;"></input>양호</td>
             </tr>
         </tbody>
    </table>
    
    <table id="thawMeat">
    <thead>
    	<tr>
    		<th>부적합사항</th>
        	<th>대책 및 조치사항</th>
        	<th>비고</th>
    	</tr>
    </thead>
    <tbody>
	    <tr>
	    	<td>
	            <input type="text" class="form-control" id="txt_incong_note" />
	        </td>
	        <td>
	            <input type="text" class="form-control" id="txt_improve_note" />
	        </td>
	        <td>
	            <input type="text" class="form-control" id="txt_bigo_note" />
	            <!-- 기타사항(작성자id, rev) -->
	            <input type="hidden" id="txt_writor" ></input>
	            <input type="hidden" id="txt_writor_rev" ></input>
	        </td>
	    </tr>
    </tbody>
</table>
    
	<div style="width:100%;clear:both">
		<p style="text-align:center;">
			<button id="btn_Save" class="btn btn-info" onclick="SaveOderInfo();">저장</button>
			<button id="btn_Canc" class="btn btn-info" onclick="window.close();">취소</button>
		</p>
	</div>
</body>