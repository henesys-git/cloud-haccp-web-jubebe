<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*,java.util.*,javax.servlet.http.*"%>
<%@ page import="mes.client.comm.*" %>
<%@ page import="mes.client.common.*" %>
<%@ page import="mes.client.guiComponents.*" %>
<%@ page import="mes.client.util.*" %>
<%@ page import="mes.client.conf.*" %>
<%  
/* 
회수관련 개선조치완료 보고서(M838S090500.jsp)
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
 
 	var vDocGubunDefault = "HACCP008";
 	var vDocNoDefault = "CS-PP-08-E";
 
 	var vDocGubun = "";  
 	var vDocNo		= "";
	var vStatus="";		//리스트 선택시 세팅
    var GV_PROCESS_MODIFY="";
    var GV_PROCESS_DELETE="";
    
	var vRegistNo = "";
	var vRevisionNo = "";
	var vDocumentNo = "";
	var vFileViewName = "";

    $(document).ready(function () {
        
        fn_MainSubMenuSelect("<%=sMenuTitle%>");
		$("#InfoContentTitle").html("회수관련 개선조치완료 보고서");

    	fn_MainInfo_List();
        
// 	    $("#select_DocGubunCode").on("change", function(){
// 	    	vDocGubun = $(this).val();
// 	        //fn_CheckBox_Chaned();
// 	    	fn_MainInfo_List();
// 	    });

	    ////$( function() {$( "#tabs" ).tabs();});M808S060100
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


    //호출 되지 않음
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
    //호출 되지 않음
	function fn_CheckBox_Chaned(){
		var tr = $($("TableS606S010100 tr")[0]);
		var td = tr.children();

// 		var trNum = $(obj).closest('tr').prevAll().length;//현재 클릭한 TR의 순서 return
		$("input[id='checkbox1']").prop("checked", false);
		$($("input[id='checkbox1']")[0]).prop("checked", true);

	     ProcSeq	= td.eq(10).text().trim();
	     procCD		= td.eq(12).text().trim();
	     bomCode	= td.eq(15).text().trim();
    }

    function fn_MainInfo_List() {
		/////////버그 방지용 ~~////////////////////////////////////////////
//     	vDocGubun = $("#select_DocGubunCode option:selected").val();//
    	vDocGubun = vDocGubunDefault;
    	//////////////////////////////////////////////////////////////
        if(vDocGubun=="ALL")
        	vDocGubun="";
        $.ajax(
        {
            type: "POST",
            url: "<%=Config.this_SERVER_path%>/Contents/Business/M838/S838S010100.jsp",
            data: "DocGubun=" + vDocGubun + "&jspPageName=" + "<%=JSPpage%>" + "&DocNo=" + vDocNoDefault ,
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
    
    	var modalContentUrl = "<%=Config.this_SERVER_path%>/Contents/Business/M606/S606S010101.jsp"
    						+ "?jspPage=" + '<%=JSPpage%>'
    						+ "&doc_gubun=" + vDocGubunDefault
    						+ "&DocNo=" + vDocNoDefault;
    	
        pop_fn_popUpScr(modalContentUrl, obj.innerText+"(S606S010101)", '500px', '600px');
		return false;
     }

    function pop_fn_DocInfo_Update(obj) {
    	
     	if(vDocNo.length < 1){
 			$('#alertNote').html(obj.innerText + " <BR> <%=JSPpage%>!!! <BR><BR> 문서정보를 선택하세요  !!!");
 			$('#modalalert').show();
 			return false;
 		}
// 		if(vStatus > GV_PROCESS_DELETE){
<%--     			$('#alertNote').html("<%=JSPpage%>!!! <BR><BR> 현재 삭제할 수 없는 상태 입니다  !!!!!"); --%>
//     			$('#modalalert').show();
//     			return;
//     	}
		
    	var modalContentUrl;
    	
    	modalContentUrl = "<%=Config.this_SERVER_path%>/Contents/Business/M606/S606S010102.jsp?RegistNo=" + vRegistNo 
    			+ "&RevisionNo=" + vRevisionNo + "&DocumentNo=" + vDocumentNo + "&FileViewName=" + vFileViewName
    			+ "&jspPage=" + '<%=JSPpage%>' + "&doc_gubun=" + vDocGubunDefault ;

        pop_fn_popUpScr(modalContentUrl, obj.innerText+"(S606S010102)", '50%', '600px');
		return false;
    }

    function pop_fn_DocInfo_Delete(obj) {
// 		if(vStatus > GV_PROCESS_DELETE){
    	<%--     			$('#alertNote').html("<%=JSPpage%>!!! <BR><BR> 현재 삭제할 수 없는 상태 입니다  !!!!!"); --%>
//    	     			$('#modalalert').show();
//    	     			return;
//				}
    	 		if(vDocNo.length < 1){
   	 			$('#alertNote').html("<%=JSPpage%>!!! <BR><BR> 문서정보를 선택하세요!!");
    	 			$('#modalalert').show();
    	 			return;
    	 		}
    	var modalContentUrl;
    	
    	modalContentUrl = "<%=Config.this_SERVER_path%>/Contents/Business/M606/S606S010103.jsp?RegistNo=" + vRegistNo 
				+ "&RevisionNo=" + vRevisionNo + "&DocumentNo=" + vDocumentNo + "&FileViewName=" + vFileViewName
				+ "&jspPage=" + '<%=JSPpage%>' + "&doc_gubun=" + vDocGubunDefault;

        pop_fn_popUpScr(modalContentUrl, obj.innerText+"(S606S010103)", '500px', '600px');
		return false;
    }

    //
    function pop_fn_DocInfo_Revision(obj) {
		if(vDocNo.length < 1){
			$('#alertNote').html(obj.innerText + " <BR> <%=JSPpage%>!!! <BR><BR> 문서정보를 선택하세요  !!!");
			$('#modalalert').show();
			return false;
		}
    	var modalContentUrl; 
    	modalContentUrl = "<%=Config.this_SERVER_path%>/Contents/Business/M606/S606S010122.jsp?RegistNo=" + vRegistNo 
				+ "&RevisionNo=" + vRevisionNo + "&DocumentNo=" + vDocumentNo + "&FileViewName=" + vFileViewName
				+ "&jspPage=" + '<%=JSPpage%>';

		pop_fn_popUpScr(modalContentUrl, obj.innerText+"(S606S010122)", '550px', '600px');
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
		            			style="width: auto;float: left; margin-left:30px;" >문서등록</button>
		            <button data-author="update" type="button" onclick="pop_fn_DocInfo_Update(this)" id="update" class="btn btn-outline-success" 
		            			style="width: auto; float: left; margin-left:3px;">문서정보수정</button>
		            <button data-author="delete" type="button" onclick="pop_fn_DocInfo_Delete(this)" id="delete" class="btn btn-danger" 
		            			style="width: auto; float: left; margin-left:3px;">문서삭제</button>
		            <button data-author="update" type="button" onclick="pop_fn_DocInfo_Revision(this)" id="update" class="btn btn-warning" 
		            			style="width: auto; float: left;  margin-left:30px;">문서개정</button>
		            <label style="width: ; float: left; margin-left:3px;"></label>
	
		            <label style="width: ;  clear:both; margin-left:3px;"></label>
	            </div>
	            
	            <p style="width: auto ;  clear:both; margin-left:3px;">
	            </p>
	            <div class="panel panel-default">
	            
                <!-- Default panel contents -->
                <div class="panel-body" style="width: 100%;">
                    <div style="clear:both; width: 100%;">

	                <table style="background-color:#e0e0e0; text-align:left; width: 100%">
	                      <tr>
	                           <td style='width:20%; vertical-align: middle;'>
	                                    <div class="panel-heading" style="font-size:16px; font-weight: bold" id="InfoContentTitle">문서기본정보</div>
	                            </td>
<!-- 	                            <td style='width:5%; vertical-align: middle'> -->
<!-- 	                                    <label style='margin-top:4px'> 문서구분 : &nbsp;</label> -->
<!-- 	                            </td> -->
<!-- 	                            <td style='width:15%; vertical-align: middle'> -->
<!-- 		                               <select class="form-control" id="select_DocGubunCode" style="width: 120px"> -->
<%-- 		                               <%	optCode =  (Vector)DocGubunVector.get(0);%> --%>
<%-- 		                               <%	optName =  (Vector)DocGubunVector.get(1);%> --%>
<%-- 		                               <%for(int i=0; i<optName.size();i++){ %> --%>
<%-- 									  <option value='<%=optCode.get(i).toString()%>'><%=optName.get(i).toString()%></option> --%>
<%-- 									<%} %> --%>
<!-- 									</select> -->
<!-- 	                            </td> -->
                             
<!-- 	                          <td style='width:60%; vertical-align: middle'> -->
<!-- 	                               &nbsp;&nbsp;&nbsp;<button type="button" onclick="fn_MainInfo_List()" id="btn_Search" class="btn btn-outline-success" style="width: 110px;" tag="select">조회</button> -->
<!-- 	                          </td> -->
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