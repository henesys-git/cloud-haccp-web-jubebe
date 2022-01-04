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

	String[] strColumnHead 	= {"주문번호","주문상세번호","순번","자료번호","자료명","원부자재명","파트코드","원부자재코드","파트코드개정번호","수입검사요청수","수입검사수량","불량수","작성일자","합격여부","입고전재고","입고번호"};
	int[]   colOff 			= {0,0,0,0,0,1,0,1,0,0,1,0,0,0,0,0};//전체 넓이 번튼 3개:86%, 문서2개:90%, 문서뷰:94%, 챠트보기,문서등록91%; 고객사

	String[] TR_Style		= {"",""};
// 	String[] TR_Style		= {""," onclick='S202S020120Event(this)' "};
	String[] TD_Style		= {"align:center;font-weight: bold;"}; 
	String[] HyperLink		= {""}; 
	String RightButton[][]	= {{"off", "fn_Chart_View", rightbtnChartShow},{"off", "fn_Doc_Reg()", rightbtnDocSave},{"off", "fn_mius_body(this)", "삭제"}};
	
	String GV_CALLER="",GV_ORDER_NO="",GV_IPGONO="",GV_PART_CD="";
	
	if(request.getParameter("order_no")== null)
		GV_ORDER_NO="";
	else
		GV_ORDER_NO = request.getParameter("order_no");	
	
	if(request.getParameter("vPartCd")== null)
		GV_PART_CD="";
	else
		GV_PART_CD = request.getParameter("vPartCd");	
	
	if(request.getParameter("vIpgoNo")== null)
		GV_IPGONO="";
	else
		GV_IPGONO = request.getParameter("vIpgoNo");	
	
	
	if(request.getParameter("caller")== null)
		GV_CALLER="";
	else
		GV_CALLER = request.getParameter("caller");	
	
	String param = GV_ORDER_NO + "|" + GV_IPGONO + "|" + GV_PART_CD + "|";
	
	JSONObject jArray = new JSONObject();
	jArray.put( "order_no", GV_ORDER_NO);
	jArray.put( "ipgono", GV_IPGONO);
	jArray.put( "part_cd", GV_PART_CD);
	jArray.put( "member_key", member_key);
		
//     TableModel = new DoyosaeTableModel("M202S030100E164", strColumnHead, param);
    TableModel = new DoyosaeTableModel("M202S030100E164", strColumnHead, jArray);
 	int RowCount =TableModel.getRowCount();	
    makeTableHTML= new MakeTableHTML(TableModel);
    makeTableHTML.colCount		= strColumnHead.length;
    makeTableHTML.pageSize 		= RowCount;  //RowCount 1페이지로 구성,PageSize: PageSize의 사이즈로 구성 
    makeTableHTML.currentPageNum= 1;
    makeTableHTML.htmlTable_ID	= "TableS202S030150";
    makeTableHTML.colOff		= colOff;
    makeTableHTML.TR_Style 		= TR_Style;
    makeTableHTML.TD_Style 		= TD_Style; 
    makeTableHTML.HyperLink 	= HyperLink;
    makeTableHTML.Check_Box 	= "false";
    makeTableHTML.RightButton	= RightButton;
    String zhtml=makeTableHTML.getHTML();	
%>
<script>
    $(document).ready(function () {
		
		vTableS202S030150 = $('#<%=makeTableHTML.htmlTable_ID%>').DataTable({
			scrollX: true,
		    scrollY: 340,
		    scrollCollapse: true,
		    paging: false,
// 		    lengthMenu: [[8,9,-1], [8,9,"All"]],
		    searching: false,
		    ordering: false,
		    order: [[ 1, "asc" ]],
		    keys: false,
		    info: false,
		    'createdRow': function(row) {	
	      		$(row).attr('id',"<%=makeTableHTML.htmlTable_ID%>_rowID");
// 	      		$(row).attr('onclick',"S202S010120Event(this)");
	      		$(row).attr('role',"row");
	  		},
	  		'columnDefs': [{
	       		'targets': [0,1,2,3,4,6,8,11,12,13,14,15],
	       		'createdCell':  function (td) {
	          			$(td).attr('style', 'width:0px; display: none;'); 
	       		}
			}],
			language: { 
	               url:"<%=Config.this_SERVER_path%>/AdminLTE-3.0.5/localisation/Korean.json"
	            }
		});

	
		$('#<%=makeTableHTML.htmlTable_ID%> tbody').on( 'click', 'tr', function () {
			S202S030150_Row_index = vTableS202S030150
		        .row( this )
		        .index();
			//인풋 클리어 해주고 값 다시 넣어주기 밥먹고와서 해야함.
			
// 			$($("input[id='checkbox1']")[S202S010120_Row_index]).prop("checked", function(){
// 		        return !$(this).prop('checked');
// 		    });

	 		$(<%=makeTableHTML.htmlTable_ID%>_rowID).removeClass("hene-bg-color");
			vTableS202S030150.row(this)
		    .nodes()
		    .to$()
		    .attr("class","hene-bg-color");
			clear_input();
// 			{"주문번호","주문상세번호","자료번호","자료명","원부자재코드","파트코드","원부자재명","파트코드개정번호","수입검사요청수","수입검사수량","불량수","작성일자","합격여부"};
			$('#txt_order_no').val(vTableS202S030150.cell(S202S030150_Row_index, 0).data());		//1 주문번호
			$('#txt_order_seq').val(vTableS202S030150.cell(S202S030150_Row_index, 1).data());		//2 주문상세번호
			$('#txt_balju_seq').val(vTableS202S030150.cell(S202S030150_Row_index, 2).data());		//15 순번
			$('#txt_jaryo_bunho').val(vTableS202S030150.cell(S202S030150_Row_index, 3).data());		//3 자료번호
			$('#txt_jaryo_irum').val(vTableS202S030150.cell(S202S030150_Row_index, 4).data());		//4 자료명
			$('#txt_part_name').val(vTableS202S030150.cell(S202S030150_Row_index, 5).data());		//7 원부자재명
			$('#txt_part_cd').val(vTableS202S030150.cell(S202S030150_Row_index, 6).data());		//6 파트코드
			$('#txt_bupum_bunho').val(vTableS202S030150.cell(S202S030150_Row_index, 7).data());		//5 원부자재코드
			$('#txt_partcd_bunho').val(vTableS202S030150.cell(S202S030150_Row_index, 8).data());	//8 파트코드개정번호
			$('#txt_request_cnt').val(vTableS202S030150.cell(S202S030150_Row_index, 9).data());		//9 수입검사요청수
			$('#txt_inspect_cnt').val(vTableS202S030150.cell(S202S030150_Row_index, 10).data());		//10 수입검사수량
			$('#txt_error_cnt').val(vTableS202S030150.cell(S202S030150_Row_index, 11).data());		//11 불량수
			$('#txt_write_date').val(vTableS202S030150.cell(S202S030150_Row_index, 12).data());		//12 작성일자
			$('#txt_pass_yn').val(vTableS202S030150.cell(S202S030150_Row_index, 13).data());		//13 합격여부
			$('#txt_pre_amt').val(vTableS202S030150.cell(S202S030150_Row_index, 14).data());		//14 입고전재고
			$('#txt_ipgo_no').val(vTableS202S030150.cell(S202S030150_Row_index, 15).data());		//14 입고번호
		} );
		        

		$('#<%=makeTableHTML.htmlTable_ID%> tbody').on( 'blur', 'tr', function () {
			vTableS202S030150.row(this)
		    .nodes()
		    .to$()
		    .attr("class", "hene-bg-color_w");
		} );


	    $('#txt_seq').val( '<%=(RowCount+1)%>');
    });

    function S202S030150Event(obj){
    	var tr = $(obj);
		var td = tr.children();
		var trNum = $(obj).closest('tr').prevAll().length;//현재 클릭한 TR의 순서 return	
		
// 		$(<%=makeTableHTML.htmlTable_ID%>_rowID).attr("class", "");
// 		$(obj).attr("class", "hene-bg-color");

// 		$('#txt_seq').val(td.eq(0).text().trim());
		
		vOrderNo 			= td.eq(0).text().trim();
 		vIpgoNo				= td.eq(1).text().trim();
 		//vPartCd				= td.eq(1).text().trim();

    }        
</script>

    <%=zhtml%>  