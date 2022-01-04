<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page language="java"
	import="java.sql.*,java.util.*,javax.servlet.http.*"%>
<%@ page import="mes.client.comm.*"%>
<%@ page import="mes.client.common.*"%>
<%@ page import="mes.client.guiComponents.*"%>
<%@ page import="mes.client.util.*"%>
<%@ page import="mes.client.conf.*"%>
<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1">
<%
	String loginID = session.getAttribute("login_id").toString();
	String member_key = session.getAttribute("member_key").toString();

	DoyosaeTableModel TableModel;
	String zhtml = "";
	Vector optCode = null;
	Vector optName = null;

	String[] strColumnHead = {"", "", "", "", "", ""};

	String GV_BOM_CODE = "", GV_REVISION_NO = "", GV_BOM_NAME = "", GV_BOM_BIGO = ""  ;

	if (request.getParameter("BomCode") == null)
		GV_BOM_CODE = "";
	else
		GV_BOM_CODE = request.getParameter("BomCode");

	if (request.getParameter("RevisionNo") == null)
		GV_REVISION_NO = "";
	else
		GV_REVISION_NO = request.getParameter("RevisionNo");

	if (request.getParameter("BomName") == null)
		GV_BOM_NAME = "";
	else
		GV_BOM_NAME = request.getParameter("BomName");

	if (request.getParameter("BomBigo") == null)
		GV_BOM_BIGO = "";
	else
		GV_BOM_BIGO = request.getParameter("BomBigo");
%>

<%-- <jsp:include page="../../Common/linkcss_js.jsp" flush="false" /> --%>

<script type="text/javascript">
	
	function SaveOderInfo() {
		var fileValue = $("#idFilename").val().split("\\");
		var fileName = fileValue[fileValue.length-1]; 		// 파일명
		var vBom_cd_rev = $("#txt_RevisionNo").val(); 		// bom개정번호
		var vBom_nm = $("#txt_BomName").val(); 				// bom_nm(제품명)
		var form = $('#upload_form')[0];
        var data = new FormData(form);

        if ($('#idFilename').val().length < 1) {
    		alert("등록할 파일을 선택하세요-!!");
    		return;
    	} else {
    		var chekrtn = confirm("등록하시겠습니까?"); 
    		
    		if(chekrtn){
	    	    $.ajax({
					type: "POST",
	    	        enctype: "multipart/form-data",
	    	        url: "<%=Config.this_SERVER_path%>/hcp_Excel2BomServlet"
	    	        	+"?pid=M909S010100E201" 
	    	        	+ "&Filename=" + fileName 
	    	        	+ "&bom_cd_rev=" + vBom_cd_rev
	    	        	+ "&bom_nm=" + vBom_nm 
	    	        	+ "&member_key=" + "<%=member_key%>" ,
					data : data,
					processData : false,
					contentType : false,
					cache : false,
					timeout : 600000,
					beforeSend : function() {
						$('#alertNote').html(" <BR><BR> 저장 중 <BR>잠시만 기다려주세요");
						$('#modalalert').show();
					},
					success : function(data) {
						$("#btn_Save").prop("disabled", false);
						if (data.length > 0) {}
						
						alert("등록 되었습니다.");
						
						parent.fn_DetailInfo_List();
	             		parent.$("#ReportNote").children().remove();
	             		parent.$('#modalReport').hide();
	             		parent.$('#modalalert').hide();
					},
					error : function(e) {
						$("#result").text(e.responseText);
						console.log("ERROR : ", e);
						$("#btnSubmit").prop("disabled", false);
					}
				});
    		}
		}
	}

	function fn_CommonPopupModal(sUrl, name, w, h) { // url, name, width, height, 기타 속성(생략해도 무방)     	
		var popupWin = window
				.showModalDialog(
						sUrl,
						name,
						'dialogWidth:'
								+ w
								+ 'px; dialogHeight:'
								+ h
								+ 'px; center:yes; help:no; status:no; resizable:no; scroll:yes; toolbar :no;');
		if (typeof (popupWin) == "undefine")
			popupWin = window.returnValue;
		return popupWin;
	}
</script>
</head>
<body>
	<table class="table table-hover"
		style="width: 100%; margin: 0 auto; align: left">
		<tr style="background-color: #fff; height: 40px">
			<td style="font-weight:900;">BOM코드</td>
			<td></td>
			<td>
				<input type="text" class="form-control" id="txt_BomCode" 
					   style="width:200px; float:left" value="<%=GV_BOM_CODE%>" readonly />
			</td>
		</tr>

		<tr style="background-color: #fff; height: 40px">
			<td style="font-weight:900;">BOM코드 개정번호</td>
			<td></td>
			<td><input type="text" class="form-control" id="txt_RevisionNo"
				style="width: 200px; float: left" value="<%=GV_REVISION_NO%>"
				readonly /></td>
		</tr>

		<tr style="background-color: #fff; height: 40px">
			<td style="font-weight:900;">BOM명칭</td>
			<td></td>
			<td><input type="text" class="form-control" id="txt_BomName"
				style="width: 200px; float: left" value="<%=GV_BOM_NAME%>" readonly />
			</td>
		</tr>

		<tr style="background-color: #fff; height: 40px">
			<td style="font-weight:900;">BOM비고</td>
			<td></td>
			<td><input type="text" class="form-control" id="txt_BomBigo"
				style="width: 200px; float: left" value="<%=GV_BOM_BIGO%>" readonly />
			</td>
		</tr>

		<tr style="background-color: #fff; height: 40px">
			<td style="font-weight:900;">엑셀파일</td>

			<td style="font-weight: 900; font-size: 14px; text-align: left"
				colspan="2">
				<form id="upload_form" enctype="multipart/form-data"
					action="<%=Config.this_SERVER_path%>/hcp_Excel2BomServlet"
					method="post">
					<input type="file" id="idFilename" name="filename" multiple
						class="form-control"
						style="width: auto; border: solid 1px #cccccc;" />

				</form>
			</td>
		</tr>
		<input type="hidden" id="txt_pid" value="M909S010100E201" />

		<!-- <tr style="height: 60px">
			<td colspan="4" align="center">
				<p>
					<button id="btn_Save" class="btn btn-info" style="width: 100px"
						onclick="SaveOderInfo();">저장</button>
					<button id="btn_Canc" class="btn btn-info" style="width: 100px"
						onclick="parent.$('#modalReport').hide();">취소</button>
				</p>
			</td>
		</tr> -->
	</table>
</body>
</html>