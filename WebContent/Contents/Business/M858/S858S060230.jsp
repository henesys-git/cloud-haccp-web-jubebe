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

	String[] strColumnHead 	= { "주문번호","출고번호","출고일자","출고일련번호","출고시간",
								"입고담당자","제품명","제품코드","제품코드개정번호","창고번호",
								"렉번호","선반번호","칸번호","출고전","출고수량", "출고후","비고"};
	int[]   colOff 			= { 0,0,0,0,0,
								0,1,1,0,1,
								1,1,1,1,1,1,1 };//전체 넓이 번튼 3개:86%, 문서2개:90%, 문서뷰:94%, 챠트보기,문서등록91%; 고객사
	
	String[] TR_Style		= {"",""};
// 	String[] TR_Style		= {""," onclick='S202S020120Event(this)' "};
	String[] TD_Style		= {"align:center;font-weight: bold;"}; 
	String[] HyperLink		= {""}; 
	String RightButton[][]	= {{"off", "fn_Chart_View", rightbtnChartShow},{"off", "fn_Doc_Reg()", rightbtnDocSave},{"on", "fn_mius_body(this)", "삭제"}};
	
	String GV_PROD_CD="",GV_ORDER_NO="";
	
	if(request.getParameter("order_no")== null)
		GV_ORDER_NO="";
	else
		GV_ORDER_NO = request.getParameter("order_no");	
	
	if(request.getParameter("prod_cd")== null)
		GV_PROD_CD="";
	else
		GV_PROD_CD = request.getParameter("prod_cd");
	
	/* if(GV_CALLER.equals("S858S060230")){
		RightButton[2][0] = "off";
	};
	 */
	String param = GV_ORDER_NO + "|" + GV_PROD_CD + "|";
	 
	JSONObject jArray = new JSONObject();
	jArray.put( "member_key", member_key);
	jArray.put( "order_no", GV_ORDER_NO);
	jArray.put( "prod_cd", GV_PROD_CD);

		
    TableModel = new DoyosaeTableModel("M858S060100E244", strColumnHead, jArray);	
 	int RowCount =TableModel.getRowCount();	

 	CurrentPage jspPageName = new CurrentPage(request.getRequestURI());
 	String JSPpage = jspPageName.GetJSP_FileName();
 	
    makeTableHTML= new MakeTableHTML(TableModel);
    makeTableHTML.colCount		= strColumnHead.length;
    makeTableHTML.pageSize 		= RowCount;  //RowCount 1페이지로 구성,PageSize: PageSize의 사이즈로 구성 
    makeTableHTML.currentPageNum= 1;
    makeTableHTML.htmlTable_ID	= "TableS858S060230";
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
    	var columnDefs;
    	
		vTableS858S060230 = $('#<%=makeTableHTML.htmlTable_ID%>').DataTable({
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
// 	      		$(row).attr('onclick',"S202S010120Event(this)");
	      		$(row).attr('role',"row");
	  		},
	  		'columnDefs': [
        		{
    	       		'targets': [0,1,2,3,4,5,8],
    	       		'createdCell':  function (td) {
    	          			$(td).attr('style', 'width:0px; display: none;'); 
    	       		}
           		},
           		{
    	       		'targets': [17],
    	       		'createdCell':  function (td) {
              			$(td).attr('style', 'width:  7%; font-weight: 900; font-size:14px; text-align:center; vertical-align: middle');
    	          			$(td).html('<button style="width: auto; float: left; " type="button" onclick="fn_mius_body(this)" id="right_btn" class="btn-outline-success">삭제</button>'); 
    	       		}
    			}
           	],
           	language: { 
                url:"<%=Config.this_SERVER_path%>/AdminLTE-3.0.5/localisation/Korean.json"
             }
		});
		
		TableS858S060230_RowCount = vTableS858S060230.rows().count();
		  
			for(i=0;i<TableS858S060230_RowCount;i++) {  // q_proc_seq 최대값 구하기
				//alert(vTableS303S010230.cell(i, 13).data());
				if(ioSeq_Max < vTableS858S060230.cell(i, 2).data())
					ioSeq_Max = vTableS858S060230.cell(i, 2).data();
			}
			
			  for(var i=0; i<TableS858S060230_RowCount; i++){  // DB에서 조회된 레코드 삭제버튼제거
				var trInput = $($("#TableS858S060230_tbody tr")[i]).find(":button");
				//trInput.eq(0).prop("disabled", true);
				trInput.eq(0).remove();
	 		}  
		
		
		
	
		$('#<%=makeTableHTML.htmlTable_ID%> tbody').on( 'click', 'tr', function () {
			S858S060230_Row_index = vTableS858S060230
		        .row( this )
		        .index();
			
// 			$($("input[id='checkbox1']")[S202S010120_Row_index]).prop("checked", function(){
// 		        return !$(this).prop('checked');
// 		    });

	 		$(<%=makeTableHTML.htmlTable_ID%>_rowID).removeClass("hene-bg-color");
			vTableS858S060230.row(this)
		    .nodes()
		    .to$()
		    .attr("class","hene-bg-color");
// 			{,"입고번호","입고일자","입고일련번호","입고시간","입고담당자","제품명","제품코드","창고번호","렉번호","선반번호","칸번호","입고전재고량","입고수량","입고후재고"};
//			txt_prod_name,txt_prod_cd,txt_request_cnt,txt_store_no,txt_rakes_no,txt_plate_no,txt_colm_no
//			txt_pre_amt,txt_io_count,txt_post_stack
			$('#txt_ipgo_order').val(vTableS858S060230.cell(S858S060230_Row_index, 0).data());	//주문번호
			$('#txt_ipgo_no').val(vTableS858S060230.cell(S858S060230_Row_index, 1).data());		//2 입고번호
			$('#txt_ipgo_date').val(vTableS858S060230.cell(S858S060230_Row_index, 2).data());		//3 입고일자
			$('#txt_io_seqno').val(vTableS858S060230.cell(S858S060230_Row_index, 3).data());		//4 입고일련번호
			$('#txt_io_time').val(vTableS858S060230.cell(S858S060230_Row_index, 4).data());		//5 입고시간
			$('#txt_io_user_id').val(vTableS858S060230.cell(S858S060230_Row_index, 5).data());		//6 입고담당자
			$('#txt_prod_name').val(vTableS858S060230.cell(S858S060230_Row_index, 6).data());		//7제품명
			$('#txt_prod_cd').val(vTableS858S060230.cell(S858S060230_Row_index, 7).data());		//8 제품코드 
			$('#txt_prodcd_bunho').val(vTableS858S060230.cell(S858S060230_Row_index, 8).data());		//8 제품코드
			$('#txt_store_no').val(vTableS858S060230.cell(S858S060230_Row_index, 9).data());	//9 창고번호
			$('#txt_rakes_no').val(vTableS858S060230.cell(S858S060230_Row_index, 10).data());		//10 렉번호
			$('#txt_plate_no').val(vTableS858S060230.cell(S858S060230_Row_index, 11).data());		//11선반번호
			$('#txt_colm_no').val(vTableS858S060230.cell(S858S060230_Row_index, 12).data());		//12 칸번호
			$('#txt_pre_amt').val(vTableS858S060230.cell(S858S060230_Row_index, 13).data());		//13 입고 전 재고량
			$('#txt_io_count').val(vTableS858S060230.cell(S858S060230_Row_index, 14).data());		//14 입고 후 재고량
			$('#txt_post_stack').val(vTableS858S060230.cell(S858S060230_Row_index, 15).data());		//15 입출고 수량
			$('#txt_request_cnt').val(vTableS858S060230.cell(S858S060230_Row_index, 14).data());		//15 입출고 수량
			$('#txt_bigo').val(vTableS858S060230.cell(S858S060230_Row_index, 16).data());		//15 비고
			
			$('#btn_plus').html("수정");
			
		} );
		        

		$('#<%=makeTableHTML.htmlTable_ID%> tbody').on( 'blur', 'tr', function () {
			vTableS858S060230.row(this)
		    .nodes()
		    .to$()
		    .attr("class", "hene-bg-color_w");
		} );


	    $('#txt_seq').val( '<%=(RowCount+1)%>');
    });

    function S858S060230Event(obj){
    	var tr = $(obj);
		var td = tr.children();
		var trNum = $(obj).closest('tr').prevAll().length;//현재 클릭한 TR의 순서 return	
		
// 		$(<%=makeTableHTML.htmlTable_ID%>_rowID).attr("class", "");
// 		$(obj).attr("class", "hene-bg-color");

// 		$('#txt_seq').val(td.eq(0).text().trim());



    }        
</script>

    <%=zhtml%>  