<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*,java.util.*,javax.servlet.http.*"%>
<%@ page import="mes.client.comm.*" %>
<%@ page import="mes.client.common.*" %>
<%@ page import="mes.client.guiComponents.*" %>
<%@ page import="mes.client.util.*" %>
<%@ page import="mes.client.conf.*" %>

<!-- 
원료수불일보 
yumsam
-->

<%
	String loginID = session.getAttribute("login_id").toString();
	String member_key = session.getAttribute("member_key").toString();
	if(loginID == null || loginID.equals("")) {         // id가 Null 이거나 없을 경우
		response.sendRedirect("Contents/index.jsp");    // 로그인 페이지로 리다이렉트 한다.
	}
	
    Vector optCode = null;
    Vector optName = null;
    Vector partgubun_midVector = PartListComboData.getPartMidGubunDataAll("", member_key);
    Vector partgubun_bigVector = PartListComboData.getPartBigGubunDataAll(member_key);
    Vector partList = PartListComboData.getPart(member_key);
%>

<script type="text/javascript">
 	var vPartCd = "";
 	var vPartRevNo = "";
 	var vPartNm = "";
 	
 	var checklistId = "checklist98";
 	var checklistRevNo = "0";

 	$(document).ready(function () {
    	
    	var date = new SetRangeDate("dateParent", "dateRange", 30);
    	startDate = date.start.format('YYYY-MM-DD');
       	endDate = date.end.format('YYYY-MM-DD');
    	
        fn_MainSubMenuSelect("원료수불일보");
		$("#InfoContentTitle").html("버튼을 클릭해 원료를 선택해주세요");
		
		fn_MainInfo_List(startDate, endDate, vPartNm);
		
		// select part info
        $("#partListSelector").click(function() {
        	parent.pop_fn_PartList_View2(0, "");
        })
        
        $("#searchBtn").on("click", function() {
        	fn_MainInfo_List(startDate, endDate, vPartNm);
        })
    });

    function fn_MainInfo_List(startDate, endDate, partName) {
    	
		// 전기 이월 재고를 구하기 위해 시작날짜에서 하루를 빼준다
		var heneDate = new HeneDate();
		startDate = heneDate.minusDate(startDate, 1);
		
        $.ajax({
            type: "POST",
            url: "<%=Config.this_SERVER_path%>/Contents/Business/M353/S353S010100.jsp",
            data: "startDate=" + startDate + 
            	  "&endDate=" + endDate +
            	  "&partCd=" + vPartCd,
            beforeSend: function () {
                $("#MainInfo_List_contents").children().remove();
            },
            success: function (html) {
                $("#MainInfo_List_contents").hide().html(html).fadeIn(100);
            }
        });
    }
    
 	// 점검표 조회
    function displayChecklist(element) {
    	
    	if(vPartCd === "") {
    		heneSwal.warning('원료수불일보 조회를 먼저 해주세요');
    		return false;
    	}
    	
    	var date = new HeneDate();
    	
    	let ajaxUrl = '<%=Config.this_SERVER_path%>/Contents/CheckList/getChecklistFormat.jsp';
    	
    	let jObj = new Object();
    	jObj.checklistId = "checklist98";
    	jObj.checklistRevNo = "0";
    	jObj.checklistDate = date.getToday();

    	let ajaxParam = JSON.stringify(jObj);
	
    	$.ajax({
    		url: ajaxUrl,
    		data: {"ajaxParam" : ajaxParam},
    		success: function(rcvData) {
    			const format = rcvData[0][0];	// 이미지 파일
    			const page = rcvData[0][1];		// jsp 페이지
    			
		    	const modalUrl = '<%=Config.this_SERVER_path%>' + page
		    					+ '?format=' + format
			    				+ '&checklistId=' + checklistId 
			    				+ '&checklistRevNo=' + checklistRevNo
			    				+ '&ccpDate=' + date.getToday()
			    				+ '&partCd=' + vPartCd
			    				+ '&startDate=' + startDate
			    				+ '&endDate=' + endDate;
		    	
				const footer = "<button type='button' class='btn btn-outline-primary' onclick='printChecklist()'>출력</button>";
				const title = element.innerText;
				const heneModal = new HenesysModal(modalUrl, 'auto', title, footer);
				heneModal.open_modal();
    		}
    	});
    }
	
	function SetpartName_code(partCd, partRevNo, partNm) {
		vPartCd = partCd;
		vPartRevNo = partRevNo;
		vPartNm = partNm;
		$("#InfoContentTitle").html(vPartNm);
    }
</script>
    
<!-- Content Header (Page header) -->
<div class="content-header">
 		<div class="container-fluid">
   		<div class="row mb-2">
	    	<div class="col-sm-6">
	      		<h1 class="m-0 text-dark" id="MenuTitle">여기에 메뉴 타이틀</h1>
	      	</div>
	      	<div class="col-sm-6">
     			<div class="float-sm-right">
     				<button type="button" onclick="displayChecklist(this)" 
     				  	 	class="btn btn-outline-dark">
     					일지 출력
     				</button>
     			</div>
     		</div>
 		</div><!-- /.row -->
    </div><!-- /.container-fluid -->
</div>
<!-- /.content-header -->
   
<!-- Main content -->
<div class="content">
	<div class="container-fluid">
  		<div class="row">
  			<div class="col-md-12">
      			<div class="card card-primary card-outline">
        			<div class="card-header">
         				<h3 class="card-title">
         					<i class="fas fa-edit" id="InfoContentTitle"></i>
         				</h3>
        				<div class="card-tools row">
        					<div class="col-md-4">
								<button class="btn btn-default" id="partListSelector">
									원료 선택
								</button>
							</div>
							<div class="input-group input-group-sm col-md-6" id="dateParent">
				          	  	<input type="text" class="form-control float-right" id="dateRange">
				        	</div>
				        	<div class="col-md-2">
				        		<button type="submit" class="btn btn-default" id="searchBtn">
			          	  	    	<i class="fas fa-search"></i>
			          	  		</button>
				        	</div>
      					</div>
					</div>
         			<div class="card-body" id="MainInfo_List_contents"></div> 
       			</div>
     		</div>
     		<!-- /.col-md-6 -->
   		</div>
   		<!-- /.row -->
	</div><!-- /.container-fluid -->
</div>
<!-- /.content -->