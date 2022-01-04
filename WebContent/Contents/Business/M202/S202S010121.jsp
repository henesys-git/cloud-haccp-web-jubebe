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

// 	DoyosaeTableModel TableModel;
	String zhtml = "";
	
	String GV_ORDER_NO="",GV_JSPPAGE="", GV_ORDERDETAIL, GV_INNERTEXT,GV_LOTNO="";

	if(request.getParameter("OrderNo")== null)
		GV_ORDER_NO="";
	else
		GV_ORDER_NO = request.getParameter("OrderNo");
	
	if(request.getParameter("OrderDetail")== null)
		GV_ORDERDETAIL="";
	else
		GV_ORDERDETAIL = request.getParameter("OrderDetail");
	
	if(request.getParameter("jspPage")== null)
		GV_JSPPAGE="";
	else
		GV_JSPPAGE = request.getParameter("jspPage");	

	if(request.getParameter("innerText")== null)
		GV_INNERTEXT="";
	else
		GV_INNERTEXT = request.getParameter("innerText");
	
	if(request.getParameter("LotNo")== null)
		GV_LOTNO = "";
	else
		GV_LOTNO = request.getParameter("LotNo");
	
	String param = GV_ORDER_NO + "|" + GV_JSPPAGE + "|";	
	
	CurrentPage jspPageName = new CurrentPage(request.getRequestURI());
	String JSPpage = jspPageName.GetJSP_FileName();
	
	ProcesStatusCheck prcStatusCheck = new ProcesStatusCheck(JSPpage+"|"+"NON"+"|");
	String GV_GET_NUM_PREFIX	= prcStatusCheck.GV_PROCESS_NUMBER_GUBUN;	
	
	Vector optCode =  null;
    Vector optName =  null;;
	Vector DocGubunReg = CommonData.getDocGubunReg(member_key);
	
	String GV_DOC_GUBUN_DEFAULT = "NORML001";
%>
    <script type="text/javascript">


    $(document).ready(function () {
    	$('#txt_Reg_reason').val("<%=GV_JSPPAGE%>")
    	
        $('#txt_pid').val('M606S010100E111');
    	$('#txt_user_id').val("<%=loginID%>");
    	$('#txt_orderno').val("<%=GV_ORDER_NO%>");
    	$('#txt_lotno').val("<%=GV_LOTNO%>");
    	$('#txt_jspPage').val("<%=GV_JSPPAGE%>");
    	$('#txt_getnum_prefix').val("<%=GV_GET_NUM_PREFIX%>");
    	
    	fn_DocGubun_check(); // 문서출처구분에 따라 출처 입력칸 활성화/비활성화
    });


    function SetDocName_code(name, code, rev, num, doc_gubun,gubun_nm){

    	var len = $("#Doc_tbody tr").length-1;		
		var trInput = $($("#Doc_tbody tr")[num]).find(":input")
		trInput.eq(0).val(name);
		trInput.eq(1).val(code);
		trInput.eq(2).val(rev);			//doc_code_rev
		trInput.eq(3).val(doc_gubun);
    }
    
    function submitForm(){
    	
        var form = $('#upload_form')[0];
        var data = new FormData(form);
        data.append("docname1", 	$('#txt_docname1').val());
        data.append("doccode1", 	$('#txt_doccode1').val());
        data.append("rev_no1", 		$('#txt_rev_no1').val());
        data.append("doc_gubun1", 	$('#txt_doc_gubun1').val());
        data.append("external_doc_source", 	$('#txt_external_doc_source').val());
        data.append("DocGubunReg", 	$("#select_DocGubunReg option:selected").val()); //선택된 인덱스의 값을 세팅 할 것
        
        data.append("pid", 			$('#txt_pid').val());
        data.append("user_id", 		$('#txt_user_id').val());
        data.append("orderno", 		$('#txt_orderno').val());
		data.append("lotno",	 	$('#txt_lotno').val()); //추가
        data.append("jspPage", 		$('#txt_jspPage').val());
        data.append("getnum_prefix", $('#txt_getnum_prefix').val());
        data.append("JobType", 		$('#txt_JobType').val());
        data.append("reg_reason", 	$('#txt_Reg_reason').val());
        
        data.append("docname2", 	$('#txt_docname2').val());
        data.append("doccode2", 	$('#txt_doccode2').val());
        data.append("rev_no2", 		$('#txt_rev_no2').val());
        data.append("doc_gubun2", 	$('#txt_doc_gubun2').val());

        data.append("docname3", 	$('#txt_docname3').val());
        data.append("doccode3", 	$('#txt_doccode3').val());
        data.append("rev_no3", 		$('#txt_rev_no3').val());
        data.append("doc_gubun3", 	$('#txt_doc_gubun3').val());

        data.append("docname4", 	$('#txt_docname4').val());
        data.append("doccode4", 	$('#txt_doccode4').val());
        data.append("rev_no4", 		$('#txt_rev_no4').val());
        data.append("doc_gubun4", 	$('#txt_doc_gubun4').val());

        data.append("docname5", 	$('#txt_docname5').val());
        data.append("doccode5", 	$('#txt_doccode5').val());
        data.append("rev_no5", 		$('#txt_rev_no5').val());
        data.append("doc_gubun5", 	$('#txt_doc_gubun5').val());
        data.append("member_key", 	"<%=member_key%>"); 
        $("#btn_Save").prop("disabled", true);
        
//     	alert($('#iDfilename1').val().length);
    	if($('#iDfilename1').val().length<1 && $('#iDfilename2').val().length<1  && $('#iDfilename3').val().length<1 
    			 && $('#iDfilename4').val().length<1  && $('#iDfilename5').val().length<1 ){
    		alert("등록할 파일을 선택하세요-!!");
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
					if(data.length>0){
                    	console.log("성공 : ", data);
                    	alert("성공 : "+ data+ "이 성공적으로 등록 되었습니다.");                		
                   		SubInfo_DOC_List.click();
                 		parent.$('#modalReport').hide();
					}
	            },
    	        error: function (e) {

                    $("#result").text(e.responseText);
                    console.log("ERROR : ", e);
                    $("#btnSubmit").prop("disabled", false);

    	        }
    	     });	
    	}
    }
    
    //문서출처구분 선택시 실행 (외부문서 외의 다른 값 선택시 출처입력칸 disabled)
    function fn_DocGubun_check() {
    	if($("#select_DocGubunReg").val().trim()=="DOCREG02") { // 외부문서
    		$("#txt_external_doc_source").prop("disabled",false);
    	} else { // 외부문서 아닐때
    		$("#txt_external_doc_source").prop("disabled",true);
    		$("#txt_external_doc_source").val("");
    	}
    }
    
    </script>

	<table class="table" style="width: 100%; margin: 0 auto; align:left">
	 		<tr style="height: 40px">
	            <td style="width:15%; font-weight: 900; font-size:14px; text-align:left" >등록사유</td>
	            <td style="width:35%;"><%=GV_INNERTEXT%>
					<input type="text" class="form-control" id="txt_Reg_reason" name="reg_reason" style="width: 150px" readonly></input>
	            </td>
	            <td style="width:50%;"> </td>
	        </tr>     	        
	 		<tr style="height: 40px">
	            <td style="font-weight: 900; font-size:14px; text-align:left" >문서출처구분</td>
	            <td>
					<select class="form-control" id="select_DocGubunReg" name="DocGubunReg"  style="width: 120px" onchange="fn_DocGubun_check()">
			            <%	optCode =  (Vector)DocGubunReg.get(0);%>
			            <%	optName =  (Vector)DocGubunReg.get(1);%>
			            <%for(int i=0; i<optName.size();i++){ %>
						  <option value='<%=optCode.get(i).toString()%>'><%=optName.get(i).toString()%></option>
						<%} %>
					</select>
	            </td>
	            <td></td>
	        </tr>   
	 		<tr style="height: 40px">
	            <td style="font-weight: 900; font-size:14px; text-align:left" >외부문서 출처</td>
	            <td>
	            <input type="text" 	class="form-control" 	id="txt_external_doc_source"	name="external_doc_source" 		style="width: 70%; float:left;" ></input>
	            </td>
	            <td></td>
	        </tr>    	        
	        <tr>
	        	<td colspan="2" style="width:50%; font-weight: 900; font-size:14px; text-align:left" >
		        	<table style="width:100%;">
	        		<tbody  id="Doc_tbody">
						<tr style="height: 40px; vertical-align: middle"> 
				            <td style="width: 20%; font-weight: 900; font-size:14px; text-align:left; vertical-align: middle">문서#1</td>
				            <td style="width: 80%; font-weight: 900; font-size:14px; text-align:left; vertical-align: middle">
								<input type="text" 		class="form-control" 	id="txt_docname1" 		name="docname1" 		style="width: 250px; float:left" readonly></input>
								<input type="hidden" 	class="form-control" 	id="txt_doccode1" 		name="doccode1" 		style="width: 150px" readonly></input>
								<input type="hidden" 	class="form-control" 	id="txt_rev_no1" 		name="rev_no1" 			style="width: 150px" readonly></input>
								<input type="hidden" 	class="form-control" 	id="txt_doc_gubun1" 		name="doc_gubun1" 		style="width: 150px" readonly></input>
								
								<input type="hidden" 	class="form-control" 	id="txt_JobType" 	value="INSERT"	name="JobType" 	   style="width: 150px" readonly></input>
								<input type="hidden" 	class="form-control" 	id="txt_pid" 			name="pid" 				style="width: 150px" readonly></input>
								<input type="hidden" 	class="form-control" 	id="txt_user_id" 		name="user_id" 			style="width: 150px" readonly></input>
								<input type="hidden" 	class="form-control" 	id="txt_orderno" 		name="orderno" 			style="width: 150px" readonly></input>
								<input type="hidden" 	class="form-control" 	id="txt_lotno" 	name="lotno" 	style="width: 150px" readonly></input>
								<input type="hidden" 	class="form-control" 	id="txt_jspPage" 		name="jspPage" 			style="width: 150px" readonly></input>
								<input type="hidden" 	class="form-control" 	id="txt_getnum_prefix" 	name="getnum_prefix" 	style="width: 150px" readonly></input>
								<button type="button" onclick="parent.pop_fn_DocName_View(1,0,'<%=GV_DOC_GUBUN_DEFAULT%>','')" id="btn_SearchProd" class="btn btn-info" style=" margin-left:10px;float:left">
								    문서코드</button> 
				           	</td>
				        </tr>       
				        <tr style="height: 40px; vertical-align: middle">
				            <td style="font-weight: 900; font-size:14px; text-align:left; vertical-align: middle">문서#2</td>
				            <td style=" font-weight: 900; font-size:14px; text-align:left; vertical-align: middle">
								<input type="text" 		class="form-control" 	id="txt_docname2"   name="docname2" 			style="width: 250px; float:left" readonly></input>
								<input type="hidden" 	class="form-control" 	id="txt_doccode2" 	name="doccode2" 			style="width: 150px" readonly></input>
								<input type="hidden" 	class="form-control" 	id="txt_rev_no2" 	name="rev_no2" 			style="width: 150px" readonly></input>
								<input type="hidden" 	class="form-control" 	id="txt_doc_gubun2" 	name="doc_gubun2" 		style="width: 150px" readonly></input>
								<button type="button" onclick="parent.pop_fn_DocName_View(1,1,'<%=GV_DOC_GUBUN_DEFAULT%>','')" id="btn_SearchProd" class="btn btn-info" style="margin-left:10px;float:left">
								    문서코드</button> 
				           	</td>
				        </tr>   
				                 
				        <tr style="height: 40px; vertical-align: middle">
				            <td style="font-weight: 900; font-size:14px; text-align:left; vertical-align: middle">문서#3</td>
				            <td style="font-weight: 900; font-size:14px; text-align:left; vertical-align: middle">
								<input type="text" 		class="form-control" 	id="txt_docname3" 		name="docname3" 			style="width: 250px; float:left" readonly></input>
								<input type="hidden" 	class="form-control" 	id="txt_doccode3" 		name="doccode3" 			style="width: 150px" readonly></input>
								<input type="hidden" 	class="form-control" 	id="txt_rev_no3" 		name="rev_no3" 			style="width: 150px" readonly></input>
								<input type="hidden" 	class="form-control" 	id="txt_doc_gubun3" 		name="doc_gubun3" 		style="width: 150px" readonly></input>
								<button type="button" onclick="parent.pop_fn_DocName_View(1,2,'<%=GV_DOC_GUBUN_DEFAULT%>','')" id="btn_SearchProd" class="btn btn-info" style="margin-left:10px;float:left">
								    문서코드</button> 
				           	</td>
				        </tr>       
				        <tr style="height: 40px; vertical-align: middle">
				            <td style="font-weight: 900; font-size:14px; text-align:left; vertical-align: middle">문서#4</td>
				            <td style="font-weight: 900; font-size:14px; text-align:left; vertical-align: middle">
								<input type="text" 		class="form-control" 	id="txt_docname4" 		name="docname4" 			style="width: 250px; float:left" readonly></input>
								<input type="hidden" 	class="form-control" 	id="txt_doccode4" 		name="doccode4" 			style="width: 150px" readonly></input>
								<input type="hidden" 	class="form-control" 	id="txt_rev_no4" 		name="rev_no4" 			style="width: 150px" readonly></input>
								<input type="hidden" 	class="form-control" 	id="txt_doc_gubun4" 		name="doc_gubun4" 		style="width: 150px" readonly></input>
								<button type="button" onclick="parent.pop_fn_DocName_View(1,3,'<%=GV_DOC_GUBUN_DEFAULT%>','')" id="btn_SearchProd" class="btn btn-info" style="margin-left:10px;float:left">
								    문서코드</button> 
				           	</td>
				        </tr>   
				               
				        <tr style="height: 40px; vertical-align: middle">
				            <td style="font-weight: 900; font-size:14px; text-align:left; vertical-align: middle">문서#5</td>
				            <td style="font-weight: 900; font-size:14px; text-align:left; vertical-align: middle">
								<input type="text" 	class="form-control" 	id="txt_docname5" 		name="docname5" 			style="width: 250px; float:left" readonly></input>
								<input type="hidden" 	class="form-control" 	id="txt_doccode5" 		name="doccode5" 			style="width: 150px" readonly></input>
								<input type="hidden" 	class="form-control" 	id="txt_rev_no5" 		name="rev_no5" 			style="width: 150px" readonly></input>
								<input type="hidden" 	class="form-control" 	id="txt_doc_gubun5" 	name="doc_gubun5" 		style="width: 150px" readonly></input>
								<button type="button" onclick="parent.pop_fn_DocName_View(1,4,'<%=GV_DOC_GUBUN_DEFAULT%>','')" id="btn_SearchProd" class="btn btn-info" style="margin-left:10px;float:left">
								    문서코드</button> 
				           	</td>
				        </tr>   
			    	</tbody>
    	
	        	</table>
	        	</td>
	            <td style="width:50%; font-weight: 900; font-size:14px; text-align:left">	            
					<form id="upload_form" enctype="multipart/form-data" action="<%=Config.this_SERVER_path%>/hcp_EdmsServerServlet" method="post"> 
			        	<table style="width:100%;">
						        <tr style="height: 40px; vertical-align: middle"> 
						            <td style="width: 100%; font-weight: 900; font-size:14px; text-align:left; vertical-align: middle">
						            	<input type="file"  id="iDfilename1"  name="filename1"  multiple class="form-control" style="width: auto; border: solid 1px #cccccc;"/>
						            </td>
						        </tr>       
						        <tr style="height: 40px; vertical-align: middle">
						            <td style="font-weight: 900; font-size:14px; text-align:left; vertical-align: middle">
						            	<input type="file" id="iDfilename2"  name="filename2" class="form-control" style="width: auto; border: solid 1px #cccccc;"/>
						            </td>
						        </tr>   
						                 
						        <tr style="height: 40px; vertical-align: middle">
						            <td style="font-weight: 900; font-size:14px; text-align:left; vertical-align: middle">
						            	<input type="file" id="iDfilename3"  name="filename3" class="form-control" style="width: auto; border: solid 1px #cccccc;"/>
						            </td>
						        </tr>       
						        <tr style="height: 40px; vertical-align: middle">
						            <td style="font-weight: 900; font-size:14px; text-align:left; vertical-align: middle">
						            	<input type="file" id="iDfilename4"  name="filename4" class="form-control" style="width: auto; border: solid 1px #cccccc;"/>
						            </td>
						        </tr>   
						               
						        <tr style="height: 40px; vertical-align: middle">
						            <td style="font-weight: 900; font-size:14px; text-align:left; vertical-align: middle">
						            	<input type="file"   id="iDfilename5"  name="filename5" multiple class="form-control" style="width: auto; border: solid 1px #cccccc;"/>
						            </td>
						        </tr>   			
						        <tr style="height: 60px">
						            <td colspan="3" align="center">
						                <p>
						                <button id="btn_Save"  class="btn btn-info" style="width: 100px" onclick="submitForm(); return false; parent.$('#modalReport').hide().fadeIn(100);">등록</button>   
					                    <button id="btn_Canc"  class="btn btn-info" style="width: 100px" onclick="parent.$('#modalReport').hide();return false;">취소</button>
						                </p>
						            </td>
						        </tr>						        
			        	</table>
		        	</form>
	            </td>	            
	        </tr>	   	
	</table>