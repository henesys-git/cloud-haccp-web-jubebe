<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*,java.util.*,javax.servlet.http.*"%>
<%@ page import="mes.client.comm.*" %>
<%@ page import="mes.client.common.*" %>
<%@ page import="mes.client.guiComponents.*" %>
<%@ page import="mes.client.util.*" %>
<%@ page import="mes.client.conf.*" %>
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

	/*
				.append(" values ('"	+ c_paramArray[0][0] + "' \n")	//document_no
				.append(" 		,'" 	+ c_paramArray[0][1] + "' \n") 	//revision_no
				.append(" 		,'" 	+ c_paramArray[0][2] + "' \n") 	//document_name
				.append(" 		,'" 	+ c_paramArray[0][3] + "' \n") 	//security_doc_yn
				.append(" 		,'" 	+ c_paramArray[0][4] + "' \n") 	//hold_period
				.append(" 		,'" 	+ c_paramArray[0][5] + "' \n") 	//gubun_code
				.append(" 		,'" 	+ c_paramArray[0][6] + "' \n") 	//start_date
				.append(" 		,'" 	+ c_paramArray[0][7] + "' \n") 	//duration_date
				.append(" 		,'" 	+ c_paramArray[0][8] + "' \n") 	//create_user_id
				.append(" 		,SYSDATETIME					  \n") 	//create_date
				.append(" 		,'" 	+ c_paramArray[0][10] + "' \n") //modify_user_id
				.append(" 		,'" 	+ c_paramArray[0][11] + "' \n") //modify_reason
				.append(" 		,SYSDATETIME ) \n")						//modify_date
	*/

	String[] strColumnHead = {"문서코드", "개정번호", "문서명", "보안문서여부", "보존기한", "생성일자", "문서구분코드", "문서구분명" };
	
	String GV_DOC_GUBUN="";

	if(request.getParameter("DocGubun")== null)
		GV_DOC_GUBUN="";
	else
		GV_DOC_GUBUN = request.getParameter("DocGubun");
		
	String param = GV_DOC_GUBUN + "|";
		
//    TableModel = new DoyosaeTableModel("M101S10000E214", strColumnHead, param);
//    int ColCount =TableModel.getColumnCount();CurrentPage jspPageName = new CurrentPage(request.getRequestURI());String JSPpage = jspPageName.GetJSP_FileName();
		
%>
 
<%-- <jsp:include page="../../Common/linkcss_js.jsp" flush="false"/> --%>
        
    <script type="text/javascript">
//     웹소켓 통신을 위해서 필요한 변수들 ---시작
	var M909S130100E101 = {
			PID: "M909S130100E101",  
			totalcnt: 0,
			retnValue: 999,
			colcnt: 0,
			colname: ["","","",""], //insert, Update, Delete 문장을 처리할 때는 사용되지않음
			data: []
	};  
	
	var SQL_Param = {
			PID: "M909S130100E101",
			excute: "queryProcess",
			stream: "N",
			param: + "|"
	};
	var GV_RECV_DATA = "";	//웹소켓 onMessage(event)들어온 데이터를 받는 변수
//  웹소켓 통신을 위해서 필요한 변수들 ---끝	

    var docGubunCode = "";
    var JOB_GUBUN = "";
	
	function SetRecvData(){
		DataPars(M909S130100E101,GV_RECV_DATA);
 		if(M909S130100E101.retnValue > 0)
 			alert('등록 되었습니다.');
   		
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
			dataJson.DocGubunCode = $('#select_DocGubunCode option:selected').val();
			dataJson.StartDate = $('#txt_StartDate').val();
			dataJson.user_id = "<%=loginID%>";
//    	    console.log(params);

		var chekrtn = confirm("등록하시겠습니까?"); 
		
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
	        		heneSwal.success('문서코드 정보 등록에 성공하였습니다.');
	        	   	parent.fn_MainInfo_List();
	                parent.$("#ReportNote").children().remove();
	                $('#modalReport').modal('hide');
	         	}
	        	else{
	        		heneSwal.error('문서코드 정보 수정에 실패하였습니다.');	 
	        	}
	         },
	         error: function (xhr, option, error) {

	         }
	     });		
	}
	
    
    $(document).ready(function () {

		new SetSingleDate2("", "#txt_StartDate", 0);

        var today = new Date();
        var fromday = new Date();
        fromday.setDate(today.getDate());
        

        
//        $("#select_status option:eq(1)").prop("selected", true);
//         $($("select[id='select_status']")[1]).prop("selected", true);

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
</head>
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

        <tr style="height: 40px">
            <td style="font-weight:900;">문서구분</td>
            <td></td>
            <td >
            	<select class="form-control" id="select_DocGubunCode" style="width: 200px">
	            	<%	optCode =  (Vector)DocGubunVector.get(0);%>
	                <%	optName =  (Vector)DocGubunVector.get(1);%>
	                <%for(int i=1; i<optName.size();i++){ %>
						<option value='<%=optCode.get(i).toString()%>' 
							<%=GV_DOC_GUBUN.equals(optCode.get(i).toString()) ? "selected" : "" %> >
							<%=optName.get(i).toString()%></option>
					<%} %>
				</select>
            </td>
        </tr>
        
        <tr style="background-color: #fff; height: 40px">
            <td style="font-weight:900;">문서코드</td>
            <td> </td>
            <td ><input type="text" class="form-control" id="txt_DocCode" style="width: 200px; float:left"  />
				<!-- <input type="hidden" class="form-control" id="txt_custcode" style="width: 120px" /> -->
           	</td>
        </tr>

        <tr style="background-color: #fff; height: 40px">
            <td style="font-weight:900;">문서명</td>
            <td> </td>
            <td ><input type="text" class="form-control" id="txt_DocName" style="width: 200px; float:left"  />
				<!-- <input type="hidden" class="form-control" id="txt_custcode" style="width: 120px" /> -->
           	</td>
        </tr>
        
        <tr style="background-color: #fff; height: 40px">
            <td style="font-weight:900;">개정번호</td>
            <td> </td>
            <td ><input type="text" class="form-control" id="txt_RevisionNo" value="0" style="width: 200px; float:left" readonly />
           	</td>
        </tr>
        
        <tr style="height: 40px">
            <td style="font-weight:900;">보안문서여부</td>
            <td></td>
            <td >
				<select class="form-control" id="select_Secret" style="width: 200px">
					<option value='Y'>보안</option>
					<option value='N'>비보안</option>
				</select>
            </td>
        </tr>

        <tr style="background-color: #fff; height: 40px">
            <td style="font-weight:900;">보존기한</td>
            <td> </td>
            <td ><input type="text" class="form-control" id="txt_HoldYear" style="width: 200px; float:left"  /> &nbsp;&nbsp;년
           	</td>
        </tr>
        
        <tr style="background-color: #fff; height: 40px">
            <td style="font-weight:900;">적용시작일자</td>
            <td> </td>
            <td >
            	<input type="text" data-date-format="yyyy-mm-dd" id="txt_StartDate" class="form-control"
                	style="width: 220px; border: solid 1px #cccccc;"/>
            		
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