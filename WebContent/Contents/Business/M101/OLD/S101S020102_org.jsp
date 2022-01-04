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
	DoyosaeTableModel TableModel;

	String[] strColumnHead 	= {
								"order_no", "order_detail_seq", "cust_cd",
								"cust_rev", "cust_nm", "order_date",
								"product_serial_no", "delivery_date", "project_name", //0 ~ 8
								"cust_pono", "prod_cd", "prod_rev", 
								"product_nm", "order_count", "lotno", 
								"lot_count", "비고", "생산구분", 
								"원부자재공급방법", "사급자재출고일", "RoHS",
								"특이사항", "bomversion", "시리얼end" // 9 ~ 23
							  }; 
	int[] colOff = {
					1, 1, 1, 1, 1, 1, 1, 1, 1,
				    1, 1, 1, 1, 1, 1, 1, 1, 1, 
				    1, 1, 1, 1, 1, 1
				   };	//전체 넓이 번튼 3개:86%, 문서2개:90%, 문서뷰:94%, 챠트보기,문서등록91%;

	
	//챠트보기:4%,문서등록4%;문서View6%
	String RightButton[][]	= {{"off", "fn_Chart_View", rightbtnChartShow},{"off", "fn_Doc_Reg()", rightbtnDocSave},{"off", "file_real_name", rightbtnDocShow}};

	String GV_ORDERNO, GV_JSPPAGE="", GV_NUM_GUBUN, GV_ORDERDETAIL="", 
		   GV_LOTNO="", GV_PRODUCT_GUBUN="", GV_PART_SOURCE="",GV_ROHS="",
		   GV_PROD_CD="", GV_PROD_REV="", GV_DELIVERY_DATE="", GV_EXPIRATION_DATE="";

	if(request.getParameter("OrderNo")== null)
		GV_ORDERNO="";
	else
		GV_ORDERNO = request.getParameter("OrderNo");	

	if(request.getParameter("OrderDetail")== null)
		GV_ORDERDETAIL="";
	else
		GV_ORDERDETAIL = request.getParameter("OrderDetail");	

	if(request.getParameter("jspPage")== null)
		GV_JSPPAGE="";
	else
		GV_JSPPAGE = request.getParameter("jspPage");
	
	if(request.getParameter("LotNo")== null)
		GV_LOTNO="";
	else
		GV_LOTNO = request.getParameter("LotNo");
	
	if(request.getParameter("Product_Gubun")== null)
		GV_PRODUCT_GUBUN="";
	else
		GV_PRODUCT_GUBUN = request.getParameter("Product_Gubun");
	
	if(request.getParameter("Part_Source")== null)
		GV_PART_SOURCE="";
	else
		GV_PART_SOURCE = request.getParameter("Part_Source");
	
	if(request.getParameter("Rohs")== null)
		GV_ROHS="";
	else
		GV_ROHS = request.getParameter("Rohs");
	
	if(request.getParameter("ProdCd")== null)
		GV_PROD_CD="";
	else
		GV_PROD_CD = request.getParameter("ProdCd");
	
	if(request.getParameter("ProdRev")== null)
		GV_PROD_REV="";
	else
		GV_PROD_REV = request.getParameter("ProdRev");
	
	if(request.getParameter("DeliveryDate")== null)
		GV_DELIVERY_DATE="";
	else
		GV_DELIVERY_DATE = request.getParameter("DeliveryDate");
	
	if(request.getParameter("ExpirationDate")== null)
		GV_EXPIRATION_DATE="";
	else
		GV_EXPIRATION_DATE = request.getParameter("ExpirationDate");
	
	String loginID = session.getAttribute("login_id").toString();
	String member_key = session.getAttribute("member_key").toString();
	String param =  GV_ORDERNO + "|" + GV_ORDERDETAIL  + "|" + GV_LOTNO  + "|" + member_key + "|" ;
	
	JSONObject jArray = new JSONObject();
	jArray.put( "order_no", GV_ORDERNO);
	jArray.put( "order_detail_seq", GV_ORDERDETAIL);
	jArray.put( "lotno", GV_LOTNO);
	jArray.put( "prod_cd", GV_PROD_CD);
	jArray.put( "prod_rev", GV_PROD_REV);
	jArray.put( "delivery_date", GV_DELIVERY_DATE);
	jArray.put( "expiration_date", GV_EXPIRATION_DATE);
	jArray.put( "member_key", member_key);
	
    TableModel = new DoyosaeTableModel("M101S020100E134", strColumnHead, jArray);	
  
 	int RowCount =TableModel.getRowCount();
 
	StringBuffer html = new StringBuffer();
	if(RowCount>0){
		html.append("$('#txt_order_no').val('" 		+ TableModel.getValueAt(0,0).toString().trim() + "');\n");
		html.append("$('#txt_projrctName').val('" 	+ TableModel.getValueAt(0,8).toString().trim() + "');\n");
		html.append("$('#txt_custcode').val('" 		+ TableModel.getValueAt(0,2).toString().trim() + "');\n");
		html.append("$('#txt_cust_rev').val('" 		+ TableModel.getValueAt(0,3).toString().trim() + "');\n");
	    html.append("$('#txt_custname').val('" 		+ TableModel.getValueAt(0,4).toString().trim() + "');\n");
	    html.append("$('#dateOrder').val('" 		+ TableModel.getValueAt(0,5).toString().trim() + "');\n");
	    html.append("$('#txt_jumunCount').val('" 	+ TableModel.getValueAt(0,13).toString().trim() + "');\n");
	    html.append("$('#txt_cust_poNo').val('" 	+ TableModel.getValueAt(0,9).toString().trim() + "');\n");
	    html.append("$('#txt_bigo').val('" 			+ TableModel.getValueAt(0,16).toString().trim() + "');\n");
	    html.append("$(\"input:radio[name='txt_order_priority']:radio[value='" 
	   				+ TableModel.getValueAt(0,24).toString().trim() + "']\").prop('checked', true);\n");

		for(int i = 0; i < RowCount; i++) {
			html.append( "fn_plus_body();\n" );
			html.append(" var trInput = $($('#product_tbody tr')[" + i + "]).find(':input');\n");
			html.append(" trInput.eq(0).val('" 		+ TableModel.getValueAt(i,1).toString().trim()  + "');\n");	//order_detail_seq
			html.append(" trInput.eq(1).val('" 		+ TableModel.getValueAt(i,12).toString().trim() + "');\n");	//product_nm
			html.append(" trInput.eq(3).val('" 		+ TableModel.getValueAt(i,10).toString().trim() + "');\n");	//prod_cd
			html.append(" trInput.eq(4).val('" 		+ TableModel.getValueAt(i,11).toString().trim() + "');\n");	//prod_rev
			html.append(" trInput.eq(5).val('" 		+ TableModel.getValueAt(i,6).toString().trim()  + "');\n");	//productSerialNo
			html.append(" trInput.eq(6).val('" 		+ TableModel.getValueAt(i,14).toString().trim() + "');\n"); //LOTNo
			html.append(" trInput.eq(7).val('" 		+ TableModel.getValueAt(i,15).toString().trim() + "');\n"); //LOTCount
// 			html.append(" trInput.eq(8).val('" 		+ TableModel.getValueAt(i,19).toString().trim() + "');\n"); //chulgo_date
			// 라디오 버튼 참고!! ▼▼▼
// 			html.append("$('input[name=txt_RoHS'+(vproduct_update_table_RowCount-1)+']').filter(\"input[value='" 	+ TableModel.getValueAt(i,20).toString().trim() + "']\").attr('checked',true);\n"); //RoHS
			html.append(" trInput.eq(8).datepicker('update',new Date('" + TableModel.getValueAt(i,7).toString().trim()  + "'));\n"); //delivery_date
			html.append(" trInput.eq(9).datepicker('update',new Date('" + TableModel.getValueAt(i,25).toString().trim()  + "'));\n"); //expiration_date
			html.append(" trInput.eq(10).val('" 	+ TableModel.getValueAt(i,21).toString().trim() + "');\n"); //order_note
// 			html.append(" trInput.eq(12).val('" 	+ TableModel.getValueAt(i,22).toString().trim() + "');\n"); //bomversion
			html.append(" trInput.eq(11).val('" 	+ TableModel.getValueAt(i,23).toString().trim() + "');\n"); //productEnd
// 			html.append(" trInput.eq(6).val('');\n");
		}
	}

%>
    
<script type="text/javascript">
	// 웹소켓 통신을 위해서 필요한 변수들 ---시작
	var M101S020100E102 = {
			PID:  "M101S020100E102", 
			totalcnt: 0,
			retnValue: 999,
			colcnt: 0,
			colname: ["","","",""], //insert, Update, Delete 문장을 처리할 때는 사용되지않음
			data: []
	};  
	
	var SQL_Param = {
			PID:  "M101S020100E102", 
			excute: "queryProcess",
			stream: "N",
			param: ""
	};
	
	var GV_RECV_DATA = "";	//웹소켓 onMessage(event)들어온 데이터를 받는 변수
	// 웹소켓 통신을 위해서 필요한 변수들 ---끝

    var detail_seq=1;
	var vproduct_update_table;
    var vproduct_update_table_Row_index = -1;
	var vproduct_update_table_info;
    var vproduct_update_table_RowCount=0;
    
    var checkValue1 = '<%=GV_PRODUCT_GUBUN%>';
    var checkValue2 = '<%=GV_PART_SOURCE%>';
    
    $(document).ready(function () {
    	detail_seq =1;
    	RowCount = '<%=RowCount%>'; 
	    vproduct_update_table = $('#product_update_table').DataTable({
	    	scrollX: true,
		    scrollY: 250,
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
		       		'targets': [1],
		       		'createdCell':  function (td) {
		          			$(td).attr('style', 'width:auto%;'); 
		       		}
				},
		    	{
		       		'targets': [2,3,4,5,6,7],
		       		'createdCell':  function (td) {
		          			$(td).attr('style', 'width:12%;'); 
		       		}
		    	}
		   	],
            language: { 
                url:"<%=Config.this_SERVER_path%>/AdminLTE-3.0.5/localisation/Korean.json"
             }
		});
	    
        $("#dateOrder").datepicker({
        	format: 'yyyy-mm-dd',
        	autoclose: true,
        	language: 'ko'
        });
        $('#txt_expiration_date').datepicker({
        	format: 'yyyy-mm-dd',
        	autoclose: true,
        	language: 'ko'
        });
        $('#dateDelevery').datepicker({
        	format: 'yyyy-mm-dd',
        	autoclose: true,
        	language: 'ko'
        });
        $('#dateChulgo').datepicker({
        	format: 'yyyy-mm-dd',
        	autoclose: true,
        	language: 'ko'
        });
        
        var today = new Date();
        var fromday = new Date();
        fromday.setDate(today.getDate());
        
        $('#dateOrder').datepicker('update', fromday);
        $('#dateDelevery').datepicker('update', today);
        $('#dateChulgo').datepicker('update', today);

		$('#txt_seq').val(detail_seq);
		$('#txt_detail_seq').val('<%=GV_ORDERDETAIL%>');	    
	    
	    $("#btn_plus").click(function(){ 
	    	fn_plus_body(); 
	    }); 
	    $("#btn_mius").click(function(){ 
	    	fn_mius_body(); 
	    }); 
	    
	 // 라디오 버튼 값
        $("input[name=txt_gubun]").filter("input[value='"+checkValue1+"']").attr("checked",true);
     // 라디오 버튼 값
        $("input[name=txt_part_source]").filter("input[value='"+checkValue2+"']").attr("checked",true);
	    
     	vproduct_update_table_info = vproduct_update_table.page.info();
        vproduct_update_table_RowCount = vproduct_update_table_info.recordsTotal;
     
	    // textarea 줄바꿈 제한
	    $('#txt_bigo').keydown(function(){
	        var rows = $('#txt_bigo').val().split('\n').length;
	        var maxRows = 1;
	        if( rows > maxRows){
	            alert('줄바꿈은 불가능합니다');
	            modifiedText = $('#txt_bigo').val().split("\n").slice(0, maxRows);
	            $('#txt_bigo').val(modifiedText.join("\n"));
	        }
	    });
	    
	    // textarea 글자수 제한
	    $('#txt_bigo').on('keyup', function() {
	    	if($(this).val().length > 10) {
	    alert("글자수는 10자로 이내로 제한됩니다.");
	    		$(this).val($(this).val().substring(0, 10));
	    	}
	    });
        
	    <%=html%>
    });
    
   
    function select_product(obj){
    	var tr = $(obj).parent().parent();
    	var trNum = $(tr).closest('tr').prevAll().length;
    	
    	vproduct_update_table_Row_index = vproduct_update_table
        .row( trNum )
        .index();
    }
    
	function SetRecvData(){
		DataPars(M101S020100E102,GV_RECV_DATA);  		
   		parent.fn_MainInfo_List();
 		parent.$('#modalReport').hide();
	}
	
	function SaveOderInfo() {        
		var WebSockData="";
		var len = $("#product_tbody tr").length;
		
		if($("#txt_custname").val()=='') { 
			alert("고객사를 검색하여 선택하세요");
			return false;
		}
		
		if($("#txt_custname").val()=='') { 
			alert("고객사를 검색하여 선택하세요");
			return false;
		}
		
		var parmHead= '<%=Config.HEADTOKEN%>' ;

        vproduct_update_table_info = vproduct_update_table.page.info();
        vproduct_update_table_RowCount = vproduct_update_table_info.recordsTotal;
        
		var qa1 = $(':input[name="txt_gubun"]:radio:checked').val();
		var qa2 = $(':input[name="txt_part_source"]:radio:checked').val();
		var qa3 = $(':input[name="txt_RoHS"]:radio:checked').val();
		var qa4 = $(':input[name="txt_order_priority"]:radio:checked').val();
		
		var jArray = new Array(); // JSON Array 선언
		
        for(var i = 0; i < vproduct_update_table_RowCount; i++) {
    		var trInput = $($("#product_tbody tr")[i]).find(":input")
    		qa3 = $(':input[name="txt_RoHS'+i+'"]:radio:checked').val();
    		
    		if(trInput.eq(3).val()== '' ) { 
    			alert("제품을 검색하여 선택하세요");
    			return false;
    		}
    		if(trInput.eq(6).val()== '' ) { 
    			alert("LOT_NO를 입력하여 주세요");
    			return false;
    		}
    		if(trInput.eq(7).val()== '' ) { 
    			alert("LOT수량을 입력하여 주세요");
    			return false;
    		}
    		if(trInput.eq(8).val()== '' ) { 
    			alert("납기일자를 선택하여 주세요");
    			return false;
    		}
    		var dataJson = new Object(); // jSON Object 선언
			    		
				var dataJson = new Object(); // JSON Object 선언			
						
				dataJson.jsp_page = '<%=GV_JSPPAGE%>'; 
				dataJson.user_id = '<%=loginID%>'; 
				dataJson.order_no = $('#txt_order_no').val();
				dataJson.order_detail_seq = trInput.eq(0).val();
	    		dataJson.project_name 		= '';
	    		
	    		dataJson.cust_cd 			= $('#txt_custcode').val();
	    		dataJson.cust_rev 			= $('#txt_cust_rev').val();
	    		dataJson.order_date 		= $('#dateOrder').val();
	    		dataJson.delivery_date 		= trInput.eq(8).val();
	    		dataJson.product_serial_no 	= trInput.eq(5).val();
	    		
	    		dataJson.order_count 	= trInput.eq(7).val();
	    		dataJson.cust_pono 		= $('#txt_cust_poNo').val();
	    		dataJson.bigo 			= $('#txt_bigo').val();
	    		dataJson.prod_cd 		= trInput.eq(3).val();
	    		dataJson.prod_rev 		= trInput.eq(4).val();
	    		
	    		dataJson.lotno 					= trInput.eq(6).val();
	    		dataJson.lot_count 				= trInput.eq(7).val();
	    		dataJson.product_serial_no_end 	= "1111";
// 	    		dataJson.order_no 				= vOrderNo101; //추가로 주문등록할때 OrderNo
				dataJson.order_note 		= trInput.eq(10).val();
				dataJson.order_priority 	= qa4;
				dataJson.expiration_date 	= trInput.eq(9).val();
				dataJson.member_key 		= "<%=member_key%>";
				
				jArray.push(dataJson); // 데이터를 배열에 담는다.
        }
		
		var dataJsonMulti = new Object();
 		dataJsonMulti.param = jArray; // Array를 다시 Object형태로 변환 {"param":{Array...}}

		var JSONparam = JSON.stringify(dataJsonMulti); // JSON Object전송을 위해 문자열형태로 바꿔줌(stringify)
		SendTojsp(JSONparam, SQL_Param.PID); // SendToJSP를 통해 ajax로 데이터(JSONObject,PID) 보냄
	}
    

	function SendTojsp(bomdata, pid){
		
	    $.ajax({
	         type: "POST",
	         dataType: "json",
	         url: "<%=Config.this_SERVER_path%>/Contents/CommonView/insert_update_delete_json.jsp", 
	         data:  {"bomdata" : bomdata, "pid" : pid },
	         success: function (html) {	 
	        	 if(html > -1) {
	        	   	parent.fn_MainInfo_List();
	         		$('#modalReport').modal('hide');
	         	}
	         }
	     });		
	}  

    function fn_CommonPopupModal(sUrl, name, w, h) { // url, name, width, height, 기타 속성(생략해도 무방)     	
        var popupWin = window.showModalDialog(sUrl, name, 'dialogWidth:' + w + 'px; dialogHeight:' + h 
                + 'px; center:yes; help:no; status:no; resizable:no; scroll:yes; toolbar :no;');
    	if(typeof(popupWin)=="undefine")
    		popupWin = window.returnValue;
		return popupWin;
    }  

    function SetCustName_code(name, code, rev){
		$('#txt_custname').val(name);
		$('#txt_custcode').val(code);
		$('#txt_cust_rev').val(rev);
    }
    
    function SetCustProjectInfo(cust_cd, cust_nm,project_name,cust_pono,prod_cd, product_nm,cust_rev,projrctCnt){
		$('#txt_projrctName').val(project_name);
		$('#txt_custname').val(cust_nm);
		$('#txt_projrctCnt').val(projrctCnt);
		
		$('#txt_custcode').val(cust_cd);
		$('#txt_cust_rev').val(cust_rev);
		$('#txt_cust_poNo').val(cust_pono);
    }
    
    function SetProductName_code(name, code, rev){
	    	var trInput = $($("#product_tbody tr")[vproduct_update_table_Row_index]).find(":input")
    		trInput.eq(1).val(name);
    		trInput.eq(3).val(code);
    		trInput.eq(4).val(rev);
//     	}
    }
    
    function fn_plus_body(){
    	vproduct_update_table.row.add( [
    		"	<input type='text' class='form-control' id='txt_detail_seq'  style='width:30px;' readonly></input>",
    		"	<input type='text' class='form-control' id='txt_ProductName' style='float:left; width:70%;' readonly></input>" +
    		"	<button type='button' onclick=\"select_product(this); parent.pop_fn_ProductName_View(1,'01')\" id='btn_SearchProd' class='btn btn-info' style='float:left;width:30%;' disabled='disabled'>검색</button> " +
    		"	<input type='hidden' class='form-control' id='txt_Productcode' readonly></input>" +
    		"	<input type='hidden' class='form-control' id='txt_prod_rev' readonly></input>" +
    		"	<input type='hidden' id='txt_productSerialNo' class='form-control' />",
    		"	<input type='text' style='width:100%;' class='form-control' id='txt_LOTNo"+vproduct_update_table_RowCount+"'  readonly></input>",
    		"	<input type='text' style='width:100%;' numberOnly class='form-control' id='txt_LOTCount"+vproduct_update_table_RowCount+"'  ></input>",
    		"	<input type='text' style='width:100%;' data-date-format='yyyy-mm-dd' class='form-control' id='dateDelevery' readonly ></input>",
    		"	<input type='text' style='width:100%;' id='txt_expiration_date' class='form-control' readonly/>",
    		"	<input type='text' style='width:100%;' class='form-control' id='txt_order_note' ></input>" +
    		"	<input type='hidden' id='txt_productSerialNoEnd' class='form-control' />",
    		""
        ] ).draw();
    	
	    // 숫자만
	    $("input:text[numberOnly]").on("keyup", function() {
	        $(this).val($(this).val().replace(/[^0-9]/g,""));
	    });
	    
        vproduct_update_table_info = vproduct_update_table.page.info();
        vproduct_update_table_RowCount = vproduct_update_table_info.recordsTotal;
		
        var trInput = $($("#product_tbody tr")[vproduct_update_table_RowCount-1]).find(":input");
		trInput.eq(0).val(vproduct_update_table_RowCount);
		var vSerialNo =  "00000" + "1";
		var vLotNo = trInput.eq(6).val();
        
		if(vproduct_update_table_RowCount>=2){
			var pre_seq_no = $($("#product_tbody tr")[vproduct_update_table_RowCount-2]).find(":input").eq(0).val();
			var seq_no = parseInt(pre_seq_no) + 1;
			trInput.eq(0).val(seq_no);
			vSerialNo += seq_no;
		} else {
			trInput.eq(0).val(vproduct_update_table_RowCount);
			vSerialNo += vproduct_update_table_RowCount;
		}
		
	    for(i = 0; i < vproduct_update_table_RowCount; i++) {
	    	$('input[id=dateDelevery]').eq(i).datepicker({
	        	format: 'yyyy-mm-dd',
	        	autoclose: true,
	        	language: 'ko'
	        });
	    }
	    
	    for(i = 0; i < vproduct_update_table_RowCount; i++) {
	    	$('input[id=dateChulgo]').eq(i).datepicker({
	        	format: 'yyyy-mm-dd',
	        	autoclose: true,
	        	language: 'ko'
	        });
	    }	
	    
	    for(i = 0; i < vproduct_update_table_RowCount; i++) {
	    	$('input[id=txt_expiration_date]').eq(i).datepicker({
	        	format: 'yyyy-mm-dd',
	        	autoclose: true,
	        	language: 'ko'
	        });
	    }

		$("#txt_LOTNo"+(vproduct_update_table_RowCount-1)).on('change', function(){ 
	        vproduct_update_table_info = vproduct_update_table.page.info();
	        vproduct_update_table_RowCount = vproduct_update_table_info.recordsTotal;
	    		
	        vLotNo = trInput.eq(6).val();
	        
	    	trInput.eq(5).val(vLotNo + "-" + vSerialNo.slice(-4));
	    }); 
		
		$("#txt_LOTCount"+(vproduct_update_table_RowCount-1)).on('change', function(){ 
	        vproduct_update_table_info = vproduct_update_table.page.info();
	        vproduct_update_table_RowCount = vproduct_update_table_info.recordsTotal;
	    	
	        vLotNo = trInput.eq(6).val();
	    	vSerialNo =  "00000" + trInput.eq(7).val();
	    		
	    	trInput.eq(5).val(vLotNo + "-" + vSerialNo.slice(-4));
	    }); 
    }     
    
    function fn_mius_body() {  	        
        vproduct_update_table
        .row( vproduct_update_table_RowCount-1 )
        .remove()
        .draw();

        vproduct_update_table_info = vproduct_update_table.page.info();
        vproduct_update_table_RowCount = vproduct_update_table_info.recordsTotal;
    }  
    
    </script>

   <table class="table table-bordered" style="width: 100%; margin: 0 auto; align:left">
   	<tr>   
		<td style="width: 47%;">
   			<table class="table " style="width: 100%; margin: 0 auto; align:left">
		        <tr style="background-color: #fff;">
		            <td style="width: 15%; font-weight: 900; font-size:14px; text-align:left">고객사</td>
		            <td style="width: 35%; font-weight: 900; font-size:14px; text-align:left">
						<input type="text" class="form-control" id="txt_custname" style="float:left;width:200px;" readonly />
						<input type="hidden" class="form-control" id='txt_custcode' style="float:left"  />
						<input type="hidden" class="form-control" id="txt_cust_rev" style="width: 120px" />
						<input type="hidden" class="form-control" id="txt_order_no" />
						<input type="hidden" class="form-control" id="txt_projrctName" />
						<button type="button" onclick="parent.pop_fn_CustName_View(1,'O')" id="btn_SearchCust" 
								class="btn btn-info" style="float:left">
							검색
						</button> 
		           	</td>
		        </tr>

				<tr style="background-color: #fff;">
		            <td style=" font-weight: 900; font-size:14px; text-align:left">주문일자</td>
		            <td>
		            	<input type="text" data-date-format="yyyy-mm-dd" id="dateOrder" class="form-control"
		                       style="width: 200px; border: solid 1px #cccccc;"/>
					</td>
		            <td style=" font-weight: 900; font-size:14px; text-align:left">고객사PoNo</td>
		            <td>
		            	<input type="text" id="txt_cust_poNo" class="form-control" 
		            			style="width: 200px; border: solid 1px #cccccc; vertical-align: middle;"/>
		            </td>
		        </tr>

		        <tr style="background-color: #fff; display:none;">
		        	<td style=" font-weight: 900; font-size:14px; text-align:left">생산구분</td>
		        	<td>
		        		<input type="radio" id="txt_gubun" name="txt_gubun" checked="checked" value="0" style="width: 60px;">양산품</input>
		           		<input type="radio" id="txt_gubun" name="txt_gubun" value="1" style="width: 60px;">개발품</input>
		            </td>
		            <td style=" font-weight: 900; font-size:14px; text-align:left">원부자재공급방법</td>
		        	<td>
		        		<input type="radio" id="txt_part_source" name="txt_part_source" checked="checked" value="01" style="width: 60px;" />사급
		        		<input type="radio" id="txt_part_source" name="txt_part_source" value="02" style="width: 60px;" />도급
		        		<input type="radio" id="txt_part_source" name="txt_part_source" value="03" style="width: 60px;" />사급&도급
		            </td>
		        </tr>
				<tr style="background-color: #fff" >
		            <td style=" font-weight: 900; font-size:14px; text-align:left" >긴급주문여부</td>
		            <td>
		        		<input type="radio" id="txt_order_priority" name="txt_order_priority" value="Y" style="width: 60px;" />긴급
		        		<input type="radio" id="txt_order_priority" name="txt_order_priority" value="N" style="width: 60px;" />일반
		            </td>
		        </tr>
		        <tr style="background-color: #fff" >
		        	<td style=" font-weight: 900; font-size:14px; text-align:left" >비고</td>
		            <td colspan="3"><textarea class="form-control" id="txt_bigo"  style="cols:10;rows:4; resize:none;" ></textarea></td>
		           
		        </tr>
        	</table>
       	    <table class="table " id="product_update_table" style="width: 100%; margin: 0 auto; align:left">
				<thead>
					<tr style="vertical-align: middle">
				            <th style="width: 2%; font-weight: 900; font-size:14px; text-align:center; vertical-align: middle">#</th>
				            <th style="width: 26%; font-weight: 900; font-size:14px; text-align:center; vertical-align: middle">제품명</th>
				            <th style="width: 12%; font-weight: 900; font-size:14px; text-align:center; vertical-align: middle">단위</th>
				            <th style="width: 12%; font-weight: 900; font-size:14px; text-align:center; vertical-align: middle">수량</th>
				            <th style="width: 12%; font-weight: 900; font-size:14px; text-align:center; vertical-align: middle">납기일자</th>
				            <th style="width: 12%; font-weight: 900; font-size:14px; text-align:center; vertical-align: middle">유통기한</th>
				            <th style="width: 12%; font-weight: 900; font-size:14px; text-align:center; vertical-align: middle">특이사항</th>
				            <th style="width: 12%; font-weight: 900; font-size:14px; text-align:center; vertical-align: middle">
			                	<button alt="한줄 추가" id="btn_plus" class="btn btn-info btn-sm" disabled="disabled">+</button>
			                	<button alt="한줄 삭제" id="btn_mius" class="btn btn-info btn-sm" disabled="disabled">-</button></th>
					</tr>
				</thead>
	        <tbody id="product_tbody">
	        </tbody>
	    	</table>
        </td>
    </table>