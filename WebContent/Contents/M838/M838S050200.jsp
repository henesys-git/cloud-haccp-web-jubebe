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
	
	
// 	String GV_PROCESS_MODIFY	= prcStatusCheck.GV_PROCESS_MODIFY;
// 	String GV_PROCESS_DELETE	= prcStatusCheck.GV_PROCESS_DELETE;
// 	String GV_GET_NUM_PREFIX = prcStatusCheck.GV_PROCESS_NUMBER_GUBUN;
%>

 <script type="text/javascript">

 	var vWriteDate = "" ;
 
    $(document).ready(function () {
    	new SetDate("dateFrom", -180);
    	new SetDate("dateTo", 0);
        
        fn_MainSubMenuSelect("<%=sMenuTitle%>");
		$("#InfoContentTitle").html("건강진단결과");

		fn_MainInfo_List();


		//탭 클릭시 처리하는 Function
// 		//$( function() {$( "#tabs" ).tabs();});

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
                $(this).prop("disabled",false);
            });
   		}
		if(vUpdate == "0") {
	    	$('button[id="update"]').each(function () {
                $(this).prop("disabled",false);
                $(this).attr("onclick", " ");
            });
   		}
		if(vDelete == "0") {
	    	$('button[id="delete"]').each(function () {
                $(this).prop("disabled",false);

            });
   		}
    }


    function fn_clearList() {
        if ($("#MainInfo_List_contents").children().length > 0) {
            $("#MainInfo_List_contents").children().remove();
        }
        if ($("#SubInfo_List_contents").children().length > 0) {
            //$("#SubInfo_List_contents").children().remove();
        }
    }
        
    //주문기본정보
    function fn_MainInfo_List() {
        var from = $("#dateFrom").val();
        var to = $("#dateTo").val();
        $.ajax(
        {
            type: "POST",
            url: "<%=Config.this_SERVER_path%>/Contents/Business/M838/S838S050200.jsp",
            data: "From=" + from + "&To=" + to,
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
   
    function fn_HACCP_View_Canvas(obj) {
    	vHealthExmYear	= $(obj).parent().parent().find("td").eq(0).text().trim();
    	vQuat1	= $(obj).parent().parent().find("td").eq(1).text().trim();
    	vQuat2	= $(obj).parent().parent().find("td").eq(2).text().trim();
    	vQuat3	= $(obj).parent().parent().find("td").eq(3).text().trim();
    	vQuat4	= $(obj).parent().parent().find("td").eq(4).text().trim();
    	vWritorName	= $(obj).parent().parent().find("td").eq(14).text().trim();
    	//console.log(vHealthExmYear + " : "+ vWritorName);
    	
    	var modalContentUrl  = "<%=Config.this_SERVER_path%>/Contents/Business/M838/S838S050200_canvas.jsp" 
    						 + "?healthExmYear=" + vHealthExmYear 
							 + "&quat1=" + vQuat1 + "&quat2=" + vQuat2 + "&quat3=" + vQuat3 + "&quat4=" + vQuat4 
							 + "&writorName=" + vWritorName;
    	//console.log(modalContentUrl.toString());
    	
    	pop_fn_popUpScr(modalContentUrl, "<%=sMenuTitle%>"+"(S838S050200_canvas)", '750px', '1260px');
		
    	return false;
    	
    }
   

    // 건강진단관리대장 등록(S838S050201)
    function pop_fn_HealthCheck_Insert(obj) {

    	var modalContentUrl;
    	
    	modalContentUrl = "<%=Config.this_SERVER_path%>/Contents/Business/M838/S838S050201.jsp?jspPage=" + "<%=JSPpage%>";

    			
		pop_fn_popUpScr(modalContentUrl, obj.innerText+"(S838S050201)", "90%", "90%");
     }    
    // 건강진단관리대장 수정
    function pop_fn_HealthCheck_Update(obj) {    	
		if(vHealthExmYear.length < 1){
			
			$('#alertNote').html(obj.innerText + " <BR> <%=JSPpage%>!!! <BR><BR> 건강진단정보를 선택하세요  !!!");
			$('#modalalert').show();
			return false;
		}
    	var modalContentUrl = "<%=Config.this_SERVER_path%>/Contents/Business/M838/S838S050202.jsp?jspPage=" + "<%=JSPpage%>" 
    				+ "&healthExmYear=" +vHealthExmYear
        			+ "&quat1=" +vQuat1
        			+ "&quat2=" +vQuat2
        			+ "&quat3=" +vQuat3
        			+ "&quat4=" +vQuat4
        			+ "&writorName=" +vWritorId
         			;

    	
        pop_fn_popUpScr(modalContentUrl, obj.innerText+"(S838S050202)", "90%", "90%");
		return false;
    }

	// 건강진단관리대장 삭제
    function pop_fn_HealthCheck_Delete(obj) { 
		if(vHealthExmYear.length < 1){
			
			$('#alertNote').html(obj.innerText + " <BR> <%=JSPpage%>!!! <BR><BR> 건강진단정보를 선택하세요  !!!");
			$('#modalalert').show();
			return false;
		}
    	var modalContentUrl = "<%=Config.this_SERVER_path%>/Contents/Business/M838/S838S050203.jsp?jspPage=" + "<%=JSPpage%>" 
    				+ "&healthExmYear=" +vHealthExmYear
        			+ "&quat1=" +vQuat1
        			+ "&quat2=" +vQuat2
        			+ "&quat3=" +vQuat3
        			+ "&quat4=" +vQuat4
        			+ "&writorName=" +vWritorId
         			;

    	
        pop_fn_popUpScr(modalContentUrl, obj.innerText+"(S838S050203)", "90%", "90%");
		return false;
    }


 
    </script>

 
    <div class="panel panel-default" style="margin-left:5px; margin-top:5px; margin-right:5px; margin-bottom:5px; width:100%">
<!--         Default panel contents -->
        <div class="panel-heading" style="font-weight: bold" id="MenuTitle">여기에메뉴타이틀</div>
        <div class="panel-body">
            <div>
	            <button data-author="mainBtn" type="button"  id="mainButton"  class="btn btn-primary active"
	            			style="width: auto; float: left; ">zzzzzzz</button>
	            <button data-author="select" type="button" onclick="fn_HACCP_View('<%=sMenuTitle%>','<%=sProgramId%>')" id="select" class="btn btn-outline-success" 
	            			style="width: auto;float: left; margin-left:30px;" >건강진단 관리대장 (양식)</button>
	            			
				<button data-author="insert" type="button" onclick="pop_fn_HealthCheck_Insert(this)" id="insert" class="btn btn-default" 
	            			style="width: auto;float: left; margin-left:30px;">건강진단관리대장 등록</button>      			
	            <button data-author="update" type="button" onclick="pop_fn_HealthCheck_Update(this)" id="update" class="btn btn-outline-success" 
	            			style="width: auto; float: left; margin-left:3px;">건강진단관리대장 수정</button>
	            <button data-author="delete" type="button" onclick="pop_fn_HealthCheck_Delete(this)" id="delete" class="btn btn-danger" 
	            			style="width: auto; float: left;  margin-left:3px;">건강진단관리대장 삭제</button>            			
		
	            <label style="width: ;  clear:both; margin-left:3px;"></label>
            </div>
            <p style="width: auto; clear:both;">
            </p>
            <div class="panel panel-default">
<!--                 Default panel contents -->
                <div class="panel-body">
                    <div style="float:left">
                        <table style="width: 100%; text-align:left; background-color:#e0e0e0;">
                            <tr><td style='width:20%; vertical-align: middle;'>
                            		<div class="panel-heading" style="font-size:16px; font-weight: bold"  id="InfoContentTitle"></div>
                            	</td>
                            	<td style='width:5%; vertical-align: middle'>점검일자 :</td>
                                <td style='width:6%;  vertical-align: middle'>
                                    <input type="text" data-date-format="yyyy-mm-dd" id="dateFrom" class="form-control" />
                                </td>
                                <td style='width:1%;vertical-align: middle'>
                                    &nbsp;~&nbsp;
                                </td>
                                <td style='width:6%; vertical-align: middle'>
                                    <input type="text" data-date-format="yyyy-mm-dd" id="dateTo" class="form-control" />
                                </td>
                                <td style="width:62%; text-align:left">
                                    <button type="button" onclick="fn_MainInfo_List()" id="btn_Search" class="btn  btn-outline-success" style='margin-left:10px; width:100px'>조 회</button>
                                </td>
                            </tr>
                        </table>
                        <p>
                        </p>
                    </div>				
 					<div  style="clear:both; height:10px ;border-top: 1px solid #D2D6Df;" >
                    </div>
                    <div style="clear:both" id="MainInfo_List_contents" >
                    </div>
                </div>
                
<!-- 	                <div id="tabs"> -->
<!-- 			         	<ul > -->
<!-- 							<li onclick='fn_DetailInfo_List()'><a id="DetailInfo_List"  href=#SubInfo_List_contents>점검상세정보</a></li> -->
<!-- 			            </ul> -->
<!-- 	                    <div id="SubInfo_List_contents"></div> -->
<!-- 	                </div> -->
	        	
            </div>
        </div>
    </div>
