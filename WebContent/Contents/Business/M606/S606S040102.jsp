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

<%
/* 
문서배포수정(S606S040102).jsp
*/
	String loginID = session.getAttribute("login_id").toString();
	String member_key = session.getAttribute("member_key").toString();
	
	String GV_JSPPAGE = "M606S040102.jsp", jspPagePID = "M606S040100E102";
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
	
	DoyosaeTableModel TableModel;
	//백터로 데이터를 가져올때에는 컬럼 해드를 줄필요가 없다. 없어도 된다
	String[] strColumnHead = {"", "", "", ""};
	
	String param = GV_DISTRIBUTE_NO + "|" + GV_GUBUN_CODE + "|" + GV_DOCUMENT_NO + "|" 
				+ GV_REGIST_NO + "|" + GV_REGIST_NO_REV + "|" + member_key + "|"; 
	TableModel = new DoyosaeTableModel("M606S040100E106", strColumnHead, param);
	
	// 데이터를 가져온다.
	Vector targetDocumentVector = (Vector) (TableModel.getVector().get(0));
	
	Vector optCode =  null;
    Vector optName =  null;
    
	Vector DeptCode = (Vector) CommonData.getDeptCodeAll(member_key);
%>

<script type="text/javascript">
//     웹소켓 통신을 위해서 필요한 변수들 ---시작

//aaa
	var M606S040100E102 = {
			PID:  "M606S040100E102",
			totalcnt: 0,
			retnValue: 999,
			colcnt: 0,
			colname: ["","","",""], //insert, Update, Delete 문장을 처리할 때는 사용되지않음
			data: []
	};  
	var SQL_Param = {
			excute: "queryProcess",
			stream: "N",
			param: ""
	};
	
    $(document).ready(function () {
    	    	
    	$("#txt_due_date").datepicker({
        	format: 'yyyy-mm-dd',
        	autoclose: true,
        	language: 'ko'
        });   	
    	<%-- $('#txt_due_date').datepicker('update', "<%=targetDocumentVector.get(8).toString()%>") --%>;
    	

    <%--
        $("#txt_order_no").val("<%=GV_ORDERNO%>");
        $("#txt_order_detail_seq").val("<%=GV_ORDER_DETAIL_SEQ%>");
        $("#txt_project_name").val("<%=GV_PROJECT_NAME%>");
        $("#txt_cust_nm").val("<%=GV_CUST_NM%>");
        $("#txt_product_nm").val("<%=GV_PRODUCT_NM%>");
        --%>
    });	
    
    function UpdatedistInfo() {
        
		    	if($("#txt_due_date").val() == ""){
		    		alert("배포유효기간을 선택하여 주세요.");
		    		return;
		    	}
    	
				var work_complete_update_check = confirm("수정하시겠습니까?");
				if(work_complete_update_check == false)	return;
		
    	
    	
    			var parmBody= "" ;
    			
    		    parmBody +=  '<%=GV_GUBUN_CODE%>'		 					+	"|" //구분코드
    		    			+ '<%=GV_DISTRIBUTE_NO%>'	 					+	"|"	//배포번호
    		    			+ '<%=GV_DOCUMENT_NO%>'	 	 					+ 	"|" //문서번호
    		    			+ '<%=GV_REGIST_NO%>'	 	 					+	"|" //등록번호
    		    			+ '<%=GV_REGIST_NO_REV%>'	 					+	"|" //개정번호
    		    			+ $("#txt_due_date").val()	 					+	"|"	//유효기간
    		    			+ $("#txt_dist_target").val()	 				+	"|"	//배포 대상
    		    			+ $("#select_DeptCode option:selected").val() 	+	"|" //배포부서
    		    			+ '<%=member_key%>'	 							+	"|" 
    						;
    		    			
    			SendTojsp(urlencode(parmBody), M606S040100E102.PID);
    		}
    	    
    		function SendTojsp(bomdata, pid){
    			//alert(bomdata);
    		    $.ajax({
    		         type: "POST",
    		         url: "<%=Config.this_SERVER_path%>/Contents/CommonView/insert_update_delete.jsp",
    						data : "bomdata=" + bomdata + "&pid=" + pid,
    						beforeSend : function() {
    							//alert(bomdata);
    						},
    						success : function(html) {
    							if (html > -1) {
    								alert("수정 되었습니다.");

    								parent.fn_MainInfo_List();
    		                 		parent.$("#ReportNote").children().remove();
    		                 		$('#modalReport').modal('hide');
    							}
    						},
    						error : function(xhr, option, error) {
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
                <input type="text" data-date-format="yyyy-mm-dd" id="txt_due_date" class="form-control" style="width: 250px; border: solid 1px #cccccc;" readonly="readonly">
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
				value="<%=targetDocumentVector.get(9).toString()%>"></input>
			</td>
		</tr>
		
		<tr>
			<td
				style="font-weight: 900; font-size: 14px; text-align: left; vertical-align: middle">배포 부서</td>
				
				<td
				style="font-weight: 900; font-size: 14px; text-align: left; vertical-align: middle">
				<select class="form-control" id="select_DeptCode"
				name="DeptCode" style="width: 250px">
					<%
						optCode = (Vector) DeptCode.get(0);
						optName = (Vector) DeptCode.get(1);

						for (int i = 0; i < optName.size(); i++) {
							if (optCode.get(i).equals(targetDocumentVector.get(10).toString())) {
					%>
					<option value='<%=optCode.get(i).toString()%>' selected><%=optName.get(i).toString()%>
					</option>
					<%
						} else {
					%>
					<option value='<%=optCode.get(i).toString()%>'><%=optName.get(i).toString()%></option>
					<%
						}
						}
					%>
			</select>
			</td>
		</tr>
			
				<!-- 
			<td
				style="font-weight: 900; font-size: 14px; text-align: left; vertical-align: middle">
				<input type="text" class="form-control" id="txt_dist_target"
				name="dist_target" style="width: 250px; float: left"
				value="<%=targetDocumentVector.get(9).toString()%>"></input>
			</td>
			 -->
		</tr>

		<tr style="height: 60px">
			<td colspan="2" align="center">
				<p>
					<button id="btn_Save" class="btn btn-info" style="width: 100px"
						onclick="UpdatedistInfo();">수정</button>
					<button id="btn_Canc" class="btn btn-info" style="width: 100px"
						onclick="$('#modalReport').modal('hide');return false;">취소</button>
				</p>
			</td>
		</tr>
	</tbody>
</table>
	