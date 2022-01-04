<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*,java.util.*,javax.servlet.http.*"%>
<%@ page import="mes.client.comm.*" %>
<%@ page import="mes.client.common.*" %>
<%@ page import="mes.client.guiComponents.*" %>
<%@ page import="mes.client.util.*" %>
<%@ page import="mes.client.conf.*" %>
<%@ page import="mes.frame.business.customer.*" %>
<%
	/* 	yumsam
		2021 02 18 최현수
		중분류 id를 partgubun_mid가 아닌 굳이 partgubun_mid2로 한 이유:
	   	부모 페이지에 아이디가 중복되서 정상 작동을 안해서 2를 붙임
	*/

	String member_key = session.getAttribute("member_key").toString();
	String GV_CALLER = "0", GV_PART_GUBUN = "";
	
	if(request.getParameter("caller") != null)
		GV_CALLER = request.getParameter("caller");	
	
	if(request.getParameter("part_gubun") != null)
		GV_PART_GUBUN = request.getParameter("part_gubun");	
	
	Vector optCode = null;
    Vector optName = null;
    
    Vector partgubun_bigVector = PartListComboData.getPartBigGubunDataAll(member_key);
    Vector partgubun_midVector = PartListComboData.getPartMidGubunDataAll("", member_key);

	CustomerDao customerDao = new CustomerDaoImpl();
	List<Customer> customerList = new ArrayList<Customer>();
	customerList = customerDao.getAllCustomersByType("CUSTOMER_GUBUN_BIG01");
%>

<script type="text/javascript">
	var vPartgubun_big = "";
	var vPartgubun_mid = "";
	var vPartgubun_sm = "";
	
	$(document).ready(function () {
		let caller = "<%=GV_CALLER%>";
		
		$("#custList").prepend("<option value='ALL' selected=true>전체</option>");
		
		displayPartList();
		
        // 대분류 변경 시
	    $('body').on('change', '#partgubun_big', function(e) {
	    	if( $('#custList').val() != "ALL") {
	    		e.preventDefault();
	    	}
	    	
	    	vPartgubun_big = $(this).val();
	    	
	    	if(vPartgubun_big == "ALL") {
	    		vPartgubun_big = "";
	    		vPartgubun_mid = "";
	    	}
			
	    	$.ajax({
				type: "POST",
		        url: "<%=Config.this_SERVER_path%>/Contents/Business/M909/S909S110200.jsp",
		        data: "partgubun_big="+ vPartgubun_big,
		        success: function (html) {
		        	$("#partgubun_mid2 > option").remove();
 		            var changeMidResult = html.split("|");

 		            for(var i = 0; i < changeMidResult.length; i++) {
 		            	var value = changeMidResult[i].split(",")[0]
 		                var name = changeMidResult[i].split(",")[1].trim();
  		                $("#partgubun_mid2").append("<option value="+value+">"+name+"</option>");
	                }
		            
	            	$("#partgubun_mid2").prepend("<option value='ALL'>전체</option>"); 
	                $("#partgubun_mid2 > option:eq(0)").prop("selected", true);
 		            
 		            vPartgubun_mid = $("#partgubun_mid2 > option:eq(0)").val();

		           	displayPartList();
				}
			});
	    });
		
        // 중분류 변경 시
	    $('body').on('change', '#partgubun_mid2', function(e) {
	    	if( $('#custList').val() != "ALL") {
	    		e.preventDefault();
	    	}
	    	
	    	vPartgubun_big = $("#partgubun_big").val();
	    	vPartgubun_mid = $(this).val();  	
	    	
	    	if( $("#partgubun_mid2").val() == "ALL" ) {
	    		vPartgubun_mid = "";
	    		displayPartList();
	    		return false;
	    	}
	    	
	    	displayPartList();
	    });
        
	 	// 업체별 조회
	    $('body').on('change', '#custList', function() {
	    	// 대분류, 중분류 값은 초기화 한다
	    	$("#partgubun_big > option:eq(0)").prop("selected", true);
	    	$("#partgubun_mid2 > option:eq(0)").prop("selected", true);
	    	vPartgubun_big = "";
	    	vPartgubun_mid = "";
	    	
	    	// 협력업체 코드를 가져 온다
	    	var custCode = $('#custList').val();
	    	
	    	// 협력업체 코드에 매칭되는 원부재료 목록을 불러온다
	    	displayPartListByCustomer(custCode);
	    });
	    
	    // 원부자재 목록을 불러옴
	    function displayPartList() {
			if(vPartgubun_big == "ALL") {
				vPartgubun_big = "";
			}
			
			if(vPartgubun_mid == "ALL") {
				vPartgubun_mid = "";
			}

	        $.ajax({
	            type: "POST",
	            url: "<%=Config.this_SERVER_path%>/Contents/CommonView/PartCodeView.jsp",
	            data: "partgubun_big="+ vPartgubun_big + 
	            	  "&partgubun_mid="+ vPartgubun_mid + 
	            	  "&caller=" + caller + 
	            	  "&part_gubun=" + "<%=GV_PART_GUBUN%>",
	           	beforeSend: function () {
	                $("#partViewContents").children().remove();
	            },
	            success: function (html) {
	                $("#partViewContents").hide().html(html).fadeIn(100);
	            }
	        });
	    }
	    
		// 원부자재 목록을 불러옴
	    function displayPartListByCustomer(customerCode) {
	    	
	        $.ajax({
	            type: "POST",
	            url: "<%=Config.this_SERVER_path%>/Contents/CommonView/PartCodeView.jsp",
	            data: "partgubun_big="+ vPartgubun_big + 
	            	  "&partgubun_mid="+ vPartgubun_mid + 
	            	  "&caller=" + caller + 
	            	  "&part_gubun=" + "<%=GV_PART_GUBUN%>" + 
	            	  "&cust_code=" + customerCode,
	           	beforeSend: function () {
	                $("#partViewContents").children().remove();
	            },
	            success: function (html) {
	                $("#partViewContents").hide().html(html).fadeIn(100);
	            }
	        });
	    }
    });
</script>
   
<!-- Main content -->
<div class="content">
	<div class="container-fluid">
  		<div class="row">
  			<div class="col-md-12">
      			<div class="card card-primary card-outline">
        			<div class="card-header">
        				<div class="card-tools">
        					<table style="width:100%">
								<tr>
		                           	<td>
		                           		대분류
		                           	</td>
		                            <td>
			                        	<select class="form-control" id="partgubun_big">
			                                <%	optCode = (Vector)partgubun_bigVector.get(0);%>
	                                		<%	optName = (Vector)partgubun_bigVector.get(1);%>
	                                		<%	for(int i = 0; i < optName.size(); i++) { %>
									  				<option value='<%=optCode.get(i).toString()%>'>
									  					<%=optName.get(i).toString()%>
									  				</option>
											<%} %>
										</select>
									</td> 
		                           	<td>
		                           		중분류
		                           	</td>
		                            <td>
			                        	<select class="form-control" id="partgubun_mid2" >
			                                <%	optCode = (Vector)partgubun_midVector.get(0);%>
			                                <%	optName = (Vector)partgubun_midVector.get(1);%>
			                                <%	for(int i=0; i<optName.size();i++){ %>
													<option value='<%=optCode.get(i).toString()%>'>
														<%=optName.get(i).toString()%>
													</option>
											<%	} %>
										</select>
									</td>
									<td>
		                           		업체별
		                           	</td>
		                            <td>
			                        	<select class="form-control" id="custList">
			                                <%for(Customer cust : customerList) { %>
												<option value='<%=cust.getCode()%>'>
													<%=cust.getName()%>
												</option>
											<%}%>
										</select>
									</td>
								</tr>
							</table>
      					</div>
					</div>
         			<div class="card-body" id="partViewContents"></div> 
       			</div>
     		</div>
     		<!-- /.col-md-6 -->
   		</div>
   		<!-- /.row -->
	</div><!-- /.container-fluid -->
</div>
<!-- /.content -->