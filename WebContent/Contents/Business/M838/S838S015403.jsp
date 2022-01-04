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
	DoyosaeTableModel TableModelUser = new DoyosaeTableModel("M909S080100E107", jArrayUser);
	int RowCountUser =TableModelUser.getRowCount();
	String loginIDrev = "";
	if(RowCountUser > 0) {
		loginIDrev = TableModelUser.getValueAt(0, 1).toString().trim();
	} else {
		loginIDrev = "0";
	}
	
	String GV_WRITE_DATE="",GV_PROD_CD="",GV_PROD_CD_REV="",GV_INSPECTION_SEQ="",GV_CHECK_GUBUN_MID="" ;
	
	if(request.getParameter("write_date")== null)
		GV_WRITE_DATE="";
	else
		GV_WRITE_DATE = request.getParameter("write_date");	
	
	if(request.getParameter("prod_cd")== null)
		GV_PROD_CD="";
	else
		GV_PROD_CD = request.getParameter("prod_cd");
	
	if(request.getParameter("prod_cd_rev")== null)
		GV_PROD_CD_REV="";
	else
		GV_PROD_CD_REV = request.getParameter("prod_cd_rev");
	
	if(request.getParameter("inspection_seq")== null)
		GV_INSPECTION_SEQ="";
	else
		GV_INSPECTION_SEQ = request.getParameter("inspection_seq");
	
	if(request.getParameter("check_gubun_mid")== null)
		GV_CHECK_GUBUN_MID="";
	else
		GV_CHECK_GUBUN_MID = request.getParameter("check_gubun_mid");
	
	JSONObject jArray = new JSONObject();
	jArray.put( "prod_cd", GV_PROD_CD);
	jArray.put( "prod_cd_rev", GV_PROD_CD_REV);
	jArray.put( "inspection_seq", GV_INSPECTION_SEQ);
	jArray.put( "check_gubun_mid", GV_CHECK_GUBUN_MID);
	jArray.put( "write_date", GV_WRITE_DATE);
	jArray.put( "member_key", member_key);
	
	DoyosaeTableModel TableModel;
	TableModel = new DoyosaeTableModel("M838S015400E124", jArray);
	int RowCount =TableModel.getRowCount();
%>
 
<%-- <jsp:include page="../../Common/linkcss_js.jsp" flush="false"/> --%>
        
    <script type="text/javascript">
//     웹소켓 통신을 위해서 필요한 변수들 ---시작
	var SQL_Param = {
			PID: "M838S015400E103",
			excute: "queryProcess",
			stream: "N",
			param: + "|"
	};
//  웹소켓 통신을 위해서 필요한 변수들 ---끝	
	
	var vTableMetalCheck;
	var TableMetalCheck_info;
    var TableMetalCheck_RowCount;
	
	$(document).ready(function () {
		$("#txt_writer_main").val("<%=loginID%>"); //로그인한 유저
		$("#txt_writer_main_rev").val("<%=loginIDrev%>"); //로그인한 유저rev
		var checkValue1 = '<%=GV_INSPECTION_SEQ%>';
		$("input[name=txt_inspection_seq]").filter("input[value='"+checkValue1+"']").attr("checked",true);
		
		vTableMetalCheck=$('#metal_check_table').DataTable({    
    		scrollX: true,
    		scrollY: 400,
//   	    scrollCollapse: true,
    	    paging: false,
    	    searching: false,
    	    ordering: false,
//     	    order: [[ 0, "asc" ]],
    	    keys: false,
    	    info: true,
	  		columnDefs: [
	  			{
		       		'targets': [0,3],
		       		'createdCell':  function (td) {
		          			$(td).attr('style', 'width:30%;'); 
		       		}
				},
				{
		       		'targets': [1,2],
		       		'createdCell':  function (td) {
		          			$(td).attr('style', 'width:20%;'); 
		       		}
				}
			],
            language: { 
                url:"<%=Config.this_SERVER_path%>/AdminLTE-3.0.5/localisation/Korean.json"
            }		    	  	
		});	
		
		TableMetalCheck_info = vTableMetalCheck.page.info();
		TableMetalCheck_RowCount = TableMetalCheck_info.recordsTotal;
	});
	
	function SaveOderInfo() {
	    var jArray = new Array(); // JSON Array 선언
	    
	    TableMetalCheck_info = vTableMetalCheck.page.info();
		TableMetalCheck_RowCount = TableMetalCheck_info.recordsTotal;
	    
	    for(var i=0; i<TableMetalCheck_RowCount; i++){
	    	var trInput = $($("#metal_check_tbody tr")[i]).find(":input");
	    	
			// JSON 파라미터 세팅
			var dataJson = new Object(); // jSON Object 선언 
			
			dataJson.prod_cd 	 	= $("#txt_prod_cd").val();
			dataJson.prod_cd_rev  	= $("#txt_prod_cd_rev").val();
			
			dataJson.inspection_seq  = $(':input[name="txt_inspection_seq"]:radio:checked').val();
			dataJson.check_gubun 	 = trInput.eq(0).val();
			dataJson.check_gubun_mid = trInput.eq(1).val();
			
			dataJson.write_date = $("#txt_write_date").val();
			dataJson.member_key = "<%=member_key%>";
			
			jArray.push(dataJson); // 데이터를 배열에 담는다.
	    }
		  
	    var dataJsonMulti = new Object();
 		dataJsonMulti.param = jArray; // Array를 다시 Object형태로 변환 {"param":{Array...}}

		var JSONparam = JSON.stringify(dataJsonMulti); // JSON Object전송을 위해 문자열형태로 바꿔줌(stringify)
		
// 		console.log(JSONparam);
		var chekrtn = confirm("삭제하시겠습니까?"); 
		
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
            <td style="width: 150px; font-weight: 900; font-size:14px; vertical-align: middle ; text-align:left">제품명</td>
            <td style="width: auto;  font-weight: 900; font-size:14px; vertical-align: middle ;text-align:left" colspan="2">
				<input type="text" class="form-control" id="txt_prod_nm" readonly value='<%=TableModel.getValueAt(0, 22).toString().trim()%>'/>
				<input type="hidden" class="form-control" id="txt_prod_cd" readonly value='<%=TableModel.getValueAt(0, 20).toString().trim()%>'/>
				<input type="hidden" class="form-control" id="txt_prod_cd_rev" readonly value='<%=TableModel.getValueAt(0, 21).toString().trim()%>'/>
           	</td>
		</tr>
		<tr>
           	<td style="width: 150px; font-weight: 900; font-size:14px; vertical-align: middle ; text-align:left">시편</td>
            <td style="width: auto;  font-weight: 900; font-size:14px; vertical-align: middle ;text-align:left" colspan="2">
				<input type="text" class="form-control" id="txt_check_gubun_mid22" readonly value='<%=TableModel.getValueAt(0, 2).toString().trim()%>' />
           	</td>
		</tr>
		<tr>
           	<td style="width: 150px; font-weight: 900; font-size:14px; vertical-align: middle ; text-align:left">점검차수</td>
            <td style="width: auto;  font-weight: 900; font-size:14px; vertical-align: middle ;text-align:left" colspan="2">
				<input type="radio" id="txt_inspection_seq" name="txt_inspection_seq" value="1" style="width: 60px;" disabled>1차</input>
        		<input type="radio" id="txt_inspection_seq" name="txt_inspection_seq" value="2" style="width: 60px;" disabled>2차</input>
        		<input type="radio" id="txt_inspection_seq" name="txt_inspection_seq" value="3" style="width: 60px;" disabled>3차</input>
				
           	</td>
		</tr>
		<tr>
           	<td style="width: 150px; font-weight: 900; font-size:14px; vertical-align: middle ; text-align:left">이탈사항 및 개선조치 내역/특이사항</td>
            <td style="width: auto;  font-weight: 900; font-size:14px; vertical-align: middle ;text-align:left" colspan="2">
				<input type="text" class="form-control" id="txt_improvement" readonly value='<%=TableModel.getValueAt(0, 24).toString().trim()%>'/>
				<input type="hidden" class="form-control" id="txt_write_date" readonly value='<%=TableModel.getValueAt(0, 25).toString().trim()%>'/>
				<input type="hidden" class="form-control" id="txt_writer_main" readonly />
				<input type="hidden" class="form-control" id="txt_writer_main_rev" readonly />
           	</td>
		</tr>
	</table>

   <table class="table" style="width: 100%; margin: 0 auto; align:left" id="metal_check_table">
		<thead>
        <tr style="vertical-align: middle">
            <th style="width: 30%; font-weight: 900; font-size:14px; text-align:center; vertical-align: middle">점검항목</th>
            <th style="width: 20%; font-weight: 900; font-size:14px; text-align:center; vertical-align: middle">결과</th>
            <th style="width: 20%; font-weight: 900; font-size:14px; text-align:center; vertical-align: middle">판정</th>
            <th style="width: 30%; font-weight: 900; font-size:14px; text-align:center; vertical-align: middle">비고</th>
        </tr>		    	
		</thead>
		<tbody id="metal_check_tbody">
	<%
	for (int i=0; i<RowCount; i++){  
		String GV_CHECK_NOTE = TableModel.getValueAt(i, 4).toString().trim() + "-" + TableModel.getValueAt(i, 16).toString().trim() ;
	%>	 
        <tr style="background-color: #fff; height: 40px">
            <td>
            	<%=GV_CHECK_NOTE%>
	       		<input type="hidden" id="txt_check_gubun" readonly value='<%=TableModel.getValueAt(i, 0).toString().trim()%>'></input>
	       		<input type="hidden" id="txt_check_gubun_mid" readonly value='<%=TableModel.getValueAt(i, 1).toString().trim()%>'></input>
	       		<input type="hidden" id="txt_check_gubun_sm" readonly value='<%=TableModel.getValueAt(i, 3).toString().trim()%>'></input>
	       		<input type="hidden" id="txt_checklist_cd" readonly value='<%=TableModel.getValueAt(i, 5).toString().trim()%>'></input>	
				<input type="hidden" id="txt_checklist_rev" readonly value='<%=TableModel.getValueAt(i, 6).toString().trim()%>'></input>
				<input type="hidden" id="txt_checklist_seq" readonly value='<%=TableModel.getValueAt(i, 7).toString().trim()%>'></input>
	       		<input type="hidden" id="txt_item_cd" readonly value='<%=TableModel.getValueAt(i, 8).toString().trim()%>'></input>
				<input type="hidden" id="txt_item_seq" readonly value='<%=TableModel.getValueAt(i, 9).toString().trim()%>'></input>	
				<input type="hidden" id="txt_item_cd_rev" readonly value='<%=TableModel.getValueAt(i, 10).toString().trim()%>'></input>
				<input type="hidden" id="txt_standard_guide"  readonly value='<%=TableModel.getValueAt(i, 14).toString().trim()%>'></input>
				<input type="hidden" id="txt_standard_value" readonly value='<%=TableModel.getValueAt(i, 15).toString().trim()%>'></input>
				<input type="hidden" id="txt_check_note" readonly value='<%=TableModel.getValueAt(i, 16).toString().trim()%>'></input>	
            </td>
            <td >
            	<%if(TableModel.getValueAt(i,11).toString().trim().equals("text")){ %>
				<input type="<%=TableModel.getValueAt(i,11).toString().trim()%>" class="form-control" id="txt_check_value" 
						style="width:100%; vertical-align:middle;" value="<%=TableModel.getValueAt(i,17).toString().trim()%>" readonly>
				</input>
				<%} else if(TableModel.getValueAt(i,11).toString().trim().equals("checkbox")){ %>
					<%if(TableModel.getValueAt(i,17).toString().trim().equals("Y")){ %>
				<input type="<%=TableModel.getValueAt(i,11).toString().trim()%>" class="" id="txt_check_value" value="CHECK" 
						style="width:30px; height:30px; vertical-align:middle;" checked disabled>
						<%=TableModel.getValueAt(i, 13).toString().trim()%>
				
				</input>
					<%} else {%>
				<input type="<%=TableModel.getValueAt(i,11).toString().trim()%>" class="" id="txt_check_value" value="CHECK" 
						style="width:30px; height:30px; vertical-align:middle;" disabled>
						<%=TableModel.getValueAt(i, 13).toString().trim()%>
				</input>
					<%} %>
				<%} %>
            </td>
            <td >
            	<%	if(TableModel.getValueAt(i,18).toString().trim().equals("Y")){ %>
				<input type="checkbox" class="" id="txt_judgment" value="CHECK" style="width:30px; height:30px; vertical-align:middle;" checked disabled>
						적합	</input>
				<%	} else { %>
				<input type="checkbox" class="" id="txt_judgment" value="CHECK" style="width:30px; height:30px; vertical-align:middle;" disabled>
						적합	</input>
				<%	} %>
            </td>
            <td >
				<input type="text" class="form-control" id="txt_bigo" style="width:100%; vertical-align:middle;" 
					value="<%=TableModel.getValueAt(i, 19).toString().trim()%>" readonly></input>
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