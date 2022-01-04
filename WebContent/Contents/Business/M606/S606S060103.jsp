<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*,java.util.*,javax.servlet.http.*"%>
<%@ page import="mes.client.comm.*" %>
<%@ page import="mes.client.common.*" %>
<%@ page import="mes.client.guiComponents.*" %>
<%@ page import="mes.client.util.*" %>
<%@ page import="mes.client.conf.*" %>
<!DOCTYPE html>
<%
	String loginID = session.getAttribute("login_id").toString();
	String member_key = session.getAttribute("member_key").toString();
	String zhtml = "";
	
	String GV_JSPPAGE="";

	
	if(request.getParameter("jspPage")== null)
		GV_JSPPAGE="";
	else
		GV_JSPPAGE = request.getParameter("jspPage");	
	
	
// 	CurrentPage jspPageName = new CurrentPage(request.getRequestURI());
// 	String JSPpage = jspPageName.GetJSP_FileName();
	ProcesStatusCheck prcStatusCheck = new ProcesStatusCheck(GV_JSPPAGE);
	String GV_GET_NUM_PREFIX	= prcStatusCheck.GV_PROCESS_NUMBER_GUBUN;	
	Vector optCode =  null;
    Vector optName =  null;
	Vector DocGubunVector = CommonData.getDocGubunCDAll(member_key);
// 	Vector midGubun = CommonData.getMidClassCdDataAll("GPR02");

	String GV_DOC_GUBUN_DEFAULT = "NORML001";
%>
    <script type="text/javascript">


    $(document).ready(function () {
    	$('#txt_Reg_reason').val("<%=GV_JSPPAGE%>")
    	
        $('#txt_pid').val('M606S010100E101');
    	$('#txt_user_id').val("<%=loginID%>")
<%--     	$('#txt_orderno').val("<%=GV_ORDER_NO%>") --%>
<%--     	$('#txt_order_detail').val("<%=GV_ORDERDETAIL%>") --%>
    	$('#txt_jspPage').val("<%=GV_JSPPAGE%>")
    	$('#txt_getnum_prefix').val("<%=GV_GET_NUM_PREFIX%>")

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
    
    </script>

<form id="upload_form" enctype="multipart/form-data" action="<%=Config.this_SERVER_path%>/hcp_EdmsServerServlet"  method="post" > 
	<table class="table " style="width: 100%; margin: 0 auto; align:left">
	   	<tbody  id="Doc_tbody">
	 		<tr>
	            <td style=" font-weight: 900; font-size:14px; text-align:left;vertical-align: middle" >등록사유</td>
	            <td style=" font-weight: 900; font-size:14px; text-align:left;vertical-align: middle" >
					<input type="text" class="form-control" id="txt_Reg_reason" name="reg_reason" style="width: 150px; float:left" readonly></input>
					<input type="text" class="form-control" id="txt_Reg_reason2" name="reg_reason" style="width: 150px; float:left" readonly value="신규등록"></input>
	            </td>
            	
	        </tr>
	 		<tr>
            	<td style='vertical-align: middle'>문서명</td>
	            <td style=" font-weight: 900; font-size:14px; text-align:left;vertical-align: middle" >
					<input type="text" 		class="form-control" 	id="txt_docname" 		name="docname" 		style="width: 250px; float:left" readonly></input>
					<button type="button" onclick="parent.pop_fn_DocName_View(1,0,'<%=GV_DOC_GUBUN_DEFAULT%>','')" id="btn_SearchProd" class="btn btn-info" style=" margin-left:10px;float:left">검색</button>
					<input type="hidden" 	class="form-control" 	id="txt_doccode" 		name="doccode" 		style="width: 150px" readonly></input>
					<input type="hidden" 	class="form-control" 	id="txt_rev_no" 		name="rev_no" 		style="width: 150px" readonly></input>
					<input type="hidden" 	class="form-control" 	id="txt_doc_gubun" 		name="doc_gubun" 	style="width: 150px" readonly></input>
					<input type="text" 		class="form-control" 	id="txt_doc_gubun_nm" 	name="doc_gubun_nm"	style="width: 250px; clear:both;" readonly></input>
					<input type="hidden" 	class="form-control" 	id="txt_pid" 			name="pid" 			style="width: 150px" readonly></input>
					<input type="hidden" 	class="form-control" 	id="txt_user_id" 		name="user_id" 		style="width: 150px" readonly></input>
					<input type="hidden" 	class="form-control" 	id="txt_jspPage" 		name="jspPage" 		style="width: 150px" readonly></input>
					<input type="hidden" 	class="form-control" 	id="txt_getnum_prefix" 	name="getnum_prefix" 	style="width: 150px" readonly></input> 
        		</td>
	        </tr>
	        
	 		<tr>
	            <td style=" font-weight: 900; font-size:14px; text-align:left; vertical-align:middle" >외부문서여부</td>
	            <td style=" font-weight: 900; font-size:14px; text-align:left; vertical-align:middle" >
	            	<div style="float:left; vertical-align:middle">
					<input type="checkbox" id="txt_external_doc_yn" name="external_doc" style="float:left"></input>
					</div> 
	            	<div style="float:left; vertical-align:middle">
					<label style="float:left; margin-left:30px;">총페이지수</label>
					</div> 
	            	<div style="float:left; vertical-align:middle">
					<input type="text"  class="form-control" 	id="txt_total_page"  name="total_page" 	style="width:80px;height: 30px; float:left;margin-left:10px;"></input>
					</div> 
        		</td>
	        </tr>
	 		<tr>
	            <td style=" font-weight: 900; font-size:14px; text-align:left;vertical-align: middle" >보관문서여부</td>
	            <td style=" font-weight: 900; font-size:14px; text-align:left;vertical-align: middle" >
					<input type="checkbox" id="txt_keep_yn" name="keep_yn" style="float:left"></input>
					<label style="float:left; margin-left:30px;">관리본여부</label>
					<input type="checkbox" 	id="txt_hold_yn"  name="hold_yn" 	style="float:lef; margin-left:10px;"></input> 
	            </td>
            	
	        </tr>  
	        <tr>
	            <td style=" font-weight: 900; font-size:14px; text-align:left" colspan="2">
					<input type="file"  name="filename1" multiple class="form-control" style="width: auto; border: solid 1px #cccccc;"/> 
	            </td>
            	
	        </tr> 
	           	     
	        <tr style="height: 60px">
	            <td colspan="2" align="center">
	                <p>
	                <button id="btn_Save"  class="btn btn-info" style="width: 100px" onclick="submit(); parent.$('#modalReport').hide().fadeIn(100);">등록</button>
                    <button id="btn_Canc"  class="btn btn-info" style="width: 100px" onclick="parent.$('#modalReport').hide();return false;">취소</button>
	                </p>
	            </td>
	        </tr>
    	</tbody>
	</table>
</form>    