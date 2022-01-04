<%@page import="java.text.SimpleDateFormat"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*,java.util.*,java.util.Date,javax.servlet.http.*"%>
<%@ page import="mes.client.comm.*" %>
<%@ page import="mes.client.common.*" %>
<%@ page import="mes.client.guiComponents.*" %>
<%@ page import="mes.client.util.*" %>
<%@ page import="mes.client.conf.*" %>
<%@ page import="org.json.simple.*"%><%@ include file="/strings.jsp" %>
<%@page import="java.math.BigDecimal"%>
<!DOCTYPE html>

<%
	//S303S060792.jsp : 주문별BOM등록 Service Delegator START
	String loginID = session.getAttribute("login_id").toString();
	String member_key = session.getAttribute("member_key").toString();

	String  GV_ORDERNO="", GV_ORDER_DETAIL_SEQ="", GV_PROD_CD="", GV_PROD_CD_REV="", GV_PRODUCT_NM="",
			GV_LOT_COUNT = "", GV_DELIVERY_DATE="";
	
	if(request.getParameter("order_no")== null)
		GV_ORDERNO = "";
	else
		GV_ORDERNO = request.getParameter("order_no");
	
	if(request.getParameter("order_detail_seq")== null)
		GV_ORDER_DETAIL_SEQ = "";
	else
		GV_ORDER_DETAIL_SEQ = request.getParameter("order_detail_seq");

	if(request.getParameter("prod_cd")== null)
		GV_PROD_CD ="";
	else
		GV_PROD_CD = request.getParameter("prod_cd");
	
	if(request.getParameter("prod_rev")== null)
		GV_PROD_CD_REV ="";
	else
		GV_PROD_CD_REV = request.getParameter("prod_rev"); 

	if(request.getParameter("product_nm")== null)
		GV_PRODUCT_NM = "";
	else
		GV_PRODUCT_NM = request.getParameter("product_nm");
	
	if(request.getParameter("lot_count")== null)
		GV_LOT_COUNT="";
	else
		GV_LOT_COUNT = request.getParameter("lot_count");

	if(request.getParameter("delivery_date")== null)
		GV_DELIVERY_DATE="";
	else
		GV_DELIVERY_DATE = request.getParameter("delivery_date");
	
	//생산완료수량(배합단위)
	JSONObject jArray = new JSONObject();
	jArray.put( "order_no", GV_ORDERNO);
	jArray.put( "order_detail_seq", GV_ORDER_DETAIL_SEQ);
// 	jArray.put( "prod_cd", GV_PROD_CD);
// 	jArray.put( "prod_cd_rev", GV_PROD_CD_REV);
	jArray.put( "package_no", "");
// 	jArray.put( "delivery_date", GV_DELIVERY_DATE);
	jArray.put( "member_key", member_key);
	
	
	String GV_FINISH_DT = "", GV_PACKAGE_CNT_COMPLETED="";
	DoyosaeTableModel TableModel = new DoyosaeTableModel("M303S060700E115", jArray);
 	int RowCount =TableModel.getRowCount();
	if(RowCount>0) {
		GV_FINISH_DT = TableModel.getValueAt(0,0).toString();
		GV_PACKAGE_CNT_COMPLETED = TableModel.getValueAt(0,1).toString();
	}
%>
    
    <script type="text/javascript">
//     웹소켓 통신을 위해서 필요한 변수들 ---시작
	var SQL_Param = {
			PID:  "M303S060700E162", 
			excute: "queryProcess",
			stream: "N",
			param: ""
	};
	var GV_RECV_DATA = "";	//웹소켓 onMessage(event)들어온 데이터를 받는 변수
//  웹소켓 통신을 위해서 필요한 변수들 ---끝	

	var vTableS303S060795;
	var TableS303S060795_info;
    var TableS303S060795_Row_Count = 0;
    var TableS303S060795_Row_Index = -1;
    
    $(document).ready(function () {
        $("#txt_delivery_date").datepicker({
        	format: 'yyyy-mm-dd',
        	autoclose: true,
        	language: 'ko'
        });
        var today = new Date();
        var fromday = new Date();
        fromday.setDate(today.getDate());
        
        $('#txt_order_no').val('<%=GV_ORDERNO%>');
        $('#txt_order_detail_seq').val('<%=GV_ORDER_DETAIL_SEQ%>');
		$('#txt_prod_cd').val('<%=GV_PROD_CD%>');
		$('#txt_prod_cd_rev').val('<%=GV_PROD_CD_REV%>');
		$('#txt_product_nm').val('<%=GV_PRODUCT_NM%>');
		$('#txt_package_cnt').val('<%=GV_PACKAGE_CNT_COMPLETED%>');
		if('<%=GV_FINISH_DT%>'.length<1) {
			$('#txt_delivery_date').datepicker('update', today);
		} else {
			$('#txt_delivery_date').datepicker('update', '<%=GV_FINISH_DT%>');
		}

		call_S303S060795();
		
		TableS303S060795_Row_Index = -1;
		
	    // 숫자만
	    $("input:text[numberOnly]").on("keyup", function() {
	        $(this).val($(this).val().replace(/[^0-9]/g,""));
	    });
	    
	 	// 숫자 또는 소수점만
	 	$("input:text[numberPoint]").on("keyup", function() {
	 		$(this).val($(this).val().replace(/[^0-9.]/g,""));
// 	 		$(this).val($(this).val().replace(/^[0-9]*.[0-9]*[1-9]+$/g,""));
	 	});
	 	
	 	// 숫자 또는 소수점만
	 	$("input:text[numberPointMinus]").on("keyup", function() {
	 		$(this).val($(this).val().replace(/[^0-9.-]/g,""));
	 	});
	 	
	 	$("#txt_io_amt").on("change", function() {
	 		var v_detail_gyugyeok = $("#txt_detail_gyugyeok").val();
	 		var v_pre_amt = $("#txt_pre_amt").val();
	 		var v_io_amt = $(this).val();
	 		if($("#txt_part_cd").val().length<1) {
	 			alert("부재료를 먼저 선택하세요");
	 			$(this).val("");
	 			return;
	 		}
	 		if(v_detail_gyugyeok.length<1) v_detail_gyugyeok = '1';
	 		if(v_io_amt.length<1) v_io_amt = '0';
	 		var v_post_amt = ( parseFloat(v_pre_amt) - (parseFloat(v_io_amt)/parseFloat(v_detail_gyugyeok)) );
	 		$("#txt_post_amt").val( v_post_amt.toFixed(3) );
	 	});
	 	
	 	if(!(parseFloat($("#txt_package_cnt").val()).toFixed(3)>0.0)){
			alert("포장완료 개수가 없습니다." + "\n" + "포장실적등록을 먼저 해주세요.");
		}
    });
    
    function call_S303S060795() {
    	$.ajax({
            type: "POST",
            url: "<%=Config.this_SERVER_path%>/Contents/Business/M303/S303S060795.jsp", 
            data: "order_no=" + '<%=GV_ORDERNO%>'
            	+ "&order_detail_seq=" + '<%=GV_ORDER_DETAIL_SEQ%>' 
            	+ "&prod_cd=" + '<%=GV_PROD_CD%>' 
            	+ "&prod_cd_rev=" + '<%=GV_PROD_CD_REV%>',
            beforeSend: function () {
                $("#storage_tbody").children().remove();
            },
            success: function (html) {           	 
      			$("#storage_tbody").hide().html(html).fadeIn(100);
            },
            error: function (xhr, option, error) {
            }
        });
    }
    
    function fn_plus_body(obj){ 
    	if( $('#txt_part_cd').val().length<1){
			alert("부자재 검색을 먼저 하세요~~~!!!");
			return;
		}
// 		if( $('#txt_pre_amt').val().length<1){
// 			alert("불출 전 재고를 입력하세요~~~!!!");
// 			return;
// 		}
// 		if( $('#txt_post_amt').val().length<1){
// 			alert("불출 후 재고를 입력하세요~~~!!!");
// 			return;
// 		}
		if( $('#txt_io_amt').val().length<1){
			alert("불출수량을 입력하세요~~~!!!");
			return;
		}
		
		if(TableS303S060795_Row_Index>-1){ //수정
		    vTableS303S060795.cell( TableS303S060795_Row_Index, 2 ).data( $('#txt_expiration_date').val() );
		
		    vTableS303S060795.cell( TableS303S060795_Row_Index, 8  ).data( $('#txt_pre_amt').val() );
		    vTableS303S060795.cell( TableS303S060795_Row_Index, 9  ).data( $('#txt_post_amt').val() );
		    vTableS303S060795.cell( TableS303S060795_Row_Index, 10 ).data( $('#txt_io_amt').val() );
		    
		    vTableS303S060795.cell( TableS303S060795_Row_Index, 16 ).data( $('#txt_bigo').val() );
//			    vTableS303S060795.row(TableS303S060795_Row_Index).draw();
		    clear_input();
		    TableS303S060795_Row_Index=-1;
		} else { //추가
			// part_cd 비교해서 이미 등록된 원부자재는 패스
   			var v_part_cd = $('#txt_part_cd').val();
   			var jungbok_chk = false;
   			for(i=0; i<TableS303S060795_Row_Count; i++) {
   				if(v_part_cd==vTableS303S060795.cell(i,3).data()) {
   					jungbok_chk = true;
       			}
   			}
   			if(!jungbok_chk){
   				var today = new Date(); // 오늘날짜
   				var check_time 	= ("0" + today.getHours()).slice(-2) 
								+ ":" + ("0" + today.getMinutes()).slice(-2) 
								+ ":" + ("0" + today.getSeconds()).slice(-2) ;
   				
   				vTableS303S060795.row.add([
//    					$('#txt_warehousing_datetime').val(),
					$('#txt_delivery_date').val() + " " + check_time,
   					$('#txt_io_gubun').val(),
   					$('#txt_expiration_date').val(),
   					$('#txt_part_cd').val(),
   					$('#txt_part_cd_rev').val(),
   					$('#txt_part_nm').val(),
   					$('#txt_gyugyeok').val(),
   					$('#txt_detail_gyugyeok').val(),
   					$('#txt_pre_amt').val(),
   					$('#txt_post_amt').val(),
   					$('#txt_io_amt').val(),
   			 		$('#txt_order_no').val(),
   			 		$('#txt_order_detail_seq').val(),
   			 		$('#txt_prod_cd').val(),
   			 		$('#txt_prod_cd_rev').val(),
   			 		$('#txt_product_nm').val(),
   					$('#txt_bigo').val(),
   					'Y', // insert_yn(최초등록여부:Y면등록,N이면수정)
   					'<button style="width: auto; float: left; " type="button" onclick="fn_mius_body(this)" id="right_btn" class="btn-outline-success">삭제</button>'
   		        ]).draw(true);
   				
   				clear_input();
   			    
   		        TableS303S060795_info = vTableS303S060795.page.info();
   		        TableS303S060795_Row_Count = TableS303S060795_info.recordsTotal;
   		        
   		        TableS303S060795_Row_Index=-1;
   			} else {
   				alert("이미 등록된 원재료 입니다.");
   			}
		}
    }
    
    function fn_mius_body(obj){  
		vTableS303S060795.row($(obj).parents('tr')).remove().draw();
		
	    TableS303S060795_info = vTableS303S060795.page.info();
	    TableS303S060795_Row_Count = TableS303S060795_info.recordsTotal;
	    
	    TableS303S060795_Row_Index=-1;
	    clear_input();
    } 
    
	function clear_input(){
// 		$('#txt_warehousing_datetime').val("");
// 		$('#txt_io_gubun').val("");
		$('#txt_expiration_date').val("");
		$('#txt_part_cd').val("");
		$('#txt_part_cd_rev').val("");
		$('#txt_part_nm').val("");
		$('#txt_gyugyeok').val("");
		$('#txt_detail_gyugyeok').val("");
		$('#txt_pre_amt').val("");
		$('#txt_post_amt').val("");
		$('#txt_io_amt').val("");   
		$('#txt_bigo').val("");
		
		$("#btn_plus").text("추가");
		$('#btn_SearchPart').attr("disabled", false);
	}        
		
	function SaveOderInfo() {      
		var WebSockData="";		
		if(!(parseFloat($("#txt_package_cnt").val()).toFixed(3)>0.0)){
			alert("포장완료 개수가 없습니다." + "\n" + "포장실적등록을 해주세요.");
			return;
		}
		
		var chekrtn = confirm("등록하시겠습니까?"); 
		if(!chekrtn){
			return;
		}
		
	    TableS303S060795_info = vTableS303S060795.page.info();
	    TableS303S060795_Row_Count = TableS303S060795_info.recordsTotal;
	    
        var dataJsonHead = new Object(); // JSON Object 선언
        dataJsonHead.member_key = "<%=member_key%>";
        
        if(TableS303S060795_Row_Count==0) {
        	alert("부재료를 하나이상 등록하세요");
			return false;
        }

		try {
			var v_update_yn = false; // 수정쿼리 실행할지 말지 flag
			var jArray = new Array(); // JSON Array 선언
		    for(var i=0; i<TableS303S060795_Row_Count; i++){
		    	var today = new Date(); // 오늘날짜
		    	var check_time 	= ("0" + today.getHours()).slice(-2) 
								+ ":" + ("0" + today.getMinutes()).slice(-2) 
								+ ":" + ("0" + today.getSeconds()).slice(-2) ;
		    	var v_insert_yn = vTableS303S060795.cell( i, 17  ).data();
		    	if(v_insert_yn == 'Y') { // 최초등록여부
		    		var v_part_cd		= vTableS303S060795.cell( i, 3  ).data();
			    	var v_part_cd_rev	= vTableS303S060795.cell( i, 4  ).data();
			    	var v_part_nm		= vTableS303S060795.cell( i, 5  ).data();
			    	var v_io_amt 		= vTableS303S060795.cell( i, 10 ).data();
			    	var v_order_no		= $('#txt_order_no').val();
			    	var v_order_detail_seq = $('#txt_order_detail_seq').val();
			    	var v_prod_cd		= $('#txt_prod_cd').val();
			    	var v_prod_cd_rev	= $('#txt_prod_cd_rev').val();
			    	var v_prod_nm		= $('#txt_product_nm').val();
			    	var v_warehousing_datetime = $('#txt_delivery_date').val() + " " + check_time; // 출고 일시 = 생산완료일자 + 현재시간
			    	var v_delivery_date = $('#txt_delivery_date').val(); // 제품납기일자
			    	fn_production_SubPart_chulgo(v_order_no,v_order_detail_seq,
			    			v_prod_cd,v_prod_cd_rev,v_prod_nm,
			    			v_part_cd,v_part_cd_rev,v_io_amt, 
			    			v_warehousing_datetime,v_delivery_date)	;
		    	} else if(v_insert_yn == 'N') {
		    		v_update_yn = true; // 수정할 데이터가 하나라도 있으면 true
		    		var dataJson = new Object(); 
		    		dataJson.warehousing_datetime = $('#txt_delivery_date').val() + " " + check_time; // 바뀔 출고 일시
			    	dataJson.pre_warehousing_datetime = vTableS303S060795.cell( i, 0 ).data(); // 기존에 저장된 출고일시
			    	dataJson.io_gubun		= vTableS303S060795.cell( i, 1  ).data();
			    	dataJson.expiration_date= vTableS303S060795.cell( i, 2  ).data();
			    	dataJson.part_cd		= vTableS303S060795.cell( i, 3  ).data();
			    	dataJson.part_cd_rev	= vTableS303S060795.cell( i, 4  ).data();
			    	dataJson.part_nm		= vTableS303S060795.cell( i, 5  ).data();
			    	dataJson.pre_amt		= vTableS303S060795.cell( i, 8  ).data();
			    	dataJson.post_amt		= vTableS303S060795.cell( i, 9  ).data();
			    	var v_io_amt_gram		= vTableS303S060795.cell( i, 10 ).data();
			    	var v_detail_gyugyeok 	= vTableS303S060795.cell( i, 7 ).data();
			    	dataJson.io_amt 		= parseFloat(v_io_amt_gram)/parseFloat(v_detail_gyugyeok) ;
			    	dataJson.part_cnt		= v_io_amt_gram;
			    	dataJson.order_no		= vTableS303S060795.cell( i, 11 ).data();
			    	dataJson.order_detail_seq = vTableS303S060795.cell( i, 12 ).data();
			    	dataJson.prod_cd		= vTableS303S060795.cell( i, 13 ).data();
			    	dataJson.prod_cd_rev	= vTableS303S060795.cell( i, 14).data();
			    	dataJson.prod_nm		= vTableS303S060795.cell( i, 15 ).data();
			    	dataJson.bigo			= vTableS303S060795.cell( i, 16 ).data();
			    	dataJson.member_key		= "<%=member_key%>";
					jArray.push(dataJson); // 데이터를 배열에 담는다.
		    	}
	        }
	    	if(v_update_yn) {
//				console.log(JSONparam);
				var dataJsonMulti = new Object();
				dataJsonMulti.param = jArray; // Array를 다시 Object형태로 변환 {"param":{Array...}}
				var JSONparam = JSON.stringify(dataJsonMulti); // JSON Object전송을 위해 문자열형태로 바꿔줌(stringify)
// 				SendTojsp(JSONparam, "M303S060700E162"); // SendToJSP를 통해 ajax로 데이터(JSONObject,PID) 보냄
	    	}
		    
		    parent.$("#ReportNote").children().remove();
      		parent.$('#modalReport').hide();
		} 
		catch(err) {
			console.log(err);
	    }
	}
	
	function SendTojsp(bomdata,pid){
	    $.ajax({
	         type: "POST",
	         dataType: "json",
	         url: "<%=Config.this_SERVER_path%>/Contents/CommonView/insert_update_delete_json.jsp", 
	         data:  {"bomdata" : bomdata, "pid" : pid },
	         beforeSend: function () {
	//         	 alert(bomdata);
	         },
	         success: function (html) {
	//         	 console.log("success=" + bomdata);
// 	        	 parent.DetailInfo_List.click();
// 	        	 parent.SubInfo_BomList.click();
	     		parent.$("#ReportNote").children().remove();
	      		parent.$('#modalReport').hide();
	      		
	      		
	         },
	         error: function (xhr, option, error) {
	
	         }
	     });		
	}    
	
	
	//제품별 부재료불출
	function fn_production_SubPart_chulgo(v_order_no,v_order_detail_seq,v_prod_cd,v_prod_cd_rev,v_prod_nm,
			v_part_cd,v_part_cd_rev,v_io_amt,v_warehousing_datetime,v_delivery_date) {
		$.ajax({
			type: "POST",
			url: "<%=Config.this_SERVER_path%>/Contents/Business/M303/S303S060792.jsp", 
        	data: "order_no=" + v_order_no + "&order_detail_seq=" + v_order_detail_seq
        	 	+ "&prod_cd=" + v_prod_cd + "&prod_cd_rev=" + v_prod_cd_rev + "&prod_nm=" + v_prod_nm
        		+ "&part_cd=" + v_part_cd + "&part_cd_rev=" + v_part_cd_rev + "&io_amt=" + v_io_amt
        		+ "&warehousing_datetime=" + v_warehousing_datetime	+ "&delivery_date=" + v_delivery_date,
	        beforeSend: function () {
	        	 //alert(bomdata);
	        },
	        success: function (html) {	
	        },
	        error: function (xhr, option, error) {
	        }
	    });
	}

    function SetpartName_code(txt_part_name, txt_part_cd,txt_part_revision_no,txt_gyugyeok,txt_detail_gyugyeok,txt_jaego){
		$('#txt_part_nm').val(txt_part_name);
		$('#txt_part_cd').val(txt_part_cd);
		$('#txt_part_cd_rev').val(txt_part_revision_no);	
		$('#txt_gyugyeok').val(txt_gyugyeok);	
		$('#txt_detail_gyugyeok').val(txt_detail_gyugyeok);	
		$('#txt_pre_amt').val(txt_jaego);
    }

    function fn_production_storage_delete(obj) {
		var tr = $(obj).parent().parent();
		var td = tr.children();
		var chekrtn = confirm("이미 등록된 데이터입니다"+"\n"+"삭제 하시겠습니까?"); 

		if(chekrtn){
			TableS303S060795_info = vTableS303S060795.page.info();
		    TableS303S060795_Row_Count = TableS303S060795_info.recordsTotal;
		    if(TableS303S060795_Row_Count > 0) {
		    	var dataJson = new Object();
		    	dataJson.order_no		= $('#txt_order_no').val();
		    	dataJson.order_detail_seq = $('#txt_order_detail_seq').val();
		    	dataJson.prod_cd		= $('#txt_prod_cd').val();
		        dataJson.prod_cd_rev	= $('#txt_prod_cd_rev').val();
		        dataJson.warehousing_datetime = td.eq(0).text();
		        dataJson.io_gubun 		= td.eq(1).text();
		        dataJson.expiration_date = td.eq(2).text();
		        dataJson.part_cd		= td.eq(3).text();
		        dataJson.part_cd_rev	= td.eq(4).text();
		        dataJson.member_key 	= "<%=member_key%>";
		    	
		        var jArray = new Array(); // JSON Array 선언
		        jArray.push(dataJson); // 데이터를 배열에 담는다
		        var dataJsonMulti = new Object();
				dataJsonMulti.param = jArray; // Array를 다시 Object형태로 변환 {"param":{Array...}}
				var JSONparam = JSON.stringify(dataJsonMulti); // JSON Object전송을 위해 문자열형태로 바꿔줌(stringify)
		        
// 				console.log(JSONparam);
		        SendTojspDelete(JSONparam, "M303S060700E163");
			}	
		}
    }
    
    function SendTojspDelete(bomdata,pid){
	    $.ajax({
	         type: "POST",
	         dataType: "json",
	         url: "<%=Config.this_SERVER_path%>/Contents/CommonView/insert_update_delete_json.jsp", 
	         data:  {"bomdata" : bomdata, "pid" : pid },
	         beforeSend: function () {
	//         	 alert(bomdata);
	         },
	         success: function (html) {
	      		call_S303S060795();
	      		
	      		TableS303S060795_info = vTableS303S060795.page.info();
	    	    TableS303S060795_Row_Count = TableS303S060795_info.recordsTotal;
	    	    
	    	    TableS303S060795_Row_Index=-1;
	    	    clear_input();
	         },
	         error: function (xhr, option, error) {
	
	         }
	     });		
	}   
    
    function select_Product_SubPart_List(){
    	var modalContentUrl = "<%=Config.this_SERVER_path%>/Contents/Business/M303/S303S060796.jsp"
    						+ "?prod_cd=" + "<%=GV_PROD_CD%>"
    						+ "&prod_cd_rev=" + "<%=GV_PROD_CD_REV%>" ;
    	
    	pop_fn_popUpScr_nd(modalContentUrl, "제품별 부자재 목록조회(S303S060796)", '600px', '80%');
		return false;
	}
    
    </script>


	<div class="container-fluid">
        <table class="table table-striped table-bordered" style="width: 100%; margin: 0 ; align:left">	       
 			<tr>  				
	            <td style="width: 10%;  font-weight: 900; font-size:14px; text-align:right;vertical-align: middle">제품명</td> <!-- 제품코드 -->
	            <td style="width: 23.33%;  font-weight: 900; font-size:14px; text-align:lef;">
					<input type="hidden" class="form-control" id="txt_order_no" readonly/>
					<input type="hidden" class="form-control" id="txt_order_detail_seq" readonly/>
					<input type="hidden" class="form-control" id="txt_prod_cd" readonly/>
					<input type="hidden" class="form-control" id="txt_prod_cd_rev" readonly/>
					<input type="text" 	 class="form-control" id="txt_product_nm" readonly style="width:60%; float:left;"/>
					<button type="button" onclick="select_Product_SubPart_List();" id="btn_SearchBOM" class="form-control btn btn-info" style="width:40%;float:left;">부자재 검색</button>
	           	</td>
	            <td style="width: 10%;  font-weight: 900; font-size:14px; text-align:right;vertical-align: middle">포장완료개수</td>
	            <td style="width: 23.33%; font-weight: 900; font-size:14px; text-align:left">
					<input type="text" class="form-control" id="txt_package_cnt" readonly/>
	           	</td>
	           	<td style="width: 10%;  font-weight: 900; font-size:14px; text-align:right;vertical-align: middle">포장완료일자</td>
	            <td style="width: 23.33%; font-weight: 900; font-size:14px; text-align:left">
					<input type="text" class="form-control" id="txt_delivery_date" readonly/>
	           	</td>
	        </tr>
       	</table>
		<div class="modal-content panel panel-default" style="overflow:auto;">
	        <table class="table table-striped" style="width: 100%; margin: 0 ; align:left ;" id="storage_table">
		        <tr style="vertical-align: middle">
<!-- 		            <td style="width:10%; font-weight: 900; font-size:14px; text-align:center; vertical-align: middle ">유통기한</td> -->
		            <td style="width:25%; font-weight: 900; font-size:14px; text-align:center; vertical-align: middle">부재료명</td>
<!-- 		            <td style="width:20%; font-weight: 900; font-size:14px; text-align:center; vertical-align: middle">규격</td> -->
<!-- 		            <td style="width:10%; font-weight: 900; font-size:14px; text-align:center; vertical-align: middle">규격(g단위)</td> -->
<!-- 		            <td style="width:10%; font-weight: 900; font-size:14px; text-align:center; vertical-align: middle">불출 전 재고</td> -->
<!-- 		            <td style="width:10%; font-weight: 900; font-size:14px; text-align:center; vertical-align: middle">불출 후 재고</td> -->
		            <td style="width:15%; font-weight: 900; font-size:14px; text-align:center; vertical-align: middle">불출수량</td>
		            <td style="width:30%; font-weight: 900; font-size:14px; text-align:center; vertical-align: middle">비고</td>
		            <td style="width:10%; vertical-align: middle"></td>
		        </tr>
		        <tr style="vertical-align: middle">			            
<!-- 		        	<td style="text-align:center; vertical-align:middle; margin:0;"> -->
<!-- 		        		<input type="hidden" class="form-control" id="txt_warehousing_datetime" readonly value="TO_CHAR(SYSDATETIME,'YYYY-MM-DD HH24:MI:SS')" ></input> -->
<!-- 		        		<input type="hidden" class="form-control" id="txt_io_gubun" readonly value="O"></input> -->
<!-- 						<input type="hidden"   class="form-control" id="txt_expiration_date" readonly ></input> -->
<!-- 					</td> -->
		            <td style="text-align:center; vertical-align:middle; margin:0;">
		            	<input type="hidden" class="form-control" id="txt_warehousing_datetime" readonly value="TO_CHAR(SYSDATETIME,'YYYY-MM-DD HH24:MI:SS')" ></input>
		        		<input type="hidden" class="form-control" id="txt_io_gubun" readonly value="O"></input>
						<input type="hidden" class="form-control" id="txt_expiration_date" readonly ></input>
						<input type="hidden" class="form-control" id="txt_part_cd" readonly ></input>
						<input type="hidden" class="form-control" id="txt_part_cd_rev" readonly></input>
						<input type="text"   class="form-control" id="txt_part_nm" readonly style="width:62%;float:left;"></input>
						<button type="button" onclick="parent.pop_fn_PartList_View(4,'IMPORT2')" id="btn_SearchPart" 
							class="btn btn-info"  style="width:38%;float:left;">검색</button>
							
						<input type="hidden" class="form-control" id="txt_gyugyeok" readonly></input>
						<input type="hidden" class="form-control" id="txt_detail_gyugyeok" readonly></input>
		           	</td>
<!-- 		            <td style="text-align:center; vertical-align:middle; margin:0;"> -->
<!-- 		            	<input type="text" class="form-control" id="txt_gyugyeok" readonly></input> -->
<!-- 		           	</td> -->
<!-- 		            <td style="text-align:center; vertical-align:middle; margin:0;"> -->
<!-- 		            	<input type="text" class="form-control" id="txt_detail_gyugyeok" readonly></input> -->
<!-- 		            </td> -->
<!-- 		            <td style="text-align:center; vertical-align:middle; margin:0;"> -->
<!-- 		            	<input type="text" class="form-control" id="txt_pre_amt" numberPointMinus readonly></input> -->
<!-- 		           	</td> -->
<!-- 		            <td style="text-align:center; vertical-align: middle ;margin: 0 ;"> -->
<!-- 		            	<input type="text" class="form-control" id="txt_post_amt" numberPointMinus readonly></input> -->
<!-- 		            </td> -->
		            <td style="text-align:center; vertical-align: middle ;margin: 0 ;">
		            	<input type="hidden" class="form-control" id="txt_pre_amt" value='0' readonly></input>
		            	<input type="hidden" class="form-control" id="txt_post_amt" value='0' readonly></input>
		            	<input type="text" class="form-control" id="txt_io_amt" numberPoint ></input>
		            </td>
		            <td style="text-align:center; vertical-align: middle ;margin: 0 ;">
<!-- 		            	<input type="hidden" class="form-control" id="txt_proc_plan_no" readonly ></input> -->
<!-- 		            	<input type="hidden" class="form-control" id="txt_prod_cd" readonly ></input> -->
<!-- 		            	<input type="hidden" class="form-control" id="txt_prod_cd_rev" readonly ></input> -->
<!-- 		            	<input type="hidden" class="form-control" id="txt_prod_nm" readonly ></input> -->
		            	<input type="text"   class="form-control" id="txt_bigo" ></input>
		            </td>
		            <td style="text-align:center; vertical-align: middle ;margin: 0 ;">
		            	<button id="btn_plus" class="form-control btn btn-info" onclick="fn_plus_body(this);">추가</button>
		            </td>
		        </tr>
		    </table>
		</div>        
		<div id="storage_tbody"></div>
        <p style="text-align:center; vertical-align: middle ;margin: 0 ;">
			<button id="btn_Save"  class="btn btn-info" style="width: 100px" onclick="SaveOderInfo();">저장</button>
			<button id="btn_Canc"  class="btn btn-info" style="width: 100px" onclick="parent.$('#modalReport').hide();">취소</button>
        </p>
	</div>
