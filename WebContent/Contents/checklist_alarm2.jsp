<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*,java.util.*,javax.servlet.http.*"%>
<%@ page import="mes.client.comm.*" %>
<%@ page import="mes.client.guiComponents.*" %>
<%@ page import="mes.client.util.*" %>
<%@ page import="mes.client.conf.*" %>
<%
%>
<style>
	#cover_web_alarm {
		display:flex;
		align-content: space-between;
    	justify-content: space-evenly;
    	margin-top: 44px;
	}
	
	#cover_web_alarm table {
		font-size: 13px; 
		font-weight: bold;
		box-shadow: rgb(0 0 0 / 41%) 0px 3px 6px 0px;
		width:18vw;
		background:white;
	}
	
    #cover_web_alarm tbody {
      overflow-y: scroll;
      height: 400px;
      display: grid;
      background:white;
    }
    
    #cover_web_alarm button {
    	height: 24px; 
    	display: flex; 
    	justify-content: center; 
    	align-items: center; 
    	font-size: 12px; 
    	font-weight: bold;
    }
    
    #cover_web_alarm th {
    	display: flex; 
    	align-items: center; 
    	justify-content: space-between;
    }
    
    #cover_web_alarm td {
		width:100%;
		border-top:none;
    }
    
    #cover_web_alarm .menu_name_in {
	    padding-left: 5px;
	}
	
</style>
<script type="text/javascript">
	
	$(document).ready(function(){
		//alramInteval();
		
		/* $("#document_edit").click(function(){
			alarmEdit();
		})
		
		$("#sulbi_edit").click(function(){
			alarmEdit();
		}) */
		
		 async function getData() {
			
			 var today = new Date();   
			 var year = today.getFullYear(); // 년도
			 var month = today.getMonth() + 1;  // 월
			 var date = today.getDate();  // 날짜
			 var hours = today.getHours(); // 시
			 var count = 0;
			 today = new Date(year+"-"+month+"-"+date+" 09:00:00")
			
			
	        var fetchedList = $.ajax({
			            type: "GET",
			            url: "<%=Config.this_SERVER_path%>/checklist_alarm",
			            success: function (data) {
			            	
			            	console.log(data);
			            	console.log(data[0].latestCheckDate);
			            	console.log(data[0].checklistId);
			            	console.log(data[0].checklistName);
			            	console.log(data[0].checkInterVal);
			            	console.log(data[0].revisionNo);
			                 
			                data.forEach(function(item){
			                	console.log(item);
			                	console.log(item.revisionNo);
								var className = "";
								var goOnOff_2 = false;
								var goOnOff_1 = false;
								var goOnOff_0 = false;
								var goOnOff_minus = false;
								var insertDaysText = "";
								
								if(item[4] == "매년"){
									month = item[5];
									date = item[6];
									
									insertDaysText = " (매년 "+month+"월 "+date+"일)";
									
									if(Number(month) < 10) month = "0"+month;
									if(Number(date) < 10) date = "0"+date;
									var parsingDate = new Date(year+"-"+month+"-"+date);
									
									if(today > parsingDate) {
										goOnOff_minus = true;
									}else if(((parsingDate - today)/1000/60/60/24) == 0) {
										 goOnOff_0 = true;
									}else if(((parsingDate - today)/1000/60/60/24) == 1) {
										goOnOff_1 = true;
									}else if(((parsingDate - today)/1000/60/60/24) == 2) {
										 goOnOff_2 = true;
									}else if(((parsingDate - today)/1000/60/60/24) >= 3){
										
									}
								}else if(item[4] == "매월"){
									date = item[5];
									
									insertDaysText = " (매월 "+date+"일)";
									
									if(Number(date) < 10) date = "0"+date;
									var parsingDate = new Date(year+"-"+month+"-"+date);
									
									if(today > parsingDate) {
										goOnOff_minus = true;
									}else if(((parsingDate - today)/1000/60/60/24) < 0) {
										 goOnOff_0 = true;
									}else if(((parsingDate - today)/1000/60/60/24) < 1) {
										goOnOff_1 = true;
									}else if(((parsingDate - today)/1000/60/60/24) < 2) {1
										 goOnOff_2 = true;
									}else if(((parsingDate - today)/1000/60/60/24) > 1){
										
									}
								}else if(item[4] == "매일"){ // 날짜가 지났거나, 그날 당일에 알람
									date = item[5];		
								
									insertDaysText = " (매일 "+date+"시)";
								
									if(date - new Date().getHours() < 0) {
										goOnOff_minus = true;
									}else if(date - new Date().getHours() == 0) {
										 goOnOff_0 = true;
									}else if(date - new Date().getHours() == 1) {
										goOnOff_1 = true;
									}else if(date - new Date().getHours() == 2) {
										 goOnOff_2 = true;
									}else if(date - new Date().getHours() > 2){
										
									}
								}
								
								if(goOnOff_minus){
									className = 'fa-user text-red';
								}else if(goOnOff_0){
									className = 'fa-user text-yellow';
								}else if(goOnOff_1){
									className = 'fa-user text-green';
								}else if(goOnOff_2){
									className = 'fa-user text-green';
								}else {
									goOnOff_minus = false;
									goOnOff_0 = false;
									goOnOff_1 = false;
									goOnOff_2 = false;
								}
								
								//if(goOnOff_minus || goOnOff_0 || goOnOff_1 || goOnOff_2){
									clickUrl = "<%=Config.this_SERVER_path%>/Contents/"
											 + item[2] + "/" + item[3]
									item1 = item[1];
									item2 = item[2];
									item3 = item[3];
									
									var insertFunction = "";
									
									var sulClcikUrl = "<%=Config.this_SERVER_path%>/Contents/M909/M909S050100.jsp"
									console.log(item.revisionNo == '0');
									console.log(count == 0);
									if(item.revisionNo == '0') {
										insertFunction = "'"+clickUrl+"', '"+item2+"', '"+item1+"', '"+item3+"')\"";
			                
										if(count == 0){
											$("#document tbody").append(
													'<tr><td><a onclick="fn_MainSubMenuSelectedAlarm(this, '+insertFunction+'><i class="fa '+className+'"></i><span class="menu_name_in">'+item.checklistName+'</span>'+insertDaysText+'</a></td></tr></li>'
											)
										}else{
											$("#document tbody").append(
													'<tr><td><li><a onclick="fn_MainSubMenuSelectedAlarm(this, '+insertFunction+'><i class="fa '+className+'"></i><span class="menu_name_in">'+item[1]+'</span>'+insertDaysText+'</span></a></td></tr>'
											)
										}
									}
									
									if(item[9] == "sign") {
										insertFunction = "'"+sulClcikUrl+"', 'M909', '설비정보', 'M909S050100.jsp')\"";
											
										if(count == 0){
											$("#document_sign tbody").append(
													'<tr><td><a onclick="fn_MainSubMenuSelectedAlarm(this, '+insertFunction+'><i class="fa '+className+'"></i><span class="menu_name_in">'+item[1]+'</span>'+insertDaysText+'</a></td></tr>'
											)
										}else{
											$("#document_sign tbody").append(
													'<tr><td><a onclick="fn_MainSubMenuSelectedAlarm(this, '+insertFunction+'><i class="fa '+className+'"></i><span class="menu_name_in">'+item[1]+'</span>'+insertDaysText+'</span></a></td></tr>'
											)
										}
									}
								//}
			                });
											
			                if($("#document tbody tr").get().length == 0) $("#document tbody").append('<tr style="display: flex; align-items: center; justify-content: center;text-align: center;"><td>알람없음</td></tr>')
			                if($("#document_sign tbody tr").get().length == 0) $("#document_sign tbody").append('<tr style="display: flex; align-items: center; justify-content: center;text-align: center;"><td>알람없음</td></tr>') 
										
			            },
			            error: function (xhr, option, error) {

			            }
			        });
	    
	    	return fetchedList;
	    };
	    
	    getData();
	})
	
// 	alarmProcess1 = setInterval(show_now, 1000*60*5); // 주석시 웹 알람관련 로그 안보임 - 개발서버에서 주석 해제 금지
// 	alarmProcess2 = setInterval(alarm_now, 1000*60*5); // 주석시 웹 알람관련 로그 안보임 - 개발서버에서 주석 해제 금지
// 	alarmProcess2 = setInterval(bring_total_count, 1000*60*5); // 주석시 웹 알람관련 로그 안보임 - 개발서버에서 주석 해제 금지
	
	function fn_MainSubMenuSelectedAlarm(obj, url, HeadmenuID, HeadmenuName, programId, SubmenuName) {
		var $mstr = $(obj);
		var $mObj = $(obj);
		var mMenuTitle = "" + $mstr.text().trim();
		ProgramID = "" + programId;
		
        fn_SubMain(url, HeadmenuID, HeadmenuName, programId, mMenuTitle, SubmenuName);
        
        updateAlarm($(obj).children().eq(1).text())
        return true;
    }
	
	function updateAlarm(target) { // 알람 클릭시 해당 정보 삭제        
   		var dataJson = new Object(); 															
   		dataJson.menu_nm = target;
		var JSONparam = JSON.stringify(dataJson);	
		SendTojsp2(JSONparam, "M909S190100E402");
	}
 	
    
    function bring_total_count(){
    	if($("#web_alarm .dropdown-menu li").get().length > 0) $(".alarm_num").css("display","block");
    }
    
	function alarmEdit(){
		is_show_now = true;
		
		$(".nav-link").off()
		$(".nav-link").click(function(){
			if($(this).hasClass("menu-open2")){
				$(this).next().slideUp(300);
				$(this).removeClass("menu-open2");
				$(this).closest(".nav-treeview").slideDown(300);
			}else{
				$(this).parent().children().eq(1).slideDown(300);
				$(this).addClass("menu-open2");
				$(this).closest(".nav-treeview").slideDown(300);
			}
		})			
		
		var modalContentUrl;
    	modalContentUrl = "<%=Config.this_SERVER_path%>/Contents/Business/M909/S909S190100.jsp"
    	
    	var footer = "";
		var title = "알림설정";
		var heneModal = new HenesysModal(modalContentUrl, 'xlarge', title+"(S909S190100)", footer);
		heneModal.open_modal();
		
//        	pop_fn_popUpScr_nd(modalContentUrl, "알림설정", '750px', '800px');
//    		return false;
	}
	
	function alarm_now(){
		if(!is_show_now){
			//alramInteval();
		}
	}
	
	function show_now(){
		if($(".dropdown-menu").css("display") == "block") is_show_now = true;
		if($(".dropdown-menu").css("display") == "none") is_show_now = false;
		
	}
	<%-- 
	function alramInteval(){
		var today = new Date();   
		var year = today.getFullYear(); // 년도
		var month = today.getMonth() + 1;  // 월
		var date = today.getDate();  // 날짜
		var hours = today.getHours(); // 시
		var count = 0;
		today = new Date(year+"-"+month+"-"+date+" 09:00:00")
		
		 $.ajax({
		            type: "POST",
		            url: "<%=Config.this_SERVER_path%>/Contents/checklist_alarm3.jsp?sql_code=M909S190100E984", 
		            success: function (data) {
		                var TableModelAlarm = JSON.parse(data);
		                
		                console.log(TableModelAlarm)
		                
		                TableModelAlarm.forEach(function(item){
							var className = "";
							var goOnOff_2 = false;
							var goOnOff_1 = false;
							var goOnOff_0 = false;
							var goOnOff_minus = false;
							var insertDaysText = "";
							
							if(item[4] == "매년"){
								month = item[5];
								date = item[6];
								
								insertDaysText = " (매년 "+month+"월 "+date+"일)";
								
								if(Number(month) < 10) month = "0"+month;
								if(Number(date) < 10) date = "0"+date;
								var parsingDate = new Date(year+"-"+month+"-"+date);
								
								if(today > parsingDate) {
									goOnOff_minus = true;
								}else if(((parsingDate - today)/1000/60/60/24) == 0) {
									 goOnOff_0 = true;
								}else if(((parsingDate - today)/1000/60/60/24) == 1) {
									goOnOff_1 = true;
								}else if(((parsingDate - today)/1000/60/60/24) == 2) {
									 goOnOff_2 = true;
								}else if(((parsingDate - today)/1000/60/60/24) >= 3){
									
								}
							}else if(item[4] == "매월"){
								date = item[5];
								
								insertDaysText = " (매월 "+date+"일)";
								
								if(Number(date) < 10) date = "0"+date;
								var parsingDate = new Date(year+"-"+month+"-"+date);
								
								if(today > parsingDate) {
									goOnOff_minus = true;
								}else if(((parsingDate - today)/1000/60/60/24) < 0) {
									 goOnOff_0 = true;
								}else if(((parsingDate - today)/1000/60/60/24) < 1) {
									goOnOff_1 = true;
								}else if(((parsingDate - today)/1000/60/60/24) < 2) {1
									 goOnOff_2 = true;
								}else if(((parsingDate - today)/1000/60/60/24) > 1){
									
								}
							}else if(item[4] == "매일"){ // 날짜가 지났거나, 그날 당일에 알람
								date = item[5];		
							
								insertDaysText = " (매일 "+date+"시)";
							
								if(date - new Date().getHours() < 0) {
									goOnOff_minus = true;
								}else if(date - new Date().getHours() == 0) {
									 goOnOff_0 = true;
								}else if(date - new Date().getHours() == 1) {
									goOnOff_1 = true;
								}else if(date - new Date().getHours() == 2) {
									 goOnOff_2 = true;
								}else if(date - new Date().getHours() > 2){
									
								}
							}
							
							if(goOnOff_minus){
								className = 'fa-user text-red';
							}else if(goOnOff_0){
								className = 'fa-user text-yellow';
							}else if(goOnOff_1){
								className = 'fa-user text-green';
							}else if(goOnOff_2){
								className = 'fa-user text-green';
							}else {
								goOnOff_minus = false;
								goOnOff_0 = false;
								goOnOff_1 = false;
								goOnOff_2 = false;
							}
							
							if(goOnOff_minus || goOnOff_0 || goOnOff_1 || goOnOff_2){
								clickUrl = "<%=Config.this_SERVER_path%>/Contents/"
										 + item[2] + "/" + item[3]
								item1 = item[1];
								item2 = item[2];
								item3 = item[3];
								
								var insertFunction = "";
								
								var sulClcikUrl = "<%=Config.this_SERVER_path%>/Contents/M909/M909S050100.jsp"
								
								if(item[9] == "menu") {
									insertFunction = "'"+clickUrl+"', '"+item2+"', '"+item1+"', '"+item3+"')\"";
		                
									if(count == 0){
										$("#document tbody").append(
												'<tr><td><a onclick="fn_MainSubMenuSelectedAlarm(this, '+insertFunction+'><i class="fa '+className+'"></i><span class="menu_name_in">'+item[1]+'</span>'+insertDaysText+'</a></td></tr></li>'
										)
									}else{
										$("#document tbody").append(
												'<tr><td><li><a onclick="fn_MainSubMenuSelectedAlarm(this, '+insertFunction+'><i class="fa '+className+'"></i><span class="menu_name_in">'+item[1]+'</span>'+insertDaysText+'</span></a></td></tr>'
										)
									}
								}
								
								if(item[9] == "sulbi") {
									insertFunction = "'"+sulClcikUrl+"', 'M909', '설비정보', 'M909S050100.jsp')\"";
										
									if(count == 0){
										$("#sulbi tbody").append(
												'<tr><td><a onclick="fn_MainSubMenuSelectedAlarm(this, '+insertFunction+'><i class="fa '+className+'"></i><span class="menu_name_in">'+item[1]+'</span>'+insertDaysText+'</a></td></tr>'
										)
									}else{
										$("#sulbi tbody").append(
												'<tr><td><a onclick="fn_MainSubMenuSelectedAlarm(this, '+insertFunction+'><i class="fa '+className+'"></i><span class="menu_name_in">'+item[1]+'</span>'+insertDaysText+'</span></a></td></tr>'
										)
									}
								}
							}
		                });
										
		                if($("#document tbody tr").get().length == 0) $("#document tbody").append('<tr style="display: flex; align-items: center; justify-content: center;text-align: center;"><td>알람없음</td></tr>')
		                if($("#sulbi tbody tr").get().length == 0) $("#sulbi tbody").append('<tr style="display: flex; align-items: center; justify-content: center;text-align: center;"><td>알람없음</td></tr>')
									
		            },
		            error: function (xhr, option, error) {

		            }
			    });
	}
	 --%>
	var hours_chk = true;
	var month_chk = true;
	var year_chk = true;
	
	function alramInteval2(){
		var today = new Date();   
		var year = today.getFullYear(); // 년도
		var month = today.getMonth() + 1;  // 월
		var date = today.getDate();  // 날짜
		var hours = today.getHours(); // 시
		
		var dataJson = new Object(); 															
		var JSONparam = JSON.stringify(dataJson);
		
		if(Number(hours) == 0) {
			if(hours_chk == true){
				// 0시에 업데이트 쿼리
				dataJson.alarm_cycle = "매일";
	    		SendTojsp3(JSONparam, "M909S190100E502");
				hours_chk = false;
			}
		}else{
			hours_chk = true;
		}
		
		if(Number(date) == 1) {
			if(month_chk == true){
				// 1일에 업데이트 쿼리
				dataJson.alarm_cycle = "매월";
				SendTojsp3(JSONparam, "M909S190100E502");
				month_chk = false;
			}
		}else{
			month_chk = true;
		}
		
		if(Number(month) == 1 && Number(date) == 1) {
			if(year_chk == true){
				// 1월 1일에 업데이트 쿼리
				dataJson.alarm_cycle = "매년";
				SendTojsp3(JSONparam, "M909S190100E502");
				montyear_chkh_chk = false;
			}
		}else{
			year_chk = true;
		}
	}
</script>
<div id="cover_web_alarm">
	<div id="document">
		<table class="table table-striped table-valign-middle">
	     <thead>
	     <tr>
	       <th>
	       	<span>점검표 미작성 목록</span>
	       	<!-- <button class="btn btn-success" id="document_edit">수정</button> -->
	       </th>
	     </tr>
	     </thead>
	     <tbody></tbody>
	   </table>
	</div>
	
	<div id="document_sign">
		<table class="table table-striped table-valign-middle">
	     <thead>
	     <tr>
	     	<th>
	       		<span>점검표 서명 미작성 목록</span>
	       		<!-- <button class="btn btn-success" id="sulbi_edit">수정</button> -->
	       	</th>
	     </tr>
	     </thead>
	     <tbody></tbody>
	   </table>
	</div>
	
</div>

				                 
