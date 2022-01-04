<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*,java.util.*,javax.servlet.http.*"%>
<%@ page import="mes.client.comm.*" %>
<%@ page import="mes.client.common.*" %>
<%@ page import="mes.client.guiComponents.*" %>
<%@ page import="mes.client.util.*" %>
<%@ page import="mes.client.conf.*" %>
<!DOCTYPE html>

<%
	/* 
	배포 과리 완료(S404S010122.jsp
	*/
	
	String loginID = session.getAttribute("login_id").toString();
	String member_key = session.getAttribute("member_key").toString();
	
	DoyosaeTableModel TableModel;
	//백터로 데이터를 가져올때에는 컬럼 해드를 줄필요가 없다. 지워도 됨 ㅇㅇ
	String[] strColumnHead = {"", "", "", ""};
	
	String GV_JSPPAGE = "M606S040122.jsp" ;
	String GV_DISTRIBUTE_NO = "", GV_GUBUN_CODE = "", GV_DOCUMENT_NO = "", GV_REGIST_NO = "" , GV_REGIST_NO_REV = "";
	
	if (request.getParameter("jspPage") == null)
		GV_JSPPAGE = "";
	else
		GV_JSPPAGE = request.getParameter("jspPage");
	
	if (request.getParameter("Distribute_no") == null)
		GV_DISTRIBUTE_NO = "";
	else
		GV_DISTRIBUTE_NO = request.getParameter("Distribute_no");
	
	if (request.getParameter("Gubun_code") == null)
		GV_GUBUN_CODE = "";
	else
		GV_GUBUN_CODE = request.getParameter("Gubun_code");
	
	if (request.getParameter("Document_no") == null)
		GV_DOCUMENT_NO = "";
	else
		GV_DOCUMENT_NO = request.getParameter("Document_no");
	
	if (request.getParameter("Regist_no") == null)
		GV_REGIST_NO = "";
	else
		GV_REGIST_NO = request.getParameter("Regist_no");
	
	if (request.getParameter("Regist_no_rev") == null)
		GV_REGIST_NO_REV = "";
	else
		GV_REGIST_NO_REV = request.getParameter("Regist_no_rev");
	
	String param = GV_DISTRIBUTE_NO + "|" + GV_GUBUN_CODE + "|" + GV_DOCUMENT_NO + "|" 
				+ GV_REGIST_NO + "|" + GV_REGIST_NO_REV + "|" + member_key + "|" ;
	TableModel = new DoyosaeTableModel("M606S040100E106", strColumnHead, param);
	int ColCount = TableModel.getColumnCount();
	CurrentPage jspPageName = new CurrentPage(request.getRequestURI());
	String JSPpage = jspPageName.GetJSP_FileName();
	
	// 데이터를 가져온다.
	Vector targetDocumentVector = (Vector) (TableModel.getVector().get(0));
	%>

    <script type="text/javascript">
    $(document).ready(function () {
    	
    });	
    
	var SQL_Param = {
			excute: "queryProcess",
			stream: "N",
			param: ""
	};
    
	
	function SaveOderInfo() {
		var chekrtn = confirm("완료하시겠습니까?");

		if(chekrtn){
			var parmHead = '<%=GV_JSPPAGE%>'    	+ "|"
	   				  + '<%=loginID%>'		    	+ "|"	//주문상세번호
	   				  + 					    	+ "|"
	   				  +								+ "|"	//주문상세번호
	   				  + '0'                         + "|"	//indGB 	; 0:처리 , 1:반려 
	        			;

		SendTojsp(urlencode(parmHead), "M404S010100E122");
	    }
	}
    
	function SendTojsp(bomdata, pid){
		
	    $.ajax({
	         type: "POST",
	         url: "<%=Config.this_SERVER_path%>/Contents/CommonView/insert_update_delete.jsp", 
	         data:  "bomdata=" + bomdata + "&pid=" + pid,
	         beforeSend: function () {
//	         	 alert(bomdata);
	         },
	         
	         success: function (html) {	
	        	 if(html>-1){
	        		parent.fn_DetailInfo_List();
	                parent.$("#ReportNote").children().remove();
	         		parent.$('#modalReport').hide();
	         	}
	         },
	         error: function (xhr, option, error) {
	        	 
	         }
	     });		
	} 
       
    
    </script>

	<table class="table " style="width: 100%; margin: 0 auto; align: left">
	<tbody id="Doc_tbody">
		<tr>
			<td
				style="font-weight: 900; font-size: 14px; text-align: left; vertical-align: middle">문서 번호</td>
			<td
				style="font-weight: 900; font-size: 14px; text-align: left; vertical-align: middle">
				<input type="text" class="form-control" id="txt_Reg_reason"
				name="reg_reason" style="width: 250px; float: left"
				value="<%=targetDocumentVector.get(2).toString()%>" readonly /></input>
			</td>
		</tr>
		
		<tr>
			<td
				style="font-weight: 900; font-size: 14px; text-align: left; vertical-align: middle">문서명</td>
			<td
				style="font-weight: 900; font-size: 14px; text-align: left; vertical-align: middle">
				<input type="text" class="form-control" id="txt_Reg_reason"
				name="reg_reason" style="width: 250px; float: left"
				value="<%=targetDocumentVector.get(3).toString()%>" readonly /></input>
			</td>
		</tr>


		<tr>
			<td
				style="font-weight: 900; font-size: 14px; text-align: left; vertical-align: middle">파일명</td>
			<td
				style="font-weight: 900; font-size: 14px; text-align: left; vertical-align: middle">
				<input type="text" class="form-control" id="txt_external_doc_source"
				name="external_doc_source" style="width: 250px; float: left"
				value="<%=targetDocumentVector.get(4).toString()%>" readonly></input>
			</td>
		</tr>
		
		<tr>
			<td
				style="font-weight: 900; font-size: 14px; text-align: left; vertical-align: middle">배포유효기간</td>
			<td
				style="font-weight: 900; font-size: 14px; text-align: left; vertical-align: middle">
                <input type="text"  class="form-control" id = "txt_due_date"
                name="dist_target"  style="width: 250px; float: left"
                value="<%=targetDocumentVector.get(8).toString()%>" readonly>
           	 	</input>
			</td>
		</tr>
		
		<tr>
			<td
				style="font-weight: 900; font-size: 14px; text-align: left; vertical-align: middle">배포 대상</td>
			<td
				style="font-weight: 900; font-size: 14px; text-align: left; vertical-align: middle">
				<input type="text" class="form-control" id="txt_dist_target"
				name="dist_target" style="width: 250px; float: left"
				value="<%=targetDocumentVector.get(9).toString()%>" readonly></input>
			</td>
		</tr>


		

		<tr style="height: 60px">
			<td colspan="2" align="center">
				<p>
					<button id="btn_Save" class="btn btn-info" style="width: 100px"
						onclick="DeletedistInfo();">삭제</button>
					<button id="btn_Canc" class="btn btn-info" style="width: 100px"
						onclick="parent.$('#modalReport').hide();return false;">취소</button>
				</p>
			</td>
		</tr>
	</tbody>
</table>
	