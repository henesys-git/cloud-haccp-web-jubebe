<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*,java.util.*,javax.servlet.http.*"%>
<%@ page import="mes.client.comm.*" %>
<%@ page import="mes.client.common.*" %>
<%@ page import="mes.client.guiComponents.*" %>
<%@ page import="mes.client.util.*" %>
<%@ page import="mes.client.conf.*" %>
<%@ page import="org.json.simple.*"%><%@ include file="/strings.jsp" %>
<%  	
	String loginID = session.getAttribute("login_id").toString();
	String member_key = session.getAttribute("member_key").toString();
	if(loginID==null||loginID.equals("")){                            				// id가 Null 이거나 없을 경우
		response.sendRedirect(Config.this_SERVER_path + "/Contents/index.jsp");    // 로그인 페이지로 리다이렉트 한다.
	}

	String sMenuTitle = request.getParameter("MenuTitle").toString();
	String sProgramId = request.getParameter("programId").toString();
	String sHeadmenuID= request.getParameter("HeadmenuID").toString();
	String sHeadmenuName= request.getParameter("HeadmenuName").toString();
	
	Get_Program_button_Autho prg_autho = new Get_Program_button_Autho(loginID,sProgramId);	

	CurrentPage jspPageName = new CurrentPage(request.getRequestURI());
	String JSPpage = jspPageName.GetJSP_FileName();
	ProcesStatusCheck prcStatusCheck = new ProcesStatusCheck(JSPpage+"|"+"NON"+"|");
	
	String GV_PROCESS_MODIFY	= prcStatusCheck.GV_PROCESS_MODIFY;
	String GV_PROCESS_DELETE	= prcStatusCheck.GV_PROCESS_DELETE;
	String GV_GET_NUM_PREFIX = prcStatusCheck.GV_PROCESS_NUMBER_GUBUN; 
	
	Vector optCodeBig1 = null;
    Vector optNameBig1 = null;
    
    Vector optCodeMid1 = null;
    Vector optNameMid1 = null;
    
    Vector Product_Big_Gubun_Vector1 = CommonData.getProductBigGubun(true,member_key);
    Vector Product_Mid_Gubun_Vector1 = CommonData.getProductMidGubun("", true, member_key);
    
    System.out.println("대분류 : " + Product_Big_Gubun_Vector1);
    System.out.println("중분류 : " + Product_Mid_Gubun_Vector1);
%>

<script type="text/javascript">
 	var prod_cd			= "";
 	var revision_no		= "";
	var prod_gubun_b	= "";
	var prod_gubun_m	= "";
	var FLAG			= false;
	var Gubun_FLAG		= true;
	
	$(document).ready(function () {
		fn_MainSubMenuSelect("<%=sMenuTitle%>");
		
		$("#InfoContentTitle").html("제품정보");

		$("#Select_Product_Gubun_Code_Mid").attr("disabled", true);
		
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
	                
	                if( $("#Select_Product_Gubun_Code_Big").val() == "ALL" ) {
	                	$("#Select_Product_Gubun_Code_Mid").prepend("<option value = 'ALL'>전체</option>"); 
	                	$("#Select_Product_Gubun_Code_Mid > option:eq(0)").prop("selected",true);
	                	
	                	$("#Select_Product_Gubun_Code_Mid").attr("disabled",true);
	                	
	                	prod_gubun_m = "";
					} else if( prod_gubun_m == 'Empty_Value' ) {
		            	$("#Select_Product_Gubun_Code_Mid").attr("disabled",true);
	                } else {
		            	$("#Select_Product_Gubun_Code_Mid").attr("disabled",false);
	                }
		                
	    			fn_MainInfo_List();
 		    	}
    		});
	    });
		
    	// 중분류 변경 시
	    $("#Select_Product_Gubun_Code_Mid").on("change", function() {
	    	prod_gubun_b = $("#Select_Product_Gubun_Code_Big").val();
	    	prod_gubun_m = $(this).val();
	    	
	    	fn_MainInfo_List();
	    });

		fn_MainInfo_List();
        
	    fn_tagProcess('<%=JSPpage%>');
	    
	    // 삭제된 정보 조회 여부 체크
	    $("#total_rev_check").change(function(){
	    	FLAG = !FLAG;
	    	
	    	if(FLAG) {
	    		heneSwal.warningTimer("등록 / 수정 / 삭제 기능이 제한됩니다");
	    		
	    		$("#insert").prop("disabled",true);
	    		$("#update").prop("disabled",true);
	    		$("#delete").prop("disabled",true);
	    	} else {
	    		$("#insert").prop("disabled",false);
	    		$("#update").prop("disabled",false);
	    		$("#delete").prop("disabled",false);
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

    function fn_MainInfo_List() {
    	var revCheck = $("#total_rev_check").is(":checked");
		
        $.ajax({
            type: "POST",
            url: "<%=Config.this_SERVER_path%>/Contents/Business/M909/S909S060100.jsp",
            data: "prodgubun_big=" + prod_gubun_b
				+ "&prodgubun_mid="	+ prod_gubun_m
				+ "&total_rev_check=" + revCheck,
            beforeSend: function () {
                $("#MainInfo_List_contents").children().remove();
            },
            success: function (html) {
				$("#MainInfo_List_contents").hide().html(html).fadeIn(100);
            }
        });
    }
    
    // 완제품 정보 등록
    function pop_fn_ProductCd_Insert(obj) {
    	var url = "<%=Config.this_SERVER_path%>/Contents/Business/M909/S909S060101.jsp";
    	var footer = '<button id="btn_Save" class="btn btn-info"'
    						+ 'onclick="executeQuery();">저장</button>';
    	var title = obj.innerText;
    	var heneModal = new HenesysModal(url, 'large', title, footer);
    	heneModal.open_modal();
    }
	
    // 완제품 정보 수정
    function pop_fn_ProductCd_Update(obj) {
    	if(prod_cd.length < 1) {
    		heneSwal.warning("제품을 선택하세요");
 			return false;
    	}
    	
    	var url = "<%=Config.this_SERVER_path%>/Contents/Business/M909/S909S060102.jsp"
				+ "?prod_cd="		+ prod_cd
				+ "&revision_no="	+ revision_no;
    	var footer = '<button id="btn_Save" class="btn btn-info"'
    						+ 'onclick="executeQuery();">저장</button>';
    	var title = obj.innerText;
    	var heneModal = new HenesysModal(url, 'standard', title, footer);
    	heneModal.open_modal();
    }
	
    // 완제품 정보 삭제
    function pop_fn_ProductCd_Delete(obj) {
		if(prod_cd.length < 1){
			heneSwal.warningTimer("삭제할 제품 정보를 선택하세요");
 			return false;
		}
		
		var obj = { "prod_cd":prod_cd };
		
		var objStr = JSON.stringify(obj);
		
		var chekrtn = confirm('해당 제품 정보를 삭제하시겠습니까?');
		
		if(chekrtn){
	    	executeQuery1(objStr, "M909S060100E103");
	    	prod_gubun_b = "",prod_gubun_m = "";
	    } else{
    		return false;
    	}
	}
    
    function executeQuery1(prmtr, pid){
		$.ajax({
	        type: "POST",
	        dataType: "json",
	        url: "<%=Config.this_SERVER_path%>/Contents/CommonView/insert_update_delete_json.jsp", 
	        data: {"bomdata" : prmtr, "pid" : pid},
	        success: function (rcvData) {
	        	if(rcvData < 0) {
	        		heneSwal.errorTimer("제품 삭제 실패했습니다, 다시 시도해주세요");
	        	} else {
	        		heneSwal.successTimer("해당 제품 정보가 삭제되었습니다");
		        	parent.fn_MainInfo_List();
		 	     	$('#modalReport').modal('hide');
	        	}
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
      </div><!-- /.col-->
      <div class="col-sm-6">
      	<div class="float-sm-right">
      		<button type="button" onclick="pop_fn_ProductCd_Insert(this)" id="insert" class="btn btn-outline-dark">등록</button>
			<button type="button" onclick="pop_fn_ProductCd_Update(this)" id="update" class="btn btn-outline-success">수정</button>
			<button type="button" onclick="pop_fn_ProductCd_Delete(this)" id="delete" class="btn btn-outline-danger">삭제</button>
      		<label>
            	Rev. No 전체보기
            	<input type="checkbox" id="total_rev_check">
	        </label>
      	</div>
      </div><!-- /.col -->
    </div> <!-- /.row -->
  </div> <!-- /.container-fluid-->
</div><!--  /.content-header -->

 <!--  Main content-->
<div class="content">
	<div class="container-fluid">
		<div class="row">
			<div class="col-md-12">	<!-- needtocheck, 제품대분류 col-mid-6으로 해서 오른쪽으로 둬야됨 -->
				<div class="card card-primary card-outline">
					<div class="card-header">
					   <h3 class = "card-title">
					   	<i class="fas fa-edit" id="InfoContentTitle"></i>
					   </h3>
					   <div class="card-tools">
						<table style="width:100%">
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
	                        	<td>제품 중분류</td>
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
							</tr>
						</table>
						</div>
	      			</div>
          			<div class="card-body" id="MainInfo_List_contents">
          			</div>
        		</div>
      		</div> <!--/.col-md-6-->
    	</div> <!-- /.row-->
  	</div> <!--  /.container-fluid-->
</div><!-- /.content-->