﻿<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
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
	
	DoyosaeTableModel TableModel;
	Vector optCode =  null;
	Vector optName =  null;
	Vector sulbiGroupVector = CommonData.getSulbiGroupDataAll(member_key);

	String[] strColumnHead = {"", "", "", "", ""} ;
		
	String  GV_SULBI_CODE="",GV_REVISION_NO="";
	String GV_SULBI_GROUP="";

	if(request.getParameter("seolbi_cd") != null)
		GV_SULBI_CODE = request.getParameter("seolbi_cd");

	if(request.getParameter("RevisionNo") != null)
		GV_REVISION_NO = request.getParameter("RevisionNo");
	
	JSONObject jArray = new JSONObject();
	jArray.put( "member_key", member_key);
	jArray.put( "SULBI_CODE", GV_SULBI_CODE);
	jArray.put( "REVISION_NO", GV_REVISION_NO);

	TableModel = new DoyosaeTableModel("M909S050100E204", strColumnHead, jArray);
	
	// 데이터를 가져온다.
	Vector targetSulbiVector = (Vector)(TableModel.getVector().get(0));
	
    // 개정번호를 만든다.
    String revisionNumberStr = "";
    int revisionNoInt = 0;
    
    try {
		revisionNoInt = Integer.parseInt( targetSulbiVector.get(1).toString().trim() );
    } catch (Exception e) {
    	revisionNoInt = 0;
    }
    
    revisionNoInt = revisionNoInt + 1;
    revisionNumberStr = "" + revisionNoInt;
    
    // 주요점검 및 주의사항 | 사용방법 | 청소방법
    String[] checklists = targetSulbiVector.get(24).toString().split("/");
    String[] facilities_usage = targetSulbiVector.get(25).toString().split("/");
    String[] clean_way = targetSulbiVector.get(26).toString().split("/");
    
%>
<style>
#width100 input, #width100 select {
	width : 100% !important;
}

#width100 ul, #width100 ol{
	text-align: left;
	font-size: 15px;
	margin-bottom: 0;
	background-color: #e9ecef;
    /* margin: 0%; */
    border: solid 1px #cccccc;
    border-radius: 4px;
  	padding-top: 3%;
    padding-bottom: 3%;
}

#width100 ul li{
	margin-bottom: 5px;
} 

#width100 ol li{
	margin-bottom: 1px;
}    
</style>

<script type="text/javascript">

    var detail_seq = 1;
    var vImageFileName = "";
    
    $(document).ready(function () {
    	detail_seq = 1;
        
        $('#txt_DoipDate').val("<%=targetSulbiVector.get(2).toString()%>");
        
		$('#txt_detail_seq').val(detail_seq);	
	    vImageFileName = "<%=targetSulbiVector.get(14).toString()%>";
	    Set_image_File(vImageFileName);    
	    
	    if('<%= targetSulbiVector.get(24).toString() %>' == '' || '<%= targetSulbiVector.get(24).toString() %>' == null){
	    	$("#checklists").html("");
	    } 
	    if('<%= targetSulbiVector.get(25).toString() %>' == '' || '<%= targetSulbiVector.get(25).toString() %>' == null) {
	    	$("#facilities_usage").html("");
	    } 
		if('<%= targetSulbiVector.get(26).toString() %>' == '' || '<%= targetSulbiVector.get(26).toString() %>' == null) {
	    	$("#clean_way").html("");
	    }
    });

     function Set_image_File( imageFile){
	    var images;
		var canvas = document.getElementById('SulbiImageFile');
		var context = canvas.getContext('2d');
		loadImages("<%=Config.this_SERVER_path%>/images/SULBI/" + imageFile , context);
		
		function loadImages(ImgPage1, context) {
			  var images = new Image();
			  
			  images.onload = function() {
				  context.drawImage(this,0 , 0,400,300);  //캔버스에 이미지 디스플레이
			  };
			  
			  images.src = ImgPage1;
		} 
    }
</script>
   
<table class="table table-bordered" style="width: 100%; margin: 0 auto; align:left">
   	<tr>   
		<td style="width: 30%">
	        <table class="table table-bordered" style="width: 100%; margin: 0 auto; align:left">
	 
		        <tr style="vertical-align: middle">
		            <td style="width: 60px; font-weight: 900; font-size:14px; text-align:center; vertical-align: middle" colspan="2">
		            	<canvas id="SulbiImageFile" width="400" height="300" style="border:1px solid #d3d3d3;" ></canvas>
		            </td>
		        </tr>
		        <tr style="background-color: #fff;">
		        </tr>
		        
		        <tr style="vertical-align: middle">
		            <td style="width: 60px; font-weight: 900; font-size:14px; text-align:center; vertical-align: middle" colspan="2">
		            </td>
		        </tr>
		    </table>
        </td>
   	</tr>
   	<tr id = "width100">
		<td style="width: 70%;">
   			<table class="table table-bordered" style="width: 100%; margin: 0 auto; align:left">
   				<tr>
 					 <td style=" font-weight: 900; font-size:14px; text-align:left">설비코드</td>
 					 <td colspan = 2 style=" font-weight: 900; font-size:14px; text-align:left">설비명칭</td>
 					 <td style="font-weight: 900; font-size:14px; text-align:left">설비구분</td>
   				</tr>
   			
		        <tr style="background-color: #fff;">
		            <td style=" font-weight: 900; font-size:14px; text-align:left">
						<input type="text" class="form-control" id="txt_SulbiCode" style="width: 150px; float:left" 
		            		value="<%=targetSulbiVector.get(0).toString()%>" readonly />
		           	</td>
		            <td style=" font-weight: 900; font-size:14px; text-align:left"  colspan="2">
						<input type="text" class="form-control" id="txt_SulbiName" style="float:left" 
		            		value="<%=targetSulbiVector.get(1).toString()%>" readonly />
		           	</td>
		           	 <td>
						<select class="form-control" id="select_SulbiGubun" style="width: 150px" disabled="disabled">
			            	<%	optCode =  (Vector)sulbiGroupVector.get(0);%>
			                <%	optName =  (Vector)sulbiGroupVector.get(1);%>
			                <%for(int i=1; i<optName.size();i++){ %>
								<option value='<%=optCode.get(i).toString()%>' 
									<%=targetSulbiVector.get(23).toString().equals(optCode.get(i).toString()) ? "selected" : "" %> >
									<%=optName.get(i).toString()%></option>
							<%} %>
						</select>
		            </td>
		        </tr>
			
				<tr>
					<td style="font-weight: 900; font-size:14px; text-align:left">도입일자</td>
		            <td style="font-weight: 900; font-size:14px; text-align:left">규격</td>
		            <td style=" font-weight: 900; font-size:14px; text-align:left">제조사</td>
				    <td style=" font-weight: 900; font-size:14px; text-align:left">기기번호</td>
				</tr>

				<tr style="background-color: #fff;">	
		            <td>
		            	<input type="text" data-date-format="yyyy-mm-dd" id="txt_DoipDate" class="form-control" style="width: 150px; border: solid 1px #cccccc;"
		            		value="<%=targetSulbiVector.get(2).toString()%>" readonly />
		            </td>
		            <td > 
		            	<input type="text" data-date-format="yyyy-mm-dd" id="txt_GyuGyuk" class="form-control" style="width: 150px; border: solid 1px #cccccc;"
		            		value="<%=targetSulbiVector.get(3).toString()%>" readonly />
		            </td>	
		            <td> 
		            	<input type="text"  id="txt_Maker" class="form-control" style="width: 150px; border: solid 1px #cccccc; vertical-align: middle;"
		            		value="<%=targetSulbiVector.get(4).toString()%>" readonly />
		            </td>
		            <td> 
		            	<input type="text"  id="txt_GigiBunho" class="form-control" style="width: 150px; border: solid 1px #cccccc; vertical-align: middle;"
		            		value="<%=targetSulbiVector.get(5).toString()%>" readonly  />
		            </td>	        
		        </tr>

				<tr>
				 	<td style=" font-weight: 900; font-size:14px; text-align:left">담당부서</td>	
					<td style=" font-weight: 900; font-size:14px; text-align:left">사용담당자</td>
					<td style="font-weight: 900; font-size:14px; text-align:left">책임담당자</td>
					<td style=" font-weight: 900; font-size:14px; text-align:left">교정담당자</td>
				</tr>
		
		        <tr style="background-color: #fff; ">
		            <td>
		            	<input type="text"  id="txt_UseDept" class="form-control" style="width: 150px; border: solid 1px #cccccc; vertical-align: middle;"
		            		value="<%=targetSulbiVector.get(6).toString()%>" readonly />
		            </td>		            
		            <td> 
		            	<input type="text"  id="txt_UseDamdangJa" class="form-control" style="width: 150px; border: solid 1px #cccccc; vertical-align: middle;"
		            		value="<%=targetSulbiVector.get(7).toString()%>" readonly />
		            </td>		 
		            <td><input type="text"  id="txt_CheckimDamdangJa" class="form-control" style="width: 150px; border: solid 1px #cccccc; vertical-align: middle;"
		            		value="<%=targetSulbiVector.get(8).toString()%>" readonly />
		            </td>
		            <td> 
		            	<input type="text"  id="txt_GyojungDamdangJa" class="form-control" style="width: 150px; border: solid 1px #cccccc; vertical-align: middle;"
		            		value="<%=targetSulbiVector.get(9).toString()%>" readonly />
		            </td>          
		        </tr>

				<tr>
					<td style=" font-weight: 900; font-size:14px; text-align:left">유효일자</td>
					<td style=" font-weight: 900; font-size:14px; text-align:left">교정주기(년)</td>
					<td style=" font-weight: 900; font-size:14px; text-align:left">교정일자</td>
					<td style=" font-weight: 900; font-size:14px;">개정번호</td>
				</tr>

				<tr style="background-color: #fff;">
		            <td >
		            	<input type="text" data-date-format="yyyy-mm-dd" id="txt_YuhyoDate" class="form-control" style="width: 150px; border: solid 1px #cccccc;"
		            		value="<%=targetSulbiVector.get(10).toString()%>" readonly  />
		            </td>
		            <td> 
		            	<input type="text" data-date-format="yyyy-mm-dd" id="txt_GyojungJugi" class="form-control" style="width: 150px; border: solid 1px #cccccc;"
		            		value="<%=targetSulbiVector.get(11).toString()%>" readonly />
		            </td>		  
		            <td> 
		            	<input type="text" data-date-format="yyyy-mm-dd" id="txt_GyojungDate" class="form-control" style="width: 150px; border: solid 1px #cccccc;"  
		            		value="<%=targetSulbiVector.get(12).toString()%>" readonly />
		            </td>		
		             <td >
		            	<input type="text" class="form-control" id="txt_RevisionNo" value="0" style="width: 200px; float:left" 
       	            		value="<%=revisionNumberStr%>" readonly />
		            </td>        
		        </tr>
		        
		        <tr style="background-color: #fff" >
		            <td style=" font-weight: 900; font-size:14px; text-align:left" colspan="2">주요점검 및 주의사항</td>
		            <td style=" font-weight: 900; font-size:14px; text-align:left" colspan="2">사용방법</td>
		        </tr>
		        <tr>
		            <td colspan="2" rowspan="3">
		            	<ul id="checklists">
		            		<% for(int i=0; i<checklists.length; i++){ %>
		            			<li><%= checklists[i] %></li>
		            		<% } %>
		            	</ul>
		            </td>		           
		            <td colspan="2">
		            	<!-- <textarea class="form-control" id="txt_Bigo"  style="cols:10;rows:4;resize: none;" disabled="disabled"></textarea> -->
		            	<ol id="facilities_usage">
		            		<% for(int i=0; i<facilities_usage.length; i++){ %>
		            			<li><%= facilities_usage[i] %></li>
		            		<% } %>
		            	</ol>
		            </td>
		        </tr>
		        <tr>
		            <td style=" font-weight: 900; font-size:14px; text-align:left" colspan="2">청소방법</td>		           
		        </tr>
		        <tr>
		            <td colspan="2">
		            	<ol id="clean_way">
		            		<% for(int i=0; i<clean_way.length; i++){ %>
		            			<li><%= clean_way[i] %></li>
		            		<% } %>
		            	</ol>
					</td>
		        </tr>
		        
		        <tr style="background-color: #fff" >
		            <td style=" font-weight: 900; font-size:14px; text-align:left" colspan="3">비고</td>
		            <td style=" font-weight: 900; font-size:14px;">적용시작일자</td>
		        </tr>
		        <tr>
		            <td colspan="3"><textarea class="form-control" id="txt_Bigo"  style="cols:10;rows:4;resize: none;" disabled="disabled"><%=targetSulbiVector.get(13).toString() %></textarea></td>
		            <td  colspan="3"> 
		            	<input type="text" data-date-format="yyyy-mm-dd" id="txt_StartDate" class="form-control" style="border: solid 1px #cccccc;"
		            		value="<%=targetSulbiVector.get(16).toString()%>" readonly />
		            </td>		           
		        </tr>     
        	</table>
        </td>
	</tr>
  </table>