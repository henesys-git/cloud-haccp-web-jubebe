<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*,java.util.*,javax.servlet.http.*"%>
<%@ page import="mes.client.comm.*" %>
<%@ page import="mes.client.common.*" %>
<%@ page import="mes.client.guiComponents.*" %>
<%@ page import="mes.client.util.*" %>
<%@ page import="mes.client.conf.*" %>

<!-- 
원부자재입출고관리 
yumsam
-->

<%
	String loginID = session.getAttribute("login_id").toString();
	String member_key = session.getAttribute("member_key").toString();
	if(loginID == null || loginID.equals("")) {         // id가 Null 이거나 없을 경우
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
	
	String GV_PROCESS_MODIFY = prcStatusCheck.GV_PROCESS_MODIFY;
	String GV_PROCESS_DELETE = prcStatusCheck.GV_PROCESS_DELETE;
	String GV_GET_NUM_PREFIX = prcStatusCheck.GV_PROCESS_NUMBER_GUBUN;
	
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
 	var vProdCurStock = "";
 	var vSeqNo = "";
 	var vProdDate = "";

	var vTableS858S060100;
	var TableS858S060100_Row_Index;
	var TableS858S060100_info;
	var TableS858S060100_Row_Count;
	
    $(document).ready(function () {
        fn_MainSubMenuSelect("<%=sMenuTitle%>");
        
		$("#InfoContentTitle").html("완제품 입출고 현황");
		fn_MainInfo_List();
		
        fn_tagProcess('<%=JSPpage%>');
		
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
    
    function fn_MainInfo_List() {
		if(vProdgubun_big == "ALL")
			vProdgubun_big = "";
		if(vProdgubun_mid == "ALL")
			vProdgubun_mid = "";
        
        $.ajax({
            type: "POST",
            url: "<%=Config.this_SERVER_path%>/Contents/Business/M858/S858S060100.jsp", 
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
   	        url: "<%=Config.this_SERVER_path%>/Contents/Business/M858/S858S060110.jsp",
   	        data: "prod_date=" + vProdDate + 
   	        	  "&seq_no=" + vSeqNo + 
   	        	  "&prod_cd=" + vProdCd + 
   	        	  "&prod_rev_no=" + vProdRevNo,
   	        success: function (html) {
   	            $("#SubInfo_List_contents").hide().html(html).fadeIn(100);
   	        }
   	    });
    	
		return;
	}
	
	// 신규 입고 수기 등록
	function pop_fn_ProdIpgo_Insert(obj) {
		
		var url = "<%=Config.this_SERVER_path%>/Contents/Business/M858/S858S060101.jsp?"
		var footer = '<button id="btn_Save" class="btn btn-info" onclick="SaveOderInfo();">입고 저장</button>'
		var title = obj.innerText;
		var heneModal = new HenesysModal(url, 'standard', title, footer);
		heneModal.open_modal();
	}
    
	// 재고보정(PLUS)
    function pop_fn_ProdIpgo_Additional_Insert(obj) {
    	if(vProdCd.length < 1) {
			heneSwal.warning('품목을 선택해주세요');
			return false;
		}
 		
		var url = "<%=Config.this_SERVER_path%>/Contents/Business/M858/S858S060111.jsp"
					+ "?prod_cd="+ vProdCd
					+ "&prod_rev_no=" + vProdRevNo
					+ "&prod_date=" + vProdDate
					+ "&prod_nm=" + vProdNm
					+ "&prod_cur_stock=" + vProdCurStock
					+ "&seq_no=" + vSeqNo;
		var footer = '<button id="btn_Save" class="btn btn-info" onclick="SaveOderInfo();">입고 저장</button>'
		var title = obj.innerText;
		var heneModal = new HenesysModal(url, 'standard', title, footer);
		heneModal.open_modal();
	}
	
  	// 재고보정(MINUS)
    function pop_fn_ProdChulgo_Insert(obj) {
  		
    	if(vProdCd.length < 1) {
    		heneSwal.warning('품목을 선택해주세요');
			return false;
		}
    	
    	var url = "<%=Config.this_SERVER_path%>/Contents/Business/M858/S858S060201.jsp"
		    	+ "?prod_cd="+ vProdCd
				+ "&prod_rev_no=" + vProdRevNo
				+ "&prod_date=" + vProdDate
				+ "&prod_nm=" + vProdNm
				+ "&prod_cur_stock=" + vProdCurStock
				+ "&seq_no=" + vSeqNo;
		var footer = '<button id="btn_Save" class="btn btn-info" onclick="SaveOderInfo();">출고 저장</button>';
	    var title = obj.innerText;
	    var heneModal = new HenesysModal(url, 'standard', title+"(S202S120201)", footer);
	    heneModal.open_modal();
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
			      		<button type="button" onclick="pop_fn_ProdIpgo_Insert(this)" id="insert" 
			      			class="btn btn-outline-dark">신규 입고 등록</button>
			      		<button type="button" onclick="pop_fn_ProdIpgo_Additional_Insert(this)" id="insert" 
			      			class="btn btn-outline-success">재고 보정 (PLUS)</button>
			      		<button type="button" onclick="pop_fn_ProdChulgo_Insert(this)" id="insert" 
			      			class="btn btn-outline-danger">재고 보정 (MINUS)</button>
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
		       				입출고 상세내역
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