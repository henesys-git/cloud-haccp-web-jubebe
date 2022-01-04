<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*,java.util.*,javax.servlet.http.*"%>
<%@ page import="mes.client.comm.*" %>
<%@ page import="mes.client.common.*" %>
<%@ page import="mes.client.guiComponents.*" %>
<%@ page import="mes.client.util.*" %>
<%@ page import="mes.client.conf.*" %>
<%@ page import="org.json.simple.*"%><%@ include file="/strings.jsp" %>
<%
/* 
S838S015411.jsp
CCP-4P 모니터링일지 등록
*/
	String loginID = session.getAttribute("login_id").toString();
	String member_key = session.getAttribute("member_key").toString();
	
	String checklist_id = "", checklist_rev_no = "", ccp_date = "";
	
	if(request.getParameter("checklist_id") != null)
		checklist_id = request.getParameter("checklist_id");	

	if(request.getParameter("checklist_rev_no") != null)
		checklist_rev_no = request.getParameter("checklist_rev_no");
	
	if(request.getParameter("ccp_date") != null)
		ccp_date = request.getParameter("ccp_date");
%>
    
<script type="text/javascript">
    $(document).ready(function () {
		
	
		
		
		
		
		// 제품명 input tag 클릭 시 제품 검색 팝업 생성
	    $('#prod_nm').click(function() {
	    	parent.pop_fn_ProductName_View(2,'01')
	    });
		
    });
	
    // 제품 검색 후 클릭한 데이터를 가져옴
    function SetProductName_code(prodName, prodCode, prodRevNo, 
    							 prodGyugyuk, safeStock, curStock) {
    	
    	$('#prod_nm').val(prodName);
    	$('#prod_cd').val(prodCode);
    	$('#revision_no').val(prodRevNo);
    }
	
	function SaveOderInfo() {
    	
	        var dataJson = new Object();
	        
										
			dataJson.checklist_id = '<%=checklist_id%>';
			dataJson.checklist_rev_no = '<%=checklist_rev_no%>';
			dataJson.check_time = $('#check_time').val();
			dataJson.prod_cd = $('#prod_cd').val();
			dataJson.revision_no = $('#revision_no').val();
			dataJson.fe_only_1 = $("input[name='fe_only_1']:checked").val();
			dataJson.fe_only_2 = $("input[name='fe_only_2']:checked").val();
			dataJson.fe_only_3 = $("input[name='fe_only_3']:checked").val();
			dataJson.sus_only_1 = $("input[name='sus_only_1']:checked").val();
			dataJson.sus_only_2 = $("input[name='sus_only_2']:checked").val();
			dataJson.sus_only_3 = $("input[name='sus_only_3']:checked").val();
			dataJson.prod_only_1 = $("input[name='prod_only_1']:checked").val();
			dataJson.prod_only_2 = $("input[name='prod_only_2']:checked").val();
			dataJson.prod_only_3 = $("input[name='prod_only_3']:checked").val();
			dataJson.fe_with_prod_1 = $("input[name='fe_with_prod_1']:checked").val();
			dataJson.fe_with_prod_2 = $("input[name='fe_with_prod_2']:checked").val();
			dataJson.fe_with_prod_3 = $("input[name='fe_with_prod_3']:checked").val();
			dataJson.fe_with_prod_4 = $("input[name='fe_with_prod_4']:checked").val();
			dataJson.fe_with_prod_5 = $("input[name='fe_with_prod_5']:checked").val();
			dataJson.sus_with_prod_1 = $("input[name='sus_with_prod_1']:checked").val();
			dataJson.sus_with_prod_2 = $("input[name='sus_with_prod_2']:checked").val();
			dataJson.sus_with_prod_3 = $("input[name='sus_with_prod_3']:checked").val();
			dataJson.sus_with_prod_4 = $("input[name='sus_with_prod_4']:checked").val();
			dataJson.sus_with_prod_5 = $("input[name='sus_with_prod_5']:checked").val();
			dataJson.result = $("input[name='result']:checked").val();
			dataJson.ccp_date = '<%=ccp_date%>;'
			dataJson.note_unusual = $('#note_unusual').val();
        	
			var JSONparam = JSON.stringify(dataJson);
			var chekrtn = confirm("등록하시겠습니까?"); 
			
			if(chekrtn) {
				SendTojsp(JSONparam, "M838S015400E111");
			}
		
	}

	function SendTojsp(bomdata, pid) {
	    $.ajax({
	        type: "POST",
	        dataType: "json",
	        url: "<%=Config.this_SERVER_path%>/Contents/CommonView/insert_update_delete_json.jsp", 
	        data:  {"bomdata" : bomdata, "pid" : pid},
			success: function (html) {	
				if(html > -1) {
					heneSwal.success('측정일지 등록이 완료되었습니다');

					$('#modalReport').modal('hide');
	        		parent.fn_MainInfo_List(startDate, endDate);
	         	} else {
					heneSwal.error('측정일지 등록 실패했습니다, 다시 시도해주세요');	         		
	         	}
	         }
	     });
	}
</script>

<div class="container">
	<div class="row">
		<div class="col-5">
	  	</div>
	  	<div class="col-3">
	  		통과시간
	  	</div>
	  	<div class="col-4">
		  	<input type="time" id="check_time" class="form-control">
	  	</div>
	</div>
	<div class="row">
		<div class="col-5">
	  	</div>
	  	<div class="col-3">
	  		제품명
	  	</div>
	  	<div class="col-4">
		  	<input type="text"	 id="prod_nm" class="form-control" readonly>
		  	<input type="hidden" id="prod_cd" class="form-control">
		  	<input type="hidden" id="revision_no" class="form-control">
	  	</div>
	</div>
	
	
		<div class="row">
			<div class="col-2 border" id="fe_only">Fe만 통과</div>
		    <div class="col-10 border">
		      	<div class="row border">
			      	<div class="col-7 border" id="fe_only_1">
			      	좌	
			      	</div>
			      	<div class="col-2 border form-check form-check-inline">
					  <input class="form-check-input" type="radio" id="fe_only_1_y" value="O" checked name="fe_only_1">
					  <label class="form-check-label" for="type01_1_y">O</label>
					</div>
					<div class="col-2 border form-check form-check-inline">
					  <input class="form-check-input" type="radio" id="fe_only_1_n" value="X" name="fe_only_1">
					  <label class="form-check-label" for="fe_only_1_n">X</label>
					</div>
		      	</div>
			  	<div class="row border">
			      	<div class="col-7 border" id="fe_only_2">
			      	중	
			      	</div>
			      	<div class="col-2 border form-check form-check-inline">
					  <input class="form-check-input" type="radio" id="fe_only_2_y" value="O" checked name="fe_only_2">
					  <label class="form-check-label" for="fe_only_2_y">O</label>
					</div>
					<div class="col-2 border form-check form-check-inline">
					  <input class="form-check-input" type="radio" id="fe_only_2_n" value="X" name="fe_only_2">
					  <label class="form-check-label" for="fe_only_2_n">X</label>
					</div>
		      	</div>
		      	<div class="row border">
			      	<div class="col-7 border" id="fe_only_3">
			      	우	
			      	</div>
			      	<div class="col-2 border form-check form-check-inline">
					  <input class="form-check-input" type="radio" id="fe_only_3_y" value="O" checked name="fe_only_3">
					  <label class="form-check-label" for="fe_only_3_y">O</label>
					</div>
					<div class="col-2 border form-check form-check-inline">
					  <input class="form-check-input" type="radio" id="fe_only_3_n" value="X" name="fe_only_3">
					  <label class="form-check-label" for="fe_only_3_n">X</label>
					</div>
		      	</div>
			</div>
		</div>
	
	
		<div class="row">
			<div class="col-2 border" id="sus_only">SUS만 통과</div>
		    <div class="col-10 border">
		      	<div class="row border">
			      	<div class="col-7 border" id="sus_only_1">
			      	좌
			      	</div>
			      	<div class="col-2 border form-check form-check-inline">
					  <input class="form-check-input" type="radio" id="sus_only_1_y" value="O" checked name="sus_only_1">
					  <label class="form-check-label" for="sus_only_1_y">O</label>
					</div>
					<div class="col-2 border form-check form-check-inline">
					  <input class="form-check-input" type="radio" id="sus_only_1_n" value="X" name="sus_only_1">
					  <label class="form-check-label" for="sus_only_1_n">X</label>
					</div>
		      	</div>
		      	<div class="row border">
			      	<div class="col-7 border" id="sus_only_2">
			      	중
			      	</div>
			      	<div class="col-2 border form-check form-check-inline">
					  <input class="form-check-input" type="radio" id="sus_only_2_y" value="O" checked name="sus_only_2">
					  <label class="form-check-label" for="sus_only_2_y">O</label>
					</div>
					<div class="col-2 border form-check form-check-inline">
					  <input class="form-check-input" type="radio" id="sus_only_2_n" value="X" name="sus_only_2">
					  <label class="form-check-label" for="sus_only_2_n">X</label>
					</div>
		      	</div>
		      	<div class="row border">
			      	<div class="col-7 border" id="sus_only_3">
			      	우
			      	</div>
			      	<div class="col-2 border form-check form-check-inline">
					  <input class="form-check-input" type="radio" id="sus_only_3_y" value="O" checked name="sus_only_3">
					  <label class="form-check-label" for="sus_only_3_y">O</label>
					</div>
					<div class="col-2 border form-check form-check-inline">
					  <input class="form-check-input" type="radio" id="sus_only_3_n" value="X" name="sus_only_3">
					  <label class="form-check-label" for="sus_only_3_n">X</label>
					</div>
		      	</div>
			</div>
		</div>
	
	
	
		<div class="row">
			<div class="col-2 border" id="prod_only">제품만 통과</div>
		    <div class="col-10 border">
		      	<div class="row border">
			      	<div class="col-7 border" id="prod_only_1">
			      	좌	
			      	</div>
			      	<div class="col-2 border form-check form-check-inline">
					  <input class="form-check-input" type="radio" id="prod_only_1_y" value="O" checked name="prod_only_1">
					  <label class="form-check-label" for="prod_only_1_y">O</label>
					</div>
					<div class="col-2 border form-check form-check-inline">
					  <input class="form-check-input" type="radio" id="prod_only_1_n" value="X" name="prod_only_1">
					  <label class="form-check-label" for="prod_only_1_n">X</label>
					</div>
		      	</div>
		      	<div class="row border">
			      	<div class="col-7 border" id="prod_only_2">
			      	중	
			      	</div>
			      	<div class="col-2 border form-check form-check-inline">
					  <input class="form-check-input" type="radio" id="prod_only_2_y" value="O" checked name="prod_only_2">
					  <label class="form-check-label" for="prod_only_2_y">O</label>
					</div>
					<div class="col-2 border form-check form-check-inline">
					  <input class="form-check-input" type="radio" id="prod_only_2_n" value="X" name="prod_only_2">
					  <label class="form-check-label" for="prod_only_2_n">X</label>
					</div>
		      	</div>
		      	<div class="row border">
			      	<div class="col-7 border" id="prod_only_3">
			      	우	
			      	</div>
			      	<div class="col-2 border form-check form-check-inline">
					  <input class="form-check-input" type="radio" id="prod_only_3_y" value="O" checked name="prod_only_3">
					  <label class="form-check-label" for="prod_only_3_y">O</label>
					</div>
					<div class="col-2 border form-check form-check-inline">
					  <input class="form-check-input" type="radio" id="prod_only_3_n" value="X" name="prod_only_3">
					  <label class="form-check-label" for="prod_only_3_n">X</label>
					</div>
		      	</div>
			</div>
		</div>
		
		<div class="row">
			<div class="col-2 border" id="fe_with_prod">Fe+제품 통과</div>
		    <div class="col-10 border">
		      	<div class="row border">
			      	<div class="col-7 border" id="fe_with_prod_1">
			      	좌	
			      	</div>
			      	<div class="col-2 border form-check form-check-inline">
					  <input class="form-check-input" type="radio" id="fe_with_prod_1_y" value="O" checked name="fe_with_prod_1">
					  <label class="form-check-label" for="fe_with_prod_1_y">O</label>
					</div>
					<div class="col-2 border form-check form-check-inline">
					  <input class="form-check-input" type="radio" id="fe_with_prod_1_n" value="X" name="fe_with_prod_1">
					  <label class="form-check-label" for="fe_with_prod_1_n">X</label>
					</div>
		      	</div>
		      	<div class="row border">
			      	<div class="col-7 border" id="fe_with_prod_2">
			      	중	
			      	</div>
			      	<div class="col-2 border form-check form-check-inline">
					  <input class="form-check-input" type="radio" id="fe_with_prod_2_y" value="O" checked name="fe_with_prod_2">
					  <label class="form-check-label" for="fe_with_prod_2_y">O</label>
					</div>
					<div class="col-2 border form-check form-check-inline">
					  <input class="form-check-input" type="radio" id="fe_with_prod_2_n" value="X" name="fe_with_prod_2">
					  <label class="form-check-label" for="fe_with_prod_2_n">X</label>
					</div>
		      	</div>
		      	<div class="row border">
			      	<div class="col-7 border" id="fe_with_prod_3">
			      	우	
			      	</div>
			      	<div class="col-2 border form-check form-check-inline">
					  <input class="form-check-input" type="radio" id="fe_with_prod_3_y" value="O" checked name="fe_with_prod_3">
					  <label class="form-check-label" for="fe_with_prod_3_y">O</label>
					</div>
					<div class="col-2 border form-check form-check-inline">
					  <input class="form-check-input" type="radio" id="fe_with_prod_3_n" value="X" name="fe_with_prod_3">
					  <label class="form-check-label" for="fe_with_prod_3_n">X</label>
					</div>
		      	</div>
		      	<div class="row border">
			      	<div class="col-7 border" id="fe_with_prod_4">
			      	위	
			      	</div>
			      	<div class="col-2 border form-check form-check-inline">
					  <input class="form-check-input" type="radio" id="fe_with_prod_4_y" value="O" checked name="fe_with_prod_4">
					  <label class="form-check-label" for="fe_with_prod_4_y">O</label>
					</div>
					<div class="col-2 border form-check form-check-inline">
					  <input class="form-check-input" type="radio" id="fe_with_prod_4_n" value="X" name="fe_with_prod_4">
					  <label class="form-check-label" for="fe_with_prod_4_n">X</label>
					</div>
		      	</div>
		      	<div class="row border">
			      	<div class="col-7 border" id="fe_with_prod_5">
			      	아래	
			      	</div>
			      	<div class="col-2 border form-check form-check-inline">
					  <input class="form-check-input" type="radio" id="fe_with_prod_5_y" value="O" checked name="fe_with_prod_5">
					  <label class="form-check-label" for="fe_with_prod_5_y">O</label>
					</div>
					<div class="col-2 border form-check form-check-inline">
					  <input class="form-check-input" type="radio" id="fe_with_prod_5_n" value="X" name="fe_with_prod_5">
					  <label class="form-check-label" for="fe_with_prod_5_n">X</label>
					</div>
		      	</div>
			</div>
		</div>
		
		<div class="row">
			<div class="col-2 border" id="sus_with_prod">SUS+제품 통과</div>
		    <div class="col-10 border">
		      	<div class="row border">
			      	<div class="col-7 border" id="sus_with_prod_1">
			      	좌	
			      	</div>
			      	<div class="col-2 border form-check form-check-inline">
					  <input class="form-check-input" type="radio" id="sus_with_prod_1_y" value="O" checked name="sus_with_prod_1">
					  <label class="form-check-label" for="sus_with_prod_1_y">O</label>
					</div>
					<div class="col-2 border form-check form-check-inline">
					  <input class="form-check-input" type="radio" id="sus_with_prod_1_n" value="X" name="sus_with_prod_1">
					  <label class="form-check-label" for="sus_with_prod_1_n">X</label>
					</div>
		      	</div>
		      	<div class="row border">
			      	<div class="col-7 border" id="sus_with_prod_2">
			      	중	
			      	</div>
			      	<div class="col-2 border form-check form-check-inline">
					  <input class="form-check-input" type="radio" id="sus_with_prod_2_y" value="O" checked name="sus_with_prod_2">
					  <label class="form-check-label" for="sus_with_prod_2_y">O</label>
					</div>
					<div class="col-2 border form-check form-check-inline">
					  <input class="form-check-input" type="radio" id="sus_with_prod_2_n" value="X" name="sus_with_prod_2">
					  <label class="form-check-label" for="sus_with_prod_2_n">X</label>
					</div>
		      	</div>
		      	<div class="row border">
			      	<div class="col-7 border" id="sus_with_prod_3">
			      	우	
			      	</div>
			      	<div class="col-2 border form-check form-check-inline">
					  <input class="form-check-input" type="radio" id="sus_with_prod_3_y" value="O" checked name="sus_with_prod_3">
					  <label class="form-check-label" for="sus_with_prod_3_y">O</label>
					</div>
					<div class="col-2 border form-check form-check-inline">
					  <input class="form-check-input" type="radio" id="sus_with_prod_3_n" value="X" name="sus_with_prod_3">
					  <label class="form-check-label" for="sus_with_prod_3_n">X</label>
					</div>
		      	</div>
		      	<div class="row border">
			      	<div class="col-7 border" id="sus_with_prod_4">
			      	위	
			      	</div>
			      	<div class="col-2 border form-check form-check-inline">
					  <input class="form-check-input" type="radio" id="sus_with_prod_4_y" value="O" checked name="sus_with_prod_4">
					  <label class="form-check-label" for="sus_with_prod_4_y">O</label>
					</div>
					<div class="col-2 border form-check form-check-inline">
					  <input class="form-check-input" type="radio" id="sus_with_prod_4_n" value="X" name="sus_with_prod_4">
					  <label class="form-check-label" for="sus_with_prod_4_n">X</label>
					</div>
		      	</div>
		      	<div class="row border">
			      	<div class="col-7 border" id="sus_with_prod_5">
			      	아래	
			      	</div>
			      	<div class="col-2 border form-check form-check-inline">
					  <input class="form-check-input" type="radio" id="sus_with_prod_5_y" value="O" checked name="sus_with_prod_5">
					  <label class="form-check-label" for="sus_with_prod_5_y">O</label>
					</div>
					<div class="col-2 border form-check form-check-inline">
					  <input class="form-check-input" type="radio" id="sus_with_prod_5_n" value="X" name="sus_with_prod_5">
					  <label class="form-check-label" for="sus_with_prod_5_n">X</label>
					</div>
		      	</div>
			</div>
		</div>
		
		<div class="col-6 border">
			<div class="row border">
				특이사항
			</div>
		    <div class="row border">
		      <input class="form-input" type="text" id="note_unusual">
			</div>
		</div>
		<div class="col-6 border">
			<div class="row border">
				판정
			</div>
		    <div class="row border">
		    <div class="col-2 border form-check form-check-inline">
		      <input class="form-input" type="radio" id="result_y" value="O" checked name="result">
		      <label class="form-check-label" for="result_y">O</label>
		      </div>
		    <div class="col-2 border form-check form-check-inline">
		      <input class="form-input" type="radio" id="result_n" value="X" name="result">
		      <label class="form-check-label" for="result_n">X</label>
		      </div>
			</div>
		</div>
		
	</div>
		
