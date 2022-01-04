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
S404S070101.jsp
포장검사 등록 
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
		//	String[] TR_Style		= {""," onclick='S404S070120Event(this)' "};
		String[] TD_Style		= {"align:center;font-weight: bold;"}; 
		String[] HyperLink		= {""}; 
		String RightButton[][]	= {{"off", "fn_Chart_View", rightbtnChartShow},{"off", "fn_Doc_Reg()", rightbtnDocSave},{"off", "fn_mius_body(this)", "삭제"}};


	String GV_ORDERNO="", GV_ORDERDETAIL="", GV_LOTNO="",GV_PRODUCT_NM="",GV_CUST_NM="", 
			GV_JSPPAGE="", GV_NUM_GUBUN="",GV_PROCESS_NM="",GV_GUBUN_CODE="",
			GV_PROC_INFO_NO="",GV_PROD_CD="",GV_PROD_CD_REV="",GV_INSPECT_RESULT_DT="", 
			GV_PROJECT_NAME="",GV_LOT_COUNT="", GV_PRODUCT_SERIAL_NO="",GV_PRODUCT_SERIAL_NO_END="";

		if(request.getParameter("OrderNo")== null)
			GV_ORDERNO = "";
		else
			GV_ORDERNO = request.getParameter("OrderNo");	
		
		if(request.getParameter("OrderDetail")== null)
			GV_ORDERDETAIL="";
		else
			GV_ORDERDETAIL = request.getParameter("OrderDetail");
		
		if(request.getParameter("lotno")== null)
			GV_LOTNO="";
		else
			GV_LOTNO = request.getParameter("lotno");
		
		if(request.getParameter("product_nm")== null)
			GV_PRODUCT_NM="";
		else
			GV_PRODUCT_NM = request.getParameter("product_nm");
		
		if(request.getParameter("cust_nm")== null)
			GV_CUST_NM="";
		else
			GV_CUST_NM = request.getParameter("cust_nm");
		
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
		
		if(request.getParameter("prod_cd")== null)
			GV_PROD_CD="";
		else
			GV_PROD_CD = request.getParameter("prod_cd");
		
		if(request.getParameter("prod_cd_rev")== null)
			GV_PROD_CD_REV="";
		else
			GV_PROD_CD_REV = request.getParameter("prod_cd_rev");
		
		if(request.getParameter("inspect_result_dt")== null)
			GV_INSPECT_RESULT_DT="";
		else
			GV_INSPECT_RESULT_DT = request.getParameter("inspect_result_dt");
		
		if(request.getParameter("project_name")== null)
			GV_PROJECT_NAME="";
		else
			GV_PROJECT_NAME = request.getParameter("project_name");
		
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
		
		
	JSONObject jArray = new JSONObject();
	jArray.put( "order_no", GV_ORDERNO);
	jArray.put( "order_detail_seq", GV_ORDERDETAIL);
// 	jArray.put( "lotno", GV_LOTNO);
	GV_GUBUN_CODE="PACK";
	jArray.put( "check_gubun", GV_GUBUN_CODE);
	jArray.put( "member_key", member_key);

	TableModel = new DoyosaeTableModel("M303S060700E534", strColumnHead, jArray);
	int RowCount =TableModel.getRowCount();
	
	String GV_INSPECT_NO = "";
	if(RowCount>0) GV_INSPECT_NO = TableModel.getValueAt(0, 20).toString().trim();
		
%>

<script type="text/javascript">
// 웹소켓 통신을 위해서 필요한 변수들 ---시작

var SQL_Param = {
		PID:  "M303S060700E501", 
		excute: "queryProcess",
		stream: "N",
		param: ""
};
//웹소켓 통신을 위해서 필요한 변수들 ---끝	



var vTableSimpInspect;
var SimpInspect_Row_index = -1;
var TableSimpInspect_info;
var TableSimpInspect_RowCount;

var vTableS303S060754;
var TableS303S060754_info;
var TableS303S060754_RowCount;

var item_type = [];
var pass_yn = [];

$(document).ready(function () {
	$('#txt_order_no').val('<%=GV_ORDERNO%>');
	$('#txt_order_detail_seq').val('<%=GV_ORDERDETAIL%>');
	$('#txt_lotno').val('<%=GV_LOTNO%>');
	$('#txt_prod_cd').val('<%=GV_PROD_CD%>');
	$('#txt_prod_cd_rev').val('<%=GV_PROD_CD_REV%>');
	$('#txt_product_nm').val('<%=GV_PRODUCT_NM%>');
	$('#txt_cust_nm').val('<%=GV_CUST_NM%>');
	$('#txt_gubun_code').val('<%=GV_GUBUN_CODE%>');
	$('#txt_inspect_result_dt').val('<%=GV_INSPECT_RESULT_DT%>');
	$('#txt_lot_count').val('<%=GV_LOT_COUNT%>');
	$('#txt_defect_cnt').val('0');
	$('#txt_inspect_no').val('<%=GV_INSPECT_NO%>');
	
	$("input[name='expiration_date']").datepicker({
    	format: 'yyyy-mm-dd',
    	autoclose: true,
    	language: 'ko'
    });        
    var today = new Date();
    var fromday = new Date();
    fromday.setDate(today.getDate());
    today.setDate(today.getDate()+30);
    $("input[name='expiration_date']").datepicker('update', fromday);
	
	vTableSimpInspect=$('#order_product_result_table').DataTable({    	    
		scrollY: 400,
	    scrollCollapse: true,
	    paging: false,
	    searching: false,
	    ordering: false,
// 	    order: [[ 0, "asc" ]],
	    info: false
	    		    	  	
	});	    
	
    // 숫자만
    $("input:text[numberOnly]").on("keyup", function() {
        $(this).val($(this).val().replace(/[^0-9]/g,""));
    });
    
// 		$.ajax({
// 	        type: "POST",
<%-- 	        url: "<%=Config.this_SERVER_path%>/Contents/Business/M303/S303S060754.jsp",  --%>
<%-- 	        data: "order_no=" + "<%=GV_ORDERNO%>" + "&lotno=" + "<%=GV_LOTNO%>",  --%>
// 	        beforeSend: function () {
// 	            $("#defect_tbody").children().remove();
// 	        },
// 	        success: function (html) {
// 	            $("#defect_tbody").hide().html(html).fadeIn(100);
// 	        },
// 	        error: function (xhr, option, error) {
// 	        }
// 		});
	
});


function SaveOderInfo() {  
// 	alert(checklist_cd);
	var WebSockData="";
	
	TableSimpInspect_info = vTableSimpInspect.page.info();
    TableSimpInspect_RowCount = TableSimpInspect_info.recordsTotal;
    
//     TableS303S060754_info = vTableS303S060754.page.info();
//     TableS303S060754_RowCount = TableS303S060754_info.recordsTotal;
      
    if(TableSimpInspect_RowCount == ""){
    	alert("포장검사 체크리스트를 등록하신 후에 진행하여 주세요.");
    	return false;
    }
//     if($('#txt_lot_count').val() < $('#txt_defect_cnt').val()){
//     	alert("불량수량이 주문수량보다 많을 수 없습니다.");
//     	return false;
//     }
    
//     if (TableS303S060754_RowCount == 1){
//         if(parseInt(vTableS303S060754.cell(0,0).data()) + parseInt($('#txt_defect_cnt').val()) > parseInt($('#txt_lot_count').val())){
//            alert("현 주문의 모든 포장검사의 불량수량이 주문수량보다 많을 수 없습니다.");
//            return false;
//         }
//     }


	var work_complete_insert_check = confirm("등록하시겠습니까?");
	if(work_complete_insert_check == false)	return;
	
// 	alert(checkBoxArray.length);
		var parmBody= "" ;
		var jArray = new Array();
		for(var i=0; i<TableSimpInspect_RowCount; i++){   
			var dataJson = new Object();
	    	var result_value;
	    	var vpass_yn = "Y";
	    	
			var trInput = $($("#order_head_tbody tr")[i]).find(":input")
			if(trInput.eq(10).val()=='CHECK'){
				if($("input[id='txt_item_type']").eq(i).prop("checked"))
					result_value ="Y";
				else
					result_value="N";
			}
			else{
				result_value = trInput.eq(10).val();
			}
// 			if(trInput.eq(11).val()=='CHECK'){
// 				if($("input[id='txt_pass_yn']").eq(i).prop("checked"))
// 					vpass_yn ="Y";
// 				else
// 					vpass_yn="N";
// 			}

    			dataJson.order_no 				= $('#txt_order_no').val();
    			dataJson.order_detail_seq 		= $('#txt_order_detail_seq').val();
    			dataJson.lotno 					= $('#txt_lotno').val();
    			dataJson.gubun_code 			= $('#txt_gubun_code').val();
    			dataJson.prod_cd 				= $('#txt_prod_cd').val();
    			dataJson.prod_cd_rev			= $('#txt_prod_cd_rev').val();
    			dataJson.checklist_cd 			= trInput.eq(1).val();
    			dataJson.checklist_cd_rev 		= trInput.eq(2).val();
    			dataJson.item_cd 				= trInput.eq(3).val();
    			dataJson.item_cd_rev 			= trInput.eq(5).val();
    			dataJson.standard_value 		= trInput.eq(9).val();
    			dataJson.result_value 			= result_value;
    			dataJson.pass_yn 				= vpass_yn;
    			dataJson.product_serial_no 		= vProductSerialNo;
    			dataJson.product_serial_no_end 	= vProductSerialNoEnd;
    			dataJson.inspect_no 			= $('#txt_inspect_no').val();
//     			dataJson.inspect_seq 			= '';
				dataJson.defect_cnt 			= '0';
				dataJson.incong_note 			= $('#txt_incong_note').val();
				dataJson.improve_note			= $('#txt_improve_note').val();
			
    			
    			dataJson.jspPage 				= '<%=GV_JSPPAGE%>';	// JSPPAGE
    			dataJson.login_id 				= '<%=loginID%>';
    			dataJson.num_Gubun 				= '<%=GV_NUM_GUBUN%>';
    			dataJson.member_key 			= '<%=member_key%>';
    			
    			jArray.push(dataJson);
    
	  }
	  
		var dataJsonMulti = new Object();
 		dataJsonMulti.param = jArray; // Array를 다시 Object형태로 변환 {"param":{Array...}}

		var JSONparam = JSON.stringify(dataJsonMulti); // JSON Object전송을 위해 문자열형태로 바꿔줌(stringify)
		SendTojsp(JSONparam, SQL_Param.PID);

	

	
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
        		 parent.work_result_Inspect_Detail.click();
                parent.$("#ReportNote").children().remove();
         		parent.$('#modalReport').hide();
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
	            <td style="width: 7%; font-weight: 900; font-size:14px; vertical-align: middle ;text-align:left">출고처</td>
	            <td style="width: 18%; font-weight: 900; font-size:14px; vertical-align: middle ; text-align:left">
					<input type="text" class="form-control" id="txt_cust_nm"  readonly />
					<input type="hidden" class="form-control" id="txt_order_no"  readonly />
					<input type="hidden" class="form-control" id="txt_order_detail_seq"  readonly /> 
					<input type="hidden" class="form-control" id="txt_gubun_code" readonly></input>
					<input type="hidden" class="form-control" id="txt_inspect_no" readonly></input>
	           	</td>
	
	            <td style="width: 7%; font-weight: 900; font-size:14px; vertical-align: middle ; text-align:left">제품명</td>
	            <td style="width: 18%; font-weight: 900; font-size:14px; vertical-align: middle ;text-align:left">
					<input type="text" class="form-control" id="txt_product_nm"  readonly />
					<input type="hidden" class="form-control" id="txt_prod_cd" readonly  />
					<input type="hidden" class="form-control" id="txt_prod_cd_rev" readonly  />
	           	</td>
	           	</tr>

	           	<tr>
	            <td style="width: 7%; font-weight: 900; font-size:14px; vertical-align: middle ;text-align:left">포장단위</td>
	            <td style=" width: 18%; font-weight: 900; font-size:14px; vertical-align: middle ;text-align:left">
					<input type="text" class="form-control" id="txt_lotno" readonly  /> 
	           	</td>
	            <td style=" font-weight: 900; font-size:14px; vertical-align: middle ;text-align:left">주문수량</td>
	            <td style=" font-weight: 900; font-size:14px; vertical-align: middle ;text-align:left">
	            	<input type="text" class="form-control" id="txt_lot_count" class="form-control" readonly />
	            </td>
	            </tr>
	            
	            <tr>
	            <td style="width: 7%; font-weight: 900; font-size:14px; vertical-align: middle ;text-align:left">기준 이탈 내역</td>
	            <td style=" width: 18%; font-weight: 900; font-size:14px; vertical-align: middle ;text-align:left">
					<input type="text" class="form-control" id="txt_incong_note"  /> 
	           	</td>
	            <td style="width: 7%; font-weight: 900; font-size:14px; vertical-align: middle ;text-align:left">개선 조치 및 결과</td>
	            <td style=" width: 18%; font-weight: 900; font-size:14px; vertical-align: middle ;text-align:left">
					<input type="text" class="form-control" id="txt_improve_note"  /> 
	           	</td>
	            </tr>
	            
<!-- 	            <tr> -->
<!-- 	            <td style="width: 7%; font-weight: 900; font-size:14px; vertical-align: middle ;text-align:left">기준 이탈 내역</td> -->
<!-- 	            <td style=" width: 18%; font-weight: 900; font-size:14px; vertical-align: middle ;text-align:left" colspan="3"> -->
<!-- 					<textarea class="form-control" id="txt_bigo"></textarea>  -->
<!-- 	           	</td> -->
<!-- 	            </tr> -->
		</table>
		
		<table class="table table-bordered" style="width: 100%; margin: 0 ; align:center ;" id="order_product_result_table"> 
			<thead>
	        <tr style="vertical-align: middle">
	            <th style="width: 10%; font-weight: 900; font-size:14px; text-align:center; vertical-align: middle">순번</th>
	            <th style="width: 50%; font-weight: 900; font-size:14px; text-align:center; vertical-align: middle ">체크내용</th>
	            <th style="width: 20%; font-weight: 900; font-size:14px; text-align:center; vertical-align: middle ">표준지침</th>
	            <th style="width: 20%; font-weight: 900; font-size:14px; text-align:center; vertical-align: middle">결과값</th>
	        </tr>		    	
			</thead>
			
	        <tbody id="order_head_tbody">
<%for (int i=0; i<RowCount; i++){  %>	        

	        <tr style="vertical-align: middle">			            
	        	<td style="text-align:center; vertical-align: middle ;margin: 0 ;">
					<input type="text" class="form-control" id="txt_checklist_seq" readonly value='<%=TableModel.getValueAt(i, 7).toString().trim()%>' style="width:100%;"></input>
					<input type="hidden" class="form-control" id="txt_checklist_cd"  readonly value='<%=TableModel.getValueAt(i, 8).toString().trim()%>'></input>
					<input type="hidden" class="form-control" id="txt_checklist_cd_rev" readonly value='<%=TableModel.getValueAt(i, 9).toString().trim()%>'></input>
					<input type="hidden" class="form-control" id="txt_item_cd" readonly value='<%=TableModel.getValueAt(i, 10).toString().trim()%>'></input>
					<input type="hidden" class="form-control" id="txt_item_seq" readonly value='<%=TableModel.getValueAt(i, 11).toString().trim()%>'></input>
					<input type="hidden" class="form-control" id="txt_item_cd_rev" readonly value='<%=TableModel.getValueAt(i, 12).toString().trim()%>'></input>
					<input type="hidden" class="form-control" id="txt_item_bigo" readonly value='<%=TableModel.getValueAt(i, 15).toString().trim()%>'></input>
						
				</td>	
				
	           	<td style="text-align:center; vertical-align: middle ;margin: 0 ;">
					<input type="text" 	 class="form-control" id="txt_check_note" readonly value='<%=TableModel.getValueAt(i, 18).toString().trim()%>' style="width:100%;"></input>	           
	           	</td>
	           	
				<td style="text-align:center; vertical-align: middle ;margin: 0 ;">
	           		<input type="text" 	class="form-control" id="txt_standard_guide"  readonly value='<%=TableModel.getValueAt(i, 16).toString().trim()%>' style="width:100%;"></input>
					<input type="hidden" class="form-control" id="txt_standard_value" readonly value='<%=TableModel.getValueAt(i, 17).toString().trim()%>'></input>
				</td>
				
				<td style="text-align:center; vertical-align: middle ;margin: 0 ;">
	            <%if(TableModel.getValueAt(i,14).toString().trim().equals("text")){ %>
	            	<%if(TableModel.getValueAt(i, 18).toString().trim().equals("유통기한")) {%>
					<input type="<%=TableModel.getValueAt(i,14).toString().trim()%>"  id="txt_item_type" value="<%=TableModel.getValueAt(i,19).toString()%>" 
						class="form-control" style="width:100%;" name="expiration_date" />
					<%}else{ %>
					<input type="<%=TableModel.getValueAt(i,14).toString().trim()%>"  id="txt_item_type" value="<%=TableModel.getValueAt(i,19).toString()%>"
						class="form-control" style="width:100%;"/>
					<%} %>
				<%} else if(TableModel.getValueAt(i,14).toString().trim().equals("checkbox")) { %>
					<%if(TableModel.getValueAt(i,19).toString().trim().equals("N")) {%>
					<input type="<%=TableModel.getValueAt(i,14).toString().trim()%>"  id="txt_item_type" value="CHECK"
						style="width:30px; height:30px; vertical-align:middle;" />
					<%} else {%>
					<input type="<%=TableModel.getValueAt(i,14).toString().trim()%>"  id="txt_item_type" checked="checked" value="CHECK" 
						style="width:30px; height:30px; vertical-align:middle;" />
					<%}%>
				<%} %>
	           	</td>
	        </tr>
<% }%>	        
	        </tbody>
	    </table>
	    
<!-- 		<div id="defect_tbody"> -->
<!-- 		</div> -->
	    
	    
			<div style="width:100%;clear:both">
        <p style="text-align:center;">
        	<button id="btn_Save"  class="btn btn-info"  onclick="SaveOderInfo();">저장</button>
            <button id="btn_Canc"  class="btn btn-info"  onclick="parent.$('#modalReport').hide();">취소</button>
        </p>
        </div>