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
	
	// 로그인한 사용자의 정보
	JSONObject jArrayUser = new JSONObject();
	jArrayUser.put( "member_key", member_key);
	jArrayUser.put( "USER_ID", loginID);
	DoyosaeTableModel TableModelUser = new DoyosaeTableModel("M909S080100E105", jArrayUser);
	int RowCountUser =TableModelUser.getRowCount();
	String loginIDrev = "",loginIDjikwi="",loginIDdept = "";
	if(RowCountUser > 0) {
		loginIDrev = TableModelUser.getValueAt(0, 1).toString().trim();
	} else {
		loginIDrev = "0";
	}
	
	String GV_CHECK_GUBUN="" ;
	
	if(request.getParameter("check_gubun")== null)
		GV_CHECK_GUBUN = "";
	else
		GV_CHECK_GUBUN = request.getParameter("check_gubun");
	
	JSONObject jArray = new JSONObject();
	jArray.put( "member_key", member_key);
	jArray.put( "check_gubun", GV_CHECK_GUBUN);

	DoyosaeTableModel TableModel;
	TableModel = new DoyosaeTableModel("M838S060500E134", jArray);
	int RowCount =TableModel.getRowCount();
	
	String GV_VHCL_NO="", GV_VHCL_NM="", GV_SERVICE_DATE="";
	
	if(request.getParameter("vhcl_no")== null)
		GV_VHCL_NO = "";
	else
		GV_VHCL_NO = request.getParameter("vhcl_no");
	
	if(request.getParameter("vhcl_nm")== null)
		GV_VHCL_NM = "";
	else
		GV_VHCL_NM = request.getParameter("vhcl_nm");
	
	if(request.getParameter("service_date")== null)
		GV_SERVICE_DATE = "";
	else
		GV_SERVICE_DATE = request.getParameter("service_date");
	
%>
 
<%-- <jsp:include page="../../Common/linkcss_js.jsp" flush="false"/> --%>
        
    <script type="text/javascript">
//     웹소켓 통신을 위해서 필요한 변수들 ---시작
	var SQL_Param = {
			PID: "M838S060500E101",
			excute: "queryProcess",
			stream: "N",
			param: + "|"
	};
//  웹소켓 통신을 위해서 필요한 변수들 ---끝	
	
	var vTableInoutCheck;
	var TableInoutCheck_info;
    var TableInoutCheck_RowCount;
	
	$(document).ready(function () {
		
		new SetSingleDate2("", "#txt_strange_date", 0);
		new SetSingleDate2("", "#txt_strange_result_date", 0);
		
		var today = new Date();
		//$('#txt_strange_date').datepicker('update', today);
		//$('#txt_strange_result_date').datepicker('update', today);
		$('#txt_strange_date').attr("disabled", true);
		$('#txt_strange_result_date').attr("disabled", true);
		$('#txt_strange_result').attr("disabled", true);
		$('#txt_strange_result_person').attr("disabled", true);
		$('#txt_strange_result_check').attr("disabled", true);
		//$('#txt_check_person').attr("disabled", true);
		
		$("#txt_writor_main").val("<%=loginID%>"); //로그인한 유저
		$("#txt_writor_main_rev").val("<%=loginIDrev%>"); //로그인한 유저rev
		
		$("#txt_vhcl_no").val("<%=GV_VHCL_NO%>");
		$("#txt_vhcl_nm").val("<%=GV_VHCL_NM%>");
		$("#txt_service_date").val("<%=GV_SERVICE_DATE%>");
		
		vTableInoutCheck=$('#inout_check_table').DataTable({    
    		scrollX: true,
    		scrollY: 250,
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
		          			$(td).attr('style', 'width:80%;'); 
		       		}
				},
				{
		       		'targets': [1],
		       		'createdCell':  function (td) {
		          			$(td).attr('style', 'width:20%;'); 
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
	
	$("#txt_strange_note").change(function(){
		if( $("#txt_strange_note").val() == "" )
		{
			$('#txt_strange_date').attr("disabled", true);
			$('#txt_strange_result_date').attr("disabled", true);
			$('#txt_strange_result').attr("disabled", true);
			$('#txt_strange_result_person').attr("disabled", true);
			$('#txt_strange_result_check').attr("disabled", true);
			//$('#txt_check_person').attr("disabled", true);
			
			$('#txt_strange_date').val("");
			$('#txt_strange_result_date').val("");
			$('#txt_strange_result').val("");
			$('#txt_strange_result_person').val("");
			$('#txt_strange_result_check').val("");
			$('#txt_check_person').val("");
		}
		else
		{
			alert("이상발생내역 관련 정보를 입력할 수 있게 됩니다.");
			
			$('#txt_strange_date').attr("disabled", false);
			$('#txt_strange_result_date').attr("disabled", false);
			$('#txt_strange_result').attr("disabled", false);
			$('#txt_strange_result_person').attr("disabled", false);
			$('#txt_strange_result_check').attr("disabled", false);
			//$('#txt_check_person').attr("disabled", false);
		}
	});
	
	function SaveOderInfo() {
		if($("#txt_vhcl_no").val().length<1) {
			alert("운행 차량을 검색하여 선택하세요");
			return;
		}
		if($("#txt_check_person").val().length<1) {
			alert("점검자를 입력하세요");
			return;
		}
		
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
	    
	    TableInoutCheck_info = vTableInoutCheck.page.info();
		TableInoutCheck_RowCount = TableInoutCheck_info.recordsTotal;
	    
	    for(var i=0; i<TableInoutCheck_RowCount; i++){
			var trInput = $($("#inout_check_tbody tr")[i]).find(":input");
		
			// 결과값 세팅
			var result_value;
			if(trInput.eq(17).val()=='CHECK'){ // 결과값이 체크박스 형태일때
				if($("input[id='txt_check_value']").eq(i).prop("checked"))
					result_value ="Y";
				else
					result_value="N";
			} else { // 결과값이 텍스트박스 형태일때
				result_value = trInput.eq(17).val();
			}
			
			// JSON 파라미터 세팅
			var dataJson = new Object(); // jSON Object 선언 
			
			dataJson.vhcl_no		= $("#txt_vhcl_no").val();
			dataJson.vhcl_no_rev	= $("#txt_vhcl_no_rev").val();
			dataJson.service_date	= $("#txt_service_date").val();
			dataJson.driver			= $("#txt_driver").val();
			
			dataJson.check_gubun = trInput.eq(6).val();
			dataJson.check_gubun_mid = trInput.eq(13).val();
			dataJson.check_gubun_sm = trInput.eq(14).val();
			dataJson.checklist_cd 	 = trInput.eq(1).val();
			dataJson.cheklist_cd_rev = trInput.eq(2).val();
			dataJson.checklist_seq 	 = trInput.eq(0).val();
			dataJson.item_cd 	 = trInput.eq(3).val();
			dataJson.item_seq 	 = trInput.eq(4).val();
			dataJson.item_cd_rev = trInput.eq(5).val();
			dataJson.standard_guide = trInput.eq(9).val();
			dataJson.standard_value = trInput.eq(16).val();
			dataJson.check_note 	= trInput.eq(15).val();
			dataJson.check_value 	= result_value;
			
			dataJson.strange_date			= $("#txt_strange_date").val();
			dataJson.strange_note			= $("#txt_strange_note").val();
			dataJson.strange_result			= $("#txt_strange_result").val();
			dataJson.strange_result_date	= $("#txt_strange_result_date").val();
			dataJson.strange_result_person	= $("#txt_strange_result_person").val();
			dataJson.strange_result_check	= $("#txt_strange_result_check").val();
			
			dataJson.writor_main		= $("#txt_writor_main").val();
			dataJson.writor_main_rev	= $("#txt_writor_main_rev").val();
			dataJson.write_date			= check_date;
			dataJson.check_person		= $("#txt_check_person").val();
			dataJson.check_date			= $("#txt_service_date").val();
			dataJson.approval			= "";
			dataJson.approval_date		= check_date;
			dataJson.member_key			= "<%=member_key%>";
			
			// dataJson.FLAG = ( $("#txt_strange_result").is( ': disabled') == true ) ? "T" : "F";
			// if( $("#txt_strange_result").is( ': disabled') == true )
			if( $("#txt_strange_result").disabled )
				dataJson.FLAG = "NM";
				
			jArray.push(dataJson); // 데이터를 배열에 담는다.
	    }
		  
	    var dataJsonMulti = new Object();
 		dataJsonMulti.param = jArray; // Array를 다시 Object형태로 변환 {"param":{Array...}}

		var JSONparam = JSON.stringify(dataJsonMulti); // JSON Object전송을 위해 문자열형태로 바꿔줌(stringify)
		
// 		console.log(JSONparam);
		var work_complete_insert_check = confirm("등록하시겠습니까?");
		if(work_complete_insert_check == false)   return;

		
		SendTojsp(JSONparam, SQL_Param.PID); // SendToJSP를 통해 ajax로 데이터(JSONObject,PID) 보냄
	}
 
	function SendTojsp(bomdata, pid){
	    $.ajax({
	         type: "POST",
	         dataType: "json", // Ajax로 json타입으로 보낸다.
	         url: "<%=Config.this_SERVER_path%>/Contents/CommonView/insert_update_delete_json.jsp", 
	         data: {"bomdata" : bomdata, "pid" : pid },
	         beforeSend: function () {
//	         	 alert(bomdata);
	         },	         
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
	
	function pop_fn_Transport_View(caller) {
    	var modalContentUrl  = "<%=Config.this_SERVER_path%>/Contents/Business/M838/S838S060510.jsp?caller="+caller;
    	pop_fn_popUpScr_nd(modalContentUrl, "차량운행실적 조회", '650px', '1360px');
		return false;
    }
	
    </script>
</head>
<body>
	<table class="table" style="width: 100%; margin: 0 auto; align:left">
		<tr>
            <td style="width: 150px; font-weight: 900; font-size:14px; vertical-align: middle ; text-align:left">차량명</td>
            <td style="width: auto;  font-weight: 900; font-size:14px; vertical-align: middle ;text-align:left">
				<input type="text" class="form-control" id="txt_vhcl_nm" readonly style="width:70%;float:left;"/>
				<button class="form-control btn btn-info" style="width:30%;float:left;" onclick="pop_fn_Transport_View(0)">검색</button>
           	</td>
           	<td style="width: 150px; font-weight: 900; font-size:14px; vertical-align: middle ; text-align:left">차량번호</td>
            <td style="width: auto;  font-weight: 900; font-size:14px; vertical-align: middle ;text-align:left" colspan="2">
				<input type="text" class="form-control" id="txt_vhcl_no" readonly />
				<input type="hidden" class="form-control" id="txt_vhcl_no_rev" />
				<input type="hidden" class="form-control" id="txt_writor_main" />
				<input type="hidden" class="form-control" id="txt_writor_main_rev" />
           	</td>
		</tr>
		<tr>
            <td style="width: 150px; font-weight: 900; font-size:14px; vertical-align: middle ; text-align:left">운행일자</td>
            <td style="width: auto;  font-weight: 900; font-size:14px; vertical-align: middle ;text-align:left">
				<input type="text" class="form-control" id="txt_service_date" readonly />
           	</td>
			<td style="width: 150px; font-weight: 900; font-size:14px; vertical-align: middle ; text-align:left">운전자</td>
            <td style="width: auto;  font-weight: 900; font-size:14px; vertical-align: middle ;text-align:left">
				<input type="text" class="form-control" id="txt_driver" readonly />
           	</td>
		</tr>
		<tr>
           	<td style="width: 150px; font-weight: 900; font-size:14px; vertical-align: middle ; text-align:left">이상발생일자</td>
            <td style="width: auto;  font-weight: 900; font-size:14px; vertical-align: middle ;text-align:left" colspan="3">
				<input type="text" class="form-control" data-date-format="yyyy-mm-dd" id="txt_strange_date"  readonly/>
           	</td>
		</tr>
		<tr>
           	<td style="width: 150px; font-weight: 900; font-size:14px; vertical-align: middle ; text-align:left">이상발생내역</td>
            <td style="width: auto;  font-weight: 900; font-size:14px; vertical-align: middle ;text-align:left" colspan="3">
				<input type="text" class="form-control" id="txt_strange_note"  />
           	</td>
		</tr>
		<tr>
           	<td style="width: 150px; font-weight: 900; font-size:14px; vertical-align: middle ; text-align:left">조치내역 및 결과</td>
            <td style="width: auto;  font-weight: 900; font-size:14px; vertical-align: middle ;text-align:left" colspan="3">
				<input type="text" class="form-control" id="txt_strange_result"  />
           	</td>
		</tr>
		<tr>
           	<td style="width: 150px; font-weight: 900; font-size:14px; vertical-align: middle ; text-align:left">조치완료일시</td>
            <td style="width: auto;  font-weight: 900; font-size:14px; vertical-align: middle ;text-align:left" colspan="3">
				<input type="text" class="form-control" data-date-format="yyyy-mm-dd" id="txt_strange_result_date"  readonly/>
           	</td>
		</tr>
		<tr>
           	<td style="width: 150px; font-weight: 900; font-size:14px; vertical-align: middle ; text-align:left">조치자</td>
            <td style="width: auto;  font-weight: 900; font-size:14px; vertical-align: middle ;text-align:left">
				<input type="text" class="form-control" id="txt_strange_result_person"  />
           	</td>
			<td style="width: 150px; font-weight: 900; font-size:14px; vertical-align: middle ; text-align:left">확인</td>
            <td style="width: auto;  font-weight: 900; font-size:14px; vertical-align: middle ;text-align:left">
				<input type="text" class="form-control" id="txt_strange_result_check"  />
           	</td>
		</tr>
		<tr>
           	<td style="width: 150px; font-weight: 900; font-size:14px; vertical-align: middle ; text-align:left">점검자</td>
            <td style="width: auto;  font-weight: 900; font-size:14px; vertical-align: middle ;text-align:left">
				<input type="text" class="form-control" id="txt_check_person"  />
           	</td>
		</tr>
	</table>

   <table class="table" style="width: 100%; margin: 0 auto; align:left" id="inout_check_table">
		<thead>
        <tr style="vertical-align: middle">
            <th style="width: 80%; font-weight: 900; font-size:14px; text-align:center; vertical-align: middle">점검항목</th>
            <th style="width: 20%; font-weight: 900; font-size:14px; text-align:center; vertical-align: middle">결과</th>
        </tr>		    	
		</thead>
		<tbody id="inout_check_tbody">
	<%
	for (int i=0; i<RowCount; i++){  
		String GV_CHECK_NOTE = TableModel.getValueAt(i, 20).toString().trim() + "-" + TableModel.getValueAt(i, 5).toString().trim() ;
	%>	 
        <tr style="background-color: #fff; height: 40px">
            <td>
            	<%=GV_CHECK_NOTE%>
            	<input type="hidden" id="txt_checklist_seq" readonly value='<%=TableModel.getValueAt(i, 4).toString().trim()%>'></input>
	       		<input type="hidden" id="txt_checklist_cd" readonly value='<%=TableModel.getValueAt(i, 2).toString().trim()%>'></input>	
				<input type="hidden" id="txt_checklist_rev" readonly value='<%=TableModel.getValueAt(i, 3).toString().trim()%>'></input>
	       		<input type="hidden" id="txt_item_cd" readonly value='<%=TableModel.getValueAt(i, 9).toString().trim()%>'></input>
				<input type="hidden" id="txt_item_seq" readonly value='<%=TableModel.getValueAt(i, 10).toString().trim()%>'></input>	
				<input type="hidden" id="txt_item_cd_rev" readonly value='<%=TableModel.getValueAt(i, 11).toString().trim()%>'></input>
	       		<input type="hidden" id="txt_check_gubun" readonly value='<%=TableModel.getValueAt(i, 0).toString().trim()%>'></input>	
				<input type="hidden" id="txt_code_name" readonly value='<%=TableModel.getValueAt(i, 1).toString().trim()%>'></input>	
				<input type="hidden" id="txt_double_check_yn" readonly value='<%=TableModel.getValueAt(i, 8).toString().trim()%>'></input>		
				<input type="hidden" id="txt_standard_guide"  readonly value='<%=TableModel.getValueAt(i, 6).toString().trim()%>'></input>
				<input type="hidden" id="txt_item_bigo" readonly value='<%=TableModel.getValueAt(i, 13).toString().trim()%>'></input>
				<input type="hidden" id="txt_start_date" readonly value='<%=TableModel.getValueAt(i, 15).toString().trim()%>'></input>	
				<input type="hidden" id="txt_duration_date" readonly value='<%=TableModel.getValueAt(i, 16).toString().trim()%>'></input>
            	<input type="hidden" id="txt_check_gubun_mid"  readonly value='<%=TableModel.getValueAt(i, 17).toString().trim()%>'></input>
				<input type="hidden" id="txt_check_gubun_sm"  readonly value='<%=TableModel.getValueAt(i, 19).toString().trim()%>'></input>
            	<input type="hidden" id="txt_check_note" readonly value='<%=TableModel.getValueAt(i, 5).toString().trim()%>'></input>
				<input type="hidden" id="txt_standard_value" readonly value='<%=TableModel.getValueAt(i, 7).toString().trim()%>'></input>
            </td>
            <td >
            	<%if(TableModel.getValueAt(i,12).toString().trim().equals("text")){ %>
				<input type="<%=TableModel.getValueAt(i,12).toString().trim()%>" class="form-control" id="txt_check_value" 
						style="width:100%; vertical-align:middle;" >
				</input>
				<%} else if(TableModel.getValueAt(i,12).toString().trim().equals("checkbox")){ %>
				<input type="<%=TableModel.getValueAt(i,12).toString().trim()%>" class="" id="txt_check_value" value="CHECK" 
						style="width:30px; height:30px; vertical-align:middle;" checked>
						<%=TableModel.getValueAt(i, 7).toString().trim()%>
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
                	<button id="btn_Save"  class="btn btn-info" style="width: 100px" onclick="SaveOderInfo();">저장</button>
                    <button id="btn_Canc"  class="btn btn-info" style="width: 100px" onclick="$('#modalReport').modal('hide');">취소</button>
                </p>
            </td>
        </tr>

    </table>
<!-- </form>     -->
</body>
</html>