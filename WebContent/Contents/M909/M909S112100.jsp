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
	if(loginID==null||loginID.equals("")){                            // id가 Null 이거나 없을 경우
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
	
	Vector optCode =  null;
    Vector optName =  null;
    Vector Process_gubunVector = CommonData.getProcessGubun_CodeAll(member_key);

%>

<script type="text/javascript">
 	var vstorage_no	= "";
 	var vrake_no = "";
 	var vplate_no = "";
 	var vcol_no = "";
 	var vconfYn="";
	
    $(document).ready(function () {        
        
		fn_MainSubMenuSelect("<%=sMenuTitle%>");
		$("#InfoContentTitle").html("창고환경설정");
		
    	fn_MainInfo_List();
        
	    fn_tagProcess('<%=JSPpage%>');
	    
	    $("#total_rev_check").change(function(){
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

    
    //문서코드정보
    function fn_MainInfo_List() {
    	
        $.ajax(
        {
            type: "POST",
            url: "<%=Config.this_SERVER_path%>/Contents/Business/M909/S909S112100.jsp",
            beforeSend: function () {
                $("#MainInfo_List_contents").children().remove();
            },
            success: function (html) {
                $("#MainInfo_List_contents").hide().html(html).fadeIn(100);
            }
        });
    }
    
	// 창고상세목록
    function fn_Detail_List() {
    	
        $.ajax(
        {
            type: "POST",
            url: "<%=Config.this_SERVER_path%>/Contents/Business/M909/S909S112110.jsp",
            data: "machineno="+ vstorage_no ,
            success: function (html) {
                $("#SubInfo_List_contents").hide().html(html).fadeIn(100);
            }
        });
    }
    
    //창고정보정보 등록
    function pop_fn_storage_no_Insert(obj) {   	
    	var url = "<%=Config.this_SERVER_path%>/Contents/Business/M909/S909S112101.jsp";
    	
       	var footer = "";
     	var title  = obj.innerText;
     	var heneModal = new HenesysModal(url, 'large', title, footer);
     	heneModal.open_modal();
	}
    
    function pop_fn_storage_no_Update(obj) {
    	if(vstorage_no.length < 1){
    		heneSwal.warning("창고정보를 선택해주세요");
 			return false;
        }

    	if(vconfYn=="Y"){
    		heneSwal.warning("창고환경정보가 생성되어 수정이 불가능합니다");
 			return false;
        }
    	
    	var url = "<%=Config.this_SERVER_path%>/Contents/Business/M909/S909S112102.jsp?storage_no=" + vstorage_no;
    	var footer = "";
     	var title  = obj.innerText;
     	var heneModal = new HenesysModal(url, 'large', title, footer);
     	heneModal.open_modal();
    }

    function pop_fn_storage_no_Delete(obj) {
    	if(vstorage_no.length < 1){
           	heneSwal.warning("창고정보를 선택해주세요");
 			return false;
        }
    	
    	if(vconfYn=="Y"){
    		heneSwal.warning("창고환경정보가 생성되어 삭제가 불가능합니다.");
 			return false;
        }
    	
    	var url = "<%=Config.this_SERVER_path%>/Contents/Business/M909/S909S112103.jsp?storage_no=" + vstorage_no;
       	var footer = "";
     	var title  = obj.innerText;
     	var heneModal = new HenesysModal(url, 'large', title, footer);
     	heneModal.open_modal();
       	
    }
    function pop_fn_storage_info_Create(obj) {
    	if(vstorage_no.length < 1){
           	heneSwal.warning("창고정보를 선택해주세요");
 			return false;
        }
    	
   		var dataJson = new Object(); // jSON Object 선언 
			dataJson.vstorage_no = vstorage_no;
			dataJson.vrake_no = vrake_no;
			dataJson.vplate_no = vplate_no;
			dataJson.vcol_no = vcol_no;
			dataJson.member_key = "<%=member_key%>";
			
		SendTojsp(JSON.stringify(dataJson), "M909S112100E111");
		
		return false;
    }
    
	function SendTojsp(bomdata, pid){
		
	    $.ajax({
	         type: "POST",
	         dataType: "json", // Ajax로 json타입으로 보낸다.
	         url: "<%=Config.this_SERVER_path%>/Contents/CommonView/insert_update_delete_json.jsp", 
	         data:  "bomdata=" + bomdata + "&pid=" + pid,
	         success: function (html) {
	        	 if(html>-1){
	        	   	parent.fn_MainInfo_List();
	                parent.$("#ReportNote").children().remove();
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
      		<button type = "button" onclick = "pop_fn_storage_no_Insert(this)" id="insert" class= "btn btn-outline-dark">창고정보등록</button>
			<button type = "button" onclick = "pop_fn_storage_no_Update(this)" id="update" class= "btn btn-outline-success">창고정보수정</button>
			<button type = "button" onclick = "pop_fn_storage_no_Delete(this)" id="delete" class= "btn btn-outline-danger">창고정보삭제</button>
			<button type = "button" onclick = "pop_fn_storage_info_Create(this)" id="insert" class= "btn btn-outline-warning">창고(저장고정보)환경생성</button>
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
	      </div>
          <div class="card-body" id="MainInfo_List_contents"></div> 
        </div>
     </div> <!--/.col-md-12-->
    </div> <!-- /.row-->
        <div class="card card-primary card-outline">
          <div class="card-header">
          	<h3 class="card-title">
          		<i class="fas fa-edit">세부 정보</i>
          	</h3>
	      </div>
          <div class="card-body">
          	<ul class="nav nav-tabs" id="custom-tabs-one-tab" role="tablist">
	       		<li class="nav-item" onclick='fn_Detail_List()'>
	       			<a class="nav-link" id="ImportInfo_List" data-toggle="pill" href="#SubInfo_List_contents" role="tab">창고환경상세정보</a>
	       		</li>
	        </ul>
	        <div class="tab-content" id="custom-tabs-one-tabContent">
	     		<div class="tab-pane fade" id="SubInfo_List_contents" role="tabpanel"></div>
	        </div>
          </div>  
        </div> 
  </div> <!--  /.container-fluid-->
</div><!-- /.content-->