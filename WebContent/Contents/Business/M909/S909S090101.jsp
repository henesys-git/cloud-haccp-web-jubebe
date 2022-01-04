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
	if(loginID==null||loginID.equals("")){                            			// id가 Null 이거나 없을 경우
		response.sendRedirect(Config.this_SERVER_path + "/Contents/index.jsp"); // 로그인 페이지로 리다이렉트 한다.
	}
	
	// 로그인한 아이디의 그룹 코드를 가져오는 벡터
	Vector UserGroupVectorID = CommonData.getUserGroupDataID(loginID,member_key);
	Vector optCodeIDVector = (Vector)UserGroupVectorID.get(0); 
	String optCodeID = optCodeIDVector.get(0).toString();
	
	String GV_USER_ID = "";
	String GV_GROUP_CD = "";
	
	if(request.getParameter("user_id") != null)
		GV_USER_ID = request.getParameter("user_id");
	
	if(request.getParameter("group_cd") != null)
		GV_GROUP_CD = request.getParameter("group_cd");
%>

<script>
	 
	$(document).ready(function() {
		
		setTimeout(function() {
			fn_LoadSubPage101();
		}, 200);	
	
	});
    
	function fn_LoadSubPage101() {
        fn_clearList101();
        fn_MyInfo_List();
        fn_AllInfo_List();
    }
	
	function fn_clearList101() {
        if ($("#User_Contents").children().length > 0) {
            $("#User_Contents").children().remove();
        }
        if ($("#All_Contents").children().length > 0) {
            $("#All_Contents").children().remove();
        }
    }
	
    //메뉴정보
    function fn_MyInfo_List() {
        $.ajax({
            type: "POST",
            url: "<%=Config.this_SERVER_path%>/Contents/Business/M909/S909S090120.jsp",
	        data: "user_id=<%=GV_USER_ID%>" + "&group_cd=<%=GV_GROUP_CD%>" ,
            beforeSend: function () {
                $("#User_Contents").children().remove();
            },
            success: function (html) {
                $("#User_Contents").hide().html(html).fadeIn(100);
                check_all("#User_Contents");
            }
        });
    }

	function fn_AllInfo_List() { 
    	$.ajax({
   	        type: "POST",
   	        url: "<%=Config.this_SERVER_path%>/Contents/Business/M909/S909S090130.jsp",
			data: "user_id=<%=GV_USER_ID%>" + "&group_cd=<%=GV_GROUP_CD%>",
   	        beforeSend: function () {
    	            $("#All_Contents").children().remove();
   	        },
   	        success: function (html) {
   	            $("#All_Contents").hide().html(html).fadeIn(100);
   	            check_all("#All_Contents");
   	        }
    	});
		
    	return;
	}   
	
	function check_all(contents_id){
		$(contents_id+" "+"input[id='checkboxAll']").on("click", function() {
			$(contents_id+" "+"#checkbox1").prop("checked",this.checked);
	    });   
	}

	var SOCKET_COMM_DATA = {
			PID: "",  
			totalcnt: 0,
			retnValue: 999,
			colcnt: 0,
			colname: ["","","",""], //insert, Update, Delete 문장을 처리할 때는 사용되지않음
			data: []
	};  
	
	var SQL_Param = {
			PID: "",
			excute: "queryProcess",
			stream: "N",
			param: + "|"
	};
	
	var GV_RECV_DATA = "";	//웹소켓 onMessage(event)들어온 데이터를 받는 변수
	
	// 추가
	function fn_insert() {
		 if ("<%=optCodeIDVector.get(0).toString()%>" != "GRCD001") {
    		heneSwal.warning("관리자만 등록 가능합니다.");
    		return false;
    	} else if ("<%=GV_USER_ID%>" == "admin") {
    		heneSwal.warning("관리자의 권한은 변경이 불가능 합니다.");
    		return false;
    	}
		
		var myTr;
		var myTd;
		var chkCount = 0;
		var checkBoxArray = $("#All_Contents input[id='checkbox1']:checked");
		
		var jArray = new Array();
		
		checkBoxArray.each(function(i) {
			myTr = checkBoxArray.parent().parent().eq(i);
			myTd = myTr.children();
			chkCount++;
			
			var dataJson = new Object();
			dataJson.group_cd = "<%=GV_GROUP_CD%>";
			dataJson.user_id = "<%=GV_USER_ID%>";
			dataJson.menu_id = myTd.eq(1).text();
			dataJson.delyn = " ";
			dataJson.autho_menu = myTd.eq(7).text();
			dataJson.autho_insert = myTd.eq(3).text();
			dataJson.autho_update = myTd.eq(4).text();
			dataJson.autho_delete = myTd.eq(5).text();
			dataJson.autho_select = myTd.eq(6).text();
			dataJson.member_key = "<%=member_key%>";

			jArray.push(dataJson);
		});
	
		SOCKET_COMM_DATA.PID = "M909S090100E111";
		SQL_Param.PID = "M909S090100E111";
		
		var dataJsonMulti = new Object();
 		dataJsonMulti.param = jArray;

		var JSONparam = JSON.stringify(dataJsonMulti);
		SaveProgramInfo(JSONparam, SQL_Param.PID);
	}
	
	// 수정
	function fn_update(obj) {
		var checkBoxArray = $("#User_Contents input[id='checkbox1']:checked");
		
		if(checkBoxArray.length < 1) {
			heneSwal.warning("사용 프로그램 목록에서 수정할 프로그램을 선택하세요");
    		return false;
    	} else if(checkBoxArray.length > 1) {
    		heneSwal.warning("수정할 프로그램을 1개만 선택하세요"+"\n"+"현재 선택 개수 : "+checkBoxArray.length+"개");
    		return false;
    	} else if ("<%=optCodeIDVector.get(0).toString()%>" != "GRCD001") {
    		heneSwal.warning("관리자만 수정 가능합니다.");
    		return false;
    	} else if ("<%=GV_USER_ID%>" == "admin") {
    		heneSwal.warning("관리자의 권한은 변경이 불가능 합니다.");
    		return false;
    	}
		
		var myTr = checkBoxArray.parent().parent();
		var myTd = myTr.children();
		var params = "group_cd=" + "<%=GV_GROUP_CD%>"
					+ "&user_id=" + "<%=GV_USER_ID%>"
					+ "&menu_id=" + myTd.eq(1).text().trim()
					+ "&menu_nm=" + myTd.eq(2).text().trim()
					+ "&autho_insert=" + myTd.eq(3).text().trim()
					+ "&autho_update=" + myTd.eq(4).text().trim()
					+ "&autho_delete=" + myTd.eq(5).text().trim()
					+ "&autho_select=" + myTd.eq(6).text().trim()
					+ "&autho_menu=" + myTd.eq(7).text().trim()
					+ "&member_key=" + "<%=member_key%>";
    	var modalContentUrl = "<%=Config.this_SERVER_path%>/Contents/Business/M909/S909S090102.jsp?"+params;
        pop_fn_popUpScr_nd(modalContentUrl, "사용프로그램 수정(S909S090102)", "420px", "500px");
		return false;
	}

	// 제거
	function fn_delete() {
		if ("<%=optCodeIDVector.get(0).toString()%>" != "GRCD001") {
			heneSwal.warning("관리자만 삭제 가능합니다.");
    		return false;
		} else if ("<%=GV_USER_ID%>" == "admin") {
	    	heneSwal.warning("관리자의 권한은 변경이 불가능 합니다.");
    		return false;
    	}
		
		var myTr;
		var myTd;
		var chkCount = 0;
		var checkBoxArray = $("#User_Contents input[id='checkbox1']:checked");
		
		var jArray = new Array();
		
		checkBoxArray.each(function(i) {
			myTr = checkBoxArray.parent().parent().eq(i);
			myTd = myTr.children();
			chkCount++;
			
			var dataJson = new Object();
			dataJson.group_cd = "<%=GV_GROUP_CD%>";
			dataJson.user_id = "<%=GV_USER_ID%>";
			dataJson.menu_id = myTd.eq(1).text();
			dataJson.member_key = "<%=member_key%>";

			jArray.push(dataJson);
		});
		
		SOCKET_COMM_DATA.PID = "M909S090100E113";
		SQL_Param.PID = "M909S090100E113";
		
		var dataJsonMulti = new Object();
 		dataJsonMulti.param = jArray;

		var JSONparam = JSON.stringify(dataJsonMulti);
		SaveProgramInfo(JSONparam, SQL_Param.PID);
	}
	
	// 프로그램 권한 OK
	function Permissions_Ok(obj) {
		if ("<%=optCodeIDVector.get(0).toString()%>" != "GRCD001"){
			heneSwal.warning("관리자만 변경 가능합니다.");
    		return false;
		} else if ("<%=GV_USER_ID%>" == "admin"){
	   		heneSwal.warning("관리자의 권한은 변경이 불가능 합니다.");
	    	return false;
	    }
			
		var myTr;
		var myTd;
		var chkCount = 0;
		var checkBoxArray = $("#User_Contents input[id='checkbox1']:checked");
		
		var jArray = new Array();
		
		checkBoxArray.each(function(i) {
			myTr = checkBoxArray.parent().parent().eq(i);
			myTd = myTr.children();
			chkCount++;
			
			var dataJson = new Object();
			
			dataJson.autho_menu = 1;
			dataJson.autho_insert = 1;
			dataJson.autho_update = 1;
			dataJson.autho_delete = 1;
			dataJson.autho_select = 1;
			dataJson.group_cd = "<%=GV_GROUP_CD%>";
			dataJson.user_id = "<%=GV_USER_ID%>";
			dataJson.menu_id = myTd.eq(1).text();
			dataJson.member_key = "<%=member_key%>";

			jArray.push(dataJson);
		});
		
		SOCKET_COMM_DATA.PID = "M909S090100E122";
		SQL_Param.PID = "M909S090100E122";
		
		var dataJsonMulti = new Object();
 		dataJsonMulti.param = jArray;

		var JSONparam = JSON.stringify(dataJsonMulti);
		SaveProgramInfo(JSONparam, SQL_Param.PID);
	}
	
	// 프로그램 권한 NO
	function Permissions_No(obj) {
		if ("<%=optCodeIDVector.get(0).toString()%>" != "GRCD001"){
    		heneSwal.warning("관리자만 변경 가능합니다.");
    		return false;
		} else if ("<%=GV_USER_ID%>" == "admin"){
	    	heneSwal.warning("관리자의 권한은 변경이 불가능 합니다.");
    		return false;
    	}
		
		var myTr;
		var myTd;
		var chkCount = 0;
		var checkBoxArray = $("#User_Contents input[id='checkbox1']:checked");
		
		var jArray = new Array();
		
		checkBoxArray.each(function(i) {
			myTr = checkBoxArray.parent().parent().eq(i);
			myTd = myTr.children();
			chkCount++;
			
			var dataJson = new Object();
			
			dataJson.autho_menu = 0;
			dataJson.autho_insert = 0;
			dataJson.autho_update = 0;
			dataJson.autho_delete = 0;
			dataJson.autho_select = 0;
			dataJson.group_cd = "<%=GV_GROUP_CD%>";
			dataJson.user_id = "<%=GV_USER_ID%>";
			dataJson.menu_id = myTd.eq(1).text();
			dataJson.member_key = "<%=member_key%>";

			jArray.push(dataJson);
		});
		
		SOCKET_COMM_DATA.PID = "M909S090100E132";
		SQL_Param.PID = "M909S090100E132";
		
		var dataJsonMulti = new Object();
 		dataJsonMulti.param = jArray;

		var JSONparam = JSON.stringify(dataJsonMulti);
		SaveProgramInfo(JSONparam, SQL_Param.PID);
	}
	
	function SetRecvData(){
		DataPars(SOCKET_COMM_DATA, GV_RECV_DATA);
 		if(SOCKET_COMM_DATA.retnValue > 0) {
 			if (SOCKET_COMM_DATA.PID == "M909S090100E111") {
 				heneSwal.success('추가 되었습니다');
 			} else if (SOCKET_COMM_DATA.PID == "M909S090100E112") {
 				heneSwal.success('수정 되었습니다');
 			} else if (SOCKET_COMM_DATA.PID == "M909S090100E122") {
 				heneSwal.success('수정 되었습니다');
 			} else if (SOCKET_COMM_DATA.PID == "M909S090100E132") {
 				heneSwal.success('수정 되었습니다');
 			} else {
 				heneSwal.success('제거 되었습니다');
 			}
 		} else {
 			if (SOCKET_COMM_DATA.PID == "M909S090100E111") {
 				heneSwal.warning('추가 되지 않았습니다.');
 			} else if (SOCKET_COMM_DATA.PID == "M909S090100E112") {
 				heneSwal.warning('수정 되지 않았습니다.');
 			} else if (SOCKET_COMM_DATA.PID == "M909S090100E122") {
 				heneSwal.warning('수정 되지 않았습니다.');
 			} else if (SOCKET_COMM_DATA.PID == "M909S090100E132") {
 				heneSwal.warning('수정 되지 않았습니다.');
 			} else {
 				heneSwal.warning('제거 되지 않았습니다.');
 			}
 		}
   		
   		fn_MyInfo_List();
	}
	
	function SaveProgramInfo(paramData) {
		SQL_Param.param = paramData ;
		SendTojsp(paramData,SQL_Param.PID);
	}
 
	function SendTojsp(bomdata, pid){
	    $.ajax({
	         type: "POST",
	         dataType: "json", // Ajax로 json타입으로 보낸다.
	         url: "<%=Config.this_SERVER_path%>/Contents/CommonView/insert_update_delete_json.jsp", 
	         data:  "bomdata=" + bomdata + "&pid=" + pid,
	         success: function (html) {
	        	 if(html>-1){
					fn_MyInfo_List();
					fn_AllInfo_List();
	         	}
	         }
	     });		
	}
	

    </script>

    <div class="panel panel-default" style="margin-left:5px; margin-top:5px; margin-right:5px; margin-bottom:5px; width:100%">
        <div class="panel-body">
            <div class="panel panel-default">
                
                <table border="0" width="100%">
                	<tr>
                		<td>
			                <div class="panel-heading" style="font-size:16px; font-weight: bold" id="InfoContentTitle">사용프로그램 목록</div>
			                <div class="panel-body">
			                    <div style="clear:both" id="User_Contents" >
			                    </div>
			                </div>
                		</td>
                	</tr>
                	<tr align="center">	
                		<td>
                			<div style="float:down">
							<table>
								<tr align="center">
									<td style="padding-top: 10; padding-bottom: 10;">
										<button data-author="insert" type="button" onclick="fn_insert(this)" id="insert" class="btn btn-outline-success" 
										style="width: auto; float: left; margin-left: 3px;"> △ 추가 </button>
									</td>
									<td style="padding-top: 10; padding-bottom: 10;">
										<button data-author="update" type="button" onclick="fn_update(this)" id="update" class="btn btn-warning"
											style="width: auto; clear: both; margin-left: 3px;">
											⦁수정⦁</button>
									</td>
									<td style="padding-top: 10; padding-bottom: 10;">
										<button data-author="delete" type="button" onclick="fn_delete(this)" id="delete" class="btn btn-danger"
											style="width: auto; clear: both; margin-left: 3px;">
											제거▽</button>
									</td>
									<td style="padding-top: 10; padding-bottom: 10;">
										<button data-author="update" type="button" onclick="Permissions_Ok(this)" id="update" class="btn btn-info"
											style="width: auto; clear: both; margin-left: 3px;">
											프로그램 권한</button>
									</td>
									<td style="padding-top: 10; padding-bottom: 10;">
										<button data-author="update" type="button" onclick="Permissions_No(this)" id="update" class="btn btn-info"
											style="width: auto; clear: both; margin-left: 3px;">
											프로그램 권한 제거</button>
									</td>
								</tr>
							</table>
                			</div>
                		</td>
                	</tr>
                	<tr>	
                		<td>
                			<div class="panel-heading" style="font-size:16px; font-weight: bold " id="JumunInfoContentTitle2">전체프로그램 목록</div>
                			<div class="panel-body">
                    			<div id="All_Contents">
                    			</div>
            				</div>
            			</td>
            		</tr>
            	</table>
            </div>
        </div>
    </div>
