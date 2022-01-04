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
S202S120102.jsp
자재입고 수정 
*/
	String loginID = session.getAttribute("login_id").toString();
	String member_key = session.getAttribute("member_key").toString();
	String history_yn = session.getAttribute("history_yn").toString();
	DoyosaeTableModel TableModel;
	

	String GV_JSPPAGE="", GV_NUM_GUBUN="";
	String GV_PART_CD="",GV_PART_CD_REV="", GV_IPGO_NO="", GV_PART_NAME="", GV_MACHINENO="",GV_RAKES="",GV_PLATE="",GV_COLM="",GV_IO_AMT="",GV_PRE_AMT="",
			GV_POST_AMT="",GV_PARTGUBUN_BIG="",GV_PARTGUBUN_MID="", GV_IO_SEQNO="", GV_ORDERNO="",GV_LOTNO="",
			 GV_lMACHINENO="",GV_lRAKES="",GV_lPLATE="",GV_lCOLM="",GV_lIO_AMT="",GV_lPRE_AMT="",GV_lPOST_AMT="",GV_EXPIRATION_DATE="",GV_HIST_NO="";
	
	if(request.getParameter("part_cd")== null)
		GV_PART_CD="";
	else
		GV_PART_CD = request.getParameter("part_cd");
	
	if(request.getParameter("part_cd_rev")== null)
		GV_PART_CD_REV="";
	else
		GV_PART_CD_REV = request.getParameter("part_cd_rev");
	
	if(request.getParameter("part_name")== null)
		GV_PART_NAME="";
	else
		GV_PART_NAME = request.getParameter("part_name");
	
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

	if(request.getParameter("partgubun_big")== null)
		GV_PARTGUBUN_BIG="";
	else
		GV_PARTGUBUN_BIG = request.getParameter("partgubun_big");
	
	if(request.getParameter("partgubun_mid")== null)
		GV_PARTGUBUN_MID="";
	else
		GV_PARTGUBUN_MID = request.getParameter("partgubun_mid");
	


	if(request.getParameter("OrderNo")== null)
		GV_ORDERNO="";
	else
		GV_ORDERNO = request.getParameter("OrderNo");


	if(request.getParameter("LotNo")== null)
		GV_LOTNO="";
	else
		GV_LOTNO = request.getParameter("LotNo");
	
	if(request.getParameter("ipgo_no")== null)
		GV_IPGO_NO="";
	else
		GV_IPGO_NO = request.getParameter("ipgo_no");
	
	if(request.getParameter("io_seqno")== null)
		GV_IO_SEQNO="";
	else
		GV_IO_SEQNO = request.getParameter("io_seqno");
		
	
	if(request.getParameter("lmachineno")== null)
		GV_lMACHINENO="";
	else
		GV_lMACHINENO = request.getParameter("lmachineno");
	if(request.getParameter("lrakes")== null)
		GV_lRAKES="";
	else
		GV_lRAKES = request.getParameter("lrakes");
	if(request.getParameter("lplate")== null)
		GV_lPLATE="";
	else
		GV_lPLATE = request.getParameter("lplate");
	if(request.getParameter("lcolm")== null)
		GV_lCOLM="";
	else
		GV_lCOLM = request.getParameter("lcolm");
	if(request.getParameter("lio_amt")== null)
		GV_lIO_AMT="";
	else
		GV_lIO_AMT = request.getParameter("lio_amt");

	if(request.getParameter("lpre_amt")== null)
		GV_lPRE_AMT="";
	else
		GV_lPRE_AMT = request.getParameter("lpre_amt");
	if(request.getParameter("lpost_amt")== null)
		GV_lPOST_AMT="";
	else
		GV_lPOST_AMT = request.getParameter("lpost_amt");
	
	if(request.getParameter("expiration_date")== null)
		GV_EXPIRATION_DATE="";
	else
		GV_EXPIRATION_DATE = request.getParameter("expiration_date");
	
	if(request.getParameter("hist_no")== null)
		GV_HIST_NO="";
	else
		GV_HIST_NO = request.getParameter("hist_no");
	
	String store_info_width;
	if (GV_MACHINENO.equals(""))
		store_info_width="250";
	else
		store_info_width="0";
%>
    <script type="text/javascript">
    
    $(document).ready(function () {
    	var M202S120100E101 = {
    			PID:  "M202S120100E101", 
    			totalcnt: 0,
    			retnValue: 999,
    			colcnt: 0,
    			colname: ["","","",""], //insert, Update, Delete 문장을 처리할 때는 사용되지않음
    			data: []
    	};  
    	
    	var SQL_Param = {
    			PID:  "M202S120100E101",
    			excute: "queryProcess",
    			stream: "N",
    			param: ""
    	};
    	
    	
        $("#txt_ipgo_date").datepicker({
        	format: 'yyyy-mm-dd',
        	autoclose: true,
        	language: 'ko'
        });
        var today = new Date();
        var fromday = new Date();
        fromday.setDate(today.getDate());        
        
//      $('#txt_ipgo_date').datepicker('update', fromday);

		$('#txt_io_user_id').val('<%=loginID%>');
		
		$('#txt_ipgo_no').val('<%=GV_IPGO_NO%>');
		$('#txt_store_no').val('<%=GV_MACHINENO%>');
		$('#txt_rakes_no').val('<%=GV_RAKES%>');
		$('#txt_plate_no').val('<%=GV_PLATE%>');
		$('#txt_colm_no').val('<%=GV_COLM%>');
<%-- 		$('#txt_io_count').val('<%=GV_IO_AMT%>'); --%>
		$('#txt_pre_amt').val('<%=GV_PRE_AMT%>');
		$('#txt_post_stack').val('<%=GV_POST_AMT%>');
		
		$('#txt_part_cd').val('<%=GV_PART_CD%>');
		$('#txt_part_cd_rev').val('<%=GV_PART_CD_REV%>');
		$('#txt_part_name').val('<%=GV_PART_NAME%>');
		$('#txt_expiration_date').val('<%=GV_EXPIRATION_DATE%>');
		$('#txt_hist_no').val('<%=GV_HIST_NO%>');
		$('#txt_bigo').val('재고조정');
		
		if($("#txt_pre_amt").val()==""){$("#txt_pre_amt").val(0);}
		if($("#txt_post_stack").val()==""){$("#txt_post_stack").val(0);} 
		
	    // 숫자만
	    $("input:text[numberOnly]").on("keyup", function() {
	        $(this).val($(this).val().replace(/[^0-9]/g,""));
	    });
	    
	 	// 숫자 또는 소수점만
	 	$("input:text[numberPoint]").on("keyup", function() {
	 		$(this).val($(this).val().replace(/[^0-9.]/g,""));
	 	});
		
		$.ajax({
            type: "POST",
			async: false,
            url: "<%=Config.this_SERVER_path%>/Contents/CommonView/Release_part_search_table.jsp", 
            data: "part_cd=" + '<%=GV_PART_CD%>',
            beforeSend: function () {
                $("#Release_part_search_table_tbody").children().remove();
            },
            success: function (html) {           	 
      			$("#Release_part_search_table_tbody").hide().html(html).fadeIn(100);
            },
            error: function (xhr, option, error) {

            }
        });
//         $.ajax({
// 	        type: "POST",
<%--             url: "<%=Config.this_SERVER_path%>/Contents/Business/M202/S202S120140.jsp",  --%>
<%-- 	        data: "part_cd=" + "<%=GV_PART_CD%>" ,  --%>
// 	        beforeSend: function () {
// 	            $("#inspect_body").children().remove();
// 	        },
// 	        success: function (html) {
// 	            $("#inspect_body").hide().html(html).fadeIn(100);
// 	        },
// 	        error: function (xhr, option, error) {
// 	        }
//  		});
    });	

	
	function SaveOderInfo() {        
		
		<%if(history_yn.equals("Y")){ %>
    	if($('#txt_hist_no').val() == ""){
			alert("이력번호를 검색하여 주세요.");
 			return;
    	}
    	<%}%>
		
		if($('#txt_store_no').val()=='' || $('#txt_rakes_no').val()=='' ||
			$('#txt_plate_no').val()=='' ||	$('#txt_colm_no').val()=='') {
			alert("보관창고를 선택하세요");
			return false;
		} else if($('#txt_io_count').val()=='') {
			alert("조정수량을 입력하세요");
			return false;
		} else {
			var qa1 = $(':input[name="txt_gubun"]:radio:checked').val();
			
			// 출고조정일때 재고수량보다 조정수량이 많을경우
			if( qa1 == "CHL" && ( parseInt($('#txt_io_count').val()) > parseInt($('#txt_post_stack').val().replace(/,/gi,'')) ) ) { 
				alert("출고조정 수량이 재고를 초과합니다");
				return false;
			}
			
	        var dataJsonHead = new Object(); // JSON Object 선언
	        var jArray = new Array(); // JSON Array 선언
	        
			dataJsonHead.jsp_page 		= '<%=GV_JSPPAGE%>';								
			dataJsonHead.user_id 		= '<%=loginID%>';									
			dataJsonHead.ipg 			= qa1;											//입고, 채번 prefix

	    	var ipgo_no="1";
			var dataJsonBody = new Object(); // JSON Object 선언
			dataJsonBody.ipgo_no 		= ipgo_no;											//0 ipgo_no
			dataJsonBody.io_user_id 	= $('#txt_io_user_id').val();						//1 입고담당자
			dataJsonBody.part_cd 		= $('#txt_part_cd').val();							//2 원부자재코드	
			dataJsonBody.part_cd_rev 	= $('#txt_part_cd_rev').val();						//3 원부자재개정번호
			dataJsonBody.store_no 		= $('#txt_store_no').val();							//4 창고번호
			dataJsonBody.rakes_no 		= $('#txt_rakes_no').val();							//5 렉번호
			dataJsonBody.plate_no 		= $('#txt_plate_no').val();							//6 선반번호
			dataJsonBody.colm_no 		= $('#txt_colm_no').val();							//7 칸번호	
			dataJsonBody.pre_amt 		= $('#txt_pre_amt').val().replace(/,/gi,'');		//8 입고 전 재고량	
			dataJsonBody.post_stack 	= $('#txt_post_stack').val().replace(/,/gi,'');		//9 입고 후 재고량
			dataJsonBody.io_count 		= $('#txt_io_count').val();							//10 입출고 수량	
			dataJsonBody.bigo 			= $('#txt_bigo').val();								//11 비고	
			dataJsonBody.part_nm 		= $('#txt_part_name').val();						//12 원부자재명
			dataJsonBody.warehousing_date 		= $('#txt_ipgo_date').val();				//13 입고날짜
			dataJsonBody.expiration_date 		= $('#txt_expiration_date').val();			//14 유통기한
			dataJsonBody.member_key		= '<%=member_key%>';
// 			dataJsonBody.hist_no		= $('#txt_hist_no').val();	

	       	<%if(history_yn.equals("Y")){ %>
        	dataJsonBody.hist_no		= $('#txt_hist_no').val();
        	<%} else{ %>
        	dataJsonBody.hist_no		= 'NON';
        	<%}%>
        	

			jArray.push(dataJsonBody);
			
			var dataJsonMulti = new Object();
			dataJsonMulti.paramHead = dataJsonHead;
			console.log("jarray 확인 : "+ jArray);
			dataJsonMulti.param = jArray; // Array를 다시 Object형태로 변환 {"param":{Array...}}

			var JSONparam = JSON.stringify(dataJsonMulti); // JSON Object전송을 위해 문자열형태로 바꿔줌(stringify)
			
			var pID="";
			if(qa1=="IPG")	pID = "M202S120100E101"
			else 	pID = "M202S120100E201"
//	     	var parmBody =	""
	<%--     	+ "<%=GV_ORDERNO%>"				+ "|"	//0 --%>
//	     	+ $('#txt_ipgo_no').val() 		+ "|"	//1 ipgo_no
//	     	+ $('#txt_ipgo_date').val() 	+ "|"	//2 TO_CHAR(sysdate,'YYYY-MM-DD')
	<%--     	+ "<%=GV_IO_SEQNO%>"			+ "|"	//3 --%>
//	     	+ "io_time"						+ "|"	//4 query에서는 to_char(SYSTIME,'HH24:MI:SS') 
//	     	+ $('#txt_io_user_id').val() 	+ "|"	//5 입고담당자
//	 		+ $('#txt_part_cd').val()		+ "|"	//6 원부자재코드
//	 		+ $('#txt_part_cd_rev').val()	+ "|"	//7 원부자재개정번호
//	 		+ $('#txt_store_no').val()		+ "|"	//8 창고번호
//	 		+ $('#txt_rakes_no').val()		+ "|"	//9 렉번호
//	 		+ $('#txt_plate_no').val()		+ "|"	//10 선반번호
//	 		+ $('#txt_colm_no').val()		+ "|"	//11 칸번호
//	 		+ $('#txt_pre_amt').val()		+ "|"	//12 입고 전 재고량
//	 		+ $('#txt_post_stack').val()	+ "|"	//13 입고 후 재고량
//	 		+ $('#txt_io_count').val()		+ "|"	//14 입출고 수량
//	 		+ $('#txt_bigo').val()			+ "|"	//15 비고		
	<%-- 		+ "<%=Config.DATATOKEN %>" 	; --%>

			var chekrtn = confirm("등록하시겠습니까?"); 
			
			if(chekrtn){
				SendTojsp(JSONparam, pID); // SendToJSP를 통해 ajax로 데이터(JSONObject,PID) 보냄
			}
		}
	}
    
	function SendTojsp(bomdata, pid){
		
	    $.ajax({
	         type: "POST",
	         dataType: "json",
	         url: "<%=Config.this_SERVER_path%>/Contents/CommonView/insert_update_delete_json.jsp", 
	         data:  {"bomdata" : bomdata, "pid" : pid },
	         beforeSend: function () {
// 	         	 alert(bomdata);
	         },
	         
	         success: function (html) {	
	        	 if(html>-1){
		        	parent.fn_MainInfo_List();
		        	parent.$('#SubInfo_List_contents').hide();
//	        		parent.fn_DetailInfo_List();
// 	                parent.$("#ReportNote").children().remove();
// 	         		parent.$('#modalReport').hide();
	         	 
	         	 	// 화면상 이전재고&현재재고 업데이트
		        	$('#txt_pre_amt').val($('#txt_post_stack').val());
		        	var new_post_stack = '';
	         		if(pid=='M202S120100E101'){ //입고
	         			new_post_stack = Number($('#txt_post_stack').val().replace(/,/gi,'')) + Number($('#txt_io_count').val());
		         		 
		         	 } else if(pid=="M202S120100E201"){ //출고
		         		new_post_stack = Number($('#txt_post_stack').val().replace(/,/gi,'')) - Number($('#txt_io_count').val());
		         	 }	
	         		alert(pid);
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
<!-- 		//원부자재입고 -->
		<div style="width: 650px;float: left; vertical-align: top">
					<input type="hidden" class="form-control" id="txt_ipgo_no" readonly></input>
					<input type="hidden" class="form-control" id="txt_io_seqno" readonly></input>
					<input type="hidden" class="form-control" id="txt_io_time" readonly></input>
					<input type="hidden" class="form-control" id="txt_io_user_id" readonly></input>
					
        	<table class="table table-striped" style="width: 100%; margin: 0 ; align:left ;" id="bom_table">
	        	<tr style="vertical-align: middle">
	        		<td style="width: 20%; font-weight: 900; font-size:14px; text-align:center; vertical-align: middle">일자</td>
	        		<td style="width: 30%;">
					<input type="text" data-date-format="yyyy-mm-dd" id="txt_ipgo_date" class="form-control" />
	        		</td>
	        		<td colspan="2" style="width: 50%;">
		        		<input type="radio" id="txt_gubun" name="txt_gubun" checked="checked" value="IPG" style="width: 60px;">입고조정</input>
		           		<input type="radio" id="txt_gubun" name="txt_gubun" value="CHL" style="width: 60px;">출고조정</input>
	        		</td>
	        	</tr>
	        	<tr style="vertical-align: middle">
	        		<td style="font-weight: 900; font-size:14px; text-align:center; vertical-align: middle">원부자재코드</td>
	        		<td><input type="text" 	 class="form-control" id="txt_part_cd" readonly ></input> </td>
	        		<td style="font-weight: 900; font-size:14px; text-align:center; vertical-align: middle">개정번호</td>
	        		<td><input type="text" 	 class="form-control"  id="txt_part_cd_rev" style="width:100px" readonly ></input></td>
	        	</tr>
	        	<tr style="vertical-align: middle">
	        		<td style="font-weight: 900; font-size:14px; text-align:center; vertical-align: middle">원부자재명</td>
	        		<td colspan="3"><input type="text" class="form-control" id="txt_part_name" readonly></input></td>
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
	        		<td>
	        			<input type="text" 	 class="form-control" id="txt_store_no"  style="width:100px" readonly></input>
	        			<input type="hidden" class="form-control" id="txt_rakes_no"  style="width:100px" readonly></input>
	        			<input type="hidden" class="form-control" id="txt_plate_no"  style="width:100px" readonly></input>
	        			<input type="hidden" class="form-control" id="txt_colm_no"  style="width:100px" readonly></input>
	        		</td>
<!-- 	        		<td style="font-weight: 900; font-size:14px; text-align:center; vertical-align: middle">렉번호</td> -->
<!-- 	        		<td><input type="text" 	 class="form-control" id="txt_rakes_no"  style="width:100px" readonly></input></td> -->
<!-- 	        	</tr> -->
<!-- 	        	<tr style="vertical-align: middle"> -->
<!-- 	        		<td style="font-weight: 900; font-size:14px; text-align:center; vertical-align: middle">선반번호</td> -->
<!-- 	        		<td><input type="text" 	 class="form-control" id="txt_plate_no"  style="width:100px"  readonly></input></td> -->
<!-- 	        		<td style="font-weight: 900; font-size:14px; text-align:center; vertical-align: middle">칸 번호</td> -->
<!-- 	        		<td><input type="text" 	 class="form-control" id="txt_colm_no"  style="width:100px"  readonly></input></td> -->
<!-- 	        	</tr> -->
<!-- 	        	<tr style="vertical-align: middle"> -->
	        		<td style="font-weight: 900; font-size:14px; text-align:center; vertical-align: middle">조정수량</td>
	        		<td><input type="text" numberPoint	 class="form-control" id="txt_io_count"  style="width:100px"></input></td>
<!-- 	        		<td style="font-weight: 900; font-size:14px; text-align:center; vertical-align: middle"></td> -->
<!-- 	        		<td></td> -->
	        	</tr>
	        	<%if(history_yn.equals("Y")){ %>
	        	<tr style="vertical-align: middle">
	        		<td style="font-weight: 900; font-size:14px; text-align:center; vertical-align: middle">이력번호</td>
	        		<td>
	        			<input type="text" 	 class="form-control" id="txt_hist_no"  style="width:100px;float: left;" readonly="readonly" ></input>
<!-- 	        			<button id="btn_store_search"  class="btn btn-info"  onclick="pop_fn_store_search()" style="width: 30%;float: left;">검색</button> -->
	        		</td>
        		</tr>
        		<%} %>
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
				        			style="font-weight: 900; font-size:18px;width:130px;height:60px;">재고 보정</button>
					        <button id="btn_Canc"  class="btn btn-info"  onclick="$('#modalReport').modal('hide');" 
					        		style="font-weight: 900; font-size:18px;width:130px;height:60px;;margin-left:30px;">취소</button>
				        </p>
        			</td>
	        	</tr>
        	</table>
		</div> 
<!-- 		//수량 키패드 radio -->
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
		<table  class='table table-bordered nowrap table-hover' id="Release_part_search_table_tbody" style="width: 100%">
 		<tbody id="Release_part_search_table_tbody">		
		</tbody>
		</table>
	</div>
	</div>