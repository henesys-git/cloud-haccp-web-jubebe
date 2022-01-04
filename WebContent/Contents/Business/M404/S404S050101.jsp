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
	String zhtml = "";

	String  GV_JSPPAGE="",GV_NUM_GUBUN;
	

	if(request.getParameter("jspPage")== null)
		GV_JSPPAGE="";
	else
		GV_JSPPAGE = request.getParameter("jspPage");

	if(request.getParameter("num_gubun")== null)
		GV_NUM_GUBUN="";
	else
		GV_NUM_GUBUN = request.getParameter("num_gubun");
	
	String loginID = session.getAttribute("login_id").toString();
		
%>
<%-- <jsp:include page="../../Common/linkcss_js.jsp" flush="false"/> --%>
    
    <script type="text/javascript">
//     웹소켓 통신을 위해서 필요한 변수들 ---시작
	var M101S020100E101 = {
			PID:  "M101S020100E101", 
			totalcnt: 0,
			retnValue: 999,
			colcnt: 0,
			colname: ["","","",""], //insert, Update, Delete 문장을 처리할 때는 사용되지않음
			data: []
	};  
	
	var SQL_Param = {
			PID:  "M101S020100E101", 
			excute: "queryProcess",
			stream: "N",
			param: ""
	};
	var GV_RECV_DATA = "";	//웹소켓 onMessage(event)들어온 데이터를 받는 변수
//  웹소켓 통신을 위해서 필요한 변수들 ---끝	
    var detail_seq=1;

    
    $(document).ready(function () {
    	detail_seq=1;
    	
        $("#dateOrder").datepicker({
        	format: 'yyyy-mm-dd',
        	autoclose: true,
        	language: 'ko'
        });
        $('#dateDelevery').datepicker({
        	format: 'yyyy-mm-dd',
        	autoclose: true,
        	language: 'ko'
        });
        var today = new Date();
        var fromday = new Date();
        fromday.setDate(today.getDate());
        

        $('#dateOrder').datepicker('update', fromday);
        $('#dateDelevery').datepicker('update', today);
        
//         $("#select_status option:eq(1)").prop("selected", true);
//         $($("select[id='select_status']")[1]).prop("selected", true);

// 	    $("#select_status").on("change", function(){
// 	    	WORK_STATUS = $(this).val();
// 	    });

		$('#txt_detail_seq').val(detail_seq);	    
	    
	    $("#btn_plus").click(function(){ 
	    	fn_plus_body(); 
	    }); 
	    $("#btn_mius").click(function(){ 
	    	fn_mius_body(); 
	    }); 
	    
    });
	
	function SetRecvData(){
		DataPars(M101S020100E101,GV_RECV_DATA);  		
   		parent.fn_MainInfo_List();
 		parent.$('#modalReport').hide();
	}
	
	function SaveOderInfo() {        
		var WebSockData="";
		var len = $("#product_tbody tr").length;
		
		var jArray = new Array();
        for(var i=0; i<detail_seq;i++){
        	var dataJson = new Object();
    		var trInput = $($("#product_tbody tr")[i]).find(":input")
			<%-- parmHead += '<%=GV_JSPPAGE%>' 				+ "|" 
						+ '<%=loginID%>' 				+ "|" 
						+ '<%=GV_NUM_GUBUN%>' 			+ "|" 
    					+ trInput.eq(0).val() 			+ "|"	//주문상세번호
            			+ $('#txt_projrctName').val()	+ "|"
			            + $('#txt_custcode').val() 		+ "|"
			            + $('#txt_cust_rev').val() 		+ "|"
			            + $('#dateOrder').val() 		+ "|"
			            + $('#dateDelevery').val() 		+ "|"
			            + $('#txt_productSerialNo').val() 	+ "|"
			            + $('#txt_jumunCount').val() 	+ "|"
			            + $('#txt_cust_poNo').val() 	+ "|"
			            + $('#txt_bigo').val() 			+ "|"
    					+ trInput.eq(3).val() 			+ "|"	//제품코드
    					+ trInput.eq(4).val() 			+ "|"	//prod_rev
    					+ trInput.eq(5).val() 			+ "|"	//LOT No
    					+ trInput.eq(6).val() 			+ "|"	//LOT수량
            			+ $('#txt_projrctCnt').val()	+ "|"
						+ '<%=Config.DATATOKEN %>' 	; --%>
    		dataJson.jsp_page 			= '<%=GV_JSPPAGE%>';
    		dataJson.login_id			= '<%=loginID%>';	
    		dataJson.num_gubun			= '<%=GV_NUM_GUBUN%>';
    		dataJson.order_detail		= trInput.eq(0).val();
    		dataJson.projrct_name		= $('#txt_projrctName').val();
    		dataJson.cust_code			= $('#txt_custcode').val();
    		dataJson.cust_rev 			= $('#txt_cust_rev').val();
    		dataJson.date_order			= $('#dateOrder').val();
    		dataJson.date_delevery		= $('#dateDelevery').val();
    		dataJson.product_serial_no	= $('#txt_productSerialNo').val();	
    		dataJson.jumun_count		= $('#txt_jumunCount').val();	
    		dataJson.cust_poNo			= $('#txt_cust_poNo').val();	
    		dataJson.bigo				= $('#txt_bigo').val();	
    		dataJson.prod_cd			= trInput.eq(3).val();	
    		dataJson.prod_rev			= trInput.eq(4).val();	
    		dataJson.lot_no				= trInput.eq(5).val();	
    		dataJson.lot_count			= trInput.eq(6).val();	
    		dataJson.projrct_cnt		= $('#txt_projrctCnt').val();
    			
    		jArray.push(dataJson);
    			
        }

		//SQL_Param.param = parmHead ;
		var dataJsonMulti = new Object();
 		dataJsonMulti.param = jArray; // Array를 다시 Object형태로 변환 {"param":{Array...}}

		var JSONparam = JSON.stringify(dataJsonMulti); // JSON Object전송을 위해 문자열형태로 바꿔줌(stringify)
		SendTojsp(JSONparam, SQL_Param.PID);

		SendTojsp(urlencode(SQL_Param.param),SQL_Param.PID);
	}
 
	function SendTojsp(bomdata, pid){
		
	    $.ajax({
	         type: "POST",
	         dataType: "json", // Ajax로 json타입으로 보낸다.
	         url: "<%=Config.this_SERVER_path%>/Contents/CommonView/insert_update_delete_json.jsp", 
	         data:  {"bomdata" : bomdata, "pid" : pid },
	         beforeSend: function () {
//	         	 alert(bomdata);
	         },	         
	         success: function (html) {
	        	 if(html>-1){
	        	   	parent.fn_MainInfo_List();
	                parent.$("#ReportNote").children().remove();
	         		parent.$('#modalReport').hide();
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
		$('#txt_CustName').val(name);
		$('#txt_custcode').val(code);
		$('#txt_cust_rev').val(rev);
		
		
    }
    
    function SetCustProjectInfo(cust_cd, cust_nm,project_name,cust_pono,prod_cd, product_nm,cust_rev,projrctCnt){
		$('#txt_projrctName').val(project_name);
		$('#txt_CustName').val(cust_nm);
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
    
    function fn_plus_body(){
    	if($("#product_tbody tr").length > 4){
    		detail_seq = 5
    	}
    	else{
	    	var TrHtml="";
			TrHtml	=  "<tr style='height: 40px; vertical-align: middle'>"			            
			TrHtml	+= "	<td style='font-weight: 900; font-size:14px; text-align:left; vertical-align: middle'>"
			TrHtml	+= "	<input type='text' class='form-control' id='txt_detail_seq' style='width: 40px; float:left' readonly></input>"
			TrHtml	+= "	</td>"
	    	TrHtml	+= "	<td style='font-weight: 900; font-size:14px; text-align:left; vertical-align: middle'>"
	    	TrHtml	+= "		<input type='text' class='form-control' id='txt_ProductName' style='width: 180px; float:left' readonly></input>"
	    	TrHtml	+= "		<button type='button' onclick=\"parent.pop_fn_ProductName_View(1,'ALL')\" id='btn_SearchProd' class='btn btn-info' style='width: 50px;float:left'>검색</button> "
	   		TrHtml	+= "	</td>"
	     	TrHtml	+= "	<td style='font-weight: 900; font-size:14px; text-align:left; vertical-align: middle'>"
	    	TrHtml	+= "		<input type='text' class='form-control' id='txt_Productcode' style='width: 120px' readonly></input>"
		    TrHtml	+= "		<input type='hidden' class='form-control' id='txt_prod_rev' style='width: 120px' readonly></input>"
	      	TrHtml	+= "    </td>"
	       	TrHtml	+= "	<td>"
	        TrHtml	+= "      	<input type='text'  id='txt_LOTNo' class='form-control' style='width: 80px; border: solid 1px #cccccc; vertical-align: middle;'/>"
	        TrHtml	+= "	</td>"
	        TrHtml	+= "	<td>"
	        TrHtml	+= "      	<input type='text'  id='txt_LOTCount' class='form-control' style='width: 80px; border: solid 1px #cccccc; vertical-align: middle;'/>"
	        TrHtml	+= "	</td>"
	        TrHtml	+= "	<td>"
	        TrHtml	+= "	</td>"
	        TrHtml	+= "</tr>"
	    	$('#product_tbody').append(TrHtml);
			var trInput = $($("#product_tbody tr")[detail_seq]).find(":input")
			trInput.eq(0).val(++detail_seq);
    	}
// 		trInput.eq(3).val(code);
    }    

    
    function fn_mius_body(){  	
    	var len = $("#product_tbody tr").length-1;
		if(len>0)
    		$("#product_tbody tr")[len].remove();
		;
		if((detail_seq--)<1)
			detail_seq = 1;
    }   
    </script>

   <table class="table " style="width: 100%; margin: 0 auto; align:left">
   	<tr>   
		<td style="width: 47%;">
   			<table class="table table-bordered" style="width: 100%; margin: 0 auto; align:left">
		        <tr style="background-color: #fff;">
		            <td style="width: 15%%; font-weight: 900; font-size:14px; text-align:left">주문명</td>
		            <td style="width: 35%; font-weight: 900; font-size:14px; text-align:left">
						<input type="text" class="form-control" id="txt_projrctName" style="width: 150px; float:left"  />
						<button type="button" onclick="parent.pop_fn_projrctName_View(1)" id="btn_SearchpROJECT" class="btn btn-info" style="float:left">
						    검색</button> 
		           	</td>
		            <td style="width: 15%; font-weight: 900; font-size:14px; text-align:left">고객사</td>
		            <td style="width: 35%; font-weight: 900; font-size:14px; text-align:left">
						<input type="text" class="form-control" id="txt_CustName" style="width: 150px; float:left"  />
						<input type="hidden" class="form-control" id="txt_custcode" style="width: 120px" />
						<input type="hidden" class="form-control" id="txt_cust_rev" style="width: 120px" />
						<button type="button" onclick="parent.pop_fn_CustName_View(1,'O')" id="btn_SearchCust" class="btn btn-info" style="float:left">
						    검색</button> 
		           	</td>
		        </tr>

				<tr style="background-color: #fff;">
		            <td style=" font-weight: 900; font-size:14px; text-align:left">주문일자</td>
		            <td ><input type="text" data-date-format="yyyy-mm-dd" id="dateOrder" class="form-control"
		                                        style="width: 150px; border: solid 1px #cccccc;"/></td>
		            <td style=" font-weight: 900; font-size:14px; text-align:left">납기일자</td>
		            <td> <input type="text" data-date-format="yyyy-mm-dd" id="dateDelevery" class="form-control" style="width: 150px; border: solid 1px #cccccc;"/></td>
		        
		        </tr>

		        <tr style="background-color: #fff; ">
		            <td style=" font-weight: 900; font-size:14px; text-align:left">시리얼번호</td>
		            <td> <input type="text"  id="txt_productSerialNo" class="form-control" style="width: 150px; border: solid 1px #cccccc; vertical-align: middle;"/></td>
		            <td style=" font-weight: 900; font-size:14px; text-align:left">고객사PoNo</td>
		            <td> <input type="text"  id="txt_cust_poNo" class="form-control" style="width: 150px; border: solid 1px #cccccc; vertical-align: middle;"/></td>
		        </tr>
		
		        <tr style="background-color: #fff; ">
		         	<td>프로젝트수량</td>
		            <td><input type="text"  id="txt_projrctCnt" class="form-control" style="width: 150px; border: solid 1px #cccccc; vertical-align: middle;"/></td>
		            <td style=" font-weight: 900; font-size:14px; text-align:left">주문 수량</td>
		            <td> <input type="text"  id="txt_jumunCount" class="form-control" style="width: 150px; border: solid 1px #cccccc; vertical-align: middle;"/></td>
		           
		        </tr>
		        <tr style="background-color: #fff" >
		            <td style=" font-weight: 900; font-size:14px; text-align:left" colspan="4">비고</td>
		        </tr>
		        <tr>
		            <td colspan="4"><textarea class="form-control" id="txt_bigo"  style="cols:10;rows:4;resize: none;" ></textarea></td>
		           
		        </tr>
        	</table>
        </td>
		<td style="width: 53%">
	        <table class="table table-striped" style="width: 100%; margin: 0 auto; align:left">
	 
		        <tr style="vertical-align: middle">
		            <td style="width: 60px; font-weight: 900; font-size:14px; text-align:center; vertical-align: middle">#</td>
		            <td style="width: 280px; font-weight: 900; font-size:14px; text-align:center; vertical-align: middle">제품명</td>
		            <td style="width: 190px; font-weight: 900; font-size:14px; text-align:center; vertical-align: middle">제품코드</td>
		            <td style="width: 90px; font-weight: 900; font-size:14px; text-align:center; vertical-align: middle">LOT No</td>
		            <td style="width: 90px; font-weight: 900; font-size:14px; text-align:center; vertical-align: middle">LOT 수량</td>
		            <td style="width: 120px; font-weight: 900; font-size:14px; text-align:center; vertical-align: middle">
	                	<button alt="한줄 추가" id="btn_plus"  class="btn btn-info btn-sm" >+</button>
	                	<button alt="한줄 삭제" id="btn_mius"  class="btn btn-info btn-sm" >-</button></td>
		        </tr>
		        <tbody id="product_tbody">
			        <tr style="vertical-align: middle">			            
			        	<td style="font-weight: 900; font-size:14px; text-align:center; vertical-align: middle">
							<input type="text" class="form-control" id="txt_detail_seq" style="float:left" readonly></input>
						</td>
			            <td style="font-weight: 900; font-size:14px; text-align:center; vertical-align: middle">
							<input type="text" class="form-control" id="txt_ProductName" style="width: 180px; float:left" readonly></input>
							<button type="button" onclick="parent.pop_fn_ProductName_View(1,'ALL')" id="btn_SearchProd" class="btn btn-info" style="width: 50px;float:left">검색</button> 
			           	</td>
			            <td style="font-weight: 900; font-size:14px; text-align:center; vertical-align: middle">
							<input type="text" class="form-control" id="txt_Productcode" readonly></input>
							<input type="hidden" class="form-control" id="txt_prod_rev" readonly></input>
			           	</td>
			            <td style="font-weight: 900; font-size:14px; text-align:center; vertical-align: middle">
			            	<input type="text"  id="txt_LOTNo" class="form-control" style="border: solid 1px #cccccc; vertical-align: middle;"/>
			            </td>
			            <td style="font-weight: 900; font-size:14px; text-align:center; vertical-align: middle">
			            	<input type="text"  id="txt_LOTCount" class="form-control" style="border: solid 1px #cccccc; vertical-align: middle;"/>
			            </td>
			            <td>
			            </td>
			        </tr>
		        </tbody>
		    </table>
        </td>
		</tr>
        <tr style="height: 60px">
            <td align="center" colspan="2">
                <p>
                	<button id="btn_Save"  class="btn btn-info" style="width: 100px" onclick="SaveOderInfo();">저장</button>
                    <button id="btn_Canc"  class="btn btn-info" style="width: 100px" onclick="parent.$('#modalReport').hide();">취소</button>
                </p>
            </td>
        </tr>
    </table>
