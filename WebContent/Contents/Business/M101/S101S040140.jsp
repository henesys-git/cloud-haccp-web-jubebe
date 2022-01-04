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
	String[] strColumnHead 	= {"No","제품명","제품코드","Lot No","Lot 수량",
			"project_name","cust_nm","일련번호","cust_pono","project_cnt","order_count","order_no","bigo",
			"order_detail_seq","prod_rev","cust_cd","cust_rev","order_date","delivery_date","product_serial_no_end"};
	int[]   colOff 			= { 1, 1, 1, 1, 0,
			0, 0, 1, 0, 0, 0, 0, 0, 
			0, 0, 0, 0, 0, 0, 0 };
	String[] TR_Style		= {"",""};
// 	String[] TR_Style		= {""," onclick='S101S040140Event(this)' "};
	String[] TD_Style		= {"align:center;font-weight: bold;"}; 
	String[] HyperLink		= {""}; 
	String RightButton[][]	= {{"off", "fn_Chart_View", rightbtnChartShow},{"off", "fn_Doc_Reg()", rightbtnDocSave},{"off", "fn_mius_body(this)", "삭제"}};
	
	String GV_ORDER_NO="",GV_ORDER_DETAIL_SEQ="",GV_LOTNO="",GV_PROD_CD="",GV_PROD_REV="";
	
	if(request.getParameter("order_no")== null)
		GV_ORDER_NO="";
	else
		GV_ORDER_NO = request.getParameter("order_no");	
	
	if(request.getParameter("order_detail_seq")== null)
		GV_ORDER_DETAIL_SEQ="";
	else
		GV_ORDER_DETAIL_SEQ = request.getParameter("order_detail_seq");
	
	if(request.getParameter("lotno")== null)
		GV_LOTNO="";
	else
		GV_LOTNO = request.getParameter("lotno");
	
	if(request.getParameter("prod_cd")== null)
		GV_PROD_CD="";
	else
		GV_PROD_CD = request.getParameter("prod_cd");
	
	if(request.getParameter("prod_rev")== null)
		GV_PROD_REV="";
	else
		GV_PROD_REV = request.getParameter("prod_rev");
	
	String param = GV_ORDER_NO + "|"+ GV_ORDER_DETAIL_SEQ + "|" + GV_LOTNO + "|";
	
	JSONObject jArray = new JSONObject();
	jArray.put( "order_no", GV_ORDER_NO);
	jArray.put( "lotno", GV_LOTNO);
	jArray.put( "prod_cd", GV_PROD_CD);
	jArray.put( "prod_rev", GV_PROD_REV);
	jArray.put( "order_detail_seq", GV_ORDER_DETAIL_SEQ);
	jArray.put( "member_key", member_key);	
    TableModel = new DoyosaeTableModel("M101S040100E144", strColumnHead, jArray);	
 	int RowCount =TableModel.getRowCount();	

 	CurrentPage jspPageName = new CurrentPage(request.getRequestURI());
 	String JSPpage = jspPageName.GetJSP_FileName();
 	
    makeTableHTML= new MakeTableHTML(TableModel);
    makeTableHTML.colCount		= strColumnHead.length;
    makeTableHTML.pageSize 		= RowCount;  //RowCount 1페이지로 구성,PageSize: PageSize의 사이즈로 구성 
    makeTableHTML.currentPageNum= 1;
    makeTableHTML.htmlTable_ID	= "TableS101S040140";
    makeTableHTML.colOff		= colOff;
    makeTableHTML.TR_Style 		= TR_Style;
    makeTableHTML.TD_Style 		= TD_Style; 
    makeTableHTML.HyperLink 	= HyperLink;
    makeTableHTML.user_id		= loginID;
    makeTableHTML.Check_Box 	= "false";
    makeTableHTML.RightButton	= RightButton; 
    makeTableHTML.jsp_page	= JSPpage;
    String zhtml=makeTableHTML.getHTML();	
%>
<script>
    $(document).ready(function () {
    	vTableS101S040140 = $('#<%=makeTableHTML.htmlTable_ID%>').DataTable({
    		scrollX: true,
		    scrollY: 200,
		    scrollCollapse: true,
		    paging: false,
		    searching: false,
		    ordering: true,
		    order: [[ 0, "asc" ]],
		    keys: false,
		    info: false,         
            language: { 
                url:"<%=Config.this_SERVER_path%>/AdminLTE-3.0.5/localisation/Korean.json"
             }
		});
    	
    	TableS101S040140_RowCount = vTableS101S040140.rows().count();
    	
    	$('#txt_project_name').val(vTableS101S040140.cell(0, 5).data()); //5 주문명
 		$('#txt_cust_nm').val(vTableS101S040140.cell(0, 6).data());	//6 고객사
//  		$('#txt_product_serial_no').val(vTableS101S040140.cell(0, 7).data()); //7 시리얼 No
 		$('#txt_cust_pono').val(vTableS101S040140.cell(0, 8).data()); //8 고객사 Po
 		$('#txt_project_cnt').val(vTableS101S040140.cell(0, 9).data()); //9 프로젝트 수량
 		$('#txt_order_count').val(vTableS101S040140.cell(0, 10).data()); //10 LOT수량
 		$('#txt_order_no').val(vTableS101S040140.cell(0, 11).data()); //11 주문번호
 		$('#txt_order_bigo').val(vTableS101S040140.cell(0, 12).data()); //12 주문비고
 		
		$('#<%=makeTableHTML.htmlTable_ID%> tbody').on( 'click', 'tr', function () {
			S101S040140_Row_index = vTableS101S040140.row( this ).index();
	 		$(<%=makeTableHTML.htmlTable_ID%>_rowID).removeClass("hene-bg-color");
	 		vTableS101S040140.row(this).nodes().to$().attr("class","hene-bg-color");
	 		
	 		clear_input();
	 		
			$('#txt_product_nm').val(vTableS101S040140.cell(S101S040140_Row_index, 1).data());	//1 제품명
			$('#txt_prod_cd').val(vTableS101S040140.cell(S101S040140_Row_index, 2).data());	//2 제품코드
			$('#txt_lotno').val(vTableS101S040140.cell(S101S040140_Row_index, 3).data());	//3 Lot No
			$('#txt_lot_count').val(vTableS101S040140.cell(S101S040140_Row_index, 4).data());	//4 Lot 수량
			
			$('#txt_order_detail_seq').val(vTableS101S040140.cell(S101S040140_Row_index, 13).data());	//13 주문상세
			$('#txt_prod_rev').val(vTableS101S040140.cell(S101S040140_Row_index, 14).data());	//14 제품rev
			$('#txt_cust_cd').val(vTableS101S040140.cell(S101S040140_Row_index, 15).data());	//15 고객코드
			$('#txt_cust_rev').val(vTableS101S040140.cell(S101S040140_Row_index, 16).data());	//16 고객rev
			$('#txt_order_date').val(vTableS101S040140.cell(S101S040140_Row_index, 17).data());	//17 주문날짜
			$('#txt_delivery_date').val(vTableS101S040140.cell(S101S040140_Row_index, 18).data());	//18 배송날짜
			
			$('#txt_product_serial_no').val(vTableS101S040140.cell(S101S040140_Row_index, 7).data());
			$('#txt_product_serial_no_end').val(vTableS101S040140.cell(S101S040140_Row_index, 19).data());
			
			$('#btn_plus').html("입력");
			S101S040145_Row_index = -1;
			vTableS101S040145.rows().nodes().to$().attr("class", "hene-bg-color_w");
		} );
		        
		$('#<%=makeTableHTML.htmlTable_ID%> tbody').on( 'blur', 'tr', function () {
			vTableS101S040140.row(this).nodes().to$().attr("class", "hene-bg-color_w");
		} );

    });

//     function S101S040140Event(obj){
//     	var tr = $(obj);
// 		var td = tr.children();
// 		var trNum = $(obj).closest('tr').prevAll().length;//현재 클릭한 TR의 순서 return	
//     }        
</script>

    <%=zhtml%>  