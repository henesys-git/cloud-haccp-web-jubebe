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
	
	String sMenuTitle = request.getParameter("MenuTitle").toString();
	String sProgramId = request.getParameter("programId").toString();
	String sHeadmenuID= request.getParameter("HeadmenuID").toString();
	String sHeadmenuName= request.getParameter("HeadmenuName").toString();
	
	Vector LocationCode = null;
	Vector LocationName = null;
	Vector LocationVector = CommonData.getDeliverLocation();
	
%>

 <script type="text/javascript">
	var driver_id		= "";
 	var driver_rev_no	= "";
	var driver_nm		= "";
 	var drive_location = "";
	var location_gubun2 = ""; 
	var vehicle_nm 	   = "";
	var vehicle_cd 	   = "";
	var vehicle_rev_no = "";
	var location_nm = "";
	var cust_cd = "";

 $(document).ready(function () {
	 	
    	$("#InfoContentTitle").html("배송기사 정보");
		
    	fn_MainSubMenuSelect("<%=sMenuTitle%>");     
    	
    	fn_MainInfo_List();
    	fn_DetailInfo_List();
    	
    	$("#select_Location").on("change", function() {
 	    
    	location_nm = $(this).val();
	    	
 	    fn_DetailInfo_List();
	    
 	    return;
 	    
    	});
 	   
    });
       
    //배송정보 메인 페이지
     function fn_MainInfo_List() {
    	
       $.ajax({
            type: "POST",
            url: "<%=Config.this_SERVER_path%>/Contents/Business/M909/S909S115100.jsp",
            beforeSend: function () {
                $("#Main_contents").children().remove();
            },
            success: function (html) {
                $("#Main_contents").hide().append(html).fadeIn(100);
            }
        });
    }
    
   //배송정보 서브 페이지
     function fn_DetailInfo_List() {
    	
	   var location_nm = $("#select_Location").val();
	   
       $.ajax({
            type: "POST",
            url: "<%=Config.this_SERVER_path%>/Contents/Business/M909/S909S115110.jsp",
            data : "location_nm=" + location_nm,
            beforeSend: function () {
                $("#Sub_contents").children().remove();
            },
            success: function (html) {
                $("#Sub_contents").hide().append(html).fadeIn(100);
            }
        });
    } 
	
   //차량정보등록
     function pop_fn_VehicleInfo_Insert(obj) {
    	
    	var url = "<%=Config.this_SERVER_path%>/Contents/Business/M909/S909S115121.jsp";
    	var footer = '<button id="btn_Save" class="btn btn-info">저장</button>';
       	var title = obj.innerText;
    	var heneModal = new HenesysModal(url, 'standard', title, footer);
    	heneModal.open_modal();
	}
	 
  	//차량정보삭제
     function pop_fn_VehicleInfo_Delete(obj) {
  		
    	var url = "<%=Config.this_SERVER_path%>/Contents/Business/M909/S909S115123.jsp";
     	var footer = '<button id="btnUpdate" class="btn btn-info">삭제</button>';
       	var title = obj.innerText;
    	var heneModal = new HenesysModal(url, 'standard', title, footer);
    	heneModal.open_modal();
    } 
   
   
   //배송기사 정보등록
     function pop_fn_DriverInfo_Insert(obj) {
    	
    	var url = "<%=Config.this_SERVER_path%>/Contents/Business/M909/S909S115101.jsp";
    	var footer = '<button id="btn_Save" class="btn btn-info">저장</button>';
       	var title = obj.innerText;
    	var heneModal = new HenesysModal(url, 'standard', title, footer);
    	heneModal.open_modal();
	}
	 
  	//배송기사 정보수정
     function pop_fn_DriverInfo_Update(obj) {
    	
    	if(driver_id.length < 1){
    		heneSwal.warning('수정할 배송기사 정보를 선택하세요');
    		return false;
    	}
  		
    	var url = "<%=Config.this_SERVER_path%>/Contents/Business/M909/S909S115102.jsp?driver_id=" + driver_id
    			   + "&driver_nm=" + driver_nm
    			   + "&drive_location=" + drive_location
    			   + "&location_gubun2=" + location_gubun2
    			   + "&vehicle_nm=" + vehicle_nm
    			   + "&vehicle_cd=" + vehicle_cd;
    	
    	
     	var footer = '<button id="btnUpdate" class="btn btn-info">수정</button>';
       	var title = obj.innerText;
    	var heneModal = new HenesysModal(url, 'standard', title, footer);
    	heneModal.open_modal();
    } 
	
  	
  //배송기사 정보삭제
     function pop_fn_DriverInfo_Delete(obj) {
	    
    	if(driver_id.length < 1){
    		heneSwal.warning('삭제할 배송기사 정보를 선택하세요');
    		return false;
    	} else{
    		DeleteDriverInfo();
    	}
	  	
    	function DeleteDriverInfo() {
        	
	        var dataJson = new Object();
			
			dataJson.user_id	 	= driver_id;
			dataJson.user_rev_no 	= driver_rev_no;
        	
			var JSONparam = JSON.stringify(dataJson);
			var chekrtn = confirm("해당 정보를 삭제하시겠습니까?"); 
			
			if(chekrtn) {
				SendTojsp(JSONparam, "M909S115100E103");
			} else{
			       return false;
			}
		
		}

		function SendTojsp(bomdata, pid) {
	    	$.ajax({
	        	type: "POST",
	        	dataType: "json",
	        	url: "<%=Config.this_SERVER_path%>/Contents/CommonView/insert_update_delete_json.jsp", 
	        	data:  {"bomdata" : bomdata, "pid" : pid},
				success: function (html) {	
					if(html > -1) {
					heneSwal.success('삭제가 완료되었습니다');
					$('#modalReport').modal('hide');
	        		parent.fn_MainInfo_List();
	        		parent.fn_DetailInfo_List();
	         	} else {
					heneSwal.error('삭제에 실패했습니다, 다시 시도해주세요');	         		
	         	}
	         }
	     });
	}
    	
    }
  
  	
   //가맹점 배송순서 입력
     function OrderIndex_Insert(obj) {
    	
	    var location_nm = $("#select_Location").val();
	   
    	var url = "<%=Config.this_SERVER_path%>/Contents/Business/M909/S909S115111.jsp?location_nm=" + location_nm;
    	var footer = '<button id="btn_Save" class="btn btn-info">저장</button>' +
    				 '<button id="btn_Canc" class="btn btn-info">닫기</button>';
       	var title = obj.innerText;
    	var heneModal = new HenesysModal(url, 'standard', title, footer);
    	heneModal.open_modal();
	}
	 
  	//가맹점 배송순서 수정
     function OrderIndex_Update(obj) {
    	
    	if(cust_cd.length < 1){
    		heneSwal.warning('수정할 가맹점 배송순서 정보를 선택하세요');
    		return false;
    	}
    	
    	var location_nm = $("#select_Location").val();
  		
    	var url = "<%=Config.this_SERVER_path%>/Contents/Business/M909/S909S115112.jsp?cust_cd=" + cust_cd
    			   + "&cust_rev_no=" + cust_rev_no
    			   + "&deliver_index=" + deliver_index
    			   + "&location_nm=" + location_nm;
    	
    	
     	var footer = '<button id="btnUpdate" class="btn btn-info">수정</button>' + 
     				 '<button id="btn_Canc" class="btn btn-info">닫기</button>';
       	var title = obj.innerText;
    	var heneModal = new HenesysModal(url, 'standard', title, footer);
    	heneModal.open_modal();
    } 
</script>
 
     <!-- Content Header (Page header) -->
<div class="content-header">
  <div class="container-fluid">
    <div class="row mb-2">
      <div class="col-sm-6">
        <h1 class="m-0 text-dark" id="MenuTitle">여기에 메뉴 타이틀</h1>
      </div><!-- /.col-->
      <div class="col-sm-6">
      	<div class="float-sm-right">
      		<button type="button" onclick="pop_fn_VehicleInfo_Insert(this)" id="insert" class="btn btn-outline-dark">차량정보 등록</button>
      		<button type="button" onclick="pop_fn_VehicleInfo_Delete(this)" id="delete" class="btn btn-outline-danger">차량정보 삭제</button>
      		<button type="button" onclick="pop_fn_DriverInfo_Insert(this)" id="insert" class="btn btn-outline-dark">배송기사 정보 등록</button>
			<button type="button" onclick="pop_fn_DriverInfo_Update(this)" id="update" class="btn btn-outline-success">배송기사 정보 수정</button>
			<button type="button" onclick="pop_fn_DriverInfo_Delete(this)" id="delete" class="btn btn-outline-danger">배송기사 정보 삭제</button>
      		
	           
      	</div>
      </div><!-- /.col -->
    </div> <!-- /.row -->
  </div> <!-- /.container-fluid-->
</div><!--  /.content-header -->

 <!--  Main content-->
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
          <div class="card-body" id="Main_contents"></div>
          
        </div>
      </div> <!--/.col-md-6-->
    </div> <!-- /.row-->
    
    <div class="card card-primary card-outline">
	   	<div class="card-header">
	   		<h3 class="card-title">
	   			<i class="fas fa-edit">가맹점 배송순서</i>
	   		</h3>
	   	  <div class="card-tools">
	   	  	<table>
	   	  		<tr>
          			<td>
					배송지역
					</td>
					<td></td>
					  <td>
						<select class="form-control" id="select_Location">
							<% LocationCode = (Vector)LocationVector.get(1);%>
							<% LocationName = (Vector)LocationVector.get(2);%>
							<% for(int i=0; i<LocationName.size();i++){ %>
							<option value='<%=LocationCode.get(i).toString()%>'>
							<%=LocationName.get(i).toString()%>
							</option>
							<% } %>
						</select>
					  </td>
					 <td></td>
					 <td>
					 	<button type="button" onclick="OrderIndex_Insert(this)" 
							id="insert" class="btn btn-outline-dark">
						배송순서 신규입력
						</button>         
					 </td>
					 
					 <td>
					 	<button type="button" onclick="OrderIndex_Update(this)" 
							id="update" class="btn btn-outline-success">
						배송순서 수정
						</button>
					 </td>
				</tr>        
	   	  	</table>
	   	  	 	  
				
	   	  
	   	  </div>
	   	</div>
	   	<div class="card-body" id="Sub_contents"></div>
	</div>
  </div> <!--  /.container-fluid-->
</div><!-- /.content-->