<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*,java.util.*,javax.servlet.http.*"%>
<%@ page import="mes.client.comm.*" %>
<%@ page import="mes.client.guiComponents.*" %>
<%@ page import="mes.client.util.*" %>
<%@ page import="mes.client.conf.*" %>
<%@ page import="org.json.simple.*"%><%@ include file="/strings.jsp" %>
<%
	DoyosaeTableModel TableModel;
	DBServletLink dbLink = new DBServletLink();
	DateTimeUtil dateTimeUtil = new DateTimeUtil();
	MakeTableHTML makeTableHTML;
	String loginID = session.getAttribute("login_id").toString();
	String member_key = session.getAttribute("member_key").toString();
	
	int startPageNo = 1;

	String[] strColumnHead 	= { 
// 								"목록번호","품목명","최종순번","형식번호","적용품목","부서","승인일","승인",
								"순번",
// 								"자료번호","원부자재번호",
								"원부자재코드","원부자재명","수량",
// 								"매수","구분","QAR","검사장비","포장자료","수정","구매처","비고","cust_code","cust_rev",
								"part_cd_rev", 
// 								"bom_cd_rev","sys_bom_parentid" 
								};
	int[] colOff 			= { 
// 								0, 0, 0, 0, 0, 0, 0, 0, 
								1, 
// 								0, 0, 
								1, 1, 1, 
// 								0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 
								0,
// 								0, 0 
								};
	String[] TR_Style		= {"",""};
	String[] TD_Style		= {"align:center;font-weight: bold;"};  //strColumnHead의 수만큼
	String[] HyperLink		= {""}; //strColumnHead의 수만큼
	String RightButton[][]	= {{"off", "fn_Chart_View", rightbtnChartShow},{"off", "fn_Doc_Reg()", rightbtnDocSave},{"off", "file_real_name", rightbtnDocShow}};

	String GV_ORDERNO="", GV_ORDER_DETAIL_SEQ="" ,GV_LOTNO="" ;
	
	if(request.getParameter("order_no")== null)
		GV_ORDERNO="";
	else
		GV_ORDERNO = request.getParameter("order_no");

	if(request.getParameter("order_detail_seq")== null)
		GV_ORDER_DETAIL_SEQ="";
	else
		GV_ORDER_DETAIL_SEQ = request.getParameter("order_detail_seq");
	
	if(request.getParameter("lotno")== null)
		GV_LOTNO="";
	else
		GV_LOTNO = request.getParameter("lotno");
	
	String param =  GV_ORDERNO + "|" + GV_ORDER_DETAIL_SEQ  + "|" + GV_LOTNO + "|" + member_key + "|" ;
	
	JSONObject jArray = new JSONObject();
	jArray.put( "order_no", GV_ORDERNO);
	jArray.put( "order_detail_no", GV_ORDER_DETAIL_SEQ);
	jArray.put( "lotno", GV_LOTNO);
	jArray.put( "member_key", member_key);
	
    TableModel = new DoyosaeTableModel("M303S070100E124", strColumnHead, jArray);	
 	int RowCount =TableModel.getRowCount();
    
    makeTableHTML= new MakeTableHTML(TableModel);
    makeTableHTML.colCount		= strColumnHead.length;
    makeTableHTML.pageSize 		= RowCount;
    makeTableHTML.currentPageNum= startPageNo;
    makeTableHTML.htmlTable_ID	= "TableS303S070120";
    makeTableHTML.colOff		= colOff;
    makeTableHTML.TR_Style 		= TR_Style;
    makeTableHTML.TD_Style 		= TD_Style; 
    makeTableHTML.HyperLink 	= HyperLink;
    makeTableHTML.Check_Box 	= "true";
    makeTableHTML.RightButton	= RightButton;
    String zhtml=makeTableHTML.getHTML();
%>
    
<script>
	$(document).ready(function () {
		vTableS303S070120 = $('#<%=makeTableHTML.htmlTable_ID%>').DataTable({
			scrollX: true,
    		scrollY: 220,
    	    scrollCollapse: true,
    	    paging: false,
    	    searching: false,
    	    ordering: true,
    	    order: [[ 0, "asc" ]],
    	    info: true,         
            language: { 
                url:"<%=Config.this_SERVER_path%>/AdminLTE-3.0.5/localisation/Korean.json"
             }
		});
		
		TableS303S070120_RowCount = vTableS303S070120.rows().count();
		
		for(var i=0; i<TableS303S070120_RowCount; i++) { // 오른쪽테이블에 있는 왼쪽테이블 레코드제거
			var part_cd_120 = vTableS303S070120.cell( i, 2).data().trim();
			for(var j=0; j<TableS303S070130_RowCount; j++) {
				var part_cd_130 = vTableS303S070130.cell( j, 3).data().trim();
// 				alert("TableS303S070120_RowCount="+TableS303S070120_RowCount+"\n"+"part_cd_120="+part_cd_120+"\n"+"part_cd_130="+part_cd_130);
				if(part_cd_120==part_cd_130) {
// 					alert("part="+part_cd_120+"\n"+"레코드제거");
					vTableS303S070120.row(i).remove();
					TableS303S070120_RowCount = vTableS303S070120.page.info().recordsTotal; //행제거하면 rowcount 다시계산
					i--; //행제거하면 index-1
				}
			}
 		}
		
    	$('#<%=makeTableHTML.htmlTable_ID%> tbody').on( 'click', 'tr', function () {
    		S303S070120_Row_index = vTableS303S070120.row( this ).index();
	 		$(<%=makeTableHTML.htmlTable_ID%>_rowID).removeClass("hene-bg-color");
	 		vTableS303S070120.row(this).nodes().to$().attr("class","hene-bg-color");
	 		
// 	 		clear_input();

			vTableS303S070120.cell(S303S070120_Row_index,0).nodes().to$().find("input[id='checkbox1']").prop("checked", function(){
				if($(this).prop('checked'))
					$(this).prop("checked", false);
				else
					$(this).prop("checked", true);
		    });

	 		$('#txt_part_cd_rev').val(vTableS303S070120.cell(S303S070120_Row_index, 5).data());
			$('#txt_part_cd').val(vTableS303S070120.cell(S303S070120_Row_index, 2).data());
			$('#txt_part_nm').val(vTableS303S070120.cell(S303S070120_Row_index, 3).data());
			$('#txt_req_count').val(vTableS303S070120.cell(S303S070120_Row_index, 4).data());
			
			$('#btn_plus').html("입력");
			S303S070130_Row_index = -1;
			vTableS303S070130.rows().nodes().to$().attr("class", "hene-bg-color_w");
		} );
		        
		$('#<%=makeTableHTML.htmlTable_ID%> tbody').on( 'blur', 'tr', function () {
			vTableS303S070120.row(this).nodes().to$().attr("class", "hene-bg-color_w");
		} );
		
		$("#<%=makeTableHTML.htmlTable_ID%> input[id='checkbox1']").on("click",function(){
			if($(this).prop('checked'))
				$(this).prop("checked", false);
			else
				$(this).prop("checked", true);
    	});
		
		$("#<%=makeTableHTML.htmlTable_ID%>"+" "+"input[id='checkboxAll']").on("click", function(){
			var table_info = vTableS303S070120.page.info();
	        var table_rows = table_info.recordsTotal;
	    	for(var i=0;i<table_rows;i++){  
	    		vTableS303S070120.cell(i,0).nodes().to$().find("input[id='checkbox1']").prop("checked",this.checked);
	    	}
	    });  
	});

</script>

<%=zhtml%>

