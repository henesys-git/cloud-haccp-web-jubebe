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
	// S838S050601.jsp 공정관리 점검표 등록 (PC)
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

	TableModel = new DoyosaeTableModel("M838S050600E134", jArray);
	int RowCount =TableModel.getRowCount();
	
%>

<script type="text/javascript">
	// 웹소켓 통신을 위해서 필요한 변수들 ---시작
	var SQL_Param = {
			PID:  "M838S050600E101", 
			excute: "queryProcess",
			stream: "N",
			param: ""
	};
	//웹소켓 통신을 위해서 필요한 변수들 ---끝	
	
	$(document).ready(function () {
		// 숫자만
	    $("input:text[numberOnly]").on("keyup", function() {
	        $(this).val($(this).val().replace(/[^0-9]/g,""));
	    });
		
		$("#txt_check_date").datepicker({
        	format: 'yyyy-mm-dd',
        	autoclose: true,
        	language: 'ko'
        });
		var today = new Date();
		$('#txt_check_date').datepicker('update', today);
		$("#txt_incong_date").datepicker({
        	format: 'yyyy-mm-dd',
        	autoclose: true,
        	language: 'ko'
        });
		var today = new Date();
		$('#txt_incong_date').datepicker('update', today);
		
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
		var check_time 	= ("0" + today.getHours()).slice(-2) 
						+ ":" + ("0" + today.getMinutes()).slice(-2) 
						+ ":" + ("0" + today.getSeconds()).slice(-2) ;
			
	    var jArray = new Array(); // JSON Array 선언
	    
	    var checklist = $("#procfact_check_table_body tr");
	    
	    for(var i=0; i<checklist.length; i++){
	    	var trInput = $(checklist[i]).find(":input");
		
			// 결과값 세팅
			var result_value;
			if(trInput.eq(19).val()=='CHECK'){ // 결과값이 체크박스 형태일때
				if($("input[id='txt_check_value']").eq(i).prop("checked"))
					result_value ="Y";
				else
					result_value="N";
			} else { // 결과값이 텍스트박스 형태일때
				result_value = trInput.eq(19).val();
			}
			
			// JSON 파라미터 세팅
			var dataJson = new Object(); // jSON Object 선언
			
			dataJson.check_date = $("#txt_check_date").val();
			dataJson.check_gubun = trInput.eq(6).val();
			dataJson.check_gubun_mid = trInput.eq(13).val();
			dataJson.check_gubun_sm = trInput.eq(15).val();
			dataJson.checklist_cd = trInput.eq(1).val();
			dataJson.cheklist_cd_rev = trInput.eq(2).val();
			dataJson.checklist_seq = trInput.eq(0).val();
			dataJson.item_cd = trInput.eq(3).val();
			dataJson.item_seq = trInput.eq(4).val();
			dataJson.item_cd_rev = trInput.eq(5).val();
			dataJson.standard_guide = trInput.eq(9).val();
			dataJson.standard_value = trInput.eq(18).val();
			dataJson.check_note = trInput.eq(17).val();
			dataJson.check_value = result_value;
			
			dataJson.incong_date = $("#txt_incong_date").val();
			dataJson.incong_place = $("#txt_incong_place").val();
			dataJson.incong_note = $("#txt_incong_note").val();
			dataJson.incong_action = $("#txt_incong_action").val();
			dataJson.incong_confirm = '';
			dataJson.checker = $("#txt_writor").val();
			dataJson.checker_rev = $("#txt_writor_rev").val();
			dataJson.write_date = check_date;
			dataJson.writor = $("#txt_writor").val();
			dataJson.writor_rev = $("#txt_writor_rev").val();
			dataJson.approval = "";
			dataJson.approval_rev = 0;
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

</script>


<!-- <div style="overflow-y:auto; width:100%; height:500px;"> -->
<table class="table table-bordered" style="width: 100%; margin: 0 auto; text-align:center; height:450px; overflow-y: auto; border-color: black;" id="procfact_check_table">
	<thead>
	<tr>
        <td style="border-color: black; width:40%;" colspan="2">점검일자</td>
		<td style="border-color: black; width:60%;" colspan="2">
			<input type="text" class="form-control" id="txt_check_date" readonly />
			<input type="hidden" id="txt_writor" readonly />
			<input type="hidden" id="txt_writor_rev" readonly />
		</td>
	</tr>
	<tr>
        <td style="border-color: black; width:20%;" >설비명</td>
        <td style="border-color: black; width:20%;" >세부부위</td>
        <td style="border-color: black; width:45%;" >점검항목</td>
        <td style="border-color: black; width:15%;" >점검결과</td>
	</tr>
	</thead>
	<tbody id="procfact_check_table_body">
<%
	for (int i=0; i<RowCount; i++){  
		String GV_CHECK_GUBUN_MID = TableModel.getValueAt(i, 18).toString().trim() ;
		String GV_CHECK_GUBUN_SM = TableModel.getValueAt(i, 20).toString().trim() ;
		String GV_CHECK_NOTE = TableModel.getValueAt(i, 5).toString().trim() ;
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
			<input type="hidden" class="form-control" id="txt_standard_guide"  readonly value='<%=TableModel.getValueAt(i, 6).toString().trim()%>'></input>
			<input type="hidden" class="form-control" id="txt_item_bigo" readonly value='<%=TableModel.getValueAt(i, 13).toString().trim()%>'></input>
			<input type="hidden" class="form-control" id="txt_start_date" readonly value='<%=TableModel.getValueAt(i, 15).toString().trim()%>'></input>	
			<input type="hidden" class="form-control" id="txt_duration_date" readonly value='<%=TableModel.getValueAt(i, 16).toString().trim()%>'></input>
			<input type="hidden" class="form-control" id="txt_check_gubun_mid"  readonly value='<%=TableModel.getValueAt(i, 17).toString().trim()%>'></input>
			<input type="hidden" class="form-control" id="txt_check_gubun_mid_name"  readonly value='<%=GV_CHECK_GUBUN_MID%>'></input>
			<input type="hidden" class="form-control" id="txt_check_gubun_sm"  readonly value='<%=TableModel.getValueAt(i, 19).toString().trim()%>'></input>
			<input type="hidden" class="form-control" id="txt_check_gubun_sm_name"  readonly value='<%=GV_CHECK_GUBUN_SM%>'></input>
			<input type="hidden" class="form-control" id="txt_check_note" readonly value='<%=GV_CHECK_NOTE%>'></input>
			<input type="hidden" class="form-control" id="txt_standard_value" readonly value='<%=TableModel.getValueAt(i, 7).toString().trim()%>'></input>
		</td>
		<td style="border-color: black;">
        	<%=GV_CHECK_GUBUN_SM%>
		</td>
        <td style="border-color: black;">
        	<%=GV_CHECK_NOTE%>
		</td>
		<td style="border-color: black;">
            <%if(TableModel.getValueAt(i,12).toString().trim().equals("text")){ %>
			<input type="<%=TableModel.getValueAt(i,12).toString().trim()%>"  id="txt_check_value"  class="form-control" numberOnly>
			</input>
			<%} else if(TableModel.getValueAt(i,12).toString().trim().equals("checkbox")){ %>
			<input type="<%=TableModel.getValueAt(i,12).toString().trim()%>"  id="txt_check_value" value="CHECK" 
					style="width:30px; height:30px; vertical-align:middle;" checked>
					<%=TableModel.getValueAt(i, 7).toString().trim()%>
			</input>
			<%} %>
		</td>
	</tr>
<% }%>
	</tbody>
</table>
<!-- </div> -->
	<div>
    	<table class="table" style="width: 100%; margin: 0 auto; align:left">
           	<tr>
	            <td style="width: 160px; font-weight: 900; font-size:14px; vertical-align: middle ; text-align:left">발생일자</td>
	            <td style="width: auto;  font-weight: 900; font-size:14px; vertical-align: middle ;text-align:left">
					<input type="text" class="form-control" id="txt_incong_date" readonly />
	           	</td>
			</tr>
			<tr>
	            <td style="width: 160px; font-weight: 900; font-size:14px; vertical-align: middle ; text-align:left">발생장소</td>
	            <td style="width: auto;  font-weight: 900; font-size:14px; vertical-align: middle ;text-align:left">
					<input type="text" class="form-control" id="txt_incong_place"  />
	           	</td>
			</tr>
			<tr>
	            <td style="width: 160px; font-weight: 900; font-size:14px; vertical-align: middle ; text-align:left">발생내용</td>
	            <td style="width: auto;  font-weight: 900; font-size:14px; vertical-align: middle ;text-align:left">
					<input type="text" class="form-control" id="txt_incong_note"  />
	           	</td>
			</tr>
			<tr>
	            <td style="width: 160px; font-weight: 900; font-size:14px; vertical-align: middle ; text-align:left">조치내용</td>
	            <td style="width: auto;  font-weight: 900; font-size:14px; vertical-align: middle ;text-align:left">
					<input type="text" class="form-control" id="txt_incong_action"  />
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