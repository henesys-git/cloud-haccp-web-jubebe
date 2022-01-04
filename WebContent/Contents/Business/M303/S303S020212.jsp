<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*,java.util.*,javax.servlet.http.*"%>
<%@ page import="mes.client.comm.*" %>
<%@ page import="mes.client.common.*" %>
<%@ page import="mes.client.guiComponents.*" %>
<%@ page import="mes.client.util.*" %>
<%@ page import="mes.client.conf.*" %>
<%@ page import="org.json.simple.*"%><%@ include file="/strings.jsp" %>
<%
	String loginID = session.getAttribute("login_id").toString();
	String member_key = session.getAttribute("member_key").toString();
	
	String manufacturingDate = "",
		   requestRevNo = "",
		   prodPlanDate = "",
		   planRevNo = "",
		   prodCd = "",
		   prodRevNo = "",
		   partCd = "",
		   partRevNo = "",
		   bomRevNo = "",
		   partNm = "",
		   blendingRatio = "",
		   blendingAmtPlan = "",
		   blendingAmtReal = "",
		   diffReason = "",
		   date = "";
	
	if(request.getParameter("manufacturingDate") != null) {
		manufacturingDate = request.getParameter("manufacturingDate");
	}

	if(request.getParameter("requestRevNo") != null) {
		requestRevNo = request.getParameter("requestRevNo");
	}
	
	if(request.getParameter("prodPlanDate") != null) { 
		prodPlanDate = request.getParameter("prodPlanDate"); 
	}
	
	if(request.getParameter("planRevNo") != null) { 
		planRevNo = request.getParameter("planRevNo"); 
	}
	
	if(request.getParameter("prodCd") != null) { 
		prodCd = request.getParameter("prodCd"); 
	}
	
	if(request.getParameter("prodRevNo") != null) { 
		prodRevNo = request.getParameter("prodRevNo"); 
	}
	
	if(request.getParameter("partCd") != null) { 
		partCd = request.getParameter("partCd"); 
	}
	
	if(request.getParameter("partRevNo") != null) { 
		partRevNo = request.getParameter("partRevNo"); 
	}
	
	if(request.getParameter("bomRevNo") != null) { 
		bomRevNo = request.getParameter("bomRevNo"); 
	}
	
	if(request.getParameter("partNm") != null) { 
		partNm = request.getParameter("partNm"); 
	}
	
	if(request.getParameter("blendingRatio") != null) { 
		blendingRatio = request.getParameter("blendingRatio"); 
	}
	
	if(request.getParameter("blendingAmtPlan") != null) { 
		blendingAmtPlan = request.getParameter("blendingAmtPlan"); 
	}
	
	if(request.getParameter("blendingAmtReal") != null) { 
		blendingAmtReal = request.getParameter("blendingAmtReal"); 
	}
	
	if(request.getParameter("diffReason") != null) { 
		diffReason = request.getParameter("diffReason"); 
	}
	
	if(request.getParameter("date") != null) { 
		date = request.getParameter("date"); 
	}
%>

<div class="row">
	<div class="col-md-12">
		<table class="table" style="width: 100%">
			
			<tr>
				<td>원부재료명</td>
				<td>
					<input type="text" class="form-control" id="partNm" value="<%=partNm%>" readonly/>
		       	</td>
			<tr>
				<td>배합비율</td>
				<td>
					<input type="text" class="form-control" id="blendingRatio" value="<%=blendingRatio%>" readonly />
		       	</td>
		    </tr>
			<tr>
				<td>
		        	계획 배합량
				</td>
		        <td>
		        	<input type="number" id="blendingAmtPlan" class="form-control" value="<%=blendingAmtPlan%>" readonly />
		        </td>
		    </tr>
			<tr>
				<td>
		        	실제 배합량
				</td>
		        <td>
		        	<input type="number" id="blendingAmtReal" class="form-control" value="<%=blendingAmtReal%>" step="0.00001" />
		        </td>
		    </tr>
			<tr>
				<td>
		        	불일치 사유
				</td>
		        <td>
		        	<input type="text" id="diffReason" class="form-control" value="<%=diffReason%>" />
		        </td>
		    </tr>
		</table>
	</div>
</div>



<script>
	// 웹소켓 통신을 위해서 필요한 변수들 ---시작
	var SQL_Param = {
			PID:  "M303S020200E202", 
			excute: "queryProcess",
			stream: "N",
			param: ""
	};
	// 웹소켓 통신을 위해서 필요한 변수들 ---끝	

    $(document).ready(function () {
		
    });
    
	function updateBlendingDoc() {
		
		if($("#blendingAmtReal").val() == '') { 
			heneSwal.warning("배합량을 입력해주세요");
			return false;
		}
		
		var jsonObj = new Object();
		
		jsonObj.userId = '<%=loginID%>';
		jsonObj.manufacturingDate = '<%=manufacturingDate%>';
		jsonObj.requestRevNo = <%=requestRevNo%>;
		jsonObj.prodPlanDate = '<%=prodPlanDate%>';
		jsonObj.planRevNo = <%=planRevNo%>;
		jsonObj.prodCd = '<%=prodCd%>';
		jsonObj.prodRevNo = <%=prodRevNo%>;
		jsonObj.partCd = '<%=partCd%>';
		jsonObj.partRevNo = <%=partRevNo%>;
		jsonObj.bomRevNo = <%=bomRevNo%>;
		jsonObj.blendingAmtReal = $('#blendingAmtReal').val();
		jsonObj.reasonDiff = $('#diffReason').val();
		
		var jsonStr = JSON.stringify(jsonObj);

		var confirmVal = confirm("등록 하시겠습니까?");
		
		if(confirmVal) {
			SendTojsp(jsonStr, SQL_Param.PID);
		}
	}
    
	function SendTojsp(data, pid){		
		$.ajax({
	        type: "POST",
	        dataType: "json",
	        url: "<%=Config.this_SERVER_path%>/Contents/CommonView/insert_update_delete_json.jsp", 
	        data: {"bomdata" : data, "pid" : pid},
	        success: function (receive) {
				if(receive > -1) {
					//parent.fn_MainInfo_List(selectedDate);
		    	    fn_DetailInfo_List();
					$('#modalReport').modal('hide'); 
					heneSwal.successTimer('원료배합량이 입력되었습니다');
				} else {
					heneSwal.errorTimer('원료배합량 입력 실패했습니다, 다시 시도해주세요')
				}
	         }
	    });
	}
    
    function pop_fn_ProdPlan_View(date) {
    	var url = "<%=Config.this_SERVER_path%>/Contents/CommonView/ViewPlanDaily.jsp"
    			   + "?selectedDate=" + date;

    	pop_fn_popUpScr_nd(url, "생산계획 조회", '650px', '1360px');
		return false;
    }
    
	function setValues (prodPlanDate, prodName, planAmount,
			 		    planRevNo, prodCd, prodRevNo, expirationDate) {
    	
		console.log(prodPlanDate);
		console.log(prodName);
		console.log(planAmount);
		console.log(planRevNo);
		console.log(prodCd);
		console.log(prodRevNo);
		console.log(expirationDate);
		
    	$('#date_prod_plan').val(prodPlanDate);
    	$('#txt_prod_nm').val(prodName);
    	$('#plan_amount').val(planAmount);
    	$('#prod_plan_rev').val(planRevNo);
    	$('#txt_prod_cd').val(prodCd);
    	$('#txt_prod_rev').val(prodRevNo);
    	$('#date_expiration').val(expirationDate);
    	
    	var dataToAjax = {
    					"prodCd": prodCd,
    					"prodRevNo": prodRevNo,
    					"selectedDate": prodPlanDate
    				  };
    	
    	dataToAjax = JSON.stringify(dataToAjax);
    	
    	$.ajax({
	         type: "POST",
	         dataType: "json",
	         url: "<%=Config.this_SERVER_path%>/Contents/CommonView/select_json.jsp", 
	         data: {"prmtr" : dataToAjax, "pid" : 'M303S040100E184'},
	         beforeSend: function () {
	         	 console.log('parameter: ' + dataToAjax);
	         	 console.log('sending ajax');
	         },
	         success: function (data) {
	        	 setBlendingSubTable(data);
	         },
	         error: function (request, status, error) {
	             console.log("error:" + request.responseText);
	         }
	    });
    }
	
	function setBlendingSubTable(data) {
				
    	var blendingTable = $('#blendingTable').DataTable({
    		data: data,
    		createdRow: "",
    		select: false,
    		columnDefs: [
    			{
	    			"target": [3,4],
	    			'createdCell':  function (td) {
	          			$(td).attr('style', 'display:none;'); 
	       			},
	       			"render" : function ( data, type, row ) {
	       	            return (100 * data).toFixed(2) + "%";
	       	             }
	    		},
    			{
	    		    "targets": 2,
	    		    "data": "download_link",
	    		    "render": function ( data, type, row, meta ) {
	    		      return '<input type="number" class="form-control" id="ttlBlendAmt'+meta.row+'" />';
	    		    }
	    		}
    		],
    		paging: false,
    		lengthMenu: false
    	});    	
	}

</script>