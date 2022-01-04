<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*,java.util.*,javax.servlet.http.*"%>
<%@ page import="mes.client.comm.*" %>
<%@ page import="mes.client.common.*" %>
<%@ page import="mes.client.guiComponents.*" %>
<%@ page import="mes.client.util.*" %>
<%@ page import="mes.client.conf.*" %>
<%
/* 
S202S020101.jsp
자재검수 등록 
*/
	String loginID = session.getAttribute("login_id").toString();
	String member_key = session.getAttribute("member_key").toString();
	String history_yn = session.getAttribute("history_yn").toString();
	DoyosaeTableModel TableModel;
	String zhtml = "";

	String GV_ORDERNO="", GV_ORDER_DETAIL_SEQ="", GV_JSPPAGE="", GV_NUM_GUBUN="",GV_LOTNO="",GV_BALJUNO="";
	
	if(request.getParameter("OrderNo") == null)
		GV_ORDERNO = "";
	else
		GV_ORDERNO = request.getParameter("OrderNo");	
	
	if(request.getParameter("order_detail_seq") == null)
		GV_ORDER_DETAIL_SEQ = "";
	else
		GV_ORDER_DETAIL_SEQ = request.getParameter("order_detail_seq");

	if(request.getParameter("jspPage") == null)
		GV_JSPPAGE = "0";
	else
		GV_JSPPAGE = request.getParameter("jspPage");	

	if(request.getParameter("num_gubun") == null)
		GV_NUM_GUBUN = "";
	else
		GV_NUM_GUBUN = request.getParameter("num_gubun");
	
	if(request.getParameter("LotNo") == null)
		GV_LOTNO = "";
	else
		GV_LOTNO = request.getParameter("LotNo");
	
	if(request.getParameter("BaljuNo") == null)
		GV_BALJUNO="";
	else
		GV_BALJUNO = request.getParameter("BaljuNo");
%>
    
<script type="text/javascript">
//  웹소켓 통신을 위해서 필요한 변수들 ---시작
	var GV_RECV_DATA = "";	// 웹소켓 onMessage(event)들어온 데이터를 받는 변수
//  웹소켓 통신을 위해서 필요한 변수들 ---끝	

    var JOB_GUBUN = "";

	var vTableS202S020120;
	var TableS202S020120_info;
    var TableS202S020120_RowCount;
    var S202S020120_Row_index = -1;    

	var vTableS202S020125;
    var S202S020125_Row_index = -1;
	var TableS202S020125_info;
    var TableS202S020125_RowCount;
    var vPart_cd = "";
    var vPart_nm = "";
    
    var gvOrderNumber = <%=GV_ORDERNO%>;
    
    $(document).ready(function () {
        new SetSingleDate("", "dateOrder", 0);
        new SetSingleDate("", "dateDelivery", 0);

        //$('#dateOrder').datepicker('update', fromday);
        //$('#dateDelivery').datepicker('update', today);
	    
	    $("#btn_plus").click(function(){ 
	    	fn_Update_body(this); 
	    });
	    
	    $("#right_btn").click(function(){ 
	    	fn_mius_body(this); 
	    }); 

		$('#txt_order_no').val('<%=GV_ORDERNO%>');
		$('#txt_order_detail_seq').val('<%=GV_ORDER_DETAIL_SEQ%>');
		
    });	
    
    //전체입력할때 확인 or 수정하기위한 팝업창 1/24
    function select_Balju_List_Inspect(orderNo){
    	//caller = 1 : modalFramePopup에서 호출
    	//caller = 0 : 일반화면에서 호출
    	var modalContentUrl  = "<%=Config.this_SERVER_path%>/Contents/Business/M202/S202S020126.jsp"
				    			+ "?order_no="+orderNo
				    			+ "&lot_no="+'<%=GV_LOTNO%>'
    							+ "&balju_no="+'<%=GV_BALJUNO%>';
    	pop_fn_popUpScr_nd(modalContentUrl, "자재 검수 리스트(S202S020126)", '600px', '90%');
		return false;
	}
    
    function hist_insert(orderNo){
    	//caller = 1 : modalFramePopup에서 호출
    	//caller = 0 : 일반화면에서 호출
    	var modalContentUrl;
    	
    	if(orderNo.length < 1){
			alert("발주정보를 하나 클릭하세요");
			return false;
		}
    	
    	if(vPart_cd == undefined || vPart_cd.length < 1){
			alert("발주정보를 하나 클릭하세요");
			return;
		}
    	
		modalContentUrl = "<%=Config.this_SERVER_path%>/Contents/Business/M202/S202S020161.jsp"
						+ "?OrderNo=" + orderNo
						+ "&LotNo=" + '<%=GV_LOTNO%>'
						+ "&part_cd=" + vPart_cd
						+ "&part_nm=" + vPart_nm
		    			+ "&jspPage=" + "<%=GV_JSPPAGE%>"
		    			+ "&num_gubun=<%=GV_NUM_GUBUN%>";
		    			
		pop_fn_popUpScr_nd(modalContentUrl,"이력번호 생성(S202S020161)",  "80%", "30%");
		return false;
	}
	
    function fn_Update_body(obj){  	
    	if($('#txt_bom_nm').val().length <1) {
    		heneSwal.warning('입력한 데이터가 없습니다')
			return false;
    	}
    	
    	if(S202S020125_Row_index == -1) {
    		vTableS202S020125.row.add( [
				$('#txt_balju_no').val(),
				$('#txt_balju_seq').val(),
				$('#txt_bom_nm').val(),
				$('#txt_bom_cd').val(),
				$('#txt_part_cd').val(),
				$('#txt_gyugeok').val(),
				$('#txt_part_cnt').val(),
				$('#txt_inspect_cnt').val(),
				$('#txt_unit_price').val(),
				$('#txt_part_amt').val(),
				$('#txt_rev').val() ,
				$('#txt_part_cd_rev').val(),
    			''
	        ]).draw(true);
    	} else {
			vTableS202S020125.cell( S202S020125_Row_index, 0).data( $('#txt_balju_no').val() );
			vTableS202S020125.cell( S202S020125_Row_index, 1).data( $('#txt_balju_seq').val() );
			vTableS202S020125.cell( S202S020125_Row_index, 2).data( $('#txt_bom_nm').val() );
			vTableS202S020125.cell( S202S020125_Row_index, 3).data( $('#txt_bom_cd').val() );
			vTableS202S020125.cell( S202S020125_Row_index, 4).data( $('#txt_part_cd').val() );
			vTableS202S020125.cell( S202S020125_Row_index, 5).data( $('#txt_gyugeok').val() );
			vTableS202S020125.cell( S202S020125_Row_index, 6).data( $('#txt_part_cnt').val() );
			vTableS202S020125.cell( S202S020125_Row_index, 7).data( $('#txt_inspect_cnt').val() );
			vTableS202S020125.cell( S202S020125_Row_index, 8).data( $('#txt_unit_price').val() );
			vTableS202S020125.cell( S202S020125_Row_index, 9).data( $('#txt_part_amt').val() );
			vTableS202S020125.cell( S202S020125_Row_index, 10).data( $('#txt_rev').val() );
			vTableS202S020125.cell( S202S020125_Row_index, 11).data( $('#txt_part_cd_rev').val() );
    	}
    	vTableS202S020125.draw();
	    clear_input(); 
    }  
    
	function clear_input(){
		$('#txt_balju_no').val("");
		$('#txt_balju_seq').val("");
		$('#txt_bom_nm').val("");
		$('#txt_bom_cd').val("");
		$('#txt_part_cd').val("");
		$('#txt_gyugeok').val("");
		$('#txt_part_cnt').val("");
		$('#txt_inspect_cnt').val("");
		$('#txt_unit_price').val("");
		$('#txt_part_amt').val("");	
		$('#txt_rev').val("");	
		$('#txt_part_cd_rev').val("");	
	}
    
    function fn_mius_body(obj){
    	var tr = $(obj).parent();
    	var tbody = $(tr).parent();
    	var trNum = $(tbody).closest('tr').prevAll().length;
		
    	vTableS202S020125.row(S202S020125_Row_index ).remove().draw();

	    TableS202S020125_info = vTableS202S020125.page.info();
	    TableS202S020125_RowCount = TableS202S020125_info.recordsTotal;
	    
		for(var i =0; i < TableS202S020125_RowCount; i++) {
		    vTableS202S020125.cell( i, 3 ).data( i+1 );
		}
    }
</script>
		<table class="table" style="width: 100%; margin: 0 auto; align:left">
	        <tr style="background-color: #fff; ">
	            <td style="width: 7%; font-weight: 900; font-size:14px; vertical-align: middle ;text-align:left">제목</td>
	            <td style="width: 43%; font-weight: 900; font-size:14px; vertical-align: middle ;text-align:left"colspan="3">
					<input type="hidden" class="form-control" id="txt_balju_no"  readonly/>
					<input type="text" class="form-control" id="txt_balju_text"  readonly/>
				</td>
				<%if(history_yn.equals("Y")) { %>
	            	<td style="width: 50%; font-weight: 900; font-size:14px; vertical-align: middle ; text-align:left" colspan="4">
	            		<button id="btn_hist" class="btn btn-info" onclick="parent.hist_insert('<%=GV_ORDERNO%>')">
	            			이력번호생성
	            		</button>
	           		</td>
	           	<%} %>
			</tr>
	        <tr style="background-color: #fff; ">
	            <td style="width: 7%; font-weight: 900; font-size:14px; vertical-align: middle ;text-align:left">
	            	수신처
	            </td>
	            <td style="width: 18%; font-weight: 900; font-size:14px; vertical-align: middle ;text-align:left">
					<input type="text" class="form-control" id="txt_S_CustName" style="width:75%; float:left" readonly/>
					<input type="hidden" class="form-control" id="txt_S_custcode" style="width: 120px" readonly />
					<input type="hidden" class="form-control" id="txt_S_cust_rev" style="width: 120px" readonly />
					<input type="hidden" class="form-control" id="txt_order_no" style="width: 120px" readonly />
					<input type="hidden" class="form-control" id="txt_order_detail_seq" style="width: 120px" readonly /> 
	           	</td>
	            <td style="width:7%; font-weight:900; font-size:14px; vertical-align: middle; text-align:left">수신인</td>
	            <td style="width:18%; font-weight:900; font-size:14px; vertical-align: middle; text-align:left">
					<input type="text" class="form-control" id="txt_Cust_damdang" readonly /> 
	           	</td>
	
	            <td style="width: 7%; font-weight: 900; font-size:14px; vertical-align: middle ; text-align:left">전화번호</td>
	            <td style="width: 18%; font-weight: 900; font-size:14px; vertical-align: middle ;text-align:left">
					<input type="text" class="form-control" id="txt_telNo" readonly />
	           	</td>
	            <td style="width: 7%; font-weight: 900; font-size:14px; vertical-align: middle ;text-align:left">팩스번호</td>
	            <td style="width: 18%; font-weight: 900; font-size:14px; vertical-align: middle ;text-align:left">
					<input type="text" class="form-control" id="txt_FaxNo" readonly />
	           	</td>
	        </tr>
	        
			<tr style="background-color:#fff;">
	            <td style="font-weight:900; font-size:14px; vertical-align:middle; text-align:left">발주일자</td>
	            <td style="font-weight:900; font-size:14px; vertical-align:middle; text-align:left">
	            	<input type="text" data-date-format="yyyy-mm-dd" id="dateOrder" class="form-control" readonly disabled="disabled"/>
	            </td>
	            <td style="font-weight:900; font-size:14px; vertical-align: middle ;text-align:left">납기일자</td>
	            <td style="font-weight:900; font-size:14px; vertical-align: middle ;text-align:left">
	            	<input type="text" data-date-format="yyyy-mm-dd" id="dateDelivery" class="form-control" readonly disabled="disabled"/>
	            </td>
	
	            <td style=" font-weight:900; font-size:14px; vertical-align:middle; text-align:left">납품장소</td>
	            <td style=" font-weight:900; font-size:14px; vertical-align:middle; text-align:left">
	            	<input type="text" class="form-control" id="nabpoom_location" readonly/>
	            </td>
	        </tr>    
      	</table>

		<table style="width:100%;">
			<tr>
				<td>
					<div>
						<div id="Balju_body" style="width:50%; float:left"></div>
						<div id="inspect_body" style="width:50%; float:left"></div>
					</div>
				</td>
			</tr>
        </table>