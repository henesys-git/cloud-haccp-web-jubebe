<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*,java.util.*,javax.servlet.http.*"%>
<%@ page import="mes.client.comm.*" %>
<%@ page import="mes.client.common.*" %>
<%@ page import="mes.client.guiComponents.*" %>
<%@ page import="mes.client.util.*" %>
<%@ page import="mes.client.conf.*" %>
<%@ page import="org.json.simple.*"%><%@ include file="/strings.jsp" %>
<!-- 
S101S040101.jsp
출하정보 등록 
--> 

<%
	String loginID = session.getAttribute("login_id").toString();
	String member_key = session.getAttribute("member_key").toString();
	DoyosaeTableModel TableModel;
	String zhtml = "";
	
	String GV_ORDERNO = "", GV_ORDER_DETAIL_SEQ = "", GV_JSPPAGE = "", GV_NUM_GUBUN = "",
			GV_LOTNO = "", GV_PROD_CD = "", GV_PROD_REV = "", GV_EXPIRATION_DATE = "";
	
	if(request.getParameter("OrderNo") == null)
		GV_ORDERNO = "";
	else
		GV_ORDERNO = request.getParameter("OrderNo");	

	if(request.getParameter("order_detail_seq") == null)
		GV_ORDER_DETAIL_SEQ="";
	else
		GV_ORDER_DETAIL_SEQ = request.getParameter("order_detail_seq");
	
	if(request.getParameter("jspPage") == null)
		GV_JSPPAGE="";
	else
		GV_JSPPAGE = request.getParameter("jspPage");	

	if(request.getParameter("num_gubun") == null)
		GV_NUM_GUBUN="";
	else
		GV_NUM_GUBUN = request.getParameter("num_gubun");
	
	if(request.getParameter("LotNo") == null)
		GV_LOTNO="";
	else
		GV_LOTNO = request.getParameter("LotNo");
	
	if(request.getParameter("prod_cd") == null)
		GV_PROD_CD="";
	else
		GV_PROD_CD = request.getParameter("prod_cd");
	
	if(request.getParameter("prod_rev") == null)
		GV_PROD_REV="";
	else
		GV_PROD_REV = request.getParameter("prod_rev");
	
	if(request.getParameter("expiration_date") == null)
		GV_EXPIRATION_DATE="";
	else
		GV_EXPIRATION_DATE = request.getParameter("expiration_date");
%>
    
<script type="text/javascript">
//  웹소켓 통신을 위해서 필요한 변수들 ---시작
	var M101S040100E101 = {
			PID:  "M101S040100E101", 
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
	var GV_RECV_DATA = "";	// 웹소켓 onMessage(event)들어온 데이터를 받는 변수
//  웹소켓 통신을 위해서 필요한 변수들 ---끝	

    var JOB_GUBUN = "";

	var vTableS101S040140;
	var TableS101S040140_info;
    var TableS101S040140_RowCount;
    var S101S040140_Row_index = -1;    

	var vTableS101S040145;
    var S101S040145_Row_index = -1;
	var TableS101S040145_info;
    var TableS101S040145_RowCount;
    
    var chulhaSeq_Max = -1;
    
    $(document).ready(function () {
	    $("#btn_plus").click(function(){ 
	    	fn_Update_body(this); 
	    }); 
		
        $.ajax({
	        type: "POST",
            url: "<%=Config.this_SERVER_path%>/Contents/Business/M101/S101S040140.jsp", 
	        data: "order_no=" + '<%=GV_ORDERNO%>' + "&order_detail_seq=" + '<%=GV_ORDER_DETAIL_SEQ%>' 
	        	  + "&lotno=" + '<%=GV_LOTNO%>' + "&prod_cd=" + '<%=GV_PROD_CD%>' 
	        	  + "&prod_rev=" + '<%=GV_PROD_REV%>', 
	        beforeSend: function () {
	            $("#Balju_body").children().remove();
	        },
	        success: function (html) {
	            $("#Balju_body").hide().html(html).fadeIn(100);
	        }
 		});
        
        $.ajax({
	        type: "POST",
	        url: "<%=Config.this_SERVER_path%>/Contents/Business/M101/S101S040145.jsp",  
	        data: "order_no=" +  '<%=GV_ORDERNO%>' + "&order_detail_seq=" + '<%=GV_ORDER_DETAIL_SEQ%>'
	        	  + "&mode=insert" + "&lotno=" + '<%=GV_LOTNO%>'
	        	  + "&prod_cd=" + '<%=GV_PROD_CD%>' + "&prod_rev=" + '<%=GV_PROD_REV%>' ,
	        beforeSend: function () {
	            $("#inspect_body").children().remove();
	        },
	        success: function (html) {
	            $("#inspect_body").hide().html(html).fadeIn(500, function() {
	            });
	        }
 		});
        
        $("#txt_chulha_cnt").on("blur",function(){
        	var lotCnt = parseInt($("#txt_lot_count").val());
        	var chulhaCnt = parseInt($("#txt_chulha_cnt").val()); 
        	if(lotCnt < chulhaCnt) {
        		alert("출하수량이 Lot수량보다 많습니다");
        		$("#txt_chulha_cnt").val("");
        	}
        });
        
        // 출고 수량이 바뀌었을 때 적용
	    $("#txt_chulha_cnt").on("change",function(){
	    	ChulhaAmountChange(); 
	    });
	    // 단가가 바뀌었을 때 적용
	    $("#txt_chulha_unit_price").on("change",function(){
	    	ChulhaAmountChange(); 
	    });
	    
	    // 숫자만
	    $("input:text[numberOnly]").on("keyup", function() {
	        $(this).val($(this).val().replace(/[^0-9]/g,""));
	    });

	    // textarea 줄바꿈 제한
	    $('#txt_chulha_bigo').keydown(function(){
	        var rows = $('#txt_chulha_bigo').val().split('\n').length;
	        var maxRows = 1;
	        if(rows > maxRows){
	        	alert('줄바꿈은 불가능합니다');
	        	modifiedText = $('#txt_chulha_bigo').val().split("\n").slice(0, maxRows);
	            $('#txt_chulha_bigo').val(modifiedText.join("\n"));
	        }
	    });
	    
	    // textarea 글자수 제한
	    $('#txt_chulha_bigo').on('keyup', function() {
	    	if($(this).val().length > 10) {
	    alert("글자수는 10자로 이내로 제한됩니다.");
	    		$(this).val($(this).val().substring(0, 10));
	    	}
	    });
	    
	    var v_expiration_date = new Date('<%=GV_EXPIRATION_DATE%>');
	    if(isNaN(v_expiration_date) ==false){
	    	$('#txt_chulha_bigo').val( ("0" + (v_expiration_date.getMonth() + 1)).slice(-2) 
	    			+ "/" + ("0" + v_expiration_date.getDate()).slice(-2) );
	    } else {
	    	$('#txt_chulha_bigo').val('<%=GV_EXPIRATION_DATE%>');
	    }
	    	
    });	
    
    // 출고수량, 단가 계산해서 변경
    function ChulhaAmountChange() {
    	if($('#txt_chulha_cnt').val() == "" || $('#txt_chulha_cnt').val() == null ||
    		 $('#txt_chulha_cnt').val() == undefined || $('#txt_chulha_unit_price').val() == "" || 
    		 $('#txt_chulha_unit_price').val() == null || $('#txt_chulha_unit_price').val() == undefined) {
    		return false;
    	} else {
	    	var chulha_cnt = parseInt($("#txt_chulha_cnt").val());
	    	var chulha_unit_price = parseInt($("#txt_chulha_unit_price").val());
	    	
    		if( isNaN(chulha_cnt) ==false && isNaN(chulha_unit_price) ==false ){
    			var chulha_amount=chulha_cnt * chulha_unit_price;
        		// 화면상
            	$('#txt_chulha_amount').val(chulha_amount.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ","));
            	$('#txt_chulha_unit_price').val(chulha_unit_price.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ","));
    		} else {
    			$('#txt_chulha_amount').val('');
    		}
    	}
    }
	
	function SaveOderInfo() {

		if(TableS101S040145_RowCount == 0 ) { 
			alert("출하정보를 입력하여 주세요");
			return false;
		}
		
		var chekrtn = confirm("저장 후 추가 출하정보등록은 별도 명세서로 만들어집니다."+"\n"+"저장하시겠습니까?");
			
		if(chekrtn){
			TableS101S040145_info = vTableS101S040145.page.info();
	        TableS101S040145_RowCount = TableS101S040145_info.recordsTotal;
	        
	        var dataJsonHead = new Object(); // JSON Object 선언
	        dataJsonHead.jsp_page = '<%=GV_JSPPAGE%>';
	        dataJsonHead.login_id =  '<%=loginID%>'; 
	        dataJsonHead.num_gubun = '<%=GV_NUM_GUBUN%>'; 
	        dataJsonHead.order_detail_seq = '<%=GV_ORDER_DETAIL_SEQ%>';
	        dataJsonHead.member_key = "<%=member_key%>";
				
	        var jArray = new Array(); // JSON Array 선언				
	        
		    for(var i=0; i<TableS101S040145_RowCount; i++){   
		    	var dataJson = new Object(); // 
		    	var chulha_unit_price = vTableS101S040145.cell(i , 6).data().replace(/,/gi,'');
		    	
		    	dataJson.chulha_no				= vTableS101S040145.cell(i , 8).data(); //chulha_no : 없으면 채번, 있으면 해당되는 값 
		    	dataJson.chulha_seq				= vTableS101S040145.cell(i , 26).data(); //chulha_seq
		    	dataJson.order_no				= vTableS101S040145.cell(i , 9).data(); //order_no
		    	dataJson.order_detail_seq		= vTableS101S040145.cell(i , 10).data(); //order_detail_seq
		    	dataJson.lotno					= vTableS101S040145.cell(i , 3).data(); //lotno
		    	dataJson.cust_cd				= vTableS101S040145.cell(i , 11).data(); //cust_cd
		    	dataJson.cust_rev				= vTableS101S040145.cell(i , 12).data(); //cust_rev
		    	dataJson.product_serial_no		= vTableS101S040145.cell(i , 13).data(); //product_serial_no
		    	dataJson.prod_cd				= vTableS101S040145.cell(i , 2).data(); //prod_cd
		    	dataJson.prod_rev				= vTableS101S040145.cell(i , 14).data(); //prod_rev
		    	dataJson.chulha_cnt				= vTableS101S040145.cell(i , 4).data(); //chulha_cnt
		    	dataJson.chulha_unit			= vTableS101S040145.cell(i , 5).data(); //chulha_unit
		    	dataJson.chulha_unit_price		= chulha_unit_price; 					//chulha_unit_price
		    	dataJson.chulha_bigo			= $('#txt_chulha_bigo').val(); 			//txt_chulha_bigo
		    	dataJson.chuha_dt				= ''; //chuha_dt : SYSDATE
		    	dataJson.chulha_user_id			= '<%=loginID%>'; //chulha_user_id
		    	dataJson.product_serial_no_end	= vTableS101S040145.cell(i , 27).data(); //product_serial_no_end
		    	dataJson.member_key				= '<%=member_key %>';
				jArray.push(dataJson); // 데이터를 배열에 담는다.
		    }
			var dataJsonMulti = new Object();
			dataJsonMulti.paramHead = dataJsonHead;
			dataJsonMulti.param = jArray; // Array를 다시 Object형태로 변환 {"param":{Array...}}

			var JSONparam = JSON.stringify(dataJsonMulti); // JSON Object전송을 위해 문자열형태로 바꿔줌(stringify)
			SendTojsp(JSONparam, M101S040100E101.PID); // SendToJSP를 통해 ajax로 데이터(JSONObject,PID) 보냄	
		}
	}
    
	function SendTojsp(bomdata, pid){
	    $.ajax({
	         type: "POST",
	         dataType: "json",
	         url: "<%=Config.this_SERVER_path%>/Contents/CommonView/insert_update_delete_json.jsp", 
	         data:  {"bomdata" : bomdata, "pid" : pid },
	         success: function (html) {	
	        	 if(html > -1) {
	        		parent.SubInfo_TradingList.click();
	                parent.$("#ReportNote").children().remove();
	         		parent.$('#modalReport').hide();
	         		        		
	         	}
	         }
	     });		
	} 
    
    function fn_Update_body(obj){  	
    	if(S101S040140_Row_index == -1 && S101S040145_Row_index == -1) {
    		alert("출하등록 또는 수정할 제품을 선택하세요");
    		return;
    	} else if($("#txt_chulha_cnt").val() =='') { 
			alert("출고수량을 입력하여 주세요");
			return false;
		} else if(S101S040140_Row_index != -1 || S101S040145_Row_index != -1) {
    		if(S101S040140_Row_index != -1 && S101S040145_Row_index == -1){
        		vTableS101S040145.row.add( [
        			(TableS101S040145_RowCount+1), //순번
    				$('#txt_product_nm').val(),
    				$('#txt_prod_cd').val(),
    				$('#txt_lotno').val(),
    				$('#txt_chulha_cnt').val(),
    				$('#txt_chulha_unit').val(),
    				$('#txt_chulha_unit_price').val(),
    				$('#txt_chulha_amount').val(),
    				'ㅋ', //chulha_no : 채번(가짜값)
    				$('#txt_order_no').val(),
    				$('#txt_order_detail_seq').val(),
    				$('#txt_cust_cd').val(),
    				$('#txt_cust_rev').val(),
    				$('#txt_product_serial_no').val(),
    				$('#txt_prod_rev').val(),
    				'', //chulha_dt : SYSDATE
    				'<%=loginID%>', //chulha_user_id
    				$('#txt_delivery_date').val(),
    				$('#txt_project_name').val(),
    				$('#txt_project_cnt').val(),
    				$('#txt_cust_pono').val(),
    				$('#txt_cust_nm').val(),
    				$('#txt_lot_count').val(),
    				$('#txt_order_date').val(),
    				$('#txt_order_count').val(),
    				$('#txt_chulha_bigo').val(),
    				++chulhaSeq_Max, //chulha_seq : 조회된 최대값부터 1씩증가
    				$('#txt_product_serial_no_end').val(),
    				$('#txt_chulha_bigo').val(),
    				'' //삭제버튼
    	        ] ).draw();
        		S101S040140_Row_index = -1;
        		vTableS101S040140.rows().nodes().to$().attr("class", "hene-bg-color_w");
        	} else if(S101S040140_Row_index == -1 && S101S040145_Row_index != -1){
        		vTableS101S040145.cell( S101S040145_Row_index, 1).data( $('#txt_product_nm').val() );
    			vTableS101S040145.cell( S101S040145_Row_index, 2).data( $('#txt_prod_cd').val() );
    			vTableS101S040145.cell( S101S040145_Row_index, 3).data( $('#txt_lotno').val() );
    			vTableS101S040145.cell( S101S040145_Row_index, 4).data( $('#txt_chulha_cnt').val() );
    			vTableS101S040145.cell( S101S040145_Row_index, 5).data( $('#txt_chulha_unit').val() );
    			vTableS101S040145.cell( S101S040145_Row_index, 6).data( $('#txt_chulha_unit_price').val() );
    			vTableS101S040145.cell( S101S040145_Row_index, 7).data( $('#txt_chulha_amount').val() );
    			vTableS101S040145.draw();
    			S101S040145_Row_index = -1;
        	}
    		
    	    clear_input(obj); 
    	    TableS101S040145_info = vTableS101S040145.page.info();
    	    TableS101S040145_RowCount = TableS101S040145_info.recordsTotal;
    	}
    }  
    
	function clear_input(obj){
		$('#txt_product_nm').val("");
		$('#txt_prod_cd').val("");
		$('#txt_lotno').val("");
		$('#txt_lot_count').val("");
		$('#txt_chulha_cnt').val("");
		$('#txt_chulha_unit').val("");
		$('#txt_chulha_unit_price').val("");
		$('#txt_chulha_amount').val("");
		$('#txt_product_serial_no').val("");
		$('#txt_product_serial_no_end').val("");
	}        		
    
    function fn_mius_body(obj){
    	vTableS101S040145.row($(obj).parents('tr')).remove().draw();
    	
	    TableS101S040145_info = vTableS101S040145.page.info();
	    TableS101S040145_RowCount = TableS101S040145_info.recordsTotal;

	    //순번(No) 다시쓰기
		for(var i = 0; i < TableS101S040145_RowCount; i++) {
		    vTableS101S040145.cell(i, 0).data(i + 1);
		}	        
    }       
</script>

	<table class="table table-bordered" style="width: 100%; margin: 0 auto; align:center">
		<tr style="background-color: #fff; ">
            <td style="width: 6.66%; font-weight: 900; font-size:14px; vertical-align: middle ;text-align:left">주문명</td>
            <td style="width: 10%; font-weight: 900; font-size:14px; vertical-align: middle ;text-align:left">
            	<input type="text" class="form-control" maxlength="50" id="txt_project_name"  readonly/>
            </td>            
            <td style="width: 6.66%; font-weight: 900; font-size:14px; vertical-align: middle ;text-align:left">고객사</td>
            <td style="width: 10%; font-weight: 900; font-size:14px; vertical-align: middle ;text-align:left">
            	<input type="text" class="form-control" maxlength="50" id="txt_cust_nm"  readonly/>
            </td>
            <td style="width: 6.66%; font-weight: 900; font-size:14px; vertical-align: middle ;text-align:left">고객사 Po</td>
            <td style="width: 10%; font-weight: 900; font-size:14px; vertical-align: middle ;text-align:left">
            	<input type="text" class="form-control" maxlength="50" id="txt_cust_pono"  readonly/>
            	<input type="hidden" class="form-control" maxlength="50" id="txt_project_cnt"  readonly/>
            </td>
            <td style="width: 9%; font-weight: 900; font-size:14px; vertical-align: middle ;text-align:left">LOT수량</td>
            <td style="width: 5%; font-weight: 900; font-size:14px; vertical-align: middle ;text-align:left">
            	<input type="text" class="form-control" maxlength="50" id="txt_order_count"  readonly/>
            </td>
            <td style="width: 6%; font-weight: 900; font-size:14px; vertical-align: middle ;text-align:left">주문번호</td>
            <td style="width: 16%; font-weight: 900; font-size:14px; vertical-align: middle ;text-align:left">
            	<input type="text" class="form-control" maxlength="50" id="txt_order_no"  readonly/>
            </td>
		</tr>
		<tr  style="background-color: #fff; ">
			<td style="font-weight: 900; font-size:14px; vertical-align: middle ; text-align:left">주문비고</td>
            <td colspan="5"><textarea class="form-control" id="txt_order_bigo" style="height:82px;resize: none;" readonly></textarea></td>
            <td style="font-weight: 900; font-size:14px; vertical-align: middle ; text-align:left">출하비고</td>
            <td colspan="5"><textarea class="form-control" id="txt_chulha_bigo" style="height:82px;resize: none;"></textarea></td>
        </tr>        
      	</table>
        <table class="table table-striped" style="width: 100%; margin: 0 ; align:center ;" id="bom_table">
	        <tr style="vertical-align: middle">
	            <td style="width: 12.5%; font-weight: 900; font-size:14px; text-align:center; vertical-align: middle">제품명</td>
	            <td style="width: 12.5%; font-weight: 900; font-size:14px; text-align:center; vertical-align: middle">제품코드</td>
	            <td style="width: 12.5%; font-weight: 900; font-size:14px; text-align:center; vertical-align: middle">Lot No</td>
	            <td style="width: 12.5%; font-weight: 900; font-size:14px; text-align:center; vertical-align: middle">일련번호</td>
	            <td style="width: 12.5%; font-weight: 900; font-size:14px; text-align:center; vertical-align: middle">출고 수량</td>
	            <td style="width: 0%; display: none; font-weight: 900; font-size:14px; text-align:center; vertical-align: middle;">단위</td>
	            <td style="width: 12.5%; font-weight: 900; font-size:14px; text-align:center; vertical-align: middle">단가</td>
	            <td style="width: 12.5%; font-weight: 900; font-size:14px; text-align:center; vertical-align: middle">금액</td>
	            <td style="width: 12.5%; vertical-align: middle"></td>
	        </tr>
	        <tbody id="bom_head_tbody">
	        <tr style="vertical-align: middle">
	        	<td style="text-align:center; vertical-align: middle ;margin: 0 ;">
	        		<input type="hidden" class="form-control" id="txt_order_detail_seq" readonly/>
	        		<input type="hidden" class="form-control" id="txt_prod_rev" readonly/>
	        		<input type="hidden" class="form-control" id="txt_cust_cd" readonly/>
	        		<input type="hidden" class="form-control" id="txt_cust_rev" readonly/>
	        		<input type="hidden" class="form-control" id="txt_delivery_date" readonly/>
	        		<input type="hidden" class="form-control" id="txt_order_date" readonly/>
	        		<input type="text" class="form-control" id="txt_product_nm" readonly/>			
				</td>		           
				<td style="text-align:right;vertical-align: middle ;margin: 0 ;">
					<input type="text" class="form-control" id="txt_prod_cd"  readonly/> 
	           	</td>
	        	<td style="text-align:center; vertical-align: middle ;margin: 0 ;">
					<input type="text" 	 class="form-control" id="txt_lotno" readonly/>
				</td>
	            <td style="text-align:center; vertical-align: middle ;margin: 0 ;">
					<input type="hidden" class="form-control" id="txt_lot_count" readonly />
					<input type="text" class="form-control" maxlength="50" id="txt_product_serial_no" readonly />
					<input type="hidden" class="form-control" maxlength="50" id="txt_product_serial_no_end" readonly />	           
	           	</td>
	           	<td style="text-align:center; vertical-align:middle; margin:0;">
					<input type="text" numberOnly class="form-control" id="txt_chulha_cnt" />
	           	</td>
	            <td style="text-align:center; vertical-align: middle; margin: 0; width:0%; display: none;">
					<input type="text" class="form-control" id="txt_chulha_unit" />
	           	</td>
	            <td style="text-align:center; vertical-align: middle ;margin: 0 ;">
					<input type="text" class="form-control"  id="txt_chulha_unit_price" />
	           	</td>
	           	<td style="text-align:center; vertical-align: middle ;margin: 0 ;">
					<input type="text" class="form-control"  id="txt_chulha_amount" readonly />
	           	</td>
	            <td style="text-align:center; vertical-align: middle ;margin: 0 ;">
	            	<button id="btn_plus" class="form-control btn btn-info" >
	            		입력
	            	</button>
	            </td>
	        </tr>
	        </tbody>
	    </table>
		<table style="width: 100%;">
			<tr>
				<td>
					<div>
						<div id="Balju_body" style="width:37.5%; float:left;"></div>
						<div style="width:2.5%; float:left;">&nbsp;</div>
						<div id="inspect_body" style="width:60%; float:left;"></div>
					</div>
				</td>
			</tr>
        </table>
		