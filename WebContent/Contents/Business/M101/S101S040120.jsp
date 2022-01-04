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
	int startPageNo = 1;//Integer.parseInt(request.getParameter("CurrentPageNumber").toString().trim());
	final int PageSize=15; 

    String zhtml="";
    String[] strColumnHead 	= { "순서",
//     							"제품번호",
								"일련번호",
    							"품명","단위","수량","단가","금액","비고",
    							"chuha_dt","cust_pono","cust_cd","cust_nm","boss_name","address" };
	int[] colOff 			= { 1, 1, 1, 1, 1, 1, 1, 1,
								0, 0, 0, 0, 0, 0 };
	String[] TR_Style		= {""," onclick='S101S040120Event(this)' "};
	String[] TD_Style		= {"align:center;font-weight: bold;"}; 
	String[] HyperLink		= {""}; 
	String RightButton[][]	= {{"off", "fn_Chart_View", rightbtnChartShow},{"off", "fn_Doc_Reg()", rightbtnDocSave},{"OFF", "file_view_name", "문서View"}};
	
	String GV_ORDERNO="",GV_CHULHANO="",GV_LOTNO="",GV_PROD_CD="",GV_PROD_REV="";
	
	if(request.getParameter("OrderNo")== null)
		GV_ORDERNO="";
	else
		GV_ORDERNO = request.getParameter("OrderNo");
	
	if(request.getParameter("ChulhaNo")== null)
		GV_CHULHANO="";
	else
		GV_CHULHANO = request.getParameter("ChulhaNo");
	
	if(request.getParameter("LotNo")== null)
		GV_LOTNO="";
	else
		GV_LOTNO = request.getParameter("LotNo");
	
	if(request.getParameter("prod_cd")== null)
		GV_PROD_CD="";
	else
		GV_PROD_CD = request.getParameter("prod_cd");
	
	if(request.getParameter("prod_rev")== null)
		GV_PROD_REV="";
	else
		GV_PROD_REV = request.getParameter("prod_rev");
	
	String param =  GV_ORDERNO + "|" + GV_CHULHANO + "|" + GV_LOTNO + "|"  ;
	
	JSONObject jArray = new JSONObject();
	jArray.put( "order_no", GV_ORDERNO);
	jArray.put( "lotno", GV_LOTNO);
	jArray.put( "prod_cd", GV_PROD_CD);
	jArray.put( "prod_rev", GV_PROD_REV);
	jArray.put( "chulhano", GV_CHULHANO);
	jArray.put( "member_key", member_key);
    TableModel = new DoyosaeTableModel("M101S040100E124", strColumnHead, jArray);	
    
 	int RowCount =TableModel.getRowCount();


 	CurrentPage jspPageName = new CurrentPage(request.getRequestURI());
 	String JSPpage = jspPageName.GetJSP_FileName();
 	
    makeTableHTML= new MakeTableHTML(TableModel);
    makeTableHTML.colCount		= strColumnHead.length;
    makeTableHTML.pageSize 		= RowCount;  //RowCount 1페이지로 구성,PageSize: PageSize의 사이즈로 구성
    makeTableHTML.currentPageNum= startPageNo;
    makeTableHTML.htmlTable_ID	= "TableS101S040120";
    makeTableHTML.colOff		= colOff;
    makeTableHTML.TR_Style 		= TR_Style;
    makeTableHTML.TD_Style 		= TD_Style; 
    makeTableHTML.HyperLink 	= HyperLink;makeTableHTML.user_id	= loginID;
    makeTableHTML.Check_Box 	= "false";
    makeTableHTML.RightButton	= RightButton; makeTableHTML.jsp_page	= JSPpage;	
	
//     if(RowCount>0){
    	zhtml = makeTableHTML.getHTML();
//     }
    
    // tbm_our_company_info 데이터 불러오기
    String[] strColumnHeadE125 	= { "bizno","revision_no","cust_nm","address","telno","boss_name","uptae","jongmok","faxno","homepage","zipno",
    								"start_date","create_date","create_user_id","modify_date","modify_user_id","modify_reason","duration_date","seal_img_filename", "history_yn" };
    JSONObject jArrayE125 = new JSONObject();
    jArrayE125.put( "member_key", member_key);
    DoyosaeTableModel TableModelE125 = new DoyosaeTableModel("M101S040100E125", strColumnHeadE125, jArrayE125);
    int RowCountE125 =TableModelE125.getRowCount();
%>
<script type="text/javascript">
    $(document).ready(function () {
//     	vTableS101S040120 = $('#TableS101S040120').DataTable({	    	    
//     		scrollY: 300,
//     	    scrollCollapse: true,
//     	    paging: false,
//     	    searching: false,
//     	    ordering: false,
//     	    order: [[ 0, "desc" ]],
//     	    info: false,
// 			'columnDefs': [
// 				{"width":" 8%","targets": 0},
// 				{"width":"20%","targets": 1},
// 				{"width":"20%","targets": 2},
// 				{"width":" 8%","targets": 3},
// 				{"width":" 8%","targets": 4},
// 				{"width":" 8%","targets": 5},
// 				{"width":" 8%","targets": 6},
// 				{"width":"20%","targets": 7},
//     		]
//         });   
        
//     	$('#txt_chuha_dt').val(vTableS101S040120.cell(0, 8).data()); 
// 		$('#txt_cust_pono').val(vTableS101S040120.cell(0, 9).data());
// 		$('#txt_cust_cd').val(vTableS101S040120.cell(0, 10).data());
// 		$('#txt_cust_nm').val(vTableS101S040120.cell(0, 11).data());
// 		$('#txt_boss_name').val(vTableS101S040120.cell(0, 12).data());
// 		$('#txt_address').val(vTableS101S040120.cell(0, 13).data());
<%-- 		$('#txt_our_bizno').val("<%=TableModelE125.getValueAt(0,0).toString().trim()%>"); --%>
<%-- 		$('#txt_our_cust_nm').val("<%=TableModelE125.getValueAt(0,2).toString().trim()%>"); --%>
<%-- 		$('#txt_our_boss_name').val("<%=TableModelE125.getValueAt(0,5).toString().trim()%>"); --%>
<%-- 		$('#txt_our_address').val("<%=TableModelE125.getValueAt(0,3).toString().trim()%>"); --%>
		
		<%if(RowCount>0) {%>
		$('#txt_chuha_dt').text("<%=TableModel.getValueAt(0,8).toString().trim()%>"); 
		$('#txt_cust_pono').text("<%=TableModel.getValueAt(0,9).toString().trim()%>");
		$('#txt_cust_cd').text("<%=TableModel.getValueAt(0,10).toString().trim()%>");
		$('#txt_cust_nm').text("<%=TableModel.getValueAt(0,11).toString().trim()%>");
		$('#txt_boss_name').text("<%=TableModel.getValueAt(0,12).toString().trim()%>");
		$('#txt_address').text("<%=TableModel.getValueAt(0,13).toString().trim()%>");
		<%}%>
		<%if(RowCountE125>0) {%>
		$('#txt_our_bizno').text("<%=TableModelE125.getValueAt(0,0).toString().trim()%>");
		$('#txt_our_cust_nm').text("<%=TableModelE125.getValueAt(0,2).toString().trim()%>");
		$('#txt_our_boss_name').text("<%=TableModelE125.getValueAt(0,5).toString().trim()%>");
		$('#txt_our_address').text("<%=TableModelE125.getValueAt(0,3).toString().trim()%>");
		
		var imageFileName = "<%=TableModelE125.getValueAt(0,18).toString().trim()%>";
		if(imageFileName!=null && imageFileName!="") {
			$("#SealImageFile").attr("src", "<%=Config.this_SERVER_path%>/images/Company/" 
					+ imageFileName + "?v=" + Math.random());
		}
		<%}%>
    });
    
    function S101S040120Event(obj){
//     	var tr = $(obj);
// 		var td = tr.children();
// 		var trNum = $(obj).closest('tr').prevAll().length;//현재 클릭한 TR의 순서 return
    }

</script>

<div id="TradingTable">
	<table class="table table-bordered" style="width: 100%; margin: 0 auto; align:center; border:1px solid black !important;">
		<tr>
			<td style="font-weight: 900; font-size:20px; vertical-align: middle; text-align:center; border:1px solid black !important;" colspan="10">거래명세표</td>
		</tr>
		<tr>
			<td colspan="2" style="font-weight: 900; font-size:14px; vertical-align: middle; text-align:center; border:1px solid black !important;">납품일자</td>
			<td colspan="3" style="font-size:14px; vertical-align: middle ;text-align:left; border:1px solid black !important;" id="txt_chuha_dt">
<!-- 				<input type="text" class="form-control" maxlength="50" id="txt_chuha_dt"  readonly></input> -->
			</td>
			<td colspan="2" style="font-weight: 900; font-size:14px; vertical-align: middle; text-align:center; border:1px solid black !important;">발주서 번호</td>
			<td colspan="3" style="font-size:14px; vertical-align: middle ;text-align:left; border:1px solid black !important;" id="txt_cust_pono">
<!-- 				<input type="text" class="form-control" maxlength="50" id="txt_cust_pono"  readonly></input> -->
			</td>
		</tr>
		<tr>
			<td colspan="10" style="font-weight: 900; font-size:14px; vertical-align: middle; text-align:center; border:1px solid black !important;"></td>
		</tr>
		<tr>
			<td rowspan="3" style="font-weight: 900; font-size:14px; vertical-align: middle; text-align:center; border:1px solid black !important;">
				공<br><br>급<br><br>자
			</td>
			<td style="font-weight: 900; font-size:14px; vertical-align: middle; text-align:center; border:1px solid black !important;">등록<br>번호</td>
			<td colspan="3" style="font-size:14px; vertical-align: middle; text-align:left; border:1px solid black !important;" id="txt_our_bizno">
<!-- 				<input type="text" class="form-control" maxlength="50" id="txt_our_bizno"  readonly></input> -->
			</td>
			<td rowspan="3" style="font-weight: 900; font-size:14px; vertical-align: middle; text-align:center; border:1px solid black !important;">
				공<br>급<br>받<br>는<br>자
			</td>
			<td style="font-weight: 900; font-size:14px; vertical-align: middle; text-align:center; border:1px solid black !important;">등록<br>번호</td>
			<td colspan="3" style="font-size:14px; vertical-align: middle; text-align:left; border:1px solid black !important;" id="txt_cust_cd">
<!-- 				<input type="text" class="form-control" maxlength="50" id="txt_cust_cd"  readonly></input> -->
			</td>
		</tr>
		<tr>
			<td style="width: 8%; font-weight: 900; font-size:14px; vertical-align: middle; text-align:center; border:1px solid black !important;">상 호<br>(법인명)</td>
			<td style="width: 13%; font-size:14px; vertical-align: middle; text-align:left; border:1px solid black !important;" id="txt_our_cust_nm">
<!-- 				<input type="text" class="form-control" maxlength="50" id="txt_our_cust_nm"  readonly></input> -->
			</td>
			<td style="width: 8%; font-weight: 900; font-size:14px; vertical-align: middle; text-align:center; border:1px solid black !important;">성 명</td>
			<td style="width: 13%; font-size:14px; vertical-align: middle; text-align:left; border:1px solid black !important;" id="txt_our_boss_name">
<!-- 				<input type="text" class="form-control" maxlength="50" id="txt_our_boss_name"  readonly></input> -->
			</td>
			<td style="width: 8%; font-weight: 900; font-size:14px; vertical-align: middle; text-align:center; border:1px solid black !important;">상 호<br>(법인명)</td>
			<td style="width: 13%; font-size:14px; vertical-align: middle; text-align:left; border:1px solid black !important;" id="txt_cust_nm">
<!-- 				<input type="text" class="form-control" maxlength="50" id="txt_cust_nm"  readonly></input> -->
			</td>
			<td style="width: 8%; font-weight: 900; font-size:14px; vertical-align: middle; text-align:center; border:1px solid black !important;">성 명</td>
			<td style="width: 13%; font-size:14px; vertical-align: middle; text-align:left; border:1px solid black !important;" id="txt_boss_name">
<!-- 				<input type="text" class="form-control" maxlength="50" id="txt_boss_name"  readonly></input> -->
			</td> 
		</tr>
		<tr>
			<td style="font-weight: 900; font-size:14px; vertical-align: middle; text-align:center; border:1px solid black !important;">사업장<br>주 소</td>
			<td colspan="3" style="font-size:14px; vertical-align: middle; text-align:left; border:1px solid black !important;" id="txt_our_address">
<!-- 				<input type="text" class="form-control" maxlength="50" id="txt_our_address"  readonly></input> -->
			</td>
			<td style="font-weight: 900; font-size:14px; vertical-align: middle; text-align:center; border:1px solid black !important;">사업장<br>주 소</td>
			<td colspan="3" style="font-size:14px; vertical-align: middle; text-align:left; border:1px solid black !important;" id="txt_address">
<!-- 				<input type="text" class="form-control" maxlength="50" id="txt_address"  readonly></input> -->
			</td>
		</tr>
		<tr>
			<td colspan="10" style="font-weight: 900; font-size:14px; vertical-align: middle; text-align:center; border:1px solid black !important;"></td>
		</tr>
	</table>
	
<%-- 	<%=zhtml%> --%>
	<table class="table table-bordered" id="TableS101S040120" style="width: 100%; border:1px solid black !important;">
		<thead>
	        <tr style="vertical-align: middle">
	            <th style="width: 8%; font-weight: 900; font-size:14px; text-align:left; vertical-align: middle; border:1px solid black !important;">순서</th>
<!-- 	            <th style="width:20%; font-weight: 900; font-size:14px; text-align:left; vertical-align: middle; border:1px solid black !important;">제품번호</th> -->
	            <th style="width:20%; font-weight: 900; font-size:14px; text-align:left; vertical-align: middle; border:1px solid black !important;">일련번호</th>
	            <th style="width:20%; font-weight: 900; font-size:14px; text-align:left; vertical-align: middle; border:1px solid black !important;">품명</th>
	            <th style="width: 8%; font-weight: 900; font-size:14px; text-align:left; vertical-align: middle; border:1px solid black !important;">단위</th>
	            <th style="width: 8%; font-weight: 900; font-size:14px; text-align:left; vertical-align: middle; border:1px solid black !important;">수량</th>
	            <th style="width: 8%; font-weight: 900; font-size:14px; text-align:left; vertical-align: middle; border:1px solid black !important;">단가</th>
	            <th style="width: 8%; font-weight: 900; font-size:14px; text-align:left; vertical-align: middle; border:1px solid black !important;">금액</th>
	            <th style="width:20%; font-weight: 900; font-size:14px; text-align:left; vertical-align: middle; border:1px solid black !important;">비고</th>
	        </tr>		    	
		</thead>
	    <tbody>
			<%for (int i=0; i<RowCount; i++){  %>	        
	        <tr style="vertical-align: middle">			            
	        	<td style="width: 8%; font-size:14px; text-align:left; vertical-align: middle; border:1px solid black !important;"><%=TableModel.getValueAt(i, 0).toString().trim()%></td>
	        	<td style="width:20%; font-size:14px; text-align:left; vertical-align: middle; border:1px solid black !important;"><%=TableModel.getValueAt(i, 1).toString().trim()%></td>
	        	<td style="width:20%; font-size:14px; text-align:left; vertical-align: middle; border:1px solid black !important;"><%=TableModel.getValueAt(i, 2).toString().trim()%></td>
	        	<td style="width: 8%; font-size:14px; text-align:left; vertical-align: middle; border:1px solid black !important;"><%=TableModel.getValueAt(i, 3).toString().trim()%></td>
	        	<td style="width: 8%; font-size:14px; text-align:left; vertical-align: middle; border:1px solid black !important;"><%=TableModel.getValueAt(i, 4).toString().trim()%></td>
	        	<td style="width: 8%; font-size:14px; text-align:left; vertical-align: middle; border:1px solid black !important;"><%=TableModel.getValueAt(i, 5).toString().trim()%></td>
	        	<td style="width: 8%; font-size:14px; text-align:left; vertical-align: middle; border:1px solid black !important;"><%=TableModel.getValueAt(i, 6).toString().trim()%></td>
	        	<td style="width:20%; font-size:14px; text-align:left; vertical-align: middle; border:1px solid black !important;"><%=TableModel.getValueAt(i, 7).toString().trim()%></td>
	        </tr>
			<% }%>	        
	    </tbody>
	</table>
	
	<table style="width: 100%;">
		<tr>
	    	<td colspan="8" style="font-weight: 900; font-size:14px; vertical-align: middle; text-align:center;"></td>
	  	</tr>
		<tr>
	    	<td colspan="7" style="font-weight: 900; font-size:14px; vertical-align: middle; text-align:center;">상기 품명을 정히 납품 함</td>
	    	<td style="font-weight: 900; font-size:14px; vertical-align: middle; text-align:right">
	    		<img id="SealImageFile" width="50" height="50" ></img>
	    	</td>
	  	</tr>
		
	</table>
</div>
<table style="width: 100%;">
	<tr style="height: 40px;">
		<td style="text-align:center;">
			<p>
				<button id="btn_Canc"  class="btn btn-info"  onclick="jQuery.print('#TradingTable');">프린트</button>
				<button id="btn_Canc"  class="btn btn-info"  onclick="parent.$('#modalReport').hide();">닫기</button>
			</p>
		</td>
	</tr>
</table>
