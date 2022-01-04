<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*,java.util.*,javax.servlet.http.*"%>
<%@ page import="org.json.simple.*"%><%@ include file="/strings.jsp" %>
<%@ page import="mes.client.comm.*" %>
<%@ page import="mes.client.guiComponents.*" %>
<%@ page import="mes.client.util.*" %>
<%@ page import="mes.client.conf.*" %>
<%
	DoyosaeTableModel TableModel, TableHead;
	MakeGridData makeGridData;
	String loginID = session.getAttribute("login_id").toString();
	String member_key = session.getAttribute("member_key").toString();
	String RightButton[][]	= {{"off", "fn_Chart_View", rightbtnChartShow},{"off", "fn_Doc_Reg()", rightbtnDocSave},{"off", "fn_mius_body(this)", "삭제"}};
	
	String GV_CALLER="",GV_ORDER_NO="",GV_IPGONO="",GV_PART_CD="",GV_PART_CD_REV="";
	
	if(request.getParameter("order_no")== null)
		GV_ORDER_NO="";
	else
		GV_ORDER_NO = request.getParameter("order_no");	
	
	if(request.getParameter("part_cd")== null)
		GV_PART_CD="";
	else
		GV_PART_CD = request.getParameter("part_cd");	
	
	if(request.getParameter("part_cd")== null)
		GV_PART_CD="";
	else
		GV_PART_CD = request.getParameter("part_cd");	
	
	if(request.getParameter("part_cd_rev")== null)
		GV_PART_CD_REV="";
	else
		GV_PART_CD_REV = request.getParameter("part_cd_rev");	
	
	
	
	if(request.getParameter("vIpgoNo")== null)
		GV_IPGONO="";
	else
		GV_IPGONO = request.getParameter("vIpgoNo");	
	
	if(request.getParameter("caller")== null)
		GV_CALLER="";
	else
		GV_CALLER = request.getParameter("caller");
	
	/* if(GV_CALLER.equals("S202S120130")){
		RightButton[2][0] = "off";
	};
	 */
	//String param = GV_ORDER_NO + "|" + GV_PART_CD + "|"+ GV_PART_CD_REV + "|";
	 
	JSONObject jArray = new JSONObject();
	jArray.put( "part_cd", GV_PART_CD);
	jArray.put( "member_key", member_key);
			
// 	TableHead.getValueAt(0,0).toString()
    TableModel = new DoyosaeTableModel("M202S120100E115", jArray);	//검수정보를 가져와야 함
 	int RowCount =TableModel.getRowCount();	

 	CurrentPage jspPageName = new CurrentPage(request.getRequestURI());
 	String JSPpage = jspPageName.GetJSP_FileName();
 	
 	makeGridData= new MakeGridData(TableModel);
 	makeGridData.RightButton	= RightButton;
    makeGridData.htmlTable_ID	= "tableS202S120115";
    
 	makeGridData.Check_Box 	= "false";
 	String[] HyperLink		= {""}; //strColumnHead의 수만큼
 	makeGridData.HyperLink 	= HyperLink;

%>
<script>
    $(document).ready(function () {
    	$('#<%=makeGridData.htmlTable_ID%>').DataTable({	    
    		scrollX: true,
    		scrollY: 180,
    	    scrollCollapse: true,
    	    paging: false,
    	    searching: false,
    	    ordering: true,
    	    order: [[ 4, "desc" ],[ 5, "desc" ]],
    	    info: false,
    	    data: <%=makeGridData.getDataArry()%>,
   	    	'createdRow': function(row) {	
   	      		$(row).attr('id',"<%=makeGridData.htmlTable_ID%>_rowID");
   	      		$(row).attr('onclick',"<%=makeGridData.htmlTable_ID%>Event(this)");
   	      		$(row).attr('role',"row");
   	  		}, 
    	    columnDefs: [{
    	    	'targets': [0,1,2,6,7,9,11,12,13,17],
	   			'createdCell':  function (td) {
	      			$(td).attr('style', 'display: none;'); 
	   			}
    	    },
   			// 조회컬럼크기
			{
	   			'targets': [19],
   				'createdCell':  function (td) {
						$(td).attr('style', 'display: none;'); //버튼 자리아래의 테이블 버튼자리와 같이 항상 처리한다.
				}
			}],
    	    language: { 
                url:"<%=Config.this_SERVER_path%>/AdminLTE-3.0.5/localisation/Korean.json"
             }
		});

    });
    
	function <%=makeGridData.htmlTable_ID%>Event(obj){
		var tr = $(obj);
		var td = tr.children();

		var trNum = $(obj).closest('tr').prevAll().length;//현재 클릭한 TR의 순서 return .bg-success

		/* $($("input[id='checkbox1']")[trNum]).prop("checked", function(){
	        return !$(this).prop('checked');
	    }); */

	
		$(<%=makeGridData.htmlTable_ID%>_rowID).attr("class", "");
		$(obj).attr("class", "hene-bg-color");
		
	  		vOrderNo 		= td.eq(0).text().trim();
	  		vLotNo			= td.eq(1).text().trim();
	  		vipgo_no		= td.eq(2).text().trim();
	  		vio_seqno		= td.eq(3).text().trim();	  		
// 			vPart_cd 		= td.eq(7).text().trim();
// 			vPart_name	 	= td.eq(8).text().trim();
// 			vPart_cd_rev 	= td.eq(9).text().trim();
			lvmachineno 		= td.eq(10).text().trim();
			lvrakes 			= td.eq(11).text().trim();
			lvplate 			= td.eq(12).text().trim();
			lvcolm 			= td.eq(13).text().trim();
			lvpre_amt 		= td.eq(14).text().trim();
			lvio_amt 		= td.eq(15).text().trim();
			lvpost_amt 		= td.eq(16).text().trim();

	}

    
</script>

<table class='table table-bordered nowrap table-hover' id="<%=makeGridData.htmlTable_ID%>" style="width: 100%">
		<thead>
			<tr>
			<th style='width:0px; display: none;'>주문번호</th>
			<th style='width:0px; display: none;'>Lot번호</th>
			<th style='width:0px; display: none;'>입고번호</th>
			<th>번호</th>
			<th>출고일자</th>
			<th>출고시간</th>
			<th style='width:0px; display: none;'>출고담당자</th>
			<th style='width:0px; display: none;'>원부자재코드</th>
			<th>원부자재명</th>
			<th style='width:0px; display: none;'>원부자재코드개정번호</th>
			<th>창고번호</th>
			<th style='width:0px; display: none;'>렉번호</th>
			<th style='width:0px; display: none;'>선반번호</th>
			<th style='width:0px; display: none;'>칸번호</th>
			<th>출고전재고량</th>
			<th>출고수량</th>
			<th>출고후재고</th>
			<th style='width:0px; display: none;'>구분</th>
			<th>비고</th>
			<th style='width:0px; display: none;'></th>
			</tr>
		</thead>
		<tbody id="<%=makeGridData.htmlTable_ID%>_body">		
		</tbody>
</table>   
<div id="UserList_pager" class="text-center">
</div>              