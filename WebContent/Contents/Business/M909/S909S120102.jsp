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
    Vector optCode =  null;
    Vector optName =  null;
    Vector codeGroupVector = CommonData.getCodeGroupDataAll(member_key);
    
	String GV_PROC_CD="", GV_REVISION_NO="";

	String GV_TODAY = Common.getSystemTime("date");

	if(request.getParameter("ProcCd")== null)
		GV_PROC_CD="";
	else
		GV_PROC_CD = request.getParameter("ProcCd");
	
	if(request.getParameter("RevisionNo")== null)
		GV_REVISION_NO="";
	else
		GV_REVISION_NO = request.getParameter("RevisionNo");

	String param = GV_PROC_CD + "|" + GV_REVISION_NO + "|";
	
	JSONObject jArray = new JSONObject();
	jArray.put( "PROC_CD", GV_PROC_CD);
	jArray.put( "REVISION_NO", GV_REVISION_NO);
	jArray.put( "member_key", member_key);
	
    TableModel = new DoyosaeTableModel("M909S120100E204", jArray);
    int ColCount =TableModel.getColumnCount();
    CurrentPage jspPageName = new CurrentPage(request.getRequestURI());
    String JSPpage = jspPageName.GetJSP_FileName();
		
    // 데이터를 가져온다.
    Vector targetCustVector = (Vector)(TableModel.getVector().get(0));

    // 개정번호를 만든다.
    String revisionNumberStrForUpdate = "";
    int revisionNoIntForUpdate = 0;
    try {
		revisionNoIntForUpdate = Integer.parseInt( targetCustVector.get(1).toString().trim() );
    } catch (Exception e) {
    	revisionNoIntForUpdate = 0;
    }
    
    revisionNoIntForUpdate = revisionNoIntForUpdate + 1;
    revisionNumberStrForUpdate = "" + revisionNoIntForUpdate;
    
    for( int i = 0 ; i < 16 ; i++ )
    {
    	System.out.println( "targetCustVector.get(" + i + ") : " + targetCustVector.get(i).toString().trim() );    	
    }
    
    
		
%>
 
<script type="text/javascript">

    var groupCodeGubun = "";
	
	function SaveOderInfo() {
		if( $('#txt_StartDate').val() > $('#txt_DurationDate').val() )
		{
			heneSwal.warning("가장 최근의 Rev(개정번호)에 대한 공정코드정보가 아닙니다.");
			return;
		}
		if ($('#txt_ProcCd').val().length < 1) {
			heneSwal.warning("공정코드를 입력하세요.");
			return;
		}

		var dataJson = new Object();
			dataJson.process_gubun		= $('#txt_ProcCd').val().substring(0,6);
			dataJson.proc_code_gb_big	= $('#txt_ProcCd').val().split('-')[2].substring(0,2);
			dataJson.proc_code_gb_mid	= $('#txt_ProcCd').val().split('-')[2];
			dataJson.proc_cd			= $('#txt_ProcCd').val();
			dataJson.process_nm			= $('#txt_ProcName').val();
			dataJson.work_order_index	= $('#txt_WorkOrderIndex').val();
			dataJson.process_seq		= $('#txt_ProcSeq').val();
			dataJson.product_process_yn	= $('input[name = "product_process_yn"]:checked').val();
			dataJson.packing_process_yn	= $('input[name = "packing_process_yn"]:checked').val();
			dataJson.bigo				= $('#txt_Bigo').val();
			dataJson.after_start_date	= $('#txt_StartDate').val();
			dataJson.user_id			= "<%=loginID%>";
			dataJson.revision_no		= $('#txt_RevisionNo').val();
			dataJson.member_key			= "<%=member_key%>";
			
			dataJson.RevisionNo_Target = "<%=targetCustVector.get(1).toString() %>";
			
		var chekrtn = confirm("수정하시겠습니까?"); 
			
		if(chekrtn){	
			SendTojsp(JSON.stringify(dataJson), "M909S120100E102");
		}
	}
 
	function SendTojsp(bomdata, pid){
		
	    $.ajax({
	         type: "POST",
	         dataType: "json",
	         url: "<%=Config.this_SERVER_path%>/Contents/CommonView/insert_update_delete_json.jsp", 
	         data:  "bomdata=" + bomdata + "&pid=" + pid,
	         success: function (html) {
	        	 if(html>-1){
	        		heneSwal.success('정보 수정에 성공하였습니다.');
	        	   	parent.fn_MainInfo_List();
	                parent.$("#ReportNote").children().remove();
	                $('#modalReport').modal('hide');
	         	}
	        	 else{
	        		 heneSwal.error('정보 수정에 실패하였습니다.');
	        	 }
	         }
	     });		
	}
	
    
    $(document).ready(function () {

    	new SetSingleDate2("", "#txt_StartDate", 0);   

        var today = new Date();
        var fromday = new Date("<%=targetCustVector.get(8).toString()%>");
       
    });


    function fn_CommonPopupModal(sUrl, name, w, h) { // url, name, width, height, 기타 속성(생략해도 무방)     	
        var popupWin = window.showModalDialog(sUrl, name, 'dialogWidth:' + w + 'px; dialogHeight:' + h 
                + 'px; center:yes; help:no; status:no; resizable:no; scroll:yes; toolbar :no;');
    	if(typeof(popupWin)=="undefine")
    		popupWin = window.returnValue;
		return popupWin;
    }
    
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

		console.log("( 수정 )바이트 수 확인용 : " + codeByte);
		
		return codeByte;
	}
	
	// 키 입력이 있을 경우 Byte_Check 함수를 이용해 바이트 수 제한 걸기
	$("#txt_ProcName").keyup(function () {
		var TEXT_MAX_SIZE = 10;
		
		var Proc_Name_Text = $("#txt_ProcName").val();
		var Proc_Name_Text_Size = 0;
		
		Proc_Name_Text_Size = Byte_Check(Proc_Name_Text);
		
		if( Proc_Name_Text_Size > TEXT_MAX_SIZE )
		{
			alert("최대 " + TEXT_MAX_SIZE + " Byte 까지 입력 가능합니다.");
			
			$("#txt_ProcName").val(Proc_Name_Text.substring(0,Proc_Name_Text.length-1));
		}
	}); // 공정코드명 글자 수 제한

	$("#txt_Bigo").keyup(function () {
		var TEXT_MAX_SIZE = 10;
		
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
   		
        <tr style="background-color: #fff; height: 40px">
            <td>공정코드</td>
            <td> </td>
            <td ><input type="text" class="form-control" id="txt_ProcCd" style="width: 200px; float:left" 
            		value="<%=targetCustVector.get(0).toString()%>" readonly />
            	<input type="hidden" class="form-control" id="txt_ProcessGubun" style="width: 200px; float:left" 
            		value="<%=targetCustVector.get(15).toString()%>" readonly />
           	</td>
        </tr>

        <tr style="background-color: #fff; height: 40px">
            <td>공정코드명</td>
            <td> </td>
            <td ><input type="text" class="form-control" id="txt_ProcName" style="width: 200px; float:left" 
            		value="<%=targetCustVector.get(2).toString()%>" />
           	</td>
        </tr>

        <tr style="background-color: #fff; height: 40px">
            <td>공정순번</td>
            <td> </td>
            <td ><input type="text" class="form-control" id="txt_ProcSeq" style="width: 200px; float:left" 
            		value="<%=targetCustVector.get(3).toString()%>" />
           	</td>
        </tr>
        
        <tr style="background-color: #fff; height: 40px">
            <td>작업순서</td>
            <td> </td>
            <td ><input type="text" class="form-control" id="txt_WorkOrderIndex" style="width: 200px; float:left" 
            		value="<%=targetCustVector.get(4).toString()%>" />
           	</td>
        </tr>
        
        <tr style="background-color: #fff; height: 40px">
            <td>생산공정 적용여부</td>
            <td> </td>
			<td>
			<%if(targetCustVector.get(5).toString().equals("Y")) {%>
				<input type = "radio" name = "product_process_yn" value="Y" checked/> 적용 &nbsp;
				<input type = "radio" name = "product_process_yn" value="N" /> 미적용
			<%} else {%>
				<input type = "radio" name = "product_process_yn" value="Y" /> 적용 &nbsp;
				<input type = "radio" name = "product_process_yn" value="N" checked/> 미적용
			<%}%>
			</td>
        </tr>
        
        <tr style="background-color: #fff; height: 40px">
            <td>포장공정 적용여부</td>
            <td></td>
			<td>
			<%if(targetCustVector.get(6).toString().equals("Y")) {%>
				<input type = "radio" name = "packing_process_yn" value="Y" checked/> 적용 &nbsp;
				<input type = "radio" name = "packing_process_yn" value="N" /> 미적용
			<%} else {%>
				<input type = "radio" name = "packing_process_yn" value="Y" /> 적용 &nbsp;
				<input type = "radio" name = "packing_process_yn" value="N" checked/> 미적용
			<%}%>
			</td>
			<td></td>
        </tr>
        
        <tr style="background-color: #fff; height: 40px">
            <td>개정번호</td>
            <td> </td>
            <td ><input type="text" class="form-control" id="txt_RevisionNo" style="width: 200px; float:left" readonly 
            		value="<%=revisionNumberStrForUpdate%>" readonly />
           	</td>
        </tr>
        
        <tr style="background-color: #fff; height: 40px">
            <td>적용시작일자</td>
            <td> </td>
            <td>
            	<input type="text" data-date-format="yyyy-mm-dd" id="txt_StartDate" class="form-control"
            	style="width: 200px; float:left" readonly/> 
            		<%-- value="<%=targetCustVector.get(8).toString()%>" --%>
					
           	</td>
        </tr>
        
        <tr style="background-color: #fff" >
            <td style=" font-weight: 900; font-size:14px; text-align:left" colspan="3">비고</td>
        </tr>
        <tr>
            <td colspan="3"><textarea class="form-control" id="txt_Bigo" style="cols:40;rows:4;resize: none;" ><%=targetCustVector.get(7).toString()%></textarea></td>
        </tr>
        <tr style="display:none;">
        	<td>
        		<input type = "text" id = "txt_DurationDate" class="form-control"
				value="<%=targetCustVector.get(9).toString()%>" />
			</td>
        </tr>
    </table>