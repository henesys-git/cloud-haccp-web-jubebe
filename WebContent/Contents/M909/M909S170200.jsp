<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*,java.util.*,javax.servlet.http.*"%>
<%@ page import="mes.client.comm.*" %>
<%@ page import="mes.client.guiComponents.*" %>
<%@ page import="mes.client.util.*" %>
<%@ page import="mes.client.conf.*" %>
<%  	
	String loginID = session.getAttribute("login_id").toString();
	String member_key = session.getAttribute("member_key").toString();
	if(loginID==null||loginID.equals("")){                            // id가 Null 이거나 없을 경우
		response.sendRedirect(Config.this_SERVER_path + "/Contents/index.jsp");    // 로그인 페이지로 리다이렉트 한다.
	}
// 	makeMenu MainMenu = new makeMenu(loginID);

	String sMenuTitle = request.getParameter("MenuTitle").toString();
	String sProgramId = request.getParameter("programId").toString();
	String sHeadmenuID= request.getParameter("HeadmenuID").toString();
	String sHeadmenuName= request.getParameter("HeadmenuName").toString();
// 	String htmlsideMenu = MainMenu.GetsideMenu(sHeadmenuID,sHeadmenuName);
	
	Get_Program_button_Autho prg_autho = new Get_Program_button_Autho(loginID,sProgramId);
	
	CurrentPage jspPageName = new CurrentPage(request.getRequestURI());
	String JSPpage = jspPageName.GetJSP_FileName();
	ProcesStatusCheck prcStatusCheck = new ProcesStatusCheck(JSPpage+"|"+"NON"+"|");
	
	
	String GV_PROCESS_MODIFY	= prcStatusCheck.GV_PROCESS_MODIFY;
	String GV_PROCESS_DELETE	= prcStatusCheck.GV_PROCESS_DELETE;
	String GV_GET_NUM_PREFIX = prcStatusCheck.GV_PROCESS_NUMBER_GUBUN;

%>

 <script type="text/javascript">
	var vSeolbiCd="";
	var vSeqNo="";
	var vRevisionNo="";

    $(document).ready(function () {
    	<%--         makeMenu("<%=htmlsideMenu%>"); --%>
        fn_MainSubMenuSelect("<%=sMenuTitle%>");
		$("#InfoContentTitle").html("센서코드목록");

    	fn_MainInfo_List();
	    fn_tagProcess('<%=JSPpage%>');
	    
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
        if ($("#Main_contents").children().length > 0) {
            $("#Main_contents").children().remove();
        }
        if ($("#Main_contents2").children().length > 0) {
            $("#Main_contents2").children().remove();
        }
    }
        
    //센서코드정보
    function fn_MainInfo_List() {
        $.ajax(
        {
            type: "POST",
            url: "<%=Config.this_SERVER_path%>/Contents/Business/M909/S909S170200.jsp",
	        data: "SeolbiCd=" + vSeolbiCd ,
            beforeSend: function () {
                $("#Main_contents").children().remove();
            },
            success: function (html) {
                $("#Main_contents").hide().html(html).fadeIn(100);
            },
            error: function (xhr, option, error) {

            }
        });
    }

	function fn_DetailInfo_List() {
    	$.ajax(
    	    {
    	        type: "POST",
    	        url: "<%=Config.this_SERVER_path%>/Contents/Business/M909/S909S170210.jsp",
    	        data: "SeolbiCd=" + vSeolbiCd +"&RevisionNo=" + vRevisionNo ,
    	        beforeSend: function () {
//     	            $("#ProcessInfo_bom").children().remove();
    	        },
    	        success: function (html) {
    	            $("#Main_contents2").hide().html(html).fadeIn(100);
    	        },
    	        error: function (xhr, option, error) {
    	        }
    	    });
		return;
	}   


    function pop_fn_SeolbiInfo_Insert(obj) {
    	if(vSeolbiCd.length < 1){
			$('#alertNote').html(obj.innerText + " <BR> <%=JSPpage%>!!! <BR><BR> 센서코드 정보를 선택하세요  !!!");
			$('#modalalert').show();
			return false;
		}
    	var modalContentUrl;
    	modalContentUrl = "<%=Config.this_SERVER_path%>/Contents/Business/M909/S909S170201.jsp?SeolbiCd=" + vSeolbiCd + "&RevisionNo=" + vRevisionNo;
    	
		modalFramePopup.setTitle(obj.innerText);
		pop_fn_popUpScr(modalContentUrl, obj.innerText+"(S909S170201)", "550px", "800px");
     }

    function pop_fn_SeolbiInfo_Update(obj) {
    	if(vSeolbiCd.length < 1){
			$('#alertNote').html(obj.innerText + " <BR> <%=JSPpage%>!!! <BR><BR> 센서코드 정보를 선택하세요  !!!");
			$('#modalalert').show();
			return false;
		}
    	if(vSeqNo.length < 1){
			$('#alertNote').html(obj.innerText + " <BR> <%=JSPpage%>!!! <BR><BR> 센서코드   정보를 선택하세요  !!!");
			$('#modalalert').show();
			return false;
		}
    	var modalContentUrl;
    	//alert("aaa-program_id=" + program_id);
    	modalContentUrl = "<%=Config.this_SERVER_path%>/Contents/Business/M909/S909S170202.jsp?SeolbiCd=" + vSeolbiCd + "&SeqNo=" + vSeqNo + "&RevisionNo=" + vRevisionNo;
    	
		modalFramePopup.setTitle(obj.innerText);
		pop_fn_popUpScr(modalContentUrl, obj.innerText+"(S909S170202)", "550px", "800px");
// 		var rtnVal = fn_CommonPopupModal(modalContentUrl, null, 450, 600); modal-md 
		return false;
    }

    function pop_fn_SeolbiInfo_Delete(obj) {
    	if(vSeolbiCd.length < 1){
			$('#alertNote').html(obj.innerText + " <BR> <%=JSPpage%>!!! <BR><BR> 센서코드   정보를 선택하세요 !!!");
			$('#modalalert').show();
			return false;
		}
    	if(vSeqNo.length < 1){
			$('#alertNote').html(obj.innerText + " <BR> <%=JSPpage%>!!! <BR><BR> 센서코드   정보를 선택하세요  !!!");
			$('#modalalert').show();
			return false;
		}
    	var modalContentUrl;
    	
    	modalContentUrl = "<%=Config.this_SERVER_path%>/Contents/Business/M909/S909S170203.jsp?SeolbiCd=" + vSeolbiCd + "&SeqNo=" + vSeqNo + "&RevisionNo=" + vRevisionNo;
    	
		modalFramePopup.setTitle(obj.innerText);
		pop_fn_popUpScr(modalContentUrl, obj.innerText+"(S909S170203)", "550px", "800px");
		return false;
    }

    </script>

    <div class="panel panel-default" style="margin-left:5px; margin-top:5px; margin-right:5px; margin-bottom:5px; width:100%">
        <!-- Default panel contents -->
        <div class="panel-heading" style="font-weight: bold" id="MenuTitle">여기에센서코드타이틀</div>
        <div class="panel-body">
            <div>
            
	            <button data-author="mainBtn" type="button"  id="mainButton"  class="btn btn-primary active"
	            			style="width: auto; float: left; ">기준정보-센서코드관리</button>
	            			
	            <button data-author="insert" type="button" onclick="pop_fn_SeolbiInfo_Insert(this)" id="insert" class="btn btn-default" 
	            			style="width: auto; float: left; margin-left:20px;">센서코드 등록</button>
	            <button data-author="update" type="button" onclick="pop_fn_SeolbiInfo_Update(this)" id="update" class="btn btn-outline-success" 
	            			style="width: auto; float: left; margin-left:3px;">센서코드 수정</button>
	            <button data-author="delete" type="button" onclick="pop_fn_SeolbiInfo_Delete(this)" id="delete" class="btn btn-danger" 
	            			style="width: auto; clear:both;  margin-left:3px;">센서코드 삭제</button>
	            <!-- 
	            <button data-author="delete" type="button" onclick="RunFile()" id="delete" class="btn btn-danger" 
	            			style="width: auto; clear:both;  margin-left:3px;">프로그램실행</button> 
	            -->
            </div>
            <p style="width: auto; clear:both;">
            </p>
            <div class="panel panel-default">
                <!-- Default panel contents -->
                <div class="panel-heading" style="font-size:16px; font-weight: bold" id="InfoContentTitle">센서코드목록</div>
                <div class="panel-body">
                    <div style="clear:both" id="Main_contents" >
                    </div>
                </div>
                
                <div class="panel-heading" style="font-size:16px; font-weight: bold " id="JumunInfoContentTitle2">센서코드관리이력</div>
                <div class="panel-body">
                    <div id="Main_contents2">
                    </div>
            	</div>
            </div>
        </div>
    </div>
