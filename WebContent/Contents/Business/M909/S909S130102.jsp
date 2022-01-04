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

	DoyosaeTableModel TableModel;
	String zhtml = "";
    Vector optCode =  null;
    Vector optName =  null;
	Vector DocGubunVector = CommonData.getDocGubunCDAll(member_key);

	String[] strColumnHead = {"문서코드", "개정번호", "문서명", "보안문서여부", "보존기한", "생성일자", "문서구분코드", "문서구분명" };
	
	String GV_DOC_NO="", GV_REVISION_NO="";

	if(request.getParameter("DocNo")== null)
		GV_DOC_NO="";
	else
		GV_DOC_NO = request.getParameter("DocNo");

	if(request.getParameter("RevisionNo")== null)
		GV_REVISION_NO="";
	else
		GV_REVISION_NO = request.getParameter("RevisionNo");

	String param = GV_DOC_NO + "|" + GV_REVISION_NO + "|";
	
	JSONObject jArray = new JSONObject();
	jArray.put( "member_key", member_key);
	jArray.put( "DOC_NO", GV_DOC_NO);
	jArray.put( "REVISION_NO", GV_REVISION_NO);
		
    TableModel = new DoyosaeTableModel("M909S130100E204", strColumnHead, jArray);
    int ColCount =TableModel.getColumnCount();CurrentPage jspPageName = new CurrentPage(request.getRequestURI());String JSPpage = jspPageName.GetJSP_FileName();
		
    // 데이터를 가져온다.
    Vector targetCustVector = (Vector)(TableModel.getVector().get(0));

    // 개정번호를 만든다.
    String revisionNumberStr = "";
    int revisionNoInt = 0;
    try {
		revisionNoInt = Integer.parseInt( targetCustVector.get(1).toString().trim() );
    } catch (Exception e) {
    	revisionNoInt = 0;
    }
    revisionNoInt = revisionNoInt + 1;
    revisionNumberStr = "" + revisionNoInt;

%>
 
<%-- <jsp:include page="../../Common/linkcss_js.jsp" flush="false"/> --%>
        
    <script type="text/javascript">
//     웹소켓 통신을 위해서 필요한 변수들 ---시작
	var M909S130100E102 = {
			PID: "M909S130100E010",  
			totalcnt: 0,
			retnValue: 999,
			colcnt: 0,
			colname: ["","","",""], //insert, Update, Delete 문장을 처리할 때는 사용되지않음
			data: []
	};  
	
	var SQL_Param = {
			PID: "M909S130100E010",
			excute: "queryProcess",
			stream: "N",
			param: + "|"
	};
	var GV_RECV_DATA = "";	//웹소켓 onMessage(event)들어온 데이터를 받는 변수
//  웹소켓 통신을 위해서 필요한 변수들 ---끝	

    var docGubunCode = "";
    var JOB_GUBUN = "";
	
	function SetRecvData(){
		DataPars(M909S130100E102,GV_RECV_DATA);
 		if(M909S130100E102.retnValue > 0)
 			alert('수정 되었습니다.');
   		
   		parent.fn_MainInfo_List();
 		parent.$('#modalReport').hide();
	}
	
	function SaveOderInfo() {
		if ($('#txt_DocCode').val().length < 1) {
			alert("문서코드를 입력하세요.");
			return;
		}
		if ($('#txt_DocName').val().length < 1) {
			alert("문서명을 입력하세요.");
			return;
		}
		
		var WebSockData="";
    		var dataJson = new Object(); // jSON Object 선언 
    		dataJson.member_key = "<%=member_key%>";
			dataJson.DocCode = $('#txt_DocCode').val();
			dataJson.RevisionNo = $('#txt_RevisionNo').val();
			dataJson.DocName = $('#txt_DocName').val();
			dataJson.Secret = $('#select_Secret option:selected').val();
			dataJson.HoldYear = $('#txt_HoldYear').val();
			dataJson.DocGubunCode = $("#txt_DocGubunCode").val();
			dataJson.StartDate = $('#txt_StartDate').val();
			dataJson.user_id = "<%=loginID%>";
			dataJson.RevisionNo_Target = "<%=targetCustVector.get(1).toString() %>";

//    	    console.log(params);

		var chekrtn = confirm("수정하시겠습니까?"); 
		
		if(chekrtn){

			SendTojsp(JSON.stringify(dataJson), SQL_Param.PID); // 보내는 데이터묶음 하나일때 => Object하나만
// 			SendTojsp(urlencode(params),SQL_Param.PID);
		}
	}
 
	function SendTojsp(bomdata, pid){
		
	    $.ajax({
	         type: "POST",
	         dataType: "json", // Ajax로 json타입으로 보낸다.
	         url: "<%=Config.this_SERVER_path%>/Contents/CommonView/insert_update_delete_json.jsp", 
	         data:  "bomdata=" + bomdata + "&pid=" + pid,
	         beforeSend: function () {
//	         	 alert(bomdata);
	         },	         
	         success: function (html) {
	        	 if(html>-1){
	        		heneSwal.success('문서코드 정보 수정에 성공하였습니다.');
	        	   	parent.fn_MainInfo_List();
	                parent.$("#ReportNote").children().remove();
	                $('#modalReport').modal('hide');
	         	}
	        	 else{
	        		heneSwal.error('문서코드 정보 수정에 성공하였습니다.');
	        	 }
	         },
	         error: function (xhr, option, error) {

	         }
	     });		
	}
	
    
    $(document).ready(function () {

    	new SetSingleDate2("", "#txt_StartDate", 0);

        var today = new Date();
        var fromday = new Date("<%=targetCustVector.get(7).toString()%>");
        //fromday.setDate(today.getDate());

	    $("#select_DocGubunCode").on("change", function(){
	    	docGubunCode = $(this).val();
	    });
    });


    function fn_CommonPopupModal(sUrl, name, w, h) { // url, name, width, height, 기타 속성(생략해도 무방)     	
        var popupWin = window.showModalDialog(sUrl, name, 'dialogWidth:' + w + 'px; dialogHeight:' + h 
                + 'px; center:yes; help:no; status:no; resizable:no; scroll:yes; toolbar :no;');
    	if(typeof(popupWin)=="undefine")
    		popupWin = window.returnValue;
		return popupWin;
    }  
    
    function SetDocName_code(name, code){
		$('#txt_DocName').val(name);
		$('#txt_DocCode').val(code);
    }
    

    </script>
<!-- </head> -->
<body>
<!--    <table class="table table-hover" style="width: 100%; margin: 0 auto; align:left"> -->
<!-- <form id="mesfrm"> -->
   <table class="table table-hover" style="width: 100%; margin: 0 auto; align:left">
   		<!--
        <tr style="background-color: #fff; height: 40px">
            <td style="width: 25%; font-weight: 900; font-size:14px; text-align:left">주문 고객사</td>
            <td style="width: 2%; font-weight: 900; font-size:14px; text-align:left"> </td>
            <td style="width: 73%; font-weight: 900; font-size:14px; text-align:left">
				<input type="text" class="form-control" id="txt_CustName" style="width: 150px; float:left"  />
				<input type="hidden" class="form-control" id="txt_custcode" style="width: 120px" />
				<label style="float:left">&nbsp;</label>
				<button type="button" onclick="parent.pop_fn_CustName_View(1,'O')" id="btn_SearchCust" class="btn btn-info" style="float:left">
				    고객사검색</button> 
           	</td>
        </tr>
        -->
        
        <tr style="background-color: #fff; height: 40px">
            <td style="font-weight:900;">문서구분</td>
            <td> </td>
            <td ><input type="text" class="form-control" id="txt_DocGubunName" style="width: 200px; float:left"	
            		value="<%=targetCustVector.get(6).toString()%>" readonly />
            	 <input type="hidden" class="form-control" id="txt_DocGubunCode" style="width: 120px" 
            	 	value="<%=targetCustVector.get(5).toString()%>" />
           	</td>
        </tr>
        
        <tr style="background-color: #fff; height: 40px">
            <td style="font-weight:900;">문서코드</td>
            <td> </td>
            <td >
            	<input type="text" class="form-control" id="txt_DocCode" style="width: 200px; float:left" 
            		value="<%=targetCustVector.get(0).toString() %>" readonly />
           	</td>
        </tr>

        <tr style="background-color: #fff; height: 40px">
            <td style="font-weight:900;">문서명</td>
            <td> </td>
            <td >
            	<input type="text" class="form-control" id="txt_DocName" style="width: 200px; float:left" 
            		value="<%=targetCustVector.get(2).toString() %>" />
           	</td>
        </tr>
        
        <tr style="background-color: #fff; height: 40px">
            <td style="font-weight:900;">개정번호</td>
            <td> </td>
            <td ><input type="text" class="form-control" id="txt_RevisionNo" style="width: 200px; float:left"	
            		value="<%=revisionNumberStr%>" readonly />
           	</td>
        </tr>
        
        <tr style="height: 40px">
            <td style="font-weight:900;">보안문서여부</td>
            <td></td>
            <td >
				<select class="form-control" id="select_Secret" style="width: 200px">
					<option value='Y' <%=targetCustVector.get(3).toString().equals("Y") ? "selected" : "" %> >보안</option>
					<option value='N' <%=targetCustVector.get(3).toString().equals("N") ? "selected" : "" %> >비보안</option>
				</select>
            </td>
        </tr>

        <tr style="background-color: #fff; height: 40px">
            <td style="font-weight:900;">보존기한</td>
            <td> </td>
            <td >
            	<input type="text" class="form-control" id="txt_HoldYear" style="width: 200px; float:left" 
            		value="<%=targetCustVector.get(4).toString() %>" /> &nbsp;&nbsp;년
           	</td>
        </tr>
        
        <tr style="background-color: #fff; height: 40px">
            <td style="font-weight:900;">적용시작일자</td>
            <td> </td>
            <td >
            	<input type="text" data-date-format="yyyy-mm-dd" id="txt_StartDate" class="form-control" style="width: 220px; border: solid 1px #cccccc;" />
            		
           	</td>
        </tr>
        
        <!-- 
        <tr style="background-color: #fff" >
            <td style=" font-weight: 900; font-size:14px; text-align:left" colspan="3">비고</td>
        </tr>
        <tr>
            <td colspan="3"><textarea class="form-control" id="txt_bigo"  style="cols:40;rows:4" >
            </textarea></td>
        </tr>
         -->
        

        <tr style="height: 60px">
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