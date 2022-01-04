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
	
	String[] strColumnHead 	= {"order_no","order_detail_seq", "cust_cd","cust_rev", "cust_nm","order_date","product_serial_no", "delivery_date",  "project_name", //0 ~ 8
		"cust_pono",	"prod_cd","prod_rev", "product_nm", "order_count","lotno", "lot_count","비고","생산구분","원부자재공급방법","사급자재출고일","RoHS","특이사항","bomversion","시리얼end"}; // 9 ~ 23
	int[] colOff 			= {1, 1, 1, 1, 1,  1,  1, 1,1,
						  1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1};	//전체 넓이 번튼 3개:86%, 문서2개:90%, 문서뷰:94%, 챠트보기,문서등록91%;

	//챠트보기:4%,문서등록4%;문서View6%
	String RightButton[][]	= {{"off", "fn_Chart_View", rightbtnChartShow},{"off", "fn_Doc_Reg()", rightbtnDocSave},{"off", "file_real_name", rightbtnDocShow}};

	String  GV_ORDERNO, GV_JSPPAGE="",GV_NUM_GUBUN,GV_ORDERDETAIL="", GV_LOTNO="", GV_PRODUCT_GUBUN="", GV_PART_SOURCE="",GV_ROHS="";

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
	
	String loginID = session.getAttribute("login_id").toString();
	String member_key = session.getAttribute("member_key").toString();
	String param =  GV_ORDERNO + "|" + GV_ORDERDETAIL + "|" + GV_LOTNO + "|" + member_key + "|";
	
	JSONObject jArray = new JSONObject();
	jArray.put( "order_no", GV_ORDERNO);
	jArray.put( "order_detail_seq", GV_ORDERDETAIL);
	jArray.put( "lotno", GV_LOTNO);
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
// 		html.append("$('#txt_gubun').val('" 		+ TableModel.getValueAt(0,17).toString().trim() + "');\n");
// 		html.append("$('#txt_part_source').val('" 	+ TableModel.getValueAt(0,18).toString().trim() + "');\n");

	    
		for(int i=0; i<RowCount; i++){
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
			html.append("$('input[name=txt_RoHS'+(vproduct_complete_table_RowCount-1)+']').filter(\"input[value='" 	+ TableModel.getValueAt(i,20).toString().trim() + "']\").attr('checked',true);\n"); //RoHS
			html.append(" trInput.eq(8).val('" 	+ TableModel.getValueAt(i,7).toString().trim()  + "');\n"); //delivery_date
			html.append(" trInput.eq(9).val('" 	+ TableModel.getValueAt(i,21).toString().trim() + "');\n"); //order_note
// 			html.append(" trInput.eq(12).val('" 	+ TableModel.getValueAt(i,22).toString().trim() + "');\n"); //bomversion
			html.append(" trInput.eq(10).val('" 	+ TableModel.getValueAt(i,23).toString().trim() + "');\n"); //productEnd
// 			html.append(" trInput.eq(6).val('');\n");
		}
	}
%>
    
    <script type="text/javascript">
//     웹소켓 통신을 위해서 필요한 변수들 ---시작
	
	var M101S020100E122 = {
			PID:  "M101S020100E122", 
			totalcnt: 0,
			retnValue: 999,
			colcnt: 0,
			colname: ["","","",""], //insert, Update, Delete 문장을 처리할 때는 사용되지않음
			data: []
	};  
	
	var SQL_Param = {
			PID:  "M101S020100E122", 
			excute: "queryProcess",
			stream: "N",
			param: ""
	};
	var GV_RECV_DATA = "";	//웹소켓 onMessage(event)들어온 데이터를 받는 변수
//  웹소켓 통신을 위해서 필요한 변수들 ---끝	
    var detail_seq=1;
	
	var vproduct_complete_table;
    var vproduct_complete_table_Row_index = -1;
	var vproduct_complete_table_info;
    var vproduct_complete_table_RowCount=0;
	
    var checkValue1 = '<%=GV_PRODUCT_GUBUN%>';
    var checkValue2 = '<%=GV_PART_SOURCE%>';
    
    $(document).ready(function () {
    	detail_seq =1;
    	RowCount = '<%=RowCount%>';
    	
    	vproduct_complete_table = $('#product_complete_table').DataTable({
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
		       		'targets': [1],
		       		'createdCell':  function (td) {
		          			$(td).attr('style', 'width:15%;'); 
		       		}
				},
		    	{
		       		'targets': [2,3,4,5,6],
		       		'createdCell':  function (td) {
		          			$(td).attr('style', 'width:8%;'); 
		       		}
				}
// 		    	{
// 		       		'targets': [8],
// 		       		'createdCell':  function (td) {
// 		          			$(td).attr('style', 'width:8%;'); 
// 		       		}
// 				}
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
        

		$('#txt_detail_seq').val(detail_seq);	    
	    
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
     // 라디오 버튼 값
//         $("input[name=txt_RoHS]").filter("input[value='"+checkValue3+"']").attr("checked",true);
    	vproduct_complete_table_info = vproduct_complete_table.page.info();
        vproduct_complete_table_RowCount = vproduct_complete_table_info.recordsTotal;
     
	    <%=html%>
    });

	
	function SaveOderInfo() {    
		var chekrtn = confirm("완료하시겠습니까?"); 
		var WebSockData="";
		var len = $("#product_tbody tr").length;
		
		var parmHead= '<%=Config.HEADTOKEN %>' ;
		if(chekrtn){
	        for(var i=0; i<detail_seq;i++){
	    		var trInput = $($("#product_tbody tr")[i]).find(":input")
	    		
				parmHead += '<%=GV_JSPPAGE%>'			+ "|"
	    				  + '<%=loginID%>'				+ "|"	//주문상세번호
	    				  + $('#txt_order_no').val()	+ "|"
	    				  + trInput.eq(0).val() 		+ "|"	//주문상세번호
	    				  + '0' 						+ "|"	//indGB
	    				  + '<%=GV_LOTNO%>' 			+ "|"	//Lotno
	    				  + '<%=member_key%>' 			+ "|"	//member_key
						parmHead += '<%=Config.DATATOKEN %>' 	;
	    		
	        }
	
			SQL_Param.param = parmHead ;
			SendTojsp(urlencode(SQL_Param.param),SQL_Param.PID);

		}
	}
   

	function SendTojsp(bomdata, pid){
		
	    $.ajax({
	         type: "POST",
	         url: "<%=Config.this_SERVER_path%>/Contents/CommonView/insert_update_delete.jsp", 
	         data:  "bomdata=" + bomdata + "&pid=" + pid,
	         beforeSend: function () {
//	         	 alert(bomdata);
	         },
	         
	         success: function (html) {
	        	 if(html>-1){
		        		parent.fn_MainInfo_List();
		        		vOrderNo = "";  
		        		 vOrderDetailSeq = "";
		        		parent.DetailInfo_List.click();
		                parent.$("#ReportNote").children().remove();
		         		parent.$('#modalReport').hide();
		         	}
	         },
	         error: function (xhr, option, error) {

	         }
	     });		
	}  
    
	
	 function fn_plus_body(){
	    	vproduct_complete_table.row.add( [
	    		"	<input type='text' class='form-control' id='txt_detail_seq'  style='width:30px;' readonly></input>",
	    		"	<input type='text' class='form-control' id='txt_ProductName' style='float:left; width:70%;' readonly></input>" +
	    		"	<button type='button' onclick=\"select_product(this); parent.pop_fn_ProductName_View(1,'ALL')\" id='btn_SearchProd' class='btn btn-info' style='float:left;width:30%;' disabled='disabled'>검색</button> " +
	    		"	<input type='hidden' class='form-control' id='txt_Productcode' readonly></input>" +
	    		"	<input type='hidden' class='form-control' id='txt_prod_rev' readonly></input>" +
	    		"	<input type='hidden' id='txt_productSerialNo' class='form-control' />",
	    		"	<input type='text' class='form-control' id='txt_LOTNo"+vproduct_complete_table_RowCount+"'  readonly></input>",
	    		"	<input type='text' class='form-control' id='txt_LOTCount"+vproduct_complete_table_RowCount+"' readonly ></input>",
// 	    		"	<input type='text' data-date-format='yyyy-mm-dd' class='form-control' id='dateChulgo' readonly disabled='disabled'></input>",
// 	    		"	<input type='radio' id='txt_RoHS' name='txt_RoHS"+vproduct_complete_table_RowCount+"' checked='checked' value='0' disabled='disabled' >Pb Free</input>" +
// 	    		"	<input type='radio' id='txt_RoHS' name='txt_RoHS"+vproduct_complete_table_RowCount+"' value='1' disabled='disabled' >Pb</input>",
	    		"	<input type='text' data-date-format='yyyy-mm-dd' class='form-control' id='dateDelevery' readonly disabled='disabled'></input>",
// 	    		"	<input type='text' class='form-control' id='txt_BOMversion' readonly ></input>",
	    		"	<input type='text' class='form-control' id='txt_order_note'readonly ></input>" +
	    		"	<input type='hidden' id='txt_productSerialNoEnd' class='form-control'readonly />",
//	     		"   <input id='txt_DelYN'  type='checkbox' value=''>삭제여부</input>"
	    		""
	        ] ).draw();
	    	 vproduct_complete_table_info = vproduct_complete_table.page.info();
	         vproduct_complete_table_RowCount = vproduct_complete_table_info.recordsTotal;
	 		
	         var trInput = $($("#product_tbody tr")[vproduct_complete_table_RowCount-1]).find(":input");
	 		trInput.eq(0).val(vproduct_complete_table_RowCount);
	 		var vSerialNo =  "00000" + "1";
	 		var vLotNo = trInput.eq(6).val();
	 		
	         
	 		if(vproduct_complete_table_RowCount>=2){
	 			var pre_seq_no = $($("#product_tbody tr")[vproduct_complete_table_RowCount-2]).find(":input").eq(0).val();
	 			var seq_no = parseInt(pre_seq_no) + 1;
	 			trInput.eq(0).val(seq_no);
	 			vSerialNo += seq_no;
	 		} else {
	 			trInput.eq(0).val(vproduct_complete_table_RowCount);
	 			vSerialNo += vproduct_complete_table_RowCount;
	 		}
	 		
	 	    for(i=0;i<vproduct_complete_table_RowCount;i++){
	 	    	$('input[id=dateDelevery]').eq(i).datepicker({
	 	        	format: 'yyyy-mm-dd',
	 	        	autoclose: true,
	 	        	language: 'ko'
	 	        });
	 	    }
	 	    
	 	    for(i=0;i<vproduct_complete_table_RowCount;i++){
	 	    	$('input[id=dateChulgo]').eq(i).datepicker({
	 	        	format: 'yyyy-mm-dd',
	 	        	autoclose: true,
	 	        	language: 'ko'
	 	        });
	 	    }	

	 		$("#txt_LOTNo"+(vproduct_complete_table_RowCount-1)).on('change', function(){ 
	 	        vproduct_complete_table_info = vproduct_complete_table.page.info();
	 	        vproduct_complete_table_RowCount = vproduct_complete_table_info.recordsTotal;
	 	    		
	 	        vLotNo = trInput.eq(6).val();
	 	        
//	  	    	trInput.eq(5).val($("input[id=txt_LOTNo]").eq(vproduct_complete_table_RowCount-1).val() + "-" + vSerialNo.slice(-4));
	 	    	trInput.eq(5).val(vLotNo + "-" + vSerialNo.slice(-4));
	 	    }); 
	 		$("#txt_LOTCount"+(vproduct_complete_table_RowCount-1)).on('change', function(){ 
	 	        vproduct_complete_table_info = vproduct_complete_table.page.info();
	 	        vproduct_complete_table_RowCount = vproduct_complete_table_info.recordsTotal;
	 	    	
	 	        vLotNo = trInput.eq(6).val();
	 	    	vSerialNo =  "00000" + trInput.eq(7).val();
	 	    		
//	  	    	trInput.eq(14).val($("input[id=txt_LOTNo]").eq(vproduct_complete_table_RowCount-1).val() + "-" + vSerialNo.slice(-4));
	 	    	trInput.eq(14).val(vLotNo + "-" + vSerialNo.slice(-4));
	 	    }); 
	    }   
	
//     function fn_plus_body(){
//     	console.log(detail_seq);
//     	if($("#product_tbody tr").length > 4){
//     		detail_seq = 5
//     	}
//     	else{
// 	    	var TrHtml="";
// 			TrHtml	=  "<tr style='height: 40px; vertical-align: middle'>"			            
// 			TrHtml	+= "	<td style='font-weight: 900; font-size:14px; text-align:left; vertical-align: middle'>"
// 			TrHtml	+= "	<input type='text' class='form-control' id='txt_detail_seq' style='width: 60px; float:left' readonly></input>"
// 			TrHtml	+= "	</td>"
// 	    	TrHtml	+= "	<td style='font-weight: 900; font-size:14px; text-align:left; vertical-align: middle'>"
// 	    	TrHtml	+= "		<input type='text' class='form-control' id='txt_ProductName' style='width: 180px; float:left' readonly></input>"
// 	   		TrHtml	+= "	</td>"
// 	     	TrHtml	+= "	<td style='font-weight: 900; font-size:14px; text-align:left; vertical-align: middle'>"
// 	    	TrHtml	+= "		<input type='text' class='form-control' id='txt_Productcode' style='width: 120px' readonly></input>"
// 			TrHtml	+= "		<input type='hidden' class='form-control' id='txt_prod_rev' style='width: 120px' readonly></input>"
// 	      	TrHtml	+= "    </td>"
// 	       	TrHtml	+= "	<td  style='font-weight: 900; font-size:14px; text-align:left; vertical-align: middle'>"
// 	        TrHtml	+= "      	<input type='text'  id='txt_productSerialNo' class='form-control' style='width: 150px; border: solid 1px #cccccc; vertical-align: middle;' readonly/>"
// 	        TrHtml	+= "	</td>"
// 	        TrHtml	+= "	<td  style='font-weight: 900; font-size:14px; text-align:center; vertical-align: middle'>"
// 	        TrHtml	+= "	</td>"
// 	        TrHtml	+= "</tr>"
// 	    	$('#product_tbody').append(TrHtml);
// 			var trInput = $($("#product_tbody tr")[detail_seq]).find(":input")
// 			trInput.eq(0).val(++detail_seq);
//     	}
// // 		trInput.eq(3).val(code);
//     }    

    
//     function fn_mius_body(){  	
//     	var len = $("#product_tbody tr").length-1;
// 		if(len>=RowCount)
//     		$("#product_tbody tr")[len].remove();
// 		detail_seq--;
// 		if(detail_seq < RowCount)
// 			detail_seq = RowCount;
//     }   
    </script>

   <table class="table table-bordered" style="width: 100%; margin: 0 auto; align:left">
   	<tr>   
		<td style="width: 47%;">
   			<table class="table " style="width: 100%; margin: 0 auto; align:left">
		        <tr style="background-color: #fff;">
		            <td style="width: 16%; font-weight: 900; font-size:14px; text-align:left">주문명</td>
		            <td style="width: 35%; font-weight: 900; font-size:14px; text-align:left">
		           		<input type="hidden" class="form-control" id="txt_order_no" style="width: 120px" />
						<input type="text" class="form-control" id="txt_projrctName" style="width: 200px; float:left" readonly="readonly" />
						<button type="button" onclick="parent.pop_fn_projrctName_View(1)" id="btn_SearchpROJECT" class="btn btn-info" style="float:left" disabled="disabled" >
						    검색</button> 
		           	</td>
		            <td style="width: 15%; font-weight: 900; font-size:14px; text-align:left">고객사</td>
		            <td style="width: 35%; font-weight: 900; font-size:14px; text-align:left">
						<input type="text" class="form-control" id="txt_custname" style="float:left;width:200px;" readonly="readonly" />
						<input type="hidden" class="form-control" id='txt_custcode' style="float:left"  />
						<input type="hidden" class="form-control" id="txt_cust_rev" style="width: 120px" />
						<button type="button" onclick="parent.pop_fn_CustName_View(1,'O')" id="btn_SearchCust" class="btn btn-info" style="float:left" disabled="disabled">
						    검색</button> 
		           	</td>
		        </tr>

				<tr style="background-color: #fff;">
		            <td style=" font-weight: 900; font-size:14px; text-align:left">주문일자</td>
		            <td ><input type="text" data-date-format="yyyy-mm-dd" id="dateOrder" class="form-control"
		                                        style="width: 200px; border: solid 1px #cccccc;" readonly="readonly" disabled='disabled' /></td>
		            <td style=" font-weight: 900; font-size:14px; text-align:left">고객사PoNo</td>
		            <td> <input type="text"  id="txt_cust_poNo" class="form-control" style="width: 200px; border: solid 1px #cccccc; vertical-align: middle;" readonly="readonly"/></td>
<!-- 		            <td style=" font-weight: 900; font-size:14px; text-align:left">납기일자</td> -->
<!-- 		            <td> <input type="text" data-date-format="yyyy-mm-dd" id="dateDelevery" class="form-control" style="width: 150px; border: solid 1px #cccccc;"/></td> -->
		        
		        </tr>

<!-- 		        <tr style="background-color: #fff; "> -->
<!-- 		            <td style=" font-weight: 900; font-size:14px; text-align:left">고객사PoNo</td> -->
<!-- 		            <td> <input type="text"  id="txt_cust_poNo" class="form-control" style="width: 150px; border: solid 1px #cccccc; vertical-align: middle;"/></td> -->
<!-- 		            <td style=" font-weight: 900; font-size:14px; text-align:left">주문 수량</td> -->
<!-- 		            <td> <input type="text"  id="txt_jumunCount" class="form-control" style="width: 150px; border: solid 1px #cccccc; vertical-align: middle;"/></td>		            -->
<!-- 		            <td><input type="hidden"  id="txt_projrctCnt" class="form-control" style="width: 150px; border: solid 1px #cccccc; vertical-align: middle;"/></td> -->
<!-- 		            <TD colspan="2"></TD> -->
<!-- 		        </tr> -->
		
<!-- 		        <tr style="background-color: #fff; "> -->
<!-- 		         	<td style=" font-weight: 900; font-size:14px; text-align:left">프로젝트수량</td> -->
<!-- 		            <td><input type="hidden"  id="txt_projrctCnt" class="form-control" style="width: 150px; border: solid 1px #cccccc; vertical-align: middle;"/></td> -->
<!-- 		            <td style=" font-weight: 900; font-size:14px; text-align:left">주문 수량</td> -->
<!-- 		            <td> <input type="text"  id="txt_jumunCount" class="form-control" style="width: 150px; border: solid 1px #cccccc; vertical-align: middle;"/></td>		            -->
<!-- 		        </tr> -->
		        
<!-- 		        <tr style="background-color: #fff; "> -->
<!-- 		         	<td style=" font-weight: 900; font-size:14px; text-align:left">LOT No</td> -->
<!-- 		            <td><input type="text"  id="txt_LOTNo" class="form-control" style="width: 150px; border: solid 1px #cccccc; vertical-align: middle;"/></td> -->
<!-- 		            <td style=" font-weight: 900; font-size:14px; text-align:left">LOT 수량</td> -->
<!-- 		            <td> <input type="text"  id="txt_LOTCount" class="form-control" style="width: 150px; border: solid 1px #cccccc; vertical-align: middle;"/></td>		            -->
<!-- 		        </tr> -->
		        <tr style="background-color: #fff; display:none;">
		        	<td style=" font-weight: 900; font-size:14px; text-align:left">생산구분</td>
		        	<td>
		        		<input type="radio" id="txt_gubun" name="txt_gubun" checked="checked" value="0" style="width: 60px;" disabled="disabled">양산품</input>
		           		<input type="radio" id="txt_gubun" name="txt_gubun" value="1" style="width: 60px;" disabled="disabled">개발품</input>
		            </td>
		            <td style=" font-weight: 900; font-size:14px; text-align:left">원부자재공급방법</td>
		        	<td>
		        		<input type="radio" id="txt_part_source" name="txt_part_source" checked="checked" value="01" style="width: 60px;" disabled="disabled">사급</input>
		        		<input type="radio" id="txt_part_source" name="txt_part_source" value="02" style="width: 60px;" disabled="disabled">도급</input>
		        		<input type="radio" id="txt_part_source" name="txt_part_source" value="03" style="width: 60px;" disabled="disabled">사급&도급</input>
		            </td>
		        </tr>
<!-- 		        <tr> -->
<!-- 		        	<td style=" font-weight: 900; font-size:14px; text-align:left">원부자재공급방법</td> -->
<!-- 		        	<td> -->
<!-- 		        		<input type="radio" id="txt_part_source" name="txt_part_source" checked="checked" value="1" style="width: 60px;">도급</input> -->
<!-- 		            	<input type="radio" id="txt_part_source" name="txt_part_source" value="2" style="width: 60px;">사급</input> -->
<!-- 		            </td> -->
<!-- 		        </tr> -->
		        <tr style="background-color: #fff" >
		            <td style=" font-weight: 900; font-size:14px; text-align:left" colspan="4" >비고</td>
		        </tr>
		        <tr>
		            <td colspan="4"><textarea class="form-control" id="txt_bigo"  style="cols:10;rows:4; resize:none;" readonly="readonly" ></textarea></td>
		           
		        </tr>
        	</table>
        	    <table class="table " id="product_complete_table" style="width: 100%; margin: 0 auto; align:left">
		<thead>
		        <tr style="vertical-align: middle">
		            <th style="width: 2%; font-weight: 900; font-size:14px; text-align:center; vertical-align: middle">#</th>
		            <th style="width: 20%; font-weight: 900; font-size:14px; text-align:center; vertical-align: middle">제품명</th>
<!-- 		            <th style="width: 50px; font-weight: 900; font-size:14px; text-align:center; vertical-align: middle">제품코드</th> -->
<!-- 		            <th style="width: 9%; font-weight: 900; font-size:14px; text-align:center; vertical-align: middle">시리얼번호</th> -->
		            <th style="width: 10%; font-weight: 900; font-size:14px; text-align:center; vertical-align: middle">LOT No</th>
		            <th style="width: 10%; font-weight: 900; font-size:14px; text-align:center; vertical-align: middle">LOT 수량</th>
<!-- 		            <th style="width: 10%; font-weight: 900; font-size:14px; text-align:center; vertical-align: middle">사급자재 출고일</th> -->
<!-- 		            <th style="width: 10%; font-weight: 900; font-size:14px; text-align:center; vertical-align: middle">RoHS</th> -->
		            <th style="width: 10%; font-weight: 900; font-size:14px; text-align:center; vertical-align: middle">납기일자</th>
		            
<!-- 		            <th style="width: 10%; font-weight: 900; font-size:14px; text-align:center; vertical-align: middle">BOMversion</th> -->
		            <th style="width: 10%; font-weight: 900; font-size:14px; text-align:center; vertical-align: middle">특이사항</th>
		            <th style="width: 8%; font-weight: 900; font-size:14px; text-align:center; vertical-align: middle">
	                	<button alt="한줄 추가" id="btn_plus"  class="btn btn-info btn-sm" disabled="disabled">+</button>
	                	<button alt="한줄 삭제" id="btn_mius"  class="btn btn-info btn-sm" disabled="disabled">-</button></th>
		        </tr>
		</thead>
		        <tbody id="product_tbody">
		        </tbody>
		    </table>
        </td>
<!-- 		<td style="width: 53%"> -->
<!-- 	        <table class="table " id="product_update_table" style="width: 100%; margin: 0 auto; align:left"> -->
<!-- 		<thead> -->
<!-- 		        <tr style="vertical-align: middle"> -->
<!-- 		            <th style="width: 60px; font-weight: 900; font-size:14px; text-align:center; vertical-align: middle">#</th> -->
<!-- 		            <th style="width: 280px; font-weight: 900; font-size:14px; text-align:center; vertical-align: middle">제품명</th> -->
<!-- 		            <th style="width: 190px; font-weight: 900; font-size:14px; text-align:center; vertical-align: middle">제품코드</th> -->
<!-- 		            <th style="width: 90px; font-weight: 900; font-size:14px; text-align:center; vertical-align: middle">시리얼번호</th> -->
<!-- 		            <th style="width: 120px; font-weight: 900; font-size:14px; text-align:center; vertical-align: middle"> -->
<!-- 	                	<button alt="한줄 추가" id="btn_plus"  class="btn btn-info btn-sm" >+</button> -->
<!-- 	                	<button alt="한줄 삭제" id="btn_mius"  class="btn btn-info btn-sm" >-</button></th> -->
<!-- 		        </tr> -->
<!-- 		</thead> -->
<!-- 		        <tbody id="product_tbody"> -->
<!-- 		        </tbody> -->
<!-- 		    </table> -->
<!--         </td> -->
		</tr>
        <tr style="height: 60px">
            <td style="text-align:center">
                <p>
                	<button id="btn_Save"  class="btn btn-info" style="width: 100px" onclick="SaveOderInfo();">처리완료</button>
                    <button id="btn_Canc"  class="btn btn-info" style="width: 100px" onclick="parent.$('#modalReport').hide();">취소</button>
                </p>
            </td>
        </tr>
    </table>
