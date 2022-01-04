<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*,java.util.*,javax.servlet.http.*"%>
<%@ page import="mes.client.comm.*" %>
<%@ page import="mes.client.common.*" %>
<%@ page import="mes.client.guiComponents.*" %>
<%@ page import="mes.client.util.*" %>
<%@ page import="mes.client.conf.*" %>
<%@ page import="org.json.simple.*"%><%@ include file="/strings.jsp" %>
<!DOCTYPE html>
<!-- <html xmlns="http://www.w3.org/1999/xhtml"> -->
<!-- <head id="Head1" > -->
<%
	String loginID = session.getAttribute("login_id").toString();
	String member_key = session.getAttribute("member_key").toString();
	DoyosaeTableModel TableModel;

	String zhtml = "";
	Vector CCPCode = new Vector();
	Vector CCPName = new Vector();
	
	String[] strColumnHead = {""};

	String MEMBER_KEY = "", CODE_CD = "", CCP_NO = "", CCP_SEQ_NO = "";

	if(request.getParameter("member_key")== null)
		MEMBER_KEY = "";
	else
		MEMBER_KEY = request.getParameter("member_key");
	
	if(request.getParameter("code_cd") == null)
		CODE_CD = "";
	else
		CODE_CD = request.getParameter("code_cd");
	
	if(request.getParameter("ccp_no") == null)
		CCP_NO = "";
	else
		CCP_NO = request.getParameter("ccp_no");
	
	if(request.getParameter("ccp_seq_no") == null)
		CCP_SEQ_NO = "";
	else
		CCP_SEQ_NO = request.getParameter("ccp_seq_no");

	JSONObject jArray = new JSONObject();
	jArray.put("member_key", member_key);
	jArray.put("code_cd", CODE_CD);
	jArray.put("ccp_no", CCP_NO);
	jArray.put("ccp_seq_no", CCP_SEQ_NO);
	
	Vector CCP_Type_Vector = CommonData.getCCPType(jArray);
	
	TableModel = new DoyosaeTableModel("M909S160200E204", strColumnHead, jArray);
    int ColCount =TableModel.getColumnCount();

    // 데이터를 가져온다.
    Vector Limit_Delete_Target_Vector = (Vector)(TableModel.getVector().get(0));

    jArray.put("code_value", Limit_Delete_Target_Vector.get(2).toString().trim());

    DBServletLink dbServletLink = new DBServletLink();
	dbServletLink.connectURL("M909S160100E996");
    Vector CodeValueTable = dbServletLink.doQuery(jArray, false);
    
    System.out.println("CodeValueTable : " + CodeValueTable);
    String ResultOfCodeValueTable = ((Vector)CodeValueTable.get(0)).get(0).toString();
    
    for( int i = 0 ; i < 7 ; i++ )
    {
    	System.out.println( "Limit_Delete_Target_Vector.get(" + i + ") : " + Limit_Delete_Target_Vector.get(i).toString().trim() );    	
    }


    /* // 개정번호를 만든다.
    String revisionNumberStr = "";
    int revisionNoInt = 0;
    try {
		revisionNoInt = Integer.parseInt( Limit_Delete_Target_Vector.get(1).toString().trim() );
    } catch (Exception e) {
    	revisionNoInt = 0;
    }
    revisionNoInt = revisionNoInt + 1;
    revisionNumberStr = "" + revisionNoInt; */
		
%>
    
<script type="text/javascript">
	// 웹소켓 통신을 위해서 필요한 변수들 ---시작
	var M909S160100E203 = {
			PID:  "M909S160100E203", 
			totalcnt: 0,
			retnValue: 999,
			colcnt: 0,
			colname: ["","","",""], //insert, Update, Delete 문장을 처리할 때는 사용되지않음
			data: []
	};  
	
	var SQL_Param = {
			PID:  "M909S160100E203", 
			excute: "queryProcess",
			stream: "N",
			param: ""
	};
	var GV_RECV_DATA = "";	//웹소켓 onMessage(event)들어온 데이터를 받는 변수
	// 웹소켓 통신을 위해서 필요한 변수들 ---끝
	
    var detail_seq=1;

	function SaveOderInfo() {        
		var delete_check = confirm("선택한 한계기준정보를 삭제합니다." + "\n" + "삭제하시겠습니까?");
		
		if(delete_check) {
			var dataJson = new Object();

			dataJson.member_key		= "<%=member_key%>";
			dataJson.ccp_no			= $('#txt_CCPNo').val();
			dataJson.ccp_seq_no		= $("#txt_CCPSEQ").val();
			dataJson.ccp_type		= $("#txt_CCPType").val();
			dataJson.min_value		= $('#txt_MinValue').val();
			dataJson.max_value		= $('#txt_MaxValue').val();
			dataJson.standard_value	= $('#txt_StandardValue').val();
			dataJson.bigo			= $('#txt_Bigo').val();
		
			var JSONparam = JSON.stringify(dataJson);
			SendTojsp(JSONparam, "M909S160200E103");
		}
	}

	function SendTojsp(bomdata, pid){
		
	    $.ajax({
	         type: "POST",
	         dataType: "json", // Ajax로 json타입으로 보낸다.
	     	 url: "<%=Config.this_SERVER_path%>/Contents/CommonView/insert_update_delete_json.jsp",
	     	 data:  {"bomdata" : bomdata, "pid" : pid },
	         success: function (html) {	 
	        	 if(html > -1){
	        	   	parent.fn_MainInfo_List();
	                parent.$("#ReportNote").children().remove();
	                $('#modalReport').modal('hide');
	         	}
	         }
	     });
	    
	    vCCPNo = "";
	}  
    function fn_CommonPopupModal(sUrl, name, w, h) { // url, name, width, height, 기타 속성(생략해도 무방)     	
        var popupWin = window.showModalDialog(sUrl, name, 'dialogWidth:' + w + 'px; dialogHeight:' + h 
                + 'px; center:yes; help:no; status:no; resizable:no; scroll:yes; toolbar :no;');
    	if(typeof(popupWin)=="undefine")
    		popupWin = window.returnValue;
		return popupWin;
    }  
    
    function SetCustName_code(name, code, rev){
    	alert(code);
		$('#txt_custname').val(name);
		$('#txt_custcode').val(code);
		$('#txt_cust_rev').val(rev);
		
    	alert(code);
    }
    
    function SetCustProjectInfo(cust_cd, cust_nm, project_name, cust_pono, prod_cd, product_nm, cust_rev, projrctCnt){
		$('#txt_projrctName').val(project_name);
		$('#txt_custname').val(cust_nm);
		$('#txt_projrctCnt').val(projrctCnt);
		
		$('#txt_custcode').val(cust_cd);
		$('#txt_cust_rev').val(cust_rev);
		$('#txt_cust_poNo').val(cust_pono);
    }
    
    function SetProductName_code(name, code, rev) {
    	var len = $("#product_tbody tr").length-1;		
		var trInput = $($("#product_tbody tr")[len]).find(":input")
		trInput.eq(1).val(name);
		trInput.eq(3).val(code);
		trInput.eq(4).val(rev);
    }
    
</script>

<table class="table table-hover" style="width: 100%; margin: 0 auto; align:left">
	<tr style="background-color: #fff; height: 40px">
		<td style="font-weight:900;">CCP 번호</td>
		<td></td>
		<td>
			<input type="text" class="form-control" id="txt_CCPNo" style="width: 200px; float:left"
			value = "<%=Limit_Delete_Target_Vector.get(0).toString()%>" readonly />
		</td>
	</tr>

	<tr style="background-color: #fff; height: 40px">
		<td style="font-weight:900;">CCP SEQ</td>
		<td></td>
		<td>
			<input type="text" class="form-control" id="txt_CCPSEQ" style="width: 200px; float:left"
				   value = "<%=Limit_Delete_Target_Vector.get(1).toString()%>" readonly />
		</td>
	</tr>

	<tr style="background-color: #fff; height: 40px">
		<td style="font-weight:900;">CCP 타입</td>
		<td></td>
		<td>
			<input type="text" class="form-control" id="txt_CCPType" style="width: 200px; float:left"
				   value = "<%=ResultOfCodeValueTable%>" readonly />
		</td>
	</tr>

	<tr style="background-color: #fff; height: 40px">
		<td style="font-weight:900;">최소값</td>
		<td></td>
		<td>
			<input type="text" class="form-control" id="txt_MinValue" style="width: 200px; float:left"
				   value = "<%=Limit_Delete_Target_Vector.get(3).toString()%>" readonly />
		</td>
	</tr>

	<tr style="background-color: #fff; height: 40px">
		<td style="font-weight:900;">최대값</td>
		<td></td>
		<td>
			<input type="text" class="form-control" id="txt_MaxValue" style="width: 200px; float:left"
				   value = "<%=Limit_Delete_Target_Vector.get(4).toString()%>" readonly />
		</td>
	</tr>

	<tr style="background-color: #fff; height: 40px">
		<td style="font-weight:900;">표준값</td>
		<td> </td>
		<td>
			<input type="text" class="form-control" id="txt_StandardValue" style="width: 200px; float:left"
				   value = "<%=Limit_Delete_Target_Vector.get(5).toString()%>" readonly />
		</td>
	</tr>

	<tr style="background-color: #fff" >
		<td style=" font-weight: 900; font-size:14px; text-align:left" colspan="3">비고</td>
	</tr>
	<tr>
		<td colspan = "3">
			<textarea class="form-control" id="txt_Bigo"
					  style="cols:40;rows:4;resize: none;" readonly >
				<%=Limit_Delete_Target_Vector.get(6).toString()%>
			</textarea>
		</td>
	</tr>

	<tr style="height: 60px">
		<td align="center" colspan="4">
			<p>
				<button id="btn_Save" class="btn btn-info" style="width: 100px" onclick="SaveOderInfo();">삭제</button>
				<button id="btn_Canc" class="btn btn-info" style="width: 100px" onclick="$('#modalReport').modal('hide');">취소</button>
			</p>
		</td>
	</tr>
</table>