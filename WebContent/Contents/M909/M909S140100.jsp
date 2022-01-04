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
    Vector codeGroupVector = CommonData.getCodeGroupDataAll(member_key);

// 	로그인한 아이디의 그룹 코드를 가져오는 벡터
	Vector UserGroupVectorID = CommonData.getUserGroupDataID(loginID,member_key);
	Vector optCodeIDVector = (Vector)UserGroupVectorID.get(0); 
	String optCodeID =  optCodeIDVector.get(0).toString();
%>

 <script type="text/javascript">
 	var vCodeGroupGubun		= "";  
 	var vCodeValue			= "";
 	var vRevisionNo			= "";
 	var vDetailCodeValue	= "";  
 	var vDetailRevisionNo	= "";  
 	var vBigo				= "";
 	var FLAG				= false;
	
    $(document).ready(function () {        
        
		fn_MainSubMenuSelect("<%=sMenuTitle%>");
		$("#InfoContentTitle").html("공통코드목록");
		$("#InfoContentTitle2").html("코드상세정보");

    	fn_MainInfo_List();
        
	    $("#select_CodeGroupGubunCode").on("change", function(){
	    	alert("test1");
	    	vCodeGroupGubun = $(this).val();
	    	fn_MainInfo_List();
	    });
	    
	    fn_tagProcess('<%=JSPpage%>');
	    
	    $("#total_rev_check").change(function() {
			FLAG = !FLAG;
	    	
	    	if( FLAG ) {
	    		alert("등록 / 수정 / 삭제 기능이 제한됩니다.");
	    		
	    		$("#insert_group").prop("disabled",true);
	    		$("#insert").prop("disabled",true);
	    		$("#update").prop("disabled",true);
	    		$("#delete").prop("disabled",true);
	    	} else {
	    		$("#insert_group").prop("disabled",false);
	    		$("#insert").prop("disabled",false);
	    		$("#update").prop("disabled",false);
	    		$("#delete").prop("disabled",false);
	    	}
	    	
	    	fn_MainInfo_List();
	    	$('#DetailInfo_List_contents').hide();
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
		if("<%=optCodeIDVector.get(0).toString()%>" != "GRCD002") {
			$('button[id="insert_group"]').each(function () {
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
        if ($("#SubInfo_List_contents").children().length > 0) {
            $("#SubInfo_List_contents").children().remove();
        }        
        if ($("#sub_SubInfo_List_contents").children().length > 0) {
            $("#sub_SubInfo_List_contents").children().remove();
        }
    }
    
    //문서코드정보
    function fn_MainInfo_List() {
    	var revCheck = $("#total_rev_check").is(":checked"); 
    	
        if(vCodeGroupGubun == "ALL") {
        	vCodeGroupGubun = "";
        }
        
        $.ajax({
            type: "POST",
            url: "<%=Config.this_SERVER_path%>/Contents/Business/M909/S909S140100.jsp",
            data: "CodeGroupGubun=" + vCodeGroupGubun + "&total_rev_check=" + revCheck ,
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
    	let revCheck = $("#total_rev_check").is(":checked");
    	
        $.ajax({
            type: "POST",
            url: "<%=Config.this_SERVER_path%>/Contents/Business/M909/S909S140110.jsp",
            data: "CodeGroupGubun=" + vCodeGroupGubun + "&total_rev_check=" + revCheck ,
            success: function (html) {
                $("#DetailInfo_List_contents").hide().html(html).fadeIn(100);
            }
        });
    }
    
    //문서코드그룹 등록
    function pop_fn_CodeCd_group_Insert(obj) {
    	let url;
    	
    	if(vCodeGroupGubun.length < 1)
    		url = "<%=Config.this_SERVER_path%>/Contents/Business/M909/S909S140111.jsp?CodeGroupGubun=" + vCodeGroupGubun;
    	else
    		url = "<%=Config.this_SERVER_path%>/Contents/Business/M909/S909S140111.jsp?CodeGroupGubun=" + vCodeGroupGubun;
    	
        var footer = '<button id="btn_Save" class="btn btn-info" onclick="SaveOderInfo();">저장</button>';
        var title = obj.innerText;
        var heneModal = new HenesysModal(url, 'standard', title, footer);
        heneModal.open_modal(); 	
	}
    
    //문서코드정보 등록
    function pop_fn_CodeCd_Insert(obj) {
    	let url;
    	
    	if(vCodeGroupGubun.length < 1)
    		url = "<%=Config.this_SERVER_path%>/Contents/Business/M909/S909S140101.jsp?CodeGroupGubun=" + vCodeGroupGubun;
    	else
         	url = "<%=Config.this_SERVER_path%>/Contents/Business/M909/S909S140101.jsp?CodeGroupGubun=" + vCodeGroupGubun; 
    	
        var footer = '<button id="btn_Save" class="btn btn-info" onclick="SaveOderInfo();">저장</button>';
        var title  = obj.innerText;
        var heneModal = new HenesysModal(url, 'standard', title, footer);
        heneModal.open_modal();
	}
	
  	//문서코드정보 수정
    function pop_fn_CodeCd_Update(obj) {
  		let url;
  		
    	if(vCodeValue.length < 1){
			heneSwal.warning("공통코드정보를 선택해주세요");
 			return false;
        }

    	if(vDetailCodeValue.length < 1) {
    		heneSwal.warning("공통코드가 없습니다, 코드상세정보의 공통코드를 클릭하고 처리하세요");
 			return false;
    	} else {
    		if(vCodeValue.length < 1)
    			url = "<%=Config.this_SERVER_path%>/Contents/Business/M909/S909S140102.jsp"
    					+ "?CodeValue=" + vDetailCodeValue 
    					+ "&RevisionNo=" + vDetailRevisionNo;
    		else
         		url = "<%=Config.this_SERVER_path%>/Contents/Business/M909/S909S140102.jsp"
         				+ "?CodeValue=" + vDetailCodeValue 
         				+ "&RevisionNo=" + vDetailRevisionNo;
    	}
    	
    	var footer = '<button id="btn_Save" class="btn btn-info" onclick="SaveOderInfo();">수정</button>';
        var title  = obj.innerText;
        var heneModal = new HenesysModal(url, 'standard', title, footer);
        heneModal.open_modal();
    }
	
  	//문서코드정보 삭제
    function pop_fn_CodeCd_Delete(obj) {
  		let url;
  		
    	if(vCodeValue.length < 1){
           	heneSwal.warning("공통코드정보를 선택해주세요");
 			return false;
        }

    	if(vDetailCodeValue.length < 1){
    		heneSwal.warning("공통코드가 없습니다, 코드상세정보의 공통코드를 클릭하고 처리하세요");
 			return false;
    	} else {
	    	if(vCodeValue.length < 1)
	    		url = "<%=Config.this_SERVER_path%>/Contents/Business/M909/S909S140103.jsp?CodeValue=" + vDetailCodeValue + "&RevisionNo=" + vDetailRevisionNo + "&bigo=" + vBigo;
	    	else
	    		url = "<%=Config.this_SERVER_path%>/Contents/Business/M909/S909S140103.jsp?CodeValue=" + vDetailCodeValue + "&RevisionNo=" + vDetailRevisionNo + "&bigo=" + vBigo;
    	}
    	var footer = '<button id="btn_Save" class="btn btn-info" onclick="SaveOderInfo();">삭제</button>';
     	var title  = obj.innerText;
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
      		<button type="button" onclick="pop_fn_CodeCd_group_Insert(this)" id="insert" class="btn btn-outline-warning">공통코드그룹등록</button>
      		<button type="button" onclick="pop_fn_CodeCd_Insert(this)" id="insert" class="btn btn-outline-dark">공통코드등록</button>
			<button type="button" onclick="pop_fn_CodeCd_Update(this)" id="update" class="btn btn-outline-success">공통코드수정</button>
			<button type="button" onclick="pop_fn_CodeCd_Delete(this)" id="delete" class="btn btn-outline-danger">공통코드삭제</button>
	      		<label for="total_rev_check">
		        	Rev.No 전체보기
		        </label>
		        <input type="checkbox" id="total_rev_check">
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
        <div class="card card-primary card-outline">
          <div class="card-header">
          	<h3 class="card-title">
          		<i class="fas fa-edit" id="InfoContentTitle2"></i>
          	</h3>
	      </div>
          <div class="card-body" id="DetailInfo_List_contents"></div> 
        </div>
      </div> <!--/.col-md-6-->
    </div> <!-- /.row-->
  </div> <!--  /.container-fluid-->
</div><!-- /.content-->