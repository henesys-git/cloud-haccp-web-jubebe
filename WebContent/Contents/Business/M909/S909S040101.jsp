<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*,java.util.*,javax.servlet.http.*"%>
<%@ page import="mes.client.comm.*" %>
<%@ page import="mes.client.common.*" %>
<%@ page import="mes.client.guiComponents.*" %>
<%@ page import="mes.client.util.*" %>
<%@ page import="mes.client.conf.*" %>
<%
	String loginID = session.getAttribute("login_id").toString();
	String member_key = session.getAttribute("member_key").toString();

	DoyosaeTableModel TableModel;
	String zhtml = "";
    Vector optCode =  null;
    Vector optName =  null;
    Vector itemTypeVector = CommonData.getItemTypeCDAll(member_key);
    
	String[] strColumnHead = {"", "", "", "", ""} ;
	
	String GV_ITEM_TYPE = "";

	if(request.getParameter("CheckItemType") != null)
		GV_ITEM_TYPE = request.getParameter("CheckItemType");
	
	String GV_TODAY = Common.getSystemTime("date");
%>
 
        
<script type="text/javascript">
//     웹소켓 통신을 위해서 필요한 변수들 ---시작
	var M909S040100E101 = {
			PID: "M909S040100E101",  
			totalcnt: 0,
			retnValue: 999,
			colcnt: 0,
			colname: ["","","",""], //insert, Update, Delete 문장을 처리할 때는 사용되지않음
			data: []
	};  
	
	var SQL_Param = {
			PID: "M909S040100E101",
			excute: "queryProcess",
			stream: "N",
			param: + "|"
	};
	var GV_RECV_DATA = "";	//웹소켓 onMessage(event)들어온 데이터를 받는 변수
//  웹소켓 통신을 위해서 필요한 변수들 ---끝	

    var groupCodeGubun = "";
	
	function SetRecvData(){
		DataPars(M909S040100E101, GV_RECV_DATA);
 		if(M909S040100E101.retnValue > 0)
 			alert('등록 되었습니다.');
   		
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
			
			var chekrtn = confirm("등록하시겠습니까?"); 
			
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
	        		heneSwal.success('등록에 성공하였습니다.');
	        	   	parent.fn_MainInfo_List();
	                parent.$("#ReportNote").children().remove();
	                $('#modalReport').modal('hide'); 
	         	}
	        	 else{
	        		 heneSwal.error('등록에 실패하였습니다. 다시 시도해주세요.'); 
	        	 }
	         }
	     });		
	}
	
    
    $(document).ready(function () {

    	new SetSingleDate2("", "#txt_StartDate", 0);
    	
        var today = new Date();
        var fromday = new Date();
        fromday.setDate(today.getDate());
        
		ItemTypeGubun_Select();
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
    
    function ItemTypeGubun_Select() {
    	var item_type_gubun = $("#select_ItemTypeGubun").val().trim();
    	
    	if(item_type_gubun=="checkbox") $("#txt_ItemCode").val("CHK-");
    	else if(item_type_gubun=="text") $("#txt_ItemCode").val("TXT-");
    	else if(item_type_gubun=="radio") $("#txt_ItemCode").val("RDO-");
    }
</script>

   <table class="table table-hover" style="width: 100%; margin: 0 auto; align:left">
        <tr style="height: 40px">
            <td style="font-weight:900;">체크항목유형</td>
            <td></td>
            <td >
				<select class="form-control" id="select_ItemTypeGubun" style="width: 200px" onchange="ItemTypeGubun_Select()" >
	            	<%	optCode =  (Vector)itemTypeVector.get(2);%>
	                <%	optName =  (Vector)itemTypeVector.get(1);%>
	                <%for(int i=1; i<optName.size();i++){ %>
						<option value='<%=optCode.get(i).toString()%>' 
							<%=GV_ITEM_TYPE.equals(optCode.get(i).toString()) ? "selected" : "" %> >
							<%=optName.get(i).toString()%></option>
					<%} %>
				</select>
            </td>
        </tr>
        
        <tr style="background-color: #fff; height: 40px">
            <td style="font-weight:900;">체크항목코드</td>
            <td> </td>
            <td ><input type="text" class="form-control" id="txt_ItemCode" style="width: 200px; float:left"  />
				<!-- <input type="hidden" class="form-control" id="txt_custcode" style="width: 120px" /> -->
				<p style="font-size: 12px; clear:both;">코드안의 영문을 지우면 심각한 시스템오류가 발생합니다.</p>
           	</td>
        </tr>

        <tr style="background-color: #fff; height: 40px">
            <td style="font-weight:900;">체크항목명</td>
            <td> </td>
            <td ><input type="text" class="form-control" id="txt_ItemName" style="width: 200px; float:left"  />
				<!-- <input type="hidden" class="form-control" id="txt_custcode" style="width: 120px" /> -->
           	</td>
        </tr>

        <tr style="background-color: #fff" >
            <td style=" font-weight: 900; font-size:14px; text-align:left" colspan="3">비고</td>
        </tr>
        <tr>
            <td colspan="3"><textarea class="form-control" id="txt_Bigo"  style="cols:40;rows:4;resize: none;" ></textarea></td>
        </tr>

        <tr style="background-color: #fff; height: 40px">
            <td style="font-weight:900;">일련번호</td>
            <td> </td>
            <td ><input type="text" class="form-control" id="txt_ItemSeq" value="자동채번" style="width: 200px; float:left" readonly />
           	</td>
        </tr>
        
        <tr style="background-color: #fff; height: 40px">
            <td style="font-weight:900;">개정번호</td>
            <td> </td>
            <td ><input type="text" class="form-control" id="txt_RevisionNo" value="0" style="width: 200px; float:left" readonly />
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
    </table>
