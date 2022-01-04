<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*,java.util.*,javax.servlet.http.*"%>
<%@ page import="mes.client.comm.*" %>
<%@ page import="mes.client.common.*" %>
<%@ page import="mes.client.guiComponents.*" %>
<%@ page import="mes.client.util.*" %>
<%@ page import="mes.client.conf.*" %>
<%@ page import="org.json.simple.*"%><%@ include file="/strings.jsp" %>
<%
	String loginID = session.getAttribute("login_id").toString();
	String member_key = session.getAttribute("member_key").toString();
	DoyosaeTableModel TableModel;

	String zhtml = "";
	
	String[] strColumnHead = {""};
	
	String MEMBER_KEY = "", CODE_CD = "", CENSOR_NO = "";

	if(request.getParameter("member_key") == null)
		MEMBER_KEY = "";
	else
		MEMBER_KEY = request.getParameter("member_key");
	
	if(request.getParameter("code_cd") == null)
		CODE_CD = "";
	else
		CODE_CD = request.getParameter("code_cd");
	
	if(request.getParameter("censor_no") == null)
		CENSOR_NO = "";
	else
		CENSOR_NO = request.getParameter("censor_no");
	
	JSONObject jArray = new JSONObject();
	jArray.put("member_key", member_key);
	jArray.put("code_cd", CODE_CD);
	jArray.put("censor_no", CENSOR_NO);
	
	Vector Censor_Type_Vector = CommonData.getCensorType(jArray);
	
	TableModel = new DoyosaeTableModel("M909S170100E204", strColumnHead, jArray);
    int ColCount =TableModel.getColumnCount();
    CurrentPage jspPageName = new CurrentPage(request.getRequestURI());
    String JSPpage = jspPageName.GetJSP_FileName();
	
    // 데이터를 가져온다.
    Vector Delete_Target_Vector = (Vector)(TableModel.getVector().get(0));
    
    jArray.put("code_value", Delete_Target_Vector.get(3).toString().trim());
    
    DBServletLink dbServletLink = new DBServletLink();
	dbServletLink.connectURL("M909S170100E996");
    Vector CodeValueTable = dbServletLink.doQuery(jArray, false);
    
    String ResultOfCodeValueTable = ((Vector)CodeValueTable.get(0)).get(0).toString();
%>

<script type="text/javascript">
	// 웹소켓 통신을 위해서 필요한 변수들 ---시작
	var M909S170100E103 = {
			PID:  "M909S170100E103", 
			totalcnt: 0,
			retnValue: 999,
			colcnt: 0,
			colname: ["","","",""], //insert, Update, Delete 문장을 처리할 때는 사용되지않음
			data: []
	};  
	
	var SQL_Param = {
			PID:  "M909S170100E103", 
			excute: "queryProcess",
			stream: "N",
			param: ""
	};
	var GV_RECV_DATA = "";	//웹소켓 onMessage(event)들어온 데이터를 받는 변수
	// 웹소켓 통신을 위해서 필요한 변수들 ---끝	
    var detail_seq=1;
	
	function SaveOderInfo() {        
		var work_complete_delete_check = confirm("삭제하시겠습니까?");
		if(work_complete_delete_check == false)	{
			return;
		}
		
		var delete_check = confirm("선택한 센서정보를 삭제합니다." + "\n" + "삭제하시겠습니까?");
		
		if(delete_check) {
			var dataJson = new Object();

			dataJson.member_key		= "<%=member_key%>";
			dataJson.censor_no		= $('#txt_CensorNo').val();
			dataJson.censor_channel	= $('#txt_CensorChannel').val();
			dataJson.censor_name	= $('#txt_CensorName').val();
			dataJson.censor_type	= $('#txt_CensorType').val();
			dataJson.censor_cycle	= $('#txt_CensorCycle').val();
			dataJson.censor_loc		= $('#txt_CensorLocation').val();
		
			var JSONparam = JSON.stringify(dataJson); // JSON Object전송을 위해 문자열형태로 바꿔줌(stringify)
			
			SendTojsp(JSONparam, "M909S170100E103");
		}
	}
	
	function SendTojsp(bomdata, pid){
		
	    $.ajax({
	         type: "POST",
	         dataType: "json", // Ajax로 json타입으로 보낸다.
	     	 url: "<%=Config.this_SERVER_path%>/Contents/CommonView/insert_update_delete_json.jsp", // insert_update_delete_json.jsp로 연결
	     	 data:  {"bomdata" : bomdata, "pid" : pid },
	         success: function (html) {	 
	        	 if(html > -1){
	        	   	parent.fn_MainInfo_List();
	                parent.$("#ReportNote").children().remove();
	                $('#modalReport').modal('hide');
	         	}
	         }
	     });
	    
	    vCensorNo = "";
	}  
</script>
</head>
<body>
<!-- <form name="form1S909S050101" method="post" enctype="multipart/form-data" action="">  -->
<table class="table table-hover" style="width: 100%; margin: 0 auto; align:left">
	<tr style="background-color: #fff; height: 40px">
		<td>센서No</td>
		<td> </td>
		<td>
			<input type="text" class="form-control" id="txt_CensorNo" style="width: 200px; float:left"
			value = "<%=Delete_Target_Vector.get(0).toString()%>" readonly />
		</td>
	</tr>

	<tr style="background-color: #fff; height: 40px">
		<td>센서채널번호</td>
		<td> </td>
		<td>
			<input type="text" class="form-control" id="txt_CensorChannel" style="width: 200px; float:left"
			value = "<%=Delete_Target_Vector.get(1).toString()%>" readonly />
		</td>
	</tr>

	<tr style="background-color: #fff; height: 40px">
		<td>센서이름</td>
		<td> </td>
		<td>
			<input type="text" class="form-control" id="txt_CensorName" style="width: 200px; float:left"
			value = "<%=Delete_Target_Vector.get(2).toString()%>" readonly />
		</td>
	</tr>

	<tr style="background-color: #fff; height: 40px">
		<td>센서데이터유형</td>
		<td></td>
		<td>
			<input type="text" class="form-control" id="txt_CensorType" style="width: 200px; float:left"
			value = "<%=ResultOfCodeValueTable%>" readonly />
		</td>
	</tr>

	<tr style="background-color: #fff; height: 40px">
		<td>데이터수집주기</td>
		<td> </td>
		<td>
			<input type="text" class="form-control" id="txt_CensorCycle" style="width: 200px; float:left"
			value = "<%=Delete_Target_Vector.get(4).toString()%>" readonly />
		</td>
	</tr>

	<tr style="background-color: #fff; height: 40px">
		<td>센서위치</td>
		<td> </td>
		<td>
			<input type="text" class="form-control" id="txt_CensorLocation" style="width: 200px; float:left"
			value = "<%=Delete_Target_Vector.get(5).toString()%>" readonly />
		</td>
	</tr>
</table>