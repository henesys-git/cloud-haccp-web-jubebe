<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page language="java"
	import="java.sql.*,java.util.*,javax.servlet.http.*"%>
<%@ page import="mes.client.comm.*"%>
<%@ page import="mes.client.common.*"%>
<%@ page import="mes.client.guiComponents.*"%>
<%@ page import="mes.client.util.*"%>
<%@ page import="mes.client.conf.*"%>
<%
	String loginID = session.getAttribute("login_id").toString();
	String member_key = session.getAttribute("member_key").toString();
	
	String[] strColumnHead = {"", "", "", ""};
	
	String GV_JSPPAGE = "M606S010101.jsp", 
		   GV_DOC_GUBUN = "", 
		   GV_DOC_NO="",
		   GV_REGIST_NO = "", 
		   GV_REVISION_NO = "", 
		   GV_DOCUMENT_NO = "", 
		   GV_FILEVIEW_NAME = "", 
	
	jspPagePID = "M606S010100E101";

	if (request.getParameter("jspPage") != null)
		GV_JSPPAGE = request.getParameter("jspPage");
	
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
	
	String param = GV_REGIST_NO + "|" + GV_REVISION_NO + "|" + GV_DOCUMENT_NO + "|" 
				 + GV_FILEVIEW_NAME + "|" + member_key + "|" ;
	
	DoyosaeTableModel TableModel = new DoyosaeTableModel("M606S010100E101", strColumnHead, param);
	CurrentPage jspPageName = new CurrentPage(request.getRequestURI());
	String JSPpage = jspPageName.GetJSP_FileName();
	ProcesStatusCheck prcStatusCheck = new ProcesStatusCheck(GV_JSPPAGE+"|"+"DCPROCS"+"|");
	
	String GV_GET_NUM_PREFIX = prcStatusCheck.GV_PROCESS_NUMBER_GUBUN;
	
	Vector optCode = null;
	Vector optName = null;
	Vector DocGubunReg = CommonData.getDocGubunReg(member_key);
%>
<script type="text/javascript">
	
    $(document).ready(function () {
        $('#txt_pid').val('M606S010100E101');
    	$('#txt_user_id').val("<%=loginID%>");
    	$('#txt_jspPage').val("<%=GV_JSPPAGE%>");
    	$('#txt_getnum_prefix').val("<%=GV_GET_NUM_PREFIX%>");
    	$('#txt_keep_yn').val("N");
    	$('#txt_gwanribon_yn').val("N");
    });
    
    function SetDocName_code(name, code, rev, num, doc_gubun,gubun_nm){
    	var len = $("#Doc_tbody tr").length-1;
		var trInput = $($("#Doc_tbody tr")[num]).find(":input");
		
    	$('#txt_docname').val(name);
    	$('#txt_doccode').val(code);
    	$('#txt_rev_no').val(rev);
    	
    	$('#txt_doc_gubun').val(doc_gubun);
    	$('#txt_doc_gubun_nm').val(gubun_nm);
    }
    
    function select_DocGubunReg() {
    	var getVal = $("#select_DocGubunReg option:selected").val();

    	if(getVal =="ALL") {
    		$("#txt_external_doc_source").val('');
    		$("#txt_external_doc_source").attr("disabled",true);
    		$("#txt_external_doc_yn").attr("disabled",true);
    		
    	} else if(getVal == "DOCREG01") {
    		//내부
    		$("#txt_external_doc_source").val('');
    		$("#txt_external_doc_source").attr("disabled",true);
    		$("#txt_external_doc_yn").attr("disabled",true);
    		$('#txt_external_doc_yn').val("N");

    	} else {
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
    	if(chkd) {
    		$('#txt_gwanribon_yn').val("Y");
    	} else {
    		$('#txt_gwanribon_yn').val("N");
    	}
    }
    
	function submitForm() {
    	
    	if($("#select_DocGubunReg option:selected").val() == "ALL"){
    		heneSwal.warning("문서출처구분을 선택해 주세요");
    		return;
    	}
    	
    	if($("#txt_doccode").val().length < 1){
    		heneSwal.warning("문서명을 검색해서 입력해주세요");
    		return;
    	}
    	
    	if ($('#idFilename').val().length < 1) {
    		heneSwal.warning("등록할 파일을 선택하세요");
    		return;
    	}
    	
		var work_complete_insert_check = confirm("등록하시겠습니까?");
		if(work_complete_insert_check == false)	{
			return false;
		}
    	
    	var form = $('#upload_form')[0];
        var data = new FormData(form);
        data.append("pid", 			$('#txt_pid').val());
        data.append("user_id", 		$('#txt_user_id').val());
        data.append("orderno", 		$('#txt_orderno').val());
        data.append("order_detail", $('#txt_order_detail').val());
        data.append("jspPage", 		$('#txt_jspPage').val());
        data.append("getnum_prefix", "DOC");
        data.append("reg_reason", "");
        data.append("JobType", $('#txt_JobType').val());
        data.append("regist_no", 	"");

        data.append("DocGubunReg", 	$("#select_DocGubunReg option:selected").val()); //선택된 인덱스의 값을 세팅 할 것
        data.append("docname", 		$('#txt_docname').val());
        data.append("doccode", 		$('#txt_doccode').val());
        data.append("rev_no", 		$('#txt_rev_no').val());
        data.append("doc_gubun", 	$('#txt_doc_gubun').val());
        data.append("external_doc_source", 	$('#txt_external_doc_source').val());
        
		data.append("external_doc", $('#txt_external_doc_yn').val()); 	// 외부문서여부
        data.append("total_page", 	$('#txt_total_page').val()); 		// 총페이지수
        data.append("keep_yn", 		$('#txt_keep_yn').val()); 			// 보관문서여부
        data.append("gwanribon_yn", $('#txt_gwanribon_yn').val()); 		// 관리본여부

        data.append("member_key", '<%=member_key%>'); 		// 관리본여부
        
   	    $.ajax({
			type: "POST",
			async: true,
   	        enctype: "multipart/form-data",
   	        acceptcharset: "UTF-8",
   	        url: "<%=Config.this_SERVER_path%>/hcp_EdmsServerServlet", 
   	        data: data,
   	        processData: false,
   	        contentType: false,
			cache: false,
   	        timeout: 600000,
   	        success: function (data) {
				if(data.length > 0) {
            		$('#modalReport').modal('hide');
            		parent.fn_MainInfo_List();
					heneSwal.successTimer("문서 등록 되었습니다");
				} else {
					heneSwal.errorTimer("문서 등록 실패했습니다, 다시 시도해주세요");
				}
			},
   	        error: function (e) {
				$("#result").text(e.responseText);
   	        }
   	    });
    }
</script>

<table class="table">
	<tbody id="Doc_tbody">
		<tr>
			<td>문서출처구분</td>
			<td>
				<select class="form-control" id="select_DocGubunReg"
						name="DocGubunReg" onchange="select_DocGubunReg()">
					<%optCode = (Vector) DocGubunReg.get(0);%>
					<%optName = (Vector) DocGubunReg.get(1);%>
					<%for (int i = 0; i < optName.size(); i++) {%>
							<option value='<%=optCode.get(i).toString()%>'><%=optName.get(i).toString()%></option>
					<%}%>
				</select>
			</td>
		</tr>
		<tr>
			<td>문서 분류</td>
			<td>
				<input type="hidden" class="form-control" id="txt_pid" name="pid" readonly> 
				<input type="hidden" class="form-control" id="txt_user_id" name="user_id" readonly> 
				<input type="hidden" class="form-control" id="txt_orderno" name="orderno" value="0" readonly> 
				<input type="hidden" class="form-control" id="txt_order_detail" name="order_detail" value="1" readonly> 
				<input type="hidden" class="form-control" id="txt_jspPage" name="jspPage" readonly> 
				<input type="hidden" class="form-control" id="txt_getnum_prefix" name="getnum_prefix" readonly> 
				<input type="hidden" class="form-control" id="txt_JobType" name="JobType" value="INSERT" readonly> 
				<input type="hidden" class="form-control" id="txt_doccode" name="doccode" readonly> 
				<input type="hidden" class="form-control" id="txt_rev_no" name="rev_no" readonly> 
				<input type="hidden" class="form-control" id="txt_doc_gubun" name="doc_gubun" readonly> 
				<form class="form-inline">
					<input type="text" class="form-control" id="txt_docname" name="docname" readonly>
					<button type="button" onclick="parent.pop_fn_DocName_View(1,2,'<%=GV_DOC_GUBUN%>','<%=GV_DOC_NO%>')"
						      id="btn_SearchProd" class="btn btn-info">검색</button>
				</form>
				<input type="text" class="form-control" id="txt_doc_gubun_nm" name="doc_gubun_nm" readonly>
			</td>
		</tr>
		<tr>
			<td>외부문서출처</td>
			<td>
				<input type="text" class="form-control">
			</td>
		</tr>

		<tr>
			<td>외부문서 여부</td>
			<td>
				<input type="checkbox" id="txt_external_doc_yn" name="external_doc" onClick="chkBoxCon_Ext(this.checked)" disabled value="N">
			</td>
		</tr>
		
		<tr>
			<td>총 페이지 수</td>
			<td>
				<input type="text" class="form-control" id="txt_total_page" name="total_page" value=0>
			</td>
		</tr>
		
		<tr>
			<td>보관문서 여부</td>
			<td>
				<input type="checkbox" id="txt_keep_yn" name="keep_yn" onClick="chkBoxCon_Keep(this.checked)">
			</td>
		</tr>
		
		<tr>
			<td>관리본 여부</td>
			<td>
				<input type="checkbox" id="txt_gwanribon_yn" name="gwanribon_yn" onClick="chkBoxCon_GBon(this.checked)">
			</td>
		</tr>
		
		<tr>
			<td>
				등록할 문서
			</td>
			<td>
				<form id="upload_form" enctype="multipart/form-data" action="<%=Config.this_SERVER_path%>/hcp_EdmsServerServlet" method="post">
					<input type="file" id="idFilename" name="filenames" multiple class="form-control">
				</form>
			</td>
		</tr>
	</tbody>
</table>