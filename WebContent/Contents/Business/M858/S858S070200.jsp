<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*,java.util.*,javax.servlet.http.*"%>
<%@ page import="mes.client.comm.*" %>
<%@ page import="mes.client.guiComponents.*" %>
<%@ page import="mes.client.util.*" %>
<%@ page import="mes.client.conf.*" %>
<%@ page import="org.json.simple.*"%><%@ include file="/strings.jsp" %>

<!-- 
완제품 재고 현황 메인 테이블 
-->

<%
	String loginID = session.getAttribute("login_id").toString();
	String member_key = session.getAttribute("member_key").toString();
	
	String Fromdate = "", Todate = "", 
		   GV_PRODGUBUN_BIG = "", GV_PRODGUBUN_MID = "";

	if(request.getParameter("prodgubun_big") == null)
		GV_PRODGUBUN_BIG = "";
	else
		GV_PRODGUBUN_BIG = request.getParameter("prodgubun_big");

	if(request.getParameter("prodgubun_mid") == null)
		GV_PRODGUBUN_MID = "";
	else
		GV_PRODGUBUN_MID = request.getParameter("prodgubun_mid");
	
	String param = GV_PRODGUBUN_BIG + "|" + GV_PRODGUBUN_MID + "|"  + member_key;
	
	JSONObject jArray = new JSONObject();
	jArray.put("member_key", member_key);
	jArray.put("prodgubun_big", GV_PRODGUBUN_BIG);
	jArray.put("prodgubun_mid", GV_PRODGUBUN_MID);

    DoyosaeTableModel TableModel = new DoyosaeTableModel("M858S070200E204", jArray);	

    MakeGridData makeGridData= new MakeGridData(TableModel);
    makeGridData.htmlTable_ID = "tableS858S070200";
%>

<script>
  	
    $(document).ready(function () {
    	
    	var exportDate = new Date();        
     	var printCounter = 0;
		var htmlTable_ID = <%=makeGridData.htmlTable_ID%>;
		
		var customOpts = {
				data : <%=makeGridData.getDataArray()%>,
				columnDefs : [{
					'targets': [4],
					'createdCell': function (td) {
			  			$(td).attr('style', 'display: none;'); 
					}
				},
	   			{
		  			'targets': [5,6],
		  			'render': function(data){
		  				if(data == "" || data == null){
		  					return 0;
		  				}
		  				return addComma(data);
		  			},
		  			'className' : "dt-body-right"
		  		}],
				scrollX : true,
				
				'rowCallback': function(row, data){
			  		
		  		  	if(parseInt(data[5]) > parseInt(data[6])){
		  			   $(row).find('td:eq(6)').css('color','red');
		  		   }
		  		}
		}
		
		$('#<%=makeGridData.htmlTable_ID%>').DataTable(
			mergeOptions(heneMainTableOpts, customOpts)
		);
		
 		vProdgubun_big = "";
		vProdgubun_mid = "";
		vProdCd	= "";
		vProdRev = "";
    });
    
	function clickMainMenu(obj){
		var tr = $(obj);
		var td = tr.children();
		var trNum = $(obj).closest('tr').prevAll().length;
	
		vProdgubun_big = td.eq(0).text().trim();
		vProdgubun_mid = td.eq(1).text().trim();
		vProd_cd = td.eq(2).text().trim();
		vProd_rev = td.eq(4).text().trim();
		
		parent.DetailInfo_List.click();
	}
 
</script>
<table class='table table-bordered nowrap table-hover' 
		  id="<%=makeGridData.htmlTable_ID%>" style="width: 100%">
	<thead>
		<tr>
			<th>대분류</th>
			<th>중분류</th>
			<th>제품코드</th>
			<th>제품명</th>
			<th style='width:0px; display: none;'>제품 수정이력번호</th>
			<th>안전재고</th>
			<th>현재재고</th>
		</tr>
	</thead>
	<tbody id="<%=makeGridData.htmlTable_ID%>_body">		
	</tbody>
</table>