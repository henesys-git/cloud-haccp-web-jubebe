<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*,java.util.*,javax.servlet.http.*"%>
<%@ page import="mes.client.comm.*" %>
<%@ page import="mes.client.common.*" %>
<%@ page import="mes.client.guiComponents.*" %>
<%@ page import="mes.client.util.*" %>
<%@ page import="mes.client.conf.*" %>
<%@ page import="org.json.simple.*"%><%@ include file="/strings.jsp" %>
<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1" >
<%
	String loginID = session.getAttribute("login_id").toString();
	String member_key = session.getAttribute("member_key").toString();
	
// 	// 로그인한 사용자의 정보
// 	JSONObject jArrayUser = new JSONObject();
// 	jArrayUser.put( "member_key", member_key);
// 	jArrayUser.put( "USER_ID", loginID);
// 	DoyosaeTableModel TableModelUser = new DoyosaeTableModel("M909S080100E107", jArrayUser);
// 	int RowCountUser =TableModelUser.getRowCount();
// 	String loginIDrev = "",loginIDjikwi="",loginIDdept = "";
// 	if(RowCountUser > 0) {
// 		loginIDrev = TableModelUser.getValueAt(0, 1).toString().trim();
// 		loginIDjikwi = TableModelUser.getValueAt(0, 5).toString().trim();
// 		loginIDdept = TableModelUser.getValueAt(0, 10).toString().trim();
// 	} else {
// 		loginIDrev = "0";
// 	}
	
	String GV_CHECK_DATE="",GV_CHECK_TIME="",GV_CUST_CD="",GV_CUST_CD_REV="" ;

	if(request.getParameter("check_date")== null)
		GV_CHECK_DATE="";
	else
		GV_CHECK_DATE = request.getParameter("check_date");	
	
	if(request.getParameter("check_time")== null)
		GV_CHECK_TIME="";
	else
		GV_CHECK_TIME = request.getParameter("check_time");
	
	if(request.getParameter("cust_cd")== null)
		GV_CUST_CD="";
	else
		GV_CUST_CD = request.getParameter("cust_cd");
	
	if(request.getParameter("cust_cd_rev")== null)
		GV_CUST_CD_REV="";
	else
		GV_CUST_CD_REV = request.getParameter("cust_cd_rev");
	
	JSONObject jArray = new JSONObject();
	jArray.put( "member_key", member_key);
	jArray.put( "check_date", GV_CHECK_DATE);
	jArray.put( "check_time", GV_CHECK_TIME);
	jArray.put( "cust_cd", GV_CUST_CD);
	jArray.put( "cust_cd_rev", GV_CUST_CD_REV);

	DoyosaeTableModel TableModel;
	TableModel = new DoyosaeTableModel("M838S050300E124", jArray);
	int RowCount =TableModel.getRowCount();
%>
 
<%-- <jsp:include page="../../Common/linkcss_js.jsp" flush="false"/> --%>
        
    <script type="text/javascript">
//     웹소켓 통신을 위해서 필요한 변수들 ---시작
	var SQL_Param = {
			PID: "M838S050300E103",
			excute: "queryProcess",
			stream: "N",
			param: + "|"
	};
//  웹소켓 통신을 위해서 필요한 변수들 ---끝	
	
	var vTableInoutCheck;
	var TableInoutCheck_info;
    var TableInoutCheck_RowCount;
	
	$(document).ready(function () {
<%-- 		$("#txt_checker_main").val("<%=loginID%>"); //로그인한 유저 --%>
<%-- 		$("#txt_checker_main_rev").val("<%=loginIDrev%>"); //로그인한 유저rev --%>
<%-- 		$("#txt_checker_dept").val("<%=loginIDdept%>"); //로그인한 유저 소속 --%>
<%-- 		$("#txt_checker_title").val("<%=loginIDjikwi%>"); //로그인한 유저 직위 --%>
		
		vTableInoutCheck=$('#inout_check_table').DataTable({    
    		scrollX: true,
    		scrollY: 500,
//   	    scrollCollapse: true,
    	    paging: false,
    	    searching: false,
    	    ordering: false,
    	    order: [[ 0, "asc" ]],
    	    keys: false,
    	    info: true,
	  		columnDefs: [
	  			{
		       		'targets': [0],
		       		'createdCell':  function (td) {
		          			$(td).attr('style', 'width:40%;'); 
		       		}
				},
				{
		       		'targets': [1],
		       		'createdCell':  function (td) {
		          			$(td).attr('style', 'width:60%;'); 
		       		}
				}
			],
            language: { 
                url:"<%=Config.this_SERVER_path%>/AdminLTE-3.0.5/localisation/Korean.json"
            }		    	  	
		});	
		
		TableInoutCheck_info = vTableInoutCheck.page.info();
		TableInoutCheck_RowCount = TableInoutCheck_info.recordsTotal;
	});
	
	function SaveOderInfo() {
	    var jArray = new Array(); // JSON Array 선언
	    
	    TableInoutCheck_info = vTableInoutCheck.page.info();
		TableInoutCheck_RowCount = TableInoutCheck_info.recordsTotal;
	    
	    for(var i=0; i<TableInoutCheck_RowCount; i++){
			// JSON 파라미터 세팅
			var dataJson = new Object(); // jSON Object 선언 
			
			dataJson.cust_cd 	 = $("#txt_cust_cd").val();
			dataJson.cust_cd_rev = $("#txt_cust_cd_rev").val();
			
			dataJson.check_date  = $("#txt_check_date").val();
			dataJson.check_time  = $("#txt_check_time").val();
			
			dataJson.member_key = "<%=member_key%>";
			
			jArray.push(dataJson); // 데이터를 배열에 담는다.
	    }
		  
	    var dataJsonMulti = new Object();
 		dataJsonMulti.param = jArray; // Array를 다시 Object형태로 변환 {"param":{Array...}}

		var JSONparam = JSON.stringify(dataJsonMulti); // JSON Object전송을 위해 문자열형태로 바꿔줌(stringify)
		
// 		console.log(JSONparam);
		var work_complete_delete_check = confirm("삭제하시겠습니까?");
		if(work_complete_delete_check == false)   return;
		
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
	        	 if(html>-1){
	        	   	parent.fn_MainInfo_List();
	        	   	vCheckDate="";
	        	   	parent.fn_DetailInfo_List();
	                parent.$("#ReportNote").children().remove();
	         		parent.$('#modalReport').hide();
	         	}
	         },
	         error: function (xhr, option, error) {
	         }
	     });		
	}
	
    </script>
</head>
<body>
	<table class="table" style="width: 100%; margin: 0 auto; align:left">
		<tr>
            <td style="width: 150px; font-weight: 900; font-size:14px; vertical-align: middle ; text-align:left">업소명</td>
            <td style="width: auto;  font-weight: 900; font-size:14px; vertical-align: middle ;text-align:left" colspan="2">
				<input type="text" class="form-control" id="txt_cust_nm" readonly value='<%=TableModel.getValueAt(0, 24).toString().trim()%>'/>
				<input type="hidden" class="form-control" id="txt_cust_cd" readonly value='<%=TableModel.getValueAt(0, 21).toString().trim()%>'/>
				<input type="hidden" class="form-control" id="txt_cust_cd_rev" readonly value='<%=TableModel.getValueAt(0, 22).toString().trim()%>'/>
				<input type="hidden" class="form-control" id="txt_boss_name" readonly value='<%=TableModel.getValueAt(0, 25).toString().trim()%>'/>
				<input type="hidden" class="form-control" id="txt_jongmok" readonly value='<%=TableModel.getValueAt(0, 26).toString().trim()%>'/>
				<input type="hidden" class="form-control" id="txt_bizno" readonly value='<%=TableModel.getValueAt(0, 27).toString().trim()%>'/>
				<input type="hidden" class="form-control" id="txt_address" readonly value='<%=TableModel.getValueAt(0, 28).toString().trim()%>'/>
				<input type="hidden" class="form-control" id="txt_telno" readonly value='<%=TableModel.getValueAt(0, 29).toString().trim()%>'/>
           	</td>
<!--            	<td style="width: 150px; font-weight: 900; font-size:14px; vertical-align: middle ; text-align:left"> -->
<!--            		<button type="button" onclick="parent.pop_fn_CustName_View(2,'O')" id="btn_SearchCust" class="btn btn-info" style="float:left"> -->
<!-- 					    검색</button> -->
<!--            	</td> -->
		</tr>
		<tr>
           	<td style="width: 150px; font-weight: 900; font-size:14px; vertical-align: middle ; text-align:left">점검목적</td>
            <td style="width: auto;  font-weight: 900; font-size:14px; vertical-align: middle ;text-align:left" colspan="2">
				<input type="text" class="form-control" id="txt_check_object" readonly value='<%=TableModel.getValueAt(0, 23).toString().trim()%>'/>
				<input type="hidden" class="form-control" id="txt_checker_main" readonly value='<%=TableModel.getValueAt(0, 14).toString().trim()%>'/>
				<input type="hidden" class="form-control" id="txt_checker_main_rev" readonly value='<%=TableModel.getValueAt(0, 15).toString().trim()%>'/>
				<input type="hidden" class="form-control" id="txt_checker_dept" readonly value='<%=TableModel.getValueAt(0, 30).toString().trim()%>'/>
				<input type="hidden" class="form-control" id="txt_checker_title" readonly value='<%=TableModel.getValueAt(0, 33).toString().trim()%>'/>
				<input type="hidden" class="form-control" id="txt_check_date" readonly value='<%=TableModel.getValueAt(0, 12).toString().trim()%>'/>
				<input type="hidden" class="form-control" id="txt_check_time" readonly value='<%=TableModel.getValueAt(0, 13).toString().trim()%>'/>
           	</td>
		</tr>
	</table>

   <table class="table" style="width: 100%; margin: 0 auto; align:left" id="inout_check_table">
		<thead>
        <tr style="vertical-align: middle">
            <th style="width: 10%; font-weight: 900; font-size:14px; text-align:center; vertical-align: middle">점검항목</th>
            <th style="width: 10%; font-weight: 900; font-size:14px; text-align:center; vertical-align: middle">결과</th>
        </tr>		    	
		</thead>
		<tbody id="inout_check_tbody">
	<%
	for (int i=0; i<RowCount; i++){  
		String GV_CHECK_NOTE = TableModel.getValueAt(i, 6).toString().trim() ;
	%>	 
        <tr style="background-color: #fff; height: 40px">
            <td>
            	<%=GV_CHECK_NOTE%>
	       		<input type="hidden" id="txt_checklist_cd" readonly value='<%=TableModel.getValueAt(i, 0).toString().trim()%>'></input>	
				<input type="hidden" id="txt_checklist_rev" readonly value='<%=TableModel.getValueAt(i, 1).toString().trim()%>'></input>
				<input type="hidden" id="txt_checklist_seq" readonly value='<%=TableModel.getValueAt(i, 2).toString().trim()%>'></input>
	       		<input type="hidden" id="txt_item_cd" readonly value='<%=TableModel.getValueAt(i, 3).toString().trim()%>'></input>
				<input type="hidden" id="txt_item_seq" readonly value='<%=TableModel.getValueAt(i, 4).toString().trim()%>'></input>	
				<input type="hidden" id="txt_item_cd_rev" readonly value='<%=TableModel.getValueAt(i, 5).toString().trim()%>'></input>
				<input type="hidden" id="txt_check_note" readonly value='<%=GV_CHECK_NOTE%>'></input>
				<input type="hidden" id="txt_standard_guide"  readonly value='<%=TableModel.getValueAt(i, 8).toString().trim()%>'></input>
				<input type="hidden" id="txt_standard_value" readonly value='<%=TableModel.getValueAt(i, 9).toString().trim()%>'></input>
				<input type="hidden" id="txt_check_gubun" readonly value='<%=TableModel.getValueAt(i, 10).toString().trim()%>'></input>	
            </td>
            <td >
            	<%if(TableModel.getValueAt(i,11).toString().trim().equals("text")){ %>
				<input type="<%=TableModel.getValueAt(i,11).toString().trim()%>" class="form-control" id="txt_check_value" 
						style="width:100%; vertical-align:middle;" value="<%=TableModel.getValueAt(i,7).toString().trim()%>" readonly >
				</input>
				<%} else if(TableModel.getValueAt(i,11).toString().trim().equals("checkbox")){ %>
				<input type="<%=TableModel.getValueAt(i,11).toString().trim()%>" class="form-control" id="txt_check_value" value="CHECK" 
						style="width:30px; height:30px; vertical-align:middle;" disabled>
						<%=TableModel.getValueAt(i, 9).toString().trim()%>
				</input>
				<%} %>
            </td>
        </tr>
	<%} %>
		</tbody>
    </table>
    <table class="table" style="width: 100%; margin: 0 auto; align:left">    
        <tr style="height: 50px">
            <td colspan="4" align="center">
                <p>
                	<button id="btn_Save"  class="btn btn-info" style="width: 100px" onclick="SaveOderInfo();">삭제</button>
                    <button id="btn_Canc"  class="btn btn-info" style="width: 100px" onclick="parent.$('#modalReport').hide();">취소</button>
                </p>
            </td>
        </tr>

    </table>
<!-- </form>     -->
</body>
</html>