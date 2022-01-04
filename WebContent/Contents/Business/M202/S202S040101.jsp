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
S202S040101.jsp
주문별 자재출고 등록 
*/
	String loginID = session.getAttribute("login_id").toString();
	String member_key = session.getAttribute("member_key").toString();
	String history_yn = session.getAttribute("history_yn").toString();
	DoyosaeTableModel TableModel;
	String zhtml = "";

	String GV_JSPPAGE="", GV_NUM_GUBUN="" ;
	String GV_ORDERNO="",GV_LOTNO="",GV_BALJUNO="" ;
		
	if(request.getParameter("OrderNo")== null)
		GV_ORDERNO="";
	else
		GV_ORDERNO = request.getParameter("OrderNo");

	if(request.getParameter("LotNo")== null)
		GV_LOTNO="";
	else
		GV_LOTNO = request.getParameter("LotNo");
	if(request.getParameter("BaljuNo")== null)
		GV_BALJUNO="";
	else
		GV_BALJUNO = request.getParameter("BaljuNo");
	
	
	
	
	
	String GV_PART_CD="",GV_PART_CD_REV="", GV_PART_NAME="", GV_MACHINENO="",GV_RAKES="",GV_PLATE="",GV_COLM="",GV_IO_AMT="",GV_PRE_AMT="",
			GV_POST_AMT="",GV_PARTGUBUN_BIG="",GV_PARTGUBUN_MID="" ; 

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
	
%>
    
	<script type="text/javascript">
//  웹소켓 통신을 위해서 필요한 변수들 ---시작
	var M202S040100E101 = {
			PID:  "M202S040100E101", 
			totalcnt: 0,
			retnValue: 999,
			colcnt: 0,
			colname: ["","","",""], //insert, Update, Delete 문장을 처리할 때는 사용되지않음
			data: []
	};  
	
	var SQL_Param = {
			PID:  "M202S040100E101", 
			excute: "queryProcess",
			stream: "N",
			param: ""
	};
    $(document).ready(function () {
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
		
	    // 숫자만
	    $("input:text[numberOnly]").on("keyup", function() {
	        $(this).val($(this).val().replace(/[^0-9]/g,""));
	    });
	    
	 	// 숫자 또는 소수점만
	 	$("input:text[numberPoint]").on("keyup", function() {
	 		$(this).val($(this).val().replace(/[^0-9.]/g,""));
	 	});
    	
    	call_S202S040120();
    });	
    
    function call_S202S040120() {
    	$.ajax({
	        type: "POST",
	        async: false,
            url: "<%=Config.this_SERVER_path%>/Contents/Business/M202/S202S040120.jsp", 
	        data: "order_no=" + '<%=GV_ORDERNO%>' + "&lotno=" + '<%=GV_LOTNO%>'+ "&baljuNo=" + '<%=GV_BALJUNO%>' , 
	        beforeSend: function () {
	            $("#bom_info").children().remove();
	        },
	        success: function (html) {
	            $("#bom_info").hide().html(html).fadeIn(100);
	        },
	        error: function (xhr, option, error) {
	        }
 		});
    }
    
//     function pop_fn_store_search() {
<%--     	var modalContentUrl  = "<%=Config.this_SERVER_path%>/Contents/Business/M202/S202S030130.jsp"; --%>
//     	pop_fn_popUpScr_nd(modalContentUrl, "보관창고 조회", '50%', "40%");
// 		return false;
//     }
    
	function SaveOderInfo() {        
		
		var jArray = new Array(); // JSON Array 선언
		
		if($('#txt_store_no').val()=='' || $('#txt_reakes_no').val()=='' ||
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
	        dataJsonHead.jsp_page 	= '<%=GV_JSPPAGE%>';
	        dataJsonHead.login_id 	=  '<%=loginID%>'; 
	        dataJsonHead.prefix 	= 'CHL';

		    var chulgo="1";
		    var dataJson = new Object(); // JSON Object 선언
		    dataJson.chulgo_no		= chulgo;			//0 chulgo
		    dataJson.io_user_id		= $('#txt_io_user_id').val(); 	//1 입고담당자
		    dataJson.part_cd		= $('#txt_part_cd').val(); 		//2 원부자재코드
		    dataJson.part_cd_rev	= $('#txt_part_cd_rev').val(); 	//3 원부자재개정번호
		    dataJson.store_no		= $('#txt_store_no').val(); 	//4 창고번호
		    dataJson.reakes		= $('#txt_reakes_no').val(); 	//5 렉번호
		    dataJson.plate	= $('#txt_plate_no').val(); 	//6 선반번호
		    dataJson.colm	= $('#txt_colm_no').val(); 		//7 칸번호
		    dataJson.pre_amt	= $('#txt_pre_amt').val().replace(/,/gi,''); //8 입고 전 재고량
		    dataJson.post_stack	= $('#txt_post_stack').val().replace(/,/gi,''); //9 입고 후 재고량
		    dataJson.io_count	= $('#txt_io_count').val(); 	//10 입출고 수량
		    dataJson.bigo		= $('#txt_bigo').val(); 		//11 비고
		    dataJson.order_no		= "<%=GV_ORDERNO%>";			//12 주문번호
		    dataJson.lotno			= "<%=GV_LOTNO%>";				//13 Lot번호
		    dataJson.part_nm 		= $('#txt_part_name').val();						//12 원부자재명
			dataJson.warehousing_date 		= $('#txt_ipgo_date').val();				//13 입고날짜
			dataJson.expiration_date 		= $('#txt_expiration_date').val();			//14 유통기한
		    dataJson.member_key		= '<%=member_key%>';

		    dataJson.hist_no		= 'NON';
        	dataJson.balju_no		= '<%=GV_BALJUNO%>';
        	
			jArray.push(dataJson); // 데이터를 배열에 담는다.
		}
			var dataJsonMulti = new Object();
			dataJsonMulti.paramHead = dataJsonHead;
			dataJsonMulti.param = jArray; // Array를 다시 Object형태로 변환 {"param":{Array...}}
			
			var JSONparam = JSON.stringify(dataJsonMulti); // JSON Object전송을 위해 문자열형태로 바꿔줌(stringify)
			var chekrtn = confirm("등록하시겠습니까?"); 
			
			if(chekrtn){
				SendTojsp(JSONparam, SQL_Param.PID); // SendToJSP를 통해 ajax로 데이터(JSONObject,PID) 보냄
			}
		}
    
	function SendTojsp(bomdata, pid){
	    $.ajax({
	         type: "POST",
	         dataType: "json",
	         url: "<%=Config.this_SERVER_path%>/Contents/CommonView/insert_update_delete_json.jsp", 
	         data:  "bomdata=" + bomdata + "&pid=" + pid,
	         beforeSend: function () {
	         
	         },
	         
	         success: function (html) {	
	        	 if(html>-1){
// 	        		parent.fn_MainInfo_List();
// 	                parent.$("#ReportNote").children().remove();
// 	         		parent.$('#modalReport').hide();
	         		//SendToStorage(SQL_Param.params, SQL_Param.UPID);
	        		$('#txt_store_no').val('');
	        		$('#txt_reakes_no').val('');
	        		$('#txt_plate_no').val('');
	        		$('#txt_colm_no').val('');
	        		$('#txt_io_count').val('');
	        		$('#txt_pre_amt').val('');
	        		$('#txt_post_stack').val('');
	        		
	        		$('#txt_part_cd').val('');
	        		$('#txt_part_cd_rev').val('');
	        		$('#txt_part_name').val('');
	        		
	        		$('#txt_bigo').val('');
	        		$('#txt_expiration_date').val('');
	        		$('#txt_hist_no').val('');
	        		
	        		call_S202S040120();
	        		parent.fn_DetailInfo_List();
	         	}
	         },
	         error: function (xhr, option, error) {

	         }
	     });		
	}      		

    </script>

	<div style="width: 100%"> 
<!-- 	BOM정보 -->
		<div id="bom_info" style="width: 600px;float: left; vertical-align: top">
		</div>
<!-- 	원부자재입고 -->
		<div style="width: 650px;float: left; vertical-align: top">					
	        		<input type="hidden" class="form-control" id="txt_ipgo_order" readonly></input>
					<input type="hidden" class="form-control" id="txt_ipgo_no" readonly></input>
					<input type="hidden" class="form-control" id="txt_io_seqno" readonly></input>
					<input type="hidden" class="form-control" id="txt_io_time" readonly></input>
					<input type="hidden" class="form-control" id="txt_io_user_id" readonly></input>
					<input type="hidden" class="form-control" id="txt_order_seq" readonly></input>
					<input type="hidden" class="form-control"  id="txt_bom_cd"  readonly></input>
					<input type="hidden" class="form-control"  id="txt_bom_nm" readonly></input>
					
        	<table class="table table-striped" style="width: 100%; margin: 0 ; align:left ;" id="bom_table">
	        	<tr style="vertical-align: middle">
	        		<td style="width: 20%; font-weight: 900; font-size:14px; text-align:center; vertical-align: middle">일자</td>
	        		<td style="width: 30%;" >
						<input type="text" data-date-format="yyyy-mm-dd" id="txt_ipgo_date" class="form-control" />
	        		</td>
	        		<td colspan="2" style="width: 50%;"></td>
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
	        	<tr style="vertical-align: middle">
	        		<td style="font-weight: 900; font-size:14px; text-align:center; vertical-align: middle">보관창고</td>
	        		<td>
	        			<input type="text" 	 class="form-control" id="txt_store_no"  style="width:100px;float: left;" readonly></input>
<!-- 	        			<button id="btn_store_search"  class="btn btn-info"  onclick="pop_fn_store_search()" style="width: 30%;float: left;">검색</button> -->
						<input type="hidden" 	 class="form-control" id="txt_reakes_no"  style="width:100px"  ></input>
						<input type="hidden" 	 class="form-control" id="txt_plate_no"  style="width:100px"  ></input>
						<input type="hidden" 	 class="form-control" id="txt_colm_no"  style="width:100px"  ></input>
	        		</td>
<!-- 	        		<td style="font-weight: 900; font-size:14px; text-align:center; vertical-align: middle">렉번호</td> -->
<!-- 	        		<td><input type="text" 	 class="form-control" id="txt_reakes_no"  style="width:100px"  ></input></td> -->
<!-- 	        	</tr> -->
<!-- 	        	<tr style="vertical-align: middle"> -->
<!-- 	        		<td style="font-weight: 900; font-size:14px; text-align:center; vertical-align: middle">선반번호</td> -->
<!-- 	        		<td><input type="text" 	 class="form-control" id="txt_plate_no"  style="width:100px"  ></input></td> -->
<!-- 	        		<td style="font-weight: 900; font-size:14px; text-align:center; vertical-align: middle">칸 번호</td> -->
<!-- 	        		<td><input type="text" 	 class="form-control" id="txt_colm_no"  style="width:100px"  ></input></td> -->
<!-- 	        	</tr> -->
<!-- 	        	<tr style="vertical-align: middle"> -->
	        		<td style="font-weight: 900; font-size:14px; text-align:center; vertical-align: middle">출고수량</td>
	        		<td><input type="text" numberPoint class="form-control" id="txt_io_count"  style="width:100px" ></input></td>
	        		<td></td>
	        		<td></td>
	        	</tr>
<%-- 	        	<%if(history_yn.equals("Y")){ %> --%>
<!-- 	        	<tr style="vertical-align: middle"> -->
<!-- 	        		<td style="font-weight: 900; font-size:14px; text-align:center; vertical-align: middle">이력번호</td> -->
<!-- 	        		<td> -->
<!-- 	        			<input type="text" 	 class="form-control" id="txt_hist_no"  style="width:100px;float: left;" readonly="readonly" ></input> -->
<!-- 	        			<button id="btn_store_search"  class="btn btn-info"  onclick="pop_fn_store_search()" style="width: 30%;float: left;">검색</button> -->
<!-- 	        		</td> -->
<!--         		</tr> -->
<%-- 	        	<%}%> --%>
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
<!-- 	창고정보 -->
<!-- 		<div id="store_info" style="width: 250px;float: left; vertical-align: top"> -->
<!-- 		</div> -->
	</div>
	