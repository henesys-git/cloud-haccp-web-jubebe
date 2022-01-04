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
				        	<input type="hidden" id="prod_rev_no" name="prod_rev_no" class="form-control">
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
				       		반품/폐기량(기존)
				       	</td>
						<td>
				        	<input type="text" class="form-control" id="amount" name="amount" readonly>
						</td>
				   	</tr>
				   	<tr>
				       	<td>
				       		반품/폐기량(수정)
				       	</td>
						<td>
				        	<input type="number" class="form-control" id="modified_amount" name="modified_amount">
						</td>
				   	</tr>
				   	<tr>
				       	<td>
				       		비고
				       	</td>
						<td>
				        	<input type="text" class="form-control" id="note" name="note">
				        	<input type="hidden" name="chulha_no">
				        	<input type="hidden" name="chulha_rev_no">
				        	<input type="hidden" name="prod_date">
				        	<input type="hidden" name="seq_no">
				        	<input type="hidden" name="chulha_count">
				        	<input type="hidden" name="post_amt">
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
    	console.log($('input[name=post_amt]').val());
    	
        // 반품 수정 전에 반품 개수의 유효성을 검증
        function validateModifiedAmount(chulhaCount, discardAmount, modifiedCount, curStock) {
        	var returnVal = true;
        	
        	/* 
        		ex) chulhaCount = 80 (반품/폐기 후 수정된 출하량)
        			amount = 20 (반품/폐기량)
        			20 + 80 => 80 => orgChulhaCount (반품/폐기 전의 원래 출하량) 
        	*/
        	var orgChulhaCount = Number(chulhaCount) + Number(curStock);
        			
        			console.log(orgChulhaCount);
        			console.log(modifiedCount);
        			console.log(modifiedCount > orgChulhaCount);
        			
        	if(parseInt(modifiedCount) <= 0 || parseInt(modifiedCount) > parseInt(orgChulhaCount) || parseInt(modifiedCount) > parseInt(curStock)) {
        		returnVal = false;
        	}
        	
        	return returnVal;
        }
        
        function checkCurStock(discard_amount, modified_amount, cur_stock) {
        	var diff = +modified_amount - +discard_amount;
        	console.log("diff");
        	console.log(diff);
        	if(Math.abs(parseInt(diff)) > parseInt(cur_stock)) {
        		return false;
        	} else {
        		return true;
        	}
        }
        
        function compareOrgAmtAndModifiedAmt(discard_amount, modified_amount) {
        	var returnVal;
        	var diff = +modified_amount - +discard_amount;
        	
        	if(parseInt(diff) > 0 || parseInt(diff) < 0) {
        		returnVal = "more or less";
        	} else if(diff === 0) {
        		returnVal = "same";
        	} else {
        		returnVal = "err";
        	}
        	
        	return returnVal;
        }
        
        $('#updateBtn').click(function() {
    		var pid = "";
    		
    		var formData = getFormDataJson('#myForm');
    		var discard_type = formData["discard_type"];
    		var chulha_count = formData["chulha_count"];
            var discard_amount = formData["amount"];
            var modified_amount = formData["modified_amount"];
            var cur_stock = formData["post_amt"];
            console.log(cur_stock);
            var validation = validateModifiedAmount(chulha_count, discard_amount, modified_amount, cur_stock);
            console.log(validation);
            if(!validation) {
            	heneSwal.error('반품 수량은 1보다 작거나 출하수량보다 클 수 없습니다');
            	return false;
            }
          	//수정되는 반품량이 기존 반품량보다 작을 경우에만 재고 체크
          	//수정되는 반품량이 늘어날때는 어차피 재고에 추가되므로 체크할 필요가 없음
            if(discard_amount > modified_amount) { 
            
            var curStockEnough = checkCurStock(discard_amount, modified_amount, cur_stock);
            console.log(curStockEnough);
    		if(!curStockEnough) {
    			heneSwal.warning("현재 재고가 충분하지 않습니다");
    			return false;
    		}
    		
            }
            
    		var JSONparam = JSON.stringify(formData);
    		var confirmEdit = confirm("수정하시겠습니까?");
    		
    		if(confirmEdit) {
    		
    		if(discard_type = "반품") {
    			var compareResult = compareOrgAmtAndModifiedAmt(discard_amount, modified_amount);

    			switch(compareResult) {
    				case "more or less":
    					pid = "M858S040100E202";
    					break;
    				case "same":
    					heneSwal.warning("이전 수량과 변경된 반품 수량이 같습니다");
    					return false;
    				case "err":
    					heneSwal.warning("변경된 반품 수량을 다시 확인해주세요");
    					return false;
    			}
    			
    			/* if(confirmEdit) {
    				sendToServer(JSONparam, pid);
    			} */
    		} else if(discard_type = "폐기") {
    			var compareResult = compareOrgAmtAndModifiedAmt(discard_amount, modified_amount);

    			switch(compareResult) {
    				case "more or less":
    					pid = "M858S040100E212";
    					break;
    				case "same":
    					heneSwal.warning("이전 수량과 변경된 폐기 수량이 같습니다");
    					return false;
    				case "err":
    					heneSwal.warning("변경된 폐기 수량을 다시 확인해주세요");
    					return false;
    				}
    				
    			}
    			sendToServer(JSONparam, pid);
    		}
    	});
        
    	function sendToServer(bomdata, pid) {
    		$.ajax({
    	        type: "POST",
    	        dataType: "json",
    	        url: "<%=Config.this_SERVER_path%>/Contents/CommonView/insert_update_delete_json.jsp", 
    	        data: {"bomdata" : bomdata, "pid" : pid},
    	        success: function (rcvData) {
    	        	if(rcvData > -1) {
    	        		heneSwal.success("수정을 완료했습니다");
    		 	     	$('#modalReport').modal('hide');
    	        		parent.fn_MainInfo_List(startDate, endDate);
    	        	} else {
    	        		heneSwal.error("수정 실패했습니다, 관리자에게 문의해주세요");
    	        	}
    	        },
    	        error: function(rcvData) {
            		heneSwal.error("수정 실패했습니다, 관리자에게 문의해주세요");
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
    			async : false,
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
    });
</script>