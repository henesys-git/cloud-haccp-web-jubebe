<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*,java.util.*,javax.servlet.http.*"%>
<%@ page import="mes.client.comm.*" %>
<%@ page import="mes.client.guiComponents.*" %>
<%@ page import="mes.client.util.*" %>
<%@ page import="mes.client.conf.*" %>
<%@ page import="org.json.simple.*"%><%@ include file="/strings.jsp" %>
<%
	DoyosaeTableModel TableModel;
	MakeGridData makeGridData;
	String loginID = session.getAttribute("login_id").toString();
	String member_key = session.getAttribute("member_key").toString();
	
	String Fromdate="",Todate="",custCode="", GV_PROCESS_STATUS="";

	if(request.getParameter("From") == null)
		Fromdate="";
	else
		Fromdate = request.getParameter("From");
	
	if(request.getParameter("To") == null)
		Todate="";
	else
		Todate = request.getParameter("To");	
	
	if(request.getParameter("custcode") == null)
	custCode="";
		else
	custCode = request.getParameter("custcode");
		
	JSONObject jArray = new JSONObject();
	jArray.put("fromdate", Fromdate);
	jArray.put("todate", Todate);
	jArray.put("member_key", member_key);	

    TableModel = new EdmsDoyosaeTableModel("M404S080100E894", jArray);	    
 	int ColCount =TableModel.getColumnCount();
 	
 	CurrentPage jspPageName = new CurrentPage(request.getRequestURI());
 	String JSPpage = jspPageName.GetJSP_FileName();
	
 	makeGridData= new MakeGridData(TableModel);
	String RightButton[][]	= {
								{"off", "fn_Chart_View", rightbtnChartShow},
								{"on", "file_view_name", rightbtnDocRevise},
								{"on", "file_real_name", rightbtnDocShow}
							  };
 	makeGridData.RightButton = RightButton;
 	makeGridData.htmlTable_ID = "TableS404S080100";
 	makeGridData.Check_Box = "false";
 	String[] HyperLink = {""}; //strColumnHead의 수만큼
 	makeGridData.HyperLink = HyperLink;
%>

<script type="text/javascript">
	
    $(document).ready(function () {
    	
		var htmlTable_ID = <%=makeGridData.htmlTable_ID%>;
    	
    	var customOpts = {
   			data : <%=makeGridData.getDataArry()%>,
   			columnDefs : [{
   	       		'targets': [3,4,8,8,9,10,12,13,14,16,17,18,19,20,21,22,23],
   	       		'createdCell':  function (td) {
   	          			$(td).attr('style', 'display: none;');
   	       		}
   			}]
    	}
    	
    	$('#<%=makeGridData.htmlTable_ID%>').DataTable(
    		mergeOptions(heneMainTableOpts, customOpts)
    	);
    	
    	var exportDate = new Date();
    	var printCounter = 0;

		$("#checkboxAll").click(function(){ 					// 만약 전체 선택 체크박스가 체크된상태일경우 
			if($("#checkboxAll").prop("checked")) { 			// 해당화면에 전체 checkbox들을 체크해준다 
				$("input[type=checkbox]").prop("checked",true); // 전체선택 체크박스가 해제된 경우 
			} else {  
				$("input[type=checkbox]").prop("checked",false); 
			} 
		})
    });

    function clickMainMenu(obj) {
    	var tr = $(obj);
		var td = tr.children();
		var trNum = $(obj).closest('tr').prevAll().length;	// 현재 클릭한 TR의 순서 return	
		
		$(MainMenu_rowID).attr("class", "");
		$(obj).attr("class", "hene-bg-color");

		vOrderNo		= td.eq(13).text().trim();
		vLotNo			= td.eq(6).text().trim();
		vProduct_Gubun	= td.eq(3).text().trim();
		vPart_Source	= td.eq(4).text().trim();
		vRoHS			= td.eq(9).text().trim();
		vProdCd			= td.eq(20).text().trim();
		vProdRev		= td.eq(21).text().trim();
		
		<%-- var modalContentUrl = "<%=Config.this_SERVER_path%>/Contents/Business/M101/S101S030804.jsp?OrderNo=" + vOrderNo 
				+ "&lotno=" + vLotNo + "&Product_Gubun=" + vProduct_Gubun + "&Part_Source=" + vPart_Source 
				+ "&RoHS=" + vRoHS + "&Fromdate=" + '<%=Fromdate%>'  + "&Todate=" +'<%=Todate%>'
				+ "&prod_cd=" + vProdCd + "&prod_cd_rev=" + vProdRev;
		
		pop_fn_popUpScr(modalContentUrl, "제조이력(S101S030804)", '850px', '1550px'); --%>
		
		var url = "<%=Config.this_SERVER_path%>/Contents/Business/M101/S101S030804.jsp?OrderNo=" + vOrderNo 
					+ "&lotno=" + vLotNo + "&Product_Gubun=" + vProduct_Gubun + "&Part_Source=" + vPart_Source 
					+ "&RoHS=" + vRoHS + "&Fromdate=" + '<%=Fromdate%>'  + "&Todate=" +'<%=Todate%>'
					+ "&prod_cd=" + vProdCd + "&prod_cd_rev=" + vProdRev;
		var footer = "";
		var title = obj.innerText;
		var heneModal = new HenesysModal(url, 'large', title, footer);
		heneModal.open_modal();
    }
    
</script>
	<table class='table table-bordered nowrap table-hover' id="<%=makeGridData.htmlTable_ID%>" style="width: 100%">
		<thead>
		<tr>
		     <th>고객사</th>
		     <th>제품명</th>
		     <th>PO번호</th>
		     <th style='width:0px; display: none;'>구분</th>
		     <th style='width:0px; display: none;'>원부자재공급</th>
		     <th>주문일</th>
		     <th>포장단위</th>
		     <th>주문수량</th>
		     <th style='width:0px; display: none;'>자재출고일</th>
		     <th style='width:0px; display: none;'>rohs</th>
		     <th style='width:0px; display: none;'>특이사항</th>
		     <th>납기일</th>
		     <th style='width:0px; display: none;'>bom_version</th>
		     <th style='width:0px; display: none;'>주문번호</th>
		     <th style='width:0px; display: none;'>현상태</th>
		     <th>비고</th>
		     <th style='width:0px; display: none;'>product_serial_no</th>
		     <th style='width:0px; display: none;'>product_serial_no_end</th>
		     <th style='width:0px; display: none;'>cust_cd</th>
		     <th style='width:0px; display: none;'>cust_rev</th>
		     <th style='width:0px; display: none;'>prod_cd</th>
		     <th style='width:0px; display: none;'>prod_rev</th>
		     <th style='width:0px; display: none;'>order_status</th>
		     <!-- 버튼 자리 makeGridData의 데이터는 항상 버튼위 위치에 데이터를 space혹은 Button 문법을 구현해 준다-->
		     <th style='width:0px; display: none;'></th> 
		</tr>
		</thead>
		<tbody id="tableView_body">		
		</tbody>
	</table>