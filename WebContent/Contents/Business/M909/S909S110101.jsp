<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*,java.util.*,javax.servlet.http.*"%>
<%@ page import="mes.client.comm.*" %>
<%@ page import="mes.client.common.*" %>
<%@ page import="mes.client.guiComponents.*" %>
<%@ page import="mes.client.util.*" %>
<%@ page import="mes.client.conf.*" %>
<%
	String loginID = session.getAttribute("login_id").toString();
	String member_key = session.getAttribute("member_key").toString();

	DoyosaeTableModel TableModel;
    Vector optCode = null;
    Vector optName = null;
    Vector partgubun_bigVector = PartListComboData.getPartBigGubunDataAll(member_key);
    Vector partgubun_midVector = PartListComboData.getPartMidGubunDataAll("",member_key);
	
	String GV_PART_CD = "", GV_REVISION_NO = "", GV_PART_GUBUN_B = "", 
		   GV_PART_GUBUN_M = "", GV_PART_GUBUN_S = "", GV_GYUGYEOK = "", 
		   GV_PART_LEVEL = "";
	CurrentPage jspPageName = new CurrentPage(request.getRequestURI());	
	String JSPpage = jspPageName.GetJSP_FileName();
%>

<script type="text/javascript">
	var part_code = "";
	
	$(document).ready(function () {
		
	    /* function bigChage() {
			$("#partGubunMidSelector > option").show();
			
			//대분류 "전체"를 선택 했을 경우
	    	if($("#partGubunBigSelector").val() == "ALL") { 
	    		$("#partGubunMidSelector > option:eq(0)").prop("selected", true);
	    		return true;
	    	}
	    } */
	    
	    $('#partGubunMidSelector').attr('disabled', true);
	    
	    $("#partGubunBigSelector").on("change", function() {
	    	$('#partGubunMidSelector').attr('disabled', false);
	    	$("#txt_PartCd_big").val("");
			$("#txt_PartCd_mid").val("");
			$("#txt_PartCd").val("");
			
			var bigGubun =$("#partGubunBigSelector").val();
			
			if($("#partGubunBigSelector").val() == "ALL") {
				bigGubun ="";
			}
	    	
			//대분류 선택시 part_cd에 값 셋팅
			$.ajax({
		    	type: "POST",
		    	url: "<%=Config.this_SERVER_path%>/Contents/Business/M909/S909S110200.jsp",
		        data: "partgubun_big="+ bigGubun ,
		        success: function (html) {
	                $("#partGubunMidSelector > option").remove();
	                var changMidResult = html.split("|");
	                for(var i=0; i<changMidResult.length; i++) {
	                	var value = changMidResult[i].split(",")[0]
	                	var name  = changMidResult[i].split(",")[1].trim();
		                $("#partGubunMidSelector").append("<option value="+value+">"+name+"</option>");
	                	
	                }
	                if($("#partGubunBigSelector").val()=="ALL") {
	                	$("#partGubunMidSelector").prepend("<option value='ALL'>전체</option>"); 
	                	$('#partGubunMidSelector').attr('disabled', true);
	                	
	                }
	                if($("#partGubunBigSelector").val() != null 
	                		&& $("#partGubunBigSelector").val() != "ALL") {
		                $("#txt_PartCd_big").val($("#partGubunBigSelector").val());
		                $("#txt_PartCd_mid").val($("#partGubunMidSelector > option:eq(0)").val());
		                //$("#txt_PartCd").val($("#partGubunMidSelector > option:eq(0)").val());
	                }
	                
	                $("#partGubunMidSelector > option:eq(0)").prop("selected", true);

	                <%-- $.ajax({
	   		            type: "POST",
	   		            url: "<%=Config.this_SERVER_path%>/Contents/Business/M909/S909S110200.jsp",
	   		            data: "partgubun_big=" + $("#partGubunBigSelector").val() +
	   		            	  "&partgubun_mid=" + $("#partGubunMidSelector").val() +"&max=1",
	   		            success: function (maxValue) {
	   		            	var al = maxValue.substr(0,1);
	   		            	var no = numpad(parseInt(maxValue.substr(1,3))+1,3);
	   		            	$("#txt_PartCd").val(al+no);                 	
	   		            }
	     		    }); --%>
				}
			});
	    });
	    
	});
    
    $("#partGubunMidSelector").on("change", function() {
    	$("#txt_PartCd_mid").val("");
		$("#txt_PartCd").val("");
		
		//중분류 선택시 part_cd에 값 셋팅
    	if($("#partGubunMidSelector").val() != null 
    			&& $("#partGubunMidSelector").val() != "ALL") {
    		$("#txt_PartCd_mid").val($("#partGubunMidSelector").val());
    	}
		
		<%-- var big = $("#partGubunBigSelector").val();
		var mid = $("#partGubunMidSelector").val();
		
    	$.ajax({
	    	type: "POST",
	        url: "<%=Config.this_SERVER_path%>/Contents/Business/M909/S909S110200.jsp",
	        data: "partgubun_big=" + big +"&partgubun_mid=" + mid + "&max=1",
			success: function (maxValue) {
				var al = maxValue.substr(0,1);
	            var no = numpad(parseInt(maxValue.substr(1,3))+1,3);
	            $("#txt_PartCd").val(al+no);                  	
			}
		}); --%>
	});

	function SaveOderInfo() {
		
		if ($('#partGubunBigSelector').val().length < 1 
				|| $('#partGubunBigSelector').val() == "ALL") {
			heneSwal.warningTimer("대분류를 선택 해주세요.");
			return;
		} else if($('#partGubunMidSelector').val().length < 1 
				|| $('#partGubunMidSelector').val() == "ALL") {
			heneSwal.warningTimer("중분류를 선택 해주세요.");
			return;
		}
		
		var dataJson = new Object();
		dataJson.member_key = "<%=member_key%>";
		dataJson.partgubun_big = $("#partGubunBigSelector option:selected").val();
		dataJson.partgubun_mid = $("#partGubunMidSelector option:selected").val();
		dataJson.PartCd = $("#txt_PartCd").val();
		dataJson.packing_qtty = $('#txt_packing_qtty').val();
		dataJson.gyugyeok = $("#gyugyeok").val();
		dataJson.unit_type = $("#select_unit_type").val();
	    dataJson.PartName = $('#txt_PartName').val();
	    dataJson.UnitPrice = $('#txt_UnitPrice').val();
	    dataJson.saftyCount = $('#txt_saftyCount').val();
	    dataJson.user_id = "<%=loginID%>";
			
		$.ajax({
			type: "POST",
			url: "<%=Config.this_SERVER_path%>/Contents/Business/M909/S909S110104.jsp", 
			data: "Page=<%=JSPpage%>"+"&Part_cd=" + $('#txt_PartCd').val(),	         
			success: function (html) {
		    	if(html > 0) {
		   			heneSwal.alert("이미 등록되어 있습니다");
		   			return;
			    } else {
		   			if(confirm("등록하시겠습니까?")) {
						sendToServer(JSON.stringify(dataJson), "M909S110100E111");	
			        }
			    }
		 	}
		});
	}

	function sendToServer(bomdata, pid) {
		
	    $.ajax({
	    	type: "POST",
	        dataType: "json",
	        url: "<%=Config.this_SERVER_path%>/Contents/CommonView/insert_update_delete_json.jsp", 
	        data:  "bomdata=" + bomdata + "&pid=" + pid,
	        success: function (html) {
	        	if(html > -1) {
	        		heneSwal.successTimer('원부자재 정보 등록에 성공했습니다');
	        		
	        		$('#modalReport').modal('hide');
	        		parent.fn_MainInfo_List();
	                parent.$("#ReportNote").children().remove();
	         	} else{
	        		heneSwal.errorTimer('등록에 실패했습니다. 관리자에 문의해 주세요')
	        	}
	    	},
	        error: function (xhr, option, error) {
	        	heneSwal.errorTimer('등록에 실패했습니다. 관리자에 문의해 주세요')
	        }
		});		
	}
 
	// 코드 등록
	function part_code_regist(obj, gubun) {
		part_code = obj.id;
		var parent_val = "";
		var current_gubun = "대분류";
			
		if(part_code == "PRDGM") {
			parent_val = $("#partGubunBigSelector option:selected").val();
			current_gubun="중분류";
		} else if(part_code == "PRDGS") {
			parent_val = $("#partGubunMidSelector option:selected").val();
			current_gubun="소분류";
		}
		
		var modalContentUrl = "<%=Config.this_SERVER_path%>/Contents/Business/M909/S909S110201.jsp?part_code="
							   + part_code+"&parent_val=" + parent_val+"&current_gubun=" + current_gubun;
		var footer = "";
		var title = gubun+"구분코드등록(S909S110201)";
		var heneModal = new HenesysModal2(modalContentUrl, 'auto', title, footer);
		heneModal.open_modal();
	}
</script>

<table class="table table-hover"> 
	<tr>
		<td>
			제품대분류
		</td>
		<td>
		</td>
		<td>
			<div class= "input-group">			
          		<select class="form-control" id="partGubunBigSelector">
					<%	optCode =  (Vector)partgubun_bigVector.get(0);%>
					<%	optName =  (Vector)partgubun_bigVector.get(1);%>
					<%for(int i=0; i<optName.size();i++){ %>
					  <%if (optCode.get(i).equals(GV_PART_GUBUN_B)) {%>
						<option value='<%=optCode.get(i).toString()%>' selected="selected"><%=optName.get(i).toString()%></option>
					  <%} else{%>
						<option value='<%=optCode.get(i).toString()%>'><%=optName.get(i).toString()%></option>
					  <%} %>
					<%}%>
				</select>
			
				<!-- <div class="input-group-append">
					<button id="PRDGB" class="btn btn-info" 
							onclick="part_code_regist(this,'대분류');">
						등록
					</button>
			    </div> -->
			</div>
		</td>
	</tr>

	<tr>
		<td>
			제품중분류
		</td>
        <td>
        </td>
		<td> 
			<div class="input-group">
				<select class="form-control" id="partGubunMidSelector" style="float: left">
					<% optCode = (Vector)partgubun_midVector.get(0);%>
					<% optName = (Vector)partgubun_midVector.get(1);%>
					<%for(int i=0; i<optName.size();i++){ %>
					  <%if (optCode.get(i).equals(GV_PART_GUBUN_M)) {%>
						<option value='<%=optCode.get(i).toString()%>' selected="selected"><%=optName.get(i).toString()%></option>
					  <%} else{%>
						<option value='<%=optCode.get(i).toString()%>'><%=optName.get(i).toString()%></option>
					  <%} %>
					<%}%>
				</select>
				<!-- <div class="input-group-append">
					<button id="PRDGM" class="btn btn-info"  
						onclick="part_code_regist(this,'중분류');">
						등록
					</button> 
		     	</div> -->
			</div>
		</td>
	</tr>
       
	<tr>
	    <td>
	    	대분류코드
	    </td>
	    <td>
	    </td>
	    <td>
	    	<input type="text" class="form-control" id="txt_PartCd_big" readonly/>
	   	</td>
	</tr>
       
	<tr>
	    <td>
	    	중분류코드
	    </td>
	    <td>
	    </td>
	    <td>
	    	<input type="text" class="form-control" id="txt_PartCd_mid" readonly/>
	   	</td>
	</tr>

	<tr>
	    <td>
	    	원자재코드
	    </td>
	    <td>
	    </td>
	    <td>
	    	<input type="text" class="form-control" id="txt_PartCd"/>
	   	</td>
	</tr>
       
	<tr>
	    <td>
	    	원자재명
	    </td>
	    <td>
	    </td>
	    <td>
	    	<input type="text" class="form-control" id="txt_PartName"  />
	   	</td>
	</tr>
       
	<tr>
	    <td>
	    	포장 단위
	    </td>
	    <td>
	    </td>
	    <td>
	    	<input type="number" class="form-control" id="txt_packing_qtty"
	    				placeholder="포장 단위 수량을 입력해주세요" />
	   	</td>
	</tr>
       
    <tr>
		<td>
	   		개별 규격 
	   	</td>
	   	<td>
	   	</td>
	   	<td>
	   		<input type="number" class="form-control" 
	   				id="gyugyeok" placeholder="ex) 0.65"/>
       	</td>
    </tr>
    
	<tr>
		<td>
	   		개별 규격 단위
	   	</td>
	   	<td>
	   	</td>
	   	<td>
	   		<input type="text" class="form-control" 
	   				id="select_unit_type" placeholder="ex) kg/수"/>
       	</td>
    </tr>
      
	<tr>
		<td>
			안전재고
		</td>
		<td>
		</td>
		<td>
			<div class="input-group">
				<input type="number" class="form-control" 
						id="txt_saftyCount" name="txt_saftyCount">
	  			<div class="input-group-append">
	    			<span class="input-group-text">개</span>
	  			</div>
			</div>
		</td>
	</tr>
       
	<tr>
		<td>
			단가
		</td>
		<td>
		</td>
		<td>
     		<div class="input-group">
 				<input type="text" class="form-control" id="txt_UnitPrice" />
  				<div class="input-group-append">
    				<span class="input-group-text">원</span>
  				</div>
			</div>
    	</td>
 	</tr>
       
	<!-- <tr>
    	<td>
    		적용시작일자
    	</td>
    	<td>
    	</td>
    	<td>
    		<input type="date" id="txt_StartDate" class="form-control" 
    				name="txt_StartDate">
   		</td>
	</tr> -->
</table>