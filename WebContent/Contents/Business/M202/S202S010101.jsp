<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*,java.util.*,javax.servlet.http.*"%>
<%@ page import="mes.client.comm.*" %>
<%@ page import="mes.client.common.*" %>
<%@ page import="mes.client.guiComponents.*" %>
<%@ page import="mes.client.util.*" %>
<%@ page import="mes.client.conf.*" %>
<%@ page import="org.json.simple.*"%><%@ include file="/strings.jsp" %>
<%
/* 
S202S010101.jsp
발주서 등록 
*/
	String loginID = session.getAttribute("login_id").toString();
	String member_key = session.getAttribute("member_key").toString();

	String GV_ORDERNO = "", GV_ORDER_DETAIL_SEQ = "", 
		   GV_JSPPAGE = "", GV_NUM_GUBUN="", 
		   GV_CUST_NM, GV_PRODUCT_NM, GV_LOTNO = "";
	
	if(request.getParameter("OrderNo") == null)
		GV_ORDERNO = "";
	else
		GV_ORDERNO = request.getParameter("OrderNo");	
	
	if(request.getParameter("order_detail_seq") == null)
		GV_ORDER_DETAIL_SEQ="";
	else
		GV_ORDER_DETAIL_SEQ = request.getParameter("order_detail_seq");
	
	if(request.getParameter("jspPage") == null)
		GV_JSPPAGE="0";
	else
		GV_JSPPAGE = request.getParameter("jspPage");	

	if(request.getParameter("num_gubun") == null)
		GV_NUM_GUBUN="";
	else
		GV_NUM_GUBUN = request.getParameter("num_gubun");

	if(request.getParameter("product_nm") == null)
		GV_PRODUCT_NM="";
	else
		GV_PRODUCT_NM = request.getParameter("product_nm");

	if(request.getParameter("cust_nm") == null)
		GV_CUST_NM="";
	else
		GV_CUST_NM = request.getParameter("cust_nm");
	
	if(request.getParameter("LotNo") == null)
		GV_LOTNO = "";
	else
		GV_LOTNO = request.getParameter("LotNo");	
%>
    
    <script type="text/javascript">
//     웹소켓 통신을 위해서 필요한 변수들 ---시작
	var M202S010100E101 = {
			PID:  "M202S010100E101", 
			UPID: "M202S010100E102",  
			totalcnt: 0,
			retnValue: 999,
			colcnt: 0,
			colname: ["","","",""], //insert, Update, Delete 문장을 처리할 때는 사용되지않음
			data: []
	};  
	
	var SQL_Param = {
			PID:  "M202S010100E101",
			excute: "queryProcess",
			stream: "N",
			param: ""
	};
	var GV_RECV_DATA = "";	//웹소켓 onMessage(event)들어온 데이터를 받는 변수
//  웹소켓 통신을 위해서 필요한 변수들 ---끝	

    var JOB_GUBUN = "";

	var vTableS202S010150;
	var TableS202S010150_info;
    var TableS202S010150_RowCount;
    var S202S010150_Row_index = -1;
    
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
	    	fn_plus_body(this); 
	    }); 
	    	    
	    $("#right_btn").click(function(){ 
	    	fn_mius_body(this); 
	    }); 

		$('#txt_order_no').val('<%=GV_ORDERNO%>');
		$('#txt_order_detail_seq').val('<%=GV_ORDER_DETAIL_SEQ%>');
		$('#txt_balju_text').val('<%=GV_PRODUCT_NM%>[<%=GV_CUST_NM%>]용 원부자재조달');
		
		
		$.ajax({
	        type: "POST",
            url: "<%=Config.this_SERVER_path%>/Contents/Business/M202/S202S010150.jsp", 
	        data: "order_no=" + $('#txt_order_no').val() , 
	        beforeSend: function () {
	            $("#bom_tbody").children().remove();
	        },
	        success: function (html) {
	            $("#bom_tbody").hide().html(html).fadeIn(100);
	        }
 		});
        
        S202S010150_Row_index = -1;
        
        // 출고 수량이 바뀌었을 때 적용
	    $("#txt_part_cnt").on("change",function(){
	    	BaljuAmountChange(); 
	    });
	    // 단가가 바뀌었을 때 적용
	    $("#txt_unit_price").on("change",function(){
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
	    
	    $("#dateDelevery").on("change",function(){
	    	DateChange(); 
	    });
    });	
    
    function BaljuAmountChange() {
    	if($('#txt_part_cnt').val() == "" || $('#txt_part_cnt').val() == null || 
    	   $('#txt_part_cnt').val() == undefined || $('#txt_unit_price').val() == "" || 
    	   $('#txt_unit_price').val() == null || $('#txt_unit_price').val() == undefined) {
    		return false;
    	} else {
    		
	    	var part_cnt = parseFloat($("#txt_part_cnt").val());
	    	var unit_price = parseInt($("#txt_unit_price").val().replace(/,/g,''));
	    	var part_amt = parseInt($("#txt_part_amt").val().replace(/,/g,'')); 
    		
	    	part_amt = part_cnt * unit_price;
	    	
    		// 화면상
        	$('#txt_part_amt').val(parseInt(part_amt).toString().replace(/\B(?=(\d{3})+(?!\d))/g, ","));
        	$('#txt_unit_price').val(parseInt(unit_price).toString().replace(/\B(?=(\d{3})+(?!\d))/g, ","));
    	}
        	
    }
    function DateChange(){
        if ($('#dateOrder').val() > $('#dateDelevery').val()){
        	heneSwal.warning("발주일자가 납기일자보다 길 수 없습니다.");
        	return false;
        }
    }


	function select_Oder_Bom_List(orderNo){
    	//caller = 1 : modalFramePopup에서 호출
    	//caller = 0 : 일반화면에서 호출
    	var modalContentUrl  = "<%=Config.this_SERVER_path%>/Contents/Business/M202/S202S010170.jsp?order_no="+orderNo
    		+ "&lotno=" +vLotNo;
    	pop_fn_popUpScr_nd(modalContentUrl, "발주용 BOM 조회(S202S010170)", '600px', '80%');
		return false;
	}
	
	function SetRecvData(){
		DataPars(M202S010100E101,GV_RECV_DATA);  		
   		parent.fn_DetailInfo_List();
        parent.$("#ReportNote").children().remove();
 		parent.$('#modalReport').hide();
	}
	
	function SaveOderInfo() {
		
        TableS202S010150_info = vTableS202S010150.page.info();
        TableS202S010150_RowCount = TableS202S010150_info.recordsTotal;
        
	 	if ($('#dateOrder').val() > $('#dateDelevery').val()){
	 		heneSwal.warning("발주일자가 납기일자보다 길 수 없습니다.");
        	return false;
        }
	 	
	 	if($("#txt_S_CustName").val() == '') { 
	 		heneSwal.warning("수신처를 검색하여 선택하세요");
			return false;
		}
	 	
		if(TableS202S010150_RowCount == 0 ) { 
			heneSwal.warning("원부자재를 등록하여 주세요");
			return false;
		}
	 	
        var dataJsonHead = new Object();
		dataJsonHead.jsp_page			= '<%=GV_JSPPAGE%>' ;
		dataJsonHead.user_id 			= '<%=loginID%>';
		dataJsonHead.prefix 			= '<%=GV_NUM_GUBUN%>';
		dataJsonHead.order_no 			= $('#txt_order_no').val();
		dataJsonHead.order_detail_seq 	= $('#txt_order_detail_seq').val();
		dataJsonHead.balju_text			= $('#txt_balju_text').val();
		dataJsonHead.balju_send_date 	= $('#dateOrder').val();
		dataJsonHead.balju_nabgi_date 	= $('#dateDelevery').val();
		dataJsonHead.cust_cd 			= $('#txt_S_custcode').val();
		dataJsonHead.cust_damdang 		= $('#txt_Cust_damdang').val();
		dataJsonHead.tell_no 			= $('#txt_telNo').val();
		dataJsonHead.fax_no 			= $('#txt_FaxNo').val();
		dataJsonHead.nabpoom_location 	= $('#nabpoom_location').val();
		dataJsonHead.qa_ter_condtion 	= $('#txt_qar').val();
		dataJsonHead.cust_cd_rev 		= $('#txt_S_cust_rev').val();
		dataJsonHead.lotno				= '<%=GV_LOTNO%>';
		dataJsonHead.member_key 		= "<%=member_key%>";

		var jArray = new Array(); // JSON Array 선언

	    for(var i = 0; i < TableS202S010150_RowCount; i++) {  
	        var list_price = vTableS202S010150.cell(i , 8).data().replace(/,/gi,'');
	        var balju_amt = vTableS202S010150.cell(i ,9).data().replace(/,/gi,'');
			var dataJson = new Object(); // BOM Data용
			
			dataJson.balju_seq 		= vTableS202S010150.cell(i , 2).data();		//0 balju_seq   순번
			dataJson.bom_nm		= vTableS202S010150.cell(i , 3).data(); 	//1 bom_nm  자료이름		
			dataJson.bom_cd 	= vTableS202S010150.cell(i , 4).data();		//2 bom_cd 자료번호
			dataJson.part_cd 		= vTableS202S010150.cell(i , 5).data();		//4 part_cd 	파트코드
			dataJson.gyugeok 		= vTableS202S010150.cell(i , 6).data();		//5 gyugeok 	규격
			dataJson.balju_count 	= vTableS202S010150.cell(i , 7).data();		//6 balju_count 수량
			dataJson.list_price 	= list_price;								//7 list_price 	단가
			dataJson.balju_amt 		= balju_amt;								//8 balju_amt 	금액
			dataJson.rev_no 		= vTableS202S010150.cell(i , 10).data();	//9 rev_no		구분
			dataJson.part_cd_rev 	= vTableS202S010150.cell(i , 11).data();	//0 part_cd_rev 구분
			dataJson.member_key 	= "<%=member_key%>";
			jArray.push(dataJson); // 데이터를 배열에 담는다.
	    }
	    
		var dataJsonMulti = new Object();
		dataJsonMulti.paramHead = dataJsonHead;
		dataJsonMulti.param = jArray; // Array를 다시 Object형태로 변환 {"param":{Array...}}

		var JSONparam = JSON.stringify(dataJsonMulti); // JSON Object전송을 위해 문자열형태로 바꿔줌(stringify)
		
		var confirmVal = confirm("등록하시겠습니까?");
		
		if(confirmVal) {
			SendTojsp(JSONparam, SQL_Param.PID);
		}
	}
	
	function fn_Balju_Jaego_Check(bomdata, pid) {
		var title = "부족재고 확인";
		var height = '750px';
		var width = '1460px';
		
		var posX = $('#modalReport_nd').offset().left - $(document).scrollLeft() - width + $('#modalReport_nd').outerWidth();
    	var posY = $('#modalReport_nd').offset().top - $(document).scrollTop() + $('#modalReport_nd').outerHeight();
        $("#modalReport_Title_nd").text(title);
        $("#modalReport_nd").find(".modal-body").css("top", $('#modalReport_nd').scrollTop());
        $("#modalReport_nd").find(".modal-body").css("height", height);
    	$("#modalReport_nd").find(".modal-dialog").css("width", width);
		$("#modalReport_nd").attr("closeOnEscape", "false");
		$.ajax({
	    	type: "POST",
	    	url:  "<%=Config.this_SERVER_path%>/Contents/Business/M202/S202S010180.jsp" , 
	    	data: {"bomdata" : bomdata, "pid" : pid },
	 	 	beforeSend: function () { 
	            $("#ReportNote_nd").children().remove();
	   		},
	   	  	success: function (html) {
			   	  	$('#ReportNote_nd').html(html);
					$('#modalReport_nd').show();
					$('#btn_Canc').on("click",function(){
						$('#modalReport_nd').hide();
					});
	   	   	}
		});

		return false;
	}
    
    function SetCustName_code(name, code, rev){
		$('#txt_S_CustName').val(name);
		$('#txt_S_custcode').val(code);
		$('#txt_S_cust_rev').val(rev);
    }

    function SetpartName_code(txt_part_name, txt_part_cd,txt_part_revision_no,txt_gyugeok,txt_unit_price){

		$('#txt_bom_cd').val(txt_part_cd);
		$('#txt_bom_nm').val(txt_part_name);
		$('#txt_part_cd').val(txt_part_cd);
		$('#txt_part_cd_rev').val(txt_part_revision_no);		
		$('#txt_gyugeok').val(txt_gyugeok);
		$('#txt_unit_price').val(txt_unit_price);
    }    
    
    function SetOrderInfo(order_no, prod_cd,product_nm,bom_no) {
		$('#txt_order_no').val(order_no);
		$('#txt_prod_cd').val(prod_cd);
		$('#txt_product_nm').val(product_nm);
		$('#txt_bom_cd').val(bom_no);
        
		$.ajax({
            type: "POST",
            url: "<%=Config.this_SERVER_path%>/Contents/Business/M202/S202S010150.jsp", 
            data: "bom_no=" + bom_no ,
            beforeSend: function () {
                $("#Balju_part_List").children().remove();
            },
            success: function (html) {
                $("#Balju_part_List").hide().html(html).fadeIn(50);
            }
        });
    }
    
    function fn_plus_body(obj){
    	if($("#txt_bom_nm").val() =='') {
    		heneSwal.warning("BOM등록 또는 수정할 BOM을 선택하세요");
    		return false; 
    	} else if($("#txt_part_cnt").val() =='') { 
    		heneSwal.warning("수량을 입력하여 주세요");
			return false;
		} else if($("#txt_unit_price").val() =='') { 
			heneSwal.warning("단가를 입력하여 주세요");
			return false;
		} else if(S202S010150_Row_index>-1){
			vTableS202S010150.cell( S202S010150_Row_index, 6 ).data( $('#txt_gyugeok').val() );
		    vTableS202S010150.cell( S202S010150_Row_index, 7 ).data( $('#txt_part_cnt').val() );
		    vTableS202S010150.cell( S202S010150_Row_index, 8 ).data( $('#txt_unit_price').val() );
		    vTableS202S010150.cell( S202S010150_Row_index, 9 ).data( $('#txt_part_amt').val() );
		    vTableS202S010150.cell( S202S010150_Row_index, 10 ).data( $('#txt_rev').val() );
		} else {
			vTableS202S010150.row.add( [
				$('#txt_order_no').val(),		//0 BOM 주문번호
				$('#txt_bom_cd').val(),			//1 BOM코드
				$('#txt_seq').val(),			//3 순번
				$('#txt_bom_nm').val(),		//4 자료이름	
				$('#txt_part_cd').val(),		//7 파트코드
				$('#txt_part_cd').val(),		//7 파트코드
				$('#txt_gyugeok').val(),		//8 규격
				$('#txt_part_cnt').val(),		//9 수량
				$('#txt_unit_price').val(),		//0 단가
				$('#txt_part_amt').val(),		//1 금액
				$('#txt_rev').val(),			//2 리비젼
				$('#txt_part_cd_rev').val(),			//2 part_cd_rev
				''
	        ] ).draw(true);
		}
	    clear_input();
	    
        TableS202S010150_info = vTableS202S010150.page.info();
        TableS202S010150_RowCount = TableS202S010150_info.recordsTotal;
        $('#txt_seq').val( TableS202S010150_RowCount + 1);
        
        S202S010150_Row_index=-1;
	    $(obj).html("추가");	    
    }  
    
	function clear_input(){
		$('#txt_seq').val("");
		$('#txt_bom_cd').val("");
		$('#txt_part_cd').val("");
		$('#txt_bom_nm').val("");
		$('#txt_part_cd').val("");
		$('#txt_gyugeok').val("");
		$('#txt_part_cnt').val("");
		$('#txt_unit_price').val("");
		$('#txt_part_amt').val("");			//2구분
		$('#txt_rev').val("");//3구분
	}        
		
    
    function fn_mius_body(obj){
    	var tr = $(obj).parent();
    	var tbody = $(tr).parent();
    	var trNum = $(tbody).closest('tr').prevAll().length;
		
		console.log(trNum + "==fn_plus_body=" + S202S010150_Row_index);
    	vTableS202S010150.row(trNum ).remove().draw();

	    TableS202S010150_info = vTableS202S010150.page.info();
	    TableS202S010150_RowCount = TableS202S010150_info.recordsTotal;
	    
		for(var i =0; i<TableS202S010150_RowCount; i++){
		    vTableS202S010150.cell( i, 2 ).data( i+1 );
		}
	    
	    $('#txt_seq').val( TableS202S010150_RowCount+1);
	    
	    S202S010150_Row_index=-1;
	    $('#btn_plus').html("추가");
    }   

    function SetBomInfo(level, txt_bom_cd, txt_bom_cd_rev, 
    					txt_bom_nm, txt_part_nm, txt_part_cd, 
    					txt_part_cd_rev, txt_part_cnt) {
		var rCount;
		
		if(level == 0) {
			$('#txt_bom_cd').val(txt_bom_cd);
			$('#txt_bom_cd_rev').val(txt_bom_cd_rev);
			$('#txt_bom_name').val(txt_bom_nm);
			
	        $.ajax({
                type: "POST",
                url: "<%=Config.this_SERVER_path%>/Contents/Business/M101/S101S030140.jsp", 
                data: "bom_cd=" + txt_bom_cd ,
                beforeSend: function () {
                    $("#bom_tbody").children().remove();
                },
                success: function (html) {
               	 
               		$("#bom_tbody").hide().html(html).fadeIn(100);
        	        TableS202S010150_info = vTableS202S010150.page.info();
       	        	TableS202S010150_RowCount = TableS202S010150_info.recordsTotal;
       	        
       		    	rCount = TableS202S010150_RowCount + 1;
       	        	$('#txt_seq').val(rCount);
       	        	right_btn_disable();
                }
            });
	        
	        S202S010150_Row_index = -1;
		    $(this).html("추가");
		} else{
			$('#txt_bom_cd').val(txt_bom_cd);
			$('#txt_bom_nm').val(txt_bom_nm);
			$('#txt_part_nm').val(txt_part_nm);
			$('#txt_part_cd').val(txt_part_cd);
			$('#txt_part_cd_rev').val(txt_part_cd_rev);	
			$('#txt_part_cnt').val(txt_part_cnt);	
		}
	}
</script>

		<table class="table" style="width: 100%; margin: 0 auto; align:left">
	        <tr style="background-color: #fff; ">
	            <td style="width: 7%; font-weight: 900; font-size:14px; vertical-align: middle ;text-align:left">제목</td>
	            <td style="width: 43%; font-weight: 900; font-size:14px; vertical-align: middle ;text-align:left"colspan="3">
					<input type="text" class="form-control" id="txt_balju_text""  />
				</td>
	            <td style="width: 50%; font-weight: 900; font-size:14px; vertical-align: middle ; text-align:left" colspan="4">
	           	</td>
			</tr>
	        <tr style="background-color: #fff; ">
	            <td style="width: 7%; font-weight: 900; font-size:14px; vertical-align: middle ;text-align:left">수신처</td>
	            <td style="width: 18%; font-weight: 900; font-size:14px; vertical-align: middle ;text-align:left">
					<input type="text" class="form-control" id="txt_S_CustName" style="width:75%; float:left" readonly />
					<input type="hidden" class="form-control" id="txt_S_custcode" style="width: 120px" />
					<input type="hidden" class="form-control" id="txt_S_cust_rev" style="width: 120px" />
					<button type="button" onclick="parent.pop_fn_CustName_View(1,'I')" id="btn_SearchCust" class="btn btn-info" style="width:25%;float:left;">검색</button>
					
					
					<input type="hidden" class="form-control" id="txt_order_no" style="width: 120px" />
					<input type="hidden" class="form-control" id="txt_order_detail_seq" style="width: 120px" /> 
	           	</td>
	            <td style="width: 7%; font-weight: 900; font-size:14px; vertical-align: middle ;text-align:left">수신인</td>
	            <td style="width: 18%; font-weight: 900; font-size:14px; vertical-align: middle ; text-align:left">
					<input type="text" class="form-control" id="txt_Cust_damdang"  /> 
	           	</td>
	
	            <td style="width: 7%; font-weight: 900; font-size:14px; vertical-align: middle ; text-align:left">전화번호</td>
	            <td style="width: 18%; font-weight: 900; font-size:14px; vertical-align: middle ;text-align:left">
					<input type="text" class="form-control" id="txt_telNo"  />
	           	</td>
	            <td style="width: 7%; font-weight: 900; font-size:14px; vertical-align: middle ;text-align:left">팩스번호</td>
	            <td style=" width: 18%; font-weight: 900; font-size:14px; vertical-align: middle ;text-align:left">
					<input type="text" class="form-control" id="txt_FaxNo"  /> 
	           	</td>
	        </tr>
	        
			<tr  style="background-color: #fff; ">
	            <td style=" font-weight: 900; font-size:14px; vertical-align: middle ;text-align:left">발주일자</td>
	            <td style=" font-weight: 900; font-size:14px; vertical-align: middle ;text-align:left">
	            	<input type="text" data-date-format="yyyy-mm-dd" id="dateOrder" class="form-control" />
	            </td>
	            <td style=" font-weight: 900; font-size:14px; vertical-align: middle ;text-align:left">납기일자</td>
	            <td style=" font-weight: 900; font-size:14px; vertical-align: middle ;text-align:left">
	            	<input type="text" data-date-format="yyyy-mm-dd" id="dateDelevery" class="form-control"/>
	            </td>
	
	            <td style=" font-weight: 900; font-size:14px; vertical-align: middle ; text-align:left">납품장소</td>
	            <td style=" font-weight: 900; font-size:14px; vertical-align: middle ;text-align:left">
	            	<input type="text"  class="form-control" id="nabpoom_location"  />
	            </td>
	        </tr>        

      	</table> 
      	
        <table class="table table-striped" style="width: 100%; margin: 0 ; align:left ;" id="bom_table">
 
	        <tr style="vertical-align: middle">
	            <td style="width:  3%; font-size:14px; text-align:center; vertical-align: middle">순번</td>
	            <td style="width: 15%; font-weight: 900; font-size:14px; text-align:right; vertical-align: middle">품명
	            <label style="width:30%;"></label>	            
				<button type="button" onclick="parent.select_Oder_Bom_List('<%=GV_ORDERNO%>')" id="btn_SearchBom"  style="text-align:right;" class="btn btn-info" >배합(BOM) 검색</button>
				</td>
	            <td style="width:  9%; font-weight: 900; font-size:14px; text-align:center; vertical-align: middle ">배합(BOM)번호</td>
	            <td style="width:  9%; font-weight: 900; font-size:14px; text-align:center; vertical-align: middle">원부자재코드</td>
	            <td style="width:3.5%; font-weight: 900; font-size:14px; text-align:center; vertical-align: middle">규격</td>
	            <td style="width:3.5%; font-weight: 900; font-size:14px; text-align:center; vertical-align: middle">수량</td>
	            <td style="width:3.5%; font-weight: 900; font-size:14px; text-align:center; vertical-align: middle">단가</td>
	            <td style="width:3.5%; font-weight: 900; font-size:14px; text-align:center; vertical-align: middle">금액</td>
	            <td style="width:  2%;vertical-align: middle"></td>
	        </tr>
		
	        <tbody id="bom_head_tbody">
	        <tr style="vertical-align: middle">			            
	        	<td style="text-align:center; vertical-align: middle ;margin: 0 ;">
					<input type="text" class="form-control" id="txt_seq" readonly></input>
				</td>		           
				<td style="text-align:right;vertical-align: middle ;margin: 0 ;">
					<input type="text" class="form-control" maxlength="50" id="txt_bom_nm"  readonly style="width:75%; float:left"></input> 
					<button type="button" onclick="parent.pop_fn_PartList_View(1)" id="btn_SearchPart" class="btn btn-info" style="text-align:center;width:25%; float:left">원부자재 검색</button> 
	           	</td>
	        	<td style="text-align:center; vertical-align: middle ;margin: 0 ;">
					<input type="text" 	 class="form-control" id="txt_bom_cd" readonly></input>
					<input type="hidden" class="form-control" id="txt_bom_cd_rev" readonly></input>
				</td>
	            <td style="text-align:center; vertical-align: middle ;margin: 0 ;">
					<input type="text" 	 class="form-control" id="txt_part_cd" readonly ></input>
					<input type="hidden" class="form-control" id="txt_part_cd_rev" readonly></input>
	           
	           	</td>

	            <td style="font-weight: 900; font-size:14px; text-align:center; vertical-align: middle ;margin: 0 ;">
	            	<input type="text" id="txt_gyugeok" class="form-control" />
	            </td>
	            <td style="text-align:center; vertical-align: middle ;margin: 0 ;">
					<input type="text" numberPoint class="form-control" id="txt_part_cnt" ></input>
	           	</td>
	            <td style="text-align:center; vertical-align: middle ;margin: 0 ;">
	            	<input type="text" numberOnly id="txt_unit_price" class="form-control" />
	            </td>
	            <td style="text-align:center; vertical-align: middle ;margin: 0 ;">
	            	<input type="text" numberOnly id="txt_part_amt" class="form-control" readonly />
	            	<input type="hidden" id="txt_rev" class="form-control"/>
	            </td>
	            
	            <td style="text-align:center; vertical-align: middle ;margin: 0 ;">
	            	<button id="btn_plus" class="form-control btn btn-info" >추가</button></td>
	        </tr>
	        </tbody>
	    </table>

	<div id="bom_tbody">

	</div>

      <p style="text-align:center;">
      	<button id="btn_Save"  class="btn btn-info"  onclick="SaveOderInfo();">발주서저장</button>
          <button id="btn_Canc"  class="btn btn-info"  onclick="parent.$('#modalReport').hide();">취소</button>
      </p>