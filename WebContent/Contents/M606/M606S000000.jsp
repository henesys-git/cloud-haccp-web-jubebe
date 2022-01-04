<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*,java.util.*,javax.servlet.http.*"%>
<%@ page import="mes.client.comm.*" %>
<%@ page import="mes.client.common.*" %>
<%@ page import="mes.client.guiComponents.*" %>
<%@ page import="mes.client.util.*" %>
<%@ page import="mes.client.conf.*" %>
<%@ page import="org.json.simple.*"%><%@ include file="/strings.jsp" %>
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
	
	// 로그인한 사용자의 정보
	JSONObject jArrayUser = new JSONObject();
	jArrayUser.put( "USER_ID", loginID);
	jArrayUser.put( "member_key", member_key);
	DoyosaeTableModel TableModelUser = new DoyosaeTableModel("M909S080100E107", jArrayUser);
	int RowCountUser =TableModelUser.getRowCount();
	String loginIDrev = "",loginIDdept = "",loginIDgroupCd="";
	if(RowCountUser > 0) {
		loginIDrev = TableModelUser.getValueAt(0, 1).toString().trim();
		loginIDgroupCd = TableModelUser.getValueAt(0, 6).toString().trim();
		loginIDdept = TableModelUser.getValueAt(0, 10).toString().trim();
	} else {
		loginIDrev = "0";
	}
	
	makeMenu MainMenu = new makeMenu(member_key, loginID, sHeadmenuID, loginIDgroupCd);
	String htmlsideMenu = MainMenu.GetsideMenu(sHeadmenuID,sHeadmenuName);
%>
    <script type="text/javascript">    	
       var MenuTitle;
        $(document).ready(function () {

        	makeMenuHTML("<%=htmlsideMenu%>");
        	
			fn_SubMain("<%=Config.this_SERVER_path%>/Contents/<%=sHeadmenuID%>/<%=MainMenu.meModel.getValueAt(0,0).toString()%>.jsp", "<%=sHeadmenuID%>",
					"<%=MainMenu.meModel.getValueAt(0,1).toString()%>","<%=MainMenu.meModel.getValueAt(0,9).toString()%>","<%=MainMenu.meModel.getValueAt(0,1).toString()%>");
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

    </script>
	        <!--사이드 메뉴 -->
	    	<div style="width: 1%;"></div>
	        <table style="width: 98%; margin: 0 auto; text-align:left">
	            <tr>
	                <td style="width: 10%; vertical-align: top; text-align:left">
	                    <div class="list-group" id="SubMenuDiv" style="margin-right: 2px; margin-top: 5px; width: 100%;">
	                    사이드메뉴
	                    </div>
	                    <div id="Div1">
	                    </div>
	                </td>
	                <td style="width: 90%;  vertical-align: top ; text-align:left" >
	                    <!--Main Contents begins HERE!!! -->
	                    <div id="ContentPlaceHolder1">                   
	                    </div>                    
	                    <div id="ContentPlaceHolder2">                   
	                    </div>
	                </td>
	            </tr>
	        </table>
	    	<div  style="width: 1%;"></div>
	         