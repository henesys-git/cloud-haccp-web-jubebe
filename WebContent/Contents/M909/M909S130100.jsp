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
	Vector DocGubunVector = CommonData.getDocGubunCDAll(member_key);
%>

 <script type="text/javascript">
	var vDocGubun	= "";  
 	var vDocNo		= "";
 	var vRevisionNo	= "";
 	var FLAG		= false;
	
    $(document).ready(function () {        
        
		fn_MainSubMenuSelect("<%=sMenuTitle%>");
		$("#InfoContentTitle").html("문서코드정보");

    	fn_MainInfo_List();
        
	    $("#m_select_DocGubunCode").on("change", function(){
	    	vDocGubun = $(this).val();
	    });

	    fn_tagProcess('<%=JSPpage%>');
	    
	    $("#total_rev_check").change(function(){
			FLAG = !FLAG;
	    	
	    	if( FLAG ){
	    		heneSwal.warningTimer("등록 / 수정 / 삭제 기능이 제한됩니다.");
	    		
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
    	
        if(vDocGubun=="ALL") {
        	vDocGubun="";
        }
        
        $.ajax({
            type: "POST",
            url: "<%=Config.this_SERVER_path%>/Contents/Business/M909/S909S130100.jsp",
            data: "DocGubun=" + vDocGubun + "&total_rev_check=" + revCheck ,
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

    //문서코드상세정보 
    function fn_DetailInfo_List() {
        $.ajax({
            type: "POST",
            url: "<%=Config.this_SERVER_path%>/Contents/Business/M909/S909S130100.jsp",
            data: "DocGubun=" + vDocGubun + "&DocNo=" + vDocNo ,
            success: function (html) {
                $("#SubInfo_List_contents").hide().html(html).fadeIn(100);
            }
        });
    }
    
    //문서코드정보 (PopUp)
    function pop_fn_DocCode_Insert(obj) {
    	
    	var modalContentUrl;
    	
    	if(vDocNo.length < 1)
    		modalContentUrl = "<%=Config.this_SERVER_path%>/Contents/Business/M909/S909S130101.jsp?DocGubun=" + vDocGubun;
    	else
         	modalContentUrl = "<%=Config.this_SERVER_path%>/Contents/Business/M909/S909S130101.jsp?DocGubun=" + vDocGubun;
    	
        var footer = "";
        var title  = obj.innerText;
        var heneModal = new HenesysModal(modalContentUrl, 'large', title+"(S909S130101)", footer);
        heneModal.open_modal();	
     }
    
    function pop_fn_DocCode_Update(obj) {
    	if(vDocNo.length < 1){
			heneSwal.warning("문서 정보를 선택해주세요");
 			return false;
        }
    	var modalContentUrl;
    	
    	modalContentUrl = "<%=Config.this_SERVER_path%>/Contents/Business/M909/S909S130102.jsp?DocNo=" + vDocNo + "&RevisionNo=" + vRevisionNo;
    	
    	var footer = "";
     	var title  = obj.innerText;
     	var heneModal = new HenesysModal(modalContentUrl, 'large', title+"(S909S130102)", footer);
     	heneModal.open_modal();
    	
    }

    function pop_fn_DocCode_Delete(obj) {
    	if(vDocNo.length < 1){
           	heneSwal.warning("문서 정보를 선택해주세요");
 			return false;
        }
    	
    	var url = "<%=Config.this_SERVER_path%>/Contents/Business/M909/S909S130103.jsp?DocNo=" + vDocNo + "&RevisionNo=" + vRevisionNo;
    	
    	var footer = "";
     	var title  = obj.innerText;
     	var heneModal = new HenesysModal(url, 'large', title+"(S909S130103)", footer);
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
      		<button type = "button" onclick = "pop_fn_DocCode_Insert(this)" id="insert" class= "btn btn-outline-dark">문서코드등록</button>
			<button type = "button" onclick = "pop_fn_DocCode_Update(this)" id="update" class= "btn btn-outline-success">문서코드수정</button>
			<button type = "button" onclick = "pop_fn_DocCode_Delete(this)" id="delete" class= "btn btn-outline-danger">문서코드삭제</button>
      		<label>
	            	Rev. No 전체보기
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
          	<div class="card-title">
          		<div class="fas fa-edit" id="InfoContentTitle">문서코드 정보</div>
          	</div>
          	<div class="card-tools">
          	  <div class="input-group input-group-sm" id="dateParent">
          	  	<label for="m_select_DocGubunCode">문서 구분 :</label>
          	  	&nbsp;&nbsp;
                <select class="form-control float-right" id="m_select_DocGubunCode">
	                <%	optCode =  (Vector)DocGubunVector.get(0);%>
	                <%	optName =  (Vector)DocGubunVector.get(1);%>
	                <%for(int i=0; i<optName.size();i++){ %>
				  	<option value='<%=optCode.get(i).toString()%>'><%=optName.get(i).toString()%></option>
					<%} %>
				</select>
          	  	<div class="input-group-append">
          	  		<button type="button" onclick="fn_MainInfo_List()" id="btn_Search" class="btn btn-outline-dark">
	          	  	    <i class="fas fa-search"></i>
					</button>
          	  	</div>
          	  </div>
          	</div>
	      </div>
          <div class="card-body" id="MainInfo_List_contents"></div> 
        </div>
      </div> <!--/.col-md-6-->
    </div> <!-- /.row-->
  </div> <!--  /.container-fluid-->
</div><!-- /.content-->