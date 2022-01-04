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
	if(loginID==null||loginID.equals("")){                            			// id가 Null 이거나 없을 경우
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
	String GV_GET_NUM_PREFIX	= prcStatusCheck.GV_PROCESS_NUMBER_GUBUN; 
	
	Vector optCode =  null;
    Vector optName =  null;
    
    Vector optCodeBig =  null;
    Vector optNameBig =  null;
    
    Vector Process_gubunVector = CommonData.getProcess_gubun(member_key);
    String Process_gubun = ((Vector)Process_gubunVector.get(0)).get(0).toString();
    
    Vector Process_gubunBigVector = CommonData.getProcess_gubun_big(Process_gubun,member_key);
    String Process_gubun_big = ((Vector)Process_gubunBigVector.get(0)).get(0).toString();
%>

 <script type="text/javascript">
 	var vProcCd					= "";
 	var vRevisionNo				= "";
 	var vProcess_gubun			= "";
 	var vProcess_gubun_big		= "";
 	var FLAG					= false;

    $(document).ready(function () {        
        
		fn_MainSubMenuSelect("<%=sMenuTitle%>");
		$("#InfoContentTitle").html("공정코드정보");
		
	    $("#select_CheckGubunCode").on("change", function(){
	    	vProcess_gubun = $(this).val();
	    	
	    	// 대분류 코드를 Refresh한다
	    	 $.ajax({
	            type: "POST",
	            url: "<%=Config.this_SERVER_path%>/Contents/Business/M909/S909S120200.jsp",
   		       	data: "Process_gubun="+ vProcess_gubun,
   				success: function (html) {
   		        	$("#select_CheckGubunCodeBig > option").remove();
   		        	var changeBigResult = html.split("|");
  		                for(var i = 0 ; i < changeBigResult.length; i++) {
  		                	var value = changeBigResult[i].split(",")[0];
  		                	var name  = changeBigResult[i].split(",")[1].trim();
   		                $("#select_CheckGubunCodeBig").append("<option value="+value+">"+name+"</option>");
   		            }
   		      		vProcess_gubun_big = $("#select_CheckGubunCodeBig > option:eq(0)").val();
				    fn_MainInfo_List();
   		     	}
    		});
	    });
		
		
		$("#select_CheckGubunCodeBig").on("change", function(){
			vProcess_gubun_big = $(this).val();
    		fn_MainInfo_List();
			
	    });
		
		$("#select_CheckGubunCode option:eq(0)").prop("selected", true);
	    vProcess_gubun = $("#select_CheckGubunCode").val(); 

		$("#select_CheckGubunCodeBig option:eq(0)").prop("selected", true);
		vProcess_gubun_big = $("#select_CheckGubunCodeBig").val(); 
	    
    	fn_MainInfo_List();
        
	    fn_tagProcess('<%=JSPpage%>');
	    
	    $("#total_rev_check").change(function(){
			FLAG = !FLAG;
	    	
	    	if( FLAG )
	    	{
	    		alert("등록 / 수정 / 삭제 기능이 제한됩니다.");
	    		
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
    }
    
    //문서코드정보
    function fn_MainInfo_List() {
    	var revCheck = $("#total_rev_check").is(":checked"); 
    	
    	console.log("vProcess_gubun_big=="+ vProcess_gubun_big);
        $.ajax(
        {
            type: "POST",
            url: "<%=Config.this_SERVER_path%>/Contents/Business/M909/S909S120100.jsp",
            data: "Process_gubun=" + vProcess_gubun
            	+ "&Process_gubun_big=" + vProcess_gubun_big
				+ "&total_rev_check=" + revCheck ,
            beforeSend: function () {
                $("#MainInfo_List_contents").children().remove();
            },
            success: function (html) {
                $("#MainInfo_List_contents").hide().html(html).fadeIn(100);
            },
            error: function (xhr, option, error) {

            }
        });
    }
    
    //공정코드정보 (PopUp)
    function pop_fn_ProcCd_Insert(obj) {
    	var modalContentUrl;
        
        	modalContentUrl = "<%=Config.this_SERVER_path%>/Contents/Business/M909/S909S120101.jsp"
						+ "?Process_gubun=" + vProcess_gubun
						+ "&Process_gubun_big=" + vProcess_gubun_big;
       	
        var footer = '<button id="btn_Save" class="btn btn-info" style="width: 100px" onclick="SaveOderInfo();">저장</button>';
        var title  = obj.innerText;
        var heneModal = new HenesysModal(modalContentUrl, 'large', title, footer);
        heneModal.open_modal();
        	
     }
    
    function pop_fn_ProcCd_Update(obj) {
    	if(vProcCd.length < 1){
    		heneSwal.warning("공정정보를 선택하세요");
 			return false;
        }
    	var modalContentUrl;

    	modalContentUrl = "<%=Config.this_SERVER_path%>/Contents/Business/M909/S909S120102.jsp"
       					+ "?ProcCd="		+ vProcCd
						+ "&RevisionNo="	+ vRevisionNo;
    	
    	 var footer = '<button id="btn_Save" class="btn btn-info" style="width: 100px" onclick="SaveOderInfo();">저장</button>';
         var title  = obj.innerText;
         var heneModal = new HenesysModal(modalContentUrl, 'large', title, footer);
         heneModal.open_modal();
    }

    function pop_fn_ProcCd_Delete(obj) {
    	if(vProcCd.length < 1){
    		heneSwal.warning("공정정보를 선택하세요");
 			return false;
        }
    	var modalContentUrl;
    	
    	modalContentUrl = "<%=Config.this_SERVER_path%>/Contents/Business/M909/S909S120103.jsp"
						+ "?ProcCd="		+ vProcCd
						+ "&RevisionNo="	+ vRevisionNo;
    	
    	 var footer = '<button id="btn_Save" class="btn btn-info" style="width: 100px" onclick="SaveOderInfo();">삭제</button>';
         var title  = obj.innerText;
         var heneModal = new HenesysModal(modalContentUrl, 'large', title, footer);
         heneModal.open_modal();
    }
</script>
    
<!-- Content Header (Page header) -->
<div class="content-header">
  <div class="container-fluid">
    <div class="row mb-2">
      <div class="col-sm-6">
        <h1 class="m-0 text-dark" id="MenuTitle">여기에 메뉴 타이틀</h1>
      </div><!-- /.col -->
      <div class="col-sm-6">
      	<div class="float-sm-right">
      		<button type="button" onclick="pop_fn_ProcCd_Insert(this)" id="insert" class="btn btn-outline-dark">공정코드등록</button>
      		<button type="button" onclick="pop_fn_ProcCd_Update(this)" id="update" class="btn btn-outline-success">공정코드수정</button>
      		<button type="button" onclick="pop_fn_ProcCd_Delete(this)" id="delete" class="btn btn-outline-danger">공정코드삭제</button>
      		<label style="width: ;  clear:both; margin-left:3px;"></label>
	            
	        <label style="width: auto; clear:both; margin-left:30px;">
	        Rev. No 전체보기
	        <input type="checkbox" id="total_rev_check"  />
	        </label>
      	</div>
      </div><!-- /.col -->
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
          	<div style="float: right">
					<table>
						<tr>
                           	<td>
                           		<div class="panel-heading" style="font-size:16px; font-weight: bold"  id="InfoContentTitle"></div>
                           	</td>
                           	<td>공정구분 :</td>
                            <td>
	                        	<select class="form-control" id="select_CheckGubunCode" style="width: 120px">
	                                <%	optCode =  (Vector)Process_gubunVector.get(0);%>
	                                <%	optName =  (Vector)Process_gubunVector.get(1);%>
	                                <%for(int i=0; i<optName.size();i++){ %>
									  <option value='<%=optCode.get(i).toString()%>'><%=optName.get(i).toString()%></option>
									<%} %>
								</select>
							</td>
                           	<td>공정구분 대분류 :</td>
							<td>
	                        	<select class="form-control" id="select_CheckGubunCodeBig" style="width: 120px">
	                                <%	optCodeBig =  (Vector)Process_gubunBigVector.get(0);%>
	                                <%	optNameBig =  (Vector)Process_gubunBigVector.get(1);%>
	                                <%for(int i=0; i<optNameBig.size();i++){ %>
									  <option value='<%=optCodeBig.get(i).toString()%>'><%=optNameBig.get(i).toString()%></option>
									<%} %>
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
    </div> <!-- /.row -->
  </div><!-- /.container-fluid -->
</div> <!-- /.content -->