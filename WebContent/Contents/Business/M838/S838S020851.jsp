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
S838S020851.jsp
작업장 낙하세균 검사 기록 - 등록부분 
*/
	String loginID = session.getAttribute("login_id").toString();
	
	String checklist_id = "", checklist_rev_no = "", regist_seq_no = "";
	
	if(request.getParameter("checklist_id") != null)
		checklist_id = request.getParameter("checklist_id");	

	if(request.getParameter("checklist_rev_no") != null)
		checklist_rev_no = request.getParameter("checklist_rev_no");
	
	if(request.getParameter("regist_seq_no") != null)
		regist_seq_no = request.getParameter("regist_seq_no");
	
%>
<script type="text/javascript">
    $(document).ready(function () {
    	
		new SetSingleDate2("", "#check_date", 0);
		new SetSingleDate2("", "#judge_date", 0);
		
		 $(".btn_plus").click(function(){ 
			 
	    	var type_name = $(this).closest("tr").children("td:first").text();
	   		
	    	var type_id = $(this).closest("tr").children("td:first").attr("id");
	    	
	    	var rows = $(".type_id:contains(" +  type_name + ")");
	    	
	    	if(rows.length < 3){
	    		
	    		var valArr = new Array();
		    	
		    	valArr.push(type_id);
		    	valArr.push(type_name);
		    	
				 fn_plus_body(valArr);
	    	}
	    				     	
	     }); 
		 	    
    });	
	
    function fn_plus_body(arr) {
    	
    	var html = " <tr> "+
    			   "<td id = '"+arr[0]+"' class = 'type_id' style = 'opacity:0; border-top:0;' > "+
    			   arr[1]+
    			   "<input type='hidden' value = '"+arr[0]+"' name = 'type_id' />"	+	
    		  	   "</td>" +
    			   " <td> "+
  				   "	<input type='text' class='form-control' name = 'LOCATION'>	"+
  				   "</td> " +
  				   " <td> "+
  				   "	<input type='text' class='form-control' name = 'result'>	"+
  				   "</td> " +
  				   " <td> "+
				   "	<input type='text' class='form-control'  name = 'evaluation'>	"+
				   "</td> " +
				   " <td> "+
 				   "	<input type='text' class='form-control' name = 'bigo_detail'>	"+
 				   "</td> " + 
 				  " <td> "+
 				  "		<button class='btn btn-info btn-sm btn_minus' onclick = 'fn_minus_body(this);'>" +
 				  " 		<i class='fas fa-minus'></i> " +
 				  "		</button>" +
 				  "</td> "+
 				  "</tr> ";
    	
    	$("#"+arr[0]).closest("tr").eq(-1).after(html);
    	
    }
    
    function fn_minus_body(obj) {
    	
    	var td = $(obj);
    	
    	var tr = td.closest("tr")
    	
    	if(tr.children("td:first").text() != tr.next().children("td:first").text()){
    		
    		tr.prev().children("td:first").eq(0).attr("rowspan", 1);
        	tr.next().children("td:first").eq(0).show();
    		
    	} else if(tr.children("td:first").text() != tr.prev().prev().children("td:first").text()) {
    		
    		tr.prev().prev().children("td:first").eq(0).attr("rowspan", 1);
    	}
    	    	
    	tr.remove();
    }
    
	function SaveOderInfo() {
		
		var flag = true;
		
		$("#germ_frm input").each(function(idx) {
			
			if(($(this).val() == null || $(this).val() == "" ) && $(this).attr("name") != "bigo_detail"){
				
				heneSwal.warning('비고 제외 빈칸을 모두 입력해주세요.');
				$(this).focus();
			
				flag = false;
				
				return false;
			}	
			
		});
		
		if(flag){
			
			var dataJson = new Object();
	        
	 		dataJson.checklist_id = '<%=checklist_id%>';
	 	 	dataJson.check_date = $('#check_date').val();
	 	 	dataJson.judge_date = $('#judge_date').val();
			dataJson.form = $("#germ_frm").serializeArray();
		 	
			var JSONparam = JSON.stringify(dataJson);
			var chekrtn = confirm("등록하시겠습니까?");
			
			if(chekrtn) {
				SendTojsp(JSONparam, "M838S020850E101");
			}
			
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
					if($("#idFilename").val() == "" || $("#idFilename").val() == null){
						
	        			heneSwal.success('기록부 등록이 완료되었습니다');

						$('#modalReport').modal('hide');
		        		parent.fn_MainInfo_List(startDate, endDate);
		        		parent.$('#SubInfo_List_contents').hide();
						
					} else {
						
		            	var form = $('#upload_form')[0];
		            	
						var data = new FormData(form);
		                
		                data.append("pid", 			$('#txt_pid').val());
		                data.append("user_id", 		$('#txt_user_id').val());
		                data.append("orderno", 		$('#txt_orderno').val());
		                data.append("order_detail", $('#txt_order_detail').val());
		                data.append("jspPage", 		$('#txt_jspPage').val());
		                data.append("getnum_prefix",$('#txt_getnum_prefix').val());
		                data.append("JobType", 		$('#txt_JobType').val());

		                data.append("regist_no", 	"");
		                data.append("docname", 		$('#txt_docname').val());
		                data.append("doccode", 		$('#txt_doccode').val());
		                data.append("rev_no", 		$('#txt_rev_no').val());
		                data.append("doc_gubun", 	$('#txt_doc_gubun').val());
		                
		                data.append("member_key", '107-86-81841'); 		// 관리본여부

		           	    $.ajax({
		        			type: "POST",
		        			async: true,
		           	        enctype: "multipart/form-data",
		           	        acceptcharset: "UTF-8",
		           	        url: "<%= request.getContextPath() %>/hcp_EdmsServerServlet", 
		           	        data: data,
		           	        processData: false,
		           	        contentType: false,
		        			cache: false,
		           	        timeout: 600000,
		           	        success: function (data) {
		        				if(data.length > 0) {

		        					heneSwal.success('기록부 등록이 완료되었습니다');

		        					$('#modalReport').modal('hide');
		        	        		parent.fn_MainInfo_List(startDate, endDate);
		        	        		parent.$('#SubInfo_List_contents').hide();
		        				} else {
		        					heneSwal.errorTimer("기록부 등록 실패했습니다, 다시 시도해주세요");
		        				}
		        			},
		           	        error: function (e) {
		        				$("#result").text(e.responseText);
		           	        }
		           	    });
		                
					}
	         	} else {
					heneSwal.error('기록부 등록 실패했습니다, 다시 시도해주세요');
	         	}
	         }
	     });
	}
</script>

<form id = "germ_frm" onSubmit = "return false;" >
	<table class="table" id = "germ_table">
		<tr>
			<td colspan = "3" align="left">
				검사일자
				<input type="text" data-date-format="yyyy-mm-dd" id="check_date" class="form-control" style = "display : inline-block; width : 56%; margin-left : 2%;">
			</td>
			<td colspan = "3" align="right">
				판독일자
				<input type="text" data-date-format="yyyy-mm-dd" id="judge_date" class="form-control" style = "display : inline-block; width : 56%; margin-left : 2%;">
			</td>
		</tr>
		<tr>
			<th>구분</th>
			<th>
				위치
			</th>
		    <th>
				낙하세균 결과
			</th>
			<th>
				낙하세균 평가
			</th>
		    <th>
				비고
			</th>
			<td>
	           	<!-- <button id="btn_mius" class="btn btn-info btn-sm">
					<i class="fas fa-minus"></i>
				</button> -->
			</td>
		</tr>
	   	<tr>
	 		<td id = "type01">
				청결구역
				<input type="hidden" value = "type01" name = "type_id"/>	
	  		</td>
	  		<td> 
	  			<input type="text" class="form-control" id="LOCATION_1" name = "LOCATION">
	  		</td>
	  		<td>
	  			<input type="text" class="form-control" id="result_1" name = "result">
	  		</td>
	  		<td>
	  			<input type="text" class="form-control" id="evaluation_1" name = "evaluation">
	  		</td>
	  		<td>
	  			<input type="text" class="form-control" id="bigo_detail_1" name = "bigo_detail">
	  		</td>
	  		<td>
	  			<button class="btn btn-info btn-sm btn_plus">
	           		<i class="fas fa-plus"></i>
	           	</button>
	  		</td>
	  	</tr>
	 	<tr>
	 		<td id = "type02">
				준청결구역
				<input type="hidden" value = "type02" name = "type_id"/>	
	  		</td>
	  		<td> 
	  			<input type="text" class="form-control" id="LOCATION_2" name = "LOCATION">
	  		</td>
	  		<td>
	  			<input type="text" class="form-control" id="result_2" name = "result">
	  		</td>
	  		<td>
	  			<input type="text" class="form-control" id="evaluation_2" name = "evaluation">
	  		</td>
	  		<td>
	  			<input type="text" class="form-control" id="bigo_detail_2" name = "bigo_detail">
	  		</td>
	  		<td>
	  			<button class="btn btn-info btn-sm btn_plus">
	           		<i class="fas fa-plus"></i>
	           	</button>
	  		</td>
	  	</tr>
	  	<tr>
	 		<td id = "type03">
				일반구역
				<input type="hidden" value = "type03" name = "type_id"/>		
	  		</td>
	  		<td> 
	  			<input type="text" class="form-control" id="LOCATION_3" name = "LOCATION">
	  		</td>
	  		<td>
	  			<input type="text" class="form-control" id="result_3" name = "result">
	  		</td>
	  		<td>
	  			<input type="text" class="form-control" id="evaluation_3" name = "evaluation">
	  		</td>
	  		<td>
	  			<input type="text" class="form-control" id="bigo_detail_3" name = "bigo_detail">
	  		</td>
	  		<td>
	  			<button class="btn btn-info btn-sm btn_plus">
	           		<i class="fas fa-plus"></i>
	           	</button>
	  		</td>
	  	</tr>
	</table>
</form>
<table class = "table">
	<tr>
		<td style = "width: 10%;">
			첨부파일
		</td>    
	    <td>
			<input type="hidden" class="form-control" id="txt_pid" name="pid"  value="M838S020850E111">
			<input type="hidden" class="form-control" id="txt_user_id" name="user_id"  value="henesys"> 
			<input type="hidden" class="form-control" id="txt_orderno" name="orderno" value="0" > 
			<input type="hidden" class="form-control" id="txt_order_detail" name="order_detail" value="1" > 
			<input type="hidden" class="form-control" id="txt_jspPage" name="jspPage"  value="M838S020851.jsp"> 
			<input type="hidden" class="form-control" id="txt_getnum_prefix" name="getnum_prefix"  value="HACCP"> 
			<input type="hidden" class="form-control" id="txt_JobType" name="JobType" value="INSERT" > 
			<input type="hidden" class="form-control" id="txt_doccode" name="doccode" value = "M838S020850" > 
			<input type="hidden" class="form-control" id="txt_rev_no" name="rev_no" > 
			<input type="hidden" class="form-control" id="txt_doc_gubun" name="doc_gubun" > 
	   		<!-- ///////////////////////////////////////////////////////////////////////////////////  -->
			<input type="hidden" id="attached_document" class="form-control">
			<form id="upload_form" enctype="multipart/form-data" action="<%= request.getContextPath() %>/hcp_EdmsServerServlet" method="post">
				<input type="file" id="idFilename" name="filenames" multiple="multiple" class="form-control" style = "height: 0%;">
			</form>
		</td>
	</tr>
</table>