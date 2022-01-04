<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*,java.util.*,javax.servlet.http.*"%>
<%@ page import="mes.client.comm.*" %>
<%@ page import="mes.client.common.*" %>
<%@ page import="mes.client.guiComponents.*" %>
<%@ page import="mes.client.util.*" %>
<%@ page import="mes.client.conf.*" %>
<%@ page import="org.json.simple.*"%><%@ include file="/strings.jsp" %>
<!DOCTYPE html>
<!-- <html xmlns="http://www.w3.org/1999/xhtml"> -->
<!-- <head id="Head1" > -->
<%
	String loginID = session.getAttribute("login_id").toString();
	String member_key = session.getAttribute("member_key").toString();
	DoyosaeTableModel TableModel;

	String zhtml = "";
	Vector optCode =  null;
	Vector optName =  null;
	Vector sulbiJobVector = CommonData.getSulbiJobDataAll(member_key);
	
	String[] strColumnHead = {""};
	
	String  GV_SULBI_CD="", GV_REVISION_NO="", GV_SEQ_NO="", GV_SULBI_JOB="";

	if(request.getParameter("SeolbiCd")== null)
		GV_SULBI_CD="";
	else
		GV_SULBI_CD = request.getParameter("SeolbiCd");

	if(request.getParameter("SeqNo")== null)
		GV_SEQ_NO="";
	else
		GV_SEQ_NO = request.getParameter("SeqNo");

	if(request.getParameter("RevisionNo")== null)
		GV_REVISION_NO="";
	else
		GV_REVISION_NO = request.getParameter("RevisionNo");
	
	String param = GV_SULBI_CD + "|" + GV_SEQ_NO + "|";
	
	JSONObject jArray = new JSONObject();
	jArray.put( "sulbi_cd", GV_SULBI_CD);
	jArray.put( "seq_no", GV_SEQ_NO);
	jArray.put( "member_key", member_key);
	
    TableModel = new DoyosaeTableModel("M505S260100E214",jArray);
    int ColCount =TableModel.getColumnCount();CurrentPage jspPageName = new CurrentPage(request.getRequestURI());String JSPpage = jspPageName.GetJSP_FileName();
		
    // 데이터를 가져온다.
    Vector targetVector = (Vector)(TableModel.getVector().get(0));
    GV_SULBI_JOB = targetVector.get(1).toString();


    // 개정번호를 만든다.
    String revisionNumberStr = "";
    int revisionNoInt = 0;
    try {
		revisionNoInt = Integer.parseInt( targetVector.get(1).toString().trim() );
    } catch (Exception e) {
    	revisionNoInt = 0;
    }
    revisionNoInt = revisionNoInt + 1;
    revisionNumberStr = "" + revisionNoInt;
		
%>
<%-- <jsp:include page="../../Common/linkcss_js.jsp" flush="false"/> --%>
    
    <script type="text/javascript">
//     웹소켓 통신을 위해서 필요한 변수들 ---시작
	var M505S260100E112 = {
			PID:  "M505S260100E112", 
			totalcnt: 0,
			retnValue: 999,
			colcnt: 0,
			colname: ["","","",""], //insert, Update, Delete 문장을 처리할 때는 사용되지않음
			data: []
	};  
	
	var SQL_Param = {
			PID:  "M505S260100E112", 
			excute: "queryProcess",
			stream: "N",
			param: ""
	};
	var GV_RECV_DATA = "";	//웹소켓 onMessage(event)들어온 데이터를 받는 변수
//  웹소켓 통신을 위해서 필요한 변수들 ---끝	
    var detail_seq=1;

    
    $(document).ready(function () {
    	detail_seq=1;
    	
    	new SetSingleDate2("", "#txt_EndDate", 0);
        new SetSingleDate2("", "#txt_StartDate", 0);
        
        $('#txt_EndDate').val("<%=targetVector.get(4).toString()%>");
        $('#txt_StartDate').val("<%=targetVector.get(5).toString()%>");

      <%--   var today = new Date();
        var start_day = new Date("<%=targetVector.get(4).toString()%>");
        var end_day = new Date("<%=targetVector.get(5).toString()%>"); --%>

	    // 숫자만
	    $("input:text[numberOnly]").on("keyup", function() {
	        $(this).val($(this).val().replace(/[^0-9]/g,""));
	    });
	    // 비용이 바뀌었을 때 적용
	    $("#txt_Biyong").on("change",function(){
	    	BiyongChange(); 
	    });
        
    });
    
    function BiyongChange() {
    	if($('#txt_Biyong').val()=="" || $('#txt_Biyong').val()==null || $('#txt_Biyong').val()==undefined) {
    		return false;
    	} else {
    		
    		var Biyong = parseInt($("#txt_Biyong").val()); 
	    	
	    	
    		// 화면상
//     		var new_chulha_amount = Number($('#txt_chulha_cnt').val().replace(/,/gi,'')) * Number($('#txt_chulha_unit_price').val().replace(/,/gi,''));
    		 $('#txt_Biyong').val(Biyong.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ","));
    	}
        	
    }
	
	
	function SaveOderInfo() {  
	 	if ($('#txt_StartDate').val() > $('#txt_EndDate').val()){
        	alert("반출일자가 완료일자보다 길 수 없습니다.");
        	return false;
        }
	 	
		var work_complete_update_check = confirm("수정하시겠습니까?");
		if(work_complete_update_check == false)	return;
	 	
	 	var Biyong = $('#txt_Biyong').val().replace(/,/gi,'');
		//SetRecvData();



		var dataJson = new Object();

		
		dataJson.seolbi_code 	= $('#txt_SeolbiCode').val();
		dataJson.job_gubun 		= $("#select_JobGubun option:selected").val();
		dataJson.start_date 	= $("#txt_StartDate").val();
		dataJson.end_date 		= $('#txt_EndDate').val();
		dataJson.damdangja		= $('#txt_DamdangJa').val();
		dataJson.biyong 		= Biyong;
		dataJson.gigwan_name 	= $('#txt_GigwanName').val();
		dataJson.work_memo 		= $('#txt_WorkMemo').val();
		dataJson.bigo 			= $('#txt_Bigo').val();
		dataJson.seq_no 		= $('#txt_SeqNo').val();
		dataJson.member_key		= '<%=member_key%>';

		var JSONparam = JSON.stringify(dataJson); // JSON Object전송을 위해 문자열형태로 바꿔줌(stringify)
		SendTojsp(JSONparam, SQL_Param.PID);




	}

	function SendTojsp(bomdata, pid){
		
	    $.ajax({
	         type: "POST",
	         dataType: "json", // Ajax로 json타입으로 보낸다.
	     	 url: "<%=Config.this_SERVER_path%>/Contents/CommonView/insert_update_delete_json.jsp", // insert_update_delete_json.jsp로 연결
	     	 data:  {"bomdata" : bomdata, "pid" : pid },
	         beforeSend: function () {
//	         	 alert(bomdata);
	         },
	         
	         success: function (html) {	 
	        	 if(html>-1){
	        		heneSwal.success('정보 수정에 성공하였습니다.');
	        	   	parent.fn_MainInfo_List();
	                parent.$("#ReportNote").children().remove();
	         		fn_DetailInfo_List();
	         		$('#modalReport').modal('hide');
	         	}
	        	 else{
	        		 heneSwal.error('정보 수정에 실패하였습니다.'); 
	        	 }
	         },
	         error: function (xhr, option, error) {

	         }
	     });		
	} 
	
    function fn_CommonPopupModal(sUrl, name, w, h) { // url, name, width, height, 기타 속성(생략해도 무방)     	
        var popupWin = window.showModalDialog(sUrl, name, 'dialogWidth:' + w + 'px; dialogHeight:' + h 
                + 'px; center:yes; help:no; status:no; resizable:no; scroll:yes; toolbar :no;');
    	if(typeof(popupWin)=="undefine")
    		popupWin = window.returnValue;
		return popupWin;
    }  
    
    function SetCustName_code(name, code, rev){
    	alert(code);
		$('#txt_custname').val(name);
		$('#txt_custcode').val(code);
		$('#txt_cust_rev').val(rev);

    	alert(code);
		
    }
    
    function SetCustProjectInfo(cust_cd, cust_nm, project_name, cust_pono, prod_cd, product_nm, cust_rev, projrctCnt){
		$('#txt_projrctName').val(project_name);
		$('#txt_custname').val(cust_nm);
		$('#txt_projrctCnt').val(projrctCnt);
		
		$('#txt_custcode').val(cust_cd);
		$('#txt_cust_rev').val(cust_rev);
		$('#txt_cust_poNo').val(cust_pono);
		
    }
    function SetProductName_code(name, code, rev){

    	var len = $("#product_tbody tr").length-1;		
		var trInput = $($("#product_tbody tr")[len]).find(":input")
		trInput.eq(1).val(name);
		trInput.eq(3).val(code);
		trInput.eq(4).val(rev);
    }
    </script>

<!-- <form name="form1S909S050101" method="post" enctype="multipart/form-data" action="">  -->
   <table class="table table-bordered" style="width: 100%; margin: 0 auto; align:left">
   	<tr>   
   	
		<td style="width: 70%;">
   			<table class="table table-bordered" style="width: 100%; margin: 0 auto; align:left">
		        <tr style="background-color: #fff;">
		            <td style=" font-weight: 900; font-size:14px; text-align:left">설비코드</td>
		            <td style=" font-weight: 900; font-size:14px; text-align:left" >
						<input type="text" class="form-control" id="txt_SeolbiCode" style="width: 150px; float:left" 
								value="<%=targetVector.get(0).toString()%>" readonly />
						<input type="hidden" class="form-control" id="txt_SeqNo" style="width: 120px" value="<%=GV_SEQ_NO%>" readonly />
								
		           	</td>
		            <td style=" font-weight: 900; font-size:14px; text-align:left">업무구분</td>
		            <td >
						<select class="form-control" id="select_JobGubun" style="width: 150px">
			            	<%	optCode =  (Vector)sulbiJobVector.get(0);%>
			                <%	optName =  (Vector)sulbiJobVector.get(1);%>
			                <%for(int i=1; i<optName.size();i++){ %>
								<option value='<%=optCode.get(i).toString()%>' 
									<%=GV_SULBI_JOB.equals(optCode.get(i).toString()) ? "selected" : "" %> >
									<%=optName.get(i).toString()%></option>
							<%} %>
						</select>
		            </td>
		        </tr>
		        
		        <tr style="background-color: #fff" >
		            <td style=" font-weight: 900; font-size:14px; text-align:left" >기관명</td>
		            <td  colspan="3"> 
		            	<input type="text" data-date-format="yyyy-mm-dd" id="txt_GigwanName" class="form-control" style="width: 400px; border: solid 1px #cccccc;" 
			            		value="<%=targetVector.get(2).toString()%>"  />
		            	</td>		        
		        </tr>

		        <tr style="background-color: #fff" >
		            <td style=" font-weight: 900; font-size:14px; text-align:left" colspan="4">수리내용</td>
		        </tr>
		        <tr>
		            <td colspan="6">
		            	<textarea class="form-control" id="txt_WorkMemo"  style="cols:10;rows:4;resize: none;" ><%=targetVector.get(3).toString() %></textarea>
		            </td>		           
		        </tr>

				<tr style="background-color: #fff;">
		            <td style=" font-weight: 900; font-size:14px; text-align:left">반출일자</td>
		            <td >
		            	<input type="text" data-date-format="yyyy-mm-dd" id="txt_StartDate" class="form-control" style="width: 150px; border: solid 1px #cccccc;"
			            		value="<%=targetVector.get(4).toString()%>"  />
		            </td>
		            <td style=" font-weight: 900; font-size:14px; text-align:left">완료일자</td>
		            <td> 
		            	<input type="text" data-date-format="yyyy-mm-dd" id="txt_EndDate" class="form-control" style="width: 150px; border: solid 1px #cccccc;"
			            		value="<%=targetVector.get(5).toString()%>"  />
		            </td>		        
		        </tr>

		        <tr style="background-color: #fff; ">
		         	<td style=" font-weight: 900; font-size:14px; text-align:left">담당자</td>
		            <td>
		            	<input type="text"  id="txt_DamdangJa" class="form-control" style="width: 150px; border: solid 1px #cccccc; vertical-align: middle;"
			            		value="<%=targetVector.get(6).toString()%>"  />
		            </td>
		            <td style=" font-weight: 900; font-size:14px; text-align:left" >비용</td>
		            <td  colspan="3"> 
		            	<input type="text"  id="txt_Biyong" numberOnly class="form-control" style="width: 150px; border: solid 1px #cccccc; vertical-align: middle;"
			            		value="<%=targetVector.get(7).toString()%>"  />
		            </td>		           
		        </tr>
		        
		        <tr style="background-color: #fff" >
		            <td style=" font-weight: 900; font-size:14px; text-align:left" colspan="6">비고</td>
		        </tr>
		        <tr>
		            <td colspan="6">
		            	<textarea class="form-control" id="txt_Bigo"  style="cols:10;rows:4;resize: none;" ><%=targetVector.get(8).toString() %></textarea>
		            </td>		           
		        </tr>
		        
        	</table>
        </td>
	</tr>
	
    <tr style="height: 60px">
        <td align="center" colspan="2">
            <p>
            	<button id="btn_Save"  class="btn btn-info" style="width: 100px" onclick="SaveOderInfo();">저장</button>
                <button id="btn_Canc"  class="btn btn-info" style="width: 100px" onclick="$('#modalReport').modal('hide');">취소</button>
            </p>
        </td>
    </tr>
  </table>
<!-- </form>  -->
