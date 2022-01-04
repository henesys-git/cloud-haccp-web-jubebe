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
	String GV_GET_NUM_PREFIX	= prcStatusCheck.GV_PROCESS_NUMBER_GUBUN; 
%>

 	<script type="text/javascript">
 	var vProdCd		= "";
 	var vProdCdRev 	= "";
 	var vProdNm 	= "";
	
    $(document).ready(function () {        
		fn_MainSubMenuSelect("<%=sMenuTitle%>");
		$("#InfoContentTitle").html("제품목록");

    	fn_MainInfo_List();
        
	    fn_tagProcess('<%=JSPpage%>');
	    
	  //탭 클릭시 처리하는 Function
	    //$( function() {$( "#tabs" ).tabs();});	
	  
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
    	var revCheck = $("#total_rev_check").is(":checked"); 
    	
        $.ajax(
        {
            type: "POST",
            url: "<%=Config.this_SERVER_path%>/Contents/Business/M909/S909S065100.jsp",
            data: "total_rev_check=" + revCheck  ,
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
    
    //제품문서등록
    function pop_fn_ProductCd_Insert(obj) {
    	if(vProdCd.length < 1){
    		heneSwal.warning(obj.innerText +" <%=JSPpage%> !! 제품목록을 선택하세요!!");
 			return false;
   		}
    	
    	var modalContentUrl;
       	modalContentUrl = "<%=Config.this_SERVER_path%>/Contents/Business/M909/S909S065101.jsp"
       					+ "?prod_cd=" + vProdCd
       					+ "&prod_cd_rev=" + vProdCdRev
       					+ "&prod_nm=" + vProdNm
       					+ "&num_gubun=" + "<%=GV_GET_NUM_PREFIX%>"
       					+ "&jspPage=" + "<%=JSPpage%>"  ;
    	
       	var footer = "";
        var title  = obj.innerText;
     	var heneModal = new HenesysModal(modalContentUrl, 'large', title+"(S909S065101)", footer);
       	heneModal.open_modal();				
       					
     }
  
  //제품문서삭제
    function pop_fn_ProductCd_Delete(obj) {
    	if(vProdCd.length < 1){
    		heneSwal.warning(obj.innerText +" <%=JSPpage%> !! 제품목록을 선택하세요!!");
 			return false;
   		}
    	
    	var modalContentUrl;
       	modalContentUrl = "<%=Config.this_SERVER_path%>/Contents/Business/M909/S909S065103.jsp"
       					+ "?prod_cd=" + vProdCd
       					+ "&prod_cd_rev=" + vProdCdRev
       					+ "&prod_nm=" + vProdNm
       					+ "&num_gubun=" + "<%=GV_GET_NUM_PREFIX%>"
       					+ "&jspPage=" + "<%=JSPpage%>"  ;
    	
       					
       	var footer = "";
       	var title  = obj.innerText;
       	var heneModal = new HenesysModal(modalContentUrl, 'large', title+"(S909S065103)", footer);
       	heneModal.open_modal();	
		
     }
  
    function fn_DetailInfo_List() { 
    	$.ajax(
    		     {
    		         type: "POST",
    		         url: "<%=Config.this_SERVER_path%>/Contents/Business/M909/S909S065110.jsp",
    		         data: "prod_cd=" + vProdCd + "&prod_cd_rev=" + vProdCdRev ,
    		         beforeSend: function () {
//    		              //$("#SubInfo_List_contents").children().remove();
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
      </div><!-- /.col -->
      <div class="col-sm-6">
      	<div class="float-sm-right">
      		<button type="button" onclick="pop_fn_ProductCd_Insert(this)" id="insert" class="btn btn-outline-dark">문서등록</button>
			<button type="button" onclick="pop_fn_ProductCd_Delete(this)" id="delete" class="btn btn-outline-danger">제품문서삭제</button>
      		<label style="width: auto; clear:both; margin-left:30px;">
            	Rev. No 전체보기
            	<input type="checkbox" id="total_rev_check" />
        	</label>
      	</div>
      </div> <!-- /.col -->
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
          </div>
          <div class="card-body" id="MainInfo_List_contents"></div> 
        </div>
      </div> <!-- /.col-md-6 -->
    </div> <!-- /.row -->
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
	       			   제품문서목록
	       			</a>
	       		</li>
	     	</ul>
	     	<div class="tab-content" id="custom-tabs-one-tabContent">
	     		<div class="tab-pane fade" id="SubInfo_List_contents" role="tabpanel"></div>
	        </div>
        </div>
    </div>
  </div> <!-- /.container-fluid -->
</div> <!-- /.content -->