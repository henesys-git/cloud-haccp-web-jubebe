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
	
	DoyosaeTableModel TableModel;
	String[] strColumnHead = {"", "", "", ""};

	String GV_JSPPAGE = "M606S010102.jsp", jspPagePID = "M606S010100E102";
	String GV_REGIST_NO = "", 
		   GV_REVISION_NO = "", 
		   GV_DOCUMENT_NO = "", 
		   GV_FILEVIEW_NAME = "", 
		   GV_DOC_GUBUN = "", 
		   GV_DOC_NO = "";

	if (request.getParameter("doc_gubun") != null)
		GV_DOC_GUBUN = request.getParameter("doc_gubun");
	
	if (request.getParameter("RegistNo") != null)
		GV_REGIST_NO = request.getParameter("RegistNo");

	if (request.getParameter("RevisionNo") != null)
		GV_REVISION_NO = request.getParameter("RevisionNo");

	if (request.getParameter("DocumentNo") != null)
		GV_DOCUMENT_NO = request.getParameter("DocumentNo");

	if (request.getParameter("FileViewName") != null)
		GV_FILEVIEW_NAME = request.getParameter("FileViewName");
	
	if (request.getParameter("DocNo") != null)
		GV_DOC_NO = request.getParameter("DocNo");

	Vector optCode = null;
	Vector optName = null;
	Vector DocGubunReg = CommonData.getDocGubunRegAll(member_key);

	String param = GV_REGIST_NO + "|" 
				 + GV_REVISION_NO + "|" 
				 + GV_DOCUMENT_NO + "|" 
				 + GV_FILEVIEW_NAME + "|" 
				 + member_key + "|" ;
	
	TableModel = new DoyosaeTableModel("M606S010100E106", strColumnHead, param);
	CurrentPage jspPageName = new CurrentPage(request.getRequestURI());
	String JSPpage = jspPageName.GetJSP_FileName();
	
	// 데이터를 가져온다.
	Vector targetDocumentVector = (Vector) (TableModel.getVector().get(0));

	// 외부문서여부
	String externalDocYn = "";
	try {
		if (targetDocumentVector.get(8).toString().startsWith("Y"))
			externalDocYn = "value='Y' checked=\\\"checked\\\"";
		else{
			externalDocYn = "value='N'";
		}
	} catch (Exception e) {}
	
	// 보관문서여부
	String keepYn = "";
	try {
		if (targetDocumentVector.get(13).toString().startsWith("Y"))
			keepYn = "value='Y' checked=\\\"checked\\\"";
		else{
			keepYn = "value='N'";
		}
	} catch (Exception e) {}
	
	// 관리본여부
	String gwanribonYn = "";
	try {
		if (targetDocumentVector.get(12).toString().startsWith("Y"))
			gwanribonYn = "value='Y' checked=\\\"checked\\\"";
		else{
			gwanribonYn = "value='N'";
		}
	} catch (Exception e) {}
	
%>

<script type="text/javascript">

    $(document).ready(function () {
    	
    	if($("#select_DocGubunReg option:selected").val() == "DOCREG01"){
    		$("#txt_external_doc_source").val('');
    		$("#txt_external_doc_source").attr("disabled",true);
    		$("#txt_external_doc_yn").attr("disabled",true);
    		$("#txt_external_doc_yn").attr("checked",false);
    		$('#txt_external_doc_yn').val("N");
    	}
    });

    function SetDocName_code(name, code, rev, num, doc_gubun,gubun_nm){
    	var len = $("#Doc_tbody tr").length-1;		
		var trInput = $($("#Doc_tbody tr")[num]).find(":input")
		
    	$('#txt_docname').val(name)
    	$('#txt_doccode').val(code)
    	$('#txt_rev_no').val(rev)
    	$('#txt_doc_gubun').val(doc_gubun)
    	$('#txt_doc_gubun_nm').val(gubun_nm)
    }
    
    function select_DocGubunReg(){
    	
    	var getVal = $("#select_DocGubunReg option:selected").val();
    	
    	if(getVal =="ALL"){
    		$("#txt_external_doc_source").val('');
    		$("#txt_external_doc_source").attr("disabled",true);
    		$("#txt_external_doc_yn").attr("disabled",true);
    		
    	}else if(getVal == "DOCREG01"){
    		//내부
    		$("#txt_external_doc_source").val('');
    		$("#txt_external_doc_source").attr("disabled",true);
    		$("#txt_external_doc_yn").attr("disabled",true);
    		$("#txt_external_doc_yn").attr("checked",false);
    		$('#txt_external_doc_yn').val("N");
    	}else{
    		//외부
    		$("#txt_external_doc_source").attr("disabled",false);
    		$("#txt_external_doc_yn").attr("disabled",false);
    		$("#txt_external_doc_yn").attr("readonly",true);
    		$("#txt_external_doc_yn").attr("checked",true);
    		$('#txt_external_doc_yn').val("Y");
    	}
    }
    
    function chkBoxCon_Ext(chkd) {
    	if(chkd) $('#txt_external_doc_yn').val("Y");
    	else $('#txt_external_doc_yn').val("N");
    }
    function chkBoxCon_Keep(chkd) {
    	if(chkd) $('#txt_keep_yn').val("Y");
    	else $('#txt_keep_yn').val("N");
    }
    function chkBoxCon_GBon(chkd) {
    	if(chkd) $('#txt_gwanribon_yn').val("Y");
    	else $('#txt_gwanribon_yn').val("N");
    }
    
    function submitForm(){
    	
    	if($("#select_DocGubunReg option:selected").val() == "ALL"){
    		heneSwal.warning("문서출처구문을 선택해 주세요.");
    		return;
    	}
    	
		var work_complete_update_check = confirm("수정하시겠습니까?");
		if(work_complete_update_check == false)	return;
    	
    	var form = $('#upload_form')[0];
    	
        var data = new FormData(form);
        data.append("pid", 			$('#txt_pid').val());
        data.append("user_id", 		$('#txt_user_id').val());
        data.append("orderno", 		$('#txt_orderno').val());
        data.append("order_detail", $('#txt_order_detail').val());
        data.append("jspPage", 		$('#txt_jspPage').val());
        data.append("getnum_prefix",$('#txt_getnum_prefix').val());
        //data.append("reg_reason", 	$('#txt_Reg_reason').val());
        data.append("reg_reason", 	"");
        data.append("JobType", 		$('#txt_JobType').val());
        
        data.append("DocGubunReg",  "<%=targetDocumentVector.get(18).toString()%>"); //선택된 인덱스의 값을 세팅 할 것
        data.append("docname", 		$('#txt_docname').val());
        data.append("doccode", 		$('#txt_doccode').val());
        data.append("rev_no", 		$('#txt_rev_no').val());
        data.append("doc_gubun", 	$('#txt_doc_gubun').val());
        data.append("external_doc_source", 	$('#txt_external_doc_source').val());
        data.append("doc_gubunAfter", $("#select_DocGubunReg option:selected").val());
        data.append("modify_reason" , $("#txt_modify_season").val());
     
		data.append("external_doc", $('#txt_external_doc_yn').val()); 	// 외부문서여부
        data.append("total_page", 	$('#txt_total_page').val()); 		// 총페이지수
        data.append("keep_yn", 		$('#txt_keep_yn').val()); 			// 보관문서여부
        data.append("gwanribon_yn", $('#txt_gwanribon_yn').val()); 		// 관리본여부 M606S010100E106

		// 수정모드 변수
		data.append("regist_no", 		"<%=GV_REGIST_NO%>");
	 	data.append("revision_no", 		"<%=GV_REVISION_NO%>");
        data.append("document_no", 		"<%=GV_DOCUMENT_NO%>");
        data.append("file_view_name", 	"<%=GV_FILEVIEW_NAME%>");
        
        data.append("member_key", 	"<%=member_key%>");
        
        $("#btn_Save").prop("disabled", true);
        
    	if ($('#idFilename').val().length < 1) {
    		alret("수정할 파일을 선택하세요-!!");
    		return;
    	}else{
    		
    	    $.ajax({
				type: "POST",
				async: false,
    	        enctype: "multipart/form-data",
    	        url: "<%=Config.this_SERVER_path%>/hcp_EdmsServerServlet",
				data : data,
				processData : false,
				contentType : false,
				cache : false,
				timeout : 600000,
				success : function(data) {
					if (data.length > 0) {
						heneSwal.success("수정 되었습니다");
						vDocGubun = "";
						parent.fn_MainInfo_List();
	             		$('#modalReport').modal('hide');
					}
				},
				error : function(e) {
					$("#result").text(e.responseText);
					console.log("ERROR : ", e);
					$("#btnSubmit").prop("disabled", false);
				}
			});
		}
	}
</script>

<table class="table">
	<tbody id="Doc_tbody">
		<%-- <tr>
			<td>등록사유</td>
			<td>
				<input type="text" class="form-control" id="txt_Reg_reason" name="reg_reason" value="<%=targetDocumentVector.get(9).toString()%>" readonly>
			</td>
		</tr> --%>

		<tr>
			<td>문서출처구분</td>
			<td>
				<select class="form-control" id="select_DocGubunReg" name="DocGubunReg" onchange="select_DocGubunReg()">
					<%
						optCode = (Vector) DocGubunReg.get(0);
						optName = (Vector) DocGubunReg.get(1);

						for (int i = 0; i < optName.size(); i++) {
							if (optCode.get(i).equals(targetDocumentVector.get(18).toString())) {
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

		<tr>
			<td>문서 분류</td>
			<td>
				<input type="hidden" class="form-control" id="txt_pid" name="pid" value="<%=jspPagePID%>" readonly> 
				<input type="hidden" class="form-control" id="txt_user_id" name="user_id" value="<%=loginID%>" readonly> 
				<input type="hidden" class="form-control" id="txt_orderno" name="orderno" value="" readonly> 
				<input type="hidden" class="form-control" id="txt_order_detail" name="order_detail" value="1" value="" readonly>
				<input type="hidden" class="form-control" id="txt_jspPage" name="jspPage" value="<%=GV_JSPPAGE%>" readonly>
				<input type="hidden" class="form-control" id="txt_getnum_prefix"
				name="getnum_prefix" value="수정시 prefix 필요 없음" readonly> 
				<input type="hidden" class="form-control" id="txt_JobType" name="JobType" value="DB_UPDATE" readonly> 
				<input type="text" class="form-control" id="txt_docname" name="docname" float: left" value="<%=targetDocumentVector.get(1).toString()%>" readonly>
				<input type="hidden" class="form-control" id="txt_doccode" name="doccode" value="<%=targetDocumentVector.get(0).toString()%>" readonly>
				<input type="hidden" class="form-control" id="txt_rev_no" name="rev_no" value="<%=targetDocumentVector.get(17).toString()%>" readonly>
				<input type="hidden" class="form-control" id="txt_doc_gubun" name="doc_gubun" value="<%=targetDocumentVector.get(2).toString()%>" readonly>
				<input type="text" class="form-control" id="txt_doc_gubun_nm" name="doc_gubun_nm" value="<%=targetDocumentVector.get(3).toString()%>" readonly>
				<input type="hidden" class="form-control" id="txt_doc_gubunbefore" name="doc_gubunbefore" value="<%=targetDocumentVector.get(2).toString()%>" readonly>
			</td>
		</tr>


		<tr>
			<td>외부문서 출처</td>
			<td>
				<input type="text" class="form-control" id="txt_external_doc_source" name="external_doc_source" value="<%=targetDocumentVector.get(19).toString()%>">
			</td>
		</tr>
		
		<tr>
			<td>외부문서 여부</td>
			<td>
				<input type="checkbox" id="txt_external_doc_yn" name="external_doc" <%=externalDocYn%> onClick="chkBoxCon_Ext(this.checked) ">
			</td>
		</tr>
		
		<tr>
			<td>총 페이지 수</td>
			<td>
				<input type="text" class="form-control" id="txt_total_page"
					   name="total_page" value="<%=targetDocumentVector.get(11).toString()%>">
			</td>
		</tr>
		
		<tr>
			<td>보관문서 여부</td>
			<td>
				<input type="checkbox" id="txt_keep_yn" name="keep_yn" <%=keepYn%> onClick="chkBoxCon_Keep(this.checked)">
			</td>
		</tr>

		<tr>
			<td>관리본 여부</td>
			<td>
				<input type="checkbox" id="txt_gwanribon_yn" name="gwanribon_yn" <%=gwanribonYn%> onClick="chkBoxCon_GBon(this.checked)">
			</td>
		</tr>
		<tr>
			<td>문서</td>
			<td>
				<form id="upload_form" enctype="multipart/form-data" action="<%=Config.this_SERVER_path%>/hcp_EdmsServerServlet" method="post">
					<input type="text" id="idFilename" name="filename" class="form-control" value="<%=targetDocumentVector.get(4).toString()%>" disabled>
				</form>
			</td>
		</tr>
		
		<tr>
			<td>수정사유</td>
			<td>
				<input class="form-control" id="txt_modify_season">
			</td>
		</tr>
	</tbody>
</table>