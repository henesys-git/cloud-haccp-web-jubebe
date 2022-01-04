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
	String Fromdate = "", Todate = "";

	if(request.getParameter("From") == null) {
		Fromdate = "";
	} else {
		Fromdate = request.getParameter("From");
	}
	
	if(request.getParameter("To") == null)
		Todate = "";
	else
		Todate = request.getParameter("To");	

	String RightButton[][]	= {
								{"off", "fn_Chart_View", rightbtnChartShow},
								{"off", "fn_Doc_Reg()", rightbtnDocSave},
								{"off", "file_real_name", rightbtnDocShow}
							  };
	
	JSONObject jArray = new JSONObject();
	jArray.put("fromdate", Fromdate);
	jArray.put("todate", Todate);

    TableModel = new DoyosaeTableModel("M303S040100E104", jArray);

    makeGridData= new MakeGridData(TableModel);
 	makeGridData.RightButton = RightButton;
    makeGridData.htmlTable_ID = "tableS303S040100";
 	makeGridData.Check_Box = "false";
 	String[] HyperLink = {""};
 	makeGridData.HyperLink = HyperLink;
%>

<script type="text/javascript">
    $(document).ready(function () {
    	
    	var htmlTable_ID = <%=makeGridData.htmlTable_ID%>;
		
		var customOpts = {
   			data : <%=makeGridData.getDataArray()%>,
   			columnDefs : [{
   				'targets': [6,7,8,9,10,11],
   	   			'createdCell':  function (td) {
   	      			$(td).attr('style', 'display:none'); 
   	   			}
   			},
   			{
	  			'targets': [3],
	  			'render': function(data){
	  				return addComma(data);
	  			}
	  		},
   			{
	  			'targets': [3,5,6],
	  			
	  			'className' : "dt-body-right"
	  		}
   			],
   			order : [2, "DESC"]
		}
    	
    	$('#<%=makeGridData.htmlTable_ID%>').DataTable(
    		mergeOptions(heneMainTableOpts, customOpts)
    	);
		
		fn_Clear_varv();
    });
    
    function clickMainMenu(obj){
    	var tr = $(obj);
		var td = tr.children();
		var trNum = $(obj).closest('tr').prevAll().length;
		
		vProductNm 				= td.eq(0).text().trim();
		vGugyuk				  	= td.eq(1).text().trim();
		vManufacturingDate  	= td.eq(2).text().trim();
		vPlanAmount				= td.eq(3).text().trim();
		vExpirationDate			= td.eq(4).text().trim();
		vLossRate				= td.eq(5).text().trim();
		vTotalBlendingAmount 	= td.eq(6).text().trim();
		vRequestRevNo 			= td.eq(7).text().trim();
		vProdPlanDate 			= td.eq(8).text().trim();
		vPlanRevNo 				= td.eq(9).text().trim();
		vProdCd 				= td.eq(10).text().trim();
		vProdRevNo 				= td.eq(11).text().trim();
		vWorkStatus 			= td.eq(12).text().trim();
		vNote					= td.eq(13).text().trim();
		
		parent.DetailInfo_List.click();
    }

	function fn_Clear_varv() {
		vRequestRevNo = "";
		vProdPlanDate = "";
		vPlanRevNo = "";
		vProdCd = "";
		vProdRevNo = "";
	}
	
	// 유통기한 날짜 세팅
	var adjustExpDate = function(orgDate, add) {
    	var heneDate = new HeneDate();
    	var date = heneDate.addDate(orgDate, add);
    	return date;
    }

</script>

<table class='table table-bordered nowrap table-hover' 
		  id="<%=makeGridData.htmlTable_ID%>" style="width: 100%">
	<thead>
		<tr>
			 <th>제품명</th>
		     <th>규격</th>
		     <th>제조년월일</th>
		     <th>계획 생산량</th>
		     <th>유통기한</th>
		     <th>수율</th>
		     <th style='width:0px; display:none'>배합량</th>
		     <th style='width:0px; display:none'>생산작업요정서 수정이력번호</th>
		     <th style='width:0px; display:none'>생산계획일자</th>
		     <th style='width:0px; display:none'>생산계획 수정이력번호</th>
		     <th style='width:0px; display:none'>완제품코드</th>
		     <th style='width:0px; display:none'>완제품 수정이력번호</th>
		     <th>작업진행상태</th>
		     <th>비고</th>
		</tr>
	</thead>
	<tbody id="<%=makeGridData.htmlTable_ID%>_body">		
	</tbody>
</table>

<div id="UserList_pager" class="text-center">
</div>      
