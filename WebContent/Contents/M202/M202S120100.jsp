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
    Vector partgubun_midVector = PartListComboData.getPartMidGubunDataAll("", member_key);
    Vector partgubun_bigVector = PartListComboData.getPartBigGubunDataAll(member_key);
%>

<script type="text/javascript"> 
	var vPartgubun_big = "";
	var vPartgubun_mid = "";
 	var vPartCd = "";
 	var vPartRevNo = "";
 	var vPartNm = "";
 	var vPartCurStock = "";
 	var vTraceKey = ""; 	
 	
	var vmachineno="";
	var vrakes="";
	var vplate="";
	var vcolm="";
	var vio_amt="";
	var vpre_amt="";
	var vpost_amt="";	

	var lvmachineno="";
	var lvrakes="";
	var lvplate="";
	var lvcolm="";
	var lvio_amt="";
	var lvpre_amt="";
	var lvpost_amt="";	
	var	vipgo_no="";
	var vio_seqno="";

	var sc_width="";
	var vTableS202S120200;
	var TableS202S120200_Row_Index;
	var TableS202S120200_info;
	var TableS202S120200_Row_Count;
	
    $(document).ready(function () {
        fn_MainSubMenuSelect("<%=sMenuTitle%>");
        
		$("#InfoContentTitle").html("원부재료/부자재 입고 현황");
		fn_MainInfo_List();
		
        fn_tagProcess('<%=JSPpage%>');
		
        $("#partgubun_mid").attr("disabled", true);
        
        $("#partgubun_big").on("change", function() {
	    	vPartgubun_big = $(this).val();
	    	
	    	if(vPartgubun_big == "ALL") {
	    		vPartgubun_big = "";
	    	}
	    	
	    	$.ajax({
				type: "POST",
				url: "<%=Config.this_SERVER_path%>/Contents/Business/M202/S202S050250.jsp",
				data: "partgubun_big="+ vPartgubun_big,
				success: function (html) {
					$("#partgubun_mid > option").remove();
				    var changMidResult = html.split("|");
				    
				    for(var i=0; i<changMidResult.length; i++) {
				    	var value = changMidResult[i].split(",")[0]
				    	var name  = changMidResult[i].split(",")[1].trim();
			        	$("#partgubun_mid").append("<option value="+value+">"+name+"</option>");
					}
				    vPartgubun_mid = $("#partgubun_mid >option:eq(0)").val();
				    
				    if($("#partgubun_big").val() == "ALL") {
	                	$("#partgubun_mid").prepend("<option value = 'ALL'>전체</option>"); 
	                	$("#partgubun_mid > option:eq(0)").prop("selected",true);
	                	$("#partgubun_mid").attr("disabled",true);
	                	vPartgubun_mid = "";
					} else if(vPartgubun_mid == 'Empty_Value') {
		            	$("#partgubun_mid").attr("disabled",true);
	                } else {
		            	$("#partgubun_mid").attr("disabled",false);
	                }
		                
	    			fn_MainInfo_List();
				}
			});
	    });

        $("#partgubun_mid").on("change", function() {
	    	vPartgubun_big = $("#partgubun_big").val();
	    	vPartgubun_mid = $(this).val();
	    	
	    	if($("#partgubun_mid").val() == "ALL") {
	    		fn_MainInfo_List();
	    		return;
	    	}
	    	
	    	fn_MainInfo_List();
	    });
        
        loadJs(heneServerPath + '/js/auth-button/auth-button.js');
        
        var dt = new Date();
        
        console.log(dt);
        
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
		if(vPartgubun_big == "ALL")
			vPartgubun_big = "";
		if(vPartgubun_mid == "ALL")
			vPartgubun_mid = "";
        
        $.ajax({
            type: "POST",
            url: "<%=Config.this_SERVER_path%>/Contents/Business/M202/S202S120100.jsp", 
            data: "partgubun_big="+ vPartgubun_big + "&partgubun_mid="+ vPartgubun_mid,
            beforeSend: function () {
                $("#MainInfo_List_contents").children().remove();
            },
            success: function (html) {
                $("#MainInfo_List_contents").hide().html(html).fadeIn(100);
            }
        });
        
        $("#SubInfo_List_Doc").children().remove();
        $("#ImportInspect_Request").children().remove();
        $("#SubInfo_List_contents").children().remove();
    }
    
  	// 입고내역
	function fn_DetailInfo_List() {
  		
    	$.ajax({
   	        type: "POST",
   	        url: "<%=Config.this_SERVER_path%>/Contents/Business/M202/S202S120110.jsp",
   	        data: "trace_key=" + vTraceKey + 
   	        	  "&part_cd=" + vPartCd + 
   	        	  "&part_rev_no=" + vPartRevNo,
   	        success: function (html) {
   	            $("#SubInfo_List_contents").hide().html(html).fadeIn(100);
   	        }
   	    });
    	
		return;
	}
	
	// 신규 입고 수기 등록
	function pop_fn_PartIpgo_Insert(elem) {
		
		var url = "<%=Config.this_SERVER_path%>/Contents/Business/M202/S202S120101.jsp?"
		var footer = '<button id="btn_Save" class="btn btn-info" onclick="SaveOderInfo();">입고 저장</button>'
		var title = elem.innerText;
		var heneModal = new HenesysModal(url, 'standard', title, footer);
		heneModal.open_modal();
	}
    
	// 재고보정(PLUS)
    function pop_fn_PartIpgo_Additional_Insert(elem) {
    	if(vPartCd.length < 1) {
			heneSwal.warning('품목을 선택해주세요');
			return false;
		}
 		
		var url = "<%=Config.this_SERVER_path%>/Contents/Business/M202/S202S120111.jsp"
					+ "?part_cd="+ vPartCd
					+ "&part_rev_no=" + vPartRevNo
					+ "&part_nm=" + vPartNm
					+ "&part_cur_stock=" + vPartCurStock
					+ "&trace_key=" + vTraceKey;
		var footer = '<button id="btn_Save" class="btn btn-info" onclick="SaveOderInfo();">입고 저장</button>'
		var title = elem.innerText;
		var heneModal = new HenesysModal(url, 'standard', title, footer);
		heneModal.open_modal();
	}
	
  	// 재고보정(MINUS)
    function pop_fn_PartChulgo_Insert(elem) {
  		
    	if(vPartCd.length < 1) {
    		heneSwal.warning('품목을 선택해주세요');
			return false;
		}
    	
    	var url = "<%=Config.this_SERVER_path%>/Contents/Business/M202/S202S120201.jsp"
		    	+ "?part_cd="+ vPartCd
				+ "&part_rev_no=" + vPartRevNo
				+ "&part_nm=" + vPartNm
				+ "&part_cur_stock=" + vPartCurStock
				+ "&trace_key=" + vTraceKey;
		var footer = '<button id="btn_Save" class="btn btn-info" onclick="SaveOderInfo();">출고 저장</button>';
	    var title = elem.innerText;
	    var heneModal = new HenesysModal(url, 'standard', title, footer);
	    heneModal.open_modal();
    }
  	
 	// 원부자재 입고
    function insertPart(elem) {
    	if(vPartCd.length < 1) {
			heneSwal.warning('품목을 선택해주세요');
			return false;
		}
 		
		var url = "<%=Config.this_SERVER_path%>/Contents/Business/M202/S202S120121.jsp"
					+ "?part_cd="+ vPartCd
					+ "&part_rev_no=" + vPartRevNo
					+ "&part_nm=" + vPartNm
					+ "&part_cur_stock=" + vPartCurStock
					+ "&trace_key=" + vTraceKey;
		var footer = '<button id="btn_Save" class="btn btn-info" onclick="SaveOderInfo();">입고 저장</button>'
		var title = elem.innerText;
		var heneModal = new HenesysModal(url, 'standard', title, footer);
		heneModal.open_modal();
	}
	
  	// 원부자재 출고
    function takeoutPart(elem) {
  		
    	if(vPartCd.length < 1) {
    		heneSwal.warning('품목을 선택해주세요');
			return false;
		}
    	
    	var url = "<%=Config.this_SERVER_path%>/Contents/Business/M202/S202S120131.jsp"
		    	+ "?part_cd="+ vPartCd
				+ "&part_rev_no=" + vPartRevNo
				+ "&part_nm=" + vPartNm
				+ "&part_cur_stock=" + vPartCurStock
				+ "&trace_key=" + vTraceKey;
		var footer = '<button id="btn_Save" class="btn btn-info" onclick="SaveOderInfo();">출고 저장</button>';
	    var title = elem.innerText;
	    var heneModal = new HenesysModal(url, 'standard', title, footer);
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
	      		<!-- <button type="button" onclick="insertPart(this)" id="insert" 
	      			class="btn btn-outline-success btn-user">원부자재 입고</button>
	      		<button type="button" onclick="takeoutPart(this)" id="insert" 
	      			class="btn btn-outline-danger btn-user">원부자재 출고</button> -->
	      		<button type="button" onclick="pop_fn_PartIpgo_Insert(this)" id="insert" 
	      			class="btn btn-outline-dark btn-manager">신규 입고 등록</button>
	      		<button type="button" onclick="pop_fn_PartIpgo_Additional_Insert(this)" id="insert" 
	      			class="btn btn-outline-success btn-manager">재고 보정 (PLUS)</button>
	      		<button type="button" onclick="pop_fn_PartChulgo_Insert(this)" id="insert" 
	      			class="btn btn-outline-danger btn-manager">재고 보정 (MINUS)</button>
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
			                        	<select class="form-control" id="partgubun_mid" >
			                                <%	optCode = (Vector)partgubun_midVector.get(0);%>
			                                <%	optName = (Vector)partgubun_midVector.get(1);%>
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