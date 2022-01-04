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

	Vector CCPCode = new Vector();
	Vector CCPName = new Vector();

	String MEMBER_KEY = "", CODE_CD = "";

	if(request.getParameter("member_key") == null)
		MEMBER_KEY = "";
	else
		MEMBER_KEY = request.getParameter("member_key");
	
	if(request.getParameter("code_cd") == null)
		CODE_CD = "";
	else
		CODE_CD = request.getParameter("code_cd");	

	JSONObject jArray = new JSONObject();
	jArray.put("member_key", member_key);
	jArray.put("code_cd", CODE_CD);
	
	Vector CCP_Type_Vector = CommonData.getCCPType(jArray);
%>
    
<script type="text/javascript">
    
    $(document).ready(function () {
    	new SetSingleDate("", "txt_StartDate", 0)
    });
	
	function SaveOderInfo() {
		
		var dataJson = new Object();

			dataJson.member_key		= "<%=member_key%>";
			dataJson.ccp_no			= $('#txt_CCPNo').val();
			dataJson.ccp_type		= $("#txt_CCPType").val();
			dataJson.revision_no	= $('#txt_RevisionNo').val();
			dataJson.min_value		= $('#txt_MinValue').val();
			dataJson.max_value		= $('#txt_MaxValue').val();
			dataJson.standard_value	= $('#txt_StandardValue').val();
			dataJson.start_date		= $('#txt_StartDate').val();
			dataJson.bigo			= $('#txt_Bigo').val();

			if(Number(dataJson.min_value) > Number(dataJson.max_value)) {
				alert("최소값이 최대값보다 클수 없습니다.");
				return false;
			}
			
			if(dataJson.bigo = "최대 100 Byte 까지 입력 가능합니다."){
				dataJson.bigo = "";
			}
			
			console.log(dataJson.bigo);
			
			var JSONparam = JSON.stringify(dataJson);
			var chekrtn = confirm("등록하시겠습니까?"); 
			
			if(chekrtn) {
				SendTojsp(JSONparam, "M909S160200E101");
			}
	}

	function SendTojsp(bomdata, pid){
	    $.ajax({
	         type: "POST",
	         dataType: "json",
	     	 url: "<%=Config.this_SERVER_path%>/Contents/CommonView/insert_update_delete_json.jsp",
	     	 data:  {"bomdata" : bomdata, "pid" : pid },
	         success: function (html) {	 
	        	 if(html>-1){
	        	   	parent.fn_MainInfo_List();
	                parent.$("#ReportNote").children().remove();
	                $('#modalReport').modal('hide');
	         	}
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
    
    function pop_fn_CCPInfo_View(obj){
    	var modalContentUrl = "<%=Config.this_SERVER_path%>/Contents/CommonView/CCP_view.jsp"
   							+ "?member_key=" + "<%=member_key%>";

   		modalFramePopup.setTitle("CCP 정보 검색");
   		pop_fn_popUpScr_nd(modalContentUrl, "CCP 정보 검색", '500px', '1500px');

   		return false;
    }
    
    function SetCCPInfo(Number, Type, TypeName) {
    	$('#txt_CCPNo').val(Number);
    	$('#txt_CCPType').val(Type);
    	$('#txt_CCPTypeName').val(TypeName);
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

    // 비고 내용 리셋은 한 번만...
	$("#txt_Bigo").one( "click" , function(){ $("#txt_Bigo").val(""); } );
	
	// 바이트 수 체크하는 함수
	function Byte_Check( text )
	{
		var codeByte = 0;
		
		for ( var i = 0 ; i < text.length ; i++ )
		{
			var oneChar = escape(text.charAt(i));

			if ( oneChar.length == 1 )
				codeByte++;
			else if ( oneChar.indexOf("%u") != -1 )
				codeByte += 2;
			else if ( oneChar.indexOf("%") != -1 )
				codeByte++;
		}

		console.log("( 등록 ) 바이트 수 확인용 : " + codeByte);
		
		return codeByte;
	}
	
	// 키 입력이 있을 경우 Byte_Check 함수를 이용해 바이트 수 제한 걸기
	$("#txt_Bigo").keyup(function () {
		var TEXT_MAX_SIZE = 100;
		
		var Bigo_Text = $("#txt_Bigo").val();
		var Bigo_Text_Size = 0;
		
		Bigo_Text_Size = Byte_Check(Bigo_Text);
		
		if( Bigo_Text_Size > TEXT_MAX_SIZE )
		{
			alert("최대 " + TEXT_MAX_SIZE + " Byte 까지 입력 가능합니다.");
			
			$("#txt_Bigo").val(Bigo_Text.substring(0,Bigo_Text.length-1));
		}
	}); // 비고 글자 수 제한
</script>

<table class="table table-hover" style="width: 100%; margin: 0 auto; align:left">

	<tr style="background-color: #fff; height: 40px; ">
		<td style="font-weight:900;">CCP 번호</td>
		<td> </td>
		<td>
			<input type="text" class="form-control" id="txt_CCPNo" style="width: 200px; float:left" readonly/>
			<button type="button" id="btn_CCPSearch" class="btn btn-info"
					onclick="pop_fn_CCPInfo_View(this)" style="width:65px; float:left;margine-left:10px">검색</button>
		</td>
	</tr>

	<tr style="background-color: #fff; height: 40px; display:none;">
		<td style="font-weight:900;">CCP 타입 코드</td>
		<td> </td>
		<td>
			<input type="text" class="form-control" id="txt_CCPType" 
				   style="width: 200px; float:left"/>
		</td>
	</tr>
	
	<tr style="background-color: #fff; height: 40px">
		<td style="font-weight:900;">CCP 타입</td>
		<td> </td>
		<td>
			<input type="text" class="form-control" id="txt_CCPTypeName" 
				   style="width: 200px; float:left" readonly/>
		</td>
	</tr>
	
	<tr style="background-color: #fff; height: 40px">
		<td style="font-weight:900;">최소값</td>
		<td> </td>
		<td>
			<input type="text" class="form-control" id="txt_MinValue" style="width: 200px; float:left"/>
		</td>
	</tr>

	<tr style="background-color: #fff; height: 40px">
		<td style="font-weight:900;">최대값</td>
		<td> </td>
		<td>
			<input type="text" class="form-control" id="txt_MaxValue" style="width: 200px; float:left"/>
		</td>
	</tr>

	<tr style="background-color: #fff; height: 40px">
		<td style="font-weight:900;">표준값</td>
		<td> </td>
		<td>
			<input type="text" class="form-control" id="txt_StandardValue" 
				   style="width: 200px; float:left"/>
		</td>
	</tr>

	<tr style="background-color: #fff; height: 40px">
		<td style="font-weight:900;">한계기준 개정번호</td>
		<td> </td>
		<td>
			<input type="text" class="form-control" id="txt_RevisionNo" 
				   value="0" style="width: 200px; float:left" readonly />
		</td>
	</tr>

	<tr style="background-color: #fff; height: 40px">
		<td style="font-weight:900;">적용시작일자</td>
		<td> </td>
		<td>
			<input type="text" class="form-control" id="txt_StartDate" value="0" style="width: 200px; float:left"/>
		</td>
	</tr>

	<tr style="background-color: #fff" >
		<td style=" font-weight: 900; font-size:14px; text-align:left" colspan="3">비고</td>
	</tr>
	<tr>
		<td colspan = "3">
			<textarea class="form-control" id="txt_Bigo"
					  style="cols:40;rows:4;resize: none;width: 100%;" placeholder="최대 100 Byte 까지 입력 가능합니다.">
			</textarea>
		</td>
	</tr>
</table>
