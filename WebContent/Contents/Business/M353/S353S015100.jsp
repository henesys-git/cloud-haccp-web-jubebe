<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*,java.util.*,javax.servlet.http.*"%>
<%@ page import="mes.client.comm.*" %>
<%@ page import="mes.client.guiComponents.*" %>
<%@ page import="mes.client.util.*" %>
<%@ page import="mes.client.conf.*" %>
<%@ page import="org.json.simple.*"%><%@ include file="/strings.jsp" %>
<%
	String loginID = session.getAttribute("login_id").toString();
	String member_key = session.getAttribute("member_key").toString();
	String history_yn = session.getAttribute("history_yn").toString();
	
	String GV_PRODGUBUN_BIG = "",
		   GV_PRODGUBUN_MID = "";
	
	if(request.getParameter("prodgubun_big") != null)
		GV_PRODGUBUN_BIG = request.getParameter("prodgubun_big");

	if(request.getParameter("prodgubun_mid") != null)
		GV_PRODGUBUN_MID = request.getParameter("prodgubun_mid");
	
	JSONObject jArray = new JSONObject();
	jArray.put("prodgubun_big", GV_PRODGUBUN_BIG);
	jArray.put("prodgubun_mid", GV_PRODGUBUN_MID);
	
	DoyosaeTableModel TableModel = new DoyosaeTableModel("M353S015100E104", jArray);
	MakeGridData makeGridData = new MakeGridData(TableModel);
	makeGridData.htmlTable_ID = "tableS353S015100";
%>

<script type="text/javascript">
    $(document).ready(function () {
    	
    	let inputAmt;
    	let outputAmt;
    	
    	var customOpts = {
    			data : <%=makeGridData.getDataArray()%>,
    			columnDefs : [{
    	       		'targets': [8,9,10],
    	       		'createdCell':  function (td) {
    	          			$(td).attr('style', 'display: none;'); 
    	       		}
    	    	},
	   			{
		  			'targets': [5],
		  			'render': function(data, type, row, meta){
		  				var ipgoAmt = row[5];
		  				var packCnt = row[6];
		  				var cntUnit = row[7];
		  				var blendingRatio = row[8];
						inputAmt = (ipgoAmt * packCnt * cntUnit) / blendingRatio;
						
		  				return addComma(inputAmt);
		  			},
		  			'className' : "dt-body-right"
		  		},
	   			{
		  			'targets': [6],
		  			'render': function(data, type, row, meta){
		  				var packWeight = row[6] * row[7];
		  				var ipgoAmt = row[5];
		  				outputAmt = packWeight * ipgoAmt;
		  				
		  				return addComma(outputAmt);
		  			},
		  			'className' : "dt-body-right"
		  		},
	   			{
		  			'targets': [7],
		  			'render': function(data, type, row, meta) {
		  				var lossRate = (outputAmt / inputAmt) * 100;
		  				lossRate = Number(lossRate).toFixed(2);
		  				
		  				if(isNaN(lossRate)) {
		  					lossRate = 0;
		  				};
		  				
		  				return lossRate + "%";
		  			},
		  			'className' : "dt-body-right"
		  		}]
    	}
    	
    	$('#<%=makeGridData.htmlTable_ID%>').DataTable(
    		mergeOptions(heneMainTableOpts, customOpts)
    	);
                                                                                                                                                            });
    
    function clickMainMenu(obj) {
    	var tr = $(obj);
		var td = tr.children();
		var trNum = $(obj).closest('tr').prevAll().length;
		
		vProdgubun_big = td.eq(0).text().trim();
		vProdgubun_mid = td.eq(1).text().trim();
		vProdCd = td.eq(2).text().trim();
		vProdRevNo = td.eq(10).text().trim();
		vProdNm = td.eq(3).text().trim();
		vProdDate = td.eq(4).text().trim();
		vInputAmt = td.eq(5).text().trim();
		vOutputAmt = td.eq(6).text().trim();
		vLossRate = td.eq(8).text().trim();
		
		console.log(vProdCd);
		
		DetailInfo_List.click();
    }
</script>

<table class='table table-bordered nowrap table-hover' 
		  id="<%=makeGridData.htmlTable_ID%>" style="width: 100%">
	<thead>
		<tr>
			<th>대분류</th>
			<th>중분류</th>
			<th>코드</th>
			<th>품목명</th>
			<th>생산일자</th>
			<th>투입량</th>
			<th>생산량</th>
			<th>수율</th>
			<th style="display:none; width:0">원자재 배합률</th>
			<th style="display:none; width:0">일련 번호(seq_no)</th>
			<th style="display:none; width:0">수정이력번호</th>
		</tr>
	</thead>
	<tbody id="tablePartView_body">		
	</tbody>
</table>