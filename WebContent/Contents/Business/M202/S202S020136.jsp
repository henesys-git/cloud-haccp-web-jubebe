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
	
	String[] strColumnHead 	= {"balju_no","순번","배합(BOM)명","배합(BOM)번호","원부자재코드","규격",  "발주수","검수수", "단가","금액", "Rev" ,"part_rev_no"};
	int[]   colOff 			= { 0,  1, 10, 0, 1,0,0,1,0,0,0,0};//전체 넓이 번튼 3개:86%, 문서2개:90%, 문서뷰:94%, 챠트보기,문서등록91%; 고객사

	String[] TR_Style		= {"",""};
// 	String[] TR_Style		= {""," onclick='S202S020136Event(this)' "};
	String[] TD_Style		= {"align:center;font-weight: bold;"}; 
	String[] HyperLink		= {""}; 
	String RightButton[][]	= {{"off", "fn_Chart_View", rightbtnChartShow},{"off", "fn_Doc_Reg()", rightbtnDocSave},{"off", "fn_mius_body(this)", "삭제"}};
	
	String GV_CALLER="",GV_ORDER_NO="",GV_BALJU_NO="";
	
	if(request.getParameter("order_no")== null)
		GV_ORDER_NO="";
	else
		GV_ORDER_NO = request.getParameter("order_no");	
	
	if(request.getParameter("balju_no")== null)
		GV_BALJU_NO="";
	else
		GV_BALJU_NO = request.getParameter("balju_no");	
	
	if(request.getParameter("caller")== null)
		GV_CALLER="";
	else
		GV_CALLER = request.getParameter("caller");	
	
	String param = GV_ORDER_NO + "|" + GV_BALJU_NO + "|" + member_key + "|";
	
	JSONObject jArray = new JSONObject();
	jArray.put( "order_no", GV_ORDER_NO);
	jArray.put( "baljuno", GV_BALJU_NO);
	jArray.put( "member_key", member_key);
		
//     TableModel = new DoyosaeTableModel("M202S020100E136", strColumnHead, param);
    TableModel = new DoyosaeTableModel("M202S020100E136", strColumnHead, jArray);
 	int RowCount =TableModel.getRowCount();	

 	CurrentPage jspPageName = new CurrentPage(request.getRequestURI());
 	String JSPpage = jspPageName.GetJSP_FileName();
 	
    makeTableHTML= new MakeTableHTML(TableModel);
    makeTableHTML.colCount		= strColumnHead.length;
    makeTableHTML.pageSize 		= RowCount;  //RowCount 1페이지로 구성,PageSize: PageSize의 사이즈로 구성 
    makeTableHTML.currentPageNum= 1;
    makeTableHTML.htmlTable_ID	= "TableS202S020136";
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
		vTableS202S020136 = $('#<%=makeTableHTML.htmlTable_ID%>').DataTable({
			scrollX: true,
		    scrollY: 340,
		    scrollCollapse: true,
		    paging: false,
		    lengthMenu: [[8,9,-1], [8,9,"All"]],
		    searching: false,
		    ordering: true,
		    order: [[ 1, "asc" ]],
		    keys: false,
		    info: true,
		    'createdRow': function(row) {	
	      		$(row).attr('id',"<%=makeTableHTML.htmlTable_ID%>_rowID");
// 	      		$(row).attr('onclick',"S202S020136Event(this)");
	      		$(row).attr('role',"row");
	  		},
	  		'columnDefs': [{
	       		'targets': [0,3,5,6,8,9,10,11],
	       		'createdCell':  function (td) {
	          			$(td).attr('style', 'width:0px; display: none;'); 
	       		}
       		}
       		],
       		language: { 
                url:"<%=Config.this_SERVER_path%>/AdminLTE-3.0.5/localisation/Korean.json"
             }
		});

	
		$('#<%=makeTableHTML.htmlTable_ID%> tbody').on( 'click', 'tr', function () {
			S202S020136_Row_index = vTableS202S020136
		        .row( this )
		        .index();
			
// 			$($("input[id='checkbox1']")[S202S020136_Row_index]).prop("checked", function(){
// 		        return !$(this).prop('checked');
// 		    });

	 		$(<%=makeTableHTML.htmlTable_ID%>_rowID).removeClass("hene-bg-color");
			vTableS202S020136.row(this)
		    .nodes()
		    .to$()
		    .attr("class","hene-bg-color");

			$('#txt_balju_no').val(vTableS202S020136.cell(S202S020136_Row_index, 0).data());	//0 순번
			$('#txt_balju_seq').val(vTableS202S020136.cell(S202S020136_Row_index, 1).data());	//0 순번
			$('#txt_bom_nm').val(vTableS202S020136.cell(S202S020136_Row_index, 2).data());	//2 자료이름
			$('#txt_bom_cd').val(vTableS202S020136.cell(S202S020136_Row_index, 3).data());	//3 자료번호
			$('#txt_part_cd').val(vTableS202S020136.cell(S202S020136_Row_index, 4).data());	//7 파트코드
			$('#txt_inspect_cnt').val(vTableS202S020136.cell(S202S020136_Row_index, 7).data());	//9 수량
			$('#txt_request_cnt').val(vTableS202S020136.cell(S202S020136_Row_index, 7).data());	//9 수량
			$('#txt_part_cd_rev').val(vTableS202S020136.cell(S202S020136_Row_index, 11).data());//3 txt_part_cd_rev
						
			$('#btn_plus').html("입력");
		} );
		        

		$('#<%=makeTableHTML.htmlTable_ID%> tbody').on( 'blur', 'tr', function () {
			vTableS202S020136.row(this)
		    .nodes()
		    .to$()
		    .attr("class", "hene-bg-color_w");
		} );

    });

//     function S202S020136Event(obj){
//     	var tr = $(obj);
// 		var td = tr.children();
// 		var trNum = $(obj).closest('tr').prevAll().length;//현재 클릭한 TR의 순서 return	
//     }        
</script>

    <%=zhtml%>  