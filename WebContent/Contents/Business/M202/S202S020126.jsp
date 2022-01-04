<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*,java.util.*,javax.servlet.http.*"%>
<%@ page import="mes.client.comm.*" %>
<%@ page import="mes.client.guiComponents.*" %>
<%@ page import="mes.client.util.*" %>
<%@ page import="mes.client.conf.*" %>
<%@ page import="org.json.simple.*"%><%@ include file="/strings.jsp" %>
<%
	DoyosaeTableModel TableModel;
	MakeTableHTML makeTableHTML; 
	String loginID = session.getAttribute("login_id").toString();
	String member_key = session.getAttribute("member_key").toString();

	String[] strColumnHead 	= {"주문번호","발주번호","순번","배합(BOM)명","배합(BOM)번호",
								"원부자재코드","규격",  "수량", "단가",
								"금액", "Rev" ,"part_rev_no","검수수","lotno"};
	int[]   colOff 			= {0, 0, 12, 13, 1,
								1,1,1,0,
								0,0,0,0,0};//전체 넓이 번튼 3개:86%, 문서2개:90%, 문서뷰:94%, 챠트보기,문서등록91%; 고객사

	String[] TR_Style		= {"",""};
// 	String[] TR_Style		= {""," onclick='S202S020120Event(this)' "};
	String[] TD_Style		= {"align:center;font-weight: bold;"}; 
	String[] HyperLink		= {""}; 
	String RightButton[][]	= {{"off", "fn_Chart_View", rightbtnChartShow},{"off", "fn_Doc_Reg()", rightbtnDocSave},{"off", "fn_mius_body(this)", "삭제"}};
	
	String GV_CALLER="",GV_ORDER_NO="", GV_ORDER_DETAIL_SEQ,GV_LOTNO="",GV_BALJU_NO="",GV_JSPPAGE,GV_NUM_GUBUN;
	
	
	
	if(request.getParameter("num_gubun")== null)
		GV_NUM_GUBUN="";
	else
		GV_NUM_GUBUN = request.getParameter("num_gubun");
	
	if(request.getParameter("jspPage")== null)
		GV_JSPPAGE="0";
	else
		GV_JSPPAGE = request.getParameter("jspPage");	
	
	if(request.getParameter("order_no")== null)
		GV_ORDER_NO="";
	else
		GV_ORDER_NO = request.getParameter("order_no");	
	
	if(request.getParameter("caller")== null)
		GV_CALLER="";
	else
		GV_CALLER = request.getParameter("caller");	

	if(request.getParameter("order_detail_seq")== null)
		GV_ORDER_DETAIL_SEQ="";
	else
		GV_ORDER_DETAIL_SEQ = request.getParameter("order_detail_seq");
	
	if(request.getParameter("lot_no")== null)
		GV_LOTNO="";
	else
		GV_LOTNO = request.getParameter("lot_no");
	
	if(request.getParameter("balju_no")== null)
		GV_BALJU_NO="";
	else
		GV_BALJU_NO = request.getParameter("balju_no");
	
	String param = GV_ORDER_NO + "|" + GV_LOTNO + "|" + GV_BALJU_NO + "|" + member_key + "|";
	
	JSONObject jArray = new JSONObject();
	jArray.put( "order_no", GV_ORDER_NO);
	jArray.put( "lotno", GV_LOTNO);
	jArray.put( "baljuno", GV_BALJU_NO);
	jArray.put( "member_key", member_key);
	
//     TableModel = new DoyosaeTableModel("M202S020100E126", strColumnHead, param);
    TableModel = new DoyosaeTableModel("M202S020100E126", strColumnHead, jArray);
 	int RowCount =TableModel.getRowCount();	
 	
 	StringBuffer html = new StringBuffer();
 	for(int i=0; i<RowCount; i++){
 		String GV_INSPECT_PART_CNT = "";
 		if(TableModel.getValueAt(i,12).toString().trim().length()>0) { //검수수량 있을경우(이미 등록된 경우)
 			GV_INSPECT_PART_CNT = TableModel.getValueAt(i,12).toString().trim();
 		} else { // 검수수량 없을경우(최초등록) -> 발주수량 입력
 			GV_INSPECT_PART_CNT = TableModel.getValueAt(i,7).toString().trim();
 		}
 		
		html.append( "fn_plus_body();\n" );
		html.append(" var trInput = $($('#product_tbody tr')[" + i + "]).find(':input');\n");
		html.append(" trInput.eq(0).val('" + TableModel.getValueAt(i,2).toString().trim() + "');\n");	//순번
		html.append(" trInput.eq(1).val('" + TableModel.getValueAt(i,3).toString().trim() + "');\n");	//자료이름
		html.append(" trInput.eq(2).val('" + TableModel.getValueAt(i,4).toString().trim() + "');\n");	//자료번호
		html.append(" trInput.eq(3).val('" + TableModel.getValueAt(i,5).toString().trim() + "');\n");	//파트코드
		html.append(" trInput.eq(4).val('" + TableModel.getValueAt(i,6).toString().trim() + "');\n");	//규격
		html.append(" trInput.eq(5).val('" + GV_INSPECT_PART_CNT 						  + "');\n");	//수량 : 원래 7이였음
		html.append(" trInput.eq(6).val('" + TableModel.getValueAt(i,0).toString().trim() + "');\n");	//주문
		html.append(" trInput.eq(7).val('" + TableModel.getValueAt(i,1).toString().trim() + "');\n");	//발주
		html.append(" trInput.eq(8).val('" + TableModel.getValueAt(i,8).toString().trim() + "');\n");	//단가
		html.append(" trInput.eq(9).val('" + TableModel.getValueAt(i,9).toString().trim() + "');\n");	//금액
		html.append(" trInput.eq(10).val('" + TableModel.getValueAt(i,10).toString().trim() + "');\n");	//rev
		html.append(" trInput.eq(11).val('" + TableModel.getValueAt(i,11).toString().trim() + "');\n");	//rev_no
		html.append(" trInput.eq(12).val('" + TableModel.getValueAt(i,12).toString().trim() + "');\n");	//검수수
		html.append(" trInput.eq(13).val('" + TableModel.getValueAt(i,13).toString().trim() + "');\n");	//lotno
		html.append(" trInput.eq(14).val('" + TableModel.getValueAt(i,7).toString().trim() + "');\n");	//balju_count
		html.append(" trInput.eq(15).val('" + TableModel.getValueAt(i,14).toString().trim() + "');\n");	//uninspect_count
//			html.append(" trInput.eq(6).val('');\n");
	}
 	
 	CurrentPage jspPageName = new CurrentPage(request.getRequestURI());
 	String JSPpage = jspPageName.GetJSP_FileName();
 	
    makeTableHTML= new MakeTableHTML(TableModel);
    makeTableHTML.colCount		= strColumnHead.length;
    makeTableHTML.pageSize 		= RowCount;  //RowCount 1페이지로 구성,PageSize: PageSize의 사이즈로 구성 
    makeTableHTML.currentPageNum= 1;
    makeTableHTML.htmlTable_ID	= "TableS202S020126";
    makeTableHTML.colOff		= colOff;
    makeTableHTML.TR_Style 		= TR_Style;
    makeTableHTML.TD_Style 		= TD_Style; 
    makeTableHTML.HyperLink 	= HyperLink;makeTableHTML.user_id	= loginID;
    makeTableHTML.Check_Box 	= "false";
    makeTableHTML.RightButton	= RightButton; makeTableHTML.jsp_page	= JSPpage;
    String zhtml=makeTableHTML.getHTML();	
%>
<script>

var SQL_Param = {
		PID:  "M202S020100E101", 
		excute: "queryProcess",
		stream: "N",
		param: ""
};

var vproduct_update_table;
var vproduct_update_table_Row_index = -1;
var vproduct_update_table_info;
var vproduct_update_table_RowCount;
	
    $(document).ready(function () {
			vproduct_update_table = $('#<%=makeTableHTML.htmlTable_ID%>').DataTable({
				scrollX: true,
		    scrollY: 340,
// 		    scrollCollapse: true,
		    paging: false,
		    searching: false,
		    ordering: false,
		    order: [[ 1, "asc" ]],
		    keys: false,
		    info: true,
		    	columnDefs: [
	    		{
		       		'targets': [0,1,2,3,4,5,13,14],
		       		'createdCell':  function (td) {
		          			$(td).attr('style', 'width:86px;'); 
		       		}
				},
		    	{
		       		'targets': [6,7,8,9,10,11,12],
		       		'createdCell':  function (td) {
		       			$(td).attr('style', 'width:0px; display: none;'); 
		       		}
				}
            ],
			language: { 
	               url:"<%=Config.this_SERVER_path%>/AdminLTE-3.0.5/localisation/Korean.json"
	            }
		});
			

			
	<%=html%>
	
});
    
    function fn_plus_body(){
    	vproduct_update_table.row.add( [
    		"	<input type='text' class='form-control' id='inspect_detail_seq' readonly></input>",
    		"	<input type='text' class='form-control' id='inspect_bom_nm' readonly></input>",
    		"	<input type='text' class='form-control' id='inspect_bom_cd' readonly></input>",
    		"	<input type='text' class='form-control' id='inspect_part_cd' readonly></input>",
    		"	<input type='text' class='form-control' id='inspect_gyugeok' readonly></input>",
    		"	<input type='text' numberPoint class='form-control' id='inspect_part_cnt'></input>",
    		"	<input type='hidden' class='form-control' id='inspect_order_no'></input>",
    		"	<input type='hidden' class='form-control' id='inspect_balju_no'></input>",
    		"	<input type='hidden' class='form-control' id='inspect_price'></input>",
    		"	<input type='hidden' class='form-control' id='inspect_balju_amt'></input>",
    		"	<input type='hidden' class='form-control' id='inspect_rev'></input>",
    		"	<input type='hidden' class='form-control' id='inspect_rev_no'></input>",
    		"	<input type='hidden' class='form-control' id='inspect_count'></input>",
    		"	<input type='hidden' class='form-control' id='inspect_lot_no'></input>"
    			+ "	<input type='text' class='form-control' id='inspect_balju_count' readonly></input>",
    		"	<input type='text' class='form-control' id='uninspect_count' readonly></input>"
        ] ).draw();
    	
    	vproduct_update_table_info = vproduct_update_table.page.info();
		vproduct_update_table_RowCount = vproduct_update_table_info.recordsTotal;
    	
	    // 숫자만
	    $("input:text[numberOnly]").on("keyup", function() {
	        $(this).val($(this).val().replace(/[^0-9]/g,""));
	    });
	    
	 	// 숫자 또는 소수점만
	 	$("input:text[numberPoint]").on("keyup", function() {
	 		$(this).val($(this).val().replace(/[^0-9.]/g,""));
	 	});
	    
	    for(var i=0;i<vproduct_update_table_RowCount; i++){
			var trInput = $($("#product_tbody tr")[i]).find(":input");
//	    		trInput.eq(0).val(vproduct_update_table_RowCount);
    		var vSerialNo =  "00000" + trInput.eq(0).val();
    		
    	}
		
	    // 수량이 바뀌었을 때 적용(trInput)
	    for(var i=0;i<vproduct_update_table_RowCount; i++){
	    	var trInput = $($("#product_tbody tr")[i]).find(":input");
	    	trInput.eq(5).on("change",function(){
    			var uninspect_count = UnInspectChange(trInput.eq(14).val(),trInput.eq(5).val(),trInput.eq(15).val());
    			if(uninspect_count != "beob") {
    				trInput.eq(15).val(uninspect_count);
    			}
	    	});
	    }
	    

    }     
    
 	// 수량이 바뀌었을 때 적용(trInput)
    function UnInspectChange(inspect_balju_count,inspect_part_cnt,uninspect_count) {
//     	if($('#inspect_balju_count').val()=="" || $('#inspect_balju_count').val()==null || $('#inspect_balju_count').val()==undefined || $('#inspect_part_cnt').val()=="" || $('#inspect_part_cnt').val()==null || $('#inspect_part_cnt').val()==undefined) {
    	if(inspect_balju_count=="" || inspect_balju_count==null || inspect_balju_count==undefined || inspect_part_cnt=="" || inspect_part_cnt==null || inspect_part_cnt==undefined) {
    		return "beob";
    	} else {
    		
// 	    	var balju_count = parseInt($("#inspect_balju_count").val());
// 	    	var inspect_count = parseInt($("#inspect_part_cnt").val());
// 	    	var uninspect_count = parseInt($("#uninspect_count").val()); 
	    	var balju_count = parseFloat(inspect_balju_count);
	    	var inspect_count = parseFloat(inspect_part_cnt);
// 	    	var uninspect_count = parseFloat(uninspect_count);
	    	var uninspect_count = 0.0;
	    	
    		
	    	uninspect_count = balju_count - inspect_count;
	    	
// 	    	$("#uninspect_count").val(uninspect_count);
	    	
    		// 화면상
//     		var new_chulha_amount = Number($('#txt_chulha_cnt').val().replace(/,/gi,'')) * Number($('#txt_chulha_unit_price').val().replace(/,/gi,''));
        	
//     		$('#uninspect_count').val(uninspect_count.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ","));
        	
//         	$('#txt_unit_price').val(unit_price.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ","));

// 			return uninspect_count.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ",");
			return uninspect_count ;
    	}
        	
    }
    


    function S202S020126Event(obj){
    	var tr = $(obj);
		var td = tr.children();
		var trNum = $(obj).closest('tr').prevAll().length;//현재 클릭한 TR의 순서 return	
		
// 		$(<%=makeTableHTML.htmlTable_ID%>_rowID).attr("class", "");
// 		$(obj).attr("class", "hene-bg-color");

// 		$('#txt_seq').val(td.eq(0).text().trim());

    }
    
    
    function SaveOderInfo() {
    	var WebSockData="";
		
		vproduct_update_table_info = vproduct_update_table.page.info();
		vproduct_update_table_RowCount = vproduct_update_table_info.recordsTotal;
		

        
		var jArray = new Array(); // JSON Array 선언
		
		for(var i=0; i<vproduct_update_table_RowCount;i++){
    		var trInput = $($("#product_tbody tr")[i]).find(":input")
        	if( trInput.eq(5).val() == ''){
        		alert("수량을 입력하여 주세요.");
        		return false;
        	}
    		var dataJson = new Object(); // BOM Data용
    		
			dataJson.jsp_page			= '<%=GV_JSPPAGE%>';
			dataJson.user_id 			= '<%=loginID%>';
			dataJson.prefix 			= '<%=GV_NUM_GUBUN%>';
			dataJson.balju_no 		= trInput.eq(7).val();	//0 balju_no   순번
			dataJson.balju_seq 		= trInput.eq(0).val();	//1 순번
			dataJson.bom_nm 	=  trInput.eq(1).val();	//1 자료이름					
			dataJson.bom_cd 	= trInput.eq(2).val();	//2 자료번호
			dataJson.part_cd 	= trInput.eq(3).val();	//4 part_cd 파트코드
			dataJson.gyugeok 	= trInput.eq(4).val();	//5 gyugeok 규격
			dataJson.balju_count 	= trInput.eq(14).val();	//6 balju_count 수량
			dataJson.order_no 	= trInput.eq(6).val();	//6 order_no 
// 	    	dataJson.inspect_count 	= trInput.eq(13).val();	//7 inspect_count 	//수입검사 하면 주석 풀어야함
			dataJson.inspect_count 	= trInput.eq(5).val();	//7 inspect_count 	//수입검사 하면 주석 해야함
			dataJson.list_price 	= trInput.eq(8).val();	//8 단가
			dataJson.balju_amt 	= trInput.eq(9).val();	//9 금액
			dataJson.rev_no 	= trInput.eq(10).val();	//0 rev 
			dataJson.part_cd_rev 	= trInput.eq(11).val();	//0 part_cd_rev
			dataJson.lotno 	= '<%=GV_LOTNO%>';
			dataJson.member_key 	= '<%=member_key%>'; 
			
			jArray.push(dataJson); // 데이터를 배열에 담는다.
	}  
// 		alert(parmBody);
		var dataJsonMulti = new Object();
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
//	         	 alert(bomdata);
	         },
	         
	         success: function (html) {	
	        	 if(html>-1){
	        		parent.fn_DetailInfo_List();
	                parent.$("#ReportNote_nd").children().remove();
	         		parent.$('#modalReport_nd').hide();
	         		parent.$("#ReportNote").children().remove();
	         		parent.$('#modalReport').hide();
	         	}
	         },
	         error: function (xhr, option, error) {

	         }
	     });		
	} 
</script>
          	
   

<table class="table " id="TableS202S020126"
	style="width: 100%; margin: 0 auto; align: left">
	<thead>
		<tr style="vertical-align: middle">
			<th
				style="width: 86px; font-weight: 900; font-size: 14px; vertical-align: middle">순번</th>
			<th
				style="width: 86px; font-weight: 900; font-size: 14px; vertical-align: middle">배합(BOM)이름</th>
			<th
				style="width: 86px; font-weight: 900; font-size: 14px; vertical-align: middle">배합(BOM)번호</th>
			<th
				style="width: 86px; font-weight: 900; font-size: 14px; vertical-align: middle">원부자재코드</th>
			<th
				style="width: 86px; font-weight: 900; font-size: 14px; vertical-align: middle">규격</th>
			<th
				style="width: 86px; font-weight: 900; font-size: 14px; vertical-align: middle">검수수량</th>
			<th style='width:0px; display: none;'>inspect_order_no</th>
			<th style='width:0px; display: none;'>inspect_balju_no</th>
			<th style='width:0px; display: none;'>inspect_price</th>
			<th style='width:0px; display: none;'>inspect_balju_amt</th>
			<th style='width:0px; display: none;'>inspect_rev</th>
			<th style='width:0px; display: none;'>inspect_rev_no</th>
			<th style='width:0px; display: none;'>inspect_count</th>
			<th style="width: 86px; font-weight: 900; font-size: 14px; vertical-align: middle">발주수량</th>
			<th style="width: 86px; font-weight: 900; font-size: 14px; vertical-align: middle">미검수수량</th>
			
		</tr>
	</thead>
	<tbody id="product_tbody">
		
	</tbody>
	
	
</table>
<div style="text-align:center">
   	<p>
        <button id="btn_Save"  class="btn btn-info" style="width: 100px" onclick="SaveOderInfo();">저장</button>
    	<button id="btn_Canc"  class="btn btn-info" style="width: 100px" onclick="parent.$('#modalReport_nd').hide();">취소</button>
	</p>
</div>

