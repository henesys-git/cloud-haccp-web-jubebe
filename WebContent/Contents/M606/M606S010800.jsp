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
	
	Vector optCode =  null;
    Vector optName =  null;
	Vector DocGubunVector = CommonData.getDocGubunCDAll(member_key);
// 	Vector midGubun = CommonData.getMidClassCdDataAll("GPR02");
%>

 <script type="text/javascript">
 	var vDocGubun = "";  
 	var vDocNo		= "";
    var GV_PROCESS_MODIFY="";
    var GV_PROCESS_DELETE="";

	
    $(document).ready(function () {
    	
        fn_MainSubMenuSelect("<%=sMenuTitle%>");
// 		$("#InfoContentTitle").html("문서정보");

    	fn_MainInfo_List();
        
	    $("#select_DocGubunCode").on("change", function(){
	    	vDocGubun = $(this).val();

	    });

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
        if ($("#sub_SubInfo_List_contents").children().length > 0) {
            $("#sub_SubInfo_List_contents").children().remove();
        }
    }
    
    //문서기본정보
    function fn_MainInfo_List() {
	
        if(vDocGubun=="ALL")
        	vDocGubun="";
        $.ajax(
        {
            type: "POST",
            url: "<%=Config.this_SERVER_path%>/Contents/Business/M606/S606S010800.jsp",
            data: "DocGubun=" + vDocGubun + "&jspPageName=" + "<%=jspPageName.GetJSP_FileName()%>" ,
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

    //문서상세정보 
    function fn_DetailInfo_List() {
        $.ajax(
        {
            type: "POST",
            url: "<%=Config.this_SERVER_path%>/Contents/Business/M606/S606S010110.jsp",
            data: "DocGubun=" + vDocGubun + "&DocNo=" + vDocNo ,
            beforeSend: function () {
                //$("#SubInfo_List_contents").children().remove();
            },
            success: function (html) {
                $("#SubInfo_List_contents").hide().html(html).fadeIn(100);
            },
            error: function (xhr, option, error) {

            }
        });
    }
  
    
    </script>

    <div class="panel panel-default" style="margin-left:5px; margin-top:5px; margin-right:5px; margin-bottom:5px; width:100%">
        <!-- Default panel contents -->
        <div class="panel-heading" style="font-weight: bold" id="MenuTitle">여기에메뉴타이틀</div>
        <div class="panel-body">
        		<div>
		            <button data-author="mainBtn" type="button"  id="mainButton"  class="btn btn-primary active"
		            			style="width: auto; float: left; ">문서관리-문서관리</button>
	<!-- 	            <button data-author="insert" type="button" onclick="pop_fn_DocInfo_Insert(this)" id="insert" class="btn btn-default"  -->
	<!-- 	            			style="width: auto;float: left; margin-left:30px;" >문서등록</button> -->
	<!-- 	            <button data-author="update" type="button" onclick="pop_fn_DocInfo_Update(this)" id="update" class="btn btn-outline-success"  -->
	<!-- 	            			style="width: auto; float: left; margin-left:3px;">문서수정</button> -->
	<!-- 	            <button data-author="delete" type="button" onclick="pop_fn_DocInfo_Delete(this)" id="delete" class="btn btn-danger"  -->
	<!-- 	            			style="width: auto; float: left; margin-left:3px;">문서삭제</button> -->
		            <label style="width: ; float: left; margin-left:3px;"></label>
	
		            <label style="width: ;  clear:both; margin-left:3px;"></label>
	            </div>
            
            <p style="width: auto ;  clear:both; margin-left:3px;">
            </p>
            <div class="panel panel-default">
            <table style="width: 100%; text-align:left; background-color:#e0e0e0;">
                            <tr>
                            	<td style='width:20%; vertical-align: middle;'>
	                                    <div class="panel-heading" style="font-size:16px; font-weight: bold" id="InfoContentTitle">문서기본정보</div>
                               </td>
                                <td style='width:5%; vertical-align: middle'>
                                    <label style='margin-top:4px'> 문서구분 : &nbsp;</label>
                                </td>
                                <td style='width:15%; vertical-align: middle'>
	                                <select class="form-control" id="select_DocGubunCode" style="width: 120px">
	                                <%	optCode =  (Vector)DocGubunVector.get(0);%>
	                                <%	optName =  (Vector)DocGubunVector.get(1);%>
	                                <%for(int i=0; i<optName.size();i++){ %>
									  <option value='<%=optCode.get(i).toString()%>'><%=optName.get(i).toString()%></option>
									<%} %>
									</select>
                                </td>
                                
                                
                                <td style='width:60%; vertical-align: middle'>
                                    &nbsp;&nbsp;&nbsp;<button type="button" onclick="fn_MainInfo_List()" id="btn_Search" class="btn btn-outline-success" style="width: 110px;" tag="select">조회</button>
                                </td>
                            </tr>
                        </table>
                <div class="panel-body">
                        
                        <div  style="width:100%; clear:both; height:10px" />
                       
                       <div style="clear:both" id="MainInfo_List_contents" >
                    	</div>
                    	
                    <!-- Table --> 					
                    <div  style="clear:both; height:10px" >
                    </div>
                    
            	</div>
            	
        </div>
    </div>
</div>