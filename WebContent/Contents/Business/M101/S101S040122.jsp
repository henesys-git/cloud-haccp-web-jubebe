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
S101S040102.jsp
납품정보 수정 
*/
	String loginID = session.getAttribute("login_id").toString();
	String member_key = session.getAttribute("member_key").toString();
	DoyosaeTableModel TableModel;
	String zhtml = "";
	
// 	String[] strColumnHead 	= {"주문번호", "제품코드", "제품명","BOMCD","order_detail_seq","프로젝트명","제품시리얼번호","고객사PO","납기일","lotno","otcount","sys_bom_id"};	
// 	int[]   colOff 			= {10, 10, 25,  0,0,0,1,1,0,0,0,0};
// 	String[] TR_Style		= {""," onclick='OrderInfoViewEvent(this)' "};
// 	String[] TD_Style		= {"","","","","","","","",""};  //strColumnHead의 수만큼
// 	String[] HyperLink		= {"","","","","","","","",""}; //strColumnHead의 수만큼
// 	String RightButton[][]	= {{"off", "fn_Chart_View", rightbtnChartShow},{"off", "fn_Doc_Reg()", rightbtnDocSave},{"off", "file_real_name", rightbtnDocShow}};


	String GV_ORDERNO="", GV_ORDER_DETAIL_SEQ="", GV_CHULHANO="", GV_JSPPAGE="", 
			GV_LOTNO="",GV_PROD_CD="",GV_PROD_REV="";
	
	if(request.getParameter("OrderNo")== null)
		GV_ORDERNO = "";
	else
		GV_ORDERNO = request.getParameter("OrderNo");	

	if(request.getParameter("OrderDetail")== null)
		GV_ORDER_DETAIL_SEQ="";
	else
		GV_ORDER_DETAIL_SEQ = request.getParameter("OrderDetail");
	
	if(request.getParameter("ChulhaNo")== null)
		GV_CHULHANO="";
	else
		GV_CHULHANO = request.getParameter("ChulhaNo");
	
	if(request.getParameter("jspPage")== null)
		GV_JSPPAGE="";
	else
		GV_JSPPAGE = request.getParameter("jspPage");	

	if(request.getParameter("LotNo")== null)
		GV_LOTNO="";
	else
		GV_LOTNO = request.getParameter("LotNo");
	
	if(request.getParameter("prod_cd")== null)
		GV_PROD_CD="";
	else
		GV_PROD_CD = request.getParameter("prod_cd");
	
	if(request.getParameter("prod_rev")== null)
		GV_PROD_REV="";
	else
		GV_PROD_REV = request.getParameter("prod_rev");

%>
    
    <script type="text/javascript">
//     웹소켓 통신을 위해서 필요한 변수들 ---시작
	var M101S020100E122 = {
			PID:  "M101S020100E122", 
			totalcnt: 0,
			retnValue: 999,
			colcnt: 0,
			colname: ["","","",""], //insert, Update, Delete 문장을 처리할 때는 사용되지않음
			data: []
	};  
	
	var SQL_Param = {
			PID:  "M101S020100E122",
			excute: "queryProcess",
			stream: "N",
			param: ""
	};
	var GV_RECV_DATA = "";	//웹소켓 onMessage(event)들어온 데이터를 받는 변수
//  웹소켓 통신을 위해서 필요한 변수들 ---끝	

    var JOB_GUBUN = "";

	var vTableS101S040145;
    var S101S040145_Row_index = -1;
	var TableS101S040145_info;
    var TableS101S040145_RowCount;
    var TableS101S040145_Prev_RowCount = 0;
    
    $(document).ready(function () {
        $("#write_date").datepicker({
        	format: 'yyyy-mm-dd',
        	autoclose: true,
        	language: 'ko'
        });
        $('#ipgo_date').datepicker({
        	format: 'yyyy-mm-dd',
        	autoclose: true,
        	language: 'ko'
        });
        $("#inspect_end_date").datepicker({
        	format: 'yyyy-mm-dd',
        	autoclose: true,
        	language: 'ko'
        });
        $('#ingae_date').datepicker({
        	format: 'yyyy-mm-dd',
        	autoclose: true,
        	language: 'ko'
        });
        var today = new Date();
        var fromday = new Date();
        fromday.setDate(today.getDate());
        
        $('#ipgo_date').datepicker('update', fromday);
        $('#ingae_date').datepicker('update', today);
        $('#inspect_end_date').datepicker('update', today);
        $('#write_date').datepicker('update', today);
		
        fn_Chulha_List();
    });	
    
    function fn_Chulha_List(){
    	$.ajax({
	        type: "POST",
	        url: "<%=Config.this_SERVER_path%>/Contents/Business/M101/S101S040145.jsp",  
	        data: "order_no=" +  '<%=GV_ORDERNO%>' + "&order_detail_seq=" + '<%=GV_ORDER_DETAIL_SEQ%>' 
	        		+ "&mode=complete" + "&lotno=" + '<%=GV_LOTNO%>'
	        		+ "&prod_cd=" + '<%=GV_PROD_CD%>' + "&prod_rev=" + '<%=GV_PROD_REV%>',
	        beforeSend: function () {
	            $("#inspect_body").children().remove();
	        },
	        success: function (html) {
	            $("#inspect_body").hide().html(html).fadeIn(100);
	        },
	        error: function (xhr, option, error) {
	        }
 		});
    }
	
	function SaveOderInfo() {
		var chekrtn = confirm("완료하시겠습니까?"); 
		var WebSockData="";
		var len = $("#product_tbody tr").length;
		
		var parmHead= '<%=Config.HEADTOKEN %>' ;
		if(chekrtn){
				parmHead += '<%=GV_JSPPAGE%>'					+ "|"
	    				  + '<%=loginID%>'						+ "|"	
	    				  + $('#txt_order_no').val()			+ "|"
	    				  + $('#txt_order_detail_seq').val()	+ "|"	//주문상세번호
	    				  + '0' 								+ "|" 	//indGB
	    				  + '<%=GV_LOTNO%>'						+ "|" ;	//lotno
				parmHead += '<%=member_key%>' + "|" + '<%=Config.DATATOKEN %>'	;
	
			SQL_Param.param = parmHead ;
			SendTojsp(urlencode(SQL_Param.param), SQL_Param.PID);
			
		}
	}
    
	function SendTojsp(bomdata, pid){
	    $.ajax({
	         type: "POST",
	         url: "<%=Config.this_SERVER_path%>/Contents/CommonView/insert_update_delete.jsp", 
	         data:  "bomdata=" + bomdata + "&pid=" + pid,
	         beforeSend: function () {
	         	 //alert(bomdata);
	         },
	         success: function (html) {	
	        	 if(html>-1){
	        		 parent.fn_MainInfo_List();
	        		vChulhaNo = "";
	        		parent.DetailInfo_List.click();
	        		parent.$("#ReportNote").children().remove();
	         		parent.$('#modalReport').hide();
	         	}
	         },
	         error: function (xhr, option, error) {

	         }
	     });		
	} 
	
    </script>

	<table class="table table-bordered" style="width: 100%; margin: 0 auto; align:center">
		<tr style="background-color: #fff; ">
            <td style="width: 6.66%; font-weight: 900; font-size:14px; vertical-align: middle ;text-align:left">주문명</td>
            <td style="width: 10%; font-weight: 900; font-size:14px; vertical-align: middle ;text-align:left">
            	<input type="text" class="form-control" maxlength="50" id="txt_project_name"  readonly></input>
            </td>            
            <td style="width: 6.66%; font-weight: 900; font-size:14px; vertical-align: middle ;text-align:left">고객사</td>
            <td style="width: 10%; font-weight: 900; font-size:14px; vertical-align: middle ;text-align:left">
            	<input type="text" class="form-control" maxlength="50" id="txt_cust_nm"  readonly></input>
            </td>
<!--             <td style="width: 6%; font-weight: 900; font-size:14px; vertical-align: middle ;text-align:left">시리얼 No</td> -->
<!--             <td style="width: 8%; font-weight: 900; font-size:14px; vertical-align: middle ;text-align:left"> -->
<!--             	<input type="text" class="form-control" maxlength="50" id="txt_product_serial_no"  readonly></input> -->
<!--             </td> -->
            <td style="width: 6.66%; font-weight: 900; font-size:14px; vertical-align: middle ;text-align:left">고객사 Po</td>
            <td style="width: 10%; font-weight: 900; font-size:14px; vertical-align: middle ;text-align:left">
            	<input type="text" class="form-control" maxlength="50" id="txt_cust_pono"  readonly></input>
            </td>
            <td style="width: 9%; font-weight: 900; font-size:14px; vertical-align: middle ;text-align:left">프로젝트 수량</td>
            <td style="width: 5%; font-weight: 900; font-size:14px; vertical-align: middle ;text-align:left">
            	<input type="text" class="form-control" maxlength="50" id="txt_project_cnt"  readonly></input>
            </td>
            <td style="width: 9%; font-weight: 900; font-size:14px; vertical-align: middle ;text-align:left">LOT수량</td>
            <td style="width: 5%; font-weight: 900; font-size:14px; vertical-align: middle ;text-align:left">
            	<input type="text" class="form-control" maxlength="50" id="txt_order_count"  readonly></input>
            </td>
            <td style="width: 6%; font-weight: 900; font-size:14px; vertical-align: middle ;text-align:left">주문번호</td>
            <td style="width: 16%; font-weight: 900; font-size:14px; vertical-align: middle ;text-align:left">
            	<input type="text" class="form-control" maxlength="50" id="txt_order_no"  readonly></input>
            </td>
		</tr>
		<tr  style="background-color: #fff; ">
			<td style="font-weight: 900; font-size:14px; vertical-align: middle ; text-align:left">주문비고</td>
            <td colspan="5"><textarea class="form-control" id="txt_order_bigo" style="height:82px;resize: none;" readonly></textarea></td>
            <td style="font-weight: 900; font-size:14px; vertical-align: middle ; text-align:left">납품비고</td>
            <td colspan="5"><textarea class="form-control" id="txt_chulha_bigo" style="height:82px;resize: none;" readonly></textarea></td>
        </tr>        
      	</table>
        <table class="table table-striped" style="width: 100%; margin: 0 ; align:center ;" id="bom_table">
	        <tr style="vertical-align: middle">
	            <td style="width: 12.5%; font-weight: 900; font-size:14px; text-align:center; vertical-align: middle">제품명</td>
	            <td style="width: 12.5%; font-weight: 900; font-size:14px; text-align:center; vertical-align: middle">제품코드</td>
	            <td style="width: 12.5%; font-weight: 900; font-size:14px; text-align:center; vertical-align: middle">Lot No</td>
<!-- 	            <td style="width: 12.5%; font-weight: 900; font-size:14px; text-align:center; vertical-align: middle">납품수량</td> -->
				<td style="width: 12.5%; font-weight: 900; font-size:14px; text-align:center; vertical-align: middle">일련번호</td>
				<td style="width: 12.5%; font-weight: 900; font-size:14px; text-align:center; vertical-align: middle">출고 수량</td>
	            <td style="width: 12.5%; font-weight: 900; font-size:14px; text-align:center; vertical-align: middle">단위</td>
	            <td style="width: 12.5%; font-weight: 900; font-size:14px; text-align:center; vertical-align: middle">단가</td>
	            <td style="width: 12.5%; font-weight: 900; font-size:14px; text-align:center; vertical-align: middle">금액</td>
<!-- 	            <td style="width: 11.11%; vertical-align: middle"></td> -->
	        </tr>
	        <tbody id="bom_head_tbody">
	        <tr style="vertical-align: middle">
	        	<td style="text-align:center; vertical-align: middle ;margin: 0 ;">
	        		<input type="hidden" class="form-control" id="txt_chulha_no" readonly></input>
	        		<input type="hidden" class="form-control" id="txt_chulha_seq" readonly></input>
	        		<input type="hidden" class="form-control" id="txt_order_detail_seq" readonly></input>
	        		<input type="hidden" class="form-control" id="txt_prod_rev" readonly></input>
	        		<input type="hidden" class="form-control" id="txt_cust_cd" readonly></input>
	        		<input type="hidden" class="form-control" id="txt_cust_rev" readonly></input>
	        		<input type="hidden" class="form-control" id="txt_chuha_dt" readonly></input>
	        		<input type="hidden" class="form-control" id="txt_chulha_user_id" readonly></input>
	        		<input type="hidden" class="form-control" id="txt_delivery_date" readonly></input>
	        		<input type="hidden" class="form-control" id="txt_order_date" readonly></input>
	        		<input type="text" class="form-control" id="txt_product_nm" readonly></input>					
				</td>		           
				<td style="text-align:right;vertical-align: middle ;margin: 0 ;">
					<input type="text" class="form-control" id="txt_prod_cd"  readonly></input> 
	           	</td>
	        	<td style="text-align:center; vertical-align: middle ;margin: 0 ;">
					<input type="text" 	 class="form-control" id="txt_lotno" readonly></input>
				</td>
	            <td style="text-align:center; vertical-align: middle ;margin: 0 ;">
					<input type="hidden" 	 class="form-control" id="txt_lot_count" readonly ></input> 
 					<input type="hidden" class="form-control" maxlength="50" id="txt_product_serial_no_end"  readonly></input>
					<input type="text" class="form-control" maxlength="50" id="txt_product_serial_no"  readonly></input>	           
	           	</td>
	            <td style="text-align:center; vertical-align: middle ;margin: 0 ;">
					<input type="text" 	 class="form-control" id="txt_chulha_cnt" readonly ></input>	           
	           	</td>
	            <td style="text-align:center; vertical-align: middle ;margin: 0 ;">
					<input type="text" class="form-control" id="txt_chulha_unit" readonly></input>
	           	</td>
	            <td style="text-align:center; vertical-align: middle ;margin: 0 ;">
					<input type="text" class="form-control"  id="txt_chulha_unit_price" readonly></input>
	           	</td>
	           	<td style="text-align:center; vertical-align: middle ;margin: 0 ;">
					<input type="text" class="form-control"  id="txt_chulha_amount" readonly></input>
	           	</td>
<!-- 	            <td style="text-align:center; vertical-align: middle ;margin: 0 ;"> -->
<!-- 	            	<button id="btn_plus" class="form-control btn btn-info" >삭제</button> -->
<!-- 	            </td> -->
	        </tr>
	        </tbody>
	    </table>
		<table style="width: 100%;">
			<tr>
				<td>
					<div>
						<div id="inspect_body" style="width:100%; float:left;"></div>
					</div>
				</td>
			</tr>
			<tr style="height: 60px;">
				<td style="text-align:center;">
					<p>
                		<button id="btn_Save"  class="btn btn-info"  onclick="SaveOderInfo();">처리완료</button>
                		<button id="btn_Canc"  class="btn btn-info"  onclick="parent.$('#modalReport').hide();">닫기</button>
            		</p>
				</td>
            </tr>
        </table>
		