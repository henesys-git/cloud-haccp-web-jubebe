<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*,java.util.*,javax.servlet.http.*"%>
<%@ page import="mes.client.comm.*" %>
<%@ page import="mes.client.common.*" %>
<%@ page import="mes.client.guiComponents.*" %>
<%@ page import="mes.client.util.*" %>
<%@ page import="mes.client.conf.*" %>
<!DOCTYPE html>
<!-- <html xmlns="http://www.w3.org/1999/xhtml"> -->
<!-- <head id="Head1" > -->
<%
	String loginID = session.getAttribute("login_id").toString();
	String member_key = session.getAttribute("member_key").toString();

	DoyosaeTableModel TableModel;	
	String zhtml = "";
	

	String[] strColumnHead = {"", "", "", "", "", "" };
	
	String GV_PROD_CD="", GV_PROD_CD_REV="", GV_PRODUCT_NM="", GV_CHECKLIST_CD="",GV_CHECKLIST_CD_REV, GV_CHECK_NOTE="", GV_CHECKLIST_SEQ="", GV_STANDARD_GUIDE="",
			GV_STANDARD_VALUE="", GV_ITEM_DESC="", GV_ITEM_TYPE="", GV_ITEM_BIGO="", GV_CHECKGUBUN, GV_PIC_SEQ;

	if(request.getParameter("prod_cd")== null)
		GV_PROD_CD="";
	else
		GV_PROD_CD = request.getParameter("prod_cd");

	if(request.getParameter("prod_cd_rev")== null)
		GV_PROD_CD_REV="";
	else
		GV_PROD_CD_REV = request.getParameter("prod_cd_rev");
	
	if(request.getParameter("product_nm")== null)
		GV_PRODUCT_NM="";
	else
		GV_PRODUCT_NM = request.getParameter("product_nm");
		
	if(request.getParameter("check_note")== null)
		GV_CHECK_NOTE="";
	else
		GV_CHECK_NOTE = request.getParameter("check_note");
	
	if(request.getParameter("checklist_cd")== null)
		GV_CHECKLIST_CD="";
	else
		GV_CHECKLIST_CD = request.getParameter("checklist_cd");
	
	if(request.getParameter("checklist_cd_rev")== null)
		GV_CHECKLIST_CD_REV="";
	else
		GV_CHECKLIST_CD_REV = request.getParameter("checklist_cd_rev");
	
	if(request.getParameter("checklist_seq")== null)
		GV_CHECKLIST_SEQ="";
	else
		GV_CHECKLIST_SEQ = request.getParameter("checklist_seq");
	
	if(request.getParameter("standard_guide")== null)
		GV_STANDARD_GUIDE="";
	else
		GV_STANDARD_GUIDE = request.getParameter("standard_guide");
	
	if(request.getParameter("standard_value")== null)
		GV_STANDARD_VALUE="";
	else
		GV_STANDARD_VALUE = request.getParameter("standard_value");
	
	if(request.getParameter("item_desc")== null)
		GV_ITEM_DESC="";
	else
		GV_ITEM_DESC = request.getParameter("item_desc");
	
	if(request.getParameter("item_type")== null)
		GV_ITEM_TYPE="";
	else
		GV_ITEM_TYPE = request.getParameter("item_type");
	
	if(request.getParameter("item_bigo")== null)
		GV_ITEM_BIGO="";
	else
		GV_ITEM_BIGO = request.getParameter("item_bigo");
	

	if(request.getParameter("pic_seq")== null)
		GV_PIC_SEQ="";
	else
		GV_PIC_SEQ = request.getParameter("pic_seq");
	

	if(request.getParameter("CheckGubun")== null)
		GV_CHECKGUBUN="";
	else
		GV_CHECKGUBUN = request.getParameter("CheckGubun");
	

		
//    TableModel = new DoyosaeTableModel("M101S10000E214", strColumnHead, param); 
//    int ColCount =TableModel.getColumnCount();CurrentPage jspPageName = new CurrentPage(request.getRequestURI());String JSPpage = jspPageName.GetJSP_FileName();
	Vector optCode =  null; 
    Vector optName =  null;
// 	Vector CheckGubunVector = CommonData.getProductCheckGubun_Code();
	Vector check_gubunVector = CommonData.getChecklistGubun_Code(member_key);
%>
 
        
    <script type="text/javascript">
//     웹소켓 통신을 위해서 필요한 변수들 ---시작
	var M909S123100E103 = {
			PID: "M909S123100E103",  
			totalcnt: 0,
			retnValue: 999,
			colcnt: 0,
			colname: ["","","",""], //insert, Update, Delete 문장을 처리할 때는 사용되지않음
			data: []
	};  
	
	var SQL_Param = {
			PID: "M909S123100E103",
			excute: "queryProcess",
			stream: "N",
			param: + "|"
	};
	var GV_RECV_DATA = "";	//웹소켓 onMessage(event)들어온 데이터를 받는 변수
//  웹소켓 통신을 위해서 필요한 변수들 ---끝	

// 체크항목 분할변수
// 	var totItemInfo = "";
// 	var arrayItemInfo;
	
// 	var partItemCode;
// 	var partItemDesc;
// 	var partItemBigo;
// 	var partItemSeq;
// 	var partItemRevNo;

//     var docGubunCode = "";
//     var JOB_GUBUN = "";
    
	function SetRecvData(){
		
		if (confirm("정말 삭제하시겠습니까?") != true) {
			return;
		}
		
		DataPars(M909S123100E103, GV_RECV_DATA);
 		if(M909S123100E103.retnValue > 0)
 			alert('삭제 되었습니다.');
 		
 		
   		parent.fn_MainInfo_List();
 		parent.$('#modalReport').hide();
	}
	
	function SaveOderInfo() {

// 		if ($('#txt_checklist_cd').val().length < 1) {
// 			alert("문항코드를 입력하세요.");
// 			return;
// 		}

		var work_complete_delete_check = confirm("삭제하시겠습니까?");
		if(work_complete_delete_check == false)	return;

	    var vCheckGubun = $("#select_CheckGubunCode3").val();
		var WebSockData="";
   		var dataJson = new Object(); // jSON Object 선언 
   			dataJson.member_key = "<%=member_key%>";
			dataJson.CheckGubun = vCheckGubun;
			dataJson.PROD_CD = '<%=GV_PROD_CD%>';
			dataJson.PROD_CD_REV = '<%=GV_PROD_CD_REV%>';
			dataJson.PIC_SEQ = '<%=GV_PIC_SEQ%>';
			dataJson.revision_no = $('#txt_revision_no').val();
			dataJson.checklist_cd = $('#txt_checklist_cd').val();
			dataJson.CHECKLIST_CD_REV = '<%=GV_CHECKLIST_CD_REV%>';
			dataJson.checklist_seq = $('#txt_checklist_seq').val();
			dataJson.user_id = "<%=loginID%>";
     			
		
// 			SendTojsp(urlencode(params),SQL_Param.PID); 
			SendTojsp(JSON.stringify(dataJson), SQL_Param.PID); // 보내는 데이터묶음 하나일때 => Object하나만
		
	}
 
	function SendTojsp(bomdata, pid){		

	    $.ajax({
	         type: "POST",
	         dataType: "json", // Ajax로 json타입으로 보낸다.
	         url: "<%=Config.this_SERVER_path%>/Contents/CommonView/insert_update_delete_json.jsp", 
	         data:  "bomdata=" + bomdata + "&pid=" + pid,
	         beforeSend: function () {
	        	 
	         },	         
	         success: function (html) {
	        	 if(html>-1){
	        		heneSwal.success('정보 삭제에 성공하였습니다.');
	        	   	parent.fn_DetailInfo_List();
	                parent.$("#ReportNote").children().remove();
	                parent.$('#modalReport').modal('hide');
	         	}
	        	 else{
	        		 heneSwal.error('정보 삭제에 실패하였습니다.');	 
	        	 }
	         },
	         error: function (xhr, option, error) {

	         }
	     });		
	}
	
    $(document).ready(function () {
		$('#txt_code_name').val('<%=GV_PRODUCT_NM%>');
		$('#txt_checklist_cd').val('<%=GV_CHECKLIST_CD%>');
		$('#txt_check_note').val('<%=GV_CHECK_NOTE%>');
		$('#txt_checklist_seq').val('<%=GV_CHECKLIST_SEQ%>');
		$('#txt_standard_guide').val('<%=GV_STANDARD_GUIDE%>');
		$('#txt_standard_value').val('<%=GV_STANDARD_VALUE%>');
		$('#txt_item_desc').val('<%=GV_ITEM_DESC%>');
		$('#txt_item_type').val('<%=GV_ITEM_TYPE%>');
		$('#txt_item_bigo').val('<%=GV_ITEM_BIGO%>');
		

		
    	// 특정 로우를 선택하고 들어오면... 그 문항코드를 뿌려준다...
<%--     	$('#txt_checklist_cd').val("<%=GV_PROD_CD%>"); --%>

		new SetSingleDate2("","#txt_StartDate", 0);
		
        
//         $("#select_ItemCode option:eq(0)").prop("selected", true);
//         $($("select[id='select_status']")[1]).prop("selected", true);

    });


	function SetCodeBook(txt_code_cd,txt_code_value, txt_code_name,txt_revision_no){
		$('#txt_code_cd').val(txt_code_cd);
		$('#txt_code_value').val(txt_code_value);
		$('#txt_code_name').val(txt_code_name);
		$('#txt_revision_no').val(txt_revision_no);
		
	}
	
    </script>


   <table class="table table-hover" style="width: 100%; margin: 0 auto; align:left">
           <tr style="background-color: #fff; height: 40px">
            <td>검사구분</td>
            <td> </td>
            <td >
			    <select class="form-control" id="select_CheckGubunCode3" style="width: 120px" disabled>
<%-- 			    <%	optCode =  (Vector)CheckGubunVector.get(0);%> --%>
<%-- 			    <%	optName =  (Vector)CheckGubunVector.get(1);%> --%>
<%-- 			    <%for(int i=0; i<optName.size();i++){ %> --%>
<%-- 			    	<%if(GV_CHECKGUBUN.equals(optCode.get(i).toString())){ %>			    		 --%>
<%-- 				  		<option value='<%=optCode.get(i).toString()%>' selected><%=optName.get(i).toString()%></option> --%>
<%-- 				 	<%}  else{ %> --%>
<%-- 				  		<option value='<%=optCode.get(i).toString()%>'><%=optName.get(i).toString()%></option> --%>
<%-- 				  <%} %> --%>
<%-- 				<%} %> --%>
					<%optCode =  (Vector)check_gubunVector.get(0);%>
					<%optName =  (Vector)check_gubunVector.get(1);%>
					<%for(int i=0; i<optName.size();i++){ %>
					<%if(GV_CHECKGUBUN.equals(optCode.get(i).toString())){ %>	
						<option value='<%=optCode.get(i).toString()%>'><%=optName.get(i).toString()%></option>
						<%} %>
					<%} %>
				</select>
           	</td>
        </tr>
        
        <tr style="background-color: #fff; height: 40px">
            <td>제품명</td>
            <td> </td>
            <td>
            	<input type="text" class="form-control" id="txt_code_name" style="width: 70%; float:left"  readonly/>
<!--            	<input type="hidden" class="form-control" id="txt_code_value" style="width: 80%; float:left"  />
            	<input type="hidden" class="form-control" id="txt_code_cd" style="width: 80%; float:left"  />
            	<input type="hidden" class="form-control" id="txt_revision_no" style="width: 80%; float:left"  />
 	            	<button type="button" 	onclick="parent.pop_fn_CodeBook_View(1,'PROC')" id="btn_SearchPart"
	            	    class="form-control btn btn-info" style="width:30%;float:left;left-margin:5px">KUH구분검색</button>
            	<br>KUH관련 제품인경우 선택
 -->
           	</td>
        </tr>
        
         <tr style="background-color: #fff; height: 40px">
            <td>체크문항코드</td>
            <td> </td>
            <td >
            	<input type="text" class="form-control" id="txt_checklist_cd" style="width: 70%; float:left"  readonly/>
<!-- 	            	<button type="button" 	onclick="parent.pop_fn_CheckList_View(1,'PROCES')" id="btn_SearchPart" -->
<!-- 	            	    class="form-control btn btn-info" style="width:30%;float:left;left-margin:5px">체크문항검색</button> -->
           	</td>
        </tr>
               
        <tr style="background-color: #fff; height: 40px">
            <td>문항내용</td>
            <td> </td>
            <td >
            	<input type="text" class="form-control" id="txt_check_note" style="width: 200px; float:left"  readonly/>
           	</td>
        </tr>

        <tr style="background-color: #fff; height: 40px">
            <td>문항일련번호</td>
            <td> </td>
            <td >
            	<input type="text" class="form-control" id="txt_checklist_seq" style="width: 200px; float:left" readonly />
           	</td>
        </tr>

        <tr style="background-color: #fff; height: 40px">
            <td>표준절차</td>
            <td> </td>
            <td >
            	<input type="text" class="form-control" id="txt_standard_guide" style="width: 200px; float:left"  readonly/>
           	</td>
        </tr>
        
          <tr style="background-color: #fff; height: 40px">
            <td>표준설정값</td>
            <td> </td>
            <td >
            	<input type="text" class="form-control" id="txt_standard_value" style="width: 200px; float:left" readonly />
           	</td>
        </tr>

        <tr style="height: 40px">
            <td>항목코드/명</td>
            <td></td>
            <td >
            	<input type="hidden" class="form-control" id="txt_item_cd" style="width: 200px; float:left"  readonly/>
            	<input type="hidden" class="form-control" id="txt_item_seq" style="width: 200px; float:left"  />
            	<input type="hidden" class="form-control" id="txt_item_cd_rev" style="width: 200px; float:left"  />
            	<input type="text" class="form-control" id="txt_item_desc" style="width: 200px; float:left"  readonly/>
            </td>
        </tr>

        <tr style="height: 40px">
            <td>항목유형</td>
            <td></td>
            <td >
            	<input type="text" class="form-control" id="txt_item_type" style="width: 200px; float:left"  readonly/>
            	<div id="txt_html_tag"></div>
            </td>
        </tr>

        <tr style="height: 40px">
            <td>항목비고</td>
            <td></td>
            <td >
            	<input type="text" class="form-control" id="txt_item_bigo" style="width: 200px; float:left" readonly />
            </td>
        </tr>
        
        <tr style="background-color: #fff; height: 40px">
            <td>개정번호</td>
            <td> </td>
            <td ><input type="text" class="form-control" id="txt_revision_no" value="0" style="width: 200px; float:left" readonly />
           	</td>
        </tr>        
        <tr style="background-color: #fff; height: 40px">
            <td>적용시작일자</td>
            <td> </td>
            <td >
            	<input type="text" data-date-format="yyyy-mm-dd" id="txt_StartDate" class="form-control"
                	style="width: 70%; border: solid 1px #cccccc;" readonly/>            		
           	</td>
        </tr>

        <tr style="height: 60px">
            <td colspan="4" align="center">
                <p>
                	<button id="btn_Save"  class="btn btn-info" style="width: 100px" onclick="SaveOderInfo();">삭제</button>
                    <button id="btn_Canc"  class="btn btn-info" style="width: 100px" onclick="parent.$('#modalReport').hide();">취소</button>
                </p>
            </td>
        </tr>
    </table>

