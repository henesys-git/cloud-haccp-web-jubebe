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
	Vector CCPCode = new Vector();
	Vector CCPName = new Vector();
	
	String[] strColumnHead = {""};

	String MEMBER_KEY = "", CODE_CD = "", CCP_NO = "", CCP_SEQ_NO = "", CCP_REV_NO = "";

	if(request.getParameter("member_key") == null)
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

	JSONObject jArray = new JSONObject();
	jArray.put("member_key", member_key);
	jArray.put("code_cd", CODE_CD);
	jArray.put("ccp_no", CCP_NO);
	
	Vector CCP_Type_Vector = CommonData.getCCPType(jArray);
	
    TableModel = new DoyosaeTableModel("M909S160200E204", strColumnHead, jArray);
    int ColCount =TableModel.getColumnCount();
    
    Vector Limit_Upgrad_Target_Vector = (Vector)(TableModel.getVector().get(0));
%>
    
<script type="text/javascript">
    var detail_seq=1;
    
    $(document).ready(function () {
    	$("#txt_CCPType").val("<%=Limit_Upgrad_Target_Vector.get(1).toString()%>");
    	
    	$("#txt_CCPType").attr("disabled",true);
    	
    	new SetSingleDate("", "txt_StartDate", 0);
    });
	
	function SaveOderInfo() {
		if( $('#txt_StartDate').val() > $('#txt_DurationDate').val() ) {
			alert("가장 최근의 Rev(개정번호)에 대한 한계기준정보가 아닙니다.");
			return;
		}
	 	var dataJson = new Object();

		dataJson.member_key				= "<%=member_key%>";
		dataJson.ccp_no					= $('#txt_CCPNo').val();
		dataJson.ccp_type				= $("#txt_CCPType").val();
		dataJson.min_value				= $('#txt_MinValue').val();
		dataJson.max_value				= $('#txt_MaxValue').val();
		dataJson.standard_value			= $('#txt_StandardValue').val();
		dataJson.after_start_date		= $('#txt_StartDate').val();
		dataJson.bigo					= $('#txt_Bigo').val();
		
		if(Number(dataJson.min_value) > Number(dataJson.max_value)) {
			alert("최소값이 최대값보다 클수 없습니다.");
			return false;
		}
		
		var JSONparam = JSON.stringify(dataJson); // JSON Object전송을 위해 문자열형태로 바꿔줌(stringify)
		var chekrtn = confirm("수정하시겠습니까?"); 
		
		if(chekrtn){
			SendTojsp(JSONparam, "M909S160200E102");
		}
	}

	function SendTojsp(bomdata, pid) {
	    $.ajax({
	         type: "POST",
	         dataType: "json",
	     	 url: "<%=Config.this_SERVER_path%>/Contents/CommonView/insert_update_delete_json.jsp",
	     	 data:  {"bomdata" : bomdata, "pid" : pid },
	         success: function (html) {	 
	        	 if(html > -1) {
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
    
    function SetProductName_code(name, code, rev){
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
				   value = "<%=TableModel.getValueAt(0, 0)%>" readonly />
		</td>
	</tr>

	<tr style="background-color: #fff; height: 40px">
		<td style="font-weight:900;">CCP 타입</td>
		<td></td>
		<td>
			<%-- <select class="form-control" id="txt_CCPType" style="width: 200px">
				 <%CCPCode = (Vector)CCP_Type_Vector.get(0);%>
				<%CCPName = (Vector)CCP_Type_Vector.get(1);%>
				<%for( int i = 0 ; i < CCPName.size() ; i++ ){ %>
					<option value='<%=CCPCode.get(i).toString()%>'>
						<%=CCPName.get(i).toString()%>
					</option>
				<%} %> 
				
			</select> --%>
			<input type="text" class="form-control" id="txt_CCPType" style="width: 200px; float:left"
				   value = "<%=TableModel.getValueAt(0, 1)%>" readonly />
		</td>
	</tr>

	<tr style="background-color: #fff; height: 40px">
		<td style="font-weight:900;">최소값</td>
		<td></td>
		<td>
			<input type="text" class="form-control" id="txt_MinValue" style="width: 200px; float:left"
			       value = "<%=TableModel.getValueAt(0, 2)%>" />
		</td>
	</tr>

	<tr style="background-color: #fff; height: 40px">
		<td style="font-weight:900;">최대값</td>
		<td></td>
		<td>
			<input type="text" class="form-control" id="txt_MaxValue" style="width: 200px; float:left"
			       value = "<%=TableModel.getValueAt(0, 3)%>" />
		</td>
	</tr>

	<tr style="background-color: #fff; height: 40px">
		<td style="font-weight:900;">표준값</td>
		<td></td>
		<td>
			<input type="text" class="form-control" id="txt_StandardValue" style="width: 200px; float:left"
				   value = "<%=TableModel.getValueAt(0, 4)%>" />
		</td>
	</tr>

	<tr style="background-color: #fff; height: 40px">
		<td style="font-weight:900;">적용시작일자</td>
		<td></td>
		<td>
			<input type="text" data-date-format="yyyy-mm-dd" id="txt_StartDate" class="form-control"
				   style="width: 200px; float:left" readonly/>
		</td>
	</tr>
	
	<tr style="display:none;">
		<td>
		<input type="text" id="txt_DurationDate" class="form-control"
			   value="<%=TableModel.getValueAt(0, 6)%>" />
		</td>
	</tr>

	<tr style="background-color: #fff" >
		<td style=" font-weight: 900; font-size:14px; text-align:left" colspan="3">비고</td>
	</tr>
	<tr>
		<td colspan = "3">
			<textarea class="form-control" id="txt_Bigo"
					  style="cols:40;rows:4;resize: none;">
				<%=TableModel.getValueAt(0, 7)%>
			</textarea>
		</td>
	</tr>
</table>