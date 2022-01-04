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
    
	String[] strColumnHead = {"공통코드그룹", "공통코드", "공통코드명", "개정번호", "비고"} ;
	
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
	
    TableModel = new DoyosaeTableModel("M909S120100E204", strColumnHead, jArray);
    int ColCount =TableModel.getColumnCount();CurrentPage jspPageName = new CurrentPage(request.getRequestURI());String JSPpage = jspPageName.GetJSP_FileName();
		
    // 데이터를 가져온다.
    Vector targetCustVector = (Vector)(TableModel.getVector().get(0));
    
    System.out.println("targetCustVector : " + targetCustVector.toString());
		
%>
 
<%-- <jsp:include page="../../Common/linkcss_js.jsp" flush="false"/> --%>
        
    <script type="text/javascript">
//     웹소켓 통신을 위해서 필요한 변수들 ---시작
	var M909S120100E103 = {
			PID: "M909S120100E103",  
			totalcnt: 0,
			retnValue: 999,
			colcnt: 0,
			colname: ["","","",""], //insert, Update, Delete 문장을 처리할 때는 사용되지않음
			data: []
	};  
	
	var SQL_Param = {
			PID: "M909S120100E103",
			excute: "queryProcess",
			stream: "N",
			param: + "|"
	};
	var GV_RECV_DATA = "";	//웹소켓 onMessage(event)들어온 데이터를 받는 변수
//  웹소켓 통신을 위해서 필요한 변수들 ---끝	

    var groupCodeGubun = "";
	
	function SetRecvData(){
		if (confirm("정말 삭제하시겠습니까?") != true) {
			return;
		}

		DataPars(M909S120100E103, GV_RECV_DATA);
 		if(M909S120100E103.retnValue > 0)
 			alert('삭제 되었습니다.');
   		
   		parent.fn_MainInfo_List();
 		parent.$('#modalReport').hide();
	}
	
	function SaveOderInfo() {
		if ($('#txt_ProcCd').val().length < 1) {
			alert("공정코드를 입력하세요.");
			return;
		}
		
		var delete_check = confirm("가장 최근의 Rev(개정번호)에 대한 공정코드정보를 삭제합니다." + "\n" + "삭제하시겠습니까?");
		
		if(delete_check) {
			
     		var dataJson = new Object(); // jSON Object 선언 
     			dataJson.start_date_for_delete_data = $('#txt_StartDate').val();
     			dataJson.start_date = getFormatDate(new Date());
				dataJson.proc_cd = $('#txt_ProcCd').val();
                dataJson.RevisionNo_Target = "<%=targetCustVector.get(1).toString() %>"; // 삭제할 데이터의 공정개정번호
                dataJson.member_key = "<%=member_key%>";
                
    		SendTojsp(JSON.stringify(dataJson), "M909S120100E103");
    		
		}
	}
 
	function SendTojsp(bomdata, pid){
		
	    $.ajax({
	         type: "POST",
	         dataType: "json", // Ajax로 json타입으로 보낸다.
	         url: "<%=Config.this_SERVER_path%>/Contents/CommonView/insert_update_delete_json.jsp", 
	         data:  "bomdata=" + bomdata + "&pid=" + pid,
	         success: function (html) {
	        	 if(html>-1){
	        		heneSwal.success('정보 삭제에 성공하였습니다.');
	        	   	parent.fn_MainInfo_List();
	                parent.$("#ReportNote").children().remove();
	                $('#modalReport').modal('hide');
	         	}
	        	 else{
	        		 heneSwal.error('정보 삭제에 실패하였습니다.');
	        	 }
	         },
	         error: function (xhr, option, error) {

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
   
 	// 날짜를 'YYYY-MM-DD'꼴로 변환하는 함수
    function getFormatDate(date)
    {
		var year = date.getFullYear();				// YYYY
		var month = ( date.getMonth() + 1 );		// M
		var day = date.getDate();					// D
		
		month = month >= 10 ? month : '0' + month;	//달을 두 자리로
		Day = day >= 10 ? day : '0' + day;			// 날을 두 자리로

		return year + '-' + month + '-' + day;
	}
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
            		value="<%=targetCustVector.get(2).toString()%>" readonly/>
           	</td>
        </tr>

        <tr style="background-color: #fff; height: 40px">
            <td>공정순번</td>
            <td> </td>
            <td ><input type="text" class="form-control" id="txt_ProcSeq" style="width: 200px; float:left" 
            		value="<%=targetCustVector.get(3).toString()%>" readonly/>
           	</td>
        </tr>
        
        <tr style="background-color: #fff; height: 40px">
            <td>작업순서</td>
            <td> </td>
            <td ><input type="text" class="form-control" id="txt_WorkOrderIndex" style="width: 200px; float:left" 
            		value="<%=targetCustVector.get(4).toString()%>" readonly/>
           	</td>
        </tr>
        
        <tr style="background-color: #fff; height: 40px">
            <td>생산공정 적용여부</td>
            <td> </td>
			<td>
			<%if(targetCustVector.get(5).toString().equals("Y")) {%>
				<input type = "radio" name = "product_process_yn" value="Y" checked disabled /> 적용 &nbsp;
				<input type = "radio" name = "product_process_yn" value="N" disabled /> 미적용
			<%} else {%>
				<input type = "radio" name = "product_process_yn" value="Y" disabled /> 적용 &nbsp;
				<input type = "radio" name = "product_process_yn" value="N" checked disabled /> 미적용
			<%}%>
			</td>
        </tr>
        
        <tr style="background-color: #fff; height: 40px">
            <td>포장공정 적용여부</td>
            <td></td>
			<td>
			<%if(targetCustVector.get(6).toString().equals("Y")) {%>
				<input type = "radio" name = "packing_process_yn" value="Y" checked disabled /> 적용 &nbsp;
				<input type = "radio" name = "packing_process_yn" value="N" disabled /> 미적용
			<%} else {%>
				<input type = "radio" name = "packing_process_yn" value="Y" disabled /> 적용 &nbsp;
				<input type = "radio" name = "packing_process_yn" value="N" checked disabled/> 미적용
			<%}%>
			</td>
			<td></td>
        </tr>
        
        <tr style="background-color: #fff; height: 40px">
            <td>개정번호</td>
            <td> </td>
            <td ><input type="text" class="form-control" id="txt_RevisionNo" style="width: 200px; float:left" readonly 
            		value="<%=targetCustVector.get(1).toString()%>" readonly />
           	</td>
        </tr>
        
        <tr style="background-color: #fff; height: 40px">
            <td>적용시작일자</td>
            <td></td>
            <td>
                <input type="text" id="txt_StartDate" class="form-control" style="width: 200px; border: solid 1px #cccccc;"
                	value="<%=targetCustVector.get(8).toString()%>" readonly/>
            		
           	</td>
        </tr>
        
        <tr style="background-color: #fff" >
            <td style=" font-weight: 900; font-size:14px; text-align:left" colspan="3">비고</td>
        </tr>
        <tr>
            <td colspan="3"><textarea class="form-control" id="txt_Bigo" style="cols:40;rows:4;resize: none;" readonly ><%=targetCustVector.get(7).toString()%></textarea></td>
        </tr>
    </table>