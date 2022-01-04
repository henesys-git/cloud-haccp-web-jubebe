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
	String loginID = session.getAttribute("login_id").toString();
	String member_key = session.getAttribute("member_key").toString();

	//로그인한 아이디의 개정번호(rev)를 가져오는 벡터
	Vector UserIDrev = CommonData.getUserRevDataID(loginID,member_key);
	Vector optCodeVector = (Vector)UserIDrev.get(0); 
	String optCode =  optCodeVector.get(0).toString();


	DoyosaeTableModel TableModel;

	CurrentPage jspPageName = new CurrentPage(request.getRequestURI());

	/* String GV_CHECK_DATE = "";
	
	if(request.getParameter("check_date")== null)
		GV_CHECK_DATE = "";
	else
		GV_CHECK_DATE = request.getParameter("check_date"); */
	
	JSONObject jArray = new JSONObject();
	//jArray.put( "check_date", GV_CHECK_DATE);
	jArray.put( "member_key", member_key);

	/* Vector Part_Info_List2 = CommonData.Get_Part_Info_List(member_key);
	
	Vector Part_Code_List				= (Vector)Part_Info_List2.get(0);
	Vector Part_Name_List				= (Vector)Part_Info_List2.get(1);
	Vector Company_Code_List			= (Vector)Part_Info_List2.get(2);
	Vector Company_Name_List			= (Vector)Part_Info_List2.get(3);
	Vector Company_Address_List			= (Vector)Part_Info_List2.get(4);
	Vector Company_Revision_Number_List	= (Vector)Part_Info_List2.get(5);
	
	int Vector_Size2 = Part_Code_List.size(); */
	int index = 0;
	int jindex = 0;
	int kindex = 0;
	
	DBServletLink dbServletLink = new DBServletLink();
    dbServletLink.connectURL("M838S060700E904");
    
    Vector Part_Info_List = dbServletLink.doQuery(jArray, false);
    int Vector_Size = Part_Info_List.size();
    
    System.out.println("??????????????????????" + Part_Info_List.toString() + "##########################");
	
%>

<script type="text/javascript">
	// 웹소켓 통신을 위해서 필요한 변수들 ---시작
	var SQL_Param = {
			PID:  "M838S060700E101", 
			excute: "queryProcess",
			stream: "N",
			param: ""
	};
	//웹소켓 통신을 위해서 필요한 변수들 ---끝	

	var check_date_year;
	var check_date_month;
	var check_date_day;
	
	var Data_List = "<%=Part_Info_List.toString()%>";
	var Data_List_Size = <%=Vector_Size%>;
	var temp_Data_List1 = Data_List.substring(2,Data_List.length-2);
	var temp_Data_List2 = replaceAll(temp_Data_List1,'], [','|');
	//var temp_Data_List2 = replaceAll(temp_Data_List1,'], [','|').concat('|');
	
	
	//temp_Data_List2 = temp_Data_List2.concat('|');
	// var temp_Data_List2 = temp_Data_List1.replace(/\], [\/gi,'|');
	
	var split_Data_List = temp_Data_List2.split('|');
	var result_Data_List = new Array(Data_List_Size);
	
	for( i = 0 ; i < Data_List_Size ; i++ )
	{
		result_Data_List[i] = new Array(8);
		
		for( j = 0 ; j < 7 ; j++ ) // 마지막 자리(8번째)는 사용자가 입력하는 값을 저장한다.
		{
			result_Data_List[i][j] = split_Data_List[i].split(', ')[j].trim();
		}
	}
	
	for( i = 0 ; i < Data_List_Size ; i++ )
	{
		
		for( j = 0 ; j < 7 ; j++ )
		{
			console.log("[" + i + "]" + "[" + j + "]"+ "번째 요소???" + result_Data_List[i][j] + "&&&");
		}
	}
	
	for( i = 0 ; i < split_Data_List.length ; i++ )
	{
		console.log(i + "번째 요소???" + split_Data_List[i] + "&&&");
	}
	
	console.log("Data_List:" + Data_List + "???");
	console.log("temp_Data_List2:" + temp_Data_List2 + "~~~");
	
	var checklist_tr;
	
	$(document).ready(function () {
		// 숫자만
	    $("input:text[numberOnly]").on("keyup", function() {
	        $(this).val($(this).val().replace(/[^0-9]/g,""));
	    });
		
		new SetSingleDate2("","#txt_check_date",0);
		
		var today = new Date();

		
		$("#txt_writor_main").val("<%=loginID%>"); //로그인한 유저
		$("#txt_writor_main_rev").val("<%=optCode%>"); //로그인한 유저rev		
		
		var today = new Date();
		
		check_date_year = today.getFullYear();
		check_date_month = today.getMonth() + 1;
		check_date_day = today.getDate();
		console.log("1" + check_date_year + "1")
		console.log("2" + check_date_month + "2")
		console.log("3" + check_date_day + "3")
		console.log(check_date_year + "년 " + check_date_month + "월 " + check_date_day + "일");
		//$("#checkdate2").text(today.getFullYear() + "년 " + today.getMonth() + 1 + "월 " + today.getDate() + "일");
		$("#checkdate2").text(check_date_year + "년 " + check_date_month + "월 " + check_date_day + "일");
		Part_List_Maker();
		
		
		
	});
	
	function replaceAll(str, searchStr, replaceStr) {
		  return str.split(searchStr).join(replaceStr);
		}
	
	function Input_Data()
	{
		for( i = 0 ; i < Data_List_Size ; i++ )
		{
			for( j = 0 ; j < 7 ; j++ )
			{
				$(checklist_tr[i]).find('td').eq(j).text(result_Data_List[i][j]);
				console.log("[" + i + "][" + j + "] 번째에 입력된 요소" + $(checklist_tr[i]).find('td').eq(j).text() + "???");
			}
		}
	}
	
	function Part_List_Maker()
	{
		checklist_tr = $("#part_check_table_body tr");
		//var checklist_td;
		
		var tr_count = checklist_tr.length;
		
		for( var i = 0 ; i < Data_List_Size ; i++ )
		{
			var htmlAppend =
				"<tr>"
	       		+ "<td style='border-color: black; display:none' id='part_code_value'></td>"
	       		+ "<td style='border-color: black; ' id='part_name_value'></td>"
	       		+ "<td style='border-color: black; display:none' id='company_code_value'></td>"
	       		+ "<td style='border-color: black; ' id='company_name_value'></td>"
	       		+ "<td style='border-color: black; ' id='company_address_value'></td>"
	       		+ "<td style='border-color: black; display:none' id='company_revision_number_value'></td>"
	       		+ "<td style='border-color: black; display:none' id='MK'></td>"
	       		+ "<td style='border-color: black; '>"
	       		+ "	<input type='text' id='txt_part_check_value' value='없음'" 
	       		+ "			style='width:90%; height:30px; vertical-align:middle;' ></input>"
	       		+ "</td>"
	       		+ "</tr>"
	       		;
			/* var htmlAppend =
				"<tr>"
	       		+ "<td style='border-color: black; display:none' id='part_code_value'></td>"
	       		+ "<td style='border-color: black; ' id='part_name_value'></td>"
	       		+ "<td style='border-color: black; display:none' id='company_code_value'></td>"
	       		+ "<td style='border-color: black; ' id='company_name_value'></td>"
	       		+ "<td style='border-color: black; ' id='company_address_value'></td>"
	       		+ "<td style='border-color: black; display:none' id='company_revision_number_value'></td>"
	       		+ "<td style='border-color: black; display:none' id='MK'></td>"
	       		+ "<td style='border-color: black; '>"
	       		+ "	<input type='text' id='txt_part_check_value" + i + "' value='없음'" 
	       		+ "			style='width:90%; height:30px; vertical-align:middle;' ></input>"
	       		+ "</td>"
	       		+ "</tr>"
	       		; */
	       	
			$("#part_check_table_body").append(htmlAppend);
			checklist_tr = $("#part_check_table_body tr");
		}
		
		Input_Data();
	}

	function SaveOderInfo() {
		// check_date, check_time 체크 날짜 세팅
		var today = new Date(); // 오늘날짜
		var write_date 	= today.getFullYear() 
						+ "-" + ("0" + (today.getMonth() + 1)).slice(-2) 
						+ "-" + ("0" + today.getDate()).slice(-2) ;
			
	    if($("#txt_check_date").val().length > write_date) { // 오늘 날짜보다 뒤의 날짜를 선택했을 경우 
	    	alert("점검일이 오늘 날짜보다 뒤일 수 없습니다.");
	    	return;
	    }
		
	    var jArray = new Array(); // JSON Array 선언
	    
	    checklist_tr = $("#part_check_table_body tr");
	    
	    for(var i = 0 ; i < checklist_tr.length ; i++ ){
			
			// JSON 파라미터 세팅
			var dataJson = new Object(); // jSON Object 선언 
			
			dataJson.part_code_value				= $(checklist_tr[i]).find("#part_code_value").text();
			dataJson.part_name_value				= $(checklist_tr[i]).find("#part_name_value").text();
			dataJson.company_code_value				= $(checklist_tr[i]).find("#company_code_value").text();
			dataJson.company_name_value				= $(checklist_tr[i]).find("#company_name_value").text();
			dataJson.company_address_value			= $(checklist_tr[i]).find("#company_address_value").text();
			dataJson.company_revision_number_value	= $(checklist_tr[i]).find("#company_revision_number_value").text();
			dataJson.member_key						= "<%=member_key%>";
			dataJson.part_check_value				= $(checklist_tr[i]).find('#txt_part_check_value').val();
			dataJson.check_date						= $("#txt_check_date").val();
			
			jArray.push(dataJson); // 데이터를 배열에 담는다.
	    }
		  
	    var dataJsonMulti = new Object();
 		dataJsonMulti.param = jArray; // Array를 다시 Object형태로 변환 {"param":{Array...}}

		var JSONparam = JSON.stringify(dataJsonMulti); // JSON Object전송을 위해 문자열형태로 바꿔줌(stringify)
		
		var chekrtn = confirm("등록하시겠습니까?"); 
		
		if(chekrtn){
 			console.log(JSONparam);
			SendTojsp(JSONparam, SQL_Param.PID); // SendToJSP를 통해 ajax로 데이터(JSONObject,PID) 보냄
		}
	}

function test(){
	for( i = 0 ; i < Data_List_Size ; i++ )
	{
		for( j = 0 ; j < 7 ; j++ )
		{
			console.log("[" + i + "][" + j + "] 번째에 입력된 요소" + $(checklist_tr[i]).find('td').eq(j).text() + "???");
		}
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
	         /* success: function (html) {	
	        	if(html>-1){
	        		opener.parent.fn_MainInfo_List();
		         	window.close();
	         	}
	         }, */
	         success: function (html) {
	        	 if(html>-1){
	        	   	parent.fn_MainInfo_List();
	                parent.$("#ReportNote").children().remove();
	                $('#modalReport').modal('hide');
	         	}
	         },
	         error: function (xhr, option, error) {
	
	         }
	     });		
	}
</script>


<table style="width: 98%; margin: 0 auto; border-color: black; ">
	<tr>
		<td style="font-size: 30px; text-align: center;" colspan="3">원재료 매입업체 위반사항 점검표</td>
	</tr>
	<tr>
		<td style="font-size: 14px; text-align: right;" >점검일자 : &nbsp;</td>
		<td style="width: 110px;  font-weight: 900; font-size:14px; vertical-align: middle ;text-align:left">
			<input type="text" class="form-control" data-date-format="yyyy-mm-dd" id="txt_check_date" readonly/>
		</td>
	</tr>
</table>

<div style="overflow-y:auto; width:100%; height:500px;">
<table class="table table-bordered" style="width: 98%; margin: 0 auto; text-align:center; height:450px; overflow-y: auto; border-color: black;"  id="process_check_table">
	<thead style="background-color:#A6A6A6;">
		<tr style="font-weight:900;">
			<td style="border-color: black; width:0%; height:3px; vertical-align: middle; display:none">제품코드</td>
			<td style="border-color: black; width:15%; height:3px; vertical-align: middle;">제품명</td>
			<td style="border-color: black; width:0%; height:3px; vertical-align: middle; display:none">제조회사코드</td>
			<td style="border-color: black; width:15%;  height:3px; vertical-align: middle;">제조원</td>
			<td style="border-color: black; width:40%;  height:3px; vertical-align: middle;">주소</td>
			<td style="border-color: black; width:0%; height:3px; vertical-align: middle; display:none">개정번호</td>
			<td style="border-color: black; width:0%; height:3px; vertical-align: middle; display:none">멤버키</td>
			<td style="border-color: black; width:30%;  height:3px; vertical-align: middle;">위반사항</td>
		</tr>
	</thead>
	<tbody id="part_check_table_body">
	</tbody>
</table>
</div>
	<div style="width:100%;clear:both">
		<p style="text-align:center;">
			<button id="btn_Save" class="btn btn-info"  onclick="SaveOderInfo();">저장</button>
			<button id="btn_Canc" class="btn btn-info"  onclick="$('#modalReport').modal('hide');">취소</button>
		</p>
	</div>