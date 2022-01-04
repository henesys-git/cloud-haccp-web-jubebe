﻿﻿<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*,java.util.*,javax.servlet.http.*"%>
<%@ page import="mes.client.comm.*" %>
<%@ page import="mes.client.common.*" %>
<%@ page import="mes.client.guiComponents.*" %>
<%@ page import="mes.client.util.*" %>
<%@ page import="mes.client.conf.*" %>
<%@ page import="org.json.simple.*"%><%@ include file="/strings.jsp" %>
<%
/* 
S202S010202.jsp
발주서 수정
*/
	String loginID = session.getAttribute("login_id").toString();
	String member_key = session.getAttribute("member_key").toString();
	String zhtml = "";
	
 
	String GV_ORDERNO="", GV_ORDER_DETAIL_SEQ="",
		   GV_JSPPAGE="", GV_NUM_GUBUN="", 
		   GV_BALJUNO="", GV_LOTNO="",
		   GV_CUSTNM="", GV_TELNO = "",
		   GV_BALJU_SEND_DATE = "", GV_BALJU_NABGI_DATE = "",
		   GV_NOTE = "", GV_CUST_CD = "", GV_CUST_REV_NO = "",
		   GV_PART_CD = "", GV_PART_REV_NO = "", GV_BALJU_AMT = "",
		   GV_TRACE_KEY = "", GV_BALJU_STATUS = "", GV_BALJU_REV_NO = "";
	
	if(request.getParameter("OrderNo") == null)
		GV_ORDERNO = "";
	else
		GV_ORDERNO = request.getParameter("OrderNo");	
	
	if(request.getParameter("order_detail_seq") == null)
		GV_ORDER_DETAIL_SEQ="";
	else
		GV_ORDER_DETAIL_SEQ = request.getParameter("order_detail_seq");
	
	if(request.getParameter("LotNo") == null)
		GV_LOTNO="";
	else
		GV_LOTNO = request.getParameter("LotNo");
	

	if(request.getParameter("jspPage") == null)
		GV_JSPPAGE="0";
	else
		GV_JSPPAGE = request.getParameter("jspPage");	

	
	if(request.getParameter("num_gubun") == null)
		GV_NUM_GUBUN="";
	else
		GV_NUM_GUBUN = request.getParameter("num_gubun");
	
	if(request.getParameter("BaljuNo") == null)
		GV_BALJUNO = "";
	else
		GV_BALJUNO = request.getParameter("BaljuNo");
	
	if(request.getParameter("CustNm") == null)
		GV_CUSTNM = "";
	else
		GV_CUSTNM = request.getParameter("CustNm");	
	
	if(request.getParameter("Telno") == null)
		GV_TELNO = "";
	else
		GV_TELNO = request.getParameter("Telno");	
	
	if(request.getParameter("Balju_send_date") == null)
		GV_BALJU_SEND_DATE = "";
	else
		GV_BALJU_SEND_DATE = request.getParameter("Balju_send_date");
	
	if(request.getParameter("Balju_nabgi_date") == null)
		GV_BALJU_NABGI_DATE = "";
	else
		GV_BALJU_NABGI_DATE = request.getParameter("Balju_nabgi_date");
	
	if(request.getParameter("Note") == null)
		GV_NOTE = "";
	else
		GV_NOTE = request.getParameter("NOTE");
	
	if(request.getParameter("CustCd") == null)
		GV_CUST_CD = "";
	else
		GV_CUST_CD = request.getParameter("CustCd");
	
	if(request.getParameter("CustRevNo") == null)
		GV_CUST_REV_NO = "";
	else
		GV_CUST_REV_NO = request.getParameter("CustRevNo");
	
	if(request.getParameter("PartCd") == null)
		GV_PART_CD = "";
	else
		GV_PART_CD = request.getParameter("PartCd");
	
	if(request.getParameter("PartRevNo") == null)
		GV_PART_REV_NO = "";
	else
		GV_PART_REV_NO = request.getParameter("PartRevNo");
	
	if(request.getParameter("BaljuAmt") == null)
		GV_BALJU_AMT = "";
	else
		GV_BALJU_AMT = request.getParameter("BaljuAmt");
	
	if(request.getParameter("TraceKey") == null)
		GV_TRACE_KEY = "";
	else
		GV_TRACE_KEY = request.getParameter("TraceKey");
	
	if(request.getParameter("Balju_status") == null)
		GV_BALJU_STATUS = "";
	else
		GV_BALJU_STATUS = request.getParameter("Balju_status");
	
	if(request.getParameter("BaljuRevNo") == null)
		GV_BALJU_REV_NO = "";
	else
		GV_BALJU_REV_NO = request.getParameter("BaljuRevNo");	
  	 
%>
    
<script type="text/javascript">
	// 웹소켓 통신을 위해서 필요한 변수들 ---시작
	var M202S010100E202= {
			PID:  "M202S010100E202", 
			totalcnt: 0,
			retnValue: 999,
			colcnt: 0,
			colname: ["","","",""], //insert, Update, Delete 문장을 처리할 때는 사용되지않음
			data: []
	};  
	
	var SQL_Param = {
			PID: "M202S010100E202",
			excute: "queryProcess",
			stream: "N",
			param: ""
	};
	var GV_RECV_DATA = "";	//웹소켓 onMessage(event)들어온 데이터를 받는 변수
	// 웹소켓 통신을 위해서 필요한 변수들 ---끝	

    var JOB_GUBUN = "";

	var vTableS202S010255;
	var TableS202S010255_info;
    var TableS202S010255_RowCount;
    var S202S010255_Row_index = -1;
    var checkval = true;
    $(document).ready(function () {
    	new SetSingleDate2("", "#dateOrder", 0);
    	new SetSingleDate2("", "#dateDelivery", 0);
	    
	    $("#btn_plus").click(function(){ 
	    	fn_plus_body(this); 
	    }); 
	    	    
	    $("#right_btn").click(function(){ 
	    	fn_mius_body(this); 
	    });  

		$('#txt_order_no').val('<%=GV_ORDERNO%>');
		$('#txt_balju_no').val('<%=GV_BALJUNO%>');
		$('#txt_order_detail_seq').val('<%=GV_ORDER_DETAIL_SEQ%>');
		$('#txt_S_CustName').val('<%=GV_CUSTNM%>');
		$('#txt_S_custcode').val('<%=GV_CUST_CD%>');
		$('#txt_S_cust_rev').val('<%=GV_CUST_REV_NO%>');
		$('#txt_telNo').val('<%=GV_TELNO%>');
		$('#dateOrder').val('<%=GV_BALJU_SEND_DATE%>');
		$('#dateDelivery').val('<%=GV_BALJU_NABGI_DATE%>');
		
		$.ajax({
	        type: "POST",
            url: "<%=Config.this_SERVER_path%>/Contents/Business/M202/S202S010255.jsp", 
            data: "order_no=" + '<%=GV_ORDERNO%>'+ "&balju_no=" + '<%=GV_BALJUNO%>' + "&caller=" + 'S202S010202', 
	        beforeSend: function () {
	            $("#bom_tbody").children().remove();
	        },
	        success: function (html) {
	            $("#bom_tbody").hide().html(html).fadeIn(100);
	        }
 		});
        
        S202S010255_Row_index = -1;
        <%-- <%=html%> --%>
        
        // 출고 수량이 바뀌었을 때 적용
	    $("#txt_part_cnt").on("change",function() {
	    	BaljuAmountChange(); 
	    });
	    // 단가가 바뀌었을 때 적용
	    $("#txt_unit_price").on("change",function() {
	    	BaljuAmountChange(); 
	    });
        
	    // 숫자만
	    $("input:text[numberOnly]").on("keyup", function() {
	        $(this).val($(this).val().replace(/[^0-9]/g,""));
	    });
	    
	 	// 숫자 또는 소수점만
	 	$("input:text[numberPoint]").on("keyup", function() {
	 		$(this).val($(this).val().replace(/[^0-9.]/g,""));
	 	});
	    
	    $("#dateOrder").on("change",function(){
	    	DateChange(); 
	    });
	    
	    $("#dateDelivery").on("change",function(){
	    	DateChange(); 
	    });
	    
	    setTimeout(function(){
	    
	    //기존 등록되어 있던 원부자재 목록 조회
	    $("#btn_partInfo").click(function(){
	    parent.pop_fn_Ordered_Part_View("<%=GV_BALJUNO%>", "<%=GV_TRACE_KEY%>");
	    
	    });
	    
	    },400);
	    
	    //품명 클릭시 원부재료 목록 조회
	    $("#txt_bom_nm").click(function(){
	    var cust_cd = $('#txt_S_custcode').val();
		//parent.pop_fn_PartList_View(1);
	     parent.pop_fn_PartList_View2(2, cust_cd );
		});
    });
    
 // 원부재료/자재 검색 후 클릭한 데이터를 가져옴
	function SetPartInfo(part_name, gyugeok, part_cnt, unit_price, part_cd, part_rev_no, balju_rev_no){

	 	$('#txt_bom_nm').val(part_name);
		$('#txt_gyugeok').val(gyugeok);
		$('#txt_part_cnt').val(part_cnt);
		$('#txt_unit_price').val(unit_price);
		$('#txt_part_cd').val(part_cd);
		$('#txt_part_cd_rev').val(part_rev_no);
		$('#txt_part_amt').val(part_cnt*unit_price);
		$('#txt_rev').val(balju_rev_no);
		
			for(var i = 0; i < TableS202S010255_RowCount; i++) {
   	   		
   			var td1 = vTableS202S010255.cell(i, 3).data();
   			
   			console.log(part_name);
   			console.log(td1);
   			if(td1 == part_name){
   	   			alert('각각 다른 원부자재를 등록해 주세요.');
   	   		
   	   		$('#txt_bom_cd').val('');
   			$('#txt_bom_nm').val('');
   			$('#txt_part_cd').val('');
   			$('#txt_part_cd_rev').val('');		
   			$('#txt_gyugeok').val('');
   			$('#txt_part_cnt').val('');
   			$('#txt_unit_price').val('');
   			$('#txt_part_amt').val('');
   			$('#txt_rev').val('');
   	   	
	    	checkval = false;
	    
			checkValue(checkval);
		
   			}
   		
   		}  
		
	}
    
	function checkValue(checkval){
    	
    	this.checkval = checkval;
    	
    	return checkval;
    }
 
    function BaljuAmountChange() {
    	if($('#txt_part_cnt').val()=="" || 
    	   $('#txt_part_cnt').val()==null || 
    	   $('#txt_part_cnt').val()==undefined || 
    	   $('#txt_unit_price').val()=="" || 
    	   $('#txt_unit_price').val()==null || 
    	   $('#txt_unit_price').val()==undefined) {
    		return false;
    	} else {
    		
	    	var part_cnt = parseInt($("#txt_part_cnt").val());
	    	var unit_price = parseInt($("#txt_unit_price").val().replace(/,/g,''));
	    	var part_amt = parseInt($("#txt_part_amt").val().replace(/,/g,'')); 
	    	
    		
	    	part_amt=part_cnt * unit_price;
// 	    	$("#txt_part_amt").val(part_amt);
	    	
    		// 화면상
//     		var new_chulha_amount = Number($('#txt_chulha_cnt').val().replace(/,/gi,'')) * Number($('#txt_chulha_unit_price').val().replace(/,/gi,''));
        	$('#txt_part_amt').val(part_amt.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ","));
        	$('#txt_unit_price').val(unit_price.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ","));
    	}
        	
    }
    
    function DateChange(){
        if ($('#dateOrder').val() > $('#dateDelivery').val()){
        	alert("발주일자가 납기일자보다 길 수 없습니다.");
        	return false;
        }
    }

	function select_Oder_Bom_List(orderNo){
    	//caller = 1 : modalFramePopup에서 호출
    	//caller = 0 : 일반화면에서 호출
    	var modalContentUrl  = "<%=Config.this_SERVER_path%>/Contents/Business/M202/S202S010270.jsp?order_no="+orderNo
    		+ "&lotno=" +vLotNo;
    	pop_fn_popUpScr_nd(modalContentUrl, "발주용 BOM 조회(S202S010270)", '600px', '80%');
		return false;
	}
	
	function SetRecvData(){
		DataPars(M202S010100E202,GV_RECV_DATA);  		
   		parent.fn_DetailInfo_List();
        parent.$("#ReportNote").children().remove();
 		parent.$('#modalReport').hide();
	}
	
	function SaveOderInfo() { 

        TableS202S010255_info = vTableS202S010255.page.info();
        TableS202S010255_RowCount = TableS202S010255_info.recordsTotal;	
		
		if ($('#dateOrder').val() > $('#dateDelivery').val()){
        	alert("발주일자가 납기일자보다 길 수 없습니다.");
        	return false;
        }
	 	
	 	if($("#txt_S_CustName").val()=='') { 
			alert("수신처를 검색하여 선택하세요");
			return false;
		}
	 	
		if(TableS202S010255_RowCount == 0 ) { 
			alert("원부자재를 등록하여 주세요");
			return false;
		}
		
		var work_complete_update_check = confirm("수정하시겠습니까?");
		if(work_complete_update_check == false)	return;
	 	
		var WebSockData="";		

        var dataJsonHead = new Object();
        //dataJsonHead		
		dataJsonHead.jsp_page			= '<%=GV_JSPPAGE%>' ;
		dataJsonHead.user_id 			= '<%=loginID%>';
		dataJsonHead.trace_key			= '<%=GV_TRACE_KEY%>';
		dataJsonHead.order_no 			= $('#txt_order_no').val();
		dataJsonHead.balju_no			= '<%=GV_BALJUNO%>';
		dataJsonHead.balju_rev_no 		= '<%=GV_BALJU_REV_NO%>';
		dataJsonHead.balju_text			= '';
		dataJsonHead.balju_send_date 	= $('#dateOrder').val();
		dataJsonHead.balju_nabgi_date 	= $('#dateDelivery').val();
		dataJsonHead.tell_no 			= $('#txt_telNo').val();
		dataJsonHead.cust_cd 			= $('#txt_S_custcode').val();
		dataJsonHead.cust_cd_rev 		= $('#txt_S_cust_rev').val();
		dataJsonHead.lotno				= '<%=GV_LOTNO%>';
		dataJsonHead.member_key 		= "<%=member_key%>";
		
		var jArray = new Array();		
		
	    for(var i = 0; i < TableS202S010255_RowCount; i++){  
	        var list_price = vTableS202S010255.cell(i , 8).data().replace(/,/gi,'');
	        var balju_amt = vTableS202S010255.cell(i ,9).data().replace(/,/gi,'');
			
	        var dataJson = new Object(); // BOM Data용
	        
	        //dataJson.balju_no 		= vTableS202S010255.cell(i , 1).data(); //0 balju_seq   발주번호
			dataJson.balju_seq 		= vTableS202S010255.cell(i , 2).data(); //0 balju_seq   순번
			dataJson.bom_nm 	= vTableS202S010255.cell(i , 3).data();	//1 bom_nm  자료이름					
			dataJson.bom_cd 	= vTableS202S010255.cell(i , 4).data();	//2 bom_cd 자료번호
			dataJson.part_cd 		= vTableS202S010255.cell(i , 5).data();	//4 part_cd 	파트코드
			dataJson.gyugeok 		= vTableS202S010255.cell(i , 6).data();	//5 gyugeok 	규격
			dataJson.balju_count 	= vTableS202S010255.cell(i , 7).data();	//6 balju_count 수량
			dataJson.list_price 	= list_price;							//7 list_price 	단가
			dataJson.balju_amt 		= balju_amt;							//8 balju_amt 	금액
			dataJson.rev_no 		= vTableS202S010255.cell(i ,10).data();	//9 rev_no		구분
			dataJson.part_cd_rev 	= vTableS202S010255.cell(i ,11).data();	//0 part_cd_rev 구분
			dataJson.member_key = "<%=member_key%>";
			
			jArray.push(dataJson);
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
			data: {"bomdata" : bomdata, "pid" : pid },
			success: function (html) {	
				if(html > -1) {
					heneSwal.success('발주 수정이 완료되었습니다');
					parent.fn_MainInfo_List(startDate, endDate);
					$('#modalReport').modal('hide');
	         	} else{
	         		heneSwal.error('발주 수정이 실패했습니다, 다시 시도해주세요')
	         	}
	         },
	         error : function(){
	        	 heneSwal.error('발주 수정이 실패했습니다, 다시 시도해주세요');
	         }
	     });		
	}

    function SetCustName_code(txt_custname, txt_custcode, txt_cust_rev, txt_boss_name, 
							  txt_jongmok, txt_bizno, txt_address, txt_telno, txt_refno) {
		$('#txt_S_CustName').val(txt_custname);
		$('#txt_S_custcode').val(txt_custcode);
		$('#txt_S_cust_rev').val(txt_cust_rev);
		$('#txt_telNo').val(txt_telno);
		
		$('#txt_bom_cd').val('');
		$('#txt_bom_nm').val('');
		$('#txt_part_cd').val('');
		$('#txt_part_cd_rev').val('');		
		$('#txt_gyugeok').val('');
		$('#txt_part_cnt').val('');
		$('#txt_unit_price').val('');
		$('#txt_part_amt').val('');
		$('#txt_rev').val('');
		
   	}

    function SetpartName_code(txt_part_name, txt_part_cd,txt_part_revision_no,txt_gyugeok,txt_unit_price) {

		$('#txt_bom_cd').val(txt_part_cd);
		$('#txt_bom_nm').val(txt_part_name);
		$('#txt_part_cd').val(txt_part_cd);
		$('#txt_part_cd_rev').val(txt_part_revision_no);		
		$('#txt_gyugeok').val(txt_gyugeok);
		$('#txt_unit_price').val(txt_unit_price);
		
		for(var i = 0; i < TableS202S010255_RowCount; i++) {
   	   		
   			var td1 = vTableS202S010255.cell(i, 3).data();
   			
   			console.log(txt_part_name);
   			console.log(td1);
   			if(td1 == txt_part_name){
   	   			alert('각각 다른 원부자재를 등록해 주세요.');
   	   		
   	   		$('#txt_bom_cd').val('');
   			$('#txt_bom_nm').val('');
   			$('#txt_part_cd').val('');
   			$('#txt_part_cd_rev').val('');		
   			$('#txt_gyugeok').val('');
   			$('#txt_part_cnt').val('');
   			$('#txt_unit_price').val('');
   			$('#txt_part_amt').val('');
   			$('#txt_rev').val('');
   	   	
	    	checkval = false;
	    
			checkValue(checkval);
		
   			}
   		
   		}  
		
		
		console.log("SetpartName_code=" + S202S010255_Row_index);
    }    
    
    function SetOrderInfo(order_no, prod_cd,product_nm,bom_no,balju_no){
    	$('#txt_balju_no').val(balju_no);
		$('#txt_order_no').val(order_no);
		$('#txt_prod_cd').val(prod_cd);
		$('#txt_product_nm').val(product_nm);
		$('#txt_bom_cd').val(bom_no);
        $.ajax({
            type: "POST",
            url: "<%=Config.this_SERVER_path%>/Contents/Business/M202/S202S010255.jsp", 
            data: "bom_no=" + bom_no,
            beforeSend: function () {
                $("#Balju_part_List").children().remove();
            },
            success: function (html) {
                $("#Balju_part_List").hide().html(html).fadeIn(50);
            }
        });
    }
    
    function fn_plus_body(obj){
		console.log("fn_plus_body=" + S202S010255_Row_index);
		
    	if($("#txt_bom_nm").val()=='') {
    		alert("BOM등록 또는 수정할 BOM을 선택하세요");
    		return false; 
    	} else if($("#txt_part_cnt").val()=='') { 
			alert("수량을 입력하여 주세요");
			return false;
		} else if($("#txt_unit_price").val()=='') { 
			alert("단가를 입력하여 주세요");
			return false;
		} else if(S202S010255_Row_index>-1){
		    vTableS202S010255.cell( S202S010255_Row_index, 6 ).data( $('#txt_gyugeok').val() );
		    vTableS202S010255.cell( S202S010255_Row_index, 7 ).data( $('#txt_part_cnt').val() );
		    vTableS202S010255.cell( S202S010255_Row_index, 8 ).data( $('#txt_unit_price').val() );
		    vTableS202S010255.cell( S202S010255_Row_index, 9 ).data( $('#txt_part_amt').val() );
		    vTableS202S010255.cell( S202S010255_Row_index, 10 ).data( $('#txt_rev').val() );
		} else {
			vTableS202S010255.row.add( [
				$('#txt_order_no').val(),			//0 주문번호
				$('#txt_balju_no').val(),			//1 발주번호
				$('#txt_seq').val(),				//2 순번
				$('#txt_bom_nm').val(),			//3 자료명
				$('#txt_bom_cd').val(),		//4 자료번호			
				$('#txt_part_cd').val(),			//6 파트코드
				$('#txt_gyugeok').val(),			//7 규격
				$('#txt_part_cnt').val(),			//8 수량
				$('#txt_unit_price').val(),			//9 단가
				$('#txt_part_amt').val(),			//0 금액
				$('#txt_rev').val(),				//1 rev
				$('#txt_part_cd_rev').val(),		//2 part_cd_rev
				//'<button style="width: auto; float: left; " type="button" id="right_btn" class="btn-outline-success">삭제</button>'
	        	''
			] ).draw(true);
		}
	    clear_input();
	    
        TableS202S010255_info = vTableS202S010255.page.info();
        TableS202S010255_RowCount = TableS202S010255_info.recordsTotal;
        $('#txt_seq').val( TableS202S010255_RowCount + 1);
        
        S202S010255_Row_index=-1;
	    $(obj).html("+");	    
    }  
    
	function clear_input(){
		$('#txt_bom_cd').val("");
		$('#txt_part_cd').val("");
		$('#txt_bom_nm').val("");
		$('#txt_part_cd').val("");
		$('#txt_gyugeok').val("");
		$('#txt_part_cnt').val("");
		$('#txt_unit_price').val("");
		$('#txt_part_amt').val("");	//2구분
		$('#txt_rev').val("");		//3구분
	}        
		
    function fn_mius_body(obj){
    	var tr = $(obj).parent();
    	var tbody = $(tr).parent();
    	var trNum = $(tbody).closest('tr').prevAll().length;
		
		console.log(trNum + "==fn_plus_body=" + S202S010255_Row_index);
    	vTableS202S010255.row(trNum ).remove().draw();

	    TableS202S010255_info = vTableS202S010255.page.info();
	    TableS202S010255_RowCount = TableS202S010255_info.recordsTotal;
	    
		for(var i =0; i<TableS202S010255_RowCount; i++){
		    vTableS202S010255.cell( i, 2 ).data( i+1 );
		}
	    
	    $('#txt_seq').val( TableS202S010255_RowCount+1);
	    
	    S202S010255_Row_index=-1;
	    $('#btn_plus').html("+");
    }   

    function SetBomInfo(level, txt_bom_cd, txt_bom_cd_rev, txt_bom_cd, 
    					txt_bom_nm, txt_part_nm, txt_part_cd, txt_part_cd_rev, txt_part_cnt) {
		var rCount;
   		if(level == 0) {
			$('#txt_bom_cd').val(txt_bom_cd);
			$('#txt_bom_cd_rev').val(txt_bom_cd_rev);
			$('#txt_bom_name').val(txt_bom_nm);
			
	        $.ajax({
                type: "POST",
                url: "<%=Config.this_SERVER_path%>/Contents/Business/M101/S101S030150.jsp", 
                data: "bom_cd=" + txt_bom_cd ,
                beforeSend: function () {
                    $("#bom_tbody").children().remove();
                },
                success: function (html) {
               		$("#bom_tbody").hide().html(html).fadeIn(100);
        	        TableS202S010255_info = vTableS202S010255.page.info();
       	        	TableS202S010255_RowCount = TableS202S010255_info.recordsTotal;
       	        
       		    	rCount = TableS202S010255_RowCount + 1;
       	        	$('#txt_seq').val(rCount);
       	        	right_btn_disable();
                }
            });
	        S202S010255_Row_index = -1;

		    $(this).html("+");
   		} else {
			$('#txt_bom_cd').val(txt_bom_cd);
			$('#txt_bom_nm').val(txt_bom_nm);
			$('#txt_part_nm').val(txt_part_nm);
			$('#txt_part_cd').val(txt_part_cd);
			$('#txt_part_cd_rev').val(txt_part_cd_rev);	
			$('#txt_part_cnt').val(txt_part_cnt);	
   		}
	}
</script>

<table class="table" style="width: 100%;">
	<tr>
		<td>
			수신처
		</td>
	    <td>
			<input type="text" class="form-control" id="txt_S_CustName" readonly />
          	<input type="hidden" class="form-control" id="txt_balju_text" />
			<input type="hidden" class="form-control" id="txt_S_custcode" />
			<input type="hidden" class="form-control" id="txt_S_cust_rev" />
			<input type="hidden" class="form-control" id="txt_order_no">
			<input type="hidden" class="form-control" id="txt_order_detail_seq">
			<input type="hidden" class="form-control" id="txt_Cust_damdang">
			<input type="hidden" class="form-control" id="txt_FaxNo">  
			<input type="hidden" class="form-control" id="nabpoom_location">
			<input type="hidden" class="form-control" id="txt_balju_no"/>
		</td>
        <td>
        	전화번호
        </td>
        <td>
			<input type="text" class="form-control" id="txt_telNo" readonly>
       	</td>
	</tr>
	<tr>
	    <td>
	    	발주일자
	    </td>
	    <td id="dateParent">
	    	<input type="text" data-date-format="yyyy-mm-dd" id="dateOrder" class="form-control">
	    </td>
	    <td>
	    	납기일자
	    </td>
	    <td id="dateParent2">
	    	<input type="text" data-date-format="yyyy-mm-dd" id="dateDelivery" class="form-control">
		</td>
	</tr>
</table> 
      	
<table class="table table-striped" style="width:100%" id="bom_table">
	<thead>
		<tr>
			<td>순번</td>
			<td>품명</td>
			<td>규격</td>
			<td>수량</td>
			<td>단가</td>
			<td>금액</td>
			<td><button id="btn_partInfo" class="btn btn-success">기존재료</button></td>
		</tr>
	</thead>

	<tbody id="bom_head_tbody">
		<tr>			            
			<td>
				<input type="text" class="form-control" id="txt_seq" readonly />
			</td>
			<td>
				<input type="text" class="form-control" id="txt_bom_nm" placeholder="Click here" readonly />
				<input type="hidden" class="form-control" id="txt_bom_cd" readonly>
				<input type="hidden" class="form-control" id="txt_bom_cd_rev" readonly>
				<input type="hidden" class="form-control" id="txt_part_cd" readonly>
				<input type="hidden" class="form-control" id="txt_part_cd_rev" readonly> 
			</td>
			<td>
				<input type="text" id="txt_gyugeok" class="form-control" />
			</td>
			<td>
				<input type="text" class="form-control" id="txt_part_cnt">
			</td>
			<td>
				<input type="text" id="txt_unit_price" class="form-control">
			</td>
			<td>
				<input type="text" id="txt_part_amt" class="form-control" readonly>
				<input type="hidden" id="txt_rev" class="form-control">
			</td>
			<td>
				<button id="btn_plus" class="form-control btn btn-info">
					<i>+</i>
				</button>
			</td>
		</tr>
	</tbody>
</table>

<div id="bom_tbody">
</div>