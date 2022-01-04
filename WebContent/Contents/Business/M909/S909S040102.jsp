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
    Vector optCode =  null;
    Vector optName =  null;
    Vector itemTypeVector = CommonData.getItemTypeCDAll(member_key);
	
	String[] strColumnHead = {"", "", "", "", ""} ;
	
	String GV_ITEM_CD = "", GV_REVISION_NO = "", GV_ITEM_SEQ = "";
	
	if(request.getParameter("ItemCd") != null)
		GV_ITEM_CD = request.getParameter("ItemCd");
	
	if(request.getParameter("RevisionNo") != null)
		GV_REVISION_NO = request.getParameter("RevisionNo");

	if(request.getParameter("ItemSeq") != null)
		GV_ITEM_SEQ = request.getParameter("ItemSeq");

	JSONObject jArray = new JSONObject();
	jArray.put( "member_key", member_key);
	jArray.put( "ITEM_CD", GV_ITEM_CD);
	jArray.put( "REVISION_NO", GV_REVISION_NO);
	jArray.put( "ITEM_SEQ", GV_ITEM_SEQ);
	
	TableModel = new DoyosaeTableModel("M909S040100E204", strColumnHead, jArray);
		
	// 데이터를 가져온다.
	Vector targetVector = (Vector)(TableModel.getVector().get(0));
	
	// 개정번호를 만든다.
	String revisionNumberStr = "";
	int revisionNoInt = 0;
	try {
		revisionNoInt = Integer.parseInt( targetVector.get(1).toString().trim() );
	} catch (Exception e) {
		revisionNoInt = 0;
	}
	revisionNoInt = revisionNoInt + 1;
	revisionNumberStr = "" + revisionNoInt;
		
%>
 
<script type="text/javascript">
//     웹소켓 통신을 위해서 필요한 변수들 ---시작
	var M909S040100E102 = {
			PID: "M909S040100E102",  
			totalcnt: 0,
			retnValue: 999,
			colcnt: 0,
			colname: ["","","",""], //insert, Update, Delete 문장을 처리할 때는 사용되지않음
			data: []
	};  
	
	var SQL_Param = {
			PID: "M909S040100E102",
			excute: "queryProcess",
			stream: "N",
			param: + "|"
	};
	var GV_RECV_DATA = "";	//웹소켓 onMessage(event)들어온 데이터를 받는 변수
//  웹소켓 통신을 위해서 필요한 변수들 ---끝	

    var groupCodeGubun = "";
	
	function SetRecvData(){
		DataPars(M909S040100E102, GV_RECV_DATA);
 		if(M909S040100E102.retnValue > 0)
 			alert('수정 되었습니다.');
   		
   		parent.fn_MainInfo_List();
 		parent.$('#modalReport').hide();
	}
	
	function SaveOderInfo() {
		if ($('#txt_ItemCode').val().length < 1) {
			alert("체크항목코드를 입력하세요.");
			return;
		}

		var WebSockData="";
     	var dataJson = new Object(); // jSON Object 선언 
     		dataJson.member_key = "<%=member_key%>";
	     	dataJson.ItemCode = $('#txt_ItemCode').val();
	     	dataJson.RevisionNo = $('#txt_RevisionNo').val();
	     	dataJson.ItemName = $('#txt_ItemName').val();
	     	dataJson.ItemTypeGubun = $("#select_ItemTypeGubun option:selected").val();
	     	dataJson.Bigo = $('#txt_Bigo').val();
	     	dataJson.ItemSeq = $('#txt_ItemSeq').val();
	     	dataJson.StartDate = $('#txt_StartDate').val();
	     	dataJson.user_id = "<%=loginID%>";
	     	dataJson.RevisionNo_Target = "<%=targetVector.get(1).toString() %>";
	     	
	     	var chekrtn = confirm("수정하시겠습니까?"); 
			
			if(chekrtn){
      			SendTojsp(JSON.stringify(dataJson), SQL_Param.PID); // 보내는 데이터묶음 하나일때 => Object하나만
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
	        		heneSwal.success('수정에 성공하였습니다.');
	        	   	parent.fn_MainInfo_List();
	                parent.$("#ReportNote").children().remove();
	                $('#modalReport').modal('hide'); 
	         	}
	        	 else{
	        		heneSwal.error('수정에 실패하였습니다. 다시 시도해주세요.'); 
	        	 }
	         }
	     });		
	}
	
    
    $(document).ready(function () {

    	new SetSingleDate2("", "#txt_StartDate", 0);

        var today = new Date();
        var fromday = new Date("<%=targetVector.get(7).toString()%>");
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

   <table class="table table-hover" style="width: 100%; margin: 0 auto; align:left">
        
        <tr style="height: 40px">
            <td style="font-weight:900;">체크항목유형</td>
            <td></td>
            <td>
				<select class="form-control" id="select_ItemTypeGubun" style="width: 200px" disabled>
	            	<%	optCode = (Vector)itemTypeVector.get(2);%>
	                <%	optName = (Vector)itemTypeVector.get(1);%>
	                <%for(int i=0; i<optName.size();i++){ %>
						<option value='<%=optCode.get(i).toString()%>' 
							<%=targetVector.get(4).toString().equals(optCode.get(i).toString()) ? "selected" : "" %> >
							<%=optName.get(i).toString()%></option>
					<%} %>
				</select>
            </td>
        </tr>
        
        <tr style="background-color: #fff; height: 40px">
            <td style="font-weight:900;">체크항목코드</td>
            <td> </td>
            <td ><input type="text" class="form-control" id="txt_ItemCode" style="width: 200px; float:left" 
            		value="<%=targetVector.get(0).toString()%>" readonly />
           	</td>
        </tr>

        <tr style="background-color: #fff; height: 40px">
            <td style="font-weight:900;">체크항목명</td>
            <td> </td>
            <td ><input type="text" class="form-control" id="txt_ItemName" style="width: 200px; float:left" 
            		value="<%=targetVector.get(2).toString()%>"  />
           	</td>
        </tr>

        <tr style="background-color: #fff" >
            <td style=" font-weight: 900; font-size:14px; text-align:left" colspan="3">비고</td>
        </tr>
        <tr>
            <td colspan="3"><textarea class="form-control" id="txt_Bigo"  style="cols:40;rows:4;resize: none;" ><%=targetVector.get(5).toString()%></textarea></td>
        </tr>

        <tr style="background-color: #fff; height: 40px">
            <td style="font-weight:900;">일련번호</td>
            <td> </td>
            <td ><input type="text" class="form-control" id="txt_ItemSeq" style="width: 200px; float:left"
            		value="<%=targetVector.get(6).toString()%>"  readonly />
           	</td>
        </tr>
        
        <tr style="background-color: #fff; height: 40px">
            <td style="font-weight:900;">개정번호</td>
            <td> </td>
            <td ><input type="text" class="form-control" id="txt_RevisionNo" style="width: 200px; float:left" 
            		value="<%=revisionNumberStr%>" readonly />
           	</td>
        </tr>
        
        <tr style="background-color: #fff; height: 40px">
            <td style="font-weight:900;">적용시작일자</td>
            <td> </td>
            <td >
            	<input type="text" data-date-format="yyyy-mm-dd" id="txt_StartDate" class="form-control"
                	style="width: 220px; border: solid 1px #cccccc;" />
            		
           	</td>
        </tr>
    </table>