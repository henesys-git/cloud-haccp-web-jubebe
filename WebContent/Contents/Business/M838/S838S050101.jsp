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
	// S838S050101.jsp 일일위생 점검일지 등록 (PC)
	String loginID = session.getAttribute("login_id").toString();
	String member_key = session.getAttribute("member_key").toString();

	//로그인한 아이디의 개정번호(rev)를 가져오는 벡터
	Vector UserIDrev = CommonData.getUserRevDataID(loginID,member_key);
	Vector optCodeVector = (Vector)UserIDrev.get(0); 
	String optCode =  optCodeVector.get(0).toString();
	
	DoyosaeTableModel TableModel;
	
	// URI로 JSPpage 못불러와서 일단 직접 표기
// 	CurrentPage jspPageName = new CurrentPage(request.getRequestURI());
// 	String JSPpage = jspPageName.GetJSP_FileName();
	String JSPpage = "M838S050100.jsp";
	ProcesStatusCheck prcStatusCheck = new ProcesStatusCheck(JSPpage.replace("T","M") + "|" + "NON" + "|");

	String GV_CHECK_GUBUN		= prcStatusCheck.GV_PROCESS_NUMBER_GUBUN;
	
// 	if(request.getParameter("check_gubun")== null)
// 		GV_CHECK_GUBUN = "";
// 	else
// 		GV_CHECK_GUBUN = request.getParameter("check_gubun");
	
// 	GV_CHECK_GUBUN = "DLYHYG_INS";
	
	JSONObject jArray = new JSONObject();
	jArray.put( "member_key", member_key);
	jArray.put( "check_gubun", GV_CHECK_GUBUN);

	TableModel = new DoyosaeTableModel("M838S050100E134", jArray);
	int RowCount =TableModel.getRowCount();
%>

<script type="text/javascript">
	//웹소켓 통신을 위해서 필요한 변수들 ---시작
	var SQL_Param = {
			PID:  "M838S050100E101", 
			excute: "queryProcess",
			stream: "N",
			param: ""
	};
	//웹소켓 통신을 위해서 필요한 변수들 ---끝	
	
	var checklist = $("div[id=checklist_tr]"); // checklist_tr div 체크항목개수
	
	$(document).ready(function () {
		
		$("#txt_writor_main").val("<%=loginID%>"); //로그인한 유저
		$("#txt_writor_main_rev").val("<%=optCode%>"); //로그인한 유저rev	
		
	});


	function SaveOderInfo() {
		// check_date, check_time 체크 날짜 세팅
// 	    var today = new Date("2019-06-02"); // 특정날짜
	    var today = new Date(); 			// 오늘날짜
		var check_date 	= today.getFullYear() 
						+ "-" + ("0" + (today.getMonth() + 1)).slice(-2) 
						+ "-" + ("0" + today.getDate()).slice(-2) ;
		var check_time 	= ("0" + today.getHours()).slice(-2) 
						+ ":" + ("0" + today.getMinutes()).slice(-2) 
						+ ":" + ("0" + today.getSeconds()).slice(-2) ;
			
		// check_duration 체크 날짜기간(월~토) 세팅
		if(today.getDay() == 0) { // 일요일에 점검표 등록할 경우 경고문
	    	var check_sunday = confirm("오늘(일요일)은 등록한 내용은 점검표에 나타나지 않습니다."
	    								+"\n"+"그래도 저장하시겠습니까?");
			if(check_sunday) var check_duration = "";
			else return false;
	    } else {
			var duration_start = new Date(today); // check_duration 기간 처음 날짜(월요일)
			duration_start.setDate(today.getDate() + 1 - today.getDay()); // 이번주의 월요일날짜, today.getDay() == 오늘 요일(0:일요일~6:토요일)
			var duration_end = new Date(today); // check_duration 기간 마지막 날짜(토요일)
			duration_end.setDate(today.getDate() + 6 - today.getDay()); // 이번주의 토요일 날짜, today.getDay() == 오늘 요일(0:일요일~6:토요일)
			var check_duration  = duration_start.getFullYear() 
								+ "-" + ("0" + (duration_start.getMonth() + 1)).slice(-2) 
								+ "-" + ("0" + duration_start.getDate()).slice(-2)
						 		+ "~" + duration_end.getFullYear() 
								+ "-" + ("0" + (duration_end.getMonth() + 1)).slice(-2) 
								+ "-" + ("0" + duration_end.getDate()).slice(-2) ; // 형식 : 2019-00-00~2019-00-00
//	 		console.log("duration_start="+duration_start+"\n"+"duration_end="+duration_end);
	    }
		
	    var jArray = new Array(); // JSON Array 선언
	    
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
			dataJson.member_key = "<%=member_key%>";
			
			dataJson.check_duration = check_duration;
			dataJson.check_date = check_date;
			dataJson.check_time = check_time;
			
			dataJson.check_gubun = trInput.eq(6).val();
			dataJson.check_gubun_mid = trInput.eq(13).val();
			dataJson.check_gubun_sm = trInput.eq(15).val();
			
			dataJson.checklist_cd = trInput.eq(1).val();
			dataJson.cheklist_cd_rev = trInput.eq(2).val();
			dataJson.checklist_seq = trInput.eq(0).val();
			dataJson.item_cd = trInput.eq(3).val();
			dataJson.item_seq = trInput.eq(4).val();
			dataJson.item_cd_rev = trInput.eq(5).val();
			
			dataJson.check_note = trInput.eq(17).val();
			dataJson.check_value = result_value;
			
			dataJson.write_date = check_date;
			dataJson.writor_main = $("#txt_writor_main").val();
			dataJson.writor_main_rev = $("#txt_writor_main_rev").val();
			dataJson.write_approval = ""; // 물어보고 수정
			dataJson.incong_note = $("#txt_incong_note").val();
			dataJson.improve_note = $("#txt_improve_note").val();

			dataJson.standard_guide = trInput.eq(9).val();
			dataJson.standard_value = trInput.eq(18).val();
			
			jArray.push(dataJson); // 데이터를 배열에 담는다.
	    }
		  
	    var dataJsonMulti = new Object();
 		dataJsonMulti.param = jArray; // Array를 다시 Object형태로 변환 {"param":{Array...}}

		var JSONparam = JSON.stringify(dataJsonMulti); // JSON Object전송을 위해 문자열형태로 바꿔줌(stringify)
		
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
	        		opener.parent.fn_MainInfo_List();	// 저장 후 화면 refresh
		         	window.close();
	         	}
		     },
	         error: function (xhr, option, error) {
	
	         }
	     });		
	} 

// 	function fn_check_value_event(index, type) {
// 		if(type=='text') { // 결과값(텍스트박스) onkeydown event
// 			if(event.keyCode == 13) { // 엔터키 쳤을때만 tr 감추기
// 				$(checklist[index]).hide(0,function(){
// 					if(index+1 < checklist.length)
// 						$(checklist[index+1]).show(0);
// 				});
// 			}
// 		} else if(type=='checkbox') { // 결과값(체크박스) onchange event
// 			$(checklist[index]).hide(0,function(){
// 				if(index+1 < checklist.length)
// 					$(checklist[index+1]).show(0);
// 			});
// 		} else { // '다음' 버튼 onclick event (값입력 또는 체크 안하고 넘어감)
// 			$(checklist[index]).hide(0,function(){
// 				if(index+1 < checklist.length)
// 					$(checklist[index+1]).show(0);
// 			});
// 		}
// 	}

</script>

<style>
	.divTable{
	display: flex;
	width: 100%;
	}
	.divTableCell {
		border: 1px solid #999999;
		display: table-cell;
		padding: 3px 10px;
		text-align:center;
	}
</style>
	
	<div style="text-align:left;">
	HS-PP-04-A 일일위생점검일지
		<div class="divTable">
			<div class="divTableCell" style="display:inline-block; width:100%;">
	        	<h1>일일위생 점검일지</h1>
	        	<h2 style="text-align:right;">/ 점검주기: 1회/일 이상</h2>
	        	<p style="text-align:right;">/ 작성일: 20   년    월    일   ~   월    일</p>
	        	<p style="text-align:right;">/ 담당팀: 품질관리팀 (정) 최 * * / (부) 이 * *</p>
			</div>
        </div>
<%
	for (int i=0; i<RowCount; i++){  
// 		String[] GV_CHECK_NOTE_ARRAY = TableModel.getValueAt(i, 5).toString().trim().split("_");
// 		String GV_CHECK_GUBUN_MID = "", GV_CHECK_GUBUN_SM = "", GV_CHECK_NOTE = "" ;
// 		if(GV_CHECK_NOTE_ARRAY.length < 2) { // 언더바(_)로 나눠진게 하나일때 == 체크문항만 있을때
// 			GV_CHECK_NOTE = GV_CHECK_NOTE_ARRAY[0];
// 		} else {
// 			GV_CHECK_GUBUN_MID = GV_CHECK_NOTE_ARRAY[0];
// 			if(GV_CHECK_NOTE_ARRAY.length < 3) { // 언더바(_)로 나눠진게 둘일때 == 체크문항, 대분류만 있을때
// 				GV_CHECK_NOTE = GV_CHECK_NOTE_ARRAY[1];
// 			} else {
// 				GV_CHECK_GUBUN_SM = GV_CHECK_NOTE_ARRAY[1];
// 				GV_CHECK_NOTE = GV_CHECK_NOTE_ARRAY[2];
// 			}
// 		}

		String GV_CHECK_GUBUN_MID = TableModel.getValueAt(i, 18).toString().trim() ;
		String GV_CHECK_GUBUN_SM = TableModel.getValueAt(i, 20).toString().trim() ;
		String GV_CHECK_NOTE = TableModel.getValueAt(i, 5).toString().trim() ;
		
		// 구분 중분류와 소분류가 같을때
		if(GV_CHECK_GUBUN_SM.equals(GV_CHECK_GUBUN_MID)) { 
			GV_CHECK_GUBUN_SM = "&nbsp;";
		}
%>	        
		
        <div class="divTable" id="checklist_tr">
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
			
			<div class="divTableCell" style="display:inline-block; width:10%;">
				<h3><%=GV_CHECK_GUBUN_MID%></h3>
				<input type="hidden" class="form-control" id="txt_check_gubun_mid"  readonly value='<%=TableModel.getValueAt(i, 17).toString().trim()%>'></input>
				<input type="hidden" class="form-control" id="txt_check_gubun_mid_name"  readonly value='<%=GV_CHECK_GUBUN_MID%>'></input>
				
			</div>
			<div class="divTableCell" style="display:inline-block; width:25%;">
				<h3><%=GV_CHECK_GUBUN_SM%></h3>
				<input type="hidden" class="form-control" id="txt_check_gubun_sm"  readonly value='<%=TableModel.getValueAt(i, 19).toString().trim()%>'></input>
				<input type="hidden" class="form-control" id="txt_check_gubun_sm_name"  readonly value='<%=GV_CHECK_GUBUN_SM%>'></input>
			</div>
			<div class="divTableCell" style="display:inline-block; width:55%; text-align:left;">
				<h3 style="display:inline-block; margin-right:10px;"><%=GV_CHECK_NOTE%></h3>
				<input type="hidden" class="form-control" id="txt_check_note" readonly value='<%=GV_CHECK_NOTE%>'></input>
				<input type="hidden" class="form-control" id="txt_standard_value" readonly value='<%=TableModel.getValueAt(i, 7).toString().trim()%>'></input>
			</div>
			<div class="divTableCell" style="display:inline-block; width:10%;">
	            <%if(TableModel.getValueAt(i,12).toString().trim().equals("text")){ %>
				<input type="<%=TableModel.getValueAt(i,12).toString().trim()%>"  id="txt_check_value" 
						onkeydown="fn_check_value_event(<%=i%>,'<%=TableModel.getValueAt(i,12).toString().trim()%>')" >
				</input>
				<%} else if(TableModel.getValueAt(i,12).toString().trim().equals("checkbox")){ %>
				<input type="<%=TableModel.getValueAt(i,12).toString().trim()%>"  id="txt_check_value" value="CHECK" 
						onchange="fn_check_value_event(<%=i%>,'<%=TableModel.getValueAt(i,12).toString().trim()%>')" 
						style="width:30px; height:30px; vertical-align:middle;" checked>
						<%=TableModel.getValueAt(i, 7).toString().trim()%>
				</input>
				<%} %>
			</div>
        </div>
<% }%>	<!-- for문 끝 --> 
		<div class="divTable">
			<div class="divTableCell" style="display:inline-block; width: 10%; font-weight: 900; font-size:14px;">부적합/이탈사항</div>
			<div class="divTableCell" style="display:inline-block; width: 90%; font-weight: 900; font-size:14px;">
				<input type="hidden" class="form-control" id="txt_writor_main"  />
				<input type="hidden" class="form-control" id="txt_writor_main_rev"  />
				<input type="hidden" class="form-control" id="txt_improve_note"  />
				<input type="text" class="form-control" id="txt_incong_note"  /> 
			</div>
		</div>
	</div> 
	<div style="width:100%;clear:both">
		<p style="text-align:center;">
			<button id="btn_Save"  class="btn btn-info"  onclick="SaveOderInfo();">저장</button>
			<button id="btn_Canc"  class="btn btn-info"  onclick="window.close();">취소</button>
		</p>
	</div>