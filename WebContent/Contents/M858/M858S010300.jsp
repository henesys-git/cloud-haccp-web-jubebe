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
완제품출하현황
 */
	String loginID = session.getAttribute("login_id").toString();
	String member_key = session.getAttribute("member_key").toString();
	if(loginID==null||loginID.equals("")){                            // id가 Null 이거나 없을 경우
		response.sendRedirect("Contents/index.jsp");    // 로그인 페이지로 리다이렉트 한다.
	}

	String sMenuTitle = request.getParameter("MenuTitle").toString();
	String sProgramId = request.getParameter("programId").toString();
	String sHeadmenuID= request.getParameter("HeadmenuID").toString();
	String sHeadmenuName= request.getParameter("HeadmenuName").toString();

	Get_Program_button_Autho prg_autho = new Get_Program_button_Autho(loginID,sProgramId);	

	CurrentPage jspPageName = new CurrentPage(request.getRequestURI());
	String JSPpage = jspPageName.GetJSP_FileName();
	ProcesStatusCheck prcStatusCheck = new ProcesStatusCheck(JSPpage+"|"+"ODPROCS"+"|");
	
	String GV_PROCESS_MODIFY	= prcStatusCheck.GV_PROCESS_MODIFY;
	String GV_PROCESS_DELETE	= prcStatusCheck.GV_PROCESS_DELETE;
	String GV_GET_NUM_PREFIX = prcStatusCheck.GV_PROCESS_NUMBER_GUBUN;
	
	JSONObject jArray = new JSONObject();
	
	Vector optCodeBig1 = null;
    Vector optNameBig1 = null;
    
    Vector optCodeMid1 = null;
    Vector optNameMid1 = null;
    
    Vector Product_Big_Gubun_Vector1 = CommonData.getProductBigGubun(true, member_key);
    Vector Product_Mid_Gubun_Vector1 = CommonData.getProductMidGubun("", true, member_key);
	
    Vector optCodeProd = null;
    Vector optNameProd = null;
    
    Vector Product_Name_Vector1 = CommonData.getProductName("", "", true, member_key);
	
	DoyosaeTableModel table = new DoyosaeTableModel("M858S010300E204", jArray);
	
	int rowLen = table.getRowCount();
	
	String initialProdCode = table.getStrValueAt(0, 0);
	String initialProdName = table.getStrValueAt(0, 1);

%>  
<style>

table {
  border-spacing: 10px;
  border-collapse: separate;
}

</style>



<script type="text/javascript">

var prod_gubun_b	= "";
var prod_gubun_m	= "";

var year = "";
var prod_cd = "";

var month = "";


    $(document).ready(function () {
		
		 var date = new Date();
		 var yr = date.getFullYear();
		 
		 $("#dateRange").val(yr);
		 
		 $("#dateRange").datetimepicker({
		 "format" : 'yyyy',
		 "startView" : 'decade',
	 	 "minView" : 'decade',
	 	 "maxView" : 'decade',
		 "viewSelect" : 'decade',
		 "autoclose" : true
			 
		 }); 
		
		year = $("#dateRange").val();
    	prod_cd = $("#select_prod option:selected").val();
		
		console.log(prod_cd);
		console.log(year);
		
	    fn_MainInfo_List(year);
	  	
		$("#InfoContentTitle").html("완제품 출하 현황");
	    fn_MainSubMenuSelect("<%=sMenuTitle%>");        	
	    fn_tagProcess();
	    
	    
	     $("#btn_Search").on("click", function(){
	    	
	    	prod_cd = $("#select_prod option:selected").val();
	    	year = $("#dateRange").val();
	    	
	    	console.log(prod_cd);
	    	console.log(year);
	    	
	    	fn_MainInfo_List(year);
	    
	    });
	     
	     $("#Select_Product_Gubun_Code_Mid").attr("disabled", true);
	     $("#select_prod").attr("disabled", true);
			
			// 대분류 변경 시
	    	$("#Select_Product_Gubun_Code_Big").on("change", function(){
	    		prod_gubun_b = $(this).val();
	    		
	    		if(prod_gubun_b == "ALL") {
					prod_gubun_b = "";
	    		}
		    
		    	 $.ajax({
		            type: "POST",
		            url: "<%=Config.this_SERVER_path%>/Contents/Business/M909/S909S060200.jsp",
		            data: "prodgubun_big=" + prod_gubun_b,
		            success: function (html) {
		                $("#Select_Product_Gubun_Code_Mid > option").remove();
		                var changMidResult = html.split("|");
		                for( var i = 0 ; i < changMidResult.length ; i++ ) {
		                	var value = changMidResult[i].split(",")[0]
		                	var name  = changMidResult[i].split(",")[1].trim();
			                $("#Select_Product_Gubun_Code_Mid").append("<option value = " + value + ">" + name + "</option>");
		                }
		                
		                prod_gubun_m = $("#Select_Product_Gubun_Code_Mid >option:eq(0)").val();
		                prod_name = $("#select_prod >option:eq(0)").val();
		                
		                if( $("#Select_Product_Gubun_Code_Big").val() == "ALL" ) {
		                	$("#Select_Product_Gubun_Code_Mid").prepend("<option value = 'ALL'>전체</option>"); 
		                	$("#select_prod").prepend("<option value = 'ALL'>분류를 선택해 주세요</option>"); 
		                	$("#Select_Product_Gubun_Code_Mid > option:eq(0)").prop("selected",true);
		                	$("#select_prod > option:eq(0)").prop("selected",true);
		                	
		                	$("#Select_Product_Gubun_Code_Mid").attr("disabled",true);
		                	$("#select_prod").attr("disabled",true);
		                	$("#btn_Search").attr('disabled', true);
		                	prod_gubun_m = "";
		                	prod_name = "";
		                	
						} else if( prod_gubun_m == 'Empty_Value' ) {
			            	$("#Select_Product_Gubun_Code_Mid").attr("disabled",true);
		                } else {
		                	$("#Select_Product_Gubun_Code_Mid").prepend("<option value = 'ALL'>중분류 선택</option>");
		                	$("#Select_Product_Gubun_Code_Mid > option:eq(0)").prop("selected",true);
			            	$("#Select_Product_Gubun_Code_Mid").attr("disabled",false);
			            	$("#btn_Search").attr('disabled', true);
		                }
		    			
	 		    	}
	    		});
		    });
			
	    	// 중분류 변경 시
		    $("#Select_Product_Gubun_Code_Mid").on("change", function() {
		    	prod_gubun_b = $("#Select_Product_Gubun_Code_Big").val();
		    	prod_gubun_m = $(this).val();
		    	
		    	if(prod_gubun_b == "ALL") {
					prod_gubun_b = "";
	    		}
		    	
		    	if(prod_gubun_m == "ALL") {
					prod_gubun_m = "";
	    		}
		    	
		    	$.ajax({
		            type: "POST",
		            url: "<%=Config.this_SERVER_path%>/Contents/Business/M909/S909S060400.jsp",
		            data: "prodgubun_big=" + prod_gubun_b + "&prodgubun_mid=" + prod_gubun_m,
		            success: function (html) {
		                $("#select_prod > option").remove();
		                var changNameResult = html.split("|");
		                for( var i = 0 ; i < changNameResult.length ; i++ ) {
		                	var value = changNameResult[i].split(",")[0]
		                	var name  = changNameResult[i].split(",")[1].trim();
		                	
			                $("#select_prod").append("<option value = " + value + ">" + name + "</option>");
		                }
		                
		                prod_name = $("#select_prod >option:eq(0)").val();
		                
		                if( $("#Select_Product_Gubun_Code_Mid").val() == "ALL" ) {
		                	$("#select_prod").prepend("<option value = 'ALL'>분류를 선택해 주세요</option>"); 
		                	$("#select_prod > option:eq(0)").prop("selected",true);
		                	
		                	$("#select_prod").attr("disabled",true);
		                	$("#btn_Search").attr('disabled', true);
		                	
		                	prod_name = "";
						} else if( prod_name == 'Empty_Value' ) {
			            	$("#select_prod").attr("disabled",true);
			            	$("#btn_Search").attr('disabled', true);
		                } else {
		                	$("#select_prod").prepend("<option value = 'ALL'>제품 선택</option>"); 
		                	$("#select_prod > option:eq(0)").prop("selected",true);
			            	$("#select_prod").attr("disabled",false);
			            	$("#btn_Search").attr('disabled', false);
		                }
		    			
	 		    	}
	    		});
		    	
		    	
		    });
	     
	    	if($("#Select_Product_Gubun_Code_Big option:selected").val() == "ALL" || 
	    	   $("#Select_Product_Gubun_Code_Mid option:selected").val() == "ALL" || 
	    	   $("#select_prod option:selected").val() == "ALL"){
	    	
	    		$("#btn_Search").attr('disabled', true);
	    	
	    	}
	    	
    });

    function fn_tagProcess(){
    	
    	var vSelect = <%=prg_autho.vSelect%>;
    	var vInsert = <%=prg_autho.vInsert%>;
    	var vUpdate = <%=prg_autho.vUpdate%>;
    	var vDelete = <%=prg_autho.vDelete%>;    	

		if(vSelect == "0") {
	    	$('button[id="select"]').each(function () {
                $(this).prop("disabled",true);
            });
   		}
		if(vInsert == "0") {
	    	$('button[id="insert"]').each(function () {
                $(this).prop("disabled",true);
            });
   		}
		if(vUpdate == "0") {
	    	$('button[id="update"]').each(function () {
                $(this).prop("disabled",true);
                $(this).attr("onclick", " ");
            });
   		}
		if(vDelete == "0") {
	    	$('button[id="delete"]').each(function () {
                $(this).prop("disabled",true);
            });
   		}
    }
   
    function fn_clearList() { 
        if ($("#MainInfo_List_contents").children().length > 0) {
            $("#MainInfo_List_contents").children().remove();
        }
        if ($("#SubInfo_List_contents").children().length > 0) {
            //$("#SubInfo_List_contents").children().remove();
        }        
        if ($("#ProcessInfo_seolbi").children().length > 0) {
            $("#ProcessInfo_seolbi").children().remove();
        }
        if ($("#ProcessInfo_sibang").children().length > 0) {
            $("#ProcessInfo_sibang").children().remove();
        }
        if ($("#ProcessInfo_processcheck").children().length > 0) {
            $("#ProcessInfo_processcheck").children().remove();
        }        
    }

    function fn_MainInfo_List(year) {
    	
        $.ajax({
            type: "POST",
            url: "<%=Config.this_SERVER_path%>/Contents/Business/M858/S858S010300.jsp",
            data : "year=" + year + "&prod_cd=" +prod_cd,
            success: function (html) {
                $("#MainInfo_List_contents").hide().html(html).fadeIn(100);
            }
        });
        
        $("#SubInfo_List_contents").children().remove();
    }
    
	function fn_DetailInfo_List(year, month) {    	
    
	console.log(month);
        $.ajax({
            type: "POST",
            url: "<%=Config.this_SERVER_path%>/Contents/Business/M858/S858S010310.jsp",
            data : "year=" + year + "&month=" + month + "&prod_cd=" + prod_cd,
            beforeSend: function () {
	        },
            success: function (html) {
                $("#SubInfo_List_contents").hide().html(html).fadeIn(100);
            },
	        error: function (xhr, option, error) {
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
     </div> <!-- /.row -->
	</div> <!-- /.container-fluid -->
  </div> <!-- /.content-header -->
    
    
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
          			<div class="input-group input-group-sm">
          				<%--  --%>
          				
          				<div class="input-group float-right" id="dateParent">
          					
          					<table>
          				<tr>
          				
          				<td>
                			제품 대분류
                			</td>
                			<td>
	              				<select class="form-control" id="Select_Product_Gubun_Code_Big">
                            		<% optCodeBig1 = (Vector)Product_Big_Gubun_Vector1.get(0);%>
	                        		<% optNameBig1 = (Vector)Product_Big_Gubun_Vector1.get(1);%>
	                              	<%for(int i=0; i<optNameBig1.size();i++) { %>
							  			<option value='<%=optCodeBig1.get(i).toString()%>'>
							  				<%=optNameBig1.get(i).toString()%>
							  			</option>
									<%} %>
								</select>
							</td>
	                     
	                        <td>
	                        	제품 중분류
	                        </td>
								<td>
	                      			<select class="form-control" id="Select_Product_Gubun_Code_Mid">
	                              		<% optCodeMid1 = (Vector)Product_Mid_Gubun_Vector1.get(0);%>
	                              		<% optNameMid1 = (Vector)Product_Mid_Gubun_Vector1.get(1);%>
	                              		<%for(int i=0; i<optNameMid1.size();i++){ %>
							  				<option value='<%=optCodeMid1.get(i).toString()%>'>
							  					<%=optNameMid1.get(i).toString()%>
							  				</option>
										<%} %>
									</select>
								</td>         
						
							<td>제품명</td>
	                    	<td>
	                      		<select class="form-control" id="select_prod">
	                      			
	                      			<% optCodeProd = (Vector)Product_Name_Vector1.get(0);%>
	                              	<% optNameProd = (Vector)Product_Name_Vector1.get(1);%>
	                            	<%for(int i = 0; i< optNameProd.size(); i++) { %>
									<option value='<%=optCodeProd.get(i).toString()%>'>
										<%=optNameProd.get(i).toString()%>
									</option>
								<%} %>
								</select>
							</td>
						<td>
						
						<td>연도</td>
						<td>
						<div class="input-group">
							<input type="text" class="form-control float-right" id="dateRange">
								<div class="input-group-append">
			        				<span class="input-group-text">년</span>
			      				</div>
						</div>
						</td>
						
						<td>
						<button type="button" id="btn_Search" class="btn btn-default">
										<i class="fas fa-search"></i>
									</button>
						</td>
						
						</tr>
          				</table>
	          	  		</div>	
          			</div>
		          </div>
					</div>
					<div class="card-body" id="MainInfo_List_contents">
					</div> 
				</div>
			</div> <!-- /.col-md-6 -->
		</div> <!-- /.row -->
		
		<div class="card card-primary card-outline">
	   	<div class="card-header">
	   		<h3 class="card-title">
	   			<i class="fas fa-edit">월별 상세 조회</i>
	   		</h3>
	   	</div>
	   	<div class="card-body" id="SubInfo_List_contents"></div>
	  </div>
	</div> <!-- /.container-fluid -->
</div> <!-- /.content -->