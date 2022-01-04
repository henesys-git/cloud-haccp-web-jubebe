<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*,java.util.*,javax.servlet.http.*"%>
<%@ page import="mes.client.comm.*" %>
<%@ page import="mes.client.common.*" %>
<%@ page import="mes.client.guiComponents.*" %>
<%@ page import="mes.client.util.*" %>
<%@ page import="mes.client.conf.*" %>
<%  
/* 
검·교정 기록부(M838S070300.jsp)
 */
 	String loginID = session.getAttribute("login_id").toString();
	String member_key = session.getAttribute("member_key").toString();
	
	if(loginID==null||loginID.equals("")){                            			// id가 Null 이거나 없을 경우
		response.sendRedirect(Config.this_SERVER_path + "/Contents/index.jsp"); // 로그인 페이지로 리다이렉트 한다.
	}

	String sMenuTitle = request.getParameter("MenuTitle").toString();
	String sProgramId = request.getParameter("programId").toString();
	String sHeadmenuID= request.getParameter("HeadmenuID").toString();
	String sHeadmenuName= request.getParameter("HeadmenuName").toString();
	
	Get_Program_button_Autho prg_autho = new Get_Program_button_Autho(loginID,sProgramId);	
%>

 <script type="text/javascript">
 
	///////////////////////////////////// 2021-05-21
	var checklist_id = "checklist13";
	var checklist_rev_no = "";
	var check_date = "";
	
    $(document).ready(function () {
        
        fn_MainSubMenuSelect("<%=sMenuTitle%>");
		$("#InfoContentTitle").html("검교정 기록부");

    	fn_MainInfo_List();
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

    function fn_MainInfo_List() {
    	
    	$.ajax({
            type: "POST",
            url: "<%=Config.this_SERVER_path%>/Contents/Business/M838/S838S070300.jsp",
            <%-- data: 날짜같은게 있는게 좋을것 같음 ,  //0521 서승헌 --%>
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
    	
    	if(check_date.length < 1){
     		heneSwal.warning("조회할 점검표를 선택해주세요");
 			return false;
 		}
    	
    	let ajaxUrl = '<%=Config.this_SERVER_path%>/Contents/CheckList/getChecklistFormat.jsp';
    	let jObj = new Object();
    	
    	jObj.checklistId = checklist_id;
    	jObj.checklistRevNo = checklist_rev_no;
    	jObj.checklistDate = check_date;
    	
		let ajaxParam = JSON.stringify(jObj);

    	$.ajax({
    		url: ajaxUrl,
    		data: {"ajaxParam" : ajaxParam},
    		success: function(rcvData) {
    			const format = rcvData[0][0];	// 이미지 파일
    			const page = rcvData[0][1];		// jsp 페이지
    			
		    	const modalUrl = '<%=Config.this_SERVER_path%>' + page
		    				    + '?format=' + format
		    					+ '&check_date=' + check_date;	
				const footer = "<button type='button' class='btn btn-outline-primary'"
									 + "onclick='printChecklist()'>출력</button>";
				const title = element.innerText;
				const heneModal = new HenesysModal(modalUrl, 'auto', title, footer);
				heneModal.open_modal();
    		}
    	});
    }
    
    // 문서등록
    function haccpInsert(obj) {
  
     	var modalContentUrl = "<%=Config.this_SERVER_path%>/Contents/Business/M838/S838S070301.jsp"
							+ "?checklist_id="+checklist_id;
     
		var footer = "<button id='btn_Save' class='btn btn-info' onclick='SaveOderInfo();'>등록</button>";
		var title = obj.innerText;
		var heneModal = new HenesysModal(modalContentUrl, 'large', title, footer);
		heneModal.open_modal();
	}
	
    // 문서수정
    function haccpUpdate(obj) {
    	
     	if(check_date.length < 1){
     		heneSwal.warning("수정할 점검표를 선택해주세요");
 			return false;
 		}

 		var modalContentUrl = "<%=Config.this_SERVER_path%>/Contents/Business/M838/S838S070302.jsp"
							+ "?check_date="+check_date;		
 
		var footer = "<button id='btn_Save' class='btn btn-info' onclick='SaveOderInfo();'>수정</button>";
		var title = obj.innerText;
		var heneModal = new HenesysModal(modalContentUrl, 'large', title, footer);
		heneModal.open_modal();
    }

    function haccpDelete(obj) {
		if(check_date.length < 1){
  	 		heneSwal.warning("삭제할 점검표를 선택해주세요");
  	 		return false;
		}
		
		var dataJson = new Object();
		dataJson.checklist_rev_no = checklist_rev_no;
		dataJson.check_date = check_date;
		
		var JSONparam = JSON.stringify(dataJson);
		var chekrtn = confirm("삭제하시겠습니까?"); 
		
		if(chekrtn) {

			 $.ajax({
			        type: "POST",
			        dataType: "json",
			        url: "<%=Config.this_SERVER_path%>/Contents/CommonView/insert_update_delete_json.jsp", 
			        data:  {"bomdata" : JSONparam, "pid" : "M838S070300E103"},
					success: function (html) {	
						if(html > -1) {
							heneSwal.success('점검표 삭제가 완료되었습니다');

							$('#modalReport').modal('hide');
			        		parent.fn_MainInfo_List();
			        		parent.$('#SubInfo_List_contents').hide();
			         	} else {
							heneSwal.error('점검표 삭제에 실패했습니다, 다시 시도해주세요');	         		
			         	}
			         }
			     });
		} else {
			return false;
		}
	}
</script>
<!-- Content Header (Page header) -->
<div class="content-header">
  <div class="container-fluid">
    <div class="row mb-2">
      <div class="col-sm-6">
        <h1 class="m-0 text-dark" id="MenuTitle">메뉴타이틀</h1>
      </div><!-- /.col -->
      <div class="col-sm-6">
      	<div class="float-sm-right">
      		<button type = "button" onclick = "haccpInsert(this)" id="insert" class= "btn btn-outline-dark">점검표 등록</button>
			<button type = "button" onclick = "haccpUpdate(this)" id="update" class= "btn btn-outline-success">점검표 수정</button>
			<button type = "button" onclick = "haccpDelete(this)" id="delete" class= "btn btn-outline-danger">점검표 삭제</button>
			<button type = "button" onclick = "displayChecklist(this)" class="btn btn-outline-dark"> 점검표 조회 </button>
      	</div>
      </div>
    </div> <!-- /.row -->
  </div> <!-- /.container-fluid -->
</div> <!-- /.content-header -->

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
          </div>
          	<div class="card-body" id="MainInfo_List_contents"></div>
        </div>
      </div> <!-- /.col-md-12 -->
    </div> <!-- /.row -->
  </div> <!-- /.container-fluid -->
</div> <!-- /.content -->