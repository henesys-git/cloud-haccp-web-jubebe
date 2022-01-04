<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*,java.util.*,javax.servlet.http.*"%>
<%@ page import="mes.client.comm.*" %>
<%@ page import="mes.client.common.*" %>
<%@ page import="mes.client.guiComponents.*" %>
<%@ page import="mes.client.util.*" %>
<%@ page import="mes.client.conf.*" %>
<%
	String member_key = session.getAttribute("member_key").toString();
	String GV_CALLER = "", GV_SUB_CALLER = "", GV_SELECT_COUNT = "";
	
	if(request.getParameter("caller") == null) {
		GV_CALLER = "0";
	} else {
		GV_CALLER = request.getParameter("caller");
	}
	
	if(request.getParameter("sub_caller") == null) {
		GV_SUB_CALLER = "0";
	} else {
		GV_SUB_CALLER = request.getParameter("sub_caller");
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
	var vprodgubun_big = "";
	var vprodgubun_mid = "";
	var vprodgubun_sm = "";

	$(document).ready(function () {
		caller = "<%=GV_CALLER%>";
		select_count = "<%=GV_SELECT_COUNT%>";
		
		vprodgubun_big = "ALL";
		vprodgubun_mid = "ALL";
		
        fn_Product_List();
	    
		$("#prodgubun_big1").on("change", function() {
	    	vprodgubun_big = $(this).val();
	    	
	    	if(vprodgubun_big == "ALL") {
	    		vprodgubun_big = "";
	    	}
	    	
	    	$.ajax({
	            type: "POST",
	            url: "<%=Config.this_SERVER_path%>/Contents/Business/M909/S909S060200.jsp",
	            data: "prodgubun_big="+ vprodgubun_big,
	            success: function (html) {
	                $("#prodgubun_mid1 > option").remove();
	                
	                var changMidResult = html.split("|");
	                
	                for(var i = 0; i < changMidResult.length; i++) {
	                	var value = changMidResult[i].split(",")[0]
	                	var name  = changMidResult[i].split(",")[1].trim();
		                $("#prodgubun_mid1").append("<option value="+value+">"+name+"</option>");
	                }
	                
	                $("#prodgubun_mid1").prepend("<option value='ALL'>전체</option>")
	                $("#prodgubun_mid1 > option:eq(0)").prop("selected", true);
	                
	                vprodgubun_mid = $("#prodgubun_mid1 > option:eq(0)").val();
	                
	                fn_Product_List();
	            }
	        });
	    });

        $("#prodgubun_mid1").on("change", function(){
	    	vprodgubun_big = $("#prodgubun_big1").val();
	    	vprodgubun_mid = $(this).val();
	    	
	    	if($("#prodgubun_mid1").val() == "ALL") {
	    		fn_Product_List();
	    		return;
	    	}
	    	
            fn_Product_List();
    	});
    });
    
    //제품등록정보
    function fn_Product_List() {

		if(vprodgubun_big == "ALL") {
			vprodgubun_big = "";
		}
		if(vprodgubun_mid == "ALL") {
			vprodgubun_mid = "";
		}
    	
        $.ajax({
            type: "POST",
            url: "<%=Config.this_SERVER_path%>/Contents/CommonView/ProductView.jsp",
            data: "prodgubun_big="+ vprodgubun_big + 
            	  "&prodgubun_mid="+ vprodgubun_mid + 
            	  "&caller=" + "<%=GV_CALLER%>" +
            	  "&sub_caller=" + "<%=GV_SUB_CALLER%>",
            beforeSend: function () {
                $("#tableProductView_body").children().remove();
            },
            success: function (html) {
                $("#tableProductView_body").hide().html(html).fadeIn(100);
            }
        });
    }
    
    <%-- function call_gubun(check) {
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
		    	
                fn_Product_List();
            }
        });
    } --%>
</script>

<div class="panel panel-default">
	<!-- Default panel contents -->
	<div class="panel-body">
		<div class="panel panel-default">
			<div>
				<table>
					<tr>
						<td>
							제품 대분류
						</td>
						<td>
							<select class="form-control" id="prodgubun_big1">
								<% optCode = (Vector)prodgubun_bigVector.get(0);%>
								<% optName = (Vector)prodgubun_bigVector.get(1);%>
								<% for(int i = 0; i < optName.size(); i++){ %>
									<option value='<%=optCode.get(i).toString()%>'>
										<%=optName.get(i).toString()%>
									</option>
								<% } %>
							</select>
						</td>
						<td>
							제품 중분류
						</td>
						<td>
							<select class="form-control" id="prodgubun_mid1">
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
	            <div id="tableProductView_body">
	            </div>
	        </div>
    	</div>
    </div>
</div>