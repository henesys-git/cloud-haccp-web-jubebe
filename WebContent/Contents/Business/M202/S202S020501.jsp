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
S202S020101.jsp
자재검수 등록 
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


	String GV_ORDERNO="", GV_ORDER_DETAIL_SEQ="", GV_JSPPAGE="", GV_NUM_GUBUN="", GV_LotNo="", GV_BaljuNo="";
	
	if(request.getParameter("OrderNo")== null)
		GV_ORDERNO = "";
	else
		GV_ORDERNO = request.getParameter("OrderNo");	
	
	if(request.getParameter("order_detail_seq")== null)
		GV_ORDER_DETAIL_SEQ="";
	else
		GV_ORDER_DETAIL_SEQ = request.getParameter("order_detail_seq");
	

	if(request.getParameter("jspPage")== null)
		GV_JSPPAGE="0";
	else
		GV_JSPPAGE = request.getParameter("jspPage");	
	
	if(request.getParameter("lotno")== null)
		GV_LotNo="";
	else
		GV_LotNo = request.getParameter("lotno");
	
	if(request.getParameter("balju_no")== null)
		GV_BaljuNo="";
	else
		GV_BaljuNo = request.getParameter("balju_no");

	if(request.getParameter("num_gubun")== null)
		GV_NUM_GUBUN="";
	else
		GV_NUM_GUBUN = request.getParameter("num_gubun");
	
// 	String param =GV_ORDERNO+ "|" ;
	
//     TableModel = new DoyosaeTableModel("M202S020100E714", strColumnHead, param);
//  	int RowCount =TableModel.getRowCount();
  		
%>
    
    <script type="text/javascript">
//     웹소켓 통신을 위해서 필요한 변수들 ---시작
	var M202S020500E101 = {
			PID:  "M202S020500E101", 
			UPID: "M202S020100E102",  
			totalcnt: 0,
			retnValue: 999,
			colcnt: 0,
			colname: ["","","",""], //insert, Update, Delete 문장을 처리할 때는 사용되지않음
			data: []
	};  
	
	var SQL_Param = {
			PID:  "M202S020500E101", 
			excute: "queryProcess",
			stream: "N",
			param: ""
	};
	var GV_RECV_DATA = "";	//웹소켓 onMessage(event)들어온 데이터를 받는 변수
//  웹소켓 통신을 위해서 필요한 변수들 ---끝	

    var JOB_GUBUN = "";
    

	var vTableS202S020520;
	var TableS202S020520_info;
    var TableS202S020520_RowCount;
    var S202S020520_Row_index = -1;    

	var vTableS202S020125;
    var S202S020125_Row_index = -1;
	var TableS202S020125_info;
    var TableS202S020125_RowCount;
    var balju_inspect_no="";
    
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
        $.ajax({
	        type: "POST",
	        async: false,
            url: "<%=Config.this_SERVER_path%>/Contents/Business/M202/S202S020520.jsp", 
	        data: "order_no=" + '<%=GV_ORDERNO%>' + "&caller=" + "S202S020520" 
					+ "&order_detail_seq=" + '<%=GV_ORDER_DETAIL_SEQ%>'	
					+ "&lotno=" + '<%=GV_LotNo%>'
					+ "&balju_no=" + '<%=GV_BaljuNo%>' , 
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
            url: "<%=Config.this_SERVER_path%>/Contents/Business/M202/S202S020125.jsp", 
	        data: "order_no=" + '<%=GV_ORDERNO%>'  
			+ "&order_detail_seq=" + '<%=GV_ORDER_DETAIL_SEQ%>'
			+"&lotno="+'<%=GV_LotNo%>'
			+"&balju_no="+'<%=GV_BaljuNo%>', 
	        beforeSend: function () {
	            $("#inspect_body").children().remove();
	        },
	        success: function (html) {
	            $("#inspect_body").hide().html(html).fadeIn(100);
	        },
	        error: function (xhr, option, error) {
	        }
 		});
        
	    // 숫자만
	    $("input:text[numberOnly]").on("keyup", function() {
	        $(this).val($(this).val().replace(/[^0-9]/g,""));
	    });
	    
	 	// 숫자 또는 소수점만
	 	$("input:text[numberPoint]").on("keyup", function() {
	 		$(this).val($(this).val().replace(/[^0-9.]/g,""));
	 	});
    });	

	
	function SaveOderInfo() {        

		var work_complete_insert_check = confirm("등록하시겠습니까?");
		if(work_complete_insert_check == false)	return;
		
		var WebSockData="";

		TableS202S020125_info = vTableS202S020125.page.info();
        TableS202S020125_RowCount = TableS202S020125_info.recordsTotal;
        
        var dataJsonHead = new Object(); // JSON Object 선언
        
			dataJsonHead.jsp_page =  '<%=GV_JSPPAGE%>';
			dataJsonHead.user_id = '<%=loginID%>';
			dataJsonHead.prefix = '<%=GV_NUM_GUBUN%>';
			dataJsonHead.order_no = '<%=GV_ORDERNO%>';	// order_no			주문번호
			dataJsonHead.order_detail_seq = '<%=GV_ORDER_DETAIL_SEQ%>'; 	// order_no		주문상세번호
// 			dataJsonHead.jsp_page = (++($('#txt_inspect_seq').val())); 	// order_no		주문상세번호
			dataJsonHead.balju_text = $('#txt_balju_text').val();	// balju_text		발주제목 
			dataJsonHead.balju_send_date = $('#dateOrder').val();	// balju_send_date	발주일 
			dataJsonHead.balju_nabgi_date = $('#dateDelevery').val();	// balju_send_date	납기일 
			dataJsonHead.cust_cd = $('#txt_S_custcode').val();	// cust_cd   수신처
			dataJsonHead.cust_damdang = $('#txt_Cust_damdang').val();	// cust_damdang   	수신인
			dataJsonHead.tell_no = $('#txt_telNo').val();	// tell_no   전화번호
			dataJsonHead.fax_no = $('#txt_FaxNo').val();	// fax_no   팩스번호
			dataJsonHead.nabpoom_location = $('#nabpoom_location').val();	// nabpoom_location   납품잘소
			dataJsonHead.qa_ter_condtion = $('#txt_qar').val();	// qa_ter_condtion   품질조건
// 			+  balju_inspect_no					+ "|"	// balju_inspect_no   
			dataJsonHead.member_key = '<%=member_key%>';
			
			var jArray = new Array(); // JSON Array 선언
			
	    for(var i=0; i<TableS202S020125_RowCount; i++){   
	    	
	    	var dataJson = new Object(); // BOM Data용
	    	
	    	dataJson.balju_no 			= vTableS202S020125.cell(i , 0).data();	//0 balju_no   순번
	    	dataJson.balju_seq 			= vTableS202S020125.cell(i , 1).data();	//1 balju_seq   순번
	    	dataJson.bom_nm 			= vTableS202S020125.cell(i , 2).data();	//1 bom_nm  자료이름					
	    	dataJson.bom_cd 			= vTableS202S020125.cell(i , 3).data();	//2 bom_cd 자료번호
	    	dataJson.part_cd 			= vTableS202S020125.cell(i , 4).data();	//4 part_cd 파트코드
	    	dataJson.gyugeok 			= vTableS202S020125.cell(i , 5).data();	//5 gyugeok 규격
	    	dataJson.balju_count 		= vTableS202S020125.cell(i , 6).data();	//6 balju_count 수량
	    	dataJson.inspect_count 		= vTableS202S020125.cell(i , 7).data();	//6 inspect_count 수량
	    	dataJson.list_price 		= vTableS202S020125.cell(i , 8).data();	//7 list_price 	단가
	    	dataJson.balju_amt 			= vTableS202S020125.cell(i , 9).data();	//8 balju_amt 	금액
	    	dataJson.rev_no 			= vTableS202S020125.cell(i , 10).data();	//9 rev_no		구분
	    	dataJson.part_cd_rev 		= vTableS202S020125.cell(i , 11).data();	//0 part_cd_rev 구분
	    	dataJson.inspect_seq 	= vTableS202S020125.cell(i , 12).data();	//0 txt_balju_inspect_no 구분
	    	dataJson.lotno 				= vTableS202S020125.cell(i , 13).data();	//0 txt_lotno 구분
	    	jArray.push(dataJson); // 데이터를 배열에 담는다.
	    }
		var dataJsonMulti = new Object();
		dataJsonMulti.paramHead = dataJsonHead;
		dataJsonMulti.param = jArray; // Array를 다시 Object형태로 변환 {"param":{Array...}}

		var JSONparam = JSON.stringify(dataJsonMulti); // JSON Object전송을 위해 문자열형태로 바꿔줌(stringify)
		SendTojsp(JSONparam, SQL_Param.PID); // SendToJSP를 통해 ajax로 데이터(JSONObject,PID) 보냄		
	}
    
	function SendTojsp(bomdata, pid){
		
	    $.ajax({
	         type: "POST",
	         dataType: "json",
	         url: "<%=Config.this_SERVER_path%>/Contents/CommonView/insert_update_delete_json.jsp", 
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
    
    function fn_Update_body(obj){  	
    	if($('#txt_bom_nm').val().length <1) {
    		heneSwal.warning('입력한 데이터가 없습니다')
			return false;
    	}
    	if(S202S020125_Row_index == -1) {
	    	TableS202S020125_info = vTableS202S020125.page.info();
	    	TableS202S020125_RowCount = TableS202S020125_info.recordsTotal;
	        
	    	var part_cd_jungbok = false;
    		for(i=0;i<TableS202S020125_RowCount;i++){
    			if($('#txt_part_cd').val()==vTableS202S020125.cell( i, 4).data()) {
    				part_cd_jungbok = true;
    				S202S020125_Row_index = i;
    			}
    		}
    	
    	
    		if(part_cd_jungbok) {
    			vTableS202S020125.cell( S202S020125_Row_index, 7).data( $('#txt_inspect_cnt').val() );
    			$(TableS202S020125_rowID).removeClass("hene-bg-color");
    			vTableS202S020125.row(S202S020125_Row_index).nodes().to$().attr("class","hene-bg-color");
    			S202S020125_Row_index = -1;
    		} else {
    			vTableS202S020125.row.add( [
    				$('#txt_balju_no').val(),
    				$('#txt_balju_seq').val(),
    				$('#txt_bom_nm').val(),
    				$('#txt_bom_cd').val(),
    				$('#txt_part_cd').val(),
    				$('#txt_gyugeok').val(),
    				$('#txt_part_cnt').val(),
    				$('#txt_inspect_cnt').val(),
    				$('#txt_unit_price').val(),
    				$('#txt_part_amt').val(),
    				$('#txt_rev').val() ,
    				$('#txt_part_cd_rev').val(),
    				(parseInt($('#txt_inspect_seq').val())+1),
//     				$('#txt_balju_inspect_no').val(),
    				$('#txt_lotno').val(),
        			''
    	        ] ).draw(true);
    		}
    	}
    	else{
			vTableS202S020125.cell( S202S020125_Row_index, 0).data( $('#txt_balju_no').val() );
			vTableS202S020125.cell( S202S020125_Row_index, 1).data( $('#txt_balju_seq').val() );
			vTableS202S020125.cell( S202S020125_Row_index, 2).data( $('#txt_bom_nm').val() );
			vTableS202S020125.cell( S202S020125_Row_index, 3).data( $('#txt_bom_cd').val() );
			vTableS202S020125.cell( S202S020125_Row_index, 4).data( $('#txt_part_cd').val() );
			vTableS202S020125.cell( S202S020125_Row_index, 5).data( $('#txt_gyugeok').val() );
			vTableS202S020125.cell( S202S020125_Row_index, 6).data( $('#txt_part_cnt').val() );
			vTableS202S020125.cell( S202S020125_Row_index, 7).data( $('#txt_inspect_cnt').val() );
			vTableS202S020125.cell( S202S020125_Row_index, 8).data( $('#txt_unit_price').val() );
			vTableS202S020125.cell( S202S020125_Row_index, 9).data( $('#txt_part_amt').val() );
			vTableS202S020125.cell( S202S020125_Row_index, 10).data( $('#txt_rev').val() );
			vTableS202S020125.cell( S202S020125_Row_index, 11).data( $('#txt_part_cd_rev').val() );
			vTableS202S020125.cell( S202S020125_Row_index, 12).data( $('#txt_balju_inspect_no').val() );
			vTableS202S020125.cell( S202S020125_Row_index, 13).data( $('#txt_lotno').val() );
    	}
    	vTableS202S020125.draw();
	    clear_input(); 
    }  
    
	function clear_input(){
		$('#txt_balju_no').val("");
		$('#txt_balju_seq').val("");
		$('#txt_bom_nm').val("");
		$('#txt_bom_cd').val("");
		$('#txt_part_cd').val("");
		$('#txt_gyugeok').val("");
		$('#txt_part_cnt').val("");
		$('#txt_inspect_cnt').val("");
		$('#txt_unit_price').val("");
		$('#txt_part_amt').val("");	
		$('#txt_rev').val("");	
		$('#txt_part_cd_rev').val("");	
		$('#txt_balju_inspect_no').val("");	
		$('#txt_lotno').val("");	
	}        		
    
    function fn_mius_body(obj){
    	var tr = $(obj).parent();
    	var tbody = $(tr).parent();
    	var trNum = $(tbody).closest('tr').prevAll().length;
		
		console.log(trNum + "==fn_Update_body=" + S202S020125_Row_index); 
    	vTableS202S020125.row(S202S020125_Row_index ).remove().draw();
//     	vTableS202S020125.row(trNum ).remove().draw();

	    TableS202S020125_info = vTableS202S020125.page.info();
	    TableS202S020125_RowCount = TableS202S020125_info.recordsTotal;
	    
		for(var i =0; i<TableS202S020125_RowCount; i++){
		    vTableS202S020125.cell( i, 3 ).data( i+1 );
		}	        
    }       
    
    </script>

<!-- 	<div> -->
		
        <table class="table table-striped" style="width: 100%; margin: 0 ; align:left ;" id="bom_table">
 
	        <tr style="vertical-align: middle">
	            <td style="width:  3%; font-weight: 900; font-size:14px; text-align:center; vertical-align: middle">순번</td>
	            <td style="width: 16%; font-weight: 900; font-size:14px; text-align:center; vertical-align: middle">품명</td>
	            <td style="width: 16%; font-weight: 900; font-size:14px; text-align:center; vertical-align: middle">자료번호</td>
	            <td style="width: 16%; font-weight: 900; font-size:14px; text-align:center; vertical-align: middle">원부자재코드</td>
	            <td style="width: 16%; font-weight: 900; font-size:14px; text-align:center; vertical-align: middle">규격</td>
	            <td style="width:5.5%; font-weight: 900; font-size:14px; text-align:center; vertical-align: middle">발주수량</td>
	            <td style="width:5.5%; font-weight: 900; font-size:14px; text-align:center; vertical-align: middle">검수수량</td>
<!-- 	            <td style="width:3.5%; font-weight: 900; font-size:14px; text-align:center; vertical-align: middle">단가</td> -->
<!-- 	            <td style="width:3.5%; font-weight: 900; font-size:14px; text-align:center; vertical-align: middle">금액</td> -->
<!-- 	            <td style="width:3.5%; font-weight: 900; font-size:14px; text-align:center; vertical-align: middle">Rev.</td> -->
	            <td style="width:  6%;vertical-align: middle"></td>
	        </tr>
		
	        <tbody id="bom_head_tbody">
	        <tr style="vertical-align: middle">			            
	        	<td style="text-align:center; vertical-align: middle ;margin: 0 ;">
	        		<input type="hidden" class="form-control" id="txt_order_no" readonly></input>
	        		<input type="hidden" class="form-control" id="txt_order_detail_seq" readonly></input>
					<input type="hidden" class="form-control" id="txt_balju_no" readonly></input>
					<input type="hidden" class="form-control" id="txt_inspect_seq" readonly></input>
					<input type="hidden" class="form-control" id="txt_lotno" readonly></input>
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

	            <td style="font-weight: 900; font-size:14px; text-align:center; vertical-align: middle ;margin: 0 ;">
	            	<input type="text"  maxlength="5" id="txt_gyugeok" class="form-control"  readonly/>
	            </td>
	            <td style="text-align:center; vertical-align: middle ;margin: 0 ;">
					<input type="text" numberOnly class="form-control" maxlength="5" id="txt_part_cnt"  readonly></input>
	           	</td>
	            <td style="text-align:center; vertical-align: middle ;margin: 0 ;">
					<input type="text" numberPoint class="form-control"  id="txt_inspect_cnt" ></input>
	            	<input type="hidden"  maxlength="5" id="txt_unit_price" class="form-control"  readonly/>
	            	<input type="hidden"  maxlength="5" id="txt_part_amt" class="form-control"  readonly/>
	            	<input type="hidden"  maxlength="10" id="txt_rev" class="form-control" readonly/>
	           	</td>
	            <td style="text-align:center; vertical-align: middle ;margin: 0 ;">
	            	<button id="btn_plus" class="form-control btn btn-info" >수정</button></td>
	        </tr>
	        </tbody>
	    </table>
		<div>
			<div id="Balju_body" style="width:50%; float:left"> </div>
			<div id="inspect_body" style="width:50%; float:left"> </div>
		</div>

         <p style="text-align:center">
         	<button id="btn_Save"  class="btn btn-info"  onclick="SaveOderInfo();">자재검수저장</button>
             <button id="btn_Canc"  class="btn btn-info"  onclick="parent.$('#modalReport').hide();">취소</button>
         </p>