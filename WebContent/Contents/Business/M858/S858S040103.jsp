﻿<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
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
	
	String discard_type = "",
		   discard_seq_no = "";
	
	if(request.getParameter("discard_type") != null)
		discard_type = request.getParameter("discard_type");

	if(request.getParameter("discard_seq_no") != null)
		discard_seq_no = request.getParameter("discard_seq_no");
%>

<section>
	<div class="row">
		<div class="table-responsive">
			<form id="myForm">
				<table class="table">
					<tr>
						<td>분류</td>
						<td>
							<input type="text" class="form-control" id="discard_type" name="discard_type" readonly>
							<input type="hidden" class="form-control" id="discard_seq_no" name="discard_seq_no">
				       	</td>
				    </tr>
						
					<tr>
						<td>
				        	제품명
						</td>
				        <td>
				        	<input type="text" id="product_nm" name="product_nm" class="form-control" readonly>
				        	<input type="hidden" id="prod_cd" name="prod_cd" class="form-control">
				        	<input type="hidden" id="prod_rev_no" name="prod_rev_no"" class="form-control">
				        </td>
				    </tr>
					<tr>
						<td>
				        	반품일자
						</td>
				        <td>
				        	<input type="date" id="discard_date" name="discard_date" class="form-control" readonly>
				        </td>
				    </tr>
				   	<tr>
				       	<td>
				       		반품/폐기량
				       	</td>
						<td>
				        	<input type="text" class="form-control" id="amount" name="amount" readonly>
				        	<!-- 
				        		일단 순서 맞춘다고 놔둔 수정 기능에 있던 input tag임 (modified_amount)
				        		추후 삭제하고 data 순서 다시 맞춰야됨 (2021 02 18 최현수)
				        	 -->
				        	<input type="hidden" class="form-control" id="modified_amount" name="modified_amount">
						</td>
				   	</tr>
				   	<tr>
				       	<td>
				       		비고
				       	</td>
						<td>
				        	<input type="text" class="form-control" id="note" name="note" readonly>
				        	<input type="hidden" name="chulha_no">
				        	<input type="hidden" name="chulha_rev_no">
				        	<input type="hidden" name="prod_date">
				        	<input type="hidden" name="seq_no">
				        	<input type="hidden" name="chulha_count">
				        	<input type="hidden" name="cur_stock">
						</td>
				   	</tr>
				</table>
			</form>
		</div>
	</div>
</section>

<script>
    $(document).ready(function () {
		var discard_type = '<%=discard_type%>';    	
		var discard_seq_no = '<%=discard_seq_no%>';    	
    	
    	getProdDiscardInfo(discard_type, discard_seq_no);
    	
    	$('#deleteBtn').click(function() {
    		var formData = getFormDataJson('#myForm');
    		var discard_amount = formData["amount"];
            var cur_stock = formData["cur_stock"];
            
    		var pid = "";
    		console.log(cur_stock);
    		console.log(discard_amount);
    		var confirmDelete = confirm("삭제하시겠습니까?");
			
    		if(confirmDelete) {
    			var JSONparam = JSON.stringify(formData);
    			
	    		var stockLeft = checkCurStock(discard_amount, cur_stock);

	    		if(!stockLeft) {
	    			heneSwal.warning("반품 취소 수량 대비 현재 남아 있는 재고가 충분하지 않습니다.\n" +
	    						   	 "재고를 확인해 주세요");
	    			return false;
	    		} else {
	    			if(discard_type = "반품") {
		    			pid = "M858S040100E203";
	    				sendToServer(JSONparam, pid);
		    		} else if(discard_type = "폐기") {
		    			pid = "M858S040100E213";
		    			sendToServer(JSONparam, pid);
		    		}
	    		}
    		}
    	});
        
    	function sendToServer(param, pid) {
    		$.ajax({
    	        type: "POST",
    	        dataType: "json",
    	        url: "<%=Config.this_SERVER_path%>/Contents/CommonView/insert_update_delete_json.jsp", 
    	        data: {"bomdata" : param, "pid" : pid},
    	        success: function (rcvData) {
    	        	if(rcvData > -1) {
    	        		heneSwal.success("반품 정보 삭제를 완료했습니다");
    		 	     	$('#modalReport').modal('hide');
    	        		parent.fn_MainInfo_List(startDate, endDate);
    	        	} else {
    	        		heneSwal.error("반품 정보 삭제 실패했습니다, 다시 시도해주세요");
    	        	}
    	        },
    	        error: function(rcvData) {
            		heneSwal.error("반품 정보 삭제 실패했습니다, 다시 시도해주세요");
    	        }
    	    });
    	}
     	
     	// 반품,폐기 테이블에서 정보를 가져옴
     	function getProdDiscardInfo(discard_type, discard_seq_no) {
    		let jsonObj = new Object();
    		jsonObj.discard_seq_no = discard_seq_no;
    		jsonObj.discard_type = discard_type;
    		let jsonStr = JSON.stringify(jsonObj);
    		
    		$.ajax({
    	        type: "POST",
    	        dataType: "json",
    	        url: "<%=Config.this_SERVER_path%>/Contents/CommonView/select_json.jsp", 
    			data: {"prmtr" : jsonStr, "pid" : "M858S040100E204"},
    	        success: function (data) {
    	        	var idx = 0;
    	        	
    	        	// set input init value
    	    		$("#myForm :input").each(function(){
    	    			this.value = data[0][idx];
    	    			idx++;
    	    		});
    	        }
    	    });
     	}
     	
     	function checkCurStock(discard_amount, cur_stock) {
        	var leftover = +cur_stock - +discard_amount;
        	if(leftover >= 0) {
        		return true;
        	} else {
        		return false;
        	}
        }
    });
</script>