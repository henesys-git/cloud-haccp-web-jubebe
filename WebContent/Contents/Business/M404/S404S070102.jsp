<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*,java.util.*,javax.servlet.http.*"%>
<%@ page import="mes.client.comm.*" %>
<%@ page import="mes.client.common.*" %>
<%@ page import="mes.client.guiComponents.*" %>
<%@ page import="mes.client.util.*" %>
<%@ page import="mes.client.conf.*" %>
<%@ page import="org.json.simple.*"%><%@ include file="/strings.jsp" %>
<!DOCTYPE html>
<%
	DoyosaeTableModel TableModel;
	
	String[] strColumnHead 	= {"주문번호","주문상세번호", "고객사코드", "고객사명","주문일자","초품시리얼번호", "납기일자",  "프로젝트명","고객사PO번호",
			"초품코드","제품명", "주문수량","롯트번호", "롯트수량","비고","프로젝트수량"};
	int[] colOff 			= {1, 1, 1, 1, 1,  1,  1, 1,1,1,1,1,1,1,1};	//전체 넓이 번튼 3개:86%, 문서2개:90%, 문서뷰:94%, 챠트보기,문서등록91%;

	//챠트보기:4%,문서등록4%;문서View6%
	String RightButton[][]	= {{"off", "fn_Chart_View", rightbtnChartShow},{"off", "fn_Doc_Reg()", rightbtnDocSave},{"off", "file_real_name", rightbtnDocShow}};

	String  GV_ORDERNO, GV_JSPPAGE="",GV_NUM_GUBUN,GV_ORDERDETAIL, GV_LOTNO;

	if(request.getParameter("OrderNo")== null)
		GV_ORDERNO="";
	else
		GV_ORDERNO = request.getParameter("OrderNo");	

	if(request.getParameter("OrderDetail")== null)
		GV_ORDERDETAIL="";
	else
		GV_ORDERDETAIL = request.getParameter("OrderDetail");	

	if(request.getParameter("LotNo")== null)
		GV_LOTNO="";
	else
		GV_LOTNO = request.getParameter("LotNo");
	
	if(request.getParameter("jspPage")== null)
		GV_JSPPAGE="";
	else
		GV_JSPPAGE = request.getParameter("jspPage");
	
	String loginID = session.getAttribute("login_id").toString();
	String member_key = session.getAttribute("member_key").toString();
	
	String param =  GV_ORDERNO + "|"  ;
	
	JSONObject jArray = new JSONObject();
	jArray.put( "order_no", GV_ORDERNO);
	jArray.put( "order_detail_seq", GV_ORDERDETAIL);
	jArray.put( "lotno", GV_LOTNO);
	jArray.put( "member_key", member_key);
	
    TableModel = new DoyosaeTableModel("M101S020100E134", strColumnHead, jArray);
 	int RowCount =TableModel.getRowCount();

	StringBuffer html = new StringBuffer();
	if(RowCount >0){
		html.append("$('#txt_order_no').val('" 		+ TableModel.getValueAt(0,0).toString().trim() + "');\n");
		html.append("$('#txt_projrctName').val('" 	+ TableModel.getValueAt(0,8).toString().trim() + "');\n");
		html.append("$('#txt_custcode').val('" 		+ TableModel.getValueAt(0,2).toString().trim() + "');\n");
		html.append("$('#txt_cust_rev').val('" 		+ TableModel.getValueAt(0,3).toString().trim() + "');\n");
	    html.append("$('#txt_CustName').val('" 		+ TableModel.getValueAt(0,4).toString().trim() + "');\n");
	    html.append("$('#dateOrder').val('" 		+ TableModel.getValueAt(0,5).toString().trim() + "');\n");
	    html.append("$('#dateDelevery').val('" 		+ TableModel.getValueAt(0,7).toString().trim() + "');\n");
	    html.append("$('#txt_productSerialNo').val('" + TableModel.getValueAt(0,6).toString().trim() + "');\n");
	    html.append("$('#txt_jumunCount').val('" 	+ TableModel.getValueAt(0,13).toString().trim() + "');\n");
	    html.append("$('#txt_cust_poNo').val('" 	+ TableModel.getValueAt(0,9).toString().trim() + "');\n");
	    html.append("$('#txt_bigo').val('" 			+ TableModel.getValueAt(0,16).toString().trim() + "');\n");
		html.append("$('#txt_projrctCnt').val('" 	+ TableModel.getValueAt(0,17).toString().trim() + "');\n");
	    
		for(int i=0; i<RowCount; i++){
			html.append(" var trInput = $($('#product_tbody tr')[" + i + "]).find(':input');\n");
			html.append(" trInput.eq(0).val('" + TableModel.getValueAt(i,1).toString().trim() + "');\n");	//order_detail_seq
			html.append(" trInput.eq(1).val('" + TableModel.getValueAt(i,12).toString().trim() + "');\n");	//product_nm
			html.append(" trInput.eq(3).val('" + TableModel.getValueAt(i,10).toString().trim() + "');\n");	//prod_cd
			html.append(" trInput.eq(4).val('" + TableModel.getValueAt(i,11).toString().trim() + "');\n");	//prod_rev
			html.append(" trInput.eq(5).val('" + TableModel.getValueAt(i,14).toString().trim() + "');\n");	//lotno
			html.append(" trInput.eq(6).val('" + TableModel.getValueAt(i,15).toString().trim() + "');\n");	//lot_count
			if(i<RowCount-1)
				html.append( "fn_plus_body();\n" );
		}
	}
%>
    
    <script type="text/javascript">
//     웹소켓 통신을 위해서 필요한 변수들 ---시작
	
	var M303S020100E102 = {
			PID:  "M303S020100E102", 
			totalcnt: 0,
			retnValue: 999,
			colcnt: 0,
			colname: ["","","",""], //insert, Update, Delete 문장을 처리할 때는 사용되지않음
			data: []
	};  
	
	var SQL_Param = {
			PID:  "M303S020100E102", 
			excute: "queryProcess",
			stream: "N",
			param: ""
	};
	var GV_RECV_DATA = "";	//웹소켓 onMessage(event)들어온 데이터를 받는 변수
//  웹소켓 통신을 위해서 필요한 변수들 ---끝	
    var detail_seq=1;

    
    $(document).ready(function () {
    	detail_seq =1;
    	RowCount = '<%=RowCount%>';
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


		$('#txt_detail_seq').val(detail_seq);	    
	    
	    $("#btn_plus").click(function(){ 
	    	fn_plus_body(); 
	    }); 
	    $("#btn_mius").click(function(){ 
	    	fn_mius_body(); 
	    }); 
	    <%=html%>
    });
	
	function SetRecvData(){
		DataPars(M303S020100E102,GV_RECV_DATA);  		
   		parent.fn_MainInfo_List();
 		parent.$('#modalReport').hide();
	}
	
	function SaveOderInfo() {        
		var WebSockData="";
		var len = $("#product_tbody tr").length;
		
		var parmHead= '<%=Config.HEADTOKEN %>' ;
		var jArray = new Array();
        for(var i=0; i<detail_seq;i++){
        	var dataJson = new Object();
    		var trInput = $($("#product_tbody tr")[i]).find(":input")
    		
			<%-- parmHead += '<%=GV_JSPPAGE%>' 				+ "|" 
						+ '<%=loginID%>' 				+ "|" 
            			+ $('#txt_order_no').val()		+ "|"
    					+ trInput.eq(0).val() 			+ "|"	//주문상세번호
            			+ $('#txt_projrctName').val()	+ "|"
			            + $('#txt_custcode').val() 		+ "|"
			            + $('#txt_cust_rev').val() 		+ "|"
			            + $('#dateOrder').val() 		+ "|"
			            + $('#dateDelevery').val() 		+ "|"
			            + $('#txt_productSerialNo').val() 	+ "|"
			            + $('#txt_jumunCount').val() 	+ "|"	//order_count
			            + $('#txt_cust_poNo').val() 	+ "|"
			            + $('#txt_bigo').val() 			+ "|"
    					+ trInput.eq(3).val() 			+ "|"	//초품코드
    					+ trInput.eq(4).val() 			+ "|"	//prod_rev
    					+ trInput.eq(5).val() 			+ "|"	//LOT No
    					+ trInput.eq(6).val() 			+ "|"	//LOT수량
            			+ $('#txt_projrctCnt').val()	+ "|";
						
					if($('#txt_DelYN').is(":checked"))
						parmHead += "Y"	+ "|";
            		else
						parmHead += "N"	+ "|";
					parmHead += '<%=Config.DATATOKEN %>' 	; --%>
					
					
					dataJson.jsp_page 				= '<%=GV_JSPPAGE%>';			// JSPpage
	    			dataJson.login_id 				= '<%=loginID%>';				// lot_no
	    			dataJson.order_no 				=  $('#txt_order_no').val();	// txt_order_no
					dataJson.order_detail			=  trInput.eq(0).val();			//order_deatail
	    			dataJson.projrct_name			=  $('#txt_projrctName').val(); // txt_projrctName
	    			dataJson.cust_code				=  $('#txt_custcode').val() 	// txt_custcode
	    			dataJson.cust_rev				=  $('#txt_cust_rev').val() 	// txt_cust_rev
	    			dataJson.date_order				=  $('#dateOrder').val() 		// dateOrder
	    			dataJson.date_delevery			=  $('#dateDelevery').val() 	// dateDelevery
	    			dataJson.product_serial_no		=  $('#txt_productSerialNo').val() 	// txt_productSerialNo
	    			dataJson.jumun_count			=  $('#txt_jumunCount').val() 	// txt_jumunCount
	    			dataJson.cust_poNo				=  $('#txt_cust_poNo').val() 	// txt_cust_poNo
	    			dataJson.bigo					=  $('#txt_bigo').val() 		// txt_bigo
	    			dataJson.prod_code				=  trInput.eq(3).val()			// prod_code
	    			dataJson.prod_rev				=  trInput.eq(4).val() 			// prod_rev
	    			dataJson.lot_no					=  trInput.eq(5).val() 			// lot_no
	    			dataJson.lot_count				=  trInput.eq(6).val() 			// lot_count
	    			
	    			if($('#txt_DelYN').is(":checked"))
						dataJson.checked = "Y"	+ "|";
            		else
            			dataJson.checked = "N"	+ "|";
	    			
	    			jArray.push(dataJson);
    		
        }

        var dataJsonMulti = new Object();
 		dataJsonMulti.param = jArray; // Array를 다시 Object형태로 변환 {"param":{Array...}}

		var JSONparam = JSON.stringify(dataJsonMulti); // JSON Object전송을 위해 문자열형태로 바꿔줌(stringify)
		SendTojsp(JSONparam, SQL_Param.PID);

	
		



// 		WebSockData = SQL_Param.PID + "###" +  SQL_Param.excute + "###" + SQL_Param.stream  + "###" + SQL_Param.param ;


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
    	console.log(detail_seq);
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
	    	TrHtml	+= "		<input type='text' class='form-control' id='txt_ProductName' style='width: 170px; float:left' readonly></input>"
	    	TrHtml	+= "		<button type='button' onclick=\"parent.pop_fn_ProductName_View(1,'ALL')\" id='btn_SearchProd' class='btn btn-info' style='float:left'>검색</button> "
	   		TrHtml	+= "	</td>"
	     	TrHtml	+= "	<td style='font-weight: 900; font-size:14px; text-align:left; vertical-align: middle'>"
	    	TrHtml	+= "		<input type='text' class='form-control' id='txt_Productcode' style='width: 120px' readonly></input>"
			TrHtml	+= "		<input type='hidden' class='form-control' id='txt_prod_rev' style='width: 120px' readonly></input>"
	      	TrHtml	+= "    </td>"
	       	TrHtml	+= "	<td  style='font-weight: 900; font-size:14px; text-align:left; vertical-align: middle'>"
	        TrHtml	+= "      	<input type='text'  id='txt_LOTNo' class='form-control' style='width: 80px; border: solid 1px #cccccc; vertical-align: middle;'/>"
	        TrHtml	+= "	</td>"
	        TrHtml	+= "	<td  style='font-weight: 900; font-size:14px; text-align:left; vertical-align: middle'>"
	        TrHtml	+= "      	<input type='text'  id='txt_LOTCount' class='form-control' style='width: 80px; border: solid 1px #cccccc; vertical-align: middle;'/>"
	        TrHtml	+= "	</td>"
	        TrHtml	+= "	<td  style='font-weight: 900; font-size:14px; text-align:center; vertical-align: middle'>"
	        TrHtml	+= "	<input id='txt_DelYN'  type='checkbox' value=''>삭제여부</input>"
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
		if(len>=RowCount)
    		$("#product_tbody tr")[len].remove();
		detail_seq--;
		if(detail_seq < RowCount)
			detail_seq = RowCount;
    }   
    </script>
    
   <table class="table " style="width: 100%; margin: 0 auto; align:left">
   	<tr>   
		<td style="width: 50%;">
   			<table class="table table-bordered" style="width: 100%; margin: 0 auto; align:left">
		        <tr style="background-color: #fff;">
		            <td style="width: 15%; font-weight: 900; font-size:14px; text-align:left">주문명</td>
		            <td style="width: 35%; font-weight: 900; font-size:14px; text-align:left">
						<input type="hidden" class="form-control" id="txt_order_no" style="width: 210px; float:left"  />
						<input type="text" class="form-control" id="txt_projrctName" style="width: 170px; float:left"  />
						<button type="button" onclick="parent.pop_fn_projrctName_View(1)" id="btn_SearchpROJECT" class="btn btn-info" style="float:left">
						    검색</button> 
		           	</td>
		            <td style="width: 15%; font-weight: 900; font-size:14px; text-align:left">고객사</td>
		            <td style="width: 35%; font-weight: 900; font-size:14px; text-align:left">
						<input type="text" class="form-control" id="txt_CustName" style="width: 170px; float:left"   />
						<input type="hidden" class="form-control" id="txt_cust_rev" style="width: 120px" />
						<input type="hidden" class="form-control" id="txt_custcode" style="width: 120px" />
						<button type="button" onclick="parent.pop_fn_CustName_View(1,'O')" id="btn_SearchCust" class="btn btn-info" style="float:left">
						    검색</button> 
		           	</td>
		        </tr>

				<tr style="background-color: #fff;">
		            <td style=" font-weight: 900; font-size:14px; text-align:left">주문일자</td>
		            <td ><input type="text" data-date-format="yyyy-mm-dd" id="dateOrder" class="form-control"/></td>
		            <td style=" font-weight: 900; font-size:14px; text-align:left">납기일자</td>
		            <td> <input type="text" data-date-format="yyyy-mm-dd" id="dateDelevery" class="form-control" /></td>
		        
		        </tr>

		        <tr style="background-color: #fff; ">
		            <td style=" font-weight: 900; font-size:14px; text-align:left">시리얼번호</td>
		            <td> 
		            <input type="text"  id="txt_productSerialNo" class="form-control" /></td>
		            <td style=" font-weight: 900; font-size:14px; text-align:left">고객사PoNo</td>
		            <td> <input type="text"  id="txt_cust_poNo" class="form-control" /></td>
		        </tr>
		
		        <tr style="background-color: #fff; ">
		         	<td>프로젝트수량</td>
		            <td><input type="text"  id="txt_projrctCnt" class="form-control" /></td>
		            <td style=" font-weight: 900; font-size:14px; text-align:left">주문 수량</td>
		            <td> <input type="text"  id="txt_jumunCount" class="form-control" /></td>
		           
		        </tr>
		        <tr style="background-color: #fff" >
		            <td style=" font-weight: 900; font-size:14px; text-align:left" colspan="4">비고</td>
		        </tr>
		        <tr>
		            <td colspan="4"><textarea class="form-control" id="txt_bigo"  style="cols:10;rows:4;resize: none;" ></textarea></td>
		           
		        </tr>
        	</table>
        </td>
		<td style="width: 800px;">
	        <table class="table table-striped" style="width: 100%; margin: 0 auto; align:left">
	 
		        <tr style="vertical-align: middle">
		            <td style="width: 60px; font-weight: 900; font-size:14px; text-align:center; vertical-align: middle">#</td>
		            <td style="width: 280px; font-weight: 900; font-size:14px; text-align:center; vertical-align: middle">제품명</td>
		            <td style="width: 140px; font-weight: 900; font-size:14px; text-align:center; vertical-align: middle">초품코드</td>
		            <td style="width: 90px; font-weight: 900; font-size:14px; text-align:center; vertical-align: middle">LOT No</td>
		            <td style="width: 90px; font-weight: 900; font-size:14px; text-align:center; vertical-align: middle">LOT 수량</td>
		            <td style="width: 140px; font-weight: 900; font-size:14px; text-align:center; vertical-align: middle">
	                	<button alt="한줄 추가" id="btn_plus"  class="btn btn-info btn-sm" >+</button>
	                	<button alt="한줄 삭제" id="btn_mius"  class="btn btn-info btn-sm" >-</button></td>
		        </tr>
		        <tbody id="product_tbody">
			        <tr style="vertical-align: middle">			            
			        	<td style="font-weight: 900; font-size:14px; text-align:center; vertical-align: middle">
							<input type="text" class="form-control" id="txt_detail_seq"  readonly></input>
						</td>
			            <td style="font-weight: 900; font-size:14px; text-align:center; vertical-align: middle">
							<input type="text" class="form-control" id="txt_ProductName" style="width: 170px; float:left" readonly></input>
							<button type="button" onclick="parent.pop_fn_ProductName_View(1,'ALL')" id="btn_SearchProd" class="btn btn-info" style="float:left">검색</button> 
			           	</td>
			            <td style="font-weight: 900; font-size:14px; text-align:center; vertical-align: middle">
							<input type="text" class="form-control" id="txt_Productcode"  readonly></input>
							<input type="hidden" class="form-control" id="txt_prod_rev" style="width: 120px" readonly></input>
			           	</td>
			            <td style="font-weight: 900; font-size:14px; text-align:center; vertical-align: middle">
			            	<input type="text"  id="txt_LOTNo" class="form-control" />
			            </td>
			            <td style="font-weight: 900; font-size:14px; text-align:center; vertical-align: middle">
			            	<input type="text"  id="txt_LOTCount" class="form-control" />
			            </td>
			            <td style="font-weight: 900; font-size:14px; text-align:center; vertical-align: middle">
						      <input id="txt_DelYN"  type="checkbox" value="">삭제여부</input>
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
