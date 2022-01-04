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

    Vector optCode = null;
    Vector optName = null;
    Vector codeGroupVector = CommonData.getCodeGroupDataAll(member_key);
    
	String[] strColumnHead = {"공통코드그룹", "공통코드", "공통코드명", "개정번호", "비고"} ;
	
	String GV_CODE_GROUP = "";

	if(request.getParameter("CodeGroupGubun") != null)
		GV_CODE_GROUP = request.getParameter("CodeGroupGubun");
%>
 
<script type="text/javascript">

    var groupCodeGubun = "";
	
	function SetRecvData(){
		DataPars(M909S140100E101, GV_RECV_DATA);
 		if(M909S140100E101.retnValue > 0) {
 			heneSwal.success('등록 되었습니다');
 		}
   		
 		parent.$('#modalReport').hide();
	}
	
	function SaveOderInfo() {		
	
		if ($('#txt_CodeValue').val().length < 1) {
			alert("공통코드를 입력하세요.");
			return;
		}
		
		var WebSockData="";
 		
 		var dataJson = new Object();
 		dataJson.member_key = "<%=member_key%>";
 		dataJson.code_cd = $("#select_CodeGroupGubun option:selected").val();
 		dataJson.code_value = $('#txt_CodeValue').val();
 		dataJson.code_name = $('#txt_CodeName').val();
 		dataJson.revision_no = $('#txt_RevisionNo').val();
 		dataJson.bigo = $('#txt_Bigo').val();
 		dataJson.start_date = $('#txt_StartDate').val();
 		dataJson.duration_date = "9999-12-31";
 		dataJson.create_user_id = "<%=loginID%>";
 		dataJson.order_index = "SYSDATETIME";
 		dataJson.modify_user_id = "<%=loginID%>";
 		dataJson.modify_reason = "최초작성";
 		dataJson.modify_date = "SYSDATETIME";
		
 		var chekrtn = confirm("등록하시겠습니까?"); 
		
		if(chekrtn){
 			SendTojsp(JSON.stringify(dataJson), "M909S140100E101");
		}
	}
 
	function SendTojsp(bomdata, pid){
	    $.ajax({
	         type: "POST",
	         dataType: "json",
	         url: "<%=Config.this_SERVER_path%>/Contents/CommonView/insert_update_delete_json.jsp", 
	         data:  {"bomdata" : bomdata , "pid" : pid },
	         success: function (html) {
	        	 if(html>-1){
	        		heneSwal.success('공통코드 정보 등록에 성공하였습니다.');
	                parent.$("#ReportNote").children().remove();
	                $('#modalReport').modal('hide');
	         		parent.fn_DetailInfo_List();
	         	}
	        	 else{
	        		heneSwal.error('공통코드 정보 등록에 실패하였습니다.');
	        	 }
	         }
	     });		
	}
	
    $(document).ready(function () {
		new SetSingleDate2("", "#txt_StartDate", 0);
		
        var today = new Date();
        var fromday = new Date();
        fromday.setDate(today.getDate());
        
	    $("#select_CodeGroupGubun").on("change", function(){
	    	groupCodeGubun = $(this).val();
	    });
    });

    function fn_CommonPopupModal(sUrl, name, w, h) {	
        var popupWin = window.showModalDialog(sUrl, name, 'dialogWidth:' + w + 'px; dialogHeight:' + h 
                + 'px; center:yes; help:no; status:no; resizable:no; scroll:yes; toolbar :no;');
    	if(typeof(popupWin) == "undefine")
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
				<select class="form-control" id="select_CodeGroupGubun">
	            	<%	optCode = (Vector)codeGroupVector.get(0);%>
	                <%	optName = (Vector)codeGroupVector.get(1);%>
	                <%for(int i=1; i<optName.size(); i++){ %>
						<option value='<%=optCode.get(i).toString()%>' 
							<%=GV_CODE_GROUP.equals(optCode.get(i).toString()) ? "selected" : "" %> >
							<%=optName.get(i).toString()%></option>
					<%} %>
				</select>
            </td>
        </tr>
        
        <tr>
            <td>공통코드</td>
            <td></td>
            <td>
            	<input type="text" class="form-control" id="txt_CodeValue" title="공통코드 : 공통코드그룹  + 코드값 ">
           	</td>
        </tr>

        <tr>
            <td>공통코드명</td>
            <td></td>
            <td>
            	<input type="text" class="form-control" id="txt_CodeName">
           	</td>
        </tr>
        
        <tr>
            <td>개정번호</td>
            <td></td>
            <td>
            	<input type="text" class="form-control" id="txt_RevisionNo" value="0" readonly>
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