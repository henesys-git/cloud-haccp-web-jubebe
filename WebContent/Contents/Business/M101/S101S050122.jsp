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
문서개정(S101S050122)
 */
	String loginID = session.getAttribute("login_id").toString();
	String member_key = session.getAttribute("member_key").toString();
	String zhtml = "";
	
	DoyosaeTableModel TableModel;
	String[] strColumnHead = {"", "", "", "" };

	String GV_JSPPAGE="M606S010122.jsp", jspPagePID="M606S010100E122";
	String GV_REGIST_NO="", GV_DOCUMENT_NO="", GV_FILEVIEW_NAME="";
	Integer GV_REVISION_NO=0;	//2018-11-25 jh 수정
	CurrentPage jspPageName = new CurrentPage(request.getRequestURI());
	String JSPpage = jspPageName.GetJSP_FileName();
	

	String GV_ORDERNO="", GV_CUSTCODE="", GV_ORDER_DETAIL_SEQ="";

	if(request.getParameter("orderno")== null)//2018-11-25 jh 추가
		GV_ORDERNO="";
	else
		GV_ORDERNO = request.getParameter("orderno");
	

	if(request.getParameter("order_detail_seq")== null)//2018-11-25 jh 추가
		GV_ORDER_DETAIL_SEQ="";
	else
		GV_ORDER_DETAIL_SEQ = request.getParameter("order_detail_seq");
	
	if(request.getParameter("jspPage")== null) {
		GV_JSPPAGE	=	JSPpage;
	}
	else {
		GV_JSPPAGE = request.getParameter("jspPage");
	}
	
//	try {
//		jspPagePID = GV_JSPPAGE.substring(0, GV_JSPPAGE.indexOf("."));
//	} catch (Exception e) {
//		jspPagePID = "";
//	}
							
	if(request.getParameter("RegistNo")== null) GV_REGIST_NO="";
	else GV_REGIST_NO = request.getParameter("RegistNo");	

	if(request.getParameter("RevisionNo")== null) GV_REVISION_NO=0;				//2018-11-25 jh 수정
	else GV_REVISION_NO = Integer.parseInt(request.getParameter("RevisionNo"));	//2018-11-25 jh 수정

	if(request.getParameter("DocumentNo")== null) GV_DOCUMENT_NO="";
	else GV_DOCUMENT_NO = request.getParameter("DocumentNo");	

	if(request.getParameter("FileViewName")== null) GV_FILEVIEW_NAME="";
	else GV_FILEVIEW_NAME = request.getParameter("FileViewName");

	
	
	Vector optCode =  null;
    Vector optName =  null;	
	Vector DocGubunReg = CommonData.getDocGubunRegAll(member_key);
	
	String param = GV_REGIST_NO + "|" + GV_REVISION_NO + "|" + GV_DOCUMENT_NO + "|" 
				+ GV_FILEVIEW_NAME + "|" + member_key + "|";
    TableModel = new DoyosaeTableModel("M606S010100E204", strColumnHead, param);
    int ColCount =TableModel.getColumnCount();
		
    // 데이터를 가져온다.
    Vector targetDocumentVector = (Vector)(TableModel.getVector().get(0));
    
    // 외부문서여부
    String externalDocYn = "";
    try {
    	if (targetDocumentVector.get(8).toString().startsWith("Y")) 
    		externalDocYn = "value='Y' checked=\\\"checked\\\"";
    } catch (Exception e) {}
    // 보관문서여부
    String keepYn = "";
    try {
    	if (targetDocumentVector.get(13).toString().startsWith("Y")) 
    		keepYn = "value='Y' checked=\\\"checked\\\"";
    } catch (Exception e) {}
    // 관리본여부
    String gwanribonYn = "";
    try {
    	if (targetDocumentVector.get(12).toString().startsWith("Y")) 
    		gwanribonYn = "value='Y' checked=\\\"checked\\\"";
    } catch (Exception e) {}
    
%>

    <script type="text/javascript">

    $(document).ready(function () {
    });

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
    	if ($('#idFilename').val().indexOf( $('#old_idFilename').val()) < 0) {
    		alert("개정할 파일명과 개정전의 파일명은 같아야 합니다.");
    		return;
    	}

    	var form = $('#upload_form')[0];
    	
        var data = new FormData(form);

        data.append("pid", 			$('#txt_pid').val());
        data.append("user_id", 		$('#txt_user_id').val());
        data.append("orderno", 		"<%=GV_ORDERNO%>");  
        data.append("order_detail", "<%=GV_ORDER_DETAIL_SEQ%>");
        data.append("jspPage", 		$('#txt_jspPage').val());
        data.append("reg_reason", 	$('#txt_Reg_reason').val());
        data.append("JobType", 		$('#txt_JobType').val());
        
        data.append("DocGubunReg",  "<%=targetDocumentVector.get(18).toString()%>");
        data.append("doc_no", 		$('#txt_doc_no').val());
        data.append("docname", 		$('#txt_docname').val());
        data.append("doccode", 		$('#txt_doccode').val());
        data.append("rev_no", 		$('#txt_rev_no').val());
        data.append("doc_gubun", 	$('#txt_doc_gubun').val());
        data.append("external_doc_source", 	$('#txt_external_doc_source').val());
        data.append("regist_reason" , $("#txt_regist_reason_code").val());
        data.append("modify_reason" , $("#txt_modify_season").val());
        
		data.append("external_doc", $('#txt_external_doc_yn').val()); 	// 외부문서여부
        data.append("total_page", 	$('#txt_total_page').val()); 		// 총페이지수
        data.append("keep_yn", 		$('#txt_keep_yn').val()); 			// 보관문서여부
        data.append("gwanribon_yn", $('#txt_gwanribon_yn').val()); 		// 관리본여부 

		// 수정모드 변수	
		data.append("regist_no", 		"<%=GV_REGIST_NO%>");		//등로번호 //2018-11-25 jh 수정
		data.append("pre_revision_no", 		"<%=GV_REVISION_NO%>");		//개정전 번호 //2018-11-25 jh 수정
	 	data.append("revision_no", 		"<%=GV_REVISION_NO+1%>");	//문서등록번호 Rev+1 증가해서 보낸다...M606S010100E122에서는 증가시키지말고 받는 그대로 저장 하자
        data.append("document_no", 		"<%=GV_DOCUMENT_NO%>");		//doccode와 같은 값이 되어야 함
        data.append("file_view_name", 	"<%=GV_FILEVIEW_NAME%>");	//파일명  개정전 파일명과 동일해야 함. 들리면 개정이아니고 신규 등록 됨
        
        data.append("member_key", 	"<%=member_key%>"); 

        $("#btn_Save").prop("disabled", true);
        
    	if ($('#idFilename').val().length < 1) {
    		alert("개정할 파일을 선택하세요-!!");
    		return;
    	}
    	else{
    		
    	    $.ajax({
				type: "POST",
				async: false,
    	        enctype: "multipart/form-data",
    	        url: "<%=Config.this_SERVER_path%>/hcp_EdmsServerServlet" ,
    	        data: data,
    	        processData: false,
    	        contentType: false,
				cache: false,
    	        timeout: 600000,
    	            
    	        beforeSend: function () {
    	        },
    	         
    	        success: function (data) {
                    $("#btn_Save").prop("disabled", false);
					if(data.length>0){}

                    	alert("개정 되었습니다.");
                		
                 		parent.fn_MainInfo_List();
                 		parent.SubInfo_DOC_List.click();
                 		parent.$("#ReportNote").children().remove();
                 		parent.$('#modalReport').hide();
	                },
    	        error: function (e) {

                    $("#result").text(e.responseText);
                    console.log("ERROR : ", e);
                    $("#btnSubmit").prop("disabled", false);

    	        }
    	     });	
    	    
// 	    	sbmifrm.sumit();
// 	    	return;
    	}
    }

    </script>
    
	<table class="table " style="width: 100%; margin: 0 auto; align:left">
	   	<tbody  id="Doc_tbody">
	 		<tr>
	            <td style=" font-weight: 900; font-size:14px; text-align:left;vertical-align: middle" >등록사유</td>
	            <td style=" font-weight: 900; font-size:14px; text-align:left;vertical-align: middle" >
					<input type="text" class="form-control" id="txt_Reg_reason" name="reg_reason" style="width: 150px; float:left" 
            		value="<%=targetDocumentVector.get(9).toString() %>" readonly /></input>
	            </td>		  
	        </tr>
	        
	        <tr>
				<td
					style="font-weight: 900; font-size: 14px; text-align: left; vertical-align: middle">문서출처구분</td>
				<td
					style="font-weight: 900; font-size: 14px; text-align: left; vertical-align: middle">
					<select class="form-control" id="select_DocGubunReg"
					name="DocGubunReg" style="width: 120px" readonly>
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
            	<td style='vertical-align: middle'>문서명</td>
	            <td style=" font-weight: 900; font-size:14px; text-align:left;vertical-align: middle" >
	            	<input type="hidden" 	class="form-control" 	id="txt_pid" 			name="pid" 			style="width: 150px" 
	            		value="<%=jspPagePID%>" readonly></input>
					<input type="hidden" 	class="form-control" 	id="txt_user_id" 		name="user_id" 		style="width: 150px" 
						value="<%=loginID%>" readonly></input>
					<input type="hidden" 	class="form-control" 	id="txt_orderno" 		name="orderno" 			value="0" style="width: 150px" 
						value="" readonly></input> 
					<input type="hidden" 	class="form-control" 	id="txt_order_detail" 	name="order_detail" 	value="1" style="width: 150px" 
						value="" readonly></input> 
					<input type="hidden" 	class="form-control" 	id="txt_jspPage" 		name="jspPage" 		style="width: 150px" 
						value="<%=GV_JSPPAGE%>" readonly></input>
					<input type="hidden" class="form-control" id="txt_JobType" 	name="JobType" 	style="width: 150px" 
						value="UPDATE" readonly></input> 
	            
					<input type="text" 		class="form-control" 	id="txt_docname" 		name="docname" 		style="width: 250px; float:left" 
						value="<%=targetDocumentVector.get(1).toString() %>" readonly></input>
					<input type="hidden" 	class="form-control" 	id="txt_doc_no" 		name="doc_no" 		style="width: 150px"
						value="<%=targetDocumentVector.get(0).toString() %>" readonly></input>
					<input type="hidden" 	class="form-control" 	id="txt_doccode" 		name="doccode" 		style="width: 150px" 
						value="<%=targetDocumentVector.get(0).toString() %>" readonly></input> <!-- 2018-11-25 jh 수정 -->
					<input type="hidden" 	class="form-control" 	id="txt_rev_no" 		name="rev_no" 		style="width: 150px" 
						value="<%=targetDocumentVector.get(17).toString() %>" readonly></input>
					<input type="hidden" 	class="form-control" 	id="txt_doc_gubun" 	name="doc_gubun" 	style="width: 150px" 
						value="<%=targetDocumentVector.get(2).toString() %>" readonly></input>
					<input type="text" 		class="form-control" 	id="txt_doc_gubun_nm" 	name="doc_gubun_nm"	style="width: 250px; clear:both;" 
						value="<%=targetDocumentVector.get(3).toString() %>" readonly></input>
        			<input type="text" 		class="form-control" 	id="txt_regist_reason_code" 	name="doc_gubun_nm"	style="width: 250px; clear:both;" 
						value="<%=targetDocumentVector.get(9).toString() %>" readonly></input>
					<input type="hidden" 	class="form-control" 	id="txt_external_doc_source" 	name="doc_source" 	style="width: 150px" 
						value="<%=targetDocumentVector.get(19).toString() %>" readonly></input>
        		</td>
	        </tr>
<!-- 
//{"문서코드", "문서명", "문서구분코드", "문서구분", "파일명","등록번호","변경번호", "실파일명"  ,"외부문서", "등록사유", 
//	"파기사유","총페이지", "관리본여부","보관여부","보존여부","등록일자", "등록자", document_no_rev} ;		
 -->	        
	        
	 		<tr>
	            <td style=" font-weight: 900; font-size:14px; text-align:left; vertical-align:middle" >외부문서여부</td>
	            <td style=" font-weight: 900; font-size:14px; text-align:left; vertical-align:middle" >
	            	<div style="float:left; vertical-align:middle">
	            	<!-- 체크박스에 대해서는 아래와 같이 "<%=externalDocYn%>"로  하면 안되고 ""를 없애야한다.-->
					<input type="checkbox" id="txt_external_doc_yn" name="external_doc" style="float:left" 
						<%=externalDocYn%> onClick="chkBoxCon_Ext(this.checked)"	readonly></input>
					</div> 
	            	<div style="float:left; vertical-align:middle">
					<label style="float:left; margin-left:30px;">총페이지수</label>
					</div> 
	            	<div style="float:left; vertical-align:middle">
					<input type="text"  class="form-control" 	id="txt_total_page"  name="total_page" 	style="width:80px;height: 30px; float:left;margin-left:10px;"
            			value="<%=targetDocumentVector.get(11).toString() %>" readonly/></input>
					</div>
        		</td>
	        </tr>
	 		<tr>
	            <td style=" font-weight: 900; font-size:14px; text-align:left;vertical-align: middle" >보관문서여부</td>
	            <td style=" font-weight: 900; font-size:14px; text-align:left;vertical-align: middle" >
					<input type="checkbox" id="txt_keep_yn" name="keep_yn" style="float:left"
						<%=keepYn%> onClick="chkBoxCon_Keep(this.checked)" readonly></input>
					<label style="float:left; margin-left:30px;">관리본여부</label>
					<input type="checkbox" 	id="txt_gwanribon_yn"  name="gwanribon_yn" 	style="float:lef; margin-left:10px;"
						<%=gwanribonYn%> onClick="chkBoxCon_GBon(this.checked)" readonly></input>
	            </td>
            	
	        </tr>  
	        <tr>
	        	<td style=" font-weight: 900; font-size:14px; text-align:left;vertical-align: middle" >파일명</td>
	            <td style=" font-weight: 900; font-size:14px; text-align:left" colspan="2">
			<form id="upload_form" name="uploadForm" enctype="multipart/form-data" action="<%=Config.this_SERVER_path%>/hcp_EdmsServerServlet"  method="post" >
					<input type="text" id="old_idFilename" name="old_filename" class="form-control" style="width: auto; border: solid 1px #cccccc;"
            			value="<%=targetDocumentVector.get(4).toString() %>" readonly /></input>
					<input type="file" id="idFilename" name="filename"  multiple class="form-control" style="width: auto; border: solid 1px #cccccc;"
						 />
			</form>
	            </td>
	        </tr> 
	        
	        <tr>
				<td
						style="font-weight: 900; font-size: 14px; text-align: left; vertical-align: middle">수정사유</td>
				<td
					style="font-weight: 900; font-size: 14px; text-align: left; vertical-align: middle">
					<textarea class="form-control" id="txt_modify_season" style="width : 100%;resize: none;" ></textarea></td>
				</td>
			</tr>
	           	     
	        <tr style="height: 60px">
	            <td colspan="2" align="center">
	                <p>
	                <button id="btn_Save"  class="btn btn-info" style="width: 100px" onclick="submitForm(); return false; parent.$('#modalReport').hide().fadeIn(100);">개정</button>
                    <button id="btn_Canc"  class="btn btn-info" style="width: 100px" onclick="parent.$('#modalReport').hide();return false;">취소</button>
	                </p>
	            </td>
	        </tr>
    	</tbody>
	</table>
	