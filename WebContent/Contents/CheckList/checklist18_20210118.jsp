<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*,java.util.*,javax.servlet.http.*"%>
<%@ page import="mes.client.comm.*" %>
<%@ page import="mes.client.common.*" %>
<%@ page import="mes.client.guiComponents.*" %>
<%@ page import="mes.client.util.*" %>
<%@ page import="mes.client.conf.*" %>
<%@ page import="org.json.simple.*"%>
<%
/* 
연간교육훈련계획서 캔버스 (S838S080100)
*/	
	String loginID = session.getAttribute("login_id").toString();
	String member_key = session.getAttribute("member_key").toString();

	String checklistFormat = "", checklistId = "", checklistRevNo = "", checklistDate = "", 
		   prodCd = "", prodRevNo = "", dateOccur = "", seqNo = "";
	
	String chulgoSeqNo = "", prodDate = "", expirationDate = "", prodName="", 
			   claimDate = "", personReport = "", claimDetail = "", picture1 = "", 
			   picture2 = "", causeOccur = "", customerAction = "", customerProof = "",
			   companyAction = "", companyProof = "", personWriteId = "", 
			   personApproveId = "", personWriter = "", personApprover = "";	
	
	
	if(request.getParameter("format") != null)
		checklistFormat = request.getParameter("format");

	if(request.getParameter("seqNo") != null)
		seqNo = request.getParameter("seqNo");

	if(request.getParameter("checklistId") != null)
		checklistId = request.getParameter("checklistId");

	if(request.getParameter("checklistRevNo") != null)
		checklistRevNo = request.getParameter("checklistRevNo");
	
	if(request.getParameter("checklistDate") != null)
		checklistDate = request.getParameter("checklistDate");
	
	if(request.getParameter("chulgoSeqNo") != null)
		chulgoSeqNo = request.getParameter("chulgoSeqNo");
	
	if(request.getParameter("prodDate") != null)
		prodDate = request.getParameter("prodDate");
	
	if(request.getParameter("expirationDate") != null)
		expirationDate = request.getParameter("expirationDate");
	
	if(request.getParameter("prodName") != null)
		prodName = request.getParameter("prodName");
	
	if(request.getParameter("seqNo") != null)
		seqNo = request.getParameter("seqNo");
	
	if(request.getParameter("prodCd") != null)
		prodCd = request.getParameter("prodCd");
	
	if(request.getParameter("prodRevNo") != null)
		prodRevNo = request.getParameter("prodRevNo");
	
	if(request.getParameter("claimDate") != null)
		claimDate = request.getParameter("claimDate");
	
	if(request.getParameter("personReport") != null)
		personReport = request.getParameter("personReport");
	
	if(request.getParameter("claimDetail") != null)
		claimDetail = request.getParameter("claimDetail");
	
	if(request.getParameter("picture1") != null)
		picture1 = request.getParameter("picture1");
	
	if(request.getParameter("picture2") != null)
		picture2 = request.getParameter("picture2");
	
	if(request.getParameter("causeOccur") != null)
		causeOccur = request.getParameter("causeOccur");
	
	if(request.getParameter("customerAction") != null)
		customerAction = request.getParameter("customerAction");
	
	if(request.getParameter("customerProof") != null)
		customerProof = request.getParameter("customerProof");
	
	if(request.getParameter("companyAction") != null)
		companyAction = request.getParameter("companyAction");
	
	if(request.getParameter("companyProof") != null)
		companyProof = request.getParameter("companyProof");
	
	if(request.getParameter("personWriteId") != null)
		personWriteId = request.getParameter("personWriteId");
	
	if(request.getParameter("personApproveId") != null)
		personApproveId = request.getParameter("personApproveId");
	
	JSONObject jArray = new JSONObject();
	jArray.put("seqNo", seqNo);
	jArray.put("checklistId", checklistId);
	jArray.put("checklistRevNo", checklistRevNo);
	jArray.put("checklistDate", checklistDate);
	jArray.put("prodCd", prodCd);
	jArray.put("prodRevNo", prodRevNo);
	jArray.put("prodDate", prodDate);
	jArray.put("dateOccur", dateOccur);

	DoyosaeTableModel table = new DoyosaeTableModel("M838S015500E144", jArray);
	VectorToJson vtj = new VectorToJson();
	String data = vtj.vectorToJson(table.getVector());
%>

<script>

	$(document).ready(function() {
		
		var data = <%=data%>;
		data = data[0];
		console.log(data);
		
		let bodyObj = new Object();
		
		bodyObj.body0 = {
			rowCnt: 3,
			colCnt: 4,
			rowRatio: [34/101, 34/101, 33/101],
			colRatio: [64/526, 211/526, 63/526, 188/526]
		};
		
		bodyObj.body1 = {
			rowCnt: 3,
			colCnt: 3,
			rowRatio: [124/343, 165/343, 54/343],
			colRatio: [64/526, 217/526, 245/526]
		};
		
		bodyObj.body2 = {
			rowCnt: 3,
			colCnt: 4,
			rowRatio: [32/181, 76/181, 73/181],
			colRatio: [64/526, 211/526, 63/526, 188/526]
		};
		
		const cl = new CheckListWithImageBuilder()
						.setDivId('myCanvas')
						.setEntireRatio([85/710, 101/710, 343/710, 181/710])
						.setHeadRowCnt(2)
						.setHeadColCnt(4)
						.setHeadRowRatio([21/85, 64/85])
						.setHeadColRatio([338/526, 28/526, 77/526, 83/526])
						.howManyBodies(3)
						.setChildBodiesRowCol(bodyObj)
						.setStartX(50)
						.setStartY(50)
						.setTest(false)
						.build();
							
		var bgImg = new Image();
		bgImg.src = '<%= checklistFormat %>';
		
		bgImg.onload = function() {
			// draw background
			cl.drawBackgroundImg(cl.ctx, bgImg);

			// merge cells
	 		cl.mergeCellsVertical(cl.head, "row0", "row1", "col0");
			cl.mergeCellsVertical(cl.head, "row0", "row1", "col1");
			
			cl.mergeCellsHorizon(cl.bodies.body0, "row1", "col1", "col3");
			cl.mergeCellsHorizon(cl.bodies.body1, "row0", "col1", "col2");
	 		cl.mergeCellsHorizon(cl.bodies.body1, "row2", "col1", "col2");

			cl.mergeCellsHorizon(cl.bodies.body2, "row0", "col0", "col1");
			cl.mergeCellsHorizon(cl.bodies.body2, "row0", "col2", "col3");
			
			// fill data
			
			//head
			cl.fillText(cl.head, "row1", "col2", '<%=table.getValueAt(0,19)%>',
						'balck', "15px arial", "center", "middle");
			cl.fillText(cl.head, "row1", "col3", '<%=table.getValueAt(0,20)%>',
					'balck', "15px arial", "center", "middle");
			
			
			//body0
			cl.fillText(cl.bodies.body0, "row0", "col1", '<%=table.getValueAt(0,7)%>',
						'balck', "15px arial", "center", "middle");
			cl.fillText(cl.bodies.body0, "row0", "col3", '<%=table.getValueAt(0,19)%>',
					'balck', "15px arial", "center", "middle");
			cl.fillText(cl.bodies.body0, "row1", "col1", '<%=table.getValueAt(0,11)%>',
					'balck', "15px arial", "center", "middle");
			cl.fillText(cl.bodies.body0, "row2", "col1", '<%=table.getValueAt(0,2)%>',
					'balck', "15px arial", "center", "middle");
			cl.fillText(cl.bodies.body0, "row2", "col3", '<%=table.getValueAt(0,6)%>',
					'balck', "15px arial", "center", "middle");
			
			//body1
			cl.fillText(cl.bodies.body1, "row0", "col1", '<%=table.getValueAt(0,12)%>',
						'balck', "15px arial", "center", "middle");
			cl.fillText(cl.bodies.body1, "row1", "col1", '<%=table.getValueAt(0,8)%>',
						'balck', "15px arial", "center", "middle");
			cl.fillText(cl.bodies.body1, "row1", "col2", '<%=table.getValueAt(0,9)%>',
					'balck', "15px arial", "center", "middle");
			cl.fillText(cl.bodies.body1, "row2", "col1", '<%=table.getValueAt(0,10)%>',
					'balck', "15px arial", "center", "middle");
			
			//body2
			cl.fillText(cl.bodies.body2, "row1", "col1", '<%=table.getValueAt(0,13)%>',
					'balck', "15px arial", "center", "middle");
			cl.fillText(cl.bodies.body2, "row1", "col3", '<%=table.getValueAt(0,14)%>',
					'balck', "15px arial", "center", "middle");
			cl.fillText(cl.bodies.body2, "row2", "col1", '<%=table.getValueAt(0,15)%>',
					'balck', "15px arial", "center", "middle");
			cl.fillText(cl.bodies.body2, "row2", "col3", '<%=table.getValueAt(0,16)%>',
					'balck', "15px arial", "center", "middle");
		};
 	});
	
</script>
<div id="PrintAreaP">
	<canvas id="myCanvas" width="625" height="829">
	</canvas>    
</div>