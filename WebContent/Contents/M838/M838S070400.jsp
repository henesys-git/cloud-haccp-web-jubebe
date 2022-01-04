<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*,java.util.*,javax.servlet.http.*"%>
<%@ page import="mes.client.comm.*" %>
<%@ page import="mes.client.common.*" %>
<%@ page import="mes.client.guiComponents.*" %>
<%@ page import="mes.client.util.*" %>
<%@ page import="mes.client.conf.*" %>
<%  
/* 
HACCP 연간검증대장(M838S070400.jsp)
 */
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
		
	Vector optCode =  null;
    Vector optName =  null;
	Vector DocGubunVector = CommonData.getHDocGubunCDAll(member_key);
%>

 <script type="text/javascript">
 
 	var vDocGubunDefault = "HACCP070";
 	var vDocNoDefault = "HACCP070-400";
 
 	var vDocGubun = "";  
 	var vDocNo = "";
	var vStatus = "";	// 리스트 선택시 세팅
    var GV_PROCESS_MODIFY="";
    var GV_PROCESS_DELETE="";
    
	var vRegistNo = "";
	var vRevisionNo = "";
	var vDocumentNo = "";
	var vFileViewName = "";

    $(document).ready(function () {
        
        fn_MainSubMenuSelect("<%=sMenuTitle%>");
		$("#InfoContentTitle").html("연간 검증 대장");

    	fn_MainInfo_List();
        
 	    $("#select_DocGubunCode").on("change", function(){
	    	vDocGubun = $(this).val();
	    	fn_MainInfo_List();
	    	fn_tagProcess('<%=JSPpage%>');
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
		/////////버그 방지용 ~~////////////////////////////////////////////
    	vDocGubun = vDocGubunDefault;
    	//////////////////////////////////////////////////////////////
        if(vDocGubun=="ALL") {
        	vDocGubun="";
        }

    	$.ajax({
            type: "POST",
            url: "<%=Config.this_SERVER_path%>/Contents/Business/M838/S838S070400.jsp",
            data: "DocGubun=" + vDocGubun + "&jspPageName=" + "<%=JSPpage%>" + "&DocNo=" + vDocNoDefault ,
            beforeSend: function () {
                $("#MainInfo_List_contents").children().remove();
            },
            success: function (html) {
                $("#MainInfo_List_contents").hide().html(html).fadeIn(100);
            }
        });
    }

    // 문서등록
    function pop_fn_DocInfo_Insert(obj) {
    
    	var modalContentUrl = "<%=Config.this_SERVER_path%>/Contents/Business/M606/S606S010101.jsp"
    						+ "?jspPage=" + '<%=JSPpage%>'
    						+ "&doc_gubun=" + vDocGubunDefault
    						+ "&DocNo=" + vDocNoDefault;
    	
		var footer = "<button id='btn_Save' class='btn btn-info'"
   							+ "onclick='submitForm();'>등록</button>";
		var title = obj.innerText;
		var heneModal = new HenesysModal(modalContentUrl, 'standard', title+"(S606S010101)", footer);
		heneModal.open_modal();
	}
	
    // 문서수정
    function pop_fn_DocInfo_Update(obj) {
    	
     	if(vDocNo.length < 1){
     		heneSwal.warning("수정할 문서를 선택해주세요");
 			return false;
 		}
		
    	var modalContentUrl = "<%=Config.this_SERVER_path%>/Contents/Business/M606/S606S010102.jsp?RegistNo=" + vRegistNo 
    			+ "&RevisionNo=" + vRevisionNo + "&DocumentNo=" + vDocumentNo + "&FileViewName=" + vFileViewName
    			+ "&jspPage=" + '<%=JSPpage%>' + "&doc_gubun=" + vDocGubunDefault ;

		var footer = "<button id='btn_Save' class='btn btn-info'"
	   						+ "onclick='submitForm();'>수정</button>";
		var title = obj.innerText;
		var heneModal = new HenesysModal(modalContentUrl, 'standard', title+"(S606S010102)", footer);
		heneModal.open_modal();
    }

    function pop_fn_DocInfo_Delete(obj) {
		if(vDocNo.length < 1){
  	 		heneSwal.warning("문서를 선택해주세요");
  	 		return false;
		}
    	
		var modalContentUrl = "<%=Config.this_SERVER_path%>/Contents/Business/M606/S606S010103.jsp?RegistNo=" + vRegistNo 
				+ "&RevisionNo=" + vRevisionNo + "&DocumentNo=" + vDocumentNo + "&FileViewName=" + vFileViewName
				+ "&jspPage=" + '<%=JSPpage%>' + "&doc_gubun=" + vDocGubunDefault;

		var footer = "<button id='btn_Save' class='btn btn-info'"
							+ "onclick='submitForm();'>삭제</button>";
		var title = obj.innerText;
		var heneModal = new HenesysModal(modalContentUrl, 'standard', title, footer);
		heneModal.open_modal();
    }

    <%-- function pop_fn_DocInfo_Revision(obj) {
		if(vDocNo.length < 1){
			heneSwal.warning("문서를 선택해주세요");
 			return false;
		}
    	var url = "<%=Config.this_SERVER_path%>/Contents/Business/M606/S606S010122.jsp?RegistNo=" + vRegistNo 
				+ "&RevisionNo=" + vRevisionNo + "&DocumentNo=" + vDocumentNo + "&FileViewName=" + vFileViewName
				+ "&jspPage=" + '<%=JSPpage%>';

    	var footer = "";
		var title = obj.innerText;
		var heneModal = new HenesysModal(url, 'large', title+"(S606S010122)", footer);
		heneModal.open_modal();
    } --%>
</script>

   
<!-- Content Header (Page header) -->
<div class="content-header">
  <div class="container-fluid">
    <div class="row mb-2">
      <div class="col-sm-6">
        <h1 class="m-0 text-dark" id="MenuTitle">메뉴타이틀</h1>
      </div><!-- /.col -->
      <div class="col-sm-6">
      	<div class="float-sm-right">
      		<button type = "button" onclick = "pop_fn_DocInfo_Insert(this)" id="insert" class= "btn btn-outline-dark">점검표등록</button>
			<button type = "button" onclick = "pop_fn_DocInfo_Update(this)" id="update" class= "btn btn-outline-success">점검표수정</button>
			<button type = "button" onclick = "pop_fn_DocInfo_Delete(this)" id="delete" class= "btn btn-outline-danger">점검표삭제</button>
			<!-- <button type = "button" onclick = "pop_fn_DocInfo_Revision(this)" id="update" class= "btn btn-outline-warning">문서개정</button> -->
      	</div>
      </div>
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
      </div> <!-- /.col-md-12 -->
    </div> <!-- /.row -->
  </div> <!-- /.container-fluid -->
</div> <!-- /.content -->