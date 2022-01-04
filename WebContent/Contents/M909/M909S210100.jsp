<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*,java.util.*,javax.servlet.http.*"%>
<%@ page import="mes.client.comm.*" %>
<%@ page import="mes.client.guiComponents.*" %>
<%@ page import="mes.client.util.*" %>
<%@ page import="mes.client.conf.*" %>
<!-- 
선반정보관리 (M909S210100)
yumsam
-->

<%  
	String loginID = session.getAttribute("login_id").toString();
	String member_key = session.getAttribute("member_key").toString();
	if(loginID==null||loginID.equals("")){                            				// id가 Null 이거나 없을 경우
		response.sendRedirect(Config.this_SERVER_path + "/Contents/index.jsp");    	// 로그인 페이지로 리다이렉트 한다."NON"
	}

	String sMenuTitle = request.getParameter("MenuTitle").toString();
	String sProgramId = request.getParameter("programId").toString();
	String sHeadmenuID= request.getParameter("HeadmenuID").toString();
	String sHeadmenuName= request.getParameter("HeadmenuName").toString();
	
	Get_Program_button_Autho prg_autho = new Get_Program_button_Autho(loginID, sProgramId);	
	
	CurrentPage jspPageName = new CurrentPage(request.getRequestURI());
	String JSPpage = jspPageName.GetJSP_FileName();
	ProcesStatusCheck prcStatusCheck = new ProcesStatusCheck(JSPpage+"|"+"ODPROCS"+"|");

	String GV_PROCESS_MODIFY	= prcStatusCheck.GV_PROCESS_MODIFY;
	String GV_PROCESS_DELETE	= prcStatusCheck.GV_PROCESS_DELETE;
	String GV_PROCESS_NAME		= prcStatusCheck.GV_PROCESS_NAME;
	String GV_GET_NUM_PREFIX	= prcStatusCheck.GV_PROCESS_NUMBER_GUBUN;
%>

<script>
	
   	var shelf_type = "";
   	var prod_cd = "";
   	var prod_rev_no = "";
   	var mainTable;
   	var subTable;
   	
    $(document).ready(function () {
    	
		fn_MainInfo_List();
	
		$("#InfoContentTitle").html("선반 종류");
 		fn_MainSubMenuSelect("<%=sMenuTitle%>");
		fn_tagProcess();
		
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
    }
    
    function fn_MainInfo_List() {
        $.ajax({
            type: "POST",
            url: "<%=Config.this_SERVER_path%>/Contents/Business/M909/S909S210100.jsp",
            success: function (html) {
                $("#MainInfo_List_contents").hide().html(html).fadeIn(100);
            }
        });
        
        $("#SubInfo_List_contents").children().remove();
    }

    
    //선반별 제품 정보 
    function fn_DetailInfo_List() {
        $.ajax({
            type: "POST",
            url: "<%=Config.this_SERVER_path%>/Contents/Business/M909/S909S210110.jsp",
            data: "shelf_type=" + shelf_type,
            success: function (html) {
                $("#SubInfo_List_contents").hide().html(html).fadeIn(100);
            }
        });
    }
    
    // 선반 정보 등록
    function insertShelf(obj) {
    	
		var url = "<%=Config.this_SERVER_path%>/Contents/Business/M909/S909S210101.jsp";
		var footer = '<button class="btn btn-info" onclick="save();">저장</button>';
		var title = obj.innerText;
		var heneModal = new HenesysModal(url, 'standard', title, footer);
		heneModal.open_modal();
    }
    
    
 	// 선반 정보 수정
    function updateShelf(obj) {
    	
		var url = "<%=Config.this_SERVER_path%>/Contents/Business/M909/S909S210102.jsp"
					+ "?shelf_type=" + shelf_type;
		var footer = '<button id="btn_Save" class="btn btn-info" onclick="update();">수정</button>';
		var title = obj.innerText;
		var heneModal = new HenesysModal(url, 'standard', title, footer);
		heneModal.open_modal();
    }
	
 	
 	// 선반 정보 삭제
    function deleteShelf(obj) {
		
		var url = "<%=Config.this_SERVER_path%>/Contents/Business/M909/S909S210103.jsp"
					+ "?shelf_type=" + shelf_type;
		var footer = '<button id="btn_Save" class="btn btn-info" onclick="deleteInfo();">삭제</button>';
		var title = obj.innerText;
		var heneModal = new HenesysModal(url, 'standard', title, footer);
		heneModal.open_modal();
    }
 	
 	// 선반별 제품 정보 등록
    function insertProduct(obj) {
 		
    	if ( !mainTable.rows( '.selected' ).any() ) {
 			heneSwal.warning('선반 종류를 먼저 선택해주세요');
 			return false;
 		}
    	
		var url = "<%=Config.this_SERVER_path%>/Contents/Business/M909/S909S210111.jsp"
					+ "?shelf_type=" + shelf_type;
		var footer = '<button id="btn_Save" class="btn btn-info" onclick="insertInfo();">저장</button>';
		var title = obj.innerText;
		var heneModal = new HenesysModal(url, 'standard', title, footer);
		heneModal.open_modal();
    }
    
 	// 선반별 제품 정보 수정
    function updateProduct(obj) {
    	if ( !subTable.rows( '.selected' ).any() ) {
 			heneSwal.warning('제품을 선택해주세요');
 			return false;
 		}
    	
		var url = "<%=Config.this_SERVER_path%>/Contents/Business/M909/S909S210112.jsp"
					+ "?shelf_type=" + shelf_type
					+ "&prod_cd=" + prod_cd
					+ "&prod_rev_no=" + prod_rev_no;
		var footer = '<button id="btn_Save" class="btn btn-info" onclick="updateInfo();">수정</button>';
		var title = obj.innerText;
		var heneModal = new HenesysModal(url, 'standard', title, footer);
		heneModal.open_modal();
    }
	
 	
 	// 선반별 제품 정보 삭제
    function deleteProduct(obj) {
    	if ( !subTable.rows( '.selected' ).any() ) {
 			heneSwal.warning('제품을 선택해주세요');
 			return false;
 		}
 		
		var url = "<%=Config.this_SERVER_path%>/Contents/Business/M909/S909S210113.jsp"
					+ "?shelf_type=" + shelf_type
					+ "&prod_cd=" + prod_cd
					+ "&prod_rev_no=" + prod_rev_no;
		var footer = '<button id="btn_Save" class="btn btn-info" onclick="deleteInfo();">삭제</button>';
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
	        	<h1 class="m-0 text-dark" id="MenuTitle">타이틀</h1>
	      	</div>
	      	<div class="col-sm-6">
		      	<div class="float-sm-right">
		      	  	<button type="button" onclick="insertShelf(this)" id="insert" class="btn btn-outline-dark">선반 등록</button>
		      	 	<button type="button" onclick="updateShelf(this)" id="update" class="btn btn-outline-success">선반 수정</button>
		      	  	<button type="button" onclick="deleteShelf(this)" id="delete" class="btn btn-outline-danger">선반 삭제</button>
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
	          	  			<div class="input-group input-group-sm" id="dateParent">
	          	  				<input type="text" class="form-control float-right" id="dateRange">
		          	  			<div class="input-group-append">
		          	  	  			<button type="submit" class="btn btn-default">
		          	  	    			<i class="fas fa-search"></i>
		          	  	  			</button>
		          	  			</div>
	          	  			</div>
          				</div>
					</div>
          			<div class="card-body" id="MainInfo_List_contents">
          			</div> 
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
    		<div class="card-tools">
				<button type="button" onclick="insertProduct(this)" id="insertDoc" class="btn btn-outline-dark">제품 등록</button>          	  
				<button type="button" onclick="updateProduct(this)" id="submitDoc" class="btn btn-outline-success">제품 수정</button>          	  
				<button type="button" onclick="deleteProduct(this)" id="submitDoc" class="btn btn-outline-danger">제품 삭제</button>          	  
          	</div>
    	</div>
    	<div class="card-body">
    		<ul class="nav nav-tabs" id="custom-tabs-one-tab" role="tablist">
	       		<li class="nav-item" onclick='fn_DetailInfo_List()'>
	       			<a class="nav-link" id="DetailInfo_List" data-toggle="pill" href="#SubInfo_List_contents" role="tab">선반별 제품 정보</a>
	       		</li>
	        </ul>
	     	<div class="tab-content" id="custom-tabs-one-tabContent">
	     		<div class="tab-pane fade" id="SubInfo_List_contents" role="tabpanel"></div>
	     	</div>
	    </div>
	</div>
  </div><!-- /.container-fluid -->
</div>
<!-- /.content -->
