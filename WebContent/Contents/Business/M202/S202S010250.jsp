<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*,java.util.*,javax.servlet.http.*"%>
<%@ page import="mes.client.comm.*" %>
<%@ page import="mes.client.guiComponents.*" %>
<%@ page import="mes.client.util.*" %>
<%@ page import="mes.client.conf.*" %>
<%@ page import="org.json.simple.*"%><%@ include file="/strings.jsp" %>
<%
	DoyosaeTableModel TableModel;
	MakeTableHTML makeTableHTML;String loginID = session.getAttribute("login_id").toString();
	String member_key = session.getAttribute("member_key").toString();
	String[] strColumnHead 	= { "주문번호","발주번호", "순번", "품명",  "BOM번호",
								"원부자재코드","규격", "수량", "단가",
								"금액","Rev","part_cd_rev"};
	int[]   colOff 			= { 0,  0, 10, 12, 0, 
								0,1,1,1,
								1,0,0};//전체 넓이 번튼 3개:86%, 문서2개:90%, 문서뷰:94%, 챠트보기,문서등록91%; 고객사

	String[] TR_Style		= {"",""};
// 	String[] TR_Style		= {""," onclick='S202S010240Event(this)' "};
	String[] TD_Style		= {"align:center;font-weight: bold;"}; 
	String[] HyperLink		= {""}; 
	String RightButton[][]	= {{"off", "fn_Chart_View", rightbtnChartShow},{"off", "fn_Doc_Reg()", rightbtnDocSave},{"on", "fn_mius_body(this)", "삭제"}};
	
	String GV_ORDERNO="",GV_BALJUNO="",GV_CALLER="";
	
	if(request.getParameter("caller")== null)
		GV_CALLER = "";
	else
		GV_CALLER = request.getParameter("caller");	
	
	if(GV_CALLER.equals("S202S010202")) RightButton[2][0] = "off";
	
	if(request.getParameter("order_no")== null)
		GV_ORDERNO="";
	else
		GV_ORDERNO = request.getParameter("order_no");	
	
	if(request.getParameter("balju_no")== null)
		GV_BALJUNO = "";
	else
		GV_BALJUNO = request.getParameter("balju_no");	
	
	String param = GV_ORDERNO + "|" + GV_BALJUNO + "|";
	
	JSONObject jArray = new JSONObject();
	jArray.put( "order_no", GV_ORDERNO);
	jArray.put( "baljuno", GV_BALJUNO);
	jArray.put( "member_key", member_key);	
//     TableModel = new DoyosaeTableModel("M202S010100E244", strColumnHead, param);
    TableModel = new DoyosaeTableModel("M202S010100E244", strColumnHead, jArray);
 	int RowCount =TableModel.getRowCount();	

 	CurrentPage jspPageName = new CurrentPage(request.getRequestURI());
 	String JSPpage = jspPageName.GetJSP_FileName();
 	
    makeTableHTML= new MakeTableHTML(TableModel);
    makeTableHTML.colCount		= strColumnHead.length;
    makeTableHTML.pageSize 		= RowCount;  //RowCount 1페이지로 구성,PageSize: PageSize의 사이즈로 구성 
    makeTableHTML.currentPageNum= 1;
    makeTableHTML.htmlTable_ID	= "TableS202S010250";
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
		
    	setTimeout(function(){
    	
    	var vColumnDefs;
    	
		if("<%=GV_CALLER%>" == "S202S010202") {
			vColumnDefs = [ {
	       		'targets': [0,1,4,5,10,11],
	       		'createdCell':  function (td) {
	          			$(td).attr('style', 'width:0px; display: none;'); 
	       		},
	  		} ];
		} else {
			vColumnDefs = [ {
	       		'targets': [0,1,4,5,10,11],
	       		'createdCell':  function (td) {
	          			$(td).attr('style', 'width:0px; display: none;'); 
	       		},
	  		},
       		{
	       		'targets': [12],
	       		'createdCell':  function (td) {
          			$(td).attr('style', 'width:  7%; font-weight: 900; font-size:14px; text-align:center; vertical-align: middle');
	          			$(td).html('<button style="width: auto; float: left; " type="button" onclick="fn_mius_body(this)" id="right_btn" class="btn-outline-success">삭제</button>'); 
	       		}
			} ];
		}
    	
		vTableS202S010250 = $('#<%=makeTableHTML.htmlTable_ID%>').removeAttr('width').DataTable({
			scrollX: true,
		    scrollY: 380,
		    scrollCollapse: true,
		    paging: false,
		    lengthMenu: [[8,9,-1], [8,9,"All"]],
		    searching: false,
		    ordering: true,
		    order: [[ 2, "asc" ]],
		    keys: false,
		    info: false,
		    'createdRow': function(row) {	
	      		$(row).attr('id',"<%=makeTableHTML.htmlTable_ID%>_rowID");
// 	      		$(row).attr('onclick',"S202S010240Event(this)");
	      		$(row).attr('role',"row");
	  		},
	  		'columnDefs': vColumnDefs,
			language: { 
	               url:"<%=Config.this_SERVER_path%>/AdminLTE-3.0.5/localisation/Korean.json"
	            }
		 
		    });
    	 
    	},400);
	
		$('#<%=makeTableHTML.htmlTable_ID%> tbody').on( 'click', 'tr', function () {
			S202S010250_Row_index = vTableS202S010250
		        .row( this )
		        .index();
			

	 		$(<%=makeTableHTML.htmlTable_ID%>_rowID).removeClass("hene-bg-color");
			vTableS202S010250.row(this)
		    .nodes()
		    .to$()
		    .attr("class","hene-bg-color");
			
			$('#txt_order_no').val(vTableS202S010250.cell(S202S010250_Row_index, 0).data());		//0  주문번호
			$('#txt_balju_no').val(vTableS202S010250.cell(S202S010250_Row_index, 1).data());		//1 발주번호
			$('#txt_seq').val(vTableS202S010250.cell(S202S010250_Row_index, 2).data());	//2 순번
			$('#txt_bom_nm').val(vTableS202S010250.cell(S202S010250_Row_index, 3).data());			//3 자료명
			$('#txt_bom_cd').val(vTableS202S010250.cell(S202S010250_Row_index, 4).data());	//4 자료번호			
			$('#txt_part_cd').val(vTableS202S010250.cell(S202S010250_Row_index, 5).data());	//6 파트코드
			$('#txt_gyugeok').val(vTableS202S010250.cell(S202S010250_Row_index, 6).data());	//7 규격
			$('#txt_part_cnt').val(vTableS202S010250.cell(S202S010250_Row_index, 7).data());		//8 수량
			$('#txt_unit_price').val(vTableS202S010250.cell(S202S010250_Row_index, 8).data());		//9 단가
			$('#txt_part_amt').val(vTableS202S010250.cell(S202S010250_Row_index, 9).data());	//0 금액
			$('#txt_rev').val(vTableS202S010250.cell(S202S010250_Row_index, 10).data());		//1 rev
			$('#txt_part_cd_rev').val(vTableS202S010250.cell(S202S010250_Row_index, 11).data());			//2 part_cd_revㄴ
			
			
			$('#btn_plus').html("수정");
		} );
		        

		$('#<%=makeTableHTML.htmlTable_ID%> tbody').on( 'blur', 'tr', function () {
			vTableS202S010250.row(this)
		    .nodes()
		    .to$()
		    .attr("class", "hene-bg-color_w");
		} );


	    $('#txt_seq').val( '<%=(RowCount+1)%>');
    });

    function S202S010250Event(obj){
    	var tr = $(obj);
		var td = tr.children();
		var trNum = $(obj).closest('tr').prevAll().length;//현재 클릭한 TR의 순서 return	
		
// 		$(<%=makeTableHTML.htmlTable_ID%>_rowID).attr("class", "");
// 		$(obj).attr("class", "hene-bg-color");

// 		$('#txt_seq').val(td.eq(0).text().trim());



    }        
</script>

    <%=zhtml%>  