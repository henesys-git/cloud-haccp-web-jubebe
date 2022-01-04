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
    Vector codeGroupVector = CommonData.getCodeGroupDataAll(member_key);
    
	String[] strColumnHead = {"공통코드그룹", "공통코드", "공통코드명", "개정번호", "비고"} ;
	
	String GV_CODE_VALUE="", GV_REVISION_NO="", GV_BIGO="";

	String GV_TODAY = Common.getSystemTime("date");

	if(request.getParameter("CodeValue")== null)
		GV_CODE_VALUE="";
	else
		GV_CODE_VALUE = request.getParameter("CodeValue");
	
	if(request.getParameter("RevisionNo")== null)
		GV_REVISION_NO="";
	else
		GV_REVISION_NO = request.getParameter("RevisionNo");

	String param = GV_CODE_VALUE + "|" + GV_REVISION_NO + "|";
	
	JSONObject jArray = new JSONObject();
	jArray.put( "member_key", member_key);
	jArray.put( "CODE_VALUE", GV_CODE_VALUE);
	jArray.put( "REVISION_NO", GV_REVISION_NO);
	jArray.put( "bigo", GV_BIGO);
	
	DoyosaeTableModel TableModel = new DoyosaeTableModel("M909S140100E204", strColumnHead, jArray);

    // 데이터를 가져온다.
    Vector targetCustVector = (Vector) (TableModel.getVector().get(0));

    // 개정번호를 만든다.
    String revisionNumberStr = "";
    int revisionNoInt = 0;
    
    try {
		revisionNoInt = Integer.parseInt( targetCustVector.get(3).toString().trim() );
    } catch (Exception e) {
    	revisionNoInt = 0;
    }
    
    revisionNoInt = revisionNoInt + 1;
    revisionNumberStr = "" + revisionNoInt;
%>
 
<script type="text/javascript">
    var groupCodeGubun = "";
	
	function SaveOderInfo() {
		
		var contents_str = document.getElementById("txt_Bigo").value;
		contents_str = contents_str.replace(/(?:\r\n|\r|\n)/g, '<br/>');
		
		var WebSockData="";
		
		if ($('#txt_CodeValue').val().length < 1) {
			heneSwal.warning("공통코드를 입력하세요");
			return;
		}

		var jArray = new Array();
		var dataJson = new Object();
		dataJson.member_key = "<%=member_key%>";
 		dataJson.code_cd = $('#txt_CodeGroupGubun').val();
 		dataJson.code_value = $('#txt_CodeValue').val();
 		dataJson.code_name = $('#txt_CodeName').val();
 		dataJson.revision_no = $('#txt_RevisionNo').val();
 		dataJson.bigo = contents_str;
 		dataJson.start_date = $('#txt_StartDate').val();
 		dataJson.duration_date = "9999-12-31";
 		dataJson.create_user_id = "<%=loginID%>";
 		dataJson.order_index = "SYSDATETIME";
 		dataJson.modify_user_id = "<%=loginID%>";
 		dataJson.modify_reason = "수정";
 		dataJson.modify_date = "SYSDATETIME";
 		
 		jArray.push(dataJson);
 		
 		var dataJsonMulti = new Object();
 		dataJsonMulti.param = jArray;

 		var chekrtn = confirm("수정하시겠습니까?"); 
		
		if(chekrtn){
 			SendTojsp(JSON.stringify(dataJsonMulti), "M909S140100E102");
		}
	}
 
	function SendTojsp(bomdata, pid){
	    $.ajax({
			type: "POST",
			dataType: "json",
			url: "<%=Config.this_SERVER_path%>/Contents/CommonView/insert_update_delete_json.jsp", 
			data:  {"bomdata" : bomdata , "pid" : pid},
			success: function (html) {
				if(html > -1) {
	                $('#modalReport').modal('hide');
	         		parent.fn_DetailInfo_List();
	         		heneSwal.success("공통코드 정보 수정이 완료되었습니다");
	         	} else {
	         		heneSwal.error("공통코드 정보 수정에 실패했습니다, 다시 시도해주세요");
	         	}
	         }
		});		
	}
    
    $(document).ready(function () {
		new SetSingleDate2("", "#txt_StartDate", 0);

        var today = new Date();
        var fromday = new Date("<%=targetCustVector.get(5).toString()%>");
        
	    $("#select_CodeGroupGubun").on("change", function(){
	    	groupCodeGubun = $(this).val();
	    });
	    
	    textarea_encoding();		   
    });
    
    function textarea_encoding() {
	       var str = '<%=TableModel.getValueAt(0,4).toString().trim()%>';
	       var result = str.replace(/(<br>|<br\/>|<br\/>)/g, '\r\n');
	        $('#txt_Bigo').val(result);
	}

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

   <table class="table table-hover">

        <tr>
            <td>코드구분</td>
            <td></td>
            <td>
            	<input type="text" class="form-control" id="txt_CodeGroupGubun"	
            		   value="<%=targetCustVector.get(0).toString()%>" readonly>
           	</td>
        </tr>
        
        <tr>
            <td>공통코드</td>
            <td></td>
            <td>
            	<input type="text" class="form-control" id="txt_CodeValue"
            		   value="<%=targetCustVector.get(1).toString() %>" readonly>
           	</td>
        </tr>

        <tr>
            <td>공통코드명</td>
            <td></td>
            <td>
            	<input type="text" class="form-control" id="txt_CodeName"
            		   value="<%=targetCustVector.get(2).toString()%>">
           	</td>
        </tr>
        
        <tr>
            <td>개정번호</td>
            <td></td>
            <td>
            	<input type="text" class="form-control" id="txt_RevisionNo"
            		   value="<%=revisionNumberStr%>" readonly>
           	</td>
        </tr>
        
        <tr>
            <td>적용시작일자</td>
            <td></td>
            <td>
            	<input type="date" data-date-format="yyyy-mm-dd" id="txt_StartDate" class="form-control">
           	</td>
        </tr>
        
        <tr>
            <td>비고</td>
            <td></td>
            <td>
				<input class="form-control" id="txt_Bigo">
			</td>
        </tr>
    </table>