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
	
//     Vector optCodeInfo =  null;
//     Vector optCodeSeq =  null;
//     Vector optCodeRevNo =  null;


	String[] strColumnHead = {"", "", "", "", "", "" };
	
	String GV_PROD_CD="", GV_PROD_CD_REV="", GV_CHECKGUBUN;

	if(request.getParameter("prod_cd")== null)
		GV_PROD_CD="";
	else
		GV_PROD_CD = request.getParameter("prod_cd");

	if(request.getParameter("prod_cd_rev")== null)
		GV_PROD_CD_REV="";
	else
		GV_PROD_CD_REV = request.getParameter("prod_cd_rev");

	
	if(request.getParameter("CheckGubun")== null)
		GV_CHECKGUBUN="";
	else
		GV_CHECKGUBUN = request.getParameter("CheckGubun");
	
	String param = GV_PROD_CD + "|";
		
//    TableModel = new DoyosaeTableModel("M101S10000E214", strColumnHead, param);
//    int ColCount =TableModel.getColumnCount();CurrentPage jspPageName = new CurrentPage(request.getRequestURI());String JSPpage = jspPageName.GetJSP_FileName();
// 	Vector optCode =  null; 
//     Vector optName =  null;
// 	Vector CheckGubunVector = CommonData.getProductCheckGubun_Code();	
	
	Vector optCode =  null;
    Vector optName =  null;
//     Vector check_gubunVector = CommonData.getChecklistGubun_Code(member_key);
	Vector check_gubunVector = CommonData.getChecklistGubun_PIN_SHIP_Code(member_key);
%>
         
    <script type="text/javascript">
//     웹소켓 통신을 위해서 필요한 변수들 ---시작
	var M909S123100E101 = {
			PID: "M909S123100E101",  
			totalcnt: 0,
			retnValue: 999,
			colcnt: 0,
			colname: ["","","",""], //insert, Update, Delete 문장을 처리할 때는 사용되지않음
			data: []
	};  
	
	var SQL_Param = {
			PID: "M909S123100E101",
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
    var vcheck_gubun=""; 
    
    var vTableS909S123170 = "";
	var TableS909S123170_info;
    var TableS909S123170_Row_Count;
    var TableS909S123170_Row_Index;
    
    $(document).ready(function () {
    	console.log('<%=check_gubunVector.get(0)%>');
    	console.log('<%=check_gubunVector.get(1)%>');
    	$('#txt_code_name').val('<%=GV_PROD_CD_REV%>');
		$('#txt_code_cd').val('<%=GV_PROD_CD%>');
		
		$("#select_CheckGubunCode1").on("change", function(){
	    	vcheck_gubun = $(this).val();
// 	    	Get_S101S030190();
	    });
	    vcheck_gubun = $("#select_CheckGubunCode1").val();
	    
		S909S123170_query();
		
		TableS909S123170_Row_Index = -1;
		
		new SetSingleDate2("", "#txt_StartDate", 0);
        var today = new Date();
        var fromday = new Date();

    });
    
    function S909S123170_query(){

		$.ajax({
            type: "POST",
            url: "<%=Config.this_SERVER_path%>/Contents/Business/M909/S909S123170.jsp", 
            data: "prod_cd=" + '<%=GV_PROD_CD%>'  + "&prod_cd_rev=" + '<%=GV_PROD_CD_REV%>',
            beforeSend: function () {
                $("#part_tbody").children().remove();
            },
            success: function (html) {           	 
      			$("#part_tbody").hide().html(html).fadeIn(100);
            },
            error: function (xhr, option, error) {
            }
        });
    }
    
	function SaveOderInfo() {
		TableS909S123170_info = vTableS909S123170.page.info();
     	TableS909S123170_Row_Count = TableS909S123170_info.recordsTotal;
     	
     	var jArray = new Array(); // JSON Array 선언

		if (vTableS909S123170.cell( 0, 6 ).data( )==undefined) {
			alert("체크문항검색을 클릭해서 체크문항을 추가하세요.");
			return;
		}
		
		for(var i=0; i<vTableS909S123170.rows().count(); i++){
	   		var dataJson = new Object(); // jSON Object 선언 
	   			dataJson.member_key = "<%=member_key%>";
				dataJson.user_id = "<%=loginID%>";
				dataJson.PROD_CD = '<%=GV_PROD_CD%>';
				dataJson.PROD_CD_REV = '<%=GV_PROD_CD_REV%>';
     			
				dataJson.checklist_cd = vTableS909S123170.cell( i, 5 ).data( ); // checklist_cd
				dataJson.checklist_cd_rev = vTableS909S123170.cell( i, 6 ).data( ); // checklist_cd_rev
				dataJson.checklist_seq = vTableS909S123170.cell( i, 0 ).data( ); // checklist_seq
				dataJson.PIC_KUH = $('#txt_PIC_KUH').val();	            
				dataJson.inspect_gubun = vTableS909S123170.cell( i, 13 ).data( ); // inspect_gubun
     			
				jArray.push(dataJson); // 데이터를 배열에 담는다.
		}
		
		var dataJsonMulti = new Object();
		dataJsonMulti.param = jArray; // Array를 다시 Object형태로 변환 {"param":{Array...}}

		var JSONparam = JSON.stringify(dataJsonMulti); // JSON Object전송을 위해 문자열형태로 바꿔줌(stringify)
		var chekrtn = confirm("등록하시겠습니까?"); 
		
		if(chekrtn){
		
			SendTojsp(JSONparam, SQL_Param.PID); // SendToJSP를 통해 ajax로 데이터(JSONObject,PID) 보냄
		}
	}
 
	function SendTojsp(bomdata, pid){		
	    $.ajax({
	         type: "POST",
	         dataType: "json", // Ajax로 json타입으로 보낸다.
	         url: "<%=Config.this_SERVER_path%>/Contents/CommonView/insert_update_delete_json.jsp", 
	         data:  "bomdata=" + bomdata + "&pid=" + pid,
	         beforeSend: function () {
//	         	 alert(bomdata);
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
		$('#txt_PIC_KUH').val(txt_code_name);
		$('#txt_revision_no').val(txt_revision_no);
	}
	
    function fn_Product_inspect_CheckList() { /* 파라메터 알맞게 조정 필요 */
    	//caller = 1 : modalFramePopup에서 호출"Contents/Business/M101/S101S030150.jsp"
    	//caller = 0 : 일반화면에서 호출
		if(vcheck_gubun == "IMPORT"){
				alert("원자재입고검사 체크리스트 등록은 수입검사체크리스트에서 등록하세요.")
			return false;
		}
		if(vcheck_gubun == "IMPORT2"){
			alert("부자재입고검사 체크리스트 등록은 수입검사체크리스트에서 등록하세요.")
		return false;
	}
    	if(vcheck_gubun=="ALL")
    		vcheck_gubun="";
    	
    	var modalContentUrl  = "<%=Config.this_SERVER_path%>/Contents/CommonView/CheckListView.jsp?prod_cd=<%=GV_PROD_CD%>" + "&check_gubun=" +vcheck_gubun;
    	var footer = "";
    	var title = "제품검사 체크리스트 조회";
    	var heneModal = new HenesysModal2(modalContentUrl, 'large', title, footer);
    	heneModal.open_modal();
    	return false;
     }
    
    </script>

	<div class="container-fluid">
   		<table class="table table-hover" style="width: 100%; margin: 0 auto; align:left">
	        <tr style="background-color: #fff; height: 40px">
	            <td>제품코드</td>
	            <td>
	            	<input type="text" class="form-control" id="txt_code_cd" style="width: 70%; float:left"  readonly/>
	            </td>
	        	<td>제품명</td>
	            <td>
	            	<input type="text" class="form-control" id="txt_code_name" style="width: 70%; float:left"  readonly/>
	            </td>
	        </tr>
	        <tr style="background-color: #fff; height: 40px">
	            <td>검사구분</td>
				<td>
			    	<select class="form-control" id="select_CheckGubunCode1" style="width: 120px">
<%-- 				    	<%	optCode =  (Vector)CheckGubunVector.get(0);%> --%>
<%-- 				    	<%	optName =  (Vector)CheckGubunVector.get(1);%> --%>
<%-- 				    	<%for(int i=0; i<optName.size();i++){ %> --%>
<%-- 				    		<%if(GV_CHECKGUBUN.equals(optCode.get(i).toString())){ %>			    		 --%>
<%-- 						  		<option value='<%=optCode.get(i).toString()%>' selected><%=optName.get(i).toString()%></option> --%>
<%-- 						 	<%}  else{ %> --%>
<%-- 						  		<option value='<%=optCode.get(i).toString()%>'><%=optName.get(i).toString()%></option> --%>
<%-- 						  <%} %> --%>
<%-- 						<%} %> --%>
						<%optCode =  (Vector)check_gubunVector.get(0);%>
						<%optName =  (Vector)check_gubunVector.get(1);%>
						<%for(int i=0; i<optName.size();i++){ %>
<%-- 						<%if(GV_CHECKGUBUN.equals(optCode.get(i).toString())){ %>	 --%>
						<option value='<%=optCode.get(i).toString()%>'><%=optName.get(i).toString()%></option>
							<%} %>
<%-- 						<%} %>		 --%>
					</select>
				</td>
<!-- 	        	<td>KUH 문항구분</td> -->
				<td >
            		<input type="hidden" class="form-control" id="txt_PIC_KUH" style="width: 70%; float:left"  readonly/>
<!-- 	            	<button type="button" 	onclick="parent.pop_fn_CodeBook_View(1,'PIC_KUH')" id="btn_SearchPart" -->
<!-- 	            	    class="form-control btn btn-info" style="width:30%;float:left;left-margin:5px">KUH구분검색</button> -->
<!--             		<br>KUH관련 제품인경우 선택 -->
				</td>
	        </tr>
	    </table>
	    <table class="table" style="width: 100%; margin: 0 ; align:right" id="checklistbutton">	               
	        <tr>
	            <td align="right">
	                <button type="button" 	onclick="fn_Product_inspect_CheckList()" id="btn_SearchPart" class="btn btn-info" style="float:right;">체크문항검색</button></td>
			</tr>
	    </table>
<!-- 	    <table class="table" style="width: 100%; margin: 0 ; align:right" id="checklistbutton">	                -->
<!-- 	        <tr> -->
<!-- 	            <td align="left"> -->
<!-- 	                <button type="button" 	onclick="parent.pop_fn_CheckList_View(1,'FPRODCT')" id="btn_SearchPart" class="btn btn-info" style="float:right;">출하체크문항검색</button></td> -->
<!-- 	        </tr> -->
<!-- 	    </table> -->
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























<!--    <table class="table table-hover" style="width: 100%; margin: 0 auto; align:left"> -->
<!--            <tr style="background-color: #fff; height: 40px"> -->
<!--             <td>검사구분</td> -->
<!--             <td> </td> -->
<!--             <td > -->
<!-- 			    <select class="form-control" id="select_CheckGubunCode" style="width: 120px" disabled> -->
<%-- 				    <%	optCode =  (Vector)CheckGubunVector.get(0);%> --%>
<%-- 				    <%	optName =  (Vector)CheckGubunVector.get(1);%> --%>
<%-- 				    <%for(int i=0; i<optName.size();i++){ %> --%>
<%-- 				    	<%if(GV_CHECKGUBUN.equals(optCode.get(i).toString())){ %>			    		 --%>
<%-- 					  		<option value='<%=optCode.get(i).toString()%>' selected><%=optName.get(i).toString()%></option> --%>
<%-- 					 	<%}  else{ %> --%>
<%-- 					  		<option value='<%=optCode.get(i).toString()%>'><%=optName.get(i).toString()%></option> --%>
<%-- 					  <%} %> --%>
<%-- 					<%} %> --%>
<!-- 				</select> -->
<!--            	</td> -->
<!--         </tr> -->
        
<!--         <tr style="background-color: #fff; height: 40px"> -->
<!--             <td>KUH 문항구분</td> -->
<!--             <td> </td> -->
<!--             <td > -->
<!--             	<input type="text" class="form-control" id="txt_PIC_KUH" style="width: 70%; float:left"  readonly/> -->
<!--             	<input type="hidden" class="form-control" id="txt_code_value" style="width: 80%; float:left"  /> -->
<!--             	<input type="hidden" class="form-control" id="txt_code_cd" style="width: 80%; float:left"  /> -->
<!--             	<input type="hidden" class="form-control" id="txt_revision_no" style="width: 80%; float:left"  /> -->
<!-- 	            	<button type="button" 	onclick="parent.pop_fn_CodeBook_View(1,'PIC_KUH')" id="btn_SearchPart" -->
<!-- 	            	    class="form-control btn btn-info" style="width:30%;float:left;left-margin:5px">KUH구분검색</button> -->
<!--             	<br>KUH관련 제품인경우 선택 -->
<!--            	</td> -->
<!--         </tr> -->
        
<!--          <tr style="background-color: #fff; height: 40px"> -->
<!--             <td>체크문항코드</td> -->
<!--             <td> </td> -->
<!--             <td > -->
<!--             	<input type="text" class="form-control" id="txt_checklist_cd" style="width: 70%; float:left"  readonly/> -->
<!-- 	            	<button type="button" 	onclick="parent.pop_fn_CheckList_View(1,'PRODCT')" id="btn_SearchPart" -->
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
        
<!--         <tr style="background-color: #fff; height: 40px"> -->
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
<!--         </tr> -->
        
<!--         <tr style="background-color: #fff; height: 40px"> -->
<!--             <td>적용시작일자</td> -->
<!--             <td> </td> -->
<!--             <td > -->
<!--             	<input type="text" data-date-format="yyyy-mm-dd" id="txt_StartDate" class="form-control" -->
<!--                 	style="width: 220px; border: solid 1px #cccccc;"/>            		 -->
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
