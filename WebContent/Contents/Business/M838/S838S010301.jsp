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
	String  GV_JSPPAGE="";

	if(request.getParameter("jspPage")== null)
		GV_JSPPAGE="";
	else
		GV_JSPPAGE = request.getParameter("jspPage");

	String loginID = session.getAttribute("login_id").toString();
	String member_key = session.getAttribute("member_key").toString();
		
%>    
    <script type="text/javascript">
//     웹소켓 통신을 위해서 필요한 변수들 ---시작
	var M838S010300E101 = {
			PID:  "M838S010300E101", 
			totalcnt: 0,
			retnValue: 999,
			colcnt: 0,
			colname: ["","","",""], //insert, Update, Delete 문장을 처리할 때는 사용되지않음
			data: []
	};  
	
	var SQL_Param = {
			PID:  "M838S010300E101", 
			excute: "queryProcess",
			stream: "N",
			param: ""
	};
	var GV_RECV_DATA = "";	//웹소켓 onMessage(event)들어온 데이터를 받는 변수
//  웹소켓 통신을 위해서 필요한 변수들 ---끝	
	var vOrderNo101 = "";

    $(document).ready(function () {
	    // 날짜선택부
        $("#txt_handover_date").datepicker({
        	format: 'yyyy-mm-dd',
        	autoclose: true,
        	language: 'ko'
        });
        $('#txt_accept_period_start').datepicker({
        	format: 'yyyy-mm-dd',
        	autoclose: true,
        	language: 'ko'
        });
        $('#txt_accept_period_end').datepicker({
        	format: 'yyyy-mm-dd',
        	autoclose: true,
        	language: 'ko'
        });
        $("#txt_accept_date").datepicker({
        	format: 'yyyy-mm-dd',
        	autoclose: true,
        	language: 'ko'
        });
        $('#txt_write_date').datepicker({
        	format: 'yyyy-mm-dd',
        	autoclose: true,
        	language: 'ko'
        });
        $('#txt_approve_date').datepicker({
        	format: 'yyyy-mm-dd',
        	autoclose: true,
        	language: 'ko'
        });

        var today = new Date();
        var fromday = new Date();
        fromday.setDate(today.getDate());
        today.setDate(today.getDate()+180);
        
        $('#txt_write_date').datepicker('update', fromday);
        $('#txt_approve_date').datepicker('update', fromday);

        
    });

	
	function SetRecvData(){
		DataPars(M838S010300E101,GV_RECV_DATA);  		
   		parent.fn_MainInfo_List();
 		parent.$('#modalReport').hide();
	}
	
	function SaveOrderInfo() {        
		var WebSockData="";

		var parmHead= '<%=Config.HEADTOKEN %>' ;
		// HACCP에서는 사용하지 않는 값이다.
		//var qa1 = $(':input[name="txt_gubun"]:radio:checked').val();
		//var qa2 = $(':input[name="txt_part_source"]:radio:checked').val();
		var qa1 = "";
		var qa2 = "";
		var qa3 = $(':input[name="txt_RoHS"]:radio:checked').val();
		
		var jArray = new Array(); // JSON Array 선언
		
		if($("#txt_handover").val() == '') { 
			alert("인계자를 선택하세요.");
			return false;
		} 		
		if($("#txt_acceptor").val() == '') { 
			alert("인수자를 선택하세요.");
			return false;
		} 		
		if($("#txt_handover_date").val() == '') { 
			alert("인수일자를 선택하세요.");
			return false;
		} 
		if($("#txt_accept_date").val() == '') { 
			alert("인계일자를 선택하세요.");
			return false;
		} 
		if($("#txt_handover_dept").val() == '') { 
			alert("인계자부서를 선택하세요.");
			return false;
		} 
		if($("#txt_handover_position").val() == '') { 
			alert("인계자직위를 선택하세요.");
			return false;
		} 
		if($("#txt_acceptor_dept").val() == '') { 
			alert("인수자부서를 선택하세요.");
			return false;
		} 
		if($("#txt_acceptor_position").val() == '') { 
			alert("인수자직위를 선택하세요.");
			return false;
		} 
		if($("#txt_accept_period_start").val() == '') { 
			alert("인계시작일자를 선택하세요.");
			return false;
		} 
		if($("#txt_accept_period_end").val() == '') { 
			alert("인계완료일자를 선택하세요.");
			return false;
		} 
		if($("#txt_writor").val() == '') { 
			alert("작성자를 선택하세요.");
			return false;
		} 
		if($("#txt_approval").val() == '') { 
			alert("승인자를 선택하세요.");
			return false;
		} 


   		var dataJson = new Object(); // jSON Object 선언   		
   		dataJson.handover_name       = $("#txt_handover").val();
   		dataJson.handover_rev        = $("#txt_handover_rev").val();
   		dataJson.handover_date       = $("#txt_handover_date").val();
   		dataJson.handover_dept       = $("#txt_handover_dept").val();
   		dataJson.handover_position   = $("#txt_handover_position").val();
   		dataJson.accept_period_start = $("#txt_accept_period_start").val();
   		dataJson.accept_period_end   = $("#txt_accept_period_end").val();
//		dataJson.accept_cause        = $("#txt_accept_cause").val();
   		var cause_str = document.getElementById("txt_accept_cause").value;
   		cause_str = cause_str.replace(/(?:\r\n|\r|\n)/g, '<br/>');
   		dataJson.accept_cause     = cause_str;
// 		dataJson.accept_contents     = $("#txt_accept_contents").val();
   		var contents_str = document.getElementById("txt_accept_contents").value;
   		contents_str = contents_str.replace(/(?:\r\n|\r|\n)/g, '<br/>');
   		dataJson.accept_contents     = contents_str;
   		dataJson.acceptor            = $("#txt_acceptor").val();
   		dataJson.acceptor_rev        = $("#txt_acceptor_rev").val();
   		dataJson.accept_date         = $("#txt_accept_date").val();
   		dataJson.acceptor_dept       = $("#txt_acceptor_dept").val();
   		dataJson.acceptor_position   = $("#txt_acceptor_position").val();
   		dataJson.writor              = $("#txt_writor").val();
   		dataJson.writor_rev          = $("#txt_writor_rev").val();
   		dataJson.write_date          = $("#txt_write_date").val();
   		dataJson.approval            = $("#txt_approval").val();
   		dataJson.approval_rev        = $("#txt_approval_rev").val();
   		dataJson.approve_date        = $("#txt_approve_date").val();
   		dataJson.member_key 		 = "<%=member_key%>";
//		console.log(dataJson);			
		jArray.push(dataJson); // 데이터를 배열에 담는다.
        
		var dataJsonMulti = new Object();
 		dataJsonMulti.param = jArray; // Array를 다시 Object형태로 변환 {"param":{Array...}}
 		
		var work_complete_insert_check = confirm("등록하시겠습니까?");
		if(work_complete_insert_check == false)   return;
	      
		var JSONparam = JSON.stringify(dataJsonMulti); // JSON Object전송을 위해 문자열형태로 바꿔줌(stringify)
		SendTojsp(JSONparam, SQL_Param.PID); // SendToJSP를 통해 ajax로 데이터(JSONObject,PID) 보냄
	}

	function SendTojsp(bomdata, pid){		
	    $.ajax({
	         type: "POST",
	         dataType: "json", // Ajax로 json타입으로 보낸다.
	         url: "<%=Config.this_SERVER_path%>/Contents/CommonView/insert_update_delete_json.jsp", 
	         data:  {"bomdata" : bomdata, "pid" : pid },
	         beforeSend: function () {
//	         	 alert(bomdata);
	         },
	         success: function (html) {	
	        		 parent.fn_MainInfo_List();
	 	             parent.$("#ReportNote").children().remove();
	 	         	 parent.$('#modalReport').hide(); 
	 	         	 console.log("성공");
	         },
	         error: function (xhr, option, error) {
	        	 console.log("인수자, 인계자, 인수사유 중복");
	         }
	     });		
	}  

    function fn_CommonPopupModal(sUrl, name, w, h) { // url, name, width, height, 기타 속성(생략해도 무방)     	
        var popupWin = window.showModalDialog(sUrl, name, 'dialogWidth:' + w + 'px; dialogHeight:' + h 
                + 'px; center:yes; help:no; status:no; resizable:no; scroll:yes; toolbar :no;');
    	if(typeof(popupWin)=="undefine")
    		popupWin = window.returnValue;
		return popupWin;
    }  
    
    function SetCustName_code(name, code, rev){
		$('#txt_custname').val(name);
		$('#txt_custcode').val(code);
		$('#txt_cust_rev').val(rev);

		
    }
    function SetUser_Select(user_id, revision_no, user_nm){
//    	console.log("??? : " + user_id +" ~ "+ revision_no + " ~ " + user_nm);
		$("#"+ rowId).val(user_nm);
		$("#"+ rowId + "_rev").val(revision_no);
	}

</script>    
<div style="overflow-y:scroll;">
	<table class="table table-bordered" style="width: 100%; margin: 0 auto; align:left;  ">
	   	<tr>   
			<td style="width: 47%;">
				<table class="table " style="width: 100%; margin: 0 auto; align:left">
					<tr style="background-color: #fff;">
						<td style=" font-weight: 900; font-size:14px; text-align:left">인계자</td>
						<td style="width: 38%; font-weight: 900; font-size:14px; text-align:left">
							<input type="text" class="form-control" id="txt_handover" style="width: 200px; float:left" readonly />
							<input type="text" class="form-control" id="txt_handover_rev" style="width: 200px; float:left; display:none" readonly />
							<button type="button" onclick="parent.pop_fn_UserList_View(2, 'txt_handover')" id="btn_SearchUser" class="btn btn-info" style="float:left"> 검색</button> 
						</td>
						<td style=" font-weight: 900; font-size:14px; text-align:left">인계일</td>
						<td><input type="text" data-date-format="yyyy-mm-dd" id="txt_handover_date" class="form-control" style="width: 200px; border: solid 1px #cccccc;" readonly/></td>
					</tr>
					<tr style="background-color: #fff;">
						<td style=" font-weight: 900; font-size:14px; text-align:left">인계자부서</td>
						<td style="width: 38%; font-weight: 900; font-size:14px; text-align:left">
							<input type="text" class="form-control" id="txt_handover_dept" style="width: 200px; float:left"/> 
						</td>
						<td style=" font-weight: 900; font-size:14px; text-align:left">인계자직위</td>
						<td style="width: 38%; font-weight: 900; font-size:14px; text-align:left">
							<input type="text" class="form-control" id="txt_handover_position" style="width: 200px; float:left"/> 
						</td>
					</tr>
					<tr style="background-color: #fff;">
						<td style=" font-weight: 900; font-size:14px; text-align:left">인수자</td>
						<td style="width: 38%; font-weight: 900; font-size:14px; text-align:left">
							<input type="text" class="form-control" id="txt_acceptor" style="width: 200px; float:left" readonly />
							<input type="text" class="form-control" id="txt_acceptor_rev" style="width: 200px; float:left; display:none" readonly />
							<button type="button" onclick="parent.pop_fn_UserList_View(2, 'txt_acceptor')" id="btn_SearchUser" class="btn btn-info" style="float:left"> 검색</button> 
						</td>		
						<td style="width: 16%; font-weight: 900; font-size:14px; text-align:left">인수일자</td>
						<td ><input type="text" data-date-format="yyyy-mm-dd" id="txt_accept_date" class="form-control" style="width: 200px; border: solid 1px #cccccc;" readonly/></td>					
					</tr>
					<tr style="background-color: #fff;">
						<td style=" font-weight: 900; font-size:14px; text-align:left">인수자부서</td>
						<td style="width: 38%; font-weight: 900; font-size:14px; text-align:left">
							<input type="text" class="form-control" id="txt_acceptor_dept" style="width: 200px; float:left"/> 
						</td>
						<td style=" font-weight: 900; font-size:14px; text-align:left">인수자직위</td>
						<td style="width: 38%; font-weight: 900; font-size:14px; text-align:left">
							<input type="text" class="form-control" id="txt_acceptor_position" style="width: 200px; float:left"/> 
						</td>
					</tr>
					<tr style="background-color: #fff;">
						<td style="width: 16%; font-weight: 900; font-size:14px; text-align:left">인계시작일자</td>
						<td ><input type="text" data-date-format="yyyy-mm-dd" id="txt_accept_period_start" class="form-control" style="width: 200px; border: solid 1px #cccccc;" readonly/></td>
						<td style="width: 16%; font-weight: 900; font-size:14px; text-align:left">인계완료일자</td>
						<td ><input type="text" data-date-format="yyyy-mm-dd" id="txt_accept_period_end" class="form-control" style="width: 200px; border: solid 1px #cccccc;" readonly/></td>					
					</tr>
					<tr style="background-color: #fff;">
						<td style=" font-weight: 900; font-size:14px; text-align:left">작성자명</td>
						<td style="width: 38%; font-weight: 900; font-size:14px; text-align:left">
							<input type="text" class="form-control" id="txt_writor" style="width: 200px; float:left" readonly />
							<input type="text" class="form-control" id="txt_writor_rev" style="width: 200px; float:left; display:none" readonly />
							<button type="button" onclick="parent.pop_fn_UserList_View(2, 'txt_writor')" id="btn_SearchUser" class="btn btn-info" style="float:left"> 검색</button> 
						</td>					
						<td style="width: 16%; font-weight: 900; font-size:14px; text-align:left">작성일자</td>
						<td ><input type="text" data-date-format="yyyy-mm-dd" id="txt_write_date" class="form-control" style="width: 200px; border: solid 1px #cccccc;" readonly/></td>										
					</tr>
					<tr style="background-color: #fff;">
						<td style=" font-weight: 900; font-size:14px; text-align:left">승인자명</td>
						<td style="width: 38%; font-weight: 900; font-size:14px; text-align:left">
							<input type="text" class="form-control" id="txt_approval" style="width: 200px; float:left" readonly />
							<input type="text" class="form-control" id="txt_approval_rev" style="width: 200px; float:left; display:none" readonly />
							<button type="button" onclick="parent.pop_fn_UserList_View(2, 'txt_approval')" id="btn_SearchUser" class="btn btn-info" style="float:left"> 검색</button> 
						</td>					
						<td style="width: 16%; font-weight: 900; font-size:14px; text-align:left">승인일자</td>
						<td ><input type="text" data-date-format="yyyy-mm-dd" id="txt_approve_date" class="form-control" style="width: 200px; border: solid 1px #cccccc;" readonly/></td>										
					</tr>
					<tr style="background-color: #fff" >
						<td style=" font-weight: 900; font-size:14px; text-align:left" colspan="4">인수사유</td>
					</tr>
					<tr>
						<td colspan="4"><textarea class="form-control" id="txt_accept_cause"  style="cols:10;rows:4; height:50px; resize:none;" ></textarea></td>
					</tr>
					<tr style="background-color: #fff" >
						<td style=" font-weight: 900; font-size:14px; text-align:left" colspan="4">인수내용</td>
					</tr>
					<tr>
						<td colspan="4"><textarea class="form-control" id="txt_accept_contents"  style="cols:10;rows:4; height:250px; resize:none;" ></textarea></td>
					</tr>
				</table>
			</td>
		</tr>		
        <tr style="height: 60px">
			<td align="center" colspan="2">
				<p>
					<button id="btn_Save"  class="btn btn-info" style="width: 100px" onclick="SaveOrderInfo();">저장</button>
					<button id="btn_Canc"  class="btn btn-info" style="width: 100px" onclick="parent.$('#modalReport').hide();">취소</button>
				</p>
			</td>
		</tr>
	</table>
</div>
