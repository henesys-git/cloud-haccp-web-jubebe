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

    var vBomCode	= "";
    var vRevisionNo	= "";
    var FLAG		= false;
    
    $(document).ready(function () {
        fn_MainSubMenuSelect("<%=sMenuTitle%>");
		$("#InfoContentTitle").html("BOM코드정보");

    	fn_MainInfo_List();
	    
	    //탭 클릭시 처리하는 Function
	    //$( function() {$( "#tabs" ).tabs();});
	    
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
    
    

    function fn_LoadSubPage() {
        fn_clearList();
        fn_MainInfo_List();
    }

    function fn_clearList() { 
        if ($("#Main_contents").children().length > 0) {
            $("#Main_contents").children().remove();
        }
    }
    

    function fn_MainInfo_List() {
    	var revCheck = $("#total_rev_check").is(":checked"); 
    	
        $.ajax(
        {
            type: "POST",
            url: "<%=Config.this_SERVER_path%>/Contents/Business/M909/S909S010100.jsp",
            data: "total_rev_check=" + revCheck  ,
            beforeSend: function () {
                $("#Main_contents").children().remove();
            },
            success: function (html) {
//                 $("#Main_contents").hide().html(html).fadeIn(100);
                $("#Main_contents").hide().html(html).fadeIn(50);
            },
            error: function (xhr, option, error) {
			
            }
        });
        
    }

    function pop_fn_BomCode_Insert(obj) {
    	var modalContentUrl;
    	
    	modalContentUrl = "<%=Config.this_SERVER_path%>/Contents/Business/M909/S909S010101.jsp";
    	pop_fn_popUpScr(modalContentUrl, obj.innerText+"(S909S010101)", "630px", "680px");
     }
    
    function pop_fn_BomCode_Update(obj) {
    	if(vBomCode.length < 1){
//     	if(folder_menu_id==undefined){
        	alert("BOM 정보를 선택하세요")
        	return false;
        }
    	var modalContentUrl;
    	
    	modalContentUrl = "<%=Config.this_SERVER_path%>/Contents/Business/M909/S909S010102.jsp?BomCode=" + vBomCode + "&RevisionNo=" + vRevisionNo;
		pop_fn_popUpScr(modalContentUrl, obj.innerText+"(S909S010102)", "630px", "680px");
     }
    
    function pop_fn_BomCode_Delete(obj) {
    	if(vBomCode.length < 1){
// 		if(folder_menu_id==undefined){
    		alert("BOM 정보를 선택하세요")
    		return false;
    	}
    	var modalContentUrl;
    	
    	modalContentUrl = "<%=Config.this_SERVER_path%>/Contents/Business/M909/S909S010103.jsp?BomCode=" + vBomCode + "&RevisionNo=" + vRevisionNo;
		pop_fn_popUpScr(modalContentUrl, obj.innerText+"(S909S010103)", "630px", "680px");
     }

    </script>
    
    

    <div class="panel panel-default" style="margin-left:5px; margin-top:5px; margin-right:5px; margin-bottom:5px; width:100%" >
        Default panel contents
        <div class="panel-heading" style="font-weight: bold" id="MenuTitle">여기에메뉴타이틀</div>
        <div class="panel-body" >
        
        	<div>
	            <button data-author="insert" type="button"  id="mainButton "  class="btn btn-primary active"
	            			style="width: auto; float: left; ">기준관리-BOM코드관리</button>
	            <button data-author="insert" type="button" onclick="pop_fn_BomCode_Insert(this)" id="insert" class="btn btn-warning" 
	            			style="width: auto;float: left; margin-left:30px;" >BOM코드등록</button>
	            <button data-author="update" type="button" onclick="pop_fn_BomCode_Update(this)" id="update" class="btn btn-outline-success" 
	            			style="width: auto; float: left; margin-left:3px;">BOM코드수정</button>
	            <button data-author="delete" type="button" onclick="pop_fn_BomCode_Delete(this)" id="delete" class="btn btn-danger" 
	            			style="width: auto; clear:both; margin-left:3px;">BOM코드삭제</button>
	            <label style="width: auto; clear:both; margin-left:30px;">
	            	Rev. No 전체보기
	            	<input type="checkbox" id="total_rev_check"  />
	            </label>
            </div>
            <p>
            </p>

            <div class="panel panel-default">
                Default panel contents
                <div class="panel-heading" style="font-size:16px; font-weight: bold"  id="InfoContentTitle"></div>
                <div class="panel-body">
                    <div id="Main_contents"  style="clear:both; " >
                    </div>
                </div>

				<div style="height:10px"></div>
				
                <div class="tab-content">

            	</div>
        	</div>
		</div>
    </div>