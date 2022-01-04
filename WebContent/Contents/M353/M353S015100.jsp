<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*,java.util.*,javax.servlet.http.*"%>
<%@ page import="mes.client.comm.*" %>
<%@ page import="mes.client.common.*" %>
<%@ page import="mes.client.guiComponents.*" %>
<%@ page import="mes.client.util.*" %>
<%@ page import="mes.client.conf.*" %>

<!-- 
제품생산일지 
yumsam
-->

<%
	String loginID = session.getAttribute("login_id").toString();
	String member_key = session.getAttribute("member_key").toString();
	if(loginID == null || loginID.equals("")) {         // id가 Null 이거나 없을 경우
		response.sendRedirect("Contents/index.jsp");    // 로그인 페이지로 리다이렉트 한다.
	}

	String sMenuTitle = request.getParameter("MenuTitle").toString();
	
    Vector optCode = null;
    Vector optName = null;
    Vector prodgubun_bigVector = ProductComboData.getProdBigGubunDataAll(member_key);
    Vector prodgubun_midVector = ProductComboData.getProdMidGubunDataAll("", member_key);
%>

<script type="text/javascript">
	var vProdgubun_big = "";
	var vProdgubun_mid = "";
 	var vProdCd = "";
 	var vProdRevNo = "";
 	var vProdNm = "";
 	var vInputAmt = "";
 	var vOutputAmt = "";
 	var vLossRate = "";
	
    $(document).ready(function () {
        fn_MainSubMenuSelect("<%=sMenuTitle%>");
        
		$("#InfoContentTitle").html("제품 생산 목록");
		
		fn_MainInfo_List();
		
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
		                
	    			fn_MainInfo_List();
				}
			});
	    });

        $("#prodgubun_mid").on("change", function() {
	    	vProdgubun_big = $("#prodgubun_big").val();
	    	vProdgubun_mid = $(this).val();
	    	
	    	if($("#prodgubun_mid").val() == "ALL") {
	    		fn_MainInfo_List();
	    		return;
	    	}
	    	
	    	fn_MainInfo_List();
	    }); 
    });

    function fn_MainInfo_List() {
		if(vProdgubun_big == "ALL")
			vProdgubun_big = "";
		if(vProdgubun_mid == "ALL")
			vProdgubun_mid = "";
        
        $.ajax({
            type: "POST",
            url: "<%=Config.this_SERVER_path%>/Contents/Business/M353/S353S015100.jsp", 
            data: "prodgubun_big="+ vProdgubun_big + "&prodgubun_mid="+ vProdgubun_mid,
            beforeSend: function () {
                $("#MainInfo_List_contents").children().remove();
            },
            success: function (html) {
                $("#MainInfo_List_contents").hide().html(html).fadeIn(100);
            }
        });
        
        $("#SubInfo_List_contents").children().remove();
    }
    
  	// 입고내역
	function fn_DetailInfo_List() {
  		
    	$.ajax({
   	        type: "POST",
   	        url: "<%=Config.this_SERVER_path%>/Contents/Business/M353/S353S015110.jsp",
   	        data: "prodCd=" + vProdCd + 
   	        	  "&prodRevNo=" + vProdRevNo + 
   	        	  "&inputAmt=" + vInputAmt,
   	        success: function (html) {
   	            $("#SubInfo_List_contents").hide().html(html).fadeIn(100);
   	        }
   	    });
	}
  	
	// 점검표 조회
    function displayChecklist(element) {
    	
    	if(vProdCd === "") {
    		heneSwal.warning('출력할 일지를 선택해주세요');
    		return false;
    	}
    	
    	var date = new HeneDate();
    	
    	let ajaxUrl = '<%=Config.this_SERVER_path%>/Contents/CheckList/getChecklistFormat.jsp';
    	
    	let jObj = new Object();
    	jObj.checklistId = "checklist99";
    	jObj.checklistRevNo = "0";
    	jObj.checklistDate = date.getToday();

    	let ajaxParam = JSON.stringify(jObj);
	
    	$.ajax({
    		url: ajaxUrl,
    		data: {"ajaxParam" : ajaxParam},
    		success: function(rcvData) {
    			const format = rcvData[0][0];	// 이미지 파일
    			const page = rcvData[0][1];		// jsp 페이지
    			
		    	const modalUrl = '<%=Config.this_SERVER_path%>' + page
		    					+ '?format=' + format
			    				+ '&prodCd=' + vProdCd
			    				+ '&prodRevNo=' + vProdRevNo
			    				+ '&prodGubunBig=' + vProdgubun_big
			    				+ '&prodGubunMid=' + vProdgubun_mid
			    				+ '&prodNm=' + vProdNm
			    				+ '&inputAmt=' + vInputAmt
			    				+ '&outputAmt=' + vOutputAmt
			    				+ '&lossRate=' + vLossRate;
		    	
				const footer = "<button type='button' class='btn btn-outline-primary' onclick='printChecklist()'>출력</button>";
				const title = element.innerText;
				const heneModal = new HenesysModal(modalUrl, 'auto', title, footer);
				heneModal.open_modal();
    		}
    	});
    }
</script>
    
<!-- Content Header (Page header) -->
<div class="content-header">
 	<div class="container-fluid">
   		<div class="row mb-2">
	    	<div class="col-sm-6">
	      		<h1 class="m-0 text-dark" id="MenuTitle">여기에 메뉴 타이틀</h1>
	      	</div>
	      	<div class="col-sm-6">
     			<div class="float-sm-right">
     				<button type="button" onclick="displayChecklist(this)" 
     				  	 	class="btn btn-outline-dark">
     					일지 출력
     				</button>
     			</div>
     		</div>
	    </div><!-- /.row -->
    </div><!-- /.container-fluid -->
</div>
<!-- /.content-header -->
   
<!-- Main content -->
<div class="content">
	<div class="container-fluid">
  		<div class="row">
  			<div class="col-md-12">
      			<div class="card card-primary card-outline">
        			<div class="card-header">
         				<h3 class="card-title">
         					<i class="fas fa-edit" id="InfoContentTitle"></i>
         				</h3>
        				<div class="card-tools">
        					<table style="width:100%">
								<tr>
		                           	<td>
		                           		대분류
		                           	</td>
		                            <td>
			                        	<select class="form-control" id="prodgubun_big">
			                                <%	optCode = (Vector)prodgubun_bigVector.get(0);%>
	                                		<%	optName = (Vector)prodgubun_bigVector.get(1);%>
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
			                        	<select class="form-control" id="prodgubun_mid" >
			                                <%	optCode = (Vector)prodgubun_midVector.get(0);%>
			                                <%	optName = (Vector)prodgubun_midVector.get(1);%>
			                                <%	for(int i=0; i<optName.size();i++){ %>
													<option value='<%=optCode.get(i).toString()%>'>
														<%=optName.get(i).toString()%>
													</option>
											<%	} %>
										</select>
									</td>
								</tr>
							</table>
      					</div>
					</div>
         			<div class="card-body" id="MainInfo_List_contents"></div> 
       			</div>
     		</div>
     		<!-- /.col-md-6 -->
   		</div>
   		<!-- /.row -->
    	<div class="card card-primary card-outline">
	    	<div class="card-header">
	    		<h3 class="card-title">
	    			<i class="fas fa-edit">세부 정보</i>
	    		</h3>
	    	</div>
	    	<div class="card-body">
	    		<ul class="nav nav-tabs" id="custom-tabs-one-tab" role="tablist">
		       		<li class="nav-item" onclick='fn_DetailInfo_List()'>
		       			<a class="nav-link" id="DetailInfo_List" data-toggle="pill" 
		       								href="#SubInfo_List_contents" role="tab">
		       				투입량
		       			</a>
		       		</li>
		        </ul>
		     	<div class="tab-content" id="custom-tabs-one-tabContent">
		     		<div class="tab-pane fade" id="SubInfo_List_contents" role="tabpanel">
		     		</div>
		     	</div>
		    </div>
    	</div>
	</div><!-- /.container-fluid -->
</div>
<!-- /.content -->