<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*,java.util.*,javax.servlet.http.*"%>
<%@ page import="mes.client.conf.*" %>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>CCP 모니터링</title>
	<link rel="shotcut icon" type="image/x-icon" href="${ctx }/henesys.jpg"/>
	<!-- <jsp:include page="/Contents/Common/linkcss_js.jsp" flush="false"/> -->
</head>
<%
	String loginID = session.getAttribute("login_id").toString();
	String member_key = session.getAttribute("member_key").toString();
	if(loginID==null||loginID.equals("")){                            // id가 Null 이거나 없을 경우
		response.sendRedirect("Contents/index.jsp");    // 로그인 페이지로 리다이렉트 한다.
	}	
	
	String sMenuTitle = request.getParameter("sMenuTitle").toString();
	String sProgramId = request.getParameter("sprogramId").toString();
	String sHeadmenuID= request.getParameter("sHeadmenuID").toString();
	String sHeadmenuName= request.getParameter("sHeadmenuName").toString();
	String parm= request.getParameter("sparm").toString();
%>
<body>

	<script type="text/javascript">

    $(document).ready(function () {


        $.ajax(
        {
            type: "POST",
			async: false,
// 	        enctype: "multipart/form-data",
            url: "<%=Config.this_SERVER_path%>/Contents/Business/<%=sHeadmenuID%>/<%=sProgramId%>",
            data: "<%=parm%>" + "&sprogramId=<%=sProgramId%>" ,
            beforeSend: function () {
                $("#popMainInfo_List_contents").children().remove();
            },
            success: function (html) {
                $("#popMainInfo_List_contents").hide().html(html).fadeIn(100);
            },
            error: function (xhr, option, error) {
            }
        });
    });
    
    
    function pop_fn_popUpScr(url,title, height, width) {

    	var posX = $('#modalReport').offset().left - $(document).scrollLeft() - width + $('#modalReport').outerWidth();
    	var posY = $('#modalReport').offset().top - $(document).scrollTop() + $('#modalReport').outerHeight();
//     	   $("#dialog").dialog({width:width, height:height ,position:[posX, posY]});

        $("#modalReport_Title").text(title);
        $("#modalReport").find(".modal-body").css("top", $('#modalReport').scrollTop());
//                 $("#modalReport").find(".modal-body").css("top", posY);
//                 $("#modalReport").find(".modal-body").css("left", posX);
		$("#modalReport").find(".modal-body").css("height", height);
		$("#modalReport").find(".modal-dialog").css("width", width);
//  		$("#modalReport").attr("closeOnEscape", "false");
 		
		$.ajax({
	    	type: "POST",
	    	url:  url , 
	 	 	beforeSend: function () { 
	            $("#ReportNote").children().remove();
	   		},
	   	  	success: function (html) {
		   	  	$('#ReportNote').hide().html(html).fadeIn(100);
				$('#modalReport').show(); 
				$('#btn_Canc').on("click",function(){
					$('#modalReport').hide();
					
				});
	   	   	},
	   	 	error: function (xhr, option, error) {
	   	  	}
		});
		return false;
     }
    
    
	</script>


    <div id="popMainInfo_List_contents"  style="clear:both;" >
    </div>
	<div class="modal collapse " role="dialog"  id="modalReport" style="width: 100%;height:90% closeOnEscape:false; margin: 0 auto text-align:center">
		<div class="modal-dialog"  style="top:3px; width: 100%; margin: 0 auto text-align:center">
			<div class="modal-content panel panel-default" >
				<div class="modal-header panel-heading">
					<a type="button" class="close" data-dismiss="modal" onclick="$('#modalReport').hide()">
					<span aria-hidden="true">&times;</span><span class="sr-only">Close</span></a>
					<strong><span class="modal-title" id="modalReport_Title" ></span></strong>
				</div>
				<div class="modal-body panel-body" style="height:90%">
					<div id="ReportNote" class="modal-body panel-body" >
					</div>
				</div>
			</div>
		</div>
	</div>	
</body>
</html>