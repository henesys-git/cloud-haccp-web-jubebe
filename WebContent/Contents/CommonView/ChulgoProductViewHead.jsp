<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*,java.util.*,javax.servlet.http.*"%>
<%@ page import="mes.client.comm.*" %>
<%@ page import="mes.client.common.*" %>
<%@ page import="mes.client.guiComponents.*" %>
<%@ page import="mes.client.util.*" %>
<%@ page import="mes.client.conf.*" %>
<%
	String member_key = session.getAttribute("member_key").toString();
	String GV_CALLER = "", GV_SELECT_COUNT = "";
	
	if(request.getParameter("caller") == null) {
		GV_CALLER = "0";
	} else {
		GV_CALLER = request.getParameter("caller");
	}
	
	if(request.getParameter("select_count") == null) {
		GV_SELECT_COUNT = "ALL";
	} else {
		GV_SELECT_COUNT = request.getParameter("select_count");
	}
	
	Vector optCode = null;
    Vector optName = null;
    
    Vector prodgubun_bigVector = ProductComboData.getProdBigGubunDataAll(member_key);
    Vector prodgubun_midVector = ProductComboData.getProdMidGubunDataAll(GV_SELECT_COUNT, member_key);
%>

<script type="text/javascript">
	var vprod_gubun_b = "";
	var vprod_gubun_m = "";
	var vprod_gubun_s = "";
	var vgyugyeok = "";
	var vprod_level = "";
	var vProdCd	= "";
	var vRevisionNo = "";
	var vProdCode = "";
	var vProd_cd_alt = "";
	var vProd_nm_alt = "";
	var vProdgubun_big = "";
	var vProdgubun_mid = "";
	var vprodgubun_sm = "";

	$(document).ready(function () {
		caller = "<%=GV_CALLER%>";
		select_count = "<%=GV_SELECT_COUNT%>";
		
		vprodgubun_big = "ALL";
		vprodgubun_mid = "ALL";
		
		fn_Chulgo_Product_List();
        
	$("#prodgubun_mid").attr("disabled", true);
        
        $("#prodgubun_big").on("change", function() {
	    	vProdgubun_big = $(this).val();
	    	
	    	if(vProdgubun_big == "ALL") {
	    		vProdgubun_big = "";
	    	}
	    	
	    	$.ajax({
				type: "POST",
				url: "<%=Config.this_SERVER_path%>/Contents/Business/M858/S858S070250.jsp",
				data: "prodgubun_big="+ vProdgubun_big,
				success: function (html) {
					$("#prodgubun_mid > option").remove();
				    var changMidResult = html.split("|");
				    
				    for(var i=0; i<changMidResult.length; i++) {
				    	var value = changMidResult[i].split(",")[0]
				    	var name  = changMidResult[i].split(",")[1].trim();
			        	$("#prodgubun_mid").append("<option value="+value+">"+name+"</option>");
					}
				    vProdgubun_mid = $("#prodgubun_mid >option:eq(0)").val();
				    
				    if($("#prodgubun_big").val() == "ALL") {
	                	$("#prodgubun_mid").prepend("<option value = 'ALL'>전체</option>"); 
	                	$("#prodgubun_mid > option:eq(0)").prop("selected",true);
	                	$("#prodgubun_mid").attr("disabled",true);
	                	vProdgubun_mid = "";
					} else if(vProdgubun_mid == 'Empty_Value') {
		            	$("#prodgubun_mid").attr("disabled",true);
	                } else {
		            	$("#prodgubun_mid").attr("disabled",false);
	                }
		                
				    fn_Chulgo_Product_List();
				}
			});
	    });

        $("#prodgubun_mid").on("change", function() {
	    	vProdgubun_big = $("#prodgubun_big").val();
	    	vProdgubun_mid = $(this).val();
	    	
	    	if($("#prodgubun_mid").val() == "ALL") {
	    		fn_Chulgo_Product_List();
	    		return;
	    	}
	    	
	    	fn_Chulgo_Product_List();
	    }); 
    });
    
    //제품등록정보
    function fn_Chulgo_Product_List() {
    	
		if(vProdgubun_big == "ALL")
			vProdgubun_big = "";
		if(vProdgubun_mid == "ALL")
			vProdgubun_mid = "";
    	
        $.ajax({
            type: "POST",
            url: "<%=Config.this_SERVER_path%>/Contents/CommonView/ChulgoProductView.jsp",
            data: "prodgubun_big="+ vProdgubun_big + 
            	  "&prodgubun_mid="+ vProdgubun_mid + 
            	  "&caller=" + "<%=GV_CALLER%>",
            beforeSend: function () {
                $("#tableChulgoProductView_body").children().remove();
            },
            success: function (html) {
                $("#tableChulgoProductView_body").hide().html(html).fadeIn(100);
            }
        });
    }
    
    function call_gubun(check) {
    	vprodgubun_big = check;
    	
    	if(vprodgubun_big == "ALL") {
    		vprodgubun_big = "";
    	}
    	
    	 $.ajax({
            type: "POST",
            url: "<%=Config.this_SERVER_path%>/Contents/Business/M909/S909S060200.jsp",
            data: "prodgubun_big="+ vprodgubun_big,
            success: function (html) {
            	var gubunBig = $("#prodgubun_big").val();
                
            	$("#prodgubun_mid > option").remove();
                
            	var changMidResult = html.split("|");
                
                for(var i = 0; i < changMidResult.length; i++) {
                	var value = changMidResult[i].split(",")[0]    		                	
                	var name = changMidResult[i].split(",")[1].trim();
  		            $("#prodgubun_mid").append("<option value="+value+">"+name+"</option>");    		                	
                }
                
                if(gubunBig == select_count) {
                	$("#prodgubun_mid").prepend("<option value='ALL'>전체</option>"); 
                	$("#prodgubun_mid > option:eq(0)").prop("selected", true);
                }
                
                if($("#prodgubun_big").val() == "ALL") { // 대분류:전체 선택시
                	$("#prodgubun_mid").prepend("<option value='ALL'>전체</option>"); 
                	$("#prodgubun_mid > option:eq(0)").prop("selected", true);
                	$("#prodgubun_mid").attr("disabled", true);
                } else {
                	$("#prodgubun_mid").attr("disabled", false);
                }
                
                vprodgubun_mid = $("#prodgubun_mid > option:eq(0)").val();
		    	
                fn_Chulgo_Product_List();
            }
        });
    }
</script>

<div class="panel panel-default" style="margin-left:5px; margin-top:5px; 
	 							 margin-right:5px; margin-bottom:5px; width:100%">
	<!-- Default panel contents -->
	<div class="panel-body">
		<div class="panel panel-default">
			<div style="float:left">
				<table style="width: 100%; text-align:left; background-color:#f5f5f5;">
					<tr>
						<td style='width:21%; vertical-align: middle'>
							대분류
						</td>
						<td style='width:26%;vertical-align: middle'>
							<select class="form-control" id="prodgubun_big" style="width: 120px">
								<%	optCode = (Vector)prodgubun_bigVector.get(0);%>
								<%	optName = (Vector)prodgubun_bigVector.get(1);%>
								<%	for(int i = 0; i < optName.size(); i++){ %>
									<option value='<%=optCode.get(i).toString()%>'>
										<%=optName.get(i).toString()%>
									</option>
								<%	} %>
							</select>
						</td>
						<td style='width:22%; vertical-align: middle'>
							중분류
						</td>
						<td style='width:26%;vertical-align: middle'>
							<select class="form-control" id="prodgubun_mid" style="width: 120px">
								<%	optCode = (Vector)prodgubun_midVector.get(0);
									optName = (Vector)prodgubun_midVector.get(1);	%>
								<%	for(int i=0; i < optName.size(); i++) {	%>
									<option value='<%=optCode.get(i).toString()%>'>
										<%=optName.get(i).toString()%>
									</option>
								<%} %>
							</select>
						</td>                          
					</tr>
				</table>
			</div>
	        <div class="panel-body">
	            <div style="clear:both" id="tableChulgoProductView_body">
	            </div>
	        </div>
    	</div>
    </div>
</div>