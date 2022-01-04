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
S202S020111.jsp
수입검사신청 등록 
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


	String GV_ORDERNO="", GV_ORDER_DETAIL_SEQ="", GV_JSPPAGE="", GV_NUM_GUBUN="",GV_LOTNO="",GV_BALJUNO="";
	
	if(request.getParameter("OrderNo")== null)
		GV_ORDERNO = "";
	else
		GV_ORDERNO = request.getParameter("OrderNo");	
	
	if(request.getParameter("order_detail_seq")== null)
		GV_ORDER_DETAIL_SEQ="";
	else
		GV_ORDER_DETAIL_SEQ = request.getParameter("order_detail_seq");
	

	if(request.getParameter("jspPage")== null)
		GV_JSPPAGE="";
	else
		GV_JSPPAGE = request.getParameter("jspPage");	

	if(request.getParameter("num_gubun")== null)
		GV_NUM_GUBUN="";
	else
		GV_NUM_GUBUN = request.getParameter("num_gubun");
	
	if(request.getParameter("LotNo")== null)
		GV_LOTNO="";
	else
		GV_LOTNO = request.getParameter("LotNo");
	
	if(request.getParameter("BaljuNo")== null)
		GV_BALJUNO="";
	else
		GV_BALJUNO = request.getParameter("BaljuNo");
	
// 	String param =GV_ORDERNO+ "|" ;
	
//     TableModel = new DoyosaeTableModel("M202S020100E714", strColumnHead, param);
//  	int RowCount =TableModel.getRowCount();
  		
%>
    
    <script type="text/javascript">
//     웹소켓 통신을 위해서 필요한 변수들 ---시작
	var M202S020100E111 = {
			PID:  "M202S020100E111", 
			UPID: "M202S020100E112",  
			totalcnt: 0,
			retnValue: 999,
			colcnt: 0,
			colname: ["","","",""], //insert, Update, Delete 문장을 처리할 때는 사용되지않음
			data: []
	};  
	
	var SQL_Param = {
			excute: "queryProcess",
			stream: "N",
			param: ""
	};
	var GV_RECV_DATA = "";	//웹소켓 onMessage(event)들어온 데이터를 받는 변수
//  웹소켓 통신을 위해서 필요한 변수들 ---끝	

    var JOB_GUBUN = "";
    

	var vTableS202S020136;
	var TableS202S020136_info;
    var TableS202S020136_RowCount;
    var S202S020136_Row_index = -1;    

	var vTableS202S020135;
    var S202S020135_Row_index = -1;
	var TableS202S020135_info;
    var TableS202S020135_RowCount;
    
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
        
	    $("#btn_plus_all").click(function(){ 
	    	fn_btn_plus_all_body(this); 
	    }); 

	    $("#btn_plus").click(function(){ 
	    	fn_Update_body(this); 
	    }); 
	    
	    $("#right_btn").click(function(){ 
	    	fn_mius_body(this); 
	    }); 

		$('#txt_order_no').val('<%=GV_ORDERNO%>');
		$('#txt_order_detail_seq').val('<%=GV_ORDER_DETAIL_SEQ%>');
        $.ajax({
	        type: "POST",
	        async: false,
            url: "<%=Config.this_SERVER_path%>/Contents/Business/M202/S202S020136.jsp", 
	        data: "order_no=" + '<%=GV_ORDERNO%>'+"&balju_no="+ '<%=GV_BALJUNO%>' + "&caller=" + "S202S020101", 
	        beforeSend: function () {
	            $("#Balju_body").children().remove();
	        },
	        success: function (html) {
	            $("#Balju_body").hide().html(html).fadeIn(100);
	        },
	        error: function (xhr, option, error) {
	        }
 		});

        $.ajax({
	        type: "POST",
	        async: false,
            url: "<%=Config.this_SERVER_path%>/Contents/Business/M202/S202S020135.jsp", 
	        data: "order_no=" +  '<%=GV_ORDERNO%>'+"&balju_no="+ '<%=GV_BALJUNO%>'   , 
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

		TableS202S020135_info = vTableS202S020135.page.info();
        TableS202S020135_RowCount = TableS202S020135_info.recordsTotal;
        
        var qa = $(':input[name="QA"]:radio:checked').val();
        if(qa) valQA = qa
        else valQA="N";

		var parmHead= "" 
			+ '<%=GV_JSPPAGE%>' 		+ "|"
			+ '<%=loginID%>' 			+ "|" 	//1
			+ '<%=GV_NUM_GUBUN%>' 		+ "|" 
			+ "<%=Config.HEADTOKEN %>" 	;
	

		var parmBody= "" ;
	    for(var i=0; i<TableS202S020135_RowCount; i++){   
	    	parmBody 	+=$('#txt_order_no').val()				+ "|"	// order_no			주문번호
				    	+ vTableS202S020135.cell(i , 0).data() 	+ "|"	// balju_no   
						+ $('#txt_order_detail_seq').val() 		+ "|" 	// order_detail_seq	주문상세번호
				    	+ vTableS202S020135.cell(i , 1).data() 	+ "|"	//1 balju_seq   순번					
				    	+ vTableS202S020135.cell(i , 3).data()  + "|"	//2 bom_cd 자료번호
				    	+ vTableS202S020135.cell(i , 2).data() + "|"	//1 bom_nm  자료이름
				    	+ vTableS202S020135.cell(i , 4).data() + "|"	//4 part_cd 파트코드
						+ $('#write_date').val() 	+ "|"		// write_date		 
						+ $('#ipgo_date').val() 	+ "|"		// ipgo_date	 
						+ $('#ingae_date').val() 	+ "|"		// ingae_date	 
						+ valQA 					+ "|" 		//inspect_report_yn
						+ $('#inspect_end_date').val()  + "|"	// inspect_end_date	 
						+ $('#txt_inspect_note').val()	+ "|"	// txt_inspect_note   
				    	+ vTableS202S020135.cell(i , 5).data() + "|"	//6 req_count 수량
				    	+ vTableS202S020135.cell(i , 6).data() + "|"	//0 part_cd_rev 구분
				    	+ '<%=GV_LOTNO%>' 		+ "|"				//lotno
						+ '<%=Config.DATATOKEN %>' 	;
	    }
		SQL_Param.params = parmHead + parmBody;

		SendTojsp(urlencode(SQL_Param.params), M202S020100E111.PID);
		
		
	}
    
	function SendTojsp(bomdata, pid){
		
	    $.ajax({
	         type: "POST",
	         url: "<%=Config.this_SERVER_path%>/Contents/CommonView/insert_update_delete.jsp", 
	         data:  "bomdata=" + bomdata + "&pid=" + pid,
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
    

    function fn_btn_plus_all_body(obj){  	

        $.ajax({
	        type: "POST",
            url: "<%=Config.this_SERVER_path%>/Contents/Business/M202/S202S020135.jsp", 
	        data: "order_no=" +  '<%=GV_ORDERNO%>'+"&balju_no="+ '<%=GV_BALJUNO%>'  + "&all=all", 
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
	
    function fn_Update_body(obj){  	
    	if(S202S020135_Row_index == -1){
    		vTableS202S020135.row.add( [
				$('#txt_balju_no').val(),
				$('#txt_balju_seq').val(),
				$('#txt_bom_nm').val(),
				 $('#txt_bom_cd').val(),
				$('#txt_part_cd').val(),
				$('#txt_request_cnt').val(),
				$('#txt_part_cd_rev').val(),
    			''
	        ] ).draw(true);
    		
    	}
    	else{
			vTableS202S020135.cell( S202S020135_Row_index, 0).data( $('#txt_balju_no').val() );
			vTableS202S020135.cell( S202S020135_Row_index, 1).data( $('#txt_balju_seq').val() );
			vTableS202S020135.cell( S202S020135_Row_index, 2).data( $('#txt_bom_nm').val() );
			vTableS202S020135.cell( S202S020135_Row_index, 3).data( $('#txt_bom_cd').val() );
			vTableS202S020135.cell( S202S020135_Row_index, 4).data( $('#txt_part_cd').val() );
			vTableS202S020135.cell( S202S020135_Row_index, 5).data( $('#txt_request_cnt').val() );
			vTableS202S020135.cell( S202S020135_Row_index, 6).data( $('#txt_part_cd_rev').val() );
    	}
    	vTableS202S020135.draw();
	    clear_input(); 
    }  
    
	function clear_input(){
		$('#txt_balju_no').val("");
		$('#txt_balju_seq').val("");
		$('#txt_bom_nm').val("");
		$('#txt_bom_cd').val("");
		$('#txt_part_cd').val("");
		$('#txt_inspect_cnt').val("");
		$('#txt_request_cnt').val("");
		$('#txt_part_cd_rev').val("");	
	}        		
    
    function fn_mius_body(obj){
    	var tr = $(obj).parent();
    	var tbody = $(tr).parent();
    	var trNum = $(tbody).closest('tr').prevAll().length;
		
// 		console.log(trNum + "==fn_Update_body=" + S202S020135_Row_index);
//     	vTableS202S020135.row(trNum ).remove().draw();

		vTableS202S020135.row($(obj).parents('tr')).remove().draw();
		
	    TableS202S020135_info = vTableS202S020135.page.info();
	    TableS202S020135_RowCount = TableS202S020135_info.recordsTotal;
	    
		for(var i =0; i<TableS202S020135_RowCount; i++){
		    vTableS202S020135.cell( i, 1 ).data( i+1 );
		}	        
    }       
    
    </script>

	<table class="table table-bordered" style="width: 100%; margin: 0 auto; align:center">
		<tr style="background-color: #fff; ">
            <td style="width: 10%; font-weight: 900; font-size:14px; vertical-align: middle ;text-align:left">작성일자</td>
            <td style="width: 20%; font-weight: 900; font-size:14px; vertical-align: middle ;text-align:left">
            	<input type="text" data-date-format="yyyy-mm-dd" id="write_date" class="form-control" readonly/>
					<input type="hidden" class="form-control" id="txt_order_no" readonly></input>
					<input type="hidden" class="form-control" id="txt_order_detail_seq" readonly></input>
			</td>
            <td style="width: 30%; font-weight: 1000; font-size:16px; vertical-align: middle ; text-align:left" colspan="2">
            수 입 검 사  요 청 서
           	</td>
            <td style="width: 40%; font-weight: 900; font-size:14px; vertical-align: middle ;text-align:left">검 사 내 용</td>
		</tr>
		<tr  style="background-color: #fff; ">
            <td style=" font-weight: 900; font-size:14px; vertical-align: middle ;text-align:left">입고일자</td>
            <td style=" font-weight: 900; font-size:14px; vertical-align: middle ;text-align:left">
            	<input type="text" data-date-format="yyyy-mm-dd" id="ipgo_date" class="form-control"  readonly/>
            </td>

            <td style="width: 10%;  font-weight: 900; font-size:14px; vertical-align: middle ; text-align:left">성적서</td>
            <td style="width: 20%; font-weight: 900; font-size:14px; vertical-align: middle ;text-align:left">
            	<input type="radio"  id="rdo_QA_report0"  name="QA" value="Y">유</input>
            	
            	<input type="radio"  id="rdo_QA_report1"  name="QA" value="N" style="margin-left:30px">무</input>
            </td>
            <td rowspan="2"><textarea class="form-control" id="txt_inspect_note" style="height:82px;resize: none;"></textarea></td>
        </tr>        
		<tr  style="background-color: #fff; ">
            <td style=" font-weight: 900; font-size:14px; vertical-align: middle ;text-align:left">인계일자</td>
            <td style=" font-weight: 900; font-size:14px; vertical-align: middle ;text-align:left">
            	<input type="text" data-date-format="yyyy-mm-dd" id="ingae_date" class="form-control"  readonly/>
            </td>
            <td style=" font-weight: 900; font-size:14px; vertical-align: middle ;text-align:left">검사완료날짜</td>
            <td style=" font-weight: 900; font-size:14px; vertical-align: middle ;text-align:left">
            	<input type="text" data-date-format="yyyy-mm-dd" id="inspect_end_date" class="form-control" readonly/>
            </td>            
        </tr> 	

      	</table> 
        <table class="table table-striped" style="width: 100%; margin: 0 ; align:center ;" id="bom_table">
 
	        <tr style="vertical-align: middle">
	            <td style="width:  3%; font-weight: 900; font-size:14px; text-align:center; vertical-align: middle">순번</td>
	            <td style="width: 16%; font-weight: 900; font-size:14px; text-align:center; vertical-align: middle">품명</td>
	            <td style="width: 16%; font-weight: 900; font-size:14px; text-align:center; vertical-align: middle">배합(BOM)번호</td>
	            <td style="width: 16%; font-weight: 900; font-size:14px; text-align:center; vertical-align: middle">원부자재코드</td>
	            <td style="width:5.5%; font-weight: 900; font-size:14px; text-align:center; vertical-align: middle">검수수량</td>
	            <td style="width:5.5%; font-weight: 900; font-size:14px; text-align:center; vertical-align: middle">요청수량</td>
	            <td style="width:  6%;vertical-align: middle"></td>
	        </tr>
		
	        <tbody id="bom_head_tbody">
	        <tr style="vertical-align: middle">			            
	        	<td style="text-align:center; vertical-align: middle ;margin: 0 ;">
					<input type="hidden" class="form-control" id="txt_balju_no" readonly></input>
					<input type="text" class="form-control" id="txt_balju_seq" readonly></input>					
				</td>		           
				<td style="text-align:right;vertical-align: middle ;margin: 0 ;">
					<input type="text" class="form-control" maxlength="50" id="txt_bom_nm"  readonly></input> 
	           	</td>
	        	<td style="text-align:center; vertical-align: middle ;margin: 0 ;">
					<input type="text" 	 	class="form-control" maxlength="7" id="txt_bom_cd" readonly></input>
				</td>
	            <td style="text-align:center; vertical-align: middle ;margin: 0 ;">
					<input type="text" 	 class="form-control" maxlength="20" id="txt_part_cd" readonly ></input>
					<input type="hidden" class="form-control" maxlength="1"  id="txt_part_cd_rev" readonly></input>	           
	           	</td>

	            <td style="text-align:center; vertical-align: middle ;margin: 0 ;">
					<input type="text" class="form-control" maxlength="5" id="txt_inspect_cnt"  readonly></input>
	           	</td>
	            <td style="text-align:center; vertical-align: middle ;margin: 0 ;">
					<input type="text" class="form-control"  id="txt_request_cnt" ></input>
	           	</td>
	            <td style="text-align:center; vertical-align: middle ;margin: 0 ;">
	            	<button id="btn_plus" class="form-control btn btn-info" >수정</button>
	            </td>
	        </tr>
	        </tbody>
	    </table>

		<div>
			<div id="Balju_body" style="width:40%; float:left">
			</div>
			<div style="width:6%;  height:330px; vertical-align: middle ;float:left">
				<label style="height:120px;"></label>
	            	<button id="btn_plus_all" class="form-control btn btn-info" >>></button>
			</div>
			<div id="inspect_body" style="width:54%; float:left">
			</div>
		</div>
		<table class="table table-striped" style="width: 100%; margin: 0 ; align:center ;" id="bom_table"> 
	        <tr style="vertical-align: middle">
	            <td style="width:100%; font-weight: 900; font-size:14px; text-align:center; vertical-align: middle">
					<p style="text-align:center">
	         			<button id="btn_Save"  class="btn btn-info"  onclick="SaveOderInfo();">저장</button>
	             		<button id="btn_Canc"  class="btn btn-info"  onclick="parent.$('#modalReport').hide();">취소</button>
	         		</p>
	         </td>
	        </tr>
	    </table>
	        
	        