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

    Vector optCode =  null;
    Vector optName =  null;
    
	String[] strColumnHead = {"공통코드그룹", "공통코드", "공통코드명", "개정번호", "비고"} ;
	
	String GV_PROD_CD = "", GV_REVISION_NO = "";
	String GV_TODAY = Common.getSystemTime("date");

	if(request.getParameter("ProdCd") == null)
		GV_PROD_CD = "";
	else
		GV_PROD_CD = request.getParameter("ProdCd");
	
	if(request.getParameter("RevisionNo") == null)
		GV_REVISION_NO = "";
	else
		GV_REVISION_NO = request.getParameter("RevisionNo");

	String param = GV_PROD_CD + "|" + GV_REVISION_NO + "|";
	
	JSONObject jArray = new JSONObject();
	jArray.put( "member_key", member_key);
	jArray.put( "PROD_CD", GV_PROD_CD);
	jArray.put( "REVISION_NO", GV_REVISION_NO);
	
	DoyosaeTableModel TableModel = new DoyosaeTableModel("M909S060100E205", strColumnHead, jArray);
		
    // 데이터를 가져온다.
    Vector Product_Delete_Target_Vector = (Vector)(TableModel.getVector().get(0));

    // 개정번호를 만든다.
    String revisionNumberStr = "";
    int revisionNoInt = 0;
    
    try {
		revisionNoInt = Integer.parseInt( Product_Delete_Target_Vector.get(1).toString().trim() );
    } catch (Exception e) {
    	revisionNoInt = 0;
    }
    
    revisionNoInt = revisionNoInt + 1;
    revisionNumberStr = "" + revisionNoInt;
%>
 
<script type="text/javascript">
	// 웹소켓 통신을 위해서 필요한 변수들 ---시작
	var M909S060100E103 = {
			PID: "M909S060100E103",  
			totalcnt: 0,
			retnValue: 999,
			colcnt: 0,
			colname: ["","","",""], //insert, Update, Delete 문장을 처리할 때는 사용되지않음
			data: []
	};  
	
	var SQL_Param = {
			PID: "M909S060100E103",
			excute: "queryProcess",
			stream: "N",
			param: + "|"
	};
	var GV_RECV_DATA = "";	//웹소켓 onMessage(event)들어온 데이터를 받는 변수
	// 웹소켓 통신을 위해서 필요한 변수들 ---끝	

    var groupCodeGubun = "";
	
	function SetRecvData(){
		if (confirm("정말 삭제하시겠습니까?") != true) {
			return;
		}
		DataPars(M909S060100E103, GV_RECV_DATA);
 		if(M909S060100E103.retnValue > 0) {
 			heneSwal.success('삭제 되었습니다');
 		}
   		
   		parent.fn_MainInfo_List();
   		$('#modalReport').modal('hide');
	}
	
	function SaveOderInfo() {
		
		var delete_check = confirm("해당 제품 정보를 삭제하시겠습니까?");
		
		if(delete_check) {
			var dataJson = new Object();
			dataJson.start_date_for_delete_data = $('#txt_StartDate').val();	// 삭제할 데이터의 적용시작일자 ( 오늘(삭제하는 날) 날짜와 다를 수 있음 )
			dataJson.start_date = "<%=GV_TODAY%>";	// 오늘(삭제하는 날) 날짜 = 제일 최신이 될 데이터의 적용시작일자가 됨 
			dataJson.prod_cd = $('#txt_ProdCd').val();
			dataJson.revision_no = $('#txt_RevisionNo').val();
			dataJson.member_key = "<%=member_key%>";
			
	       	SendTojsp(JSON.stringify(dataJson), "M909S060100E103");
		}
	}
 
	function SendTojsp(bomdata, pid){
		
	    $.ajax({
	    	type: "POST",
	        dataType: "json",
	        url: "<%=Config.this_SERVER_path%>/Contents/CommonView/insert_update_delete_json.jsp", 
	        data: "bomdata=" + bomdata + "&pid=" + pid,
	        success: function (html) {
	        	if(html > -1) {
	        		heneSwal.success('제품정보 삭제에 성공하였습니다.');
	        		$('#modalReport').modal('hide');
	        		parent.fn_MainInfo_List();
	         	}
	        	
	        	else {
	        		heneSwal.error('제품정보 삭제에 실패하였습니다.');
	        	}
	    	}
		});		
	}
    
    $(document).ready(function () {
		new SetSingleDate2("", "#txt_StartDate", 0);
    });


    function fn_CommonPopupModal(sUrl, name, w, h) { // url, name, width, height, 기타 속성(생략해도 무방)     	
        var popupWin = window.showModalDialog(sUrl, name, 'dialogWidth:' + w + 'px; dialogHeight:' + h 
                + 'px; center:yes; help:no; status:no; resizable:no; scroll:yes; toolbar :no;');
    	if(typeof(popupWin)=="undefine")
    		popupWin = window.returnValue;
		return popupWin;
    }  
</script>
   
<table class="table table-hover">
    <tr>
        <td>
        	제품코드
        </td>
        <td>
        </td>
        <td>
        	<input type="text" class="form-control" id="txt_ProdCd"
        		   value="<%=Product_Delete_Target_Vector.get(0).toString()%>" readonly />
       	</td>
    </tr>

    <tr>
        <td>
        	제품명
        </td>
        <td>
        </td>
        <td>
        	<input type="text" class="form-control" id="txt_ProductName"
        		   value="<%=Product_Delete_Target_Vector.get(1).toString()%>" readonly/>
        </td>
	</tr>

    <tr>
        <td>
        	규격
        </td>
        <td>
        </td>
        <td>
        	<input type="text" class="form-control" id="txt_GyuGyeok"
        		  value="<%=Product_Delete_Target_Vector.get(3).toString()%>" readonly/>
       	</td>
    </tr>
    
    <tr>
        <td>
        	개정번호
        </td>
        <td>
        </td>
        <td>
        	<input type="text" class="form-control" id="txt_RevisionNo" readonly 
        		value="<%=Product_Delete_Target_Vector.get(4).toString()%>" readonly/>
       	</td>
    </tr>
    
    <tr>
        <td>
        	적용시작일자
        </td>
        <td>
        </td>
        <td>
        	<input type="text" data-date-format="yyyy-mm-dd" id="txt_StartDate" class="form-control"
            	   value="<%=Product_Delete_Target_Vector.get(5).toString()%>" disabled/>
       	</td>
    </tr>
</table>