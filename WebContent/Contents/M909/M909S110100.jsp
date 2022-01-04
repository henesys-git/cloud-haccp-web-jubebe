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
	if(loginID == null || loginID.equals("")) {			                        // id가 Null 이거나 없을 경우
		response.sendRedirect(Config.this_SERVER_path + "/Contents/index.jsp");	// 로그인 페이지로 리다이렉트 한다.
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
	
	Vector optCode =  null;
    Vector optName =  null;
    
    Vector partgubun_bigVector = PartListComboData.getPartBigGubunDataAll(member_key);
    Vector partgubun_midVector = PartListComboData.getPartMidGubunDataAll("", member_key);
%>

<script type="text/javascript">
	var vPart_gubun_b	= "";
	var vPart_gubun_m	= "";
	var vPart_gubun_s	= "";
	var vgyugyeok		= "";
	var vPart_level		= "";
	var vPartCd			= "";
	var vRevisionNo		= "";
	var vPartCode		= "";
	
	var vPart_cd_alt	= "";
	var vPart_nm_alt	= "";
	var vPartgubun_big	= "";
	var vPartgubun_mid	= "";
	var vPartgubun_sm	= "";
	
	var FLAG			= false;
	
$(document).ready(function () {        
        
		fn_MainSubMenuSelect("<%=sMenuTitle%>");
 		$("#InfoContentTitle").html("원/부자재 코드정보");

    	fn_MainInfo_List();
        
	    fn_tagProcess('<%=JSPpage%>');
	    
	    $("#total_rev_check").change(function(){
			FLAG = !FLAG;
	    	
	    	if( FLAG )
	    	{
	    		alert("등록 / 수정/ 삭제 기능이 제한됩니다.");
	    		
	    		$("#insert").prop("disabled",true);
	    		$("#update").prop("disabled",true);
	    		$("#delete").prop("disabled",true);
	    	}
	    	else
	    	{
	    		$("#insert").prop("disabled",false);
	    		$("#update").prop("disabled",false);
	    		$("#delete").prop("disabled",false);
	    	}
	    	
	    	fn_MainInfo_List();
	    });
	    
	    $("#partgubun_mid").attr('disabled', true);
	    
	    $("#partgubun_big").on("change", function(){
	    	vPartgubun_big = $(this).val();
	    	
	    	if(vPartgubun_big == "ALL") {
	    		vPartgubun_big="";
	    	}
	    	
	    	$("#partgubun_mid").attr('disabled', false);
	    	
	    	 $.ajax({
		     	type: "POST",
		     	url: "<%=Config.this_SERVER_path%>/Contents/Business/M909/S909S110200.jsp",
		     	data: "partgubun_big="+ vPartgubun_big ,
		     	success: function (html) {
 		        	$("#partgubun_mid > option").remove();
 		            var changMidResult = html.split("|");
 		            
 		            for(var i=0; i<changMidResult.length; i++) {
 		            	var value = changMidResult[i].split(",")[0]
 		                var name  = changMidResult[i].split(",")[1].trim();
  		                $("#partgubun_mid").append("<option value="+value+">"+name+"</option>");
	                }
		            
 		            if($("#partgubun_big").val() == "ALL") {
		            	$("#partgubun_mid").prepend("<option value='ALL'>전체</option>"); 
		                $("#partgubun_mid > option:eq(0)").prop("selected",true);
		                $("#partgubun_mid").attr('disabled', true);
		           	}
 		            
 		            vPartgubun_mid=$("#partgubun_mid >option:eq(0)").val();
 		            fn_MainInfo_List();
 		        }
			});
	    });

	    $("#partgubun_mid").on("change", function(){
	    	vPartgubun_big = $("#partgubun_big").val();
	    	vPartgubun_mid = $(this).val();    	
	    	if($("#partgubun_mid").val()=="ALL") {
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

    function fn_LoadSubPage() {
        fn_clearList();
        fn_MainInfo_List();
    }

    function fn_clearList() {
        if ($("#MainInfo_List_contents").children().length > 0) {
            $("#MainInfo_List_contents").children().remove();
        }
        if ($("#sub_SubInfo_List_contents").children().length > 0) {
            $("#sub_SubInfo_List_contents").children().remove();
        }
    }
    
    //원자재등록정보
    function fn_MainInfo_List() {
    	 var revCheck = $("#total_rev_check").is(":checked"); 
    	
		if(vPartgubun_big=="ALL")
			vPartgubun_big="";
		if(vPartgubun_mid=="ALL")
			vPartgubun_mid="";
		if(vPartgubun_sm=="ALL")
			vPartgubun_sm=""; 
    	
        $.ajax({
            type: "POST",
            url: "<%=Config.this_SERVER_path%>/Contents/Business/M909/S909S110100.jsp",
            data:  "partgubun_big=" + vPartgubun_big 
            	+ "&partgubun_mid=" + vPartgubun_mid 
            	+ "&total_rev_check=" + revCheck,
            beforeSend: function () {
                $("#MainInfo_List_contents").children().remove();
            },
            success: function (html) {
                $("#MainInfo_List_contents").hide().html(html).fadeIn(100);
            }
        });
    }

    //문서코드상세정보 
    function fn_DetailInfo_List() {
        $.ajax({
            type: "POST",
            url: "<%=Config.this_SERVER_path%>/Contents/Business/M909/S909S140100.jsp",
            data: "CodeGroupGubun=" + vCodeGroupGubun,
            success: function (html) {
                $("#SubInfo_List_contents").hide().html(html).fadeIn(100);
            }
        });
    }
    
    function pop_fn_CodeCd_Insert(obj) {
    	var url = "<%=Config.this_SERVER_path%>/Contents/Business/M909/S909S110101.jsp";
    	var footer = '<button id="btn_Save" class="btn btn-info" style="width: 100px" onclick="SaveOderInfo();">저장</button>';
    	var title = obj.innerText;
    	//var title = "원자재코드등록";
    	var heneModal = new HenesysModal(url, 'standard', title, footer);
    	heneModal.open_modal();
    }
    
    function pop_fn_CodeCd_Update(obj) {
    	if(vPartCode.length < 1) {
    		heneSwal.warning("원부자재를 선택해 주세요");
 			return false;
        }
        
    	var url = "<%=Config.this_SERVER_path%>/Contents/Business/M909/S909S110102.jsp"
				  + "?part_code=" +vPartCode + "&revision_no=" + vRevisionNo;
    	var footer = '<button id="btn_Save" class="btn btn-info" style="width: 100px" onclick="SaveOderInfo();">저장</button>';
    	var title = obj.innerText;
    	var heneModal = new HenesysModal(url, 'standard', title, footer);
    	heneModal.open_modal();
    }

    function pop_fn_CodeCd_Delete(obj) {
    	if(vPartCode.length < 1) {
    		heneSwal.warning("원부자재를 선택해 주세요");
 			return false;
        }
    	
		var url = "<%=Config.this_SERVER_path%>/Contents/Business/M909/S909S110103.jsp"
				  + "?part_code=" +vPartCode + "&revision_no=" + vRevisionNo 
				  + "&part_gubun=" + vPart_Gubun;
		var footer = '<button id="btn_Save" class="btn btn-info" style="width: 100px"'
						   + 'onclick="SaveOderInfo3();">삭제</button>';
		var title = obj.innerText;
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
      </div><!-- /.col-->
      <div class="col-sm-6">
      	<div class="float-sm-right">
      		<button type = "button" onclick = "pop_fn_CodeCd_Insert(this)" id="insert" class= "btn btn-outline-dark">원자재코드등록</button>
			<button type = "button" onclick = "pop_fn_CodeCd_Update(this)" id="update" class= "btn btn-outline-success">원자재코드수정</button>
			<button type = "button" onclick = "pop_fn_CodeCd_Delete(this)" id="delete" class= "btn btn-outline-danger">원자재코드삭제</button>
      		<label style="width: auto; clear:both; margin-left:30px;">
            	Rev. No 전체보기
            	<input type="checkbox" id="total_rev_check" />
            </label>		
            <label style="width: ; clear:both; margin-left:3px;"></label>
      	</div>
      </div><!-- /.col -->
    </div> <!-- /.row -->
  </div> <!-- /.container-fluid-->
</div><!--  /.content-header -->

 <!--  Main content-->
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
	          	<table>
					<tr>
	                    <td>원자재 대분류</td>
	                    <td>
	                      	<select class="form-control" id="partgubun_big">
	                        	<% optCode = (Vector)partgubun_bigVector.get(0);%>
	                            <% optName = (Vector)partgubun_bigVector.get(1);%>
	                            <%for(int i=0; i<optName.size();i++) { %>
									<option value='<%=optCode.get(i).toString()%>'>
										<%=optName.get(i).toString()%>
									</option>
								<%} %>
							</select>
						</td>
	                           
	                    <td>원자재 중분류</td>
	                   	<td>
	                      	<select class="form-control" id="partgubun_mid">
	                        	<%	optCode =  (Vector)partgubun_midVector.get(0);%>
	                            <%	optName =  (Vector)partgubun_midVector.get(1);%>
	                            <%for(int i=0; i<optName.size();i++){ %>
									<option value='<%=optCode.get(i).toString()%>'>
										<%=optName.get(i).toString()%>
									</option>
								<%} %>
							</select>
						</td>                          
					</tr>
				</table>
	      	  </div>
	      	</div>
          <div class="card-body" id="MainInfo_List_contents"></div> 
        </div>
      </div> <!--/.col-md-6-->
    </div> <!-- /.row-->
  </div> <!--  /.container-fluid-->
</div><!-- /.content-->