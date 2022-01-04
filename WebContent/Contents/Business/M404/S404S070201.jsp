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
/* 
S404S070201.jsp
출하검사 등록 
*/
String loginID = session.getAttribute("login_id").toString();
String member_key = session.getAttribute("member_key").toString();
DoyosaeTableModel TableModel;
MakeTableHTML makeTableHTML;
String zhtml = "";

		String[] strColumnHead 	= {"order_no","project_name", "product_serial_no","lotno", "lot_count",  "pic_seq", "prod_cd",  "product_nm", "order_check_no",
				"순번","체크코드", "표준지침","체크내용","표준값","결과값","비고",
				"prod_cd_rev","checklist_cd_rev","item_cd","item_desc","item_seq","item_cd_rev","합격여부"};
		int[]   colOff 	= {0,0,0,0,0,0,0,0,0,
							1,1,1,1,1,1,1,
							0,0,0,0,0,0,0};//전체 넓이 번튼 3개:86%, 문서2개:90%, 문서뷰:94%, 챠트보기,문서등록91%; 고객사
		
		
		String[] TR_Style		= {"",""};
		//	String[] TR_Style		= {""," onclick='S404S070220Event(this)' "};
		String[] TD_Style		= {"align:center;font-weight: bold;"}; 
		String[] HyperLink		= {""}; 
		String RightButton[][]	= {{"off", "fn_Chart_View", rightbtnChartShow},{"off", "fn_Doc_Reg()", rightbtnDocSave},{"off", "fn_mius_body(this)", "삭제"}};


String GV_ORDERNO="", GV_LOTNO="",GV_PRODUCT_NM="", GV_JSPPAGE="", GV_NUM_GUBUN="",GV_PROCESS_NM="",GV_GUBUN_CODE="",GV_PROC_INFO_NO="",GV_PROC_CD="",GV_PROC_CD_REV="",GV_INSPECT_RESULT_DT="", GV_PROJECT_NAME="",GV_LOT_COUNT="", GV_PRODUCT_SERIAL_NO="",GV_PRODUCT_SERIAL_NO_END="",
		GV_ORDER_DETAIL_SEQ="";

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
		
		if(request.getParameter("process_nm")== null)
			GV_PROCESS_NM="";
		else
			GV_PROCESS_NM = request.getParameter("process_nm");
		
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
		
		if(request.getParameter("proc_info_no")== null)
			GV_PROC_INFO_NO="";
		else
			GV_PROC_INFO_NO = request.getParameter("proc_info_no");
		
		if(request.getParameter("proc_cd")== null)
			GV_PROC_CD="";
		else
			GV_PROC_CD = request.getParameter("proc_cd");
		
		if(request.getParameter("proc_cd_rev")== null)
			GV_PROC_CD_REV="";
		else
			GV_PROC_CD_REV = request.getParameter("proc_cd_rev");
		
		if(request.getParameter("inspect_result_dt")== null)
			GV_INSPECT_RESULT_DT="";
		else
			GV_INSPECT_RESULT_DT = request.getParameter("inspect_result_dt");
		
		if(request.getParameter("project_name")== null)
			GV_PROJECT_NAME="";
		else
			GV_PROJECT_NAME = request.getParameter("project_name");
		
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
		
		if(request.getParameter("order_detail_seq")== null)
			GV_ORDER_DETAIL_SEQ="";
		else
			GV_ORDER_DETAIL_SEQ = request.getParameter("order_detail_seq");
		
		
		

	String param =GV_ORDERNO+ "|" + GV_LOTNO + "|";
	
	JSONObject jArray = new JSONObject();
	jArray.put( "order_no", GV_ORDERNO);
	jArray.put( "lotno", GV_LOTNO);
	jArray.put( "order_detail_seq", GV_ORDER_DETAIL_SEQ);
	jArray.put( "member_key", member_key);


	TableModel = new DoyosaeTableModel("M404S070100E234", strColumnHead, jArray);
	int RowCount =TableModel.getRowCount();
		
%>

<%-- <jsp:include page="../../Common/linkcss_js.jsp" flush="false"/> --%>
<script type="text/javascript">
// 웹소켓 통신을 위해서 필요한 변수들 ---시작
var M404S070100E201 = {
		PID:  "M404S070100E201", 
		UPID: "M404S070100E201",  
		totalcnt: 0,
		retnValue: 999,
		colcnt: 0,
		colname: ["","","",""], //insert, Update, Delete 문장을 처리할 때는 사용되지않음
		data: []
};  

var SQL_Param = {
		PID:  "M404S070100E201",
		excute: "queryProcess",
		stream: "N",
		param: ""
};
//웹소켓 통신을 위해서 필요한 변수들 ---끝	



var vTableSimpInspect;
var SimpInspect_Row_index = -1;
var TableSimpInspect_info;
var TableSimpInspect_RowCount;

var item_type = [];
var pass_yn = [];

$(document).ready(function () {
	$('#txt_order_no').val('<%=GV_ORDERNO%>');
	$('#txt_lotno').val('<%=GV_LOTNO%>');
	$('#txt_product_nm').val('<%=GV_PRODUCT_NM%>');
	$('#txt_gubun_code').val('<%=GV_GUBUN_CODE%>');
	$('#txt_inspect_result_dt').val('<%=GV_INSPECT_RESULT_DT%>');
	$('#txt_lot_count').val('<%=GV_LOT_COUNT%>');
	$('#txt_product_serial_no').val('<%=GV_PRODUCT_SERIAL_NO%>');
	$('#txt_product_serial_no_end').val('<%=GV_PRODUCT_SERIAL_NO_END%>');
	
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
	
});


function SaveOderInfo() {  
// 	alert(checklist_cd);

	var WebSockData="";
	
	TableSimpInspect_info = vTableSimpInspect.page.info();
    TableSimpInspect_RowCount = TableSimpInspect_info.recordsTotal;
      

				console.log("1. "+TableSimpInspect_info);
				console.log("2. "+TableSimpInspect_RowCount);
// 		"order_no","project_name", "product_serial_no","lotno", "lot_count",  "pic_seq", "prod_cd",  "product_nm", 0~7
// 		"order_check_no","checklist_seq", "checklist_cd", "standard_guide","check_note","standard_value","item_type","item_bigo","prod_cd_rev",
// 		,"checklist_cd_rev","item_cd","item_desc","item_seq","item_cd_rev"
	
	    if(TableSimpInspect_RowCount == ""){
	    	alert("출하검사 체크리스트를 등록하신 후에 진행하여 주세요.");
	    	return false;
	    }
	    
		var work_complete_insert_check = confirm("등록하시겠습니까?");
		if(work_complete_insert_check == false)	return;

// 	alert(checkBoxArray.length);
		var parmBody= "" ;

		var jArray = new Array(); // JSON Array 선언
		
		
		for(var i=0; i<TableSimpInspect_RowCount; i++){   
			console.log("실행");
	    	var result_value;
	    	var vpass_yn;
	    	
			var trInput = $($("#order_head_tbody tr")[i]).find(":input")
			if(trInput.eq(9).val()=='CHECK'){
				if($("input[id='txt_item_type']").eq(i).prop("checked"))
					result_value ="Y";
				else
					result_value="N";
			}
			else{
				result_value = trInput.eq(9).val();
			}
			var trInput = $($("#order_head_tbody tr")[i]).find(":input")
			if(trInput.eq(10).val()=='CHECK'){
				if($("input[id='txt_pass_yn']").eq(i).prop("checked"))
					vpass_yn ="Y";
				else
					vpass_yn="N";
			}

		 
		<%-- parmBody +='<%=GV_ORDERNO%>'	+ "|"	
				 + '<%=GV_LOTNO%>'	+ "|"	
				 + trInput.eq(17).val()					+ "|"	// txt_gubun_code  
		    	 + vProdCd						+ "|"	// txt_prod_cd
		    	 + vProdRev					+ "|"	// txt_prod_cd_rev    	
				 + trInput.eq(5).val()			+ "|"   // checklist_cd
				 + trInput.eq(13).val()			+ "|"   // checklist_cd_rev
				 + trInput.eq(14).val()			+ "|"   // item_cd
				 + trInput.eq(16).val()			+ "|"   // item_cd_rev
				 + trInput.eq(8).val()			+ "|"   // standard_value
				 + result_value					+ "|"   // item_type
			     + vpass_yn 					+ "|"	// pass_yn
			     + vProductSerialNo 			+ "|"	// product_serial_no
			     + vProductSerialNoEnd			+ "|"	// product_serial_no_end
			     + trInput.eq(18).val()			+ "|"   // inspect_no
			     + trInput.eq(19).val()			+ "|"   // inspect_seq
			     
    			+ '<%=Config.DATATOKEN %>' 	; --%>
    			

    
			var dataJson = new Object();
			
			dataJson.jspPage = '<%=GV_JSPPAGE%>';
			dataJson.login_id = '<%=loginID%>';
			dataJson.num_Gubun = '<%=GV_NUM_GUBUN%>';
			dataJson.order_no = '<%=GV_ORDERNO%>';
			dataJson.lotno = '<%=GV_LOTNO%>';
			dataJson.order_detail_seq = '<%=GV_ORDER_DETAIL_SEQ%>'; 
			dataJson.gubun_code = trInput.eq(17).val()	;			// txt_gubun_code 
			dataJson.prod_cd = vProdCd;								// txt_prod_cd
			dataJson.prod_cd_rev = vProdRev;							// txt_prod_cd_rev
			dataJson.checklist_cd = trInput.eq(5).val(); 			// checklist_cd
			dataJson.checklist_cd_rev = trInput.eq(13).val(); 		// checklist_cd_rev
			dataJson.item_cd = trInput.eq(14).val();				// item_cd
			dataJson.item_cd_rev = trInput.eq(16).val();			// item_cd_rev
			dataJson.standard_value = trInput.eq(8).val();			// standard_value
			dataJson.result_value = result_value;					// result_value
			dataJson.pass_yn = vpass_yn; 							// pass_yn
			dataJson.product_serial_no = vProductSerialNo;			// product_serial_no
			dataJson.product_serial_no_end = vProductSerialNoEnd;	// product_serial_no_end
// 			dataJson.inspect_no = trInput.eq(18).val();				// inspect_no
// 			dataJson.inspect_seq = trInput.eq(19).val();			// inspect_seq
			
			dataJson.member_key = "<%=member_key%>";			// member_key
			
			jArray.push(dataJson);
			
	  }
/* 		SQL_Param.params = parmHead + parmBody;
		
		SendTojsp(urlencode(parmHead) + urlencode(parmBody), "M404S070100E201") */
		
		var dataJsonMulti = new Object();
 		dataJsonMulti.param = jArray; // Array를 다시 Object형태로 변환 {"param":{Array...}}

		var JSONparam = JSON.stringify(dataJsonMulti); // JSON Object전송을 위해 문자열형태로 바꿔줌(stringify)
		SendTojsp(JSONparam, SQL_Param.PID); // SendToJSP를 통해 ajax로 데이터(JSONObject,PID) 보냄
	  
	
}


		function SendTojsp(bomdata, pid){
			
		    $.ajax({
		         type: "POST",
		         dataType: "json", // Ajax로 json타입으로 보낸다.
		         url: "<%=Config.this_SERVER_path%>/Contents/CommonView/insert_update_delete_json.jsp", 
		         data:  {"bomdata" : bomdata, "pid" : pid },
		         beforeSend: function () {
		//         	 alert(bomdata);
		         },
		         
		         success: function (html) {	
		        	 if(html>-1){
		        		parent.fn_DetailInfo_List();
		                parent.$("#ReportNote").children().remove();
		                $('#modalReport').modal('hide');
		         	}
		         },
		         error: function (xhr, option, error) {
		
		         }
		     });		
		} 



</script>
    

<!-- 	<div> -->
		<table class="table" style="width: 100%; margin: 0 auto; align:left">

	           	<tr>
	            <td style="width: 7%; font-weight: 900; font-size:14px; vertical-align: middle ;text-align:left">주문번호</td>
	            <td style="width: 18%; font-weight: 900; font-size:14px; vertical-align: middle ; text-align:left">
					<input type="text" class="form-control" id="txt_order_no"  readonly /> 
<!-- 					<input type="hidden" class="form-control" id="txt_lotno" readonly></input> -->
					<input type="hidden" class="form-control" id="txt_gubun_code" readonly></input>
<!-- 					<input type="hidden" class="form-control" id="txt_proc_info_no" readonly></input> -->
<!-- 					<input type="hidden" class="form-control" id="txt_proc_cd" readonly></input> -->
<!-- 					<input type="hidden" class="form-control" id="txt_proc_cd_rev" readonly></input> -->
	           	</td>
	
	            <td style="width: 7%; font-weight: 900; font-size:14px; vertical-align: middle ; text-align:left">제품명</td>
	            <td style="width: 18%; font-weight: 900; font-size:14px; vertical-align: middle ;text-align:left">
					<input type="text" class="form-control" id="txt_product_nm"  readonly />
					<input type="hidden" class="form-control" id="txt_product_serial_no" readonly  />
					<input type="hidden" class="form-control" id="txt_product_serial_no_end" readonly  />
	           	</td>
	           	</tr>

<!-- 	           	<tr> -->
<!-- 	            <td style="width: 7%; font-weight: 900; font-size:14px; vertical-align: middle ; text-align:left">출하시리얼번호시작</td> -->
<!-- 	            <td style="width: 18%; font-weight: 900; font-size:14px; vertical-align: middle ;text-align:left"> -->
<!-- 					<input type="text" class="form-control" id="txt_product_serial_no" readonly  /> -->
<!-- 	           	</td> -->
<!-- 	           	<td style="width: 7%; font-weight: 900; font-size:14px; vertical-align: middle ; text-align:left">출하시리얼번호끝</td> -->
<!-- 	            <td style="width: 18%; font-weight: 900; font-size:14px; vertical-align: middle ;text-align:left"> -->
<!-- 					<input type="text" class="form-control" id="txt_product_serial_no_end" readonly  /> -->
<!-- 	           	</td> -->
<!-- 	           	</tr> -->
	           	<tr>
	            <td style="width: 7%; font-weight: 900; font-size:14px; vertical-align: middle ;text-align:left">LOT No</td>
	            <td style=" width: 18%; font-weight: 900; font-size:14px; vertical-align: middle ;text-align:left">
					<input type="text" class="form-control" id="txt_lotno" readonly  /> 
	           	</td>
	            <td style=" font-weight: 900; font-size:14px; vertical-align: middle ;text-align:left">LOT 수량</td>
	            <td style=" font-weight: 900; font-size:14px; vertical-align: middle ;text-align:left">
	            	<input type="text" class="form-control" id="txt_lot_count" class="form-control" readonly />
	            </td>
	            </tr>
		</table>
		
		<table class="table table-striped" style="width: 100%; margin: 0 ; align:center ;" id="order_product_result_table"> 
			<thead>
	        <tr style="vertical-align: middle">
	            <th style="width:  3%; font-weight: 900; font-size:14px; text-align:center; vertical-align: middle">순번</th>
	            <th style="width: 10%; font-weight: 900; font-size:14px; text-align:center; vertical-align: middle">체크코드</th>
	            <th style="width: 10%; font-weight: 900; font-size:14px; text-align:center; vertical-align: middle ">표준지침</th>
	            <th style="width: 10%; font-weight: 900; font-size:14px; text-align:center; vertical-align: middle ">체크내용</th>
	            <th style="width: 15%; font-weight: 900; font-size:14px; text-align:center; vertical-align: middle">표준값</th>
	            <th style="width: 15%; font-weight: 900; font-size:14px; text-align:center; vertical-align: middle">결과값</th>
	            <th style="width: 15%; font-weight: 900; font-size:14px; text-align:center; vertical-align: middle">합격여부</th>
	            <th style="width: 17%; font-weight: 900; font-size:14px; text-align:center; vertical-align: middle">비고</th>
	        </tr>		    	
			</thead>
			
	        <tbody id="order_head_tbody">
<%for (int i=0; i<RowCount; i++){  %>	        

	        <tr style="vertical-align: middle">			            
	        	<td style="text-align:center; vertical-align: middle ;margin: 0 ;">
	        	<input type="hidden" class="form-control" id="txt_pic_seq" readonly value='<%=TableModel.getValueAt(i, 5).toString().trim()%>'></input>	
				<input type="hidden" class="form-control" id="txt_prod_cd" readonly value='<%=TableModel.getValueAt(i, 6).toString().trim()%>'></input>	
				<input type="hidden" class="form-control" id="txt_product_nm" readonly value='<%=TableModel.getValueAt(i, 7).toString().trim()%>'></input>	
				<input type="hidden" class="form-control" id="txt_order_check_no" readonly value='<%=TableModel.getValueAt(i, 8).toString().trim()%>'></input>		
				<input type="text" class="form-control" id="txt_checklist_seq" readonly value='<%=TableModel.getValueAt(i, 9).toString().trim()%>'></input>	
				</td>	
				
				<td style="text-align:right;vertical-align: middle ;margin: 0 ;">
					<input type="text" class="form-control" id="txt_checklist_cd"  readonly value='<%=TableModel.getValueAt(i, 10).toString().trim()%>'></input> 
	           	</td> 
	           	        
	           	<td style="text-align:right;vertical-align: middle ;margin: 0 ;">
					<input type="text" class="form-control" id="txt_standard_guide"  readonly value='<%=TableModel.getValueAt(i, 11).toString().trim()%>'></input> 
	           	</td>
	           	
	           	<td style="text-align:center; vertical-align: middle ;margin: 0 ;">
					<input type="text" 	 class="form-control" id="txt_check_note" readonly value='<%=TableModel.getValueAt(i, 12).toString().trim()%>'></input>	           
	           	</td>
	           	
	           <td style="text-align:center; vertical-align: middle ;margin: 0 ;">
					<input type="text" 	 	class="form-control" id="txt_standard_value" readonly value='<%=TableModel.getValueAt(i, 13).toString().trim()%>'></input>
				</td>
				
				 <td style="text-align:center; vertical-align: middle ;margin: 0 ;">
	            <%if(TableModel.getValueAt(i,14).toString().trim().equals("text")){ %>
					<input type="<%=TableModel.getValueAt(i,14).toString().trim()%>"  id="txt_item_type"  ></input>
				<%} 
				else{ %>
<%-- 					<input type="<%=TableModel.getValueAt(i,14).toString().trim()%>" checked="checked" id="txt_item_type" value="CHECK"><%=TableModel.getValueAt(i, 19).toString().trim()%></input> --%>
					<input type="<%=TableModel.getValueAt(i,14).toString().trim()%>" checked="checked" id="txt_item_type" value="CHECK"></input>
				<%} %>
	           	</td>
	           	<td style="text-align:center; vertical-align: middle ;margin: 0 ;">
					<input type="checkbox" id="txt_pass_yn" checked="checked" value="CHECK"></input>
	           	</td>
	           	<td style="text-align:center; vertical-align: middle ;margin: 0 ;">
					<input type="text" 	 class="form-control" id="txt_item_bigo" readonly value='<%=TableModel.getValueAt(i, 15).toString().trim()%>'></input>	           
	           	
					<input type="hidden" class="form-control" id="txt_prod_cd_rev" readonly value='<%=TableModel.getValueAt(i, 16).toString().trim()%>'></input>	
					<input type="hidden" class="form-control" id="txt_checklist_cd_rev" readonly value='<%=TableModel.getValueAt(i, 17).toString().trim()%>'></input>	
					<input type="hidden" class="form-control" id="txt_item_cd" readonly value='<%=TableModel.getValueAt(i, 18).toString().trim()%>'></input>
					<input type="hidden" class="form-control" id="txt_item_seq" readonly value='<%=TableModel.getValueAt(i, 20).toString().trim()%>'></input>
					<input type="hidden" class="form-control" id="txt_item_cd_rev" readonly value='<%=TableModel.getValueAt(i, 21).toString().trim()%>'></input>
					<input type="hidden" class="form-control" id="txt_inspect_gubun" readonly value='<%=TableModel.getValueAt(i, 23).toString().trim()%>'></input>
<%-- 					<input type="hidden" class="form-control" id="txt_inspect_no" readonly value='<%=TableModel.getValueAt(i, 25).toString().trim()%>'></input> --%>
<%-- 					<input type="hidden" class="form-control" id="txt_inspect_seq" readonly value='<%=TableModel.getValueAt(i, 26).toString().trim()%>'></input> --%>
				 </td>
	        </tr>
<% }%>	        
	        </tbody>
	    </table>
	    
	    
			<div style="width:100%;clear:both">
        <p style="text-align:center;">
        	<button id="btn_Save"  class="btn btn-info"  onclick="SaveOderInfo();">저장</button>
            <button id="btn_Canc"  class="btn btn-info"  onclick="$('#modalReport').modal('hide');">취소</button>
        </p>
        </div>