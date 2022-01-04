<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*,java.util.*,javax.servlet.http.*"%>
<%@ page import="mes.client.comm.*" %>
<%@ page import="mes.client.common.*" %>
<%@ page import="mes.client.guiComponents.*" %>
<%@ page import="mes.client.util.*" %>
<%@ page import="mes.client.conf.*" %>
<!DOCTYPE html>

<%
/* 
S202S120101.jsp
자재출고 등록 
*/
	String loginID = session.getAttribute("login_id").toString();
	String member_key = session.getAttribute("member_key").toString();
	DoyosaeTableModel TableModel;
	String zhtml = "";
	
 	//String[] strColumnHead 	= {};	
// 	int[]   colOff 			= {10, 10, 25,  0,0,0,1,1,0,0,0,0};
// 	String[] TR_Style		= {""," onclick='OrderInfoViewEvent(this)' "};
// 	String[] TD_Style		= {"","","","","","","","",""};  //strColumnHead의 수만큼
// 	String[] HyperLink		= {"","","","","","","","",""}; //strColumnHead의 수만큼
// 	String RightButton[][]	= {{"off", "fn_Chart_View", rightbtnChartShow},{"off", "fn_Doc_Reg()", rightbtnDocSave},{"off", "file_real_name", rightbtnDocShow}};


	String GV_PART_CD="", GV_ORDER_DETAIL_SEQ="", GV_JSPPAGE="", GV_NUM_GUBUN="";
	
	if(request.getParameter("PartCd")== null)
		GV_PART_CD = "";
	else
		GV_PART_CD = request.getParameter("PartCd");
	
	if(request.getParameter("order_detail_seq")== null)
		GV_ORDER_DETAIL_SEQ="";
	else
		GV_ORDER_DETAIL_SEQ = request.getParameter("order_detail_seq");
	

	if(request.getParameter("jspPage")== null)
		GV_JSPPAGE="0";
	else
		GV_JSPPAGE = request.getParameter("jspPage");	

	if(request.getParameter("num_gubun")== null)
		GV_NUM_GUBUN="";
	else
		GV_NUM_GUBUN = request.getParameter("num_gubun");
	
// 	String param =GV_ORDERNO+ "|" ;
	
    // TableModel = new DoyosaeTableModel("M202S120100E144", strColumnHead, param);
//  	int RowCount =TableModel.getRowCount();
  		
%>
    
    <script type="text/javascript">
//     웹소켓 통신을 위해서 필요한 변수들 ---시작
	var M202S020100E101 = {
			PID:  "M202S120100E202", 
			totalcnt: 0,
			retnValue: 999,
			colcnt: 0,
			colname: ["","","",""], //insert, Update, Delete 문장을 처리할 때는 사용되지않음
			data: []
	};  
	
	var SQL_Param = {
			PID:  "M202S120100E202",
			excute: "queryProcess",
			stream: "N",
			param: ""
	};
	var GV_RECV_DATA = "";	//웹소켓 onMessage(event)들어온 데이터를 받는 변수
//  웹소켓 통신을 위해서 필요한 변수들 ---끝	

    var JOB_GUBUN = "";
    

	var vTableS202S120120;
	var TableS202S120120_info;
    var TableS202S120120_RowCount;
    var S202S120120_Row_index = -1;    

    var vTableS202S120240;
	var TableS202S120240_info;
    var TableS202S120240_RowCount;
    var S202S120240_Row_index = -1;    

    var ioSeq_Max = 0;
//     var balju_inspect_no="";
    
    $(document).ready(function () {

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
	    
	    $("#btn_plus").click(function(){ 
	    	fn_Update_body(this); 
	    }); 
	    	    
	    $("#right_btn").click(function(){ 
	    	fn_mius_body(this); 
	    }); 

<%-- 		$('#txt_order_no').val('<%=GV_ORDERNO%>'); --%>
<%-- 		$('#txt_order_detail_seq').val('<%=GV_ORDER_DETAIL_SEQ%>'); --%>
       
// 		 $.ajax({
// 		        type: "POST",
<%-- 	            url: "<%=Config.this_SERVER_path%>/Contents/Business/M202/S202S120120.jsp",  --%>
<%-- 		        data: "order_no=" + '<%=GV_ORDERNO%>' + "&caller=" + "S202S020101",  --%>
// 		        beforeSend: function () {
// 		            $("#Balju_body").children().remove();
// 		        },
// 		        success: function (html) {
// 		            $("#Balju_body").hide().html(html).fadeIn(100);
// 		        },
// 		        error: function (xhr, option, error) {
// 		        }
// 	 		});
		 
        $.ajax({
	        type: "POST",
            url: "<%=Config.this_SERVER_path%>/Contents/Business/M202/S202S120240.jsp", 
	        data: "part_cd=" + "<%=GV_PART_CD%>" , 
	        beforeSend: function () {
	            $("#inspect_body").children().remove();
	        },
	        success: function (html) {
	            $("#inspect_body").hide().html(html).fadeIn(100);
	        },
	        error: function (xhr, option, error) {
	        }
 		});
    });	

	
	function SaveOderInfo() {        
		var WebSockData="";

		TableS202S120240_info = vTableS202S120240.page.info();
        TableS202S120240_RowCount = TableS202S120240_info.recordsTotal;
        
        var parmHead= "" 
			+ '<%=GV_JSPPAGE%>' 				+ "|"
			+ '<%=loginID%>' 					+ "|" 	//1
			+ '<%=GV_NUM_GUBUN%>' 				+ "|" 
			+ $('#txt_part_cd').val()			+ "|"
			+ $('#txt_partcd_bunho').val()		+ "|"
			+ '<%=member_key%>' 				+ "|"
			+ "<%=Config.HEADTOKEN %>"  	;

		var parmBody= "" ;
	    for(var i=0; i<TableS202S120240_RowCount; i++){   
	    	parmBody += vTableS202S120240.cell(i , 0).data() + "|"	//0 주문번호
	    	+ vTableS202S120240.cell(i , 1).data() + "|"	//1 출고번호
	    	+ vTableS202S120240.cell(i , 2).data() + "|"	//2 출고일자
	    	+ vTableS202S120240.cell(i , 3).data() + "|"	//3 출고일련번호					
	    	+ vTableS202S120240.cell(i , 4).data() + "|"	//4 출고시간
	    	+ vTableS202S120240.cell(i , 5).data() + "|"	//5 출고담당자
	    	+ vTableS202S120240.cell(i , 6).data() + "|"	//6 원부자재명
	    	+ vTableS202S120240.cell(i , 7).data() + "|"	//7 원부자재코드\
	    	+ vTableS202S120240.cell(i , 8).data() + "|"	//8 원부자재개정번호
	    	+ vTableS202S120240.cell(i , 9).data() + "|"	//9 창고번호
	    	+ vTableS202S120240.cell(i , 10).data() + "|"	//10 렉번호
	    	+ vTableS202S120240.cell(i , 11).data() + "|"	//11 선반번호
	    	+ vTableS202S120240.cell(i , 12).data() + "|"	//12 칸번호
	    	+ vTableS202S120240.cell(i , 13).data() + "|"	//13 출고 전 재고량
	    	+ vTableS202S120240.cell(i , 14).data() + "|"	//14 출고 후 재고량
 	    	+ vTableS202S120240.cell(i , 15).data() + "|"	//15 입출고 수량
			+ '<%=member_key%>'		 				+ "|"
			+ '<%=Config.DATATOKEN %>';
	    }
		SQL_Param.params = parmHead + parmBody;
		//E101
		SendTojsp((urlencode(SQL_Param.params), SQL_Param.PID);
		//E111
		/* SendTojsp(SQL_Param.params, M202S020100E101.UPID);
		 */
	}
    
	function SendTojsp(bomdata, pid){
		
	    $.ajax({
	         type: "POST",
	         url: "<%=Config.this_SERVER_path%>/Contents/CommonView/insert_update_delete.jsp", 
	         data:  "bomdata=" + bomdata + "&pid=" + pid,
	         beforeSend: function () {
// 	         	 alert(bomdata);
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
 
    function fn_Update_body(obj){  	
    	if(S202S120240_Row_index == -1){
    		vTableS202S120240.row.add( [
    			$('#txt_ipgo_order').val(),
    			$('#txt_ipgo_no').val(),
    			$('#txt_ipgo_date').val(),
    			++ioSeq_Max,
    			$('#txt_io_time').val(),
    			$('#txt_io_user_id').val(),
    			$('#txt_part_name').val(),
    			$('#txt_part_cd').val(),
    			$('#txt_partcd_bunho').val(),
    			$('#txt_store_no').val(),
    			$('#txt_rakes_no').val(),
    			$('#txt_plate_no').val(),
    			$('#txt_colm_no').val(),
    			$('#txt_pre_amt').val() ,
    			$('#txt_io_amt').val() ,
    			$('#txt_post_amt').val(),
    			''
    			
// 				$('#txt_balju_inspect_no').val(),
//     			'';
	        ] ).draw(true);
    		
    	}
    	else{
    		vTableS202S120240.cell( S202S120240_Row_index, 0).data( $('#txt_ipgo_order').val() );
    		vTableS202S120240.cell( S202S120240_Row_index, 1).data( $('#txt_ipgo_no').val() );
			vTableS202S120240.cell( S202S120240_Row_index, 2).data( $('#txt_ipgo_date').val() );
			vTableS202S120240.cell( S202S120240_Row_index, 3).data( $('#txt_io_seqno').val() );
			vTableS202S120240.cell( S202S120240_Row_index, 4).data( $('#txt_io_time').val() );
			vTableS202S120240.cell( S202S120240_Row_index, 5).data( $('#txt_io_user_id').val() );
			vTableS202S120240.cell( S202S120240_Row_index, 6).data( $('#txt_part_name').val() );
			vTableS202S120240.cell( S202S120240_Row_index, 7).data( $('#txt_part_cd').val() );
			vTableS202S120240.cell( S202S120240_Row_index, 8).data( $('#txt_partcd_bunho').val() );
			vTableS202S120240.cell( S202S120240_Row_index, 9).data( $('#txt_store_no').val() );
			vTableS202S120240.cell( S202S120240_Row_index, 10).data( $('#txt_rakes_no').val() );
			vTableS202S120240.cell( S202S120240_Row_index, 11).data( $('#txt_plate_no').val() );
			vTableS202S120240.cell( S202S120240_Row_index, 12).data( $('#txt_colm_no').val() );
			vTableS202S120240.cell( S202S120240_Row_index, 13).data( $('#txt_pre_amt').val() );
			vTableS202S120240.cell( S202S120240_Row_index, 14).data( $('#txt_io_amt').val() );
			vTableS202S120240.cell( S202S120240_Row_index, 15).data( $('#txt_post_amt').val() );

    	}
    	vTableS202S120240.draw();
	    clear_input(); 
    }  
    
	function clear_input(){
		$('#txt_part_name').val("");
		//$('#txt_part_cd').val("");
		$('#txt_request_cnt').val("");
		$('#txt_store_no').val("");
		$('#txt_rakes_no').val("");
		$('#txt_plate_no').val("");
		$('#txt_colm_no').val("");
		$('#txt_pre_amt').val("");
		$('#txt_io_amt').val("");
		$('#txt_post_amt').val("");
//		$('#txt_part_amt').val("");	
//		$('#txt_rev').val("");	
//		$('#txt_part_cd_rev').val("");	
// 		$('#txt_balju_inspect_no').val("");	
	}        		
    
    function fn_mius_body(obj){
    	var tr = $(obj).parent();
    	var tbody = $(tr).parent();
    	var trNum = $(tbody).closest('tr').prevAll().length;
		
		console.log(trNum + "==fn_Update_body=" + S202S120240_Row_index); 
    	vTableS202S120240.row(S202S120240_Row_index ).remove().draw();
//     	vTableS202S120240.row(trNum ).remove().draw();

	    TableS202S120240_info = vTableS202S120240.page.info();
	    TableS202S120240_RowCount = TableS202S120240_info.recordsTotal;
	    
		for(var i =0; i<TableS202S120240_RowCount; i++){
		    vTableS202S120240.cell( i, 3 ).data( i+1 );
		}	        
    }
    function sum(obj){
    	if($("#txt_pre_amt").val()==""){$("#txt_pre_amt").val(0);}
    	var pre_amt = parseInt($("#txt_pre_amt").val());
    	var io_count = parseInt($("#txt_io_amt").val());
    	$('#txt_post_amt').val(pre_amt - io_count);
    } 
    
    
    </script>

<!-- 	<div> -->
		 
        <table class="table table-striped" style="width: 100%; margin: 0 ; align:left ;" id="bom_table">
 			
	        <tr style="vertical-align: middle">
<!-- 	            <td style="width:  3%; font-weight: 900; font-size:14px; text-align:center; vertical-align: middle">순번</td> -->
	            <td style="width: 12%; font-weight: 900; font-size:14px; text-align:center; vertical-align: middle">제품명</td>
	            <td style="width: 12%; font-weight: 900; font-size:14px; text-align:center; vertical-align: middle ">제품코드</td>
	            <td style="width: 5%; font-weight: 900; font-size:14px; text-align:center; vertical-align: middle">창고</td>
	            <td style="width: 5%; font-weight: 900; font-size:14px; text-align:center; vertical-align: middle">렉</td>
	            <td style="width:5%; font-weight: 900; font-size:14px; text-align:center; vertical-align: middle">선반</td>
	            <td style="width:5%; font-weight: 900; font-size:14px; text-align:center; vertical-align: middle">칸</td>
	            <td style="width:5.5%; font-weight: 900; font-size:14px; text-align:center; vertical-align: middle">출고전재고</td>
	            <td style="width:5.5%; font-weight: 900; font-size:14px; text-align:center; vertical-align: middle">출고수량</td>
	            <td style="width:6%; font-weight: 900; font-size:14px; text-align:center; vertical-align: middle">출고후재고</td>
<!-- 	            <td style="width:3.5%; font-weight: 900; font-size:14px; text-align:center; vertical-align: middle">단가</td> -->
<!-- 	            <td style="width:3.5%; font-weight: 900; font-size:14px; text-align:center; vertical-align: middle">금액</td> -->
<!-- 	            <td style="width:3.5%; font-weight: 900; font-size:14px; text-align:center; vertical-align: middle">Rev.</td> -->
	             <td style="width:  6%;vertical-align: middle"></td> 
	        </tr>
		
	        <tbody id="bom_head_tbody">
	        <tr style="vertical-align: middle">	
	        	<!-- <td style="text-align:center; vertical-align: middle ;margin: 0 ;">
					<input type="text" class="form-control" id="txt_balju_seq" readonly></input>					
				</td> -->		           		            
	        	<td style="text-align:center; vertical-align: middle ;margin: 0 ;">
	        		<input type="hidden" class="form-control" id="txt_ipgo_order" readonly></input>
					<input type="hidden" class="form-control" id="txt_ipgo_no" readonly></input>
					<input type="hidden" class="form-control" id="txt_ipgo_date" readonly></input>
					<input type="hidden" class="form-control" id="txt_io_seqno" readonly></input>
					<input type="hidden" class="form-control" id="txt_io_time" readonly></input>
					<input type="hidden" class="form-control" id="txt_io_user_id" readonly></input>
					
					
					<input type="hidden" class="form-control" id="txt_order_seq" readonly></input>
					<input type="hidden" class="form-control"  id="txt_bom_cd"  readonly></input>
					<input type="hidden" 	 	class="form-control"  id="txt_bom_nm" readonly></input>
					<input type="text" class="form-control" maxlength="20"  id="txt_part_name" readonly></input>					
				</td>		           
				
				<td style="text-align:center; vertical-align: middle ;margin: 0 ;">
					<input type="text" 	 class="form-control" maxlength="20" id="txt_part_cd" readonly ></input> 
	           	</td>
	           	
	            <td style="text-align:center; vertical-align: middle ;margin: 0 ;">
					
	           		<input type="text" 	 class="form-control" maxlength="20" id="txt_store_no"  ></input>
	           	</td>
	           	<td style="text-align:center; vertical-align: middle ;margin: 0 ;">
					 <input type="text" 	 class="form-control" maxlength="20" id="txt_rakes_no"  ></input>       
	           	</td>
	            <td style="text-align:center; vertical-align: middle ;margin: 0 ;">
					<input type="text" 	 class="form-control" maxlength="20" id="txt_plate_no"  ></input>
	           	</td>

	            <td style="font-weight: 900; font-size:14px; text-align:center; vertical-align: middle ;margin: 0 ;">
	            	<input type="hidden"  id="txt_partcd_bunho" class="form-control"  readonly/>
	            	<input type="text" 	 class="form-control" maxlength="20" id="txt_colm_no"  ></input>
	            </td>
	            <td style="text-align:center; vertical-align: middle ;margin: 0 ;">
					<input type="text" 	 class="form-control" maxlength="20" id="txt_pre_amt" readonly ></input>
	           	</td>
	           	<td style="text-align:center; vertical-align: middle ;margin: 0 ;">
					<input type="text" 	 class="form-control" maxlength="20" id="txt_io_amt" onchange="sum(this)" ></input>
	           	</td>
	           	<td style="text-align:center; vertical-align: middle ;margin: 0 ;">
					<input type="text" 	 class="form-control" maxlength="20" id="txt_post_amt" readonly></input>
					<input type="hidden" class="form-control"  id="txt_inspect_cnt" ></input>					
	            	<input type="hidden"  id="txt_error_cnt" class="form-control"  readonly/>
	            	<input type="hidden"   id="txt_write_date" class="form-control"  readonly/>
	            	<input type="hidden"   id="txt_pass_yn" class="form-control" readonly/>
	           	</td>
	           

<!-- 	            <td style="text-align:center; vertical-align: middle ;margin: 0 ;"> -->
<!-- 	            	<input type="text"  maxlength="5" id="txt_unit_price" class="form-control"  readonly/> -->
<!-- 	            </td> -->
<!-- 	            <td style="text-align:center; vertical-align: middle ;margin: 0 ;"> -->
<!-- 	            	<input type="text"  maxlength="5" id="txt_part_amt" class="form-control"  readonly/> -->
<!-- 	            </td> -->
	            
<!-- 	            <td style="text-align:center; vertical-align: middle ;margin: 0 ;"> -->
<!-- 	            	<input type="text"  maxlength="10" id="txt_rev" class="form-control" readonly/> -->
<!-- 	            </td> -->
	            <td style="text-align:center; vertical-align: middle ;margin: 0 ;">
	            	<button id="btn_plus" class="form-control btn btn-info" >수정</button></td>
	        </tr>
	        </tbody>
	    </table>

<!-- 	</div>         -->
		<div>
			<div id="Balju_body" style="width:0%; float:left">
			</div>
			<div id="inspect_body" style="width:100%; float:left">
			</div>
			
			
		</div>
		<div style="width:100%;clear:both">
        <p style="text-align:center;">
        	<button id="btn_Save"  class="btn btn-info"  onclick="SaveOderInfo();">자재출고수정</button>
	        <button id="btn_Canc"  class="btn btn-info"  onclick="parent.$('#modalReport').hide();">취소</button>
        </p>
	</div>