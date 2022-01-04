<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*,java.util.*,javax.servlet.http.*"%>
<%@ page import="mes.client.comm.*" %>
<%@ page import="mes.client.common.*" %>
<%@ page import="mes.client.guiComponents.*" %>
<%@ page import="mes.client.util.*" %>
<%@ page import="mes.client.conf.*" %>
<%@ page import="org.json.simple.*"%><%@ include file="/strings.jsp" %>
<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1" >
<%
	String loginID = session.getAttribute("login_id").toString();
	String member_key = session.getAttribute("member_key").toString();

	DoyosaeTableModel TableModel;	
%>
 
<%-- <jsp:include page="../../Common/linkcss_js.jsp" flush="false"/> --%>
        
    <script type="text/javascript">
//     웹소켓 통신을 위해서 필요한 변수들 ---시작
	var M909S121100E101 = {
			PID: "M909S121100E101",  
			totalcnt: 0,
			retnValue: 999,
			colcnt: 0,
			colname: ["","","",""], //insert, Update, Delete 문장을 처리할 때는 사용되지않음
			data: []
	};  
	
	var SQL_Param = {
			PID: "M909S121100E101",
			excute: "queryProcess",
			stream: "N",
			param: + "|"
	};
	var GV_RECV_DATA = "";	//웹소켓 onMessage(event)들어온 데이터를 받는 변수
//  웹소켓 통신을 위해서 필요한 변수들 ---끝	
    var detail_seq=1;
	var vprocess_input_table;
    var vprocess_input_table_Row_index = -1;
	var vprocess_input_table_info;
    var vprocess_input_table_RowCount = 0;
    var groupCodeGubun = "";
    var process_index= -1;
    var seolbi_index= -1;
	
    $(document).ready(function () {
    	detail_seq =1;
	    vprocess_input_table = $('#process_input_table').DataTable({
	    	scrollX: true,
		    scrollY: 250,
// 		    scrollCollapse: true,
		    paging: false,
		    searching: false,
		    ordering: false,
		    order: [[ 0, "asc" ]],
		    keys: false,
		    info: true,
		    columnDefs: [
		    	{
		       		'targets': [0],
		       		'createdCell':  function (td) {
		          			$(td).attr('style', 'width:2%;'); 
		       		}
				},
		    	{
		       		'targets': [1,2,3,4,5,7,8,9,10,11,12,16,18,19,,22,23,24,25,27,28,29,30,31],
		       		'createdCell':  function (td) {
		          			$(td).attr('style', 'display:none;'); 
		       		}
				},
		    	{
		       		'targets': [6,13,14,15,17,20,21,26], 
		       		'createdCell':  function (td) {
		          			$(td).attr('style', 'width:10%;'); 
		       		}
				}
            ],
            language: { 
                url:"<%=Config.this_SERVER_path%>/AdminLTE-3.0.5/localisation/Korean.json"
			}
		});	
/* 	    
        $('#txt_start_date').datepicker({
        	format: 'yyyy-mm-dd',
        	autoclose: true,
        	language: 'ko'
        });        
        $('#txt_create_date').datepicker({
        	format: 'yyyy-mm-dd',
        	autoclose: true,
        	language: 'ko'
        });
        $("#txt_duration_date").datepicker({
        	format: 'yyyy-mm-dd',
        	autoclose: true,
        	language: 'ko'
        });     
        $("#txt_modify_date").datepicker({
        	format: 'yyyy-mm-dd',
        	autoclose: true,
        	language: 'ko'
        });     		   		             
        var today = new Date();
        var fromday = new Date();
        fromday.setDate(today.getDate());
        
        $('#txt_start_date').datepicker('update', fromday);
        $('#txt_create_date').datepicker('update', fromday);        
        //$('#txt_modify_date').datepicker('update', fromday);
 */
	    $("#btn_plus").click(function(){ 
	    	fn_plus_body();
	    }); 
	    $("#btn_mius").click(function(){ 
	    	fn_mius_body(); 
	    }); 

    });

	function SaveOderInfo() {
		
		var jArray = new Array(); // JSON Array 선언
		var trInput = $($("#product_tbody tr")[process_index]).find(":input");
		if($("#txt_Productcode").val() == ""){
			alert("제품을 선택하세요");
			return false;
		}
		
        for(var i=0; i<vprocess_input_table_RowCount;i++){
			if(trInput.eq(8).val()== ''){
				alert("공정을 선택하세요");
				return false;
			}
			if(trInput.eq(16).val()== ''){
				alert("설비를 선택하세요");
				return false;
			}
			if(trInput.eq(14).val()== ''){
				alert("표준공수를 입력하세요");
				return false;
			}
			if(trInput.eq(15).val()== ''){
				alert("필요인원수를 입력하세요");
				return false;
			}
			if(trInput.eq(16).val()== ''){
				alert("설비라인을 입력하세요");
				return false;
			}
    		var dataJson = new Object(); // jSON Object 선언
			
			var WebSockData="";
	   		var dataJson = new Object(); // jSON Object 선언 
	   		
   			dataJson.member_key 		= "<%=member_key%>";
   			dataJson.process_gubun		= trInput.eq(2).val();
   			dataJson.process_gubun_rev	= trInput.eq(3).val();
   			dataJson.proc_code_gb_big	= trInput.eq(4).val();
   			dataJson.proc_code_gb_mid	= trInput.eq(5).val();
   			dataJson.proc_cd			= trInput.eq(6).val();
   			dataJson.proc_cd_rev		= trInput.eq(8).val();
   			dataJson.process_nm			= trInput.eq(9).val();
   			dataJson.process_seq		= i + 1;
   			dataJson.dept_gubun			= trInput.eq(11).val();
   			dataJson.prod_cd			= $('#txt_Productcode').val();   		
   			dataJson.prod_cd_rev		= $('#txt_prod_rev').val();
   			dataJson.std_proc_qnt		= trInput.eq(14).val();
   			dataJson.std_man_amt		= trInput.eq(15).val();
   			dataJson.seolbi_cd			= trInput.eq(16).val();
   			dataJson.seolbi_cd_rev		= trInput.eq(18).val();
   			dataJson.seolbi_line		= trInput.eq(19).val();
   			dataJson.work_order_index	= trInput.eq(20).val();
   			dataJson.bigo				= trInput.eq(21).val();
   			dataJson.start_date			= trInput.eq(22).val();
			dataJson.create_date		= trInput.eq(23).val();
            dataJson.create_user_id		= "<%=loginID%>";
            dataJson.modify_date		= trInput.eq(25).val();
   			dataJson.modify_user_id		= trInput.eq(26).val();
   			dataJson.duration_date		= trInput.eq(27).val();
   			dataJson.modify_reason		= trInput.eq(28).val();
   			dataJson.check_data_type	= trInput.eq(29).val();
   			dataJson.delyn				= trInput.eq(30).val();
   			dataJson.product_process_yn	= trInput.eq(31).val();
   			dataJson.packing_process_yn	= trInput.eq(32).val();
   			
			jArray.push(dataJson); // 데이터를 배열에 담는다.				
        }
		var dataJsonMulti = new Object();
 		dataJsonMulti.param = jArray; // Array를 다시 Object형태로 변환 {"param":{Array...}}

		var chekrtn = confirm("등록하시겠습니까?"); 
		
		if(chekrtn){
			var JSONparam = JSON.stringify(dataJsonMulti); // JSON Object전송을 위해 문자열형태로 바꿔줌(stringify)
			SendTojsp(JSONparam, SQL_Param.PID); // SendToJSP를 통해 ajax로 데이터(JSONObject,PID) 보냄
		}
	}
 
	function SendTojsp(bomdata, pid){
		
	    $.ajax({
	         type: "POST",
	         dataType: "json", // Ajax로 json타입으로 보낸다.
	         url: "<%=Config.this_SERVER_path%>/Contents/CommonView/insert_update_delete_json.jsp", 
	         data:  "bomdata=" + bomdata + "&pid=" + pid,
	         beforeSend: function () {
//	         	 alert(bomdata);
	         },	         
	         success: function (html) {
	        	 alert("저장완료");
	        	 if(html>-1){
	        	   	parent.fn_MainInfo_List();
	                parent.$("#ReportNote").children().remove();
	         		parent.$('#modalReport').hide();
	         	}
	         },
	         error: function (xhr, option, error) {
	        	 alert("저장실패");
	         }
	     });		
	}

    // 제품정보
    function SetProductName_code(txt_ProductName, txt_Productcode, txt_prod_rev){
//    	$('#txt_ProductName').val(txt_ProductName);
    	$('#txt_Productcode').val(txt_Productcode);
    	$('#txt_prod_rev').val(txt_prod_rev); 
//    	console.log($('#txt_ProductName').val());
//    	console.log($('#txt_Productcode').val());
//    	console.log($('#txt_prod_rev').val()); 
    }
    // 설비정보
    function SetSeolbiInfo(txt_seolbi_cd,txt_seolbi_rev, txt_seolbi_nm){
		var trInput = $($("#product_tbody tr")[seolbi_index]).find(":input");
//		trInput.eq(1).val(txt_seolbi_nm);
	    trInput.eq(16).val(txt_seolbi_cd);	    
	    trInput.eq(18).val(txt_seolbi_rev);
//	    for(i=0; i<33; i++){ console.log(i+ ". "+ trInput.eq(i).attr("id") + " : " + trInput.eq(i).val()); }
    }    
    // 공정정보
	function SetProcessName_code(txt_process_gubun,
				 				 txt_process_gubun_rev,
				 				 txt_proc_code_gb_big,
				 				 txt_proc_code_gb_mid,
				 				 txt_process_cd,
				 				 txt_process_rev,
								 txt_process_name,
				 				 txt_work_order_index,
				 				 txt_process_seq,
				 				 txt_product_process_yn,
				 				 txt_bigo,
				 				 txt_start_date,
				 				 txt_create_date,
				 				 txt_create_user_id,
				 				 txt_modify_date,
				 				 txt_modify_user_id,
				 				 txt_duration_date,
				 				 txt_modify_reason,
				 				 txt_check_data_type,
				 				 txt_dept_gubun,
				 				 txt_delyn,
				 				 txt_packing_process_yn)
    {
        var trInput = $($("#product_tbody tr")[process_index]).find(":input");
	    trInput.eq(2).val(txt_process_gubun);
	    trInput.eq(3).val(txt_process_gubun_rev);
	    trInput.eq(4).val(txt_proc_code_gb_big);
	    trInput.eq(5).val(txt_proc_code_gb_mid);
	    trInput.eq(6).val(txt_process_cd);
	    trInput.eq(8).val(txt_process_rev);
	    trInput.eq(9).val(txt_process_name);
	    trInput.eq(10).val(txt_process_seq);
	    trInput.eq(11).val(txt_dept_gubun);
	    trInput.eq(20).val(txt_work_order_index);
	    trInput.eq(21).val(txt_bigo);
	    trInput.eq(22).val(txt_start_date);
	    trInput.eq(23).val(txt_create_date);
	    trInput.eq(28).val(txt_modify_reason);
	    trInput.eq(29).val(txt_check_data_type);
	    trInput.eq(30).val(txt_delyn);
	    trInput.eq(31).val(txt_product_process_yn);
	    trInput.eq(32).val(txt_packing_process_yn);	    
	    // 확인용
	    //for(i=0; i<33; i++){ console.log(i+ ". "+ trInput.eq(i).attr("id") + " : " + trInput.eq(i).val()); }
    }    
    function seolbiIns(row_index){
    	seolbi_index = row_index;
    	parent.pop_fn_SeolbiList_View(1,2);
    }
    function processIns(row_index){
    	process_index = row_index;
        parent.pop_fn_Process_View(1,2);
    }
    
    function fn_plus_body(){
    	vprocess_input_table.row.add( [
    		"	<input type='text' class='form-control' id='txt_detail_seq' style='width:30px;' readonly></input>",
    		"	<input type='text' class='form-control' id='txt_member_key"+vprocess_input_table_RowCount+"'></input>",
    		"	<input type='text' class='form-control' id='txt_process_gubun"+vprocess_input_table_RowCount+"' value=''></input>",
    		"	<input type='text' class='form-control' id='txt_process_gubun_rev"+vprocess_input_table_RowCount+"' value=''></input>",
    		"	<input type='text' class='form-control' id='txt_proc_code_gb_big"+vprocess_input_table_RowCount+"' value=''></input>",
    		"	<input type='text' class='form-control' id='txt_proc_code_gb_mid"+vprocess_input_table_RowCount+"' value=''></input>",
    		"	<input type='text' class='form-control' id='txt_proc_cd"+vprocess_input_table_RowCount+"' style='float:left; width:70%;' value='' disabled></input>" +
    		"	<button type='button' onclick='processIns("+vprocess_input_table_RowCount+")' id='btn_SearchProd' class='btn btn-info' style='float:left;width:30%;'>검색</button> ",	// 6. 공정명
    		"	<input type='text' class='form-control' id='txt_proc_cd_rev"+vprocess_input_table_RowCount+"' value=''></input>",
    		"	<input type='text' class='form-control' id='txt_process_nm"+vprocess_input_table_RowCount+"' value=''></input>",
    		"	<input type='text' class='form-control' id='txt_process_seq"+vprocess_input_table_RowCount+"' value=''></input>",
    		"	<input type='text' class='form-control' id='txt_dept_gubun"+vprocess_input_table_RowCount+"' value=''></input>",
    		"	<input type='text' class='form-control' id='txt_prod_cd"+vprocess_input_table_RowCount+"' value=''></input>",
    		"	<input type='text' class='form-control' id='txt_prod_cd_rev"+vprocess_input_table_RowCount+"' value=''></input>",
    		"	<input type='text' class='form-control' id='txt_std_proc_qnt"+vprocess_input_table_RowCount+"' value='' numberonly></input>",			// 14. 표준공수
    		"	<input type='text' class='form-control' id='txt_std_man_amt"+vprocess_input_table_RowCount+"' value='' numberonly></input>",			// 15. 필요인원수
    		"	<input type='text' class='form-control' id='txt_seolbi_cd"+vprocess_input_table_RowCount+"' style='float:left; width:70%;' value='' disabled></input>" + // 16. 설비코드
    		"	<button type='button' onclick='seolbiIns("+vprocess_input_table_RowCount+")' id='btn_SearchProd' class='btn btn-info' style='float:left;width:30%;'>검색</button> ",	
    		"	<input type='text' class='form-control' id='txt_seolbi_cd_rev"+vprocess_input_table_RowCount+"' value=''></input>",
    		"	<input type='text' class='form-control' id='txt_seolbi_line"+vprocess_input_table_RowCount+"' value=''></input>",			// 19. 설비라인
    		"	<input type='text' class='form-control' id='txt_work_order_index"+vprocess_input_table_RowCount+"' value=''></input>",
    		"	<input type='text' class='form-control' id='txt_bigo"+vprocess_input_table_RowCount+"' value=''></input>",
    		"	<input type='text' class='form-control' id='txt_start_date' value='' readonly></input>",			// 22. 시작일자
    		"	<input type='text' class='form-control' id='txt_create_date' value='' readonly></input>",			// 23. 생성일자
    		"	<input type='text' class='form-control' id='txt_create_user_id"+vprocess_input_table_RowCount+"' value=''></input>",
    		"	<input type='text' class='form-control' id='txt_modify_date' value=''></input>",
    		"	<input type='text' class='form-control' id='txt_modify_user_id"+vprocess_input_table_RowCount+"' value=''></input>",
    		"	<input type='text' class='form-control' id='txt_duration_date' value='9999-12-31'></input>",
    		"	<input type='text' class='form-control' id='txt_modify_reason"+vprocess_input_table_RowCount+"' value='' disabled></input>",			// 28. 수정사유
    		"	<input type='text' class='form-control' id='txt_check_data_type"+vprocess_input_table_RowCount+"' value=''></input>",
    		"	<input type='text' class='form-control' id='txt_delyn"+vprocess_input_table_RowCount+"' value=''></input>",
    		"	<input type='text' class='form-control' id='txt_product_process_yn"+vprocess_input_table_RowCount+"' value=''></input>",
    		"	<input type='text' class='form-control' id='txt_packing_process_yn"+vprocess_input_table_RowCount+"' value=''></input>",
    		""
        ] ).draw();
		// 숫자만
		$("input:text[numberOnly]").on("keyup", function() {
			$(this).val($(this).val().replace(/[^0-9]/g,""));
		});
		var trInput = $($("#product_tbody tr")[vprocess_input_table_RowCount-1]).find(":input");
		trInput.eq(0).val(vprocess_input_table_RowCount);
		var vSerialNo =  "00000" + "1";
		var vLotNo = trInput.eq(6).val();
		var today = new Date();
		var fromday = new Date();
		
		for(i=0;i<vprocess_input_table_RowCount;i++){
			$('input[id=txt_start_date]').eq(i).datepicker({
				format: 'yyyy-mm-dd',
				autoclose: true,
				language: 'ko'
			});
			$('#txt_start_date').datepicker('update', fromday);
		}
		for(i=0;i<vprocess_input_table_RowCount;i++){
			$('input[id=txt_create_date]').eq(i).datepicker({
				format: 'yyyy-mm-dd',
				autoclose: true,
				language: 'ko'
			});
			$('#txt_create_date').datepicker('update', fromday);
		}
    	for(i=0;i<vprocess_input_table_RowCount;i++){
	   		$('input[id=txt_modify_date]').eq(i).datepicker({
	   			format: 'yyyy-mm-dd',
	   			autoclose: true,
	   			language: 'ko'
	   		});
	   		$('#txt_modify_date').datepicker('update', fromday);
		}
		for(i=0;i<vprocess_input_table_RowCount;i++){	
	   		$('input[id=txt_duration_date]').eq(i).datepicker({
	   			format: 'yyyy-mm-dd',
	   			autoclose: true,
	   			language: 'ko'
	   		});
	   		$('#txt_duration_date').datepicker('update', fromday);
	   	}
    }
    
	function fn_mius_body(){  	        
		vprocess_input_table
		.row( vprocess_input_table_RowCount-1 )
		.remove()
		.draw();
	}
    
    </script>
</head>      				
<body>
<!--    <table class="table table-hover" style="width: 100%; margin: 0 auto; align:left"> -->
<!-- <form id="mesfrm"> -->
	<table class="table" style="width: 100%; margin: 0 auto; align:left;">
		<tr style="background-color: #fff;">
            <td style=" font-weight: 900; font-size:14px; text-align:left">제품코드</td>
            <td>
           	<input type="text"  id="txt_Productcode" class="form-control" style="width: 200px; border: solid 1px #cccccc; vertical-align: middle; float: left;" readonly />
			<button type="button" onclick="parent.pop_fn_Product_View(1,2)" id="btn_SearchProd" class="btn btn-info" style="margin-left: 10px; float: left">검색</button>
			</td>
			<td style=" font-weight: 900; font-size:14px; text-align:left; display:none;">제품코드개정번호</td>
            <td style="display:none;"><input type="text" id="txt_prod_rev" class="form-control" style="width: 200px; border: solid 1px #cccccc;" readonly/></td>		        
        </tr>
	</table>
	<table class="table " id="process_input_table" style="width: 100%; margin: 0 auto; align:left">
		<thead>
	        <tr style="vertical-align: middle">
				<th style="width: 0%; font-weight: 900; font-size:14px; text-align:center; vertical-align: middle; display:none;">member_key</th>
				<th style="width: 0%; font-weight: 900; font-size:14px; text-align:center; vertical-align: middle; display:none;">공정구분</th>         	
				<th style="width: 0%; font-weight: 900; font-size:14px; text-align:center; vertical-align: middle; display:none;">공정구분개정번호</th>   	
				<th style="width: 0%; font-weight: 900; font-size:14px; text-align:center; vertical-align: middle; display:none;">공정구분Big</th>     	
				<th style="width: 0%; font-weight: 900; font-size:14px; text-align:center; vertical-align: middle; display:none;">공정구분Mid</th>      	
				<th style="width: 178px; font-weight: 900; font-size:14px; text-align:center; vertical-align: middle;">공정코드</th>       	  	
				<th style="width: 0%; font-weight: 900; font-size:14px; text-align:center; vertical-align: middle; display:none;">공정코드개정번호</th>    	
				<th style="width: 0%; font-weight: 900; font-size:14px; text-align:center; vertical-align: middle; display:none;">공정명</th>	              	
				<th style="width: 89px; font-weight: 900; font-size:14px; text-align:center; vertical-align: middle; display:none;">순서</th>          	
				<th style="width: 0%; font-weight: 900; font-size:14px; text-align:center; vertical-align: middle; display:none;">부서구분</th>
				<th style="width: 0%; font-weight: 900; font-size:14px; text-align:center; vertical-align: middle; display:none;">제품코드</th>
				<th style="width: 0%; font-weight: 900; font-size:14px; text-align:center; vertical-align: middle; display:none;">제품rev</th>         	
				<th style="width: 178px; font-weight: 900; font-size:14px; text-align:center; vertical-align: middle;">표준공수(단위:시간)</th>             
				<th style="width: 178px; font-weight: 900; font-size:14px; text-align:center; vertical-align: middle;">필요인원수(단위:명)</th>             
				<th style="width: 178px; font-weight: 900; font-size:14px; text-align:center; vertical-align: middle;">설비코드</th>                      
				<th style="width: 0%; font-weight: 900; font-size:14px; text-align:center; vertical-align: middle; display:none;">설비코드개정번호</th>     
				<th style="width: 178px; font-weight: 900; font-size:14px; text-align:center; vertical-align: middle;">설비라인</th>                      
				<th style="width: 0%; font-weight: 900; font-size:14px; text-align:center; vertical-align: middle; display:none;">work_order_index</th> 
				<th style="width: 0%; font-weight: 900; font-size:14px; text-align:center; vertical-align: middle; display:none;">비고</th>              
				<th style="width: 0%; font-weight: 900; font-size:14px; text-align:center; vertical-align: middle; display:none;">시작일자</th>           
				<th style="width: 0%; font-weight: 900; font-size:14px; text-align:center; vertical-align: middle; display:none;">생성일자</th>           
				<th style="width: 0%; font-weight: 900; font-size:14px; text-align:center; vertical-align: middle; display:none;">생성자</th>            
				<th style="width: 178px; font-weight: 900; font-size:14px; text-align:center; vertical-align: middle;">수정일자</th>                      
				<th style="width: 178px; font-weight: 900; font-size:14px; text-align:center; vertical-align: middle;">수정자</th>
				<th style="width: 0%; font-weight: 900; font-size:14px; text-align:center; vertical-align: middle; display:none;">지속기간</th>
				<th style="width: 178px; font-weight: 900; font-size:14px; text-align:center; vertical-align: middle;">수정사유</th>           
				<th style="width: 0%; font-weight: 900; font-size:14px; text-align:center; vertical-align: middle; display:none;">체크데이터 유형</th>
				<th style="width: 0%; font-weight: 900; font-size:14px; text-align:center; vertical-align: middle; display:none;">지연여부</th>     
				<th style="width: 0%; font-weight: 900; font-size:14px; text-align:center; vertical-align: middle; display:none;">생산공정여부</th>  
				<th style="width: 0%; font-weight: 900; font-size:14px; text-align:center; vertical-align: middle; display:none;">포장공정여부</th>  
				<th style="width: 8%; font-weight: 900; font-size:14px; text-align:center; vertical-align: middle">  
                	<button alt="한줄 추가" id="btn_plus"  class="btn btn-info btn-sm" >+</button>
                	<button alt="한줄 삭제" id="btn_mius"  class="btn btn-info btn-sm" >-</button>
                </th>
			</tr>
		</thead>
		<tbody id="product_tbody"></tbody>
	</table>
<!-- </form>     -->
		<table class="table table-bordered " style="width: 100%; margin: 0 ; align:left" id="bom_table">	               
			<tr>
				<td align="center">
					<button id="btn_Save"  class="btn btn-info" style="width: 100px" onclick="SaveOderInfo();">저장</button>
					<button id="btn_Canc"  class="btn btn-info" style="width: 100px" onclick="parent.$('#modalReport').hide();">취소</button>
				</td>
			</tr>
		</table>
</body>
</html>