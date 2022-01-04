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
	
	String prod_cd = "", revision_no = "";
	
	if(request.getParameter("prod_cd") != null) {
		prod_cd = request.getParameter("prod_cd");
	}

	if(request.getParameter("revision_no") != null) {
		revision_no = request.getParameter("revision_no");
	}
%>

<form id="formId">
   <table class="table table-hover">
        <tr>
            <td>
            	제품 대분류
            </td>
            <td>
				<input class="form-control" name="prod_gubun_b" readonly>
				<input type="hidden" name="code_value_b" readonly>
           	</td>
		</tr>

		<tr>
            <td>
            	제품 중분류
            </td>
            <td>
				<input class="form-control" name="prod_gubun_m" readonly>
				<input type="hidden" name="code_value_m" readonly>
           	</td>
        </tr>
        
        <tr>
            <td>
            	제품코드
            </td>
            <td>
            	<input type="text" class="form-control" id="prod_cd" name="prod_cd" readonly>
            	<input type="hidden" class="form-control" id="revision_no" name="revision_no">
           	</td>
        </tr>
        
        <tr>
            <td>
            	제품코드2
            </td>
            <td>
            	<input type="text" class="form-control" id="prod_sub_cd" name="prod_sub_cd">
           	</td>
        </tr>

        <tr>
            <td>
            	제품명
            </td>
            <td>
            	<input type="text" class="form-control" id="product_nm" name="product_nm">
           	</td>
        </tr>
        
        <tr>
            <td>
            	제품 개당 중량
            </td>
            <td>
            	<input type="text" class="form-control" placeholder="단위도 함께 입력해주세요 ex) 2kg" id="gugyuk" name="gugyuk">
            	<!-- <div class="input-group">
			      <input type="number" class="form-control" placeholder="kg 단위로 입력해주세요" id="gugyuk" name="gugyuk">
			      <div class="input-group-append">
			        <span class="input-group-text">kg</span>
			      </div>
			    </div> -->
           	</td>
        </tr>
        
        <tr>
            <td>
            	팩당 낱개 수량
            </td>
            <td>
            	<div class="input-group">
			      <input type="number" class="form-control" id="count_in_pack" name="count_in_pack">
			      <div class="input-group-append">
			        <span class="input-group-text">개</span>
			      </div>
			    </div>
           	</td>
        </tr>
        
        <tr>
            <td>
            	박스당 팩 수량
            </td>
            <td>
            	<div class="input-group">
			      <input type="number" class="form-control" id="count_in_box" name="count_in_box">
			      <div class="input-group-append">
			        <span class="input-group-text">팩</span>
			      </div>
			    </div>
           	</td>
        </tr>
        
        <tr>
            <td>
            	안전재고
            </td>
            <td>
            	<div class="input-group">
			      <input type="number" class="form-control" placeholder="낱개 기준으로 입력해주세요" id="safe_stock" name="safe_stock">
			      <div class="input-group-append">
			        <span class="input-group-text">개</span>
			      </div>
			    </div>
           	</td>
        </tr>
        
        <tr>
            <td>
            	포장 비용
            </td>
            <td>
            	<div class="input-group">
			      <input type="number" class="form-control" id="packing_cost" name="packing_cost">
			      <div class="input-group-append">
			        <span class="input-group-text">원</span>
			      </div>
			    </div>
           	</td>
        </tr>
        
        <tr>
            <td>
            	유통기한 기준일
            </td>
            <td>
            	<div class="input-group">
			      <input type="number" class="form-control" placeholder="일 단위로 입력해주세요" id="expiration_date" name="expiration_date">
			      <div class="input-group-append">
			        <span class="input-group-text">일</span>
			      </div>
			    </div>
           	</td>
        </tr>
        
        <tr>
            <td>
            	적용시작일자
            </td>
            <td>
            	<input type="date" id="start_date" class="form-control" name="start_date">
            	<input type="hidden" id="member_key" class="form-control" name="member_key" value='<%=member_key%>'>
           	</td>
        </tr>
    </table>
</form>
    
<script type="text/javascript">
	$(document).ready(function () {
		var obj = new Object();
		
		var pid = "M909S060100E114";
		var prmtr = {
				prod_cd : '<%=prod_cd%>',
				revision_no : '<%=revision_no%>'
		}
		
		prmtr = JSON.stringify(prmtr);
		
		$.ajax({
			type: "POST",
		    dataType: "json",
		 	url: "<%=Config.this_SERVER_path%>/Contents/CommonView/select_json.jsp",
		 	data:  {"prmtr":prmtr, "pid":pid},
		    success: function (data) {
	    		var inputList = new Array();
	    		$("form :input").each(function(){
	    			inputList.push($(this));
	    		});
	    		
				data[0].forEach(function(val, idx, arr) {
					inputList[idx].val(val);
				});
		    },
		    error: function() {
	     		heneSwal.errorTimer("목록 조회 실패", "다시 시도해 주세요");
	     		$('#modalReport').modal('hide');
			}
		});
	});

	function executeQuery() {
		// form validation 채우기 needtocheck
		prod_gubun_b = "",prod_gubun_m = "";
		
		var formData = getFormDataJson('#formId');
		
		$.ajax({
			url: "<%=Config.this_SERVER_path%>/Contents/CommonView/insert_update_delete_json.jsp",
			data : {
				bomdata : JSON.stringify(formData),
				pid : 'M909S060100E102'
			},
			success: function(returnVal) {
				if(returnVal < 1) {
					heneSwal.error('에러 발생, 다시 시도해주세요');
				} else {
					$('#modalReport').modal('hide');
					parent.fn_MainInfo_List();
					heneSwal.success('제품 정보가 수정되었습니다');
				}
			},
			error: function() {
				heneSwal.error('에러 발생, 다시 시도해주세요');
			}
		});
	}
</script>