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
	// S838S070801.jsp 비금속성 이물관리 등록 (PC)
	String loginID = session.getAttribute("login_id").toString();
	String member_key = session.getAttribute("member_key").toString();

	//로그인한 아이디의 개정번호(rev)를 가져오는 벡터
	Vector UserIDrev = CommonData.getUserRevDataID(loginID,member_key);
	Vector optCodeVector = (Vector)UserIDrev.get(0); 
	String optCode =  optCodeVector.get(0).toString();


	DoyosaeTableModel TableModel;

	CurrentPage jspPageName = new CurrentPage(request.getRequestURI());

	String GV_CHECK_GUBUN = "";
	
	if(request.getParameter("check_gubun")== null)
		GV_CHECK_GUBUN = "";
	else
		GV_CHECK_GUBUN = request.getParameter("check_gubun");
	
	JSONObject jArray = new JSONObject();
	jArray.put( "check_gubun", GV_CHECK_GUBUN);
	jArray.put( "member_key", member_key);

	TableModel = new DoyosaeTableModel("M838S070800E134", jArray);
	int RowCount =TableModel.getRowCount();
	
%>

<script type="text/javascript">
	// 웹소켓 통신을 위해서 필요한 변수들 ---시작
	var SQL_Param = {
			PID:  "M838S070800E101", 
			excute: "queryProcess",
			stream: "N",
			param: ""
	};
	//웹소켓 통신을 위해서 필요한 변수들 ---끝	
	
	$(document).ready(function () {
		
		$("#txt_writor").val("<%=loginID%>"); //로그인한 유저
		$("#txt_writor_rev").val("<%=optCode%>"); //로그인한 유저rev			
		
	});


	function SaveOderInfo() {
		// check_date, check_time 체크 날짜 세팅
// 	    var today = new Date("2019-06-02"); // 특정날짜
	    var today = new Date(); // 오늘날짜
		var check_date 	= today.getFullYear() 
						+ "-" + ("0" + (today.getMonth() + 1)).slice(-2) 
						+ "-" + ("0" + today.getDate()).slice(-2) ;
			
	    var jArray = new Array(); // JSON Array 선언
	    
	    var checklist = $("#nmtal_check_table_body tr");
	    
	    for(var i=0; i<checklist.length; i++){
			var trInput = $(checklist[i]).find(":input");
		
			// 결과값 세팅
			if($("input[id='txt_measure_yn']").eq(i).prop("checked"))
				var measure_yn ="Y";
			else
				var measure_yn="N";
			if($("input[id='txt_inspection_result']").eq(i).prop("checked"))
				var inspection_result ="Y";
			else
				var inspection_result="N";
			
			// JSON 파라미터 세팅
			var dataJson = new Object(); // jSON Object 선언 
			
			dataJson.check_date = check_date;
			dataJson.check_gubun = trInput.eq(6).val();
			dataJson.checklist_seq = trInput.eq(0).val();
			dataJson.working_process = trInput.eq(12).val(); // check_gubun_mid
			dataJson.inspection_point = trInput.eq(14).val(); // check_gubun_sm
			dataJson.latent_foreign_possiblity = trInput.eq(16).val(); // check_note
			dataJson.measure = trInput.eq(17).val(); // standard_guide
			
			dataJson.measure_yn = measure_yn;
			dataJson.inspection_result = inspection_result;
			dataJson.bigo = trInput.eq(20).val();
			
			dataJson.deviations_subject = $("#txt_deviations_subject").val();
			dataJson.improvement = $("#txt_improvement").val();
			dataJson.total_bigo = $("#txt_total_bigo").val();
			
			dataJson.writor = $("#txt_writor").val();
			dataJson.writor_rev = $("#txt_writor_rev").val();
			dataJson.write_date = check_date;
			dataJson.approval = ""; // 물어보고 수정
			dataJson.approval_rev = 0;
			dataJson.approve_date = check_date;
			
			dataJson.member_key = "<%=member_key%>";
			
			jArray.push(dataJson); // 데이터를 배열에 담는다.
	    }
		  
	    var dataJsonMulti = new Object();
 		dataJsonMulti.param = jArray; // Array를 다시 Object형태로 변환 {"param":{Array...}}

		var JSONparam = JSON.stringify(dataJsonMulti); // JSON Object전송을 위해 문자열형태로 바꿔줌(stringify)
		
		var chekrtn = confirm("등록하시겠습니까?"); 
		if(chekrtn){
// 			console.log(JSONparam);
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

	function SetpartName_code(txt_part_name, txt_part_cd,txt_part_revision_no,txt_gyugeok,txt_unit_price) {
		$("#txt_part_nm").val(txt_part_name);
		$("#txt_part_cd").val(txt_part_cd);
		$("#txt_part_cd_rev").val(txt_part_revision_no);
	}

</script>


<table style="width: 98%; margin: 0 auto; border-color: black; ">
	<tr>
		<td colspan="3">HSC-PP-01-E 비금속성 이물관리</td>
	</tr>
	<tr>
		<td style="font-size: 30px; text-align: center;" colspan="3">비금속성 이물관리</td>
	</tr>
	<tr>
		<td style="width:30%; text-align:left;">점겅일 :</td>
		<td style="width:50%;"> 
			<input type="hidden" id="txt_writor" readonly />
			<input type="hidden" id="txt_writor_rev" readonly />
		</td>
		<td style="width:20%; text-align:left;">*1회/월 점검</td>
	</tr>
</table>

<!-- <div style="overflow-y:auto; width:100%; height:500px;"> -->
<table class="table table-bordered" style="width: 98%; margin: 0 auto; text-align:center; height:450px; overflow-y: auto; border-color: black;"  id="nmtal_check_table">
	<thead style="background-color:#A6A6A6;">
		<tr style="font-weight:900;">
			<td style="border-color: black; width:10%; height:3px; vertical-align: middle;">작업공정</td>
			<td style="border-color: black; width:9%;  height:3px; vertical-align: middle;">점검사항</td>
			<td style="border-color: black; width:20%; height:3px; vertical-align: middle;">잠재이물가능성</td>
			<td style="border-color: black; width:40%; height:3px; vertical-align: middle;">예방법</td>
			<td style="border-color: black; width:7%;  height:3px; vertical-align: middle;">예방법<br>실행여부<br>(O,X)</td>
			<td style="border-color: black; width:7%;  height:3px; vertical-align: middle;">점검결과<br>(O,X)</td>
			<td style="border-color: black; width:7%;  height:3px; vertical-align: middle;">비고</td>
		</tr>
	</thead>
	<tbody id="nmtal_check_table_body">
	<%
		for (int i=0; i<RowCount; i++) {  
			String GV_CHECK_GUBUN_MID 	= TableModel.getValueAt(i, 18).toString().trim() ;
			String GV_CHECK_GUBUN_SM 	= TableModel.getValueAt(i, 20).toString().trim() ;
			String GV_CHECK_NOTE 		= TableModel.getValueAt(i, 5).toString().trim() ;
			String GV_STANDARD_GUIDE	= TableModel.getValueAt(i, 6).toString().trim() ;
	%>	        		
		<tr>
	        <td style="border-color: black;">
	        	<%=GV_CHECK_GUBUN_MID%>
		        <input type="hidden" class="form-control" id="txt_checklist_seq" readonly value='<%=TableModel.getValueAt(i, 4).toString().trim()%>'></input>
	       		<input type="hidden" class="form-control" id="txt_checklist_cd" readonly value='<%=TableModel.getValueAt(i, 2).toString().trim()%>'></input>	
				<input type="hidden" class="form-control" id="txt_checklist_rev" readonly value='<%=TableModel.getValueAt(i, 3).toString().trim()%>'></input>
	       		<input type="hidden" class="form-control" id="txt_item_cd" readonly value='<%=TableModel.getValueAt(i, 9).toString().trim()%>'></input>
				<input type="hidden" class="form-control" id="txt_item_seq" readonly value='<%=TableModel.getValueAt(i, 10).toString().trim()%>'></input>	
				<input type="hidden" class="form-control" id="txt_item_cd_rev" readonly value='<%=TableModel.getValueAt(i, 11).toString().trim()%>'></input>
	       		<input type="hidden" class="form-control" id="txt_check_gubun" readonly value='<%=TableModel.getValueAt(i, 0).toString().trim()%>'></input>	
				<input type="hidden" class="form-control" id="txt_code_name" readonly value='<%=TableModel.getValueAt(i, 1).toString().trim()%>'></input>	
				<input type="hidden" class="form-control" id="txt_double_check_yn" readonly value='<%=TableModel.getValueAt(i, 8).toString().trim()%>'></input>		
				<input type="hidden" class="form-control" id="txt_item_bigo" readonly value='<%=TableModel.getValueAt(i, 13).toString().trim()%>'></input>
				<input type="hidden" class="form-control" id="txt_start_date" readonly value='<%=TableModel.getValueAt(i, 15).toString().trim()%>'></input>	
				<input type="hidden" class="form-control" id="txt_duration_date" readonly value='<%=TableModel.getValueAt(i, 16).toString().trim()%>'></input>
				<input type="hidden" class="form-control" id="txt_check_gubun_mid"  readonly value='<%=TableModel.getValueAt(i, 17).toString().trim()%>'></input>
				<input type="hidden" class="form-control" id="txt_check_gubun_mid_name"  readonly value='<%=GV_CHECK_GUBUN_MID%>'></input>
				<input type="hidden" class="form-control" id="txt_check_gubun_sm"  readonly value='<%=TableModel.getValueAt(i, 19).toString().trim()%>'></input>
				<input type="hidden" class="form-control" id="txt_check_gubun_sm_name"  readonly value='<%=GV_CHECK_GUBUN_SM%>'></input>
				<input type="hidden" class="form-control" id="txt_check_note" readonly value='<%=GV_CHECK_NOTE%>'></input>
				<input type="hidden" class="form-control" id="txt_standard_guide" readonly value='<%=GV_STANDARD_GUIDE%>'></input>
			</td>
			<td style="border-color: black;">
				<%=GV_CHECK_GUBUN_SM%>				
			</td>
			<td style="border-color: black; text-align:left;">
				<%=GV_CHECK_NOTE%>			
			</td>
	        <td style="border-color: black; text-align:left;">
	        	<%=GV_STANDARD_GUIDE%>	
			</td>
			<td style="border-color: black;">
				<input type="<%=TableModel.getValueAt(i,12).toString().trim()%>"  id="txt_measure_yn" value="CHECK" 
						style="width:30px; height:30px; vertical-align:middle;" >
						<%=TableModel.getValueAt(i, 7).toString().trim()%>
				</input>
			</td>			
            <td style="border-color: black;">
				<input type="<%=TableModel.getValueAt(i,12).toString().trim()%>"  id="txt_inspection_result" value="CHECK" 
						style="width:30px; height:30px; vertical-align:middle;" >
						<%=TableModel.getValueAt(i, 7).toString().trim()%>
				</input>
			</td>			
			<td style="width: auto; border-color: black; font-size:14px; vertical-align: middle ;text-align:left">
				<input type="text"  id="txt_bigo" ></input>
           	</td>
		</tr>
	<% }%>
	</tbody>
</table>
	
	<div>
    	<table class="table" style="width: 95%; margin: 20px auto; align:left">
           	<tr>
	            <td style="width: 160px; font-weight: 900; font-size:14px; vertical-align: middle ; text-align:left">점검 시 이탈사항</td>
	            <td style="width: auto;  font-weight: 900; font-size:14px; vertical-align: middle ;text-align:left">
					<input type="text" class="form-control" id="txt_deviations_subject"  />
	           	</td>
			</tr>
			<tr>
	            <td style="width: 160px; font-weight: 900; font-size:14px; vertical-align: middle ; text-align:left">개선조치사항</td>
	            <td style="width: auto;  font-weight: 900; font-size:14px; vertical-align: middle ;text-align:left">
					<input type="text" class="form-control" id="txt_improvement"  />
	           	</td>
			</tr>
			<tr>
	            <td style="width: 160px; font-weight: 900; font-size:14px; vertical-align: middle ; text-align:left">비고</td>
	            <td style="width: auto;  font-weight: 900; font-size:14px; vertical-align: middle ;text-align:left">
					<input type="text" class="form-control" id="txt_total_bigo"  />
	           	</td>
			</tr>
		</table>
	</div>     
	 
	<div style="width:100%;clear:both">
		<p style="text-align:center;">
			<button id="btn_Save"  class="btn btn-info"  onclick="SaveOderInfo();">저장</button>
			<button id="btn_Canc"  class="btn btn-info"  onclick="window.close();">취소</button>
		</p>
	</div>