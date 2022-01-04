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
	String loginID = session.getAttribute("login_id").toString();
	String member_key = session.getAttribute("member_key").toString();
	String GV_REG_NO = "", GV_DOC_NO = "", GV_FILE_NAME = "" , GV_REG_GUBUN = "";
	String GV_DESTROY_NO = "", GV_REG_NO_REV = "", GV_DOC_NO_REV = "";
	
	if (request.getParameter("RegNo") == null)
		GV_REG_NO = "";
	else
		GV_REG_NO = request.getParameter("RegNo");

	if (request.getParameter("DocNo") == null)
		GV_DOC_NO = "";
	else
		GV_DOC_NO = request.getParameter("DocNo");

	if (request.getParameter("File_name") == null)
		GV_FILE_NAME = "";
	else
		GV_FILE_NAME = request.getParameter("File_name");

	if (request.getParameter("Destroy_no") == null)
		GV_DESTROY_NO = "";
	else
		GV_DESTROY_NO = request.getParameter("Destroy_no");
	
	if (request.getParameter("RegNo_rev") == null)
		GV_REG_NO_REV = "";
	else
		GV_REG_NO_REV = request.getParameter("RegNo_rev");
	
	if (request.getParameter("DocNo_rev") == null)
		GV_DOC_NO_REV = "";
	else
		GV_DOC_NO_REV = request.getParameter("DocNo_rev");
	
	if (request.getParameter("Reg_gubun") == null)
		GV_REG_GUBUN = "";
	else
		GV_REG_GUBUN = request.getParameter("Reg_gubun");
	

	DoyosaeTableModel TableModel;
	//백터로 데이터를 가져올때에는 컬럼 해드를 줄필요가 없다.
	String[] strColumnHead = {"", "", "", ""};
	
	String param = GV_DESTROY_NO + "|" + GV_REG_NO + "|" + GV_REG_NO_REV + "|" 
				+ GV_DOC_NO + "|" + GV_DOC_NO_REV + "|" + member_key + "|";
	TableModel = new DoyosaeTableModel("M606S060100E106", strColumnHead, param);
	int ColCount = TableModel.getColumnCount();
	
	// 데이터를 가져온다.
	Vector targetDocumentVector = (Vector) (TableModel.getVector().get(0));
%>

<script type="text/javascript">


    $(document).ready(function () {
    	
		$("#destroy_no").val('<%=targetDocumentVector.get(0).toString()%>');
    	$("#txt_regist_no_rev").val('<%=targetDocumentVector.get(2).toString()%>');
		$("#txt_document_no_rev").val('<%=targetDocumentVector.get(4).toString()%>');
		$("#txt_file_real_name").val('<%=targetDocumentVector.get(6).toString()%>');
		$("#txt_external_doc_yn").val('<%=targetDocumentVector.get(7).toString()%>');
		$("#txt_external_doc_souce").val('<%=targetDocumentVector.get(8).toString()%>');
		$("#txt_destroy_reason_code").val('<%=targetDocumentVector.get(9).toString()%>');
		$("#txt_total_page").val('<%=targetDocumentVector.get(10).toString()%>');
		$("#txt_gwanribon").val('<%=targetDocumentVector.get(11).toString()%>');
		$("#txt_keep_yn").val('<%=targetDocumentVector.get(12).toString()%>');
		$("#txt_hole_yn").val('<%=targetDocumentVector.get(13).toString()%>');
		$("#txt_delok_yn").val('<%=targetDocumentVector.get(14).toString()%>');
		$("#txt_regist_reason_code").val('<%=targetDocumentVector.get(15).toString()%>');
		$("#txt_destroy_yn").val('<%=targetDocumentVector.get(16).toString()%>');
		$("#txt_reg_gubun").val('<%=targetDocumentVector.get(17).toString()%>');
		
    });

	function RecuvereInfo() {
		
				var work_complete_update_check = confirm("복구하시겠습니까?");
				if(work_complete_update_check == false)	return;
		
    			var parmBody= "" ;
    			
    		    parmBody +=  $("#txt_regist_no").val()				+	"|"
							+ $("#txt_regist_no_rev").val()		 	+	"|"
							+ $("#txt_docment_no").val()	 		+	"|"
			    			+ $("#txt_document_no_rev").val()	 	+	"|"
			    			+ $("#txt_file_view_name").val()	 	+ 	"|"
			    			+ $("#txt_file_real_name").val()		+	"|"
			    			+ $("#txt_external_doc_yn").val()		+	"|"
			    			+ $("#txt_external_doc_souce").val()	+ 	"|"
			    			+ $("#txt_destroy_reason_code").val()	+	"|"
			    			+ $("#txt_total_page").val()		 	+	"|"
			    			+ $("#txt_gwanribon").val()				+	"|"
			    			+ $("#txt_keep_yn").val()				+	"|"
			    			+ $("#txt_hole_yn").val()				+	"|"
			    			+ $("#txt_delok_yn").val()				+	"|"
			    			+ $("#txt_regist_reason_code").val()	+	"|"
			    			+ $("#txt_destroy_yn").val()			+	"|"
			    			+ $("#txt_reg_gubun").val()				+	"|"
			    			+ $("#txt_distroy_no").val()			+	"|"
			    			+ '<%=member_key%>'						+	"|"
							;
    		    	    
    			SendTojsp(urlencode(parmBody), "M606S060100E102");
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
    							
    							alert("문서 복구 완료.");
    							
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
    
    <input type="hidden" class="form-control" id="txt_destroy_no" name="destroy_no"  readonly/>
    <input type="hidden" class="form-control" id="txt_reg_gubun" name="reg_gubun"  readonly/>
	<input type="hidden" class="form-control" id="txt_regist_no_rev" name="regist_no_rev"  readonly/>
    <input type="hidden" class="form-control" id="txt_document_no_rev" name="document_no_rev"  readonly/>
    <input type="hidden" class="form-control" id="txt_file_real_name" name="file_real_name"  readonly/>
    <input type="hidden" class="form-control" id="txt_external_doc_yn" name="external_doc_yn"  readonly/>
    <input type="hidden" class="form-control" id="txt_external_doc_souce" name="external_doc_souce"  readonly/>
    <input type="hidden" class="form-control" id="txt_destroy_reason_code" name="destroy_reason_code"  readonly/>
    <input type="hidden" class="form-control" id="txt_total_page" name="total_page"  readonly/>
    <input type="hidden" class="form-control" id="txt_gwanribon" name="gwanribon"  readonly/>
    <input type="hidden" class="form-control" id="txt_keep_yn" name="keep_yn"  readonly/>
    <input type="hidden" class="form-control" id="txt_hole_yn" name="hole_yn"  readonly/>
    <input type="hidden" class="form-control" id="txt_delok_yn" name="dekok_yn"  readonly/>
    <input type="hidden" class="form-control" id="txt_regist_reason_code" name="regist_reason_code"  readonly/>
    <input type="hidden" class="form-control" id="txt_destroy_yn" name="destroy_yn"  readonly/>

<table class="table " style="width: 100%; margin: 0 auto; align: left">
	<tbody id="Doc_tbody">
		<tr>
			<td
				style="font-weight: 900; font-size: 14px; text-align: left; vertical-align: middle">등록번호</td>
			<td
				style="font-weight: 900; font-size: 14px; text-align: left; vertical-align: middle">
				<input type="text" class="form-control" id="txt_regist_no"
				name="regist_no" style="width: 250px; float: left"
				value="<%=targetDocumentVector.get(1).toString()%>" readonly /></input>
			</td>
		</tr>

		<tr>
			<td
				style="font-weight: 900; font-size: 14px; text-align: left; vertical-align: middle">문서번호</td>
			<td
				style="font-weight: 900; font-size: 14px; text-align: left; vertical-align: middle">
				<input type="text" class="form-control" id="txt_docment_no"
				name="docment_no" style="width: 250px; float: left"
				value="<%=targetDocumentVector.get(3).toString()%>" readonly /></input>
			</td>
		</tr>


		<tr>
			<td
				style="font-weight: 900; font-size: 14px; text-align: left; vertical-align: middle">파일명</td>
			<td
				style="font-weight: 900; font-size: 14px; text-align: left; vertical-align: middle">
				<input type="text" class="form-control" id="txt_file_view_name"
				name="file_view_name" style="width: 250px; float: left"
				value="<%=targetDocumentVector.get(5).toString()%>" readonly></input>
			</td>
		</tr>
		<tr>
			<td
				style="font-weight: 900; font-size: 14px; text-align: left; vertical-align: middle">폐기번호</td>
			<td
				style="font-weight: 900; font-size: 14px; text-align: left; vertical-align: middle">
				<input type="text" class="form-control" id="txt_distroy_no"
				name="distroy_no" style="width: 250px; float: left"
				value="<%=targetDocumentVector.get(0).toString()%>" readonly></input>
			</td>
		</tr>

		<tr style="height: 60px">
			<td colspan="2" align="center">
				<p>
					<button id="btn_Save" class="btn btn-info" style="width: 100px"
						onclick="RecuvereInfo();">복구</button>
					<button id="btn_Canc" class="btn btn-info" style="width: 100px"
						onclick="$('#modalReport').modal('hide');return false;">취소</button>
				</p>
			</td>
		</tr>
	</tbody>
</table>
