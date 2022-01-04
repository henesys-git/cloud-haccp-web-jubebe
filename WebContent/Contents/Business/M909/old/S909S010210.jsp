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
	
	String RightButton[][]	= {
								{"off", "fn_Chart_View", rightbtnChartShow},
								{"off", "fn_Doc_Reg()", rightbtnDocSave},
								{"off", "file_real_name", rightbtnDocShow}
							  };
	
	String GV_BOM_CODE = "", GV_PROD_CD = "";
	
	if(request.getParameter("BomCode") != null)
		GV_BOM_CODE = request.getParameter("BomCode");
	
	if(request.getParameter("prod_cd") != null)
		GV_PROD_CD = request.getParameter("prod_cd");

	String param =   GV_BOM_CODE + "|" + GV_PROD_CD + "|" ;
	
	JSONObject jArray = new JSONObject();
	jArray.put("member_key", member_key);
	jArray.put("BOM_CODE", GV_BOM_CODE);
	jArray.put("prod_cd", GV_PROD_CD);
		
	DoyosaeTableModel TableModel = new DoyosaeTableModel("M909S010100E214", jArray);	

	MakeGridData makeGridData = new MakeGridData(TableModel);
 	makeGridData.RightButton = RightButton; 
 	makeGridData.htmlTable_ID = "tableS909S010210";
%>

<script type="text/javascript">
    $(document).ready(function () {
    	var htmlTable_ID = <%=makeGridData.htmlTable_ID%>;
		
		var customOpts = {
    			data : <%=makeGridData.getDataArry()%>,
    			columnDefs : [
    				{
	    	       		'targets': [2,3,4,5,8,9],
	    	       		'createdCell':  function (td) {
	    	          			$(td).attr('style', 'display: none;');
	    	          			console.log($(td).text());
	    	       		}
	    	    	},
	   				{
			  			'targets': [6],
			  			'className' : "dt-body-right",
			  			'render' : function(data, type, row, meta) {
			  				return (data * 100) + '%';
			  			}
			  		}
	    	    ],
    	    	bAutoWidth : false
    	}
    	
    	$('#<%=makeGridData.htmlTable_ID%>').DataTable(
    		mergeOptions(heneSubTableOpts, customOpts)
    	);
    
		vBomListId = "";
    	vPart_cd = "";
    });
    
    function clickSubMenu(obj) {
    	var tr = $(obj);
		var td = tr.children();
		var trNum = $(obj).closest('tr').prevAll().length;	// 현재 클릭한 TR의 순서 return

		$(SubMenu_rowID).attr("class", "");
		$(obj).attr("class", "selected");
		
		vPart_cd 		= td.eq(0).text().trim();
		vPart_nm 		= td.eq(1).text().trim();
		vPart_rev_no	= td.eq(4).text().trim();
		
		vBlending_ratio = td.eq(6).text().trim();
		console.log(vBlending_ratio);
		vStart_date 	= td.eq(7).text().trim();
    }
</script>

<table class='table table-bordered nowrap table-hover' 
		  id="<%=makeGridData.htmlTable_ID%>" style="width: 100%">
	<thead>
		<tr>
		<th>원부재료/부자재 코드</th>
		<th>원부자재명</th>
		<th style='width:0px; display: none;'>제품명</th>
		<th style='width:0px; display: none;'>제품 코드</th>
		<th style='width:0px; display: none;'>원부재료/부자재 코드 rev</th>
		<th style='width:0px; display: none;'>배합율 수정이력번호</th>
		<th>배합율</th>
		<th>시작일자</th>
		<th style='width:0px; display: none;'>duration_date</th>
		<th style='width:0px; display: none;'>delyn</th>
		</tr>
	</thead>
	<tbody id="<%=makeGridData.htmlTable_ID%>_body">
	</tbody>
</table>