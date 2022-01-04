<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page language="java"
	import="java.sql.*,java.util.*,javax.servlet.http.*"%>
<%@ page import="mes.client.comm.*"%>
<%@ page import="mes.client.guiComponents.*"%>
<%@ page import="mes.client.util.*"%>
<%@ page import="mes.client.conf.*"%>
<%@ page import="org.json.simple.*"%><%@ include file="/strings.jsp" %>
<%
	/* 
	제품(모델별) BOM 선택하는 화면
	 */
	DoyosaeTableModel TableModel;
	MakeTableHTML makeTableHTML;
	String loginID = session.getAttribute("login_id").toString();
	String member_key = session.getAttribute("member_key").toString();
	String[] strColumnHead = {"순번", "BOM번호", "개정번호", "BOM번호", "원부자재번호", "원부자재코드", "BOM명", "원부자재명", "part_cd_rev", "수량",
			"매수", "구분", "QAR", "검사장비", "포장자료", "수정", "cust_cd", "구매처", "cust_rev", "비고", "bom_cd", "bom_cd_rev",
			"BomName", "last_no", "type_no", "geukyongpoommok", "dept_code", "approval_date", "approval","modify_reason","revision_no"};
	int[] colOff = {1, 0, 0, 1, 0, 1, 1, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0,0,0};
	String[] TR_Style = {"", " onclick='S101S030940Event(this)' "};
	String[] TD_Style = {"align:center;font-weight: bold;"};
	String[] HyperLink = {""};
	String RightButton[][] = {{"off", "fn_Chart_View", rightbtnChartShow}, {"off", "fn_Doc_Reg()", rightbtnDocSave},
			{"off", "fn_mius_body(this)", "삭제"}};

	String GV_ORDER_NO = "", GV_ORDER_DETAIL_SEQ="", GV_LOTNO="";

	if (request.getParameter("OrderNo") == null)
		GV_ORDER_NO = "";
	else
		GV_ORDER_NO = request.getParameter("OrderNo");

	if (request.getParameter("OrderDetailNo") == null)
		GV_ORDER_DETAIL_SEQ = "";
	else
		GV_ORDER_DETAIL_SEQ = request.getParameter("OrderDetailNo");
	
	if(request.getParameter("lotno")== null)
		GV_LOTNO = "";
	else
		GV_LOTNO = request.getParameter("lotno");
	
	String param = GV_ORDER_NO + "|" + GV_ORDER_DETAIL_SEQ + "|" + GV_LOTNO + "|";
	
	JSONObject jArray = new JSONObject();
	jArray.put( "order_no", GV_ORDER_NO);
	jArray.put( "lotno", GV_LOTNO);
	jArray.put( "order_detail_seq", GV_ORDER_DETAIL_SEQ);
	jArray.put( "member_key", member_key);
	TableModel = new DoyosaeTableModel("M101S030100E944", strColumnHead, jArray);
	int RowCount = TableModel.getRowCount();

	CurrentPage jspPageName = new CurrentPage(request.getRequestURI());
	String JSPpage = jspPageName.GetJSP_FileName();

	makeTableHTML = new MakeTableHTML(TableModel);
	makeTableHTML.colCount = strColumnHead.length;
	makeTableHTML.pageSize = RowCount; //RowCount 1페이지로 구성,PageSize: PageSize의 사이즈로 구성 
	makeTableHTML.currentPageNum = 1;
	makeTableHTML.htmlTable_ID = "TableS101S030940";
	makeTableHTML.colOff = colOff;
	makeTableHTML.TR_Style = TR_Style;
	makeTableHTML.TD_Style = TD_Style;
	makeTableHTML.HyperLink = HyperLink;
	makeTableHTML.user_id = loginID;
	makeTableHTML.Check_Box = "false";
	makeTableHTML.RightButton = RightButton;
	makeTableHTML.jsp_page = JSPpage;
	String zhtml = makeTableHTML.getHTML();
%>

<script type="text/javascript">
	var Rowcount='<%=RowCount%>';
	$(document).ready(function () {
		vTableS101S030940 = $('#<%=makeTableHTML.htmlTable_ID%>').DataTable({
			scrollX: true,
		    scrollY: 380,
		    scrollCollapse: true,
		    paging: false,
		    lengthMenu: [[8,9,-1], [8,9,"All"]],
		    searching: false,
		    ordering: true,
		    order: [[ 0, "asc" ]],
		    keys: false,
		    info: true
		    ,
		    'createdRow': function(row) {	
	      		$(row).attr('id',"<%=makeTableHTML.htmlTable_ID%>_rowID");
	      		$(row).attr('onclick',"S101S030940Event(this)");
	      		$(row).attr('role',"row");
	  		},
	  		'columnDefs': [{
	       		'targets': [1,2,4,7,8,10,16,17,18,20,21,22,23,24,25,26,27,28,29,30],
	       		'createdCell':  function (td) {
	          			$(td).attr('style', 'width:0px; display: none;'); 
	       		}
			}
// 	  		,
// 			{
// 	       		'targets': [29],
// 	       		'createdCell':  function (td) {
//           			$(td).attr('style', 'width:  7%; font-weight: 900; font-size:14px; text-align:center; vertical-align: middle');
// 	          		$(td).html('<button style="width: auto; float: left; " type="button" id="right_btn" onclick="fn_inspect_result_delete(this)" class="btn-outline-success">삭제</button>'); 

// 	       		}
// 			}
	  		],         
            language: { 
                url:"<%=Config.this_SERVER_path%>/AdminLTE-3.0.5/localisation/Korean.json"
             }
		});
		
		TableS101S030940_info = vTableS101S030940.page.info();
     	TableS101S030940_Row_Count = TableS101S030940_info.recordsTotal;
	
		$('#<%=makeTableHTML.htmlTable_ID%> tbody').on( 'click', 'tr', function () {
			TableS101S030940_Row_Index = vTableS101S030940
		        .row( this )
		        .index();
			$('#btn_plus').html("수정");
		} );
		if(Rowcount > 0){
        	$('#txt_lastseq').val(Rowcount);		
			$('#txt_bom_cd').val(		vTableS101S030940.cell( 0, 20 ).data());	//4 bom_cd 
			$('#txt_bom_cd_rev').val(	vTableS101S030940.cell( 0, 21 ).data());	//5 bom_cd_rev
			$('#txt_bom_name').val(	vTableS101S030940.cell( 0, 22 ).data());	//6 bom_name
			$('#txt_type_code').val(	vTableS101S030940.cell( 0, 24 ).data());	//9 type_no 형식번호
			$('#txt_A_productname').val(vTableS101S030940.cell( 0, 25 ).data());	//10 geukyongpoommok 적용품목
// 			$('#txt_deptcode').val(	vTableS101S030940.cell( 0, 26 ).data());	//11 dept_code 부서코드
			$('#txt_deptcode').val(	vTableS101S030940.cell( 0, 27 ).data()).prop("selected",true);  //11 dept_code 부서코드
			$('#approval_date').val(	vTableS101S030940.cell( 0, 26 ).data());	//12 approval_date 승인일자
			$('#approval').val(		vTableS101S030940.cell( 0, 28 ).data());	//13 approval 승인
		}
	});


    
    function S101S030940Event(obj){
    	var tr = $(obj);
		var td = tr.children();
		var trNum = $(obj).closest('tr').prevAll().length;//현재 클릭한 TR의 순서 return	

		$(<%=makeTableHTML.htmlTable_ID%>_rowID).removeClass("hene-bg-color");
		$(obj).attr("class", "hene-bg-color");
		// 		$(obj).attr("class", "bg-danger");
		// 		$(obj).attr("class", "bg-success"); 

		$('#txt_seq').val(td.eq(0).text().trim());

		$('#txt_jaryo_bunho').val(td.eq(3).text().trim());
		$('#txt_bupum_bunho').val(td.eq(4).text().trim());
		$('#txt_part_cd').val(td.eq(5).text().trim());
		$('#txt_jaryo_irum').val(td.eq(6).text().trim());

		$('#txt_part_cd_rev').val(td.eq(8).text().trim());
		$('#txt_part_cnt').val(td.eq(9).text().trim());
		$('#txt_maesu').val(td.eq(10).text().trim());
		$('#txt_gubun').val(td.eq(11).text().trim());
		$('#txt_qar').val(td.eq(12).text().trim())
		$('#txt_inspectequep').val(td.eq(13).text().trim())
		$('#txt_package').val(td.eq(14).text().trim())
		$('#txt_modify').val(td.eq(15).text().trim());
		$('#txt_bom_custcode').val(td.eq(16).text().trim());
		$('#txt_bom_CustName').val(td.eq(17).text().trim());
		$('#txt_cust_rev').val(td.eq(18).text().trim());
		$('#txt_bigo').val(td.eq(19).text().trim());
		$('#txt_modify_reason').val(td.eq(29).text().trim());
		$('#txt_revision_no').val(td.eq(30).text().trim());

	}
</script>

<%=zhtml%>

