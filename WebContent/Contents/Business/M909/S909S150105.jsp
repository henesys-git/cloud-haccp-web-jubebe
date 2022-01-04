<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*,java.util.*,javax.servlet.http.*"%>
<%@ page import="mes.client.comm.*" %>
<%@ page import="mes.client.common.*" %>
<%@ page import="mes.client.guiComponents.*" %>
<%@ page import="mes.client.util.*" %>
<%@ page import="mes.client.conf.*" %>
<%@ page import="org.json.simple.*"%><%@ include file="/strings.jsp" %>
<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1" >
<%
	String loginID = session.getAttribute("login_id").toString();
	String member_key = session.getAttribute("member_key").toString();
	String GV_BIZNO = "" ;
	String GV_REV = "" ;
	if (request.getParameter("Biz_no") == null)
		GV_BIZNO = "";
	else
		GV_BIZNO = request.getParameter("Biz_no");
	
	if (request.getParameter("revisio_no") == null)
		GV_REV = "";
	else
		GV_REV = request.getParameter("revisio_no");
	
	DoyosaeTableModel TableModel;
	String zhtml = "";
    Vector optCode =  null;
    Vector optName =  null;
	
	String[] strColumnHead = {""} ;
	String param = GV_BIZNO + "|"  + GV_REV ;
	
	JSONObject jArray = new JSONObject();
	jArray.put( "member_key", member_key);
	jArray.put( "BIZNO", GV_BIZNO);
	jArray.put( "REV", GV_REV);
	
	TableModel = new DoyosaeTableModel("M909S150100E105", strColumnHead, jArray);
	int ColCount =TableModel.getColumnCount();
	
	// 데이터를 가져온다.S909S150105
	Vector targetSulbiVector = (Vector)(TableModel.getVector().get(0));
		
%>
 
<%-- <jsp:include page="../../Common/linkcss_js.jsp" flush="false"/> --%>
        
    <script type="text/javascript">
    
	// 캐시 비적용
	<%-- <%
	response.setHeader("Cache-Control","no-cache");
	response.setHeader("Pragma","no-cache");
	response.setDateHeader("Expires",0);
	%> --%>
	
	var vSealImageFileName = "";
	var vLogoImageFileName = "";
    
    $(document).ready(function () {
    	$('#txt_BizNo').val('<%=targetSulbiVector.get(0).toString().trim()%>');
    	$('#txt_Cust_nm').val('<%=targetSulbiVector.get(2).toString().trim()%>');
    	$('#txt_Juso').val('<%=targetSulbiVector.get(3).toString().trim()%>');
    	$('#txt_Zipno').val('<%=targetSulbiVector.get(10).toString().trim()%>');
    	$('#txt_TelNo').val('<%=targetSulbiVector.get(4).toString().trim()%>');
    	$('#txt_BossName').val('<%=targetSulbiVector.get(5).toString().trim()%>');
    	$('#txt_Uptae').val('<%=targetSulbiVector.get(6).toString().trim()%>');
    	$('#txt_Jongmok').val('<%=targetSulbiVector.get(7).toString().trim()%>');
    	$('#txt_Fax').val('<%=targetSulbiVector.get(8).toString().trim()%>');
    	$('#txt_HomePage').val('<%=targetSulbiVector.get(9).toString().trim()%>');
    	$('#txt_RevisionNo').val('<%=targetSulbiVector.get(1).toString().trim()%>');
    	$('#txt_StartDate').val('<%=targetSulbiVector.get(13).toString().trim()%>');
    	$('#txt_haccp_No').val('<%=targetSulbiVector.get(14).toString().trim()%>');
    	$('#txt_kape_openapi_userid').val('<%=targetSulbiVector.get(15).toString().trim()%>');
    	$('#txt_kape_openapi_apikey').val('<%=targetSulbiVector.get(16).toString().trim()%>');
    	
    	// DB에서 읽어온 이미지파일명 전역변수(v~~ImageFileName)에 집어넣고 미리보기 화면에 띄우기
        vSealImageFileName = "<%=targetSulbiVector.get(11).toString().trim()%>";
        vLogoImageFileName = "<%=targetSulbiVector.get(12).toString().trim()%>";
	    if(vSealImageFileName != "") fn_Set_Image_File(vSealImageFileName, 'SealImageFile');
	    if(vLogoImageFileName != "") fn_Set_Image_File(vLogoImageFileName, 'LogoImageFile');
	    
    });
    
 	// 미리보기 화면에 이미지파일 띄우기
    function fn_Set_Image_File(imageFile, canvasID){
		var canvas = document.getElementById(canvasID);
		var context = canvas.getContext('2d');
		var imgSrc = "<%=Config.this_SERVER_path%>/images/Company/"
					+ imageFile 
					+ "?v=" + Math.random(); // 파일경로 + 저장한 파일명 + 랜덤숫자데이터(파일캐시 방지용)
		loadImages(imgSrc, context);
		function loadImages(ImgPage1, context) {
			  var images;
			  images = new Image();
			  images.onload = function() {
				  context.clearRect(0, 0, canvas.width, canvas.height);
				  context.drawImage(this, 0, 0, canvas.width, canvas.height);
			  };
			  images.onerror = function () {
			  };
			  images.src = ImgPage1;
		} 
    }
    
    </script>
    <!-- 캐시 비적용 -->
    <meta http-equiv="Cache-Control" content="no-cache"/>
	<meta http-equiv="Expires" content="0"/>
	<meta http-equiv="Pragma" content="no-cache"/>
</head>
<body>
   <table class="table table-bordered" style="width: 100%; margin: 0 auto; align:left">
   		<tr>
   			<td style="width: 30%">
	        <table class="table table-bordered" style="width: 100%; margin: 0 auto; align:left">
		        <tr style="vertical-align: middle">
		            <td style="width: 60px; font-weight: 900; font-size:14px; text-align:center; vertical-align: middle">
		            	직인 이미지
		            </td>
		        </tr>
		        <tr style="vertical-align: middle">
		            <td style="width: 60px; font-weight: 900; font-size:14px; text-align:center; vertical-align: middle">
		            	<canvas id="SealImageFile" width="300" height="300" style="border:1px solid #d3d3d3;" ></canvas>		            	
		            </td>
		        </tr>
	
		        <tr style="vertical-align: middle">
		            <td style="width: 60px; font-weight: 900; font-size:14px; text-align:center; vertical-align: middle">
						회사 로고 이미지
		            </td>
		        </tr>
		        <tr style="vertical-align: middle">
		            <td style="width: 60px; font-weight: 900; font-size:14px; text-align:center; vertical-align: middle">
		            	<canvas id="LogoImageFile" width="300" height="100" style="border:1px solid #d3d3d3;" ></canvas>		            	
		            </td>
		        </tr>
		    </table>
        	</td>
        	<td style="width: 40%">
        	<table class="table table-bordered" style="width: 100%; margin: 0 auto; align:left">
        		<tr style="background-color: #fff; height: 40px">
            		<td>사업자등록번호</td>
            		<td> </td>
            		<td ><input type="text" class="form-control" id="txt_BizNo" style="width: 200px; float:left" readonly />
           			</td>
        		</tr>
				<tr style="background-color: #fff; height: 40px">
            		<td>회사명</td>
            		<td> </td>
            		<td ><input type="text" class="form-control" id="txt_Cust_nm" style="width: 200px; float:left"  readonly />
           			</td>
        		</tr>
  				<tr style="background-color: #fff; height: 40px">
            		<td>주소</td>
            		<td> </td>
            		<td ><input type="text" class="form-control" id="txt_Juso" style="width: 400px; float:left" readonly  />
           			</td>
        		</tr>
         		<tr style="background-color: #fff; height: 40px">
            		<td>우편번호</td>
            		<td> </td>
            		<td ><input type="text" class="form-control" id="txt_Zipno" style="width: 200px; float:left" readonly  />
           			</td>
        		</tr>
		        <tr style="background-color: #fff; height: 40px">
    		        <td>전화번호</td>
        		    <td> </td>
            		<td ><input type="text" class="form-control" id="txt_TelNo" style="width: 200px; float:left"  readonly />
           			</td>
        		</tr>
				<tr style="background-color: #fff; height: 40px">
            		<td>대표자명</td>
            		<td> </td>
            		<td ><input type="text" class="form-control" id="txt_BossName" style="width: 200px; float:left" readonly  />
           			</td>
		        </tr>
        		<tr style="background-color: #fff; height: 40px">
            		<td>업태</td>
            		<td> </td>
            		<td ><input type="text" class="form-control" id="txt_Uptae" style="width: 200px; float:left" readonly  />
           			</td>
        		</tr>
        		<tr style="background-color: #fff; height: 40px">
            		<td>종목</td>
            		<td> </td>
		            <td ><input type="text" class="form-control" id="txt_Jongmok" style="width: 200px; float:left"  readonly />
		           	</td>
        		</tr>
 		        <tr style="background-color: #fff; height: 40px">
		            <td>Fax</td>
		            <td> </td>
    		        <td ><input type="text" class="form-control" id="txt_Fax" style="width: 200px; float:left"  readonly />
		           	</td>
        		</tr>
		        <tr style="background-color: #fff; height: 40px">
		            <td>Home Page</td>
		            <td> </td>
		            <td ><input type="text" class="form-control" id="txt_HomePage" style="width: 200px; float:left"   readonly/>
		           	</td>
		        </tr>
        		<tr style="background-color: #fff; height: 40px">
            		<td>개정번호</td>
            		<td> </td>
            		<td ><input type="text" class="form-control" id="txt_RevisionNo" value="0" style="width: 200px; float:left" readonly />
        		   	</td>
        		</tr>
        		<tr style="background-color: #fff; height: 40px">
            		<td>적용시작일자</td>
            		<td> </td>
            		<td >
            			<input type="text" data-date-format="yyyy-mm-dd" id="txt_StartDate" class="form-control"
            		    	style="width: 220px; border: solid 1px #cccccc;" readonly/>
        		   	</td>
        		</tr>
        		<tr style="background-color: #fff; height: 40px">
            		<td>변경사유</td>
            		<td> </td>
        		    <td ><input type="text" class="form-control" id="txt_modify_reason" style="width: 200px; float:left"  readonly/>
    		       	</td>
		        </tr>
            	</table>
        	</td>
   			<td  style="width: 30%">
   			
   				<table class="table" style="width: 100%; margin: 0 auto; align:left; ">
        		<tr style="background-color: #fff; height: 40px">
            		<td>HACCP인증번호</td>
            		<td> </td>
            		<td ><input type="text" class="form-control" id="txt_haccp_No" style="width: 200px; float:left"  />
           			</td>
        		</tr>
				<tr style="background-color: #fff; height: 40px">
            		<td></td>
            		<td></td>
            		<td></td>
        		</tr>

		         <tr style="background-color: #fff; height: 40px">
        		    <td>이력제 Open API 사용자 아이디</td>
            		<td> </td>
            		<td ><input type="text" class="form-control" id="txt_kape_openapi_userid" style="width: 200px; float:left"/>
           			</td>
        		</tr>
        		<tr style="background-color: #fff; height: 40px">
            		<td>이력제 Open API 서비스KEY</td>
            		<td> </td>
            		<td ><input type="text" class="form-control" id="txt_kape_openapi_apikey" style="width: 200px; float:left"  />
           			</td>
        		</tr>
   				</table>
   			</td>
        </tr>
        <tr style="height: 60px">
            <td colspan="4" align="center">
                <p>
                    <button id="btn_Canc"  class="btn btn-info" style="width: 100px" onclick="parent.$('#modalReport').hide();">닫기</button>
                </p>
            </td>
        </tr>
    </table>
</body>
</html>