<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*,java.util.*,javax.servlet.http.*"%>
<%@ page import="mes.client.comm.*" %>
<%@ page import="mes.client.common.*" %>
<%@ page import="mes.client.guiComponents.*" %>
<%@ page import="mes.client.util.*" %>
<%@ page import="mes.client.conf.*" %>
<%@ page import="org.json.simple.*"%><%@ include file="/strings.jsp" %>

<!-- 
더이상 안쓰는 주문정보등록 페이지인 듯 
not used
-->

<%
	String loginID = session.getAttribute("login_id").toString();
	String member_key = session.getAttribute("member_key").toString();

	String GV_ORDERNO = "", GV_ORDER_DETAIL_SEQ = "",
		   GV_CUST_NM = "", GV_PROJECT_NAME = "", 
		   GV_PRODUCT_NM = "", GV_JSPPAGE = "", 
		   GV_NUM_GUBUN = "", GV_PRODUCTSERIALNO = "", 
		   GV_LOTNO = "";
	
	if(request.getParameter("OrderNo") == null)
		GV_ORDERNO = "";
	else
		GV_ORDERNO = request.getParameter("OrderNo");	
	
	if(request.getParameter("OrderDetailSeq") == null)
		GV_ORDER_DETAIL_SEQ="";
	else
		GV_ORDER_DETAIL_SEQ = request.getParameter("OrderDetailSeq");
	
	if(request.getParameter("cust_nm") == null)
		GV_CUST_NM = "";
	else
		GV_CUST_NM = request.getParameter("cust_nm");	
	
	if(request.getParameter("project_name") == null)
		GV_PROJECT_NAME="";
	else
		GV_PROJECT_NAME = request.getParameter("project_name");
	
	if(request.getParameter("product_nm") == null)
		GV_PRODUCT_NM = "";
	else
		GV_PRODUCT_NM = request.getParameter("product_nm");	
	
	if(request.getParameter("jspPage") == null)
		GV_JSPPAGE="";
	else
		GV_JSPPAGE = request.getParameter("jspPage");	

	if(request.getParameter("num_gubun") == null)
		GV_NUM_GUBUN="";
	else
		GV_NUM_GUBUN = request.getParameter("num_gubun");

	if(request.getParameter("productserialno") == null)
		GV_PRODUCTSERIALNO="";
	else
		GV_PRODUCTSERIALNO = request.getParameter("productserialno");
	
	if(request.getParameter("LotNo") == null)
		GV_LOTNO="";
	else
		GV_LOTNO = request.getParameter("LotNo");
	
	String param = GV_ORDERNO+ "|" + member_key + "|" ;
%>
    
<script type="text/javascript">
	// 웹소켓 통신을 위해서 필요한 변수들 ---시작
	var M303S010100E101 = {
			PID:  "M303S010100E101", 
			totalcnt: 0,
			retnValue: 999,
			colcnt: 0,
			colname: ["","","",""], //insert, Update, Delete 문장을 처리할 때는 사용되지않음
			data: []
	};  
	
	var SQL_Param = {
			PID:  "M303S010100E101", 
			excute: "queryProcess",
			stream: "N",
			param: ""
	};
	
	var GV_RECV_DATA = "";	//웹소켓 onMessage(event)들어온 데이터를 받는 변수
	// 웹소켓 통신을 위해서 필요한 변수들 ---끝	

    var JOB_GUBUN = "";

	var vTableS303S010120;
	var TableS303S010120_info;
    var TableS303S010120_RowCount=0;
    var S303S010120_Row_index = -1;    

	var vTableS303S010130;
    var S303S010130_Row_index = -1;
	var TableS303S010130_info;
    var TableS303S010130_RowCount=0;

    var qProcSeq_Max = -1;
    
    var InspectYN;
    
    $(document).ready(function () {
    	new SetSingleDate2("", "#txt_start_date", 0);
    	new SetSingleDate2("", "#txt_end_date", 0);
    	
    	$("#txt_std_proc_qnt").keypress(function(key){ 
        	var keyValue = key.keyCode; 
    		if( ( (keyValue >= 48) && (keyValue <= 57) ) || (keyValue == 46) ) { //숫자또는 점(.)만 입력
    			return true; 
    		} else {
    			alert("숫자만 입력하세요.")
    			return false; 
    		}
        });
    	
        $("#txt_man_amt").keypress(function(key){ 
        	var keyValue = key.keyCode; 
    		if( (keyValue >= 48) && (keyValue <= 57) ) { //숫자만 입력
    			return true; 
    		} else {
    			alert("숫자만 입력하세요.")
    			return false; 
    		}
        });
    	
        $("#txt_order_no").val("<%=GV_ORDERNO%>");
        $("#txt_lotno").val("<%=GV_LOTNO%>");
        $("#txt_project_name").val("<%=GV_PROJECT_NAME%>");
        $("#txt_cust_nm").val("<%=GV_CUST_NM%>");
        $("#txt_product_nm").val("<%=GV_PRODUCT_NM%>");
        $("#txt_product_serial_no").val("<%=GV_PRODUCTSERIALNO%>");
        
        call_S303S010120();
        call_S303S010130();
    });	
    
    function call_S303S010120(){
    	$.ajax({
	        type: "POST",
            url: "<%=Config.this_SERVER_path%>/Contents/Business/M303/S303S010120.jsp", 
	        data: "order_no=" + '<%=GV_ORDERNO%>' + "&order_detail_seq=" + '<%=GV_ORDER_DETAIL_SEQ%>' 
	        		+ "&process_gubun=QAPROCS" + "&caller=" + "S303S010101" + "&proc_cd=" + $('#txt_process_cd').val()
	        		 + "&lotno=" + '<%=GV_LOTNO%>', 
	        beforeSend: function () {
	            $("#inspect_Request_body").children().remove();
	        },
	        success: function (html) {
	            $("#inspect_Request_body").hide().html(html).fadeIn(100);
	        }
 		});
    }
    
    function call_S303S010130(){
        $.ajax({
	        type: "POST",
            url: "<%=Config.this_SERVER_path%>/Contents/Business/M303/S303S010130.jsp", 
	        data: "order_no=" + "<%=GV_ORDERNO%>" + "&order_detail_seq="
	        	+ "<%=GV_ORDER_DETAIL_SEQ%>" + "&caller=" + "S303S010101"
	        	+ "&lotno=" + '<%=GV_LOTNO%>', 
	        beforeSend: function () {
	            $("#inspect_result_body").children().remove();
	        },
	        success: function (html) {
	            $("#inspect_result_body").hide().html(html).fadeIn(100);
	        }
 		});
    }

	function fn_Update_body(obj){  	
    	if($("#txt_process_cd").val() =="" || $("#txt_process_cd").val() ==null || $("#txt_process_cd").val() ==undefined) {
    		alert("공정코드를 먼저 선택하세요");
    		return;
    	} else if(S303S010120_Row_index == -1 && S303S010130_Row_index == -1) {
    		alert("등록 또는 수정할 품질공정을 선택하세요");
    		return;
    	} else if(S303S010120_Row_index != -1 || S303S010130_Row_index != -1) {
    		if($("#txt_std_proc_qnt").val() =="" || $("#txt_std_proc_qnt").val() ==null || $("#txt_std_proc_qnt").val() ==undefined) {
    			alert("표준공수를 입력하세요.");
    			return;
    		} else if($("#txt_man_amt").val() =="" || $("#txt_man_amt").val() ==null || $("#txt_man_amt").val() ==undefined) { 
    			alert("필요인원수를 입력하세요.");
    			return;
    		} else if($("#txt_start_date").val() =="" || $("#txt_start_date").val() ==null || $("#txt_start_date").val() ==undefined) { 
    			alert("공정시작예정일을 입력하세요.");
    			return;
    		} else if($("#txt_end_date").val() =="" || $("#txt_end_date").val() ==null || $("#txt_end_date").val() ==undefined) {
    			alert("공정완료예정일을 입력하세요.");
    			return;
    		}		
    		
    		var inspect_yn = 'N';
    		var inspect_request_yn = 'Y'; // 20190114 진욱수정 - 제품검사요청여부 무조건 'Y'로(안쓰는 값)
    		
    		if($('#txt_inspect_yn').prop("checked")) {
    			inspect_yn = 'Y';
    		} else {
	     		inspect_yn = 'N';
    		}

			if(S303S010120_Row_index != -1 && S303S010130_Row_index == -1) { //등록
    			vTableS303S010130.row.add( [
    				$('#txt_process_cd').val(),
    				$('#txt_process_name').val(),//공정명
    				$('#txt_q_proc_cd').val(),
    				$('#txt_process_nm').val(),//품질공정명
    				inspect_yn,
    				inspect_request_yn,
    				$('#txt_std_proc_qnt').val(),
    				$('#txt_man_amt').val(),
    				'ㅋ', //proc_info_no(가짜값)
    				$('#txt_order_no').val(),
    				$('#txt_lotno').val(),
    				$('#txt_process_rev').val(),
    				$("#txt_q_proc_cd_rev").val(),
    				++qProcSeq_Max, //q_proc_seq : 조회된 최대값부터 1씩증가
    				$('#txt_dept_gubun').val(),//dept_gubun
    				$("#txt_process_seq").val(),//process_seq
    				$("#txt_start_date").val(),
    				$("#txt_end_date").val(),
    				'' //삭제버튼
    	        ] ).draw();
    			overlap_proc_data();
        		S303S010120_Row_index = -1;
    			call_S303S010120(); //입력 후 왼쪽테이블 refresh
    		} else if(S303S010120_Row_index == -1 && S303S010130_Row_index != -1) { //수정
    			vTableS303S010130.cell( S303S010130_Row_index, 0).data( $('#txt_process_cd').val() );
    			vTableS303S010130.cell( S303S010130_Row_index, 1).data( $('#txt_process_name').val() );
    			vTableS303S010130.cell( S303S010130_Row_index, 2).data( $('#txt_q_proc_cd').val() );
    			vTableS303S010130.cell( S303S010130_Row_index, 3).data( $('#txt_process_nm').val() );
    			vTableS303S010130.cell( S303S010130_Row_index, 4).data( inspect_yn );
    			vTableS303S010130.cell( S303S010130_Row_index, 5).data( inspect_request_yn );
    			vTableS303S010130.cell( S303S010130_Row_index, 6).data( $('#txt_std_proc_qnt').val() );
    			vTableS303S010130.cell( S303S010130_Row_index, 7).data( $('#txt_man_amt').val() );
    			vTableS303S010130.cell( S303S010130_Row_index, 8).data( $('#txt_proc_info_no').val() );
    			vTableS303S010130.cell( S303S010130_Row_index, 9).data( $('#txt_order_no').val() );
    			vTableS303S010130.cell( S303S010130_Row_index, 10).data( $('#txt_lotno').val() );
    			vTableS303S010130.cell( S303S010130_Row_index, 11).data( $('#txt_process_rev').val() );
    			vTableS303S010130.cell( S303S010130_Row_index, 12).data( $('#txt_q_proc_cd_rev').val() );
    			vTableS303S010130.cell( S303S010130_Row_index, 13).data( $('#txt_q_proc_seq').val() );
    			vTableS303S010130.cell( S303S010130_Row_index, 14).data( $('#txt_dept_gubun').val() );
    			vTableS303S010130.cell( S303S010130_Row_index, 15).data( $('#txt_process_seq').val() );
    			vTableS303S010130.cell( S303S010130_Row_index, 16).data( $('#txt_start_date').val() );
    			vTableS303S010130.cell( S303S010130_Row_index, 17).data( $('#txt_end_date').val() );
    			vTableS303S010130.draw();
    			overlap_proc_data();
        		clear_input(obj); 
        		S303S010130_Row_index = -1;
    		}
    	}
    }
	
	function clear_input(obj){
		$('#txt_proc_info_no').val("");
		$('#txt_q_proc_cd_rev').val("");
		$('#txt_q_proc_cd').val("");
		$('#txt_process_nm').val("");
		$('#txt_dept_gubun').val("");
		$('#txt_process_seq').val("");
		$('#txt_inspect_yn').prop("checked",false);
		$('#txt_std_proc_qnt').val("");
		$('#txt_man_amt').val("");
		$('#txt_start_date').val("");
		$('#txt_end_date').val("");
	}
	
	function overlap_proc_data() { // 같은 공정별로 자주검사여부~공정완료예정일 데이터 똑같이 집어넣기(품질공정은 각각 다르게)
		TableS303S010130_info = vTableS303S010130.page.info();
        TableS303S010130_RowCount = TableS303S010130_info.recordsTotal;
        
		for(i=0;i<TableS303S010130_RowCount;i++){
			if($("#txt_process_cd").val() == vTableS303S010130.cell(i , 0).data()){
				if($("#txt_inspect_yn").prop("checked")) {
					vTableS303S010130.cell(i , 4).data('Y');
				} else {
					vTableS303S010130.cell(i , 4).data('N');
				}
				vTableS303S010130.cell(i , 5).data('Y'); // 20190114 진욱수정 - 제품검사요청여부 무조건 'Y'로(안쓰는 값)
				vTableS303S010130.cell(i , 6).data($("#txt_std_proc_qnt").val());
				vTableS303S010130.cell(i , 7).data($("#txt_man_amt").val());
				vTableS303S010130.cell(i , 16).data($("#txt_start_date").val());
				vTableS303S010130.cell(i , 17).data($("#txt_end_date").val());
			}
		}
		vTableS303S010130.draw();
	}
	
	function fn_mius_body(obj){
		vTableS303S010130.row($(obj).parents('tr')).remove().draw();

	    TableS303S010130_info = vTableS303S010130.page.info();
	    TableS303S010130_RowCount = TableS303S010130_info.recordsTotal;
	    
	    call_S303S010120(); // 삭제 후 왼쪽 테이블 refresh
    }
	
	function SetProcessInfo(txt_process_name,txt_process_cd, txt_process_rev) { //생산공정검색 완료후 실행
		$('#txt_process_name').val(txt_process_name);
		$('#txt_process_cd').val(txt_process_cd);
		$('#txt_process_rev').val(txt_process_rev);
		call_S303S010120();
		S303S010120_Row_index = -1;
		S303S010130_Row_index = -1;
		clear_input();
	}
	
	function SaveOderInfo() {        
		TableS303S010130_info = vTableS303S010130.page.info();
        TableS303S010130_RowCount = TableS303S010130_info.recordsTotal;
        
        var procCheck = [false,false,false,false];
        for(i = 0; i < TableS303S010130_RowCount; i++) {
        	if(vTableS303S010130.cell(i , 0).data() == "P000001") procCheck[0] = true;
        	if(vTableS303S010130.cell(i , 0).data() == "P000002") procCheck[1] = true;
        	if(vTableS303S010130.cell(i , 0).data() == "P000003") procCheck[2] = true;
        	if(vTableS303S010130.cell(i , 0).data() == "P000004") procCheck[3] = true; 
        } 
        
        for(i = 0; i < procCheck.length; i++) {
        	if(procCheck[i] == false){
        		alert("P00000"+(i+1)+"공정이 등록되지 않아서 저장할 수 없습니다.");
        		return false;
        	}
        }

        var dataJsonHead = new Object(); // JSON Object 선언
        dataJsonHead.jsp_page = '<%=GV_JSPPAGE%>';
        dataJsonHead.login_id = '<%=loginID%>'; 
        dataJsonHead.num_gubun = '<%=GV_NUM_GUBUN%>'; 
        dataJsonHead.lotno = '<%=GV_LOTNO%>';
        dataJsonHead.member_key = "<%=member_key%>";
      
        var jArray = new Array(); // JSON Array 선언
	    
	    for(var i = 0; i < TableS303S010130_RowCount; i++){
	    	var dataJson = new Object(); // BOM Data용
	    
	    	dataJson.proc_info_no 		= vTableS303S010130.cell(0 , 8).data();			//proc_info_no : 이미 조회된 데이터가 있을경우 0번째 행의 proc_info_no, 없을 경우 'ㅋ'(가짜값) 
	    	dataJson.order_no 			=  vTableS303S010130.cell(i , 9).data();		//order_no
			dataJson.lotno 				= vTableS303S010130.cell(i , 10).data(); 		//lotno
			dataJson.proc_cd 			= vTableS303S010130.cell(i , 0).data(); 		//proc_cd
			dataJson.proc_cd_rev 		= vTableS303S010130.cell(i , 11).data();		//proc_cd_rev
			dataJson.q_proc_cd 			= vTableS303S010130.cell(i , 2).data();			//q_proc_cd
			dataJson.q_proc_cd_rev 		= vTableS303S010130.cell(i , 12).data(); 		//q_proc_cd_rev
			dataJson.q_proc_seq			= vTableS303S010130.cell(i , 13).data();		//q_proc_seq
			dataJson.inspect_yn			= vTableS303S010130.cell(i , 4).data(); 		//inspect_yn(checkbox)
			dataJson.inspect_request_yn	= vTableS303S010130.cell(i , 5).data();			//inspect_request_yn(checkbox)				
			dataJson.std_proc_qnt 		= vTableS303S010130.cell(i , 6).data();			//std_proc_qnt
			dataJson.man_amt 			= vTableS303S010130.cell(i , 7).data();			//man_amt
			dataJson.start_date			= vTableS303S010130.cell(i , 16).data();		//start_date
			dataJson.start_date			= vTableS303S010130.cell(i , 17).data();		//end_date
			dataJson.member_key 		= "<%=member_key%>";
			
			jArray.push(dataJson); // 데이터를 배열에 담는다.
	    }
		var dataJsonMulti = new Object();
		dataJsonMulti.paramHead = dataJsonHead;
		dataJsonMulti.param = jArray; // Array를 다시 Object형태로 변환 {"param":{Array...}}

		var JSONparam = JSON.stringify(dataJsonMulti);
		SendTojsp(JSONparam, SQL_Param.PID);
	}
    
	function SendTojsp(bomdata, pid) {
		$.ajax({
	         type: "POST",
	         dataType: "json",
	         url: "<%=Config.this_SERVER_path%>/Contents/CommonView/insert_update_delete_json.jsp", 
	         data: {"bomdata" : bomdata, "pid" : pid},
	         success: function (html) {	
	        	 if(html > -1) {
	        		parent.fn_DetailInfo_List();
	        		$("#modalReport").modal('hide');
	        	}
	    	}
		});		
	}       
	
    </script>

	<table class="table table-bordered" style="width: 100%; margin: 0 auto; align:center">
		<tr style="background-color: #fff; ">
            <td style="width: 10%; font-weight: 900; font-size:14px; vertical-align: middle ;text-align:right">주문번호</td>
            <td style="width: 25%; font-weight: 900; font-size:14px; vertical-align: middle ;text-align:left">
            	<input type="text" class="form-control" id="txt_order_no" readonly/>
				<input type="hidden" class="form-control" id="txt_order_detail_seq" readonly/>
				<input type="hidden" class="form-control" id="txt_lotno" readonly/>
			</td>
            <td style="width: 15%; font-weight: 900; font-size:14px; vertical-align: middle ;text-align:right" colspan="1">프로젝트 명</td>
            <td style="width: 20%; font-weight: 900; font-size:14px; vertical-align: middle ;text-align:left" colspan="2">
            	<input type="text" class="form-control" id="txt_project_name" readonly/>
            </td>
            <td style="width: 30%; font-weight: 900; font-size:14px; vertical-align: middle ;text-align:left" colspan="2"></td>
		</tr>
		<tr style="background-color: #fff; ">
			<td style="width: 10%; font-weight: 900; font-size:14px; vertical-align: middle ;text-align:right">고객사</td>
            <td style="width: 25%; font-weight: 900; font-size:14px; vertical-align: middle ;text-align:left">
            	<input type="text" class="form-control" id="txt_cust_nm" readonly/>
			</td>
            <td style="width: 15%; font-weight: 900; font-size:14px; vertical-align: middle ;text-align:right" colspan="1">제품명</td>
            <td style="width: 20%; font-weight: 900; font-size:14px; vertical-align: middle ;text-align:left" colspan="2">
            	<input type="text" class="form-control" id="txt_product_nm" readonly/>
            </td>
            <td style=" font-weight: 900; font-size:14px; vertical-align: middle ;text-align:right" ></td>
            <td style=" font-weight: 900; font-size:14px; vertical-align: middle ;text-align:left" >
            	<input type="hidden" class="form-control" id="txt_product_serial_no" readonly/>
            </td>
        </tr>        
		<tr style="background-color: #fff; ">
			<td style="width: 10%; font-weight: 900; font-size:14px; vertical-align: middle ;text-align:right" rowspan="2">공정명</td>
            <td style="width: 25%; font-weight: 900; font-size:14px; vertical-align: middle ;text-align:left" rowspan="2">
            	<input type="hidden" class="form-control" id="txt_process_rev" readonly/>
            	<input type="hidden" class="form-control" id="txt_process_cd" readonly/>
            	<input type="text" class="form-control" id="txt_process_name" style="width:65%;float:left;" readonly />
            	<button class="form-control btn btn-info" style="width:35%;float:left;" onclick="pop_fn_Process_View('PDPROCS',1)">생산공정검색</button>
			</td>
            <td style="width: 15%; font-weight: 900; font-size:14px; vertical-align: middle ;text-align:center; background-color: #f4f4f4;">자주검사여부</td>
            <td style="width: 10%; font-weight: 900; font-size:14px; vertical-align: middle ;text-align:center; background-color: #f4f4f4;">표준공수</td>
            <td style="width: 10%; font-weight: 900; font-size:14px; vertical-align: middle ;text-align:center; background-color: #f4f4f4;">필요인원수</td>
            <td style="width: 15%; font-weight: 900; font-size:14px; vertical-align: middle ;text-align:center; background-color: #f4f4f4;">공정시작예정일</td>
            <td style="width: 15%; font-weight: 900; font-size:14px; vertical-align: middle ;text-align:center; background-color: #f4f4f4;">공정완료예정일</td>
		</tr>
		<tr style="background-color: #fff; ">
            <td style="text-align:center; vertical-align: middle ;margin: 0 ;">
				<input type="checkbox" class="" id="txt_inspect_yn" />
           	</td>
            <td style="text-align:center; vertical-align: middle ;margin: 0 ;">
				<input type="text" class="form-control" id="txt_std_proc_qnt" />
           	</td>
           	<td style="text-align:center; vertical-align: middle ;margin: 0 ;">
				<input type="text" class="form-control" id="txt_man_amt" />
           	</td>
           	<td style="text-align:center; vertical-align: middle ;margin: 0 ;">
				<input type="text" class="form-control" id="txt_start_date" />
           	</td>
           	<td style="text-align:center; vertical-align: middle ;margin: 0 ;">
				<input type="text" class="form-control" id="txt_end_date" />
           	</td>
		</tr>
	</table>
	<table class="table table-bordered" style="width: 100%; margin: 0 ; align:center ;">
		<tr style="vertical-align: middle; background-color: #f4f4f4;">
			<td style="font-weight: 900; font-size:14px; text-align:center; vertical-align: middle">품질공정코드</td>
	        <td style="font-weight: 900; font-size:14px; text-align:center; vertical-align: middle">품질공정명</td>
	        <td style="font-weight: 900; font-size:14px; text-align:center; vertical-align: middle">관련부서</td>
	        <td style="font-weight: 900; font-size:14px; text-align:center; vertical-align: middle">공정순서</td>
	        <td style="vertical-align: middle"></td>
		</tr>
		<tr style="vertical-align: middle">
			<td style="text-align:center; vertical-align: middle ;margin: 0 ;">
	        	<input type="hidden" class="form-control" id="txt_proc_info_no" readonly/>
	        	<input type="hidden" class="form-control" id="txt_q_proc_cd_rev" readonly/>
	        	<input type="hidden" class="form-control" id="txt_q_proc_seq" readonly/>
	        	<input type="text" class="form-control" id="txt_q_proc_cd" readonly/>
			</td>		           
			<td style="text-align:right;vertical-align: middle ;margin: 0 ;">
				<input type="text" class="form-control" id="txt_process_nm" readonly/> 
           	</td>
        	<td style="text-align:center; vertical-align: middle ;margin: 0 ;">
				<input type="text" class="form-control" id="txt_dept_gubun" readonly/>
			</td>
            <td style="text-align:center; vertical-align: middle ;margin: 0 ;">
				<input type="text" class="form-control" id="txt_process_seq" readonly/>	           
           	</td>
            <td style="text-align:center; vertical-align: middle ;margin: 0 ;">
            	<button id="btn_plus" class="form-control btn btn-info" onclick="fn_Update_body(this)">
            		입력
            	</button>
            </td>
		</tr>
	</table>
	
	<div style="width:100%; text-align:center;clear:both" >
		<div id="inspect_Request_body" style="width:35%; float:left">
		</div>
		<div id="space_between_table" style="width:0.5%; float:left">
			<label style="width:100%;"></label>
		</div>
		<div id="inspect_result_body" style="width:64.5%; float:left">
		</div>
	</div>