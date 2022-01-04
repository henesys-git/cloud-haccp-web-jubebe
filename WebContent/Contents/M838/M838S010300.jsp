<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*,java.util.*,javax.servlet.http.*"%>
<%@ page import="mes.client.comm.*" %>
<%@ page import="mes.client.common.*" %>
<%@ page import="mes.client.guiComponents.*" %>
<%@ page import="mes.client.util.*" %>
<%@ page import="mes.client.conf.*" %>
<%  
/* 
인수인계서(M838S010300.jsp)
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
	$(document).ready(function () {
		new SetDate("dateFrom", -180);
    	new SetDate("dateTo", 0);
		
		fn_MainSubMenuSelect("<%=sMenuTitle%>");
		$("#InfoContentTitle").html("인수인계서");
		
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

    function fn_clearList() {
        if ($("#MainInfo_List_contents").children().length > 0) {
            $("#MainInfo_List_contents").children().remove();
        }
        if ($("#SubInfo_List_contents").children().length > 0) {
            //$("#SubInfo_List_contents").children().remove();
        }
    }


    function fn_MainInfo_List() {
        var from = $("#dateFrom").val();
        var to = $("#dateTo").val();
        $.ajax(
        {
            type: "POST",
            url: "<%=Config.this_SERVER_path%>/Contents/Business/M838/S838S010300.jsp",
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

    //문서정보 (PopUp)
    function pop_fn_DocInfo_Insert(obj) {
    
    	var modalContentUrl = "<%=Config.this_SERVER_path%>/Contents/Business/M838/S838S010301.jsp";
    	
        pop_fn_popUpScr(modalContentUrl, obj.innerText+"(S838S010301)", '940px', '1500px');
		return false;
     }

    function fn_HACCP_View_Canvas(obj) {
    	vHandover_name = $(obj).parent().parent().find("td").eq(0).text().trim();
   		vHandover_rev  = $(obj).parent().parent().find("td").eq(1).text().trim();
   		vAcceptor      = $(obj).parent().parent().find("td").eq(9).text().trim();
   		vAcceptor_rev  = $(obj).parent().parent().find("td").eq(10).text().trim();
   		vAccept_cause  = $(obj).parent().parent().find("td").eq(7).text().trim();    	
    	
    	var modalContentUrl  = "<%=Config.this_SERVER_path%>/Contents/Business/M838/S838S010300_canvas.jsp" 
			+ "?Handover_name=" + vHandover_name 
			+ "&Handover_rev=" + vHandover_rev
			+ "&Acceptor=" + vAcceptor 
			+ "&Acceptor_rev=" + vAcceptor_rev
			+ "&Accept_cause=" + vAccept_cause;
    	pop_fn_popUpScr(modalContentUrl, "<%=sMenuTitle%>"+"(S838S010300_canvas)", '750px', '1260px');
    	return false;
    	
    }
    
    function pop_fn_DocInfo_Update(obj) {
     	if(vHandover_name.length < 1){
 			$('#alertNote').html(obj.innerText + " <BR> <%=JSPpage%>!!! <BR><BR> 문서정보를 선택하세요  !!!");
 			$('#modalalert').show();
 			return false;
 		}
    	var modalContentUrl;    	
    	modalContentUrl = "<%=Config.this_SERVER_path%>/Contents/Business/M838/S838S010302.jsp" 
			 + "?Handover_name=" + vHandover_name 
			 + "&Handover_rev=" + vHandover_rev
			 + "&Acceptor=" + vAcceptor 
			 + "&Acceptor_rev=" + vAcceptor_rev
			 + "&Accept_cause=" + vAccept_cause;   
        pop_fn_popUpScr(modalContentUrl, obj.innerText+"(S838S010302)", '940px', '1500px');
    	console.log(modalContentUrl);
		return false;
    }

    function pop_fn_DocInfo_Delete(obj) {
 		if(vHandover_name.length < 1){
			$('#alertNote').html("<%=JSPpage%>!!! <BR><BR> 문서정보를 선택하세요!!");
 			$('#modalalert').show();
 			return;
 		}
    	var modalContentUrl;
    	
    	modalContentUrl = "<%=Config.this_SERVER_path%>/Contents/Business/M838/S838S010303.jsp"    		 
			 + "?Handover_name=" + vHandover_name 
			 + "&Handover_rev=" + vHandover_rev
			 + "&Acceptor=" + vAcceptor 
			 + "&Acceptor_rev=" + vAcceptor_rev
			 + "&Accept_cause=" + vAccept_cause;   
        pop_fn_popUpScr(modalContentUrl, obj.innerText+"(S838S010303)", '940px', '1500px');
		return false;
    }

    </script>

    <div class="panel panel-default" style="margin-left:5px; margin-top:5px; margin-right:5px; margin-bottom:5px; width:100%">
        <!-- Default panel contents -->
        <div class="panel-heading" style="font-weight: bold" id="MenuTitle">여기에메뉴타이틀</div>
        <div class="panel-body">
	        	<div>
		            <button data-author="mainBtn" type="button"  id="mainButton"  class="btn btn-primary active"
		            			style="width: auto; float: left; ">여기에메뉴타이틀</button>
		            <button data-author="insert" type="button" onclick="pop_fn_DocInfo_Insert(this)" id="insert" class="btn btn-default" 
		            			style="width: auto;float: left; margin-left:30px;" >인수인계서등록</button>
		            <button data-author="update" type="button" onclick="pop_fn_DocInfo_Update(this)" id="update" class="btn btn-outline-success" 
		            			style="width: auto; float: left; margin-left:3px;">인수인계서수정</button>
		            <button data-author="delete" type="button" onclick="pop_fn_DocInfo_Delete(this)" id="delete" class="btn btn-danger" 
		            			style="width: auto; float: left; margin-left:3px;">인수인계서삭제</button>
	            </div>
	            
	            <p style="width: auto ;  clear:both; margin-left:3px;">
	            </p>
	            <div class="panel panel-default">
	            
                <!-- Default panel contents -->
                <div class="panel-body" style="width: 100%;">
                    <div style="clear:both; width: 100%;">

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
	                <div class="panel-body" >
	                
	                        <div  style="width:100%; clear:both; height:10px" >
	                </div>
	                    <div style="clear:both" id="MainInfo_List_contents" >
	                    </div>
	                    
	                   
	                    <!-- Table --> 					
	                    <div  style="clear:both; height:10px" >
	                    </div>
	                
						</div>
					</div>
				</div>
			</div>
		</div>
	</div>