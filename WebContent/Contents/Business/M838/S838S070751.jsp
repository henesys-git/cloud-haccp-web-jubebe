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
S838S070751.jsp
제품 및 작업도구 미생물 검사 기록 등록
*/
	String loginID = session.getAttribute("login_id").toString();
	
	String checklist_id = "", checklist_rev_no = "";
	
	if(request.getParameter("checklist_id") != null)
		checklist_id = request.getParameter("checklist_id");	

	if(request.getParameter("checklist_rev_no") != null)
		checklist_rev_no = request.getParameter("checklist_rev_no");
    
%>
<style>
#Info {
	position: absolute;
    top: 93px;
    right: 240px;
}

#Info i {
	color : #E6CCCA;
}

#Info #hoverInfo {
    visibility: hidden;
    width: 140px;
    background-color: #FFE3E0;
    color: #5C5251;
    text-align: center;
    border-radius: 6px;
    padding: 5px 0;
    z-index: 1;
    margin-left: 2px;
    opacity: 0;
    transition: opacity 1s;
    position: absolute;
	top: -33%;
    left: 153%;
}

#Info #hoverInfo::after {
  content: "";
  position: absolute;
  top: 25%;
  right: 100%;
  margin-top: -5px;
  border-width: 5px;
  border-style: solid;
  border-color: transparent #FFE3E0 transparent transparent;
}

#Info:hover #hoverInfo {
  visibility: visible;
  opacity: 100;
}
</style>
<script type="text/javascript">
    $(document).ready(function () {
    	
    	new SetSingleDate2("", "#check_date", 0);
    	new SetSingleDate2("", "#judge_date", 0);

    	$("input:radio:input[value='O']").attr("checked",true);
    	$("input:radio:input[value='1']").attr("checked",true);
    	
		$("select[name^='type_id_']").change(function() {
    		
    		var type_id = $(this).val();
    		var seq = parseInt($(this).attr("name").split("_")[2]);
    		    		
    		$("select[name='type_id_"+(seq+1)+"']").val(type_id);
    		$("select[name='type_id_"+(seq+2)+"']").val(type_id);
    		$("select[name='type_id_"+(seq+3)+"']").val(type_id);
    	});

    });
	
	function getFormData(form) {

		$("select[name^='type_id_']").each(function(){
			$(this).attr("disabled",false);
		});
		
		$("input[name^='specimen_nm_']").each(function() {
    		if($(this).val() == null || $(this).val() == ""){
    			var name = $(this).attr("name");
    			var seq = name.split("_")[2];
    			
    			$("input[name$='_"+seq+"']").val("");
    			$("select[name$='_"+seq+"']").val("");
    		}
    	});
		
	    var array = form.serializeArray();

	    for(var i=0; i<array.length; i++){
	    	
	    	if(array[i].value == ""){
	    		array.splice(i, 1);
	    		i--;
	    	} 
	    		
	    }

	    return array;
	}
	
	function nullCheck() {
		
		var flag = true;
		
		$("input[name^='specimen_nm_']").each(function() {
			
			var name = $(this).attr("name");
			var seq = parseInt(name.split("_")[2]);
			
			if($(this).val() == null || $(this).val() == ""){
    			
    			if(seq == 0){
    				
    				heneSwal.warning('점검표의 첫 줄은 모두 입력해주세요.');
					
					$(this).focus();
					flag = false;
					return false;
    			}
    			
    		} else if($(this).val() != null && $(this).val() != ""){
    			    			
    			$("input[name$='_"+seq+"']").each(function(idx){
    				
    				if($("select[name$='_"+seq+"']").val() == "" || $("select[name$='_"+seq+"']").val() == ""){
    					
						heneSwal.warning('항목을 선택해주세요.');
    					
    					$(this).focus();
    					flag = false;
    					return false;
    					
    				}
    				
    				if($(this).val() == null || $(this).val() == ""){
    					
    					heneSwal.warning('빈칸을 입력해주세요.');
    					
    					$(this).focus();
    					flag = false;
    					return false;
    				}
    				
    			});
    		}
    	});
		
		return flag;
		
	}
	
	function sendToJsp() {
		
		var flag = nullCheck();
		
		if(flag){
		
			var chekrtn = confirm("등록하시겠습니까?");
			
			if(chekrtn) {
				
				var obj = new Object();
				
				obj.person_write_id = "<%=loginID%>";
				obj.checklist_id = '<%=checklist_id%>';
				obj.checklist_rev_no = '<%=checklist_rev_no%>';
				obj.check_date = $('#check_date').val();
				obj.judge_date = $('#judge_date').val();
				obj.result = getFormData($('#form1'));
				
				obj = JSON.stringify(obj);
				
				$.ajax({
			        type: "post",
			        url: "<%=Config.this_SERVER_path%>/Contents/CommonView/insert_update_delete_json.jsp", 
			        data: {bomdata:obj, pid:"M838S070750E101"},
					success: function (html) {
						if(html > -1) {
							
			        		if($("#idFilename").val() == "" || $("#idFilename").val() == null){
								
			        			heneSwal.success('점검표 등록이 완료되었습니다');
	
								$('#modalReport').modal('hide');
				        		parent.fn_MainInfo_List(startDate, endDate);
				        		parent.fn_DetailInfo_List();							
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
	
				        					heneSwal.success('점검표 등록이 완료되었습니다');
	
				        					$('#modalReport').modal('hide');
				        	        		parent.fn_MainInfo_List(startDate, endDate);
				        	        		parent.$('#SubInfo_List_contents').hide();
				        				} else {
				        					heneSwal.errorTimer("점검표 등록 실패했습니다, 다시 시도해주세요");
				        				}
				        			},
				           	        error: function (e) {
				        				$("#result").text(e.responseText);
				           	        }
				           	    });
				                
							}
			        		
			         	} else {
							heneSwal.error('점검표 등록 실패했습니다, 다시 시도해주세요');
			         	}
			         }
				});
			} 
		}
	}
</script>
<form id = "form1" onsubmit="return false;">		
		<table class = "table">
			<tr>
				<th>점검일자</th>
				<th colspan = 2>
					<input id = "check_date" type = "text" data-data-format="yyyy-mm-dd" class="form-control"/>
				</th>
				<th>판독일자</th>
				<th colspan = 3>
					<input id = "judge_date" type = "text" data-data-format="yyyy-mm-dd" class="form-control"/>
				</th>
			</tr>
			<tr align = "center">
				<th colspan = 3>구분</th>
				<th colspan = 3>
					검사결과(CFU/㎠,㎖)
					<p id = "Info"><i class="fas fa-info-circle"></i><br>
					<span id = "hoverInfo">일반세균: 1.0 × 10ⁿ <br>대 장 균: 1.0 × 10³ <br>살모넬라: 불검출 </span></p>
				</th>
				<th rowspan = 2 style = "width: 122px;">평가</th>
			</tr>
			<tr>
				<th style = "width: 136px;">항목</th>
				<th>검체명</th>
				<th style = "width: 111px;">냉장/냉동</th>
				<th style = "width: 135px;">일반세균</th>
				<th style = "width: 135px;">대장균</th>
				<th style = "width: 122px;">불검출</th>
			</tr>
			<% for(int i=0; i<12; i++) { 
				String str = "style = 'opacity: 0;border-top: 0;' disabled";
				if(i%4==0){str = "";} %>
			<tr>
				<td <%= str %>>
					<select name = "type_id_<%=i%>" <%= str %> class="form-control">
						<option value = "">선택</option>
						<option value = "type01" >제품</option>
						<option value = "type02" >작업도구</option>
					</select>
				</td>
				<td> 
					<input type = "text" name = "specimen_nm_<%=i%>" class="form-control"/>
				</td>
				<td>
					<select name = "status_gubun_<%=i%>" class="form-control">
						<option value = "1" >냉장</option>
						<option value = "2" >냉동</option>
					</select>
				</td>
				<td>
					<input type = "text" name = "result1_<%=i%>" class="form-control"/>
				</td>
				<td>
					<input type = "text" name = "result2_<%=i%>" class="form-control"/>
				</td>
				<td>
					<select name = "result3_<%=i%>" class="form-control">
						<option value = "X" >불검출</option>
						<option value = "O" >검출</option>
					</select>
				</td>
				<td>
					<select name = "evaluation_<%=i%>" class="form-control">
						<option value = "O" >적합</option>
						<option value = "X" >부적합</option>
					</select>
				</td>
			</tr>
		<% } %>
		</table>
</form>
<table class="table" id = "fileUpload">
	<tr>
		<td style = "width: 13.8%;">
			첨부자료
		</td>    
	    <td>
			<input type="hidden" class="form-control" id="txt_pid" name="pid"  value="M838S070750E111">
			<input type="hidden" class="form-control" id="txt_user_id" name="user_id"  value="henesys"> 
			<input type="hidden" class="form-control" id="txt_orderno" name="orderno" value="0" > 
			<input type="hidden" class="form-control" id="txt_order_detail" name="order_detail" value="1" > 
			<input type="hidden" class="form-control" id="txt_jspPage" name="jspPage"  value="M838S070751.jsp"> 
			<input type="hidden" class="form-control" id="txt_getnum_prefix" name="getnum_prefix"  value="HACCP"> 
			<input type="hidden" class="form-control" id="txt_JobType" name="JobType" value="INSERT" > 
			<input type="hidden" class="form-control" id="txt_doccode" name="doccode" value = "M838S070750" > 
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