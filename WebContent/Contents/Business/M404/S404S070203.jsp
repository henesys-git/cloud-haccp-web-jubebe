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
	String loginID = session.getAttribute("login_id").toString();
	String member_key = session.getAttribute("member_key").toString();
	DoyosaeTableModel TableModel;
	MakeTableHTML makeTableHTML;
	String zhtml = "";

// 	String[] strColumnHead 	= {"order_no","project_name", "product_serial_no","lotno", "lot_count",  "pic_seq", "prod_cd",  "product_nm", "order_check_no",
// 				"순번","체크코드", "표준지침","체크내용","표준값","체크값","비고",
// 				"prod_cd_rev","checklist_cd_rev","item_cd","item_desc","item_seq","item_cd_rev","pass_yn"};
// 	int[]   colOff 	= {0,0,0,0,0,0,0,0,0,
// 						1,1,1,1,1,1,1,
// 						0,0,0,0,0,0,0};//전체 넓이 번튼 3개:86%, 문서2개:90%, 문서뷰:94%, 챠트보기,문서등록91%; 고객사
// 	String[] TR_Style		= {"",""};
// 	//	String[] TR_Style		= {""," onclick='S404S070220Event(this)' "};
// 	String[] TD_Style		= {"align:center;font-weight: bold;"}; 
// 	String[] HyperLink		= {""}; 
// 	String RightButton[][]	= {{"off", "fn_Chart_View", rightbtnChartShow},{"off", "fn_Doc_Reg()", rightbtnDocSave},{"off", "fn_mius_body(this)", "삭제"}};

	String[] strColumnHead = { "순번", "주문번호상세","검사번호","검사구분","공정정보번호","공정명","proc_cd_rev","제품명","prod_cd_rev","검사담당자","결과등록일","체크코드", //0~11
								"checklist_cd_rev","아이템코드","item_cd_rev","검사결과값","inspect_seq","inspect_gubun","공정코드","출하코드","표준값"}; //12~21
	int[]   colOff 			= { 0,0,1,1,1,1,0,1,0,1,1,0,
								0,0,0,1,0,0,0,0,1};//전체 넓이 번튼 3개:86%, 문서2개:90%, 문서뷰:94%, 챠트보기,문서등록91%;
	String[] TR_Style		= {"",""};
	String[] TD_Style		= {"align:center;font-weight: bold;","","","","","","","","","","","","",""};  //strColumnHead의 수만큼
	String[] HyperLink		= {"fn_LoadMaterialInfo(this)","","","","","","","","","","","","",""}; //strColumnHead의 수만큼
	String RightButton[][]	= {{"off", "fn_Chart_View", rightbtnChartShow},{"off", "fn_Doc_Reg()", rightbtnDocSave},{"off", "file_real_name", rightbtnDocShow}};

	String GV_ORDERNO="", GV_LOTNO="",GV_PRODUCT_NM="", GV_JSPPAGE="", GV_NUM_GUBUN="",GV_GUBUN_CODE="",GV_INSPECT_RESULT_DT="", GV_LOT_COUNT="", GV_PRODUCT_SERIAL_NO="", GV_CHECKLIST_CD="", GV_INSPECT_NO="",GV_INSPECT_SEQ="", GV_INSPECT_GUBUN="",GV_PRODUCT_SERIAL_NO_END="";

	if(request.getParameter("OrderNo")== null)
		GV_ORDERNO = "";
	else
		GV_ORDERNO = request.getParameter("OrderNo");	
	
	if(request.getParameter("lotno")== null)
		GV_LOTNO="";
	else
		GV_LOTNO = request.getParameter("lotno");
	
	if(request.getParameter("product_nm")== null)
		GV_PRODUCT_NM="";
	else
		GV_PRODUCT_NM = request.getParameter("product_nm");
	
	if(request.getParameter("jspPage")== null)
		GV_JSPPAGE="";
	else
		GV_JSPPAGE = request.getParameter("jspPage");
	
	if(request.getParameter("num_gubun")== null)
		GV_NUM_GUBUN="";
	else
		GV_NUM_GUBUN = request.getParameter("num_gubun");
	
	if(request.getParameter("gubun_code")== null)
		GV_GUBUN_CODE="";
	else
		GV_GUBUN_CODE = request.getParameter("gubun_code");
	
	
	if(request.getParameter("inspect_result_dt")== null)
		GV_INSPECT_RESULT_DT="";
	else
		GV_INSPECT_RESULT_DT = request.getParameter("inspect_result_dt");
	
	
	if(request.getParameter("lot_count")== null)
		GV_LOT_COUNT="";
	else
		GV_LOT_COUNT = request.getParameter("lot_count");
	
	if(request.getParameter("product_serial_no")== null)
		GV_PRODUCT_SERIAL_NO="";
	else
		GV_PRODUCT_SERIAL_NO = request.getParameter("product_serial_no");
	
	if(request.getParameter("product_serial_no_end")== null)
		GV_PRODUCT_SERIAL_NO_END="";
	else
		GV_PRODUCT_SERIAL_NO_END = request.getParameter("product_serial_no_end");
	
	if(request.getParameter("checklist_cd")== null)
		GV_CHECKLIST_CD="";
	else
		GV_CHECKLIST_CD = request.getParameter("checklist_cd");
	
	if(request.getParameter("inspect_no")== null)
		GV_INSPECT_NO="";
	else
		GV_INSPECT_NO = request.getParameter("inspect_no");
	
	if(request.getParameter("inspect_seq")== null)
		GV_INSPECT_SEQ="";
	else
		GV_INSPECT_SEQ = request.getParameter("inspect_seq");
	
	if(request.getParameter("inspect_gubun")== null)
		GV_INSPECT_GUBUN="";
	else
		GV_INSPECT_GUBUN = request.getParameter("inspect_gubun");
	
	
	String param = GV_ORDERNO + "|" + GV_LOTNO + "|" + GV_GUBUN_CODE + "|" + GV_PRODUCT_SERIAL_NO + "|" + GV_PRODUCT_SERIAL_NO_END + "|";
	
	JSONObject jArray = new JSONObject();
	jArray.put( "order_no", GV_ORDERNO);
	jArray.put( "lotno", GV_LOTNO);
	jArray.put( "gubun_code", GV_GUBUN_CODE);
	jArray.put( "product_serial_no", GV_PRODUCT_SERIAL_NO);
	jArray.put( "product_serial_no_end", GV_PRODUCT_SERIAL_NO_END);
	jArray.put( "inspect_seq", GV_INSPECT_SEQ);
	jArray.put( "member_key", member_key);
		
	TableModel = new DoyosaeTableModel("M404S070100E244", strColumnHead, jArray);
	int RowCount =TableModel.getRowCount();
	
//     TableModel = new DoyosaeTableModel("M101S10000E214", strColumnHead, param);
//     int ColCount =TableModel.getColumnCount();
		
%>
    
    <script type="text/javascript">
//     웹소켓 통신을 위해서 필요한 변수들 ---시작
	var M404S070100E203 = {
			PID:  "M404S070100E203",  
			totalcnt: 0,
			retnValue: 999,
			colcnt: 0,
			colname: ["","","",""], //insert, Update, Delete 문장을 처리할 때는 사용되지않음
			data: []
	};  
	
	var SQL_Param = {
			PID:  "M404S070100E203",
			excute: "queryProcess",
			stream: "N",
			param: ""
	};
	var GV_RECV_DATA = "";	//웹소켓 onMessage(event)들어온 데이터를 받는 변수
//  웹소켓 통신을 위해서 필요한 변수들 ---끝	
    var WORK_STATUS = "";
    var JOB_GUBUN = "";
    
    var vTableSimpInspect;
    var SimpInspect_Row_index = -1;
    var TableSimpInspect_info;
    var TableSimpInspect_RowCount;

    
    $(document).ready(function () {
    	
    	$('#txt_order_no').val('<%=GV_ORDERNO%>');
    	$('#txt_lotno').val('<%=GV_LOTNO%>');
    	$('#txt_product_nm').val('<%=GV_PRODUCT_NM%>');
    	$('#txt_gubun_code').val('<%=GV_GUBUN_CODE%>');
    	$('#txt_inspect_result_dt').val('<%=GV_INSPECT_RESULT_DT%>');
    	$('#txt_lot_count').val('<%=GV_LOT_COUNT%>');
    	$('#txt_product_serial_no').val('<%=GV_PRODUCT_SERIAL_NO%>');
    	$('#txt_product_serial_no_end').val('<%=GV_PRODUCT_SERIAL_NO_END%>');
<%--     	$('#txt_inspect_no').val('<%=GV_INSPECT_NO%>'); --%>
<%--     	$('#txt_checklist_cd').val('<%=GV_CHECKLIST_CD%>'); --%>
    	$('#txt_inspect_seq').val('<%=GV_INSPECT_SEQ%>');
    	
    	vTableSimpInspect=$('#order_product_result_table').DataTable({    	    
    		scrollY: 400,
    	    scrollCollapse: true,
    	    paging: false,
    	    searching: false,
    	    ordering: true,
    	    order: [[ 0, "asc" ]],
    	    info: false
    	    ,
      		'columnDefs': [
      			{
    	       		'targets': [0],
    	       		'createdCell':  function (td) {
    	          			$(td).attr('style', 'width:3%;'); 
    	       		}
    			}
      			]			    	  	
    	});	
    	
        $("#select_status option:eq(1)").prop("selected", true);
//         $($("select[id='select_status']")[1]).prop("selected", true);

	    $("#select_status").on("change", function(){
	    	WORK_STATUS = $(this).val();
	    });
    });
	
	
	function SaveOderInfo() {        
		
		var work_complete_delete_check = confirm("삭제하시겠습니까?");
		if(work_complete_delete_check == false)	return;
		
		var WebSockData="";
		var dataJson = new Object();

				dataJson.jsp_page = '<%=GV_JSPPAGE%>';;
				dataJson.login_id = '<%=loginID%>';
				dataJson.num_gubun = '<%=GV_NUM_GUBUN%>';
				dataJson.order_no = $('#txt_order_no').val();
				dataJson.lotno = $('#txt_lotno').val();
				dataJson.inspect_no = inspect_no;
				dataJson.checklist_cd = checklist_cd;
				dataJson.inspect_seq = $('#txt_inspect_seq').val();
				dataJson.member_key = "<%=member_key%>";
				
				
				var JSONparam = JSON.stringify(dataJson);
				SendTojsp(JSONparam,SQL_Param.PID);
			
	
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
	        	   	parent.fn_DetailInfo_List();
	                parent.$("#ReportNote").children().remove();
	         		parent.$('#modalReport').hide();
	         	}
	         },
	         error: function (xhr, option, error) {

	         }
	     });		

	}

    


//     function fn_CommonPopupModal(sUrl, name, w, h) { // url, name, width, height, 기타 속성(생략해도 무방)     	
//         var popupWin = window.showModalDialog(sUrl, name, 'dialogWidth:' + w + 'px; dialogHeight:' + h 
//                 + 'px; center:yes; help:no; status:no; resizable:no; scroll:yes; toolbar :no;');
//     	if(typeof(popupWin)=="undefine")
//     		popupWin = window.returnValue;
// 		return popupWin;
//     }  
    

//     function SetCustName_code(name, code, rev){
//     	$("#txt_order_no").val(parm.order_no);
// 		$('#txt_CustName').val(name);
// 		$('#txt_custcode').val(code);
// 		$('#txt_cust_rev').val(rev);
//     }

//     function SetIpmtInspectReq(parm){ //[order_no,lotno, balju_no,balju_inspect_no,import_inspect_req_no,ipgoDate,ingaeDate,CustName,Custcode]
//  		$("#txt_order_no").val(parm.order_no);
//  		$("#txt_lotno").val(parm.lotno);
//  		$("#txt_balju_no").val(parm.balju_no);
//  		$("#txt_balju_inspect_no").val(parm.balju_inspect_no);
//  		$("#txt_import_inspect_req_no").val(parm.import_inspect_req_no);
//  		$("#ipgoDate").val(parm.ipgoDate);
//  		$("#ingaeDate").val(parm.ingaeDate);
//  		$("#txt_CustName").val(parm.CustName);
//  		$("#txt_custcode").val(parm.Custcode);

		
//     }    

	

  
    </script>
	<div style='float: left;'>
   				<table class="table" style="width: 100%; margin: 0 auto; align:left">

	           	<tr>
	            <td style="width: 7%; font-weight: 900; font-size:14px; vertical-align: middle ;text-align:left">주문번호</td>
	            <td style="width: 18%; font-weight: 900; font-size:14px; vertical-align: middle ; text-align:left">
					<input type="text" class="form-control" id="txt_order_no"  readonly /> 
<!-- 					<input type="hidden" class="form-control" id="txt_lotno" readonly></input> -->
					<input type="hidden" class="form-control" id="txt_gubun_code" readonly></input>
					<input type="hidden" class="form-control" id="txt_proc_info_no" readonly></input>
					<input type="hidden" class="form-control" id="txt_proc_cd" readonly></input>
					<input type="hidden" class="form-control" id="txt_proc_cd_rev" readonly></input>
	           	</td>
	
	            <td style="width: 7%; font-weight: 900; font-size:14px; vertical-align: middle ; text-align:left">제품명</td>
	            <td style="width: 18%; font-weight: 900; font-size:14px; vertical-align: middle ;text-align:left">
					<input type="text" 		class="form-control" id="txt_product_nm"  readonly />
					<input type="hidden" 		class="form-control" id="txt_product_serial_no" readonly  />
					<input type="hidden" 		class="form-control" id="txt_product_serial_no_end" readonly  />
	           	</td>
	           	</tr>
	           	
<!-- 	           	<tr> -->
<!-- 	            <td style="width: 7%; font-weight: 900; font-size:14px; vertical-align: middle ; text-align:left">출하시리얼번호시작</td> -->
<!-- 	            <td style="width: 18%; font-weight: 900; font-size:14px; vertical-align: middle ;text-align:left"> -->
	            
<!-- 					<input type="text" 		class="form-control" id="txt_product_serial_no" readonly  /> -->
<!-- 	           	</td> -->
	
<!-- 	            <td style="width: 7%; font-weight: 900; font-size:14px; vertical-align: middle ; text-align:left">출하시리얼번호끝</td> -->
<!-- 	            <td style="width: 18%; font-weight: 900; font-size:14px; vertical-align: middle ;text-align:left"> -->
	            
<!-- 					<input type="text" 		class="form-control" id="txt_product_serial_no_end" readonly  /> -->
<!-- 	           	</td> -->
<!-- 	           	</tr> -->
	           	<tr>
	            <td style="width: 7%; font-weight: 900; font-size:14px; vertical-align: middle ;text-align:left">LOT No</td>
	            <td style=" width: 18%; font-weight: 900; font-size:14px; vertical-align: middle ;text-align:left">
					<input type="text" 		class="form-control" id="txt_lotno" readonly  /> 
	           	</td>
	            <td style=" font-weight: 900; font-size:14px; vertical-align: middle ;text-align:left">LOT 수량</td>
	            <td style=" font-weight: 900; font-size:14px; vertical-align: middle ;text-align:left">
	            	<input type="text" class="form-control" id="txt_lot_count" class="form-control" readonly />
	            	<input type="hidden" class="form-control" id="txt_inspect_result_dt" readonly></input>
	            	<input type="hidden" class="form-control" id="txt_inspect_seq" readonly></input>
	            </td>
	            </tr>
		</table>
		
<!-- 	String[] strColumnHead = { "순번", "주문번호상세","검사번호","검사구분","공정정보번호","공정명","proc_cd_rev","제품명","prod_cd_rev","검사담당자","결과등록일","체크코드", //0~11 -->
<!-- 						"checklist_cd_rev","아이템코드","item_cd_rev","검사결과값","inspect_seq","inspect_gubun","공정코드","출하코드","표준값","체크내용"}; //12~21 -->
		
		 <table class="table table-striped" style="width: 100%; margin: 0 ; align:center ;" id="order_product_result_table"> 
			<thead>
	        <tr style="vertical-align: middle">
	            <th style="width: 10%; font-weight: 900; font-size:14px; text-align:center; vertical-align: middle">검사번호</th>
	            <th style="width: 10%; font-weight: 900; font-size:14px; text-align:center; vertical-align: middle">검사구분</th>
<!-- 	            <th style="width: 20%; font-weight: 900; font-size:14px; text-align:center; vertical-align: middle">공정번호</th> -->
<!-- 	            <th style="width: 5%; font-weight: 900; font-size:14px; text-align:center; vertical-align: middle">공정명</th> -->
	            <th style="width: 10%; font-weight: 900; font-size:14px; text-align:center; vertical-align: middle">제품명</th>
	            <th style="width: 10%; font-weight: 900; font-size:14px; text-align:center; vertical-align: middle">표준값</th>
	            <th style="width: 10%; font-weight: 900; font-size:14px; text-align:center; vertical-align: middle">체크코드</th>
	            <th style="width: 10%; font-weight: 900; font-size:14px; text-align:center; vertical-align: middle">결과등록일</th>
	            <th style="width: 10%; font-weight: 900; font-size:14px; text-align:center; vertical-align: middle">검사결과값</th>
	        </tr>		    	
			</thead>
			
	        <tbody id="order_head_tbody">
<%for (int i=0; i<RowCount; i++){  %>	        

	        <tr style="vertical-align: middle">			            
	        	<td style="text-align:center; vertical-align: middle ;margin: 0 ;">
<%-- 	        	<input type="hidden" class="form-control" id="txt_pic_seq" readonly value='<%=TableModel.getValueAt(i, 5).toString().trim()%>'></input>	 --%>
<%-- 				<input type="hidden" class="form-control" id="txt_prod_cd" readonly value='<%=TableModel.getValueAt(i, 6).toString().trim()%>'></input>	 --%>
<%-- 				<input type="hidden" class="form-control" id="txt_product_nm" readonly value='<%=TableModel.getValueAt(i, 7).toString().trim()%>'></input>	 --%>
<%-- 				<input type="hidden" class="form-control" id="txt_order_check_no" readonly value='<%=TableModel.getValueAt(i, 8).toString().trim()%>'></input>		 --%>
				<input type="text" class="form-control" id="txt_inspect_no" readonly value='<%=TableModel.getValueAt(i, 2).toString().trim()%>'></input>	
				</td>	
				
				<td style="text-align:right;vertical-align: middle ;margin: 0 ;">
					<input type="text" class="form-control" id="txt_inspect_gubun"  readonly value='<%=TableModel.getValueAt(i, 3).toString().trim()%>'></input> 
	           	</td> 
	           	        
<!-- 	           	<td style="text-align:right;vertical-align: middle ;margin: 0 ;"> -->
<%-- 					<input type="text" class="form-control" id="txt_proc_info_no"  readonly value='<%=TableModel.getValueAt(i, 4).toString().trim()%>'></input>  --%>
<!-- 	           	</td> -->
	           	
<!-- 	           	<td style="text-align:center; vertical-align: middle ;margin: 0 ;"> -->
<%-- 					<input type="text" 	 class="form-control" id="txt_process_nm" readonly value='<%=TableModel.getValueAt(i, 5).toString().trim()%>'></input>	            --%>
<!-- 	           	</td> -->
	           	
	           <td style="text-align:center; vertical-align: middle ;margin: 0 ;">
					<input type="text" 	 	class="form-control" id="txt_product_nm" readonly value='<%=TableModel.getValueAt(i, 4).toString().trim()%>'></input>
				</td>
				 <td style="text-align:center; vertical-align: middle ;margin: 0 ;">
					<input type="text" 	 	class="form-control" id="txt_standard_value" readonly value='<%=TableModel.getValueAt(i, 16).toString().trim()%>'></input>
				</td>
				 <td style="text-align:center; vertical-align: middle ;margin: 0 ;">
					<input type="text" 	 	class="form-control" id="txt_checklist_cd" readonly value='<%=TableModel.getValueAt(i, 8).toString().trim()%>'></input>
				</td>
<!-- 				 <td style="text-align:center; vertical-align: middle ;margin: 0 ;"> -->
<%-- 					<input type="text" 	 	class="form-control" id="txt_check_note" readonly value='<%=TableModel.getValueAt(i, 21).toString().trim()%>'></input> --%>
<!-- 				</td> -->
	           	<td style="text-align:center; vertical-align: middle ;margin: 0 ;">
					<input type="text" 	 class="form-control" id="txt_inspect_result_dt" readonly value='<%=TableModel.getValueAt(i, 7).toString().trim()%>'></input>	       
				</td>
	           	<td style="text-align:center; vertical-align: middle ;margin: 0 ;">
					<input type="text" 	 class="form-control" id="txt_result_value" readonly value='<%=TableModel.getValueAt(i, 12).toString().trim()%>'></input>	       
				</td>
	        </tr>
<% }%>	        
	        </tbody>
	    </table>
			<div style="width:100%;clear:both">
        <p style="text-align:center;">
        	<button id="btn_Save"  class="btn btn-info"  onclick="SaveOderInfo();">삭제</button>
            <button id="btn_Canc"  class="btn btn-info"  onclick="parent.$('#modalReport').hide();">취소</button>
        </p>
        </div>
		
<!-- 	        <tr style="height: 60px"> -->
<!--             <td align="center" colspan="2"> -->
<!-- 	                <p> -->
<!-- 	                	<button id="btn_Save"  class="btn btn-info" style="width: 100px" onclick="SaveOderInfo();">삭제</button> -->
<!-- 	                    <button id="btn_Canc"  class="btn btn-info" style="width: 100px" onclick="parent.$('#modalReport').hide();">취소</button> -->
<!-- 	                </p> -->
<!-- 	            </td> -->
<!-- 	        </tr> -->
<!--     	</table> -->
    	
    </div>
    <div id="ImportInspect_List" style='overflow:as_auto; float: left; height:600px'></div>
    
   
<!-- overflow 속성이 효력을 갖기 위해선, 반드시 블록 레벨 컨테이너의 높이(height 또는 max-height)가 설정되어 있거나, white-space가 nowrap으로 설정되어야 합니다.    -->
