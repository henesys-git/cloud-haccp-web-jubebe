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
S858S060201.jsp
자재출고 등록 
*/
	String loginID = session.getAttribute("login_id").toString();
	String member_key = session.getAttribute("member_key").toString();
	DoyosaeTableModel TableModel;

	String GV_JSPPAGE="", GV_NUM_GUBUN="";
	String GV_PROD_CD="",GV_PROD_CD_REV="", GV_PROD_NAME="", GV_MACHINENO="",GV_RAKES="",GV_PLATE="",GV_COLM="",GV_IO_AMT="",GV_PRE_AMT="",
			GV_POST_AMT="",GV_PRODGUBUN_BIG="",GV_PRODGUBUN_MID="", GV_ORDERNO="",GV_LOTNO="",GV_EXPIRATION_DATE="",GV_PRODUCTION_DATE="";

	if(request.getParameter("prod_cd")== null)
		GV_PROD_CD="";
	else
		GV_PROD_CD = request.getParameter("prod_cd");
	
	if(request.getParameter("prod_cd_rev")== null)
		GV_PROD_CD_REV="";
	else
		GV_PROD_CD_REV = request.getParameter("prod_cd_rev");
	
	if(request.getParameter("prod_name")== null)
		GV_PROD_NAME="";
	else
		GV_PROD_NAME = request.getParameter("prod_name");
	
	if(request.getParameter("machineno")== null)
		GV_MACHINENO="";
	else
		GV_MACHINENO = request.getParameter("machineno");
	if(request.getParameter("rakes")== null)
		GV_RAKES="";
	else
		GV_RAKES = request.getParameter("rakes");
	if(request.getParameter("plate")== null)
		GV_PLATE="";
	else
		GV_PLATE = request.getParameter("plate");
	if(request.getParameter("colm")== null)
		GV_COLM="";
	else
		GV_COLM = request.getParameter("colm");
	if(request.getParameter("io_amt")== null)
		GV_IO_AMT="";
	else
		GV_IO_AMT = request.getParameter("io_amt");

	if(request.getParameter("pre_amt")== null)
		GV_PRE_AMT="";
	else
		GV_PRE_AMT = request.getParameter("pre_amt");
	if(request.getParameter("post_amt")== null)
		GV_POST_AMT="";
	else
		GV_POST_AMT = request.getParameter("post_amt");

	if(request.getParameter("prodgubun_big")== null)
		GV_PRODGUBUN_BIG="";
	else
		GV_PRODGUBUN_BIG = request.getParameter("prodgubun_big");
	if(request.getParameter("prodgubun_mid")== null)
		GV_PRODGUBUN_MID="";
	else
		GV_PRODGUBUN_MID = request.getParameter("prodgubun_mid");

	if(request.getParameter("order_no")== null)
		GV_ORDERNO="";
	else
		GV_ORDERNO = request.getParameter("order_no");
	
	if(request.getParameter("expiration_date")== null)
		GV_EXPIRATION_DATE="";
	else
		GV_EXPIRATION_DATE = request.getParameter("expiration_date");
	
	if(request.getParameter("production_date")== null)
		GV_PRODUCTION_DATE="";
	else
		GV_PRODUCTION_DATE = request.getParameter("production_date");


	if(request.getParameter("LotNo")== null)
		GV_LOTNO="";
	else
		GV_LOTNO = request.getParameter("LotNo");
	
	String store_info_width;
	if (GV_MACHINENO.equals(""))
		store_info_width="250";
	else
		store_info_width="0";
%>
    
    <script type="text/javascript">
//  웹소켓 통신을 위해서 필요한 변수들 ---시작
	var M858S060100E101 = {
			PID:  "M858S060100E201", 
			totalcnt: 0,
			retnValue: 999,
			colcnt: 0,
			colname: ["","","",""], //insert, Update, Delete 문장을 처리할 때는 사용되지않음
			data: []
	};  
	
	var SQL_Param = {
			PID:  "M858S060100E201",
			excute: "queryProcess",
			stream: "N",
			param: ""
	};
 
    var JOB_GUBUN = "";

    
    $(document).ready(function () {
    	
    	$.ajax({
            type: "POST",
			async: false,
            url: "<%=Config.this_SERVER_path%>/Contents/CommonView/Release_prod_search_table.jsp", 
            data: "prod_cd=" + '<%=GV_PROD_CD%>',
            beforeSend: function () {
                $("#Release_prod_search_table_tbody").children().remove();
            },
            success: function (html) {           	 
      			$("#Release_prod_search_table_tbody").hide().html(html).fadeIn(100);
            },
            error: function (xhr, option, error) {

            }
        });

        $("#txt_ipgo_date").datepicker({
        	format: 'yyyy-mm-dd',
        	autoclose: true,
        	language: 'ko'
        });
        var today = new Date();
        var fromday = new Date();
        fromday.setDate(today.getDate());        
        
        $('#txt_ipgo_date').datepicker('update', fromday);

		$('#txt_io_user_id').val('<%=loginID%>');
		$('#txt_store_no').val('<%=GV_MACHINENO%>');
		$('#txt_rakes_no').val('<%=GV_RAKES%>');
		$('#txt_plate_no').val('<%=GV_PLATE%>');
		$('#txt_colm_no').val('<%=GV_COLM%>');
		$('#txt_pre_amt').val('<%=GV_PRE_AMT%>');
		$('#txt_post_stack').val('<%=GV_POST_AMT%>');
		
		$('#txt_prod_cd').val('<%=GV_PROD_CD%>');
		$('#txt_prod_cd_rev').val('<%=GV_PROD_CD_REV%>');
		$('#txt_prod_name').val('<%=GV_PROD_NAME%>');
		
		$('#txt_expiration_date').val('<%=GV_EXPIRATION_DATE%>');
		$('#txt_production_date').val('<%=GV_PRODUCTION_DATE%>');
		
		if($("#txt_pre_amt").val()==""){$("#txt_pre_amt").val(0);}
		if($("#txt_post_stack").val()==""){$("#txt_post_stack").val(0);}    	
	    // 숫자만
	    $("input:text[numberOnly]").on("keyup", function() {
	        $(this).val($(this).val().replace(/[^0-9]/g,""));
	    });
    	$("#txt_prod_cd_serch").change(function(key) {    
    		//한글입력 방지
    		var objTarget = key.srcElement || key.target;
    		if(objTarget.type == 'text') {
    			var value = objTarget.value;
    			if(/[ㄱ-ㅎㅏ-ㅡ가-핳]/.test(value)) {
    				alert("한글입력은 불가능합니다."+"\n"+"한/영 키를 눌러서 영문입력으로 전환하세요.");
					// objTarget.value = objTarget.value.replace(/[ㄱ-ㅎㅏ-ㅡ가-핳]/g,'');
					$('#txt_prod_cd_serch').val(""); // 입력에러났을경우 빈칸으로 (중복입력방지)
    				return false;
    			}
    		}
    		
	    	$.ajax({
		         type: "POST",
		         url: "<%=Config.this_SERVER_path%>/Contents/CommonView/prod_storage_search.jsp", 
		         data:  "prod_cd=" + $(this).val(),
		         beforeSend: function () {		         
		         },
		         
		         success: function (html) {
		        	 html = html.trim();
		        	 if(html.length > 0) {
			        	var txt_html = html.split("|");
				     	$("#txt_prod_cd", parent.document).val(txt_html[0]);
				     	$("#txt_prod_cd_rev", parent.document).val(txt_html[1]);
				     	$("#txt_prod_name", parent.document).val(txt_html[2]);
				     	$("#txt_store_no", parent.document).val(txt_html[3]);	// 창고번호
			     		$("#txt_rakes_no", parent.document).val(txt_html[4]);	// 렉번호
			     		$("#txt_plate_no", parent.document).val(txt_html[5]);	// 선반번호
			     		$("#txt_colm_no", parent.document).val(txt_html[6]);	// 칸번호
			     		$("#txt_pre_amt", parent.document).val(txt_html[8]);	// 이전 재고
			     		$("#txt_post_stack", parent.document).val(txt_html[9]);	// 현재 재고
			     		$("#txt_production_date", parent.document).val(txt_html[11]);	// 제품생산일자
			     		$("#txt_expiration_date", parent.document).val(txt_html[12]);	// 유통 기한

			     		$('#txt_prod_cd_serch').val(""); // 바코드 입력후 빈칸으로 (중복입력방지)
			         } else {
// 			        	맞는제품이 없을경우
			        	alert("바코드에 해당하는 제품이 없습니다.");
		 		        $("#txt_prod_name", parent.document).val("");
		 		     	$("#txt_prod_cd_rev", parent.document).val("");
		 		     	$("#txt_prod_cd", parent.document).val("");
		 		        $('#txt_prod_cd_serch').val(""); // 바코드 입력후 빈칸으로 (중복입력방지)
			         }
		         },
		         error: function (xhr, option, error) {
		        	 
		         }
		     });
	    	
	    	$.ajax({
		         type: "POST",
		         url: "<%=Config.this_SERVER_path%>/Contents/CommonView/Release_prod_search_table.jsp", 
		         data:  "prod_cd=" + $(this).val(),
		         beforeSend: function () {	
		        	 $("#Release_prod_search_table_tbody").children().remove();
		         },
		         
		         success: function (html) {
		        		$("#Release_prod_search_table_tbody").hide().html(html).fadeIn(100);
			     		
			     		$('#txt_prod_cd_serch').val(""); // 바코드 입력후 빈칸으로 (중복입력방지)
		         },
		         error: function (xhr, option, error) {
		        	 
		         }
		     });
	    });
    	
    	$('#txt_prod_cd_serch').focus();
    });	

	function prod_cd_serch(){

    	$.ajax({
	         type: "POST",
	         url: "<%=Config.this_SERVER_path%>/Contents/CommonView/prod_storage_search.jsp", 
	         data:  "prod_cd=" + $("#txt_prod_cd_serch").val(),
	         beforeSend: function () {		         
	         },
	         
	         success: function (html) {	
	        	 alert(html);
	         },
	         error: function (xhr, option, error) {

	         }
	     });
	}
	

	function SetProductName_code(txt_ProductName, txt_Productcode, txt_prod_rev) { //제품검색 2차팝업창에서 행 클릭했을때
// 		$("#txt_prod_cd").val(txt_prod_cd);
// 		$("#txt_prod_cd_rev").val(txt_prod_revision_no);
// 		$("#txt_prod_name").val(txt_prod_name);
		$("#txt_prod_cd_serch").val(txt_Productcode);
		$("#txt_prod_cd_serch").keyup();
	}
	
	function SetStorageName_code(txt_store_no, txt_rakes_no,txt_plate_no,txt_colm_no) { //제품검색 2차팝업창에서 행 클릭했을때
		$("#txt_store_no").val(txt_store_no);
		$("#txt_rakes_no").val(txt_rakes_no);
		$("#txt_plate_no").val(txt_plate_no);
		$("#txt_colm_no").val(txt_colm_no);
	}
	
	function SaveOderInfo() {        
		if($('#txt_store_no').val()=='' || $('#txt_rakes_no').val()=='' ||
			$('#txt_plate_no').val()=='' ||	$('#txt_colm_no').val()=='') {
			alert("보관창고를 선택하세요");
			return false;
		} else if($('#txt_io_count').val()=='') {
			alert("출고수량을 입력하세요");
			return false;
		} else if( parseInt($('#txt_io_count').val()) > parseInt($('#txt_post_stack').val().replace(/,/gi,'')) ) {
			alert("출고수량이 재고를 초과합니다");
			return false;
		} else {
			var dataJsonHead = new Object(); // JSON Object 선언
	        var jArray = new Array(); // JSON Array 선언
			var parmHead= "" 
			dataJsonHead.jsp_page 		= '<%=GV_JSPPAGE%>';								
			dataJsonHead.user_id 		= '<%=loginID%>';									
			dataJsonHead.ipg 			= 'CHL';										//입고, 채번 prefix
			dataJsonHead.headtoken 		= "<%=Config.HEADTOKEN %>";

			var dataJsonBody = new Object(); // JSON Object 선언
			
		    var chulgo="1";
		    
			dataJsonBody.ipgo_no 		= chulgo;							//0 chulgo
			dataJsonBody.io_user_id 	= $('#txt_io_user_id').val();						//1 출고담당자
			dataJsonBody.prod_cd 		= $('#txt_prod_cd').val();							//2 제품코드	
			dataJsonBody.prod_cd_rev 	= $('#txt_prod_cd_rev').val();						//3 제품개정번호
			dataJsonBody.store_no 		= $('#txt_store_no').val();							//4 창고번호
			dataJsonBody.rakes_no 		= $('#txt_rakes_no').val();							//5 렉번호
			dataJsonBody.plate_no 		= $('#txt_plate_no').val();							//6 선반번호
			dataJsonBody.colm_no 		= $('#txt_colm_no').val();							//7 칸번호	
			dataJsonBody.pre_amt 		= $('#txt_pre_amt').val().replace(/,/gi,'');		//8 입고 전 재고량	
			dataJsonBody.post_stack 	= $('#txt_post_stack').val().replace(/,/gi,'');		//9 입고 후 재고량
			dataJsonBody.io_count 		= $('#txt_io_count').val();							//10 입출고 수량
			dataJsonBody.warehousing_date 		= $('#txt_ipgo_date').val();				//13 입고날짜
			dataJsonBody.expiration_date 		= $('#txt_expiration_date').val();			//14 유통기한
			dataJsonBody.bigo 			= $('#txt_bigo').val();								//11 비고
			dataJsonBody.member_key = "<%=member_key%>";
			dataJsonBody.datatoken 		= '<%=Config.DATATOKEN %>';								
			jArray.push(dataJsonBody);

			var dataJsonMulti = new Object();
			dataJsonMulti.paramHead = dataJsonHead;
			console.log("jarray 확인 : "+ jArray);
			dataJsonMulti.param = jArray; // Array를 다시 Object형태로 변환 {"param":{Array...}}

			var JSONparam = JSON.stringify(dataJsonMulti); // JSON Object전송을 위해 문자열형태로 바꿔줌(stringify)

			var chekrtn = confirm("등록하시겠습니까?"); 
			
			if(chekrtn){
				SendTojsp(JSONparam, SQL_Param.PID); // SendToJSP를 통해 ajax로 데이터(JSONObject,PID) 보냄		
			}
			
			$('#txt_prod_cd_serch').focus();
		}
	}
    
	function SendTojsp(bomdata, pid){
		
	    $.ajax({
	         type: "POST",
	         url: "<%=Config.this_SERVER_path%>/Contents/CommonView/insert_update_delete_json.jsp", 
	         data:  {"bomdata" : bomdata, "pid" : pid },
	         beforeSend: function () {
	         
	         },
	         
	         success: function (html) {	
	        	 if(html>-1){
	        		parent.fn_MainInfo_List();
	        		parent.$('#SubInfo_List_contents').hide();
	                parent.$("#ReportNote").children().remove();
	         		parent.$('#modalReport').hide();
	         		//SendToStorage(SQL_Param.params, SQL_Param.UPID);
// 	        		$('#txt_store_no').val('');
// 	        		$('#txt_rakes_no').val('');
// 	        		$('#txt_plate_no').val('');
// 	        		$('#txt_colm_no').val('');
// 	        		$('#txt_io_count').val('');
// 	        		$('#txt_pre_amt').val('');
// 	        		$('#txt_post_stack').val('');
// 	        		$('#txt_prod_cd').val('');
// 	        		$('#txt_prod_cd_rev').val('');
// 	        		$('#txt_prod_name').val('');
	        		
	        		// 화면상 이전재고&현재재고 업데이트
			        $('#txt_pre_amt').val($('#txt_post_stack').val());	
			        var new_post_stack = Number($('#txt_post_stack').val().replace(/,/gi,'')) - Number($('#txt_io_count').val());
			        $('#txt_post_stack').val(new_post_stack.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ","));
	         	}
	         },
	         error: function (xhr, option, error) {

	         }
	     });		
	}      		
    
	function add_txt(obj){
    	 var io_cnt = $("#txt_io_count").val() + $(obj).text();
    	 $("#txt_io_count").val(io_cnt)
    } 

	function clear_txt(obj){
    	 var io_cnt = $("#txt_io_count").val();
    	 var io_length = io_cnt.length;
    	 $("#txt_io_count").val(io_cnt.substr(0,io_length-1));
    }    

    </script>

	<div style="width: 100%"> 
<!-- 		//창고정보 -->
<!-- 		<div id="store_info" style="width: 250px;float: left"> -->
		<div id="store_info" style="width: <%=store_info_width%>px;float: left; vertical-align: top">
		</div> 
<!-- 		//제품입고 -->
		<div style="width: 650px;float: left; vertical-align: top">					
	        		<input type="hidden" class="form-control" id="txt_ipgo_order" readonly></input>
					<input type="hidden" class="form-control" id="txt_chulgo" readonly></input>
					<input type="hidden" class="form-control" id="txt_io_seqno" readonly></input>
					<input type="hidden" class="form-control" id="txt_io_time" readonly></input>
					<input type="hidden" class="form-control" id="txt_io_user_id" readonly></input>
					<input type="hidden" class="form-control" id="txt_order_seq" readonly></input>
					
        	<table class="table table-striped" style="width: 100%; margin: 0 ; align:left ;" id="bom_table">
	        	<tr style="vertical-align: middle">
	        		<td style="width: 20%; font-weight: 900; font-size:14px; text-align:center; vertical-align: middle">일자</td>
	        		<td style="width: 30%;">
					<input type="text" data-date-format="yyyy-mm-dd" id="txt_ipgo_date" class="form-control" />
	        		</td>
	        		<td colspan="2" style="width: 50%;">
	        		
<!-- 	        		<input type="text" 	 class="form-control" id="txt_prod_cd_serch" style="width: 70%;float: left" onchange="prod_cd_serch();" ></input> -->
	        		<input type="text" 	 class="form-control" id="txt_prod_cd_serch" style="width: 70%;float: left" ></input>
<!-- 	        		<button id="btn_Save"  class="btn btn-info"  onclick="pop_fn_PartList_View(1)" style="width: 30%;float: left">제품검색</button> -->
	        		<button id="btn_Save"  class="btn btn-info"  onclick="pop_fn_ProductName_View(1)" style="width: 30%;float: left">제품검색</button>
	        		</td>
	        	</tr>
	        	<tr style="vertical-align: middle">
	        		<td style="font-weight: 900; font-size:14px; text-align:center; vertical-align: middle">제품코드</td>
	        		<td><input type="text" 	 class="form-control" id="txt_prod_cd" readonly ></input> </td>
	        		<td style="font-weight: 900; font-size:14px; text-align:center; vertical-align: middle">개정번호</td>
	        		<td><input type="text" 	 class="form-control"  id="txt_prod_cd_rev" style="width:100px" readonly ></input></td>
	        	</tr>
	        	<tr style="vertical-align: middle">
	        		<td style="font-weight: 900; font-size:14px; text-align:center; vertical-align: middle">제품명</td>
	        		<td colspan="3"><input type="text" class="form-control" id="txt_prod_name" readonly></input></td>
	        	</tr>
	        	<tr style="vertical-align: middle">
	        		<td style="font-weight: 900; font-size:14px; text-align:center; vertical-align: middle">이전 재고</td>
	        		<td><input type="text" 	 class="form-control" id="txt_pre_amt" style="width:100px"  readonly ></input></td>
	        		<td style="font-weight: 900; font-size:14px; text-align:center; vertical-align: middle">현재 재고</td>
	        		<td><input type="text" 	 class="form-control" id="txt_post_stack" style="width:100px"  readonly></input></td>
	        	</tr>
<!-- 	        	<tr style="vertical-align: middle"> -->
<!-- 	        		<td style="font-weight: 900; font-size:14px; text-align:center; vertical-align: middle">단위중량</td> -->
<!-- 	        		<td></td> -->
<!-- 	        		<td style="font-weight: 900; font-size:14px; text-align:center; vertical-align: middle">재고중량</td> -->
<!-- 	        		<td></td> -->
<!-- 	        	</tr> -->
	        	<tr style="vertical-align: middle">
	        		<td style="font-weight: 900; font-size:14px; text-align:center; vertical-align: middle">보관창고</td>
	        		<td colspan="2" style="width: 50%;" >
	        		<input type="text" 	 class="form-control" id="txt_store_no"  style="width: 35%; float: left;" readonly ></input>
	        		<button id="btn_Save"  class="btn btn-info"  onclick="pop_fn_StorageName_View(1)" style="width: 30%;float: left">창고검색</button>
	        		</td>
	        	</tr>
	        	<tr style="vertical-align: middle">
	        		<td style="font-weight: 900; font-size:14px; text-align:center; vertical-align: middle">렉번호</td>
	        		<td><input type="text" 	 class="form-control" id="txt_rakes_no"  style="width:100px" readonly ></input></td>
	        		<td style="font-weight: 900; font-size:14px; text-align:center; vertical-align: middle">선반번호</td>
	        		<td><input type="text" 	 class="form-control" id="txt_plate_no"  style="width:100px" readonly ></input></td>
	        	</tr>
	        	<tr style="vertical-align: middle">
	        		<td style="font-weight: 900; font-size:14px; text-align:center; vertical-align: middle">칸 번호</td>
	        		<td><input type="text" 	 class="form-control" id="txt_colm_no"  style="width:100px" readonly ></input></td>
	        		<td style="font-weight: 900; font-size:14px; text-align:center; vertical-align: middle">출고수량</td>
	        		<td><input type="text" numberOnly class="form-control" id="txt_io_count"  style="width:100px" ></input></td>
	        		<td></td>
	        		<td></td>
	        	</tr>
	        	<tr style="vertical-align: middle">
	        		<td style="font-weight: 900; font-size:14px; text-align:center; vertical-align: middle">제품생산일자</td>
	        		<td colspan="3"><input type="text" data-date-format="yyyy-mm-dd" id="txt_production_date" class="form-control" readonly="readonly" disabled="disabled" /></td>
	        	</tr>
	        	<tr style="vertical-align: middle">
	        		<td style="font-weight: 900; font-size:14px; text-align:center; vertical-align: middle">유통기한</td>
	        		<td colspan="3"><input type="text" data-date-format="yyyy-mm-dd" id="txt_expiration_date" class="form-control" readonly="readonly" disabled="disabled" /></td>
	        	</tr>
	        	<tr style="vertical-align: middle">
	        		<td style="font-weight: 900; font-size:14px; text-align:center; vertical-align: middle">비고</td>
	        		<td colspan="3"><input type="text" 	 class="form-control" id="txt_bigo"  ></input></td>
	        		
	        	</tr>
	        	<tr style="vertical-align: middle">
	        		<td colspan="4" style="font-weight: 900; font-size:14px; text-align:center; vertical-align: middle">
				        <p style="text-align:center;">
				        	<button id="btn_Save"  class="btn btn-info"  onclick="SaveOderInfo();" 
				        			style="font-weight: 900; font-size:18px;width:130px;height:60px;">출고저장</button>
					        <button id="btn_Canc"  class="btn btn-info"  onclick="parent.$('#modalReport').hide();" 
					        		style="font-weight: 900; font-size:18px;width:130px;height:60px;;margin-left:30px;">취소</button>
				        </p>
        			</td>
	        	</tr>
        	</table>
		</div> 
<!-- 		//수량 키패드 -->
		<div style="width: 400px;float: left; vertical-align: top">
			<div style="width:400px;height:110px;clear: both">
				<div style="width:110px;height:110px;float: left" >
					<button id="btn_1"  class="btn btn-info"  style="width:100%;height:100%;font-weight: 900; font-size:18px; " onclick="add_txt(this)" >1</button>
				</div>
				<div style="width:110px;height:110px;float: left" >
					<button id="btn_2"  class="btn btn-info"  style="width:100%;height:100%;font-weight: 900; font-size:18px;" onclick="add_txt(this)" >2</button>
				</div>
				<div style="width:110px;height:110px;float: left" >
					<button id="btn_3"  class="btn btn-info"  style="width:100%;height:100%;font-weight: 900; font-size:18px;" onclick="add_txt(this)" >3</button>
				</div>
			</div>
			<div style="width:400px;height:110px;clear: both">
				<div style="width:110px;height:110px;float: left" >
					<button id="btn_4"  class="btn btn-info"  style="width:100%;height:100%;font-weight: 900; font-size:18px;" onclick="add_txt(this)" >4</button>
				</div>
				<div style="width:110px;height:110px;float: left" >
					<button id="btn_5"  class="btn btn-info"  style="width:100%;height:100%;font-weight: 900; font-size:18px;" onclick="add_txt(this)" >5</button>
				</div>
				<div style="width:110px;height:110px;float: left" >
					<button id="btn_6"  class="btn btn-info"  style="width:100%;height:100%;font-weight: 900; font-size:18px;" onclick="add_txt(this)">6</button>
				</div>
			</div>
			<div style="width:400px;height:110px;clear: both">
				<div style="width:110px;height:110px;float: left" >
					<button id="btn_7"  class="btn btn-info"  style="width:100%;height:100%;font-weight: 900; font-size:18px;" onclick="add_txt(this)">7</button>
				</div>
				<div style="width:110px;height:110px;float: left" >
					<button id="btn_1"  class="btn btn-info"  style="width:100%;height:100%;font-weight: 900; font-size:18px;" onclick="add_txt(this)">8</button>
				</div>
				<div style="width:110px;height:110px;float: left" >
					<button id="btn_8"  class="btn btn-info"  style="width:100%;height:100%;font-weight: 900; font-size:18px;" onclick="add_txt(this)">9</button>
				</div>
			</div>
			<div style="width:400px;height:110px;clear: both">
				<div style="width:110px;height:110px;float: left" >
					<button id="btn_11"  class="btn btn-info"  style="width:100%;height:100%;font-weight: 900; font-size:18px;" onclick="clear_txt(this)"><=</button>
				</div>
				<div style="width:110px;height:110px;float: left" >
					<button id="btn_10"  class="btn btn-info"  style="width:100%;height:100%;font-weight: 900; font-size:18px;" onclick="add_txt(this)">0</button>
				</div>
				<div style="width:110px;height:110px;float: left" >
					<button id="btn_12"  class="btn btn-info"  style="width:100%;height:100%;font-weight: 900; font-size:18px;">></button>
				</div>
			</div>
		</div> 
			<div style="width: 400px;float: left; vertical-align: top">
		<table  class='table table-bordered nowrap table-hover' id="Release_prod_search_table_tbody" style="width: 100%">
 		<tbody id="Release_part_search_table_tbody">		
		</tbody>
		</table>
	</div>
	</div>
	