<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*,java.util.*,javax.servlet.http.*"%>
<%@ page import="mes.client.comm.*" %>
<%@ page import="mes.client.common.*" %>
<%@ page import="mes.client.guiComponents.*" %>
<%@ page import="mes.client.util.*" %>
<%@ page import="mes.client.conf.*" %>
<%@ page import="org.json.simple.*"%><%@ include file="/strings.jsp" %>
<!DOCTYPE html>
<!-- <html xmlns="http://www.w3.org/1999/xhtml"> -->
<!-- <head id="Head1" > -->
<%
	String loginID = session.getAttribute("login_id").toString();
	String member_key = session.getAttribute("member_key").toString();
	
	DoyosaeTableModel TableModel;
	String zhtml = "";
	Vector optCode =  null;
	Vector optName =  null;
	Vector sulbiGroupVector = CommonData.getSulbiGroupDataAll(member_key);

	String[] strColumnHead = {"", "", "", "", ""} ;
		
	String  GV_SULBI_CODE="",GV_REVISION_NO="";
	String GV_SULBI_GROUP="";

	if(request.getParameter("seolbi_cd")== null)
		GV_SULBI_CODE="";
	else
		GV_SULBI_CODE = request.getParameter("seolbi_cd");

	if(request.getParameter("RevisionNo")== null)
		GV_REVISION_NO="";
	else
		GV_REVISION_NO = request.getParameter("RevisionNo");
	
	String param = GV_SULBI_CODE + "|" + GV_REVISION_NO + "|";
	
	JSONObject jArray = new JSONObject();
	jArray.put( "member_key", member_key);
	jArray.put( "SULBI_CODE", GV_SULBI_CODE);
	jArray.put( "REVISION_NO", GV_REVISION_NO);

	TableModel = new DoyosaeTableModel("M909S050100E204", strColumnHead, jArray);
	int ColCount =TableModel.getColumnCount();CurrentPage jspPageName = new CurrentPage(request.getRequestURI());String JSPpage = jspPageName.GetJSP_FileName();
	
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
    
	// 캐시 비적용
	<%-- <%
	response.setHeader("Cache-Control","no-cache");
	response.setHeader("Pragma","no-cache");
	response.setDateHeader("Expires",0);
	%> --%>
    
//     웹소켓 통신을 위해서 필요한 변수들 ---시작
	var M909S050100E103 = {
			PID:  "M909S050100E103", 
			totalcnt: 0,
			retnValue: 999,
			colcnt: 0,
			colname: ["","","",""], //insert, Update, Delete 문장을 처리할 때는 사용되지않음
			data: []
	};  
	
	var SQL_Param = {
			PID:  "M909S050100E103", 
			excute: "queryProcess",
			stream: "N",
			param: ""
	};
	var GV_RECV_DATA = "";	//웹소켓 onMessage(event)들어온 데이터를 받는 변수
//  웹소켓 통신을 위해서 필요한 변수들 ---끝	
    var detail_seq=1;
    var aExt=[];
    var vImageFileName="";
    
    $(document).ready(function () {
    	detail_seq=1;
    	
        $("#txt_StartDate").datepicker({
        	format: 'yyyy-mm-dd',
        	autoclose: true,
        	language: 'ko'
        });        
        $("#txt_DoipDate").datepicker({
        	format: 'yyyy-mm-dd',
        	autoclose: true,
        	language: 'ko'
        });        
        $("#txt_YuhyoDate").datepicker({
        	format: 'yyyy-mm-dd',
        	autoclose: true,
        	language: 'ko'
        });
        
        new SetSingleDate2("", "#txt_StartDate", 0);
        new SetSingleDate2("", "#txt_DoipDate", 0);
        new SetSingleDate2("", "#txt_YuhyoDate", 0);
        
        $('#txt_DoipDate').val("<%=targetSulbiVector.get(2).toString()%>");
        $('#txt_StartDate').val("<%=targetSulbiVector.get(16).toString()%>");
        $('#txt_YuhyoDate').val("<%=targetSulbiVector.get(10).toString()%>");
        
        var today = new Date();
        var fromday = new Date();
        fromday.setDate(today.getDate());

//         $("#select_status option:eq(1)").prop("selected", true);
//         $($("select[id='select_status']")[1]).prop("selected", true);

// 	    $("#select_status").on("change", function(){
// 	    	WORK_STATUS = $(this).val();
// 	    });

	    // 하나 입력 시 동시에 계산해서... 입력되게 한다.
	    $("#txt_GyojungJugi").keyup(function(){
	        var jugi = $('#txt_GyojungJugi').val();
			var gyojungDay = new Date(Date.parse(today) + Number(jugi) * 365 * 1000 * 60 * 60 * 24);
	        $('#txt_GyojungDate').val(gyojungDay.format("yyyy-MM-dd"));
	    });

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
			  var images;
			  images = new Image();
			  images.onload = function() {
				  context.drawImage(this,0 , 0,400,300);  //캔버스에 이미지 디스플레이
			  };
			  images.onerror = function () {
			  };
			  images.src = ImgPage1;
		} 
    }
    
	function SetRecvData(){
		if (confirm("정말 삭제하시겠습니까?") != true) {
			return;
		}
		DataPars(M909S050100E103,GV_RECV_DATA);  	
 		if(M909S050100E103.retnValue > 0)
 			alert('삭제 되었습니다.');
   		
   		parent.fn_MainInfo_List();
 		parent.$('#modalReport').hide();
	}
	
	function SaveOderInfo() {        
		var WebSockData="";

		var dataJson = new Object(); // jSON Object 선언 
			dataJson.member_key = "<%=member_key%>";
			dataJson.SulbiCode = $('#txt_SulbiCode').val();
			dataJson.RevisionNo = $('#txt_RevisionNo').val();
			var chekrtn = confirm("삭제하시겠습니까?"); 
			
			if(chekrtn){
			
				SendTojsp(JSON.stringify(dataJson), SQL_Param.PID); // 보내는 데이터묶음 하나일때 => Object하나만
// 	        	SendTojsp(urlencode(params), SQL_Param.PID);
			}
	}

	function SendTojsp(bomdata, pid){
		
	    $.ajax({
	         type: "POST",
	         dataType: "json", // Ajax로 json타입으로 보낸다.
	         url: "<%=Config.this_SERVER_path%>/Contents/CommonView/insert_update_delete_json.jsp", 
	         data:  "bomdata=" + bomdata + "&pid=" + pid,
	         beforeSend: function () {
//	         	 alert(bomdata);
	         },
	         
	         success: function (html) {	 
	        	 if(html>-1){
	        		heneSwal.success('설비정보 삭제에 성공하였습니다.');
	        	   	parent.fn_MainInfo_List();
	                parent.$("#ReportNote").children().remove();
	                $('#modalReport').modal('hide');
	         	}
	        	 else{
	        		heneSwal.error('설비정보 삭제에 실패하였습니다.'); 
	        	 }
	         },
	         error: function (xhr, option, error) {

	         }
	     });		
	}  
	   
    function fn_CommonPopupModal(sUrl, name, w, h) { // url, name, width, height, 기타 속성(생략해도 무방)     	
        var popupWin = window.showModalDialog(sUrl, name, 'dialogWidth:' + w + 'px; dialogHeight:' + h 
                + 'px; center:yes; help:no; status:no; resizable:no; scroll:yes; toolbar :no;');
    	if(typeof(popupWin)=="undefine")
    		popupWin = window.returnValue;
		return popupWin;
    }  
    
    function SetCustName_code(name, code, rev){
    	alert(code);
		$('#txt_custname').val(name);
		$('#txt_custcode').val(code);
		$('#txt_cust_rev').val(rev);

    	alert(code);
		
    }
    
    function SetCustProjectInfo(cust_cd, cust_nm, project_name, cust_pono, prod_cd, product_nm, cust_rev, projrctCnt){
		$('#txt_projrctName').val(project_name);
		$('#txt_custname').val(cust_nm);
		$('#txt_projrctCnt').val(projrctCnt);
		
		$('#txt_custcode').val(cust_cd);
		$('#txt_cust_rev').val(cust_rev);
		$('#txt_cust_poNo').val(cust_pono);
		
    }
    
    function SetProductName_code(name, code, rev){

    	var len = $("#product_tbody tr").length-1;		
		var trInput = $($("#product_tbody tr")[len]).find(":input")
		trInput.eq(1).val(name);
		trInput.eq(3).val(code);
		trInput.eq(4).val(rev);
    }
    </script>
<!--     캐시 비적용 -->
    <meta http-equiv="Cache-Control" content="no-cache"/>
	<meta http-equiv="Expires" content="0"/>
	<meta http-equiv="Pragma" content="no-cache"/>
<!-- <form name="form1S909S050101" method="post" enctype="multipart/form-data" action="">  -->
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
		            <td style="width: 100%; font-weight: 900; font-size:14px; text-align:left">
<!-- 						<input name="txt_SulbiImageFilename" type="file"  -->
<%-- 		            		value="<%=targetSulbiVector.get(2).toString()%>" readonly /> --%>
		           	</td>
		        </tr>
		        
		        <tr style="vertical-align: middle">
		            <td style="width: 60px; font-weight: 900; font-size:14px; text-align:center; vertical-align: middle" colspan="2">
		            <!-- 
   						<button type="button" onclick="pop_fn_SulbiImageFileSave()" id="btn_ImageFileSave" class="btn btn-info" style="float:middle">
						   이미지파일저장</button> 
					-->
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
	
    <tr style="height: 60px">
        <td align="center" colspan="2">
            <p>
            	<button id="btn_Save"  class="btn btn-info" style="width: 100px" onclick="SaveOderInfo();">삭제</button>
                <button id="btn_Canc"  class="btn btn-info" style="width: 100px" onclick="$('#modalReport').modal('hide');">취소</button>
            </p>
        </td>
    </tr>
  </table>
<!-- </form>  -->