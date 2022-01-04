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
	
    Vector optCodeInfo =  null;
    Vector optCodeSeq =  null;
    Vector optCodeRevNo =  null;

	String[] strColumnHead = {"", "", "", "", "", "" };
	
	String GV_PROC_CD="", GV_PROC_CD_REV="", GV_PROCESS_NM="",GV_CHECKLIST_CD="",GV_PROCESS_GUBUN="";

	if(request.getParameter("proc_cd")== null)
		GV_PROC_CD="";
	else
		GV_PROC_CD = request.getParameter("proc_cd");

	if(request.getParameter("proc_cd_rev")== null)
		GV_PROC_CD_REV="";
	else
		GV_PROC_CD_REV = request.getParameter("proc_cd_rev");
	
	if(request.getParameter("process_nm")== null)
		GV_PROCESS_NM="";
	else
		GV_PROCESS_NM = request.getParameter("process_nm");
	
	if(request.getParameter("checklist_cd")== null)
		GV_CHECKLIST_CD="";
	else
		GV_CHECKLIST_CD = request.getParameter("checklist_cd");
	
	if(request.getParameter("process_gubun")== null)
		GV_PROCESS_GUBUN="";
	else
		GV_PROCESS_GUBUN = request.getParameter("process_gubun");
	
	String param = GV_PROC_CD + "|";
		
//    TableModel = new DoyosaeTableModel("M101S10000E214", strColumnHead, param);
//    int ColCount =TableModel.getColumnCount();CurrentPage jspPageName = new CurrentPage(request.getRequestURI());String JSPpage = jspPageName.GetJSP_FileName();
		
%>
 
<%-- <jsp:include page="../../Common/linkcss_js.jsp" flush="false"/> --%>
        
    <script type="text/javascript">
//     웹소켓 통신을 위해서 필요한 변수들 ---시작
	var M909S122100E101 = {
			PID: "M909S122100E101",  
			totalcnt: 0,
			retnValue: 999,
			colcnt: 0,
			colname: ["","","",""], //insert, Update, Delete 문장을 처리할 때는 사용되지않음
			data: []
	};  
	
	var SQL_Param = {
			PID: "M909S122100E101",
			excute: "queryProcess",
			stream: "N",
			param: + "|"
	};
	var GV_RECV_DATA = "";	//웹소켓 onMessage(event)들어온 데이터를 받는 변수
//  웹소켓 통신을 위해서 필요한 변수들 ---끝	

// 체크항목 분할변수
	var totItemInfo = "";
	var arrayItemInfo;
	
	var partItemCode;
	var partItemDesc;
	var partItemBigo;
	var partItemSeq;
	var partItemRevNo;

    var docGubunCode = "";
    var JOB_GUBUN = "";
   
    var vTableS909S122170 = "";
	var TableS909S122170_info = "";
    var TableS909S122170_Row_Count = "";
    var TableS909S122170_Row_Index = "";
	
	$(document).ready(function () {
		
		console.log('<%=GV_PROC_CD%>');
		console.log(TableS909S122170_Row_Count);
		
		setTimeout(function(){
			$('#txt_code_name').val('<%=GV_PROCESS_NM%>');
			$('#txt_code_cd').val('<%=GV_PROC_CD%>');
			
			S909S122170_query();
			
			TableS909S122170_Row_Index = -1;
		
		},200);
	});
	
	function S909S122170_query(){

		$.ajax({
            type: "POST",
            url: "<%=Config.this_SERVER_path%>/Contents/Business/M909/S909S122170.jsp", 
            data: "proc_cd=" + '<%=GV_PROC_CD%>'  + "&proc_cd_rev=" + '<%=GV_PROC_CD_REV%>',
            beforeSend: function () {
                $("#part_tbody").children().remove();
            },
            success: function (html) {           	 
      			$("#part_tbody").hide().html(html).fadeIn(100);
    	        //TableS909S122170_info = vTableS909S122170.page.info();
   	      		//TableS909S122170_Row_Count = TableS909S122170_info.recordsTotal;
   	      		
            },
            error: function (xhr, option, error) {
            }
        });
    }

	
	function SaveOderInfo() {
		//TableS909S122170_info = vTableS909S122170.page.info();
     	//TableS909S122170_Row_Count = TableS909S122170_info.recordsTotal;
     	
     	var jArray = new Array(); // JSON Array 선언

		if (vTableS909S122170.cell( 0, 6 ).data( )==undefined) {
			alert("체크문항검색을 클릭해서 체크문항을 추가하세요.");
			return;
		}

		//for(var i=0; i<TableS909S122170_Row_Count; i++){
			for(var i=0; i<vTableS909S122170.rows().count(); i++){
	   		var dataJson = new Object(); // jSON Object 선언 
	   		dataJson.member_key = "<%=member_key%>";
			dataJson.user_id = "<%=loginID%>";
			dataJson.PROC_CD = '<%=GV_PROC_CD%>';
			dataJson.PROC_CD_REV = '<%=GV_PROC_CD_REV%>';
     			
			dataJson.checklist_cd = vTableS909S122170.cell( i, 5 ).data( ); // checklist_cd
			dataJson.checklist_cd_rev = vTableS909S122170.cell( i, 6 ).data( ); // checklist_cd_rev
			dataJson.checklist_seq = vTableS909S122170.cell( i, 0 ).data( ); // checklist_seq
			dataJson.PROCESS_GUBUN = '<%=GV_PROCESS_GUBUN%>';
     			
     		jArray.push(dataJson); // 데이터를 배열에 담는다.
		}
		console.log(TableS909S122170_Row_Count);
		console.log(vTableS909S122170.data());
		console.log(vTableS909S122170.row(0).data());
		console.log(vTableS909S122170.rows().count());
		//console.log(vTableS909S122170.row[0].data());
		//console.log(vTableS909S122170.row[1].data());
		console.log(jArray);
		
		var dataJsonMulti = new Object();
		dataJsonMulti.param = jArray; // Array를 다시 Object형태로 변환 {"param":{Array...}}
		
		var JSONparam = JSON.stringify(dataJsonMulti); // JSON Object전송을 위해 문자열형태로 바꿔줌(stringify)
		
		var chekrtn = confirm("등록하시겠습니까?"); 
		
		if(chekrtn){
		
			SendTojsp(JSONparam, SQL_Param.PID); // SendToJSP를 통해 ajax로 데이터(JSONObject,PID) 보냄
		}
		
    }
	

 
	function SendTojsp(bomdata, pid){		
		
		console.log(bomdata);
		console.log(pid);
		
	    $.ajax({
	         type: "POST",
	         dataType: "json", // Ajax로 json타입으로 보낸다.
	         url: "<%=Config.this_SERVER_path%>/Contents/CommonView/insert_update_delete_json.jsp", 
	         data:  "bomdata=" + bomdata + "&pid=" + pid,
	         beforeSend: function () {
	        	 
	         },	         
	         success: function (html) {
	        	 if(html>-1){
	        		heneSwal.success('정보 등록에 성공하였습니다.');
	        		parent.fn_DetailInfo_List();
	                parent.$("#ReportNote").children().remove();
	                $('#modalReport').modal('hide');
	         	}
	        	
	        	 else{
	        		heneSwal.error('정보 등록에 실패하였습니다.');
	        	 }
	         },
	         error: function (xhr, option, error) {

	         }
	     });		
	}
	
	function SetCodeBook(txt_code_cd,txt_code_value, txt_code_name,txt_revision_no){
		$('#txt_code_cd').val(txt_code_cd);
		$('#txt_code_value').val(txt_code_value);
		$('#txt_code_name').val(txt_code_name);
		$('#txt_revision_no').val(txt_revision_no);
		
	}
	
	function fn_Product_Checklist(caller,check_gubun) {
    	//caller = 1 : modalFramePopup에서 호출
    	//caller = 0 : 일반화면에서 호출
    	var modalContentUrl  = "<%=Config.this_SERVER_path%>/Contents/CommonView/CheckListView.jsp?caller="+caller 
    			+ "&check_gubun=" + check_gubun ;
    	var footer = "";
    	var title = "체크리스트 조회";
    	var heneModal = new HenesysModal2(modalContentUrl, 'large', title, footer);
    	heneModal.open_modal();
    	return false;
    }
	
	
    </script>

	<div class="container-fluid">
   		<table class="table table-hover" style="width: 100%; margin: 0 auto; align:left">
	        <tr style="background-color: #fff; height: 40px">
	            <td>공정코드</td>
	            <td>
	            	<input type="text" class="form-control" id="txt_code_cd" style="width: 70%; float:left"  readonly/>
	            </td>
	        	<td>공정명</td>
	            <td>
	            	<input type="text" class="form-control" id="txt_code_name" style="width: 70%; float:left"  readonly/>
	            </td>
	        </tr>
	    </table>
	    <table class="table" style="width: 100%; margin: 0 ; align:right" id="checklistbutton">	               
	        <tr>
	            <td align="left">
	               <%--  <button type="button" 	onclick="parent.pop_fn_CheckList_View(1,'<%=GV_PROCESS_GUBUN%>')" id="btn_SearchPart" class="btn btn-info" style="float:right;">체크문항검색</button> --%>
	               <button type="button" 	onclick="fn_Product_Checklist(1,'<%=GV_PROCESS_GUBUN%>')" id="btn_SearchPart" class="btn btn-info" style="float:right;">체크문항검색</button>
	               </td>
	        </tr>
	    </table>
		<div id="part_tbody"></div>
		<table class="table table-bordered " style="width: 100%; margin: 0 ; align:left" id="bom_table">	               
	        <tr>
	            <td align="center">
	                	<button id="btn_Save"  class="btn btn-info" style="width: 100px" onclick="SaveOderInfo();">저장</button>
                    	<button id="btn_Canc"  class="btn btn-info" style="width: 100px" onclick="$('#modalReport').modal('hide');">취소</button>
	            </td>
	        </tr>
	    </table>
	</div>

<!-- 	<table class="table table-hover" style="width: 100%; margin: 0 auto; align:left"> -->
<!--         <tr style="background-color: #fff; height: 40px"> -->
<!--             <td>공정명</td> -->
<!--             <td> </td> -->
<!--             <td> -->
<!--             	<input type="text" class="form-control" id="txt_code_name" style="width: 70%; float:left"  readonly/> -->
<!-- <!--            	<input type="hidden" class="form-control" id="txt_code_value" style="width: 80%; float:left"  /> -->
<!--             	<input type="hidden" class="form-control" id="txt_code_cd" style="width: 80%; float:left"  /> -->
<!--             	<input type="hidden" class="form-control" id="txt_revision_no" style="width: 80%; float:left"  /> -->
<!--  	            	<button type="button" 	onclick="parent.pop_fn_CodeBook_View(1,'PROC')" id="btn_SearchPart" -->
<!-- 	            	    class="form-control btn btn-info" style="width:30%;float:left;left-margin:5px">KUH구분검색</button> -->
<!--             	<br>KUH관련 제품인경우 선택 -->
<!--  -->
<!--            	</td> -->
<!--         </tr> -->
        
<!--          <tr style="background-color: #fff; height: 40px"> -->
<!--             <td>체크문항코드</td> -->
<!--             <td> </td> -->
<!--             <td > -->
<!--             	<input type="text" class="form-control" id="txt_checklist_cd" style="width: 70%; float:left"  readonly/> -->
<!-- 	            	<button type="button" 	onclick="parent.pop_fn_CheckList_View(1,'PROCES')" id="btn_SearchPart" -->
<!-- 	            	    class="form-control btn btn-info" style="width:30%;float:left;left-margin:5px">체크문항검색</button> -->
<!--            	</td> -->
<!--         </tr> -->
               
<!--         <tr style="background-color: #fff; height: 40px"> -->
<!--             <td>문항내용</td> -->
<!--             <td> </td> -->
<!--             <td > -->
<!--             	<input type="text" class="form-control" id="txt_check_note" style="width: 200px; float:left"  readonly/> -->
<!--            	</td> -->
<!--         </tr> -->

<!--         <tr style="background-color: #fff; height: 40px"> -->
<!--             <td>문항일련번호</td> -->
<!--             <td> </td> -->
<!--             <td > -->
<!--             	<input type="text" class="form-control" id="txt_checklist_seq" style="width: 200px; float:left" readonly /> -->
<!--            	</td> -->
<!--         </tr> -->

<!--         <tr style="background-color: #fff; height: 40px"> -->
<!--             <td>표준절차</td> -->
<!--             <td> </td> -->
<!--             <td > -->
<!--             	<input type="text" class="form-control" id="txt_standard_guide" style="width: 200px; float:left"  readonly/> -->
<!--            	</td> -->
<!--         </tr> -->
        
<!--           <tr style="background-color: #fff; height: 40px"> -->
<!--             <td>표준설정값</td> -->
<!--             <td> </td> -->
<!--             <td > -->
<!--             	<input type="text" class="form-control" id="txt_standard_value" style="width: 200px; float:left"  /> -->
<!--            	</td> -->
<!--         </tr> -->

<!--         <tr style="height: 40px"> -->
<!--             <td>항목코드/명</td> -->
<!--             <td></td> -->
<!--             <td > -->
<!--             	<input type="hidden" class="form-control" id="txt_item_cd" style="width: 200px; float:left"  readonly/> -->
<!--             	<input type="hidden" class="form-control" id="txt_item_seq" style="width: 200px; float:left"  /> -->
<!--             	<input type="hidden" class="form-control" id="txt_item_cd_rev" style="width: 200px; float:left"  /> -->
<!--             	<input type="text" class="form-control" id="txt_item_desc" style="width: 200px; float:left"  readonly/> -->
<!--             </td> -->
<!--         </tr> -->

<!--         <tr style="height: 40px"> -->
<!--             <td>항목유형</td> -->
<!--             <td></td> -->
<!--             <td > -->
<!--             	<input type="text" class="form-control" id="txt_item_type" style="width: 200px; float:left"  readonly/> -->
<!--             	<div id="txt_html_tag"></div> -->
<!--             </td> -->
<!--         </tr> -->

<!--         <tr style="height: 40px"> -->
<!--             <td>항목비고</td> -->
<!--             <td></td> -->
<!--             <td > -->
<!--             	<input type="text" class="form-control" id="txt_item_bigo" style="width: 200px; float:left"  /> -->
<!--             </td> -->
<!--         </tr> -->
        
<!--         <tr style="background-color: #fff; height: 40px"> -->
<!--             <td>개정번호</td> -->
<!--             <td> </td> -->
<!--             <td ><input type="text" class="form-control" id="txt_revision_no" value="0" style="width: 200px; float:left" readonly /> -->
<!--            	</td> -->
<!--         </tr>         -->
<!--         <tr style="background-color: #fff; height: 40px"> -->
<!--             <td>적용시작일자</td> -->
<!--             <td> </td> -->
<!--             <td > -->
<!--             	<input type="text" data-date-format="yyyy-mm-dd" id="txt_StartDate" class="form-control" -->
<!--                 	style="width: 70%; border: solid 1px #cccccc;"/>            		 -->
<!--            	</td> -->
<!--         </tr> -->

<!--         <tr style="height: 60px"> -->
<!--             <td colspan="4" align="center"> -->
<!--                 <p> -->
<!--                 	<button id="btn_Save"  class="btn btn-info" style="width: 100px" onclick="SaveOderInfo();">저장</button> -->
<!--                     <button id="btn_Canc"  class="btn btn-info" style="width: 100px" onclick="parent.$('#modalReport').hide();">취소</button> -->
<!--                 </p> -->
<!--             </td> -->
<!--         </tr> -->
<!--     </table> -->

