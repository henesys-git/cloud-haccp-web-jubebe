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

	String[] strColumnHead 	= {"balju_no","순번","배합(BOM)명","배합(BOM)번호",
								"원부자재코드","규격",  "발주수","검수수", "단가",
								"금액", "Rev" ,"part_rev_no","주문번호","주문상세정보",
								"inspect_seq","lotno" };
	int[]   colOff 			= {0, 12, 13, 1,
								1,1,1,1,0,
								0,0,0,0,0,
								0,0 };//전체 넓이 번튼 3개:86%, 문서2개:90%, 문서뷰:94%, 챠트보기,문서등록91%; 고객사
	String[] TR_Style		= {"",""};
// 	String[] TR_Style		= {""," onclick='S202S020520Event(this)' "};
	String[] TD_Style		= {"align:center;font-weight: bold;"}; 
	String[] HyperLink		= {""}; 
	String RightButton[][]	= {{"off", "fn_Chart_View", rightbtnChartShow},{"off", "fn_Doc_Reg()", rightbtnDocSave},{"off", "fn_mius_body(this)", "삭제"}};
	
	String GV_CALLER="",GV_ORDER_NO="", GV_LOTNO="", GV_BALJU_NO="";
	
	if(request.getParameter("order_no")== null)
		GV_ORDER_NO="";
	else
		GV_ORDER_NO = request.getParameter("order_no");	
	
	if(request.getParameter("caller")== null)
		GV_CALLER="";
	else
		GV_CALLER = request.getParameter("caller");	

	if(request.getParameter("lotno")== null)
		GV_LOTNO="";
	else
		GV_LOTNO = request.getParameter("lotno");
	
	if(request.getParameter("balju_no")== null)
		GV_BALJU_NO="";
	else
		GV_BALJU_NO = request.getParameter("balju_no");
	
	
	String param = GV_ORDER_NO + "|" + GV_LOTNO + "|" + GV_BALJU_NO + "|" + member_key + "|" ;
	
	JSONObject jArray = new JSONObject();
	jArray.put( "order_no", GV_ORDER_NO);
	jArray.put( "lotno", GV_LOTNO);
	jArray.put( "baljuno", GV_BALJU_NO);
	jArray.put( "member_key", member_key);	
	
    TableModel = new DoyosaeTableModel("M202S020500E124", strColumnHead, jArray);
 	int RowCount =TableModel.getRowCount();	

 	CurrentPage jspPageName = new CurrentPage(request.getRequestURI());
 	String JSPpage = jspPageName.GetJSP_FileName();
 	
    makeTableHTML= new MakeTableHTML(TableModel);
    makeTableHTML.colCount		= strColumnHead.length;
    makeTableHTML.pageSize 		= RowCount;  //RowCount 1페이지로 구성,PageSize: PageSize의 사이즈로 구성 
    makeTableHTML.currentPageNum= 1;
    makeTableHTML.htmlTable_ID	= "TableS202S020520";
    makeTableHTML.colOff		= colOff;
    makeTableHTML.TR_Style 		= TR_Style;
    makeTableHTML.TD_Style 		= TD_Style; 
    makeTableHTML.HyperLink 	= HyperLink;makeTableHTML.user_id	= loginID;
    makeTableHTML.Check_Box 	= "false";
    makeTableHTML.RightButton	= RightButton; makeTableHTML.jsp_page	= JSPpage;
    String zhtml=makeTableHTML.getHTML();	
%>
<script>

    $(document).ready(function () {
    	
    	var customOpts = {
    			columnDefs : [
    				{
    		       		'targets': [0,8,9,10,11,12,13,14,15],
    		       		'createdCell':  function (td) {
    		          			$(td).attr('style', 'width:0px; display: none;'); 
    		       		}
    	       		},            
    	       		{
    		       		'targets': [1],
    		       		'createdCell':  function (td) {
    		          			$(td).attr('style', 'width:  8%; font-weight: 900; font-size:14px; text-align:center; vertical-align: middle'); 
    		       		}
    	       		},
    	       		{
    		       		'targets': [2],
    		       		'createdCell':  function (td) {
    		          			$(td).attr('style', 'width:  17%; font-weight: 900; font-size:14px; text-align:left; vertical-align: middle'); 
    		       		}
    	       		},
    	       		{
    		       		'targets': [3,4],
    		       		'createdCell':  function (td) {
    		          			$(td).attr('style', 'width:  14%; font-weight: 900; font-size:14px; text-align:left; vertical-align: middle'); 
    		       		}
    	       		},
    	       		{
    		       		'targets': [5],
    		       		'createdCell':  function (td) {
    		          			$(td).attr('style', 'width: 8%; font-weight: 900; font-size:14px; text-align:left; vertical-align: middle'); 
    		       		}
    	       		},

    	       		{
    		       		'targets': [6,7],
    		       		'createdCell':  function (td) {
    		          			$(td).attr('style', 'width:  9%; font-weight: 900; font-size:14px; text-align:center; vertical-align: middle'); 
    		       		}
    	       		}
    	       	]
    	}
    	
    	vTableS202S020520 = $('#<%=makeTableHTML.htmlTable_ID%>').DataTable(
    							mergeOptions(heneSubTableOpts, customOpts)
    						);

		$('#<%=makeTableHTML.htmlTable_ID%> tbody').on( 'click', 'tr', function () {
			S202S020520_Row_index = vTableS202S020520
	        .row( this )
	        .index();

	 		$(<%=makeTableHTML.htmlTable_ID%>_rowID).removeClass("hene-bg-color");
			vTableS202S020520.row(this)
		    .nodes()
		    .to$()
		    .attr("class","hene-bg-color");
		
			$('#txt_balju_no').val(vTableS202S020520.cell(S202S020520_Row_index, 0).data());		//1 BOM코드
			$('#txt_balju_seq').val(vTableS202S020520.cell(S202S020520_Row_index, 1).data());			//3 순번
			$('#txt_bom_nm').val(vTableS202S020520.cell(S202S020520_Row_index, 2).data());	//4 자료이름					
			$('#txt_bom_cd').val(vTableS202S020520.cell(S202S020520_Row_index, 3).data());	//5 자료번호
			$('#txt_part_cd').val(vTableS202S020520.cell(S202S020520_Row_index, 4).data());	//7 파트코드
			$('#txt_gyugeok').val(vTableS202S020520.cell(S202S020520_Row_index, 5).data());		//8 규격
			$('#txt_part_cnt').val(vTableS202S020520.cell(S202S020520_Row_index, 6).data());		//9 수량
			$('#txt_unit_price').val(vTableS202S020520.cell(S202S020520_Row_index, 7).data());	//0 단가
			$('#txt_part_amt').val(vTableS202S020520.cell(S202S020520_Row_index, 8).data());		//1 금액
			$('#txt_rev').val(vTableS202S020520.cell(S202S020520_Row_index, 10).data());			//2 구분
			$('#txt_part_cd_rev').val(vTableS202S020520.cell(S202S020520_Row_index, 11).data());			//2 구분
			$('#txt_order_no').val(vTableS202S020520.cell(S202S020520_Row_index, 12).data());			//2 구분
			$('#txt_order_detail_seq').val(vTableS202S020520.cell(S202S020520_Row_index, 13).data());			//2 구분
			$('#txt_inspect_seq').val(vTableS202S020520.cell(S202S020520_Row_index, 14).data());			//2 구분
			$('#txt_lotno').val(vTableS202S020520.cell(S202S020520_Row_index, 15).data());			//2 구분
			
			$('#btn_plus').html("입력");
		});
		        
		$('#<%=makeTableHTML.htmlTable_ID%> tbody').on( 'blur', 'tr', function () {
			vTableS202S020520.row(this)
		    .nodes()
		    .to$()
		    .attr("class", "hene-bg-color_w");
		});

	    $('#txt_seq').val( '<%=(RowCount+1)%>');
    });

    function <%=makeTableHTML.htmlTable_ID%>Event(obj){
      	var tr = $(obj);
		var td = tr.children();
		var trNum = $(obj).closest('tr').prevAll().length;//현재 클릭한 TR의 순서 return	
		
// 		$(<%=makeTableHTML.htmlTable_ID%>_rowID).attr("class", "");
// 		$(obj).attr("class", "hene-bg-color");

// 		$('#txt_seq').val(td.eq(0).text().trim());

    }
</script>

<%=zhtml%>  