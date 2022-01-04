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
	
	DoyosaeTableModel TableModel;
	String zhtml = "";
	Vector optCode =  null;
	Vector optName =  null;
	Vector sulbiGroupVector = CommonData.getSulbiGroupDataAll(member_key);

	String[] strColumnHead = {"seolbi_cd", "seolbi_nm", "doip_date", 
							 "gugyuk", "seolbi_maker"} ;
		
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
	int ColCount =TableModel.getColumnCount();
	CurrentPage jspPageName = new CurrentPage(request.getRequestURI());
	String JSPpage = jspPageName.GetJSP_FileName();
	
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
}

#width100 ul li{
	margin-bottom: 5px;
} 

#width100 ol li{
	margin-bottom: 1px;
} 
</style>
    
    <script type="text/javascript">
//     웹소켓 통신을 위해서 필요한 변수들 ---시작
	var M909S050100E102 = {
			PID:  "M909S050100E102", 
			totalcnt: 0,
			retnValue: 999,
			colcnt: 0,
			colname: ["","","",""], //insert, Update, Delete 문장을 처리할 때는 사용되지않음
			data: []
	};  
	
	var SQL_Param = {
			PID:  "M909S050100E102", 
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
    	
    	new SetSingleDate2("", "#txt_StartDate", 0);
        new SetSingleDate2("", "#txt_DoipDate", 0);
        new SetSingleDate2("", "#txt_YuhyoDate", 0);
        
        $('#txt_DoipDate').val("<%=targetSulbiVector.get(2).toString()%>");
        $('#txt_StartDate').val("<%=targetSulbiVector.get(16).toString()%>");
        $('#txt_YuhyoDate').val("<%=targetSulbiVector.get(10).toString()%>");
        
        var today = new Date();
        var fromday = new Date();
        fromday.setDate(today.getDate());
		
        Date.prototype.format = function(f) {
            if (!this.valueOf()) return " ";
         
            var weekName = ["일요일", "월요일", "화요일", "수요일", "목요일", "금요일", "토요일"];
            var d = this;
             
            return f.replace(/(yyyy|yy|MM|dd|E|hh|mm|ss|a\/p)/gi, function($1) {
                switch ($1) {
                    case "yyyy": return d.getFullYear();
                    case "yy": return (d.getFullYear() % 1000).zf(2);
                    case "MM": return (d.getMonth() + 1).zf(2);
                    case "dd": return d.getDate().zf(2);
                    case "E": return weekName[d.getDay()];
                    case "HH": return d.getHours().zf(2);
                    case "hh": return ((h = d.getHours() % 12) ? h : 12).zf(2);
                    case "mm": return d.getMinutes().zf(2);
                    case "ss": return d.getSeconds().zf(2);
                    case "a/p": return d.getHours() < 12 ? "오전" : "오후";
                    default: return $1;
                }
            });
        };
         
        String.prototype.string = function(len){var s = '', i = 0; while (i++ < len) { s += this; } return s;};
        String.prototype.zf = function(len){return "0".string(len - this.length) + this;};
        Number.prototype.zf = function(len){return this.toString().zf(len);};
		
	    // 하나 입력 시 동시에 계산해서... 입력되게 한다.
	    $("#txt_GyojungJugi").keyup(function(){
	        var jugi = $('#txt_GyojungJugi').val();
			var gyojungDay = new Date(Date.parse(today) + Number(jugi) * 365 * 1000 * 60 * 60 * 24);
	        $('#txt_GyojungDate').val(gyojungDay.format("yyyy-MM-dd"));
	    });

	    $("#SulbiImage").click(function(){ 
	    	if($('#txt_SulbiCode').val().length<3){
	  			$('#alertNote').html("설비정보수정(S909S050102)!!! <BR><BR> 설비코드를 입력하신 후 이미지 Upload하십니다  !!!!!");
	   			$('#modalalert').show();
	   			return;
	    	}	    		
	    }); 
	    
	    vImageFileName = "<%=targetSulbiVector.get(14).toString()%>";
	    Set_image_File(vImageFileName);
	    
	    
	    $("#SulbiImage").on('change',function(){ 
	    	if($('#txt_SulbiCode').val().length<3){
	  			$('#alertNote').html("설비정보수정(S909S050102)!!! <BR><BR> 설비코드를 입력하신 후 이미지 Upload하십니다  !!!!!");
	   			$('#modalalert').show();
	   			return;
	    	}
	    	
	        var form = $('#form1S909S050102')[0];
	        var data = new FormData(form);

	        data.append("SulbiCode", 	$('#txt_SulbiCode').val());
// 	        alert($('#SulbiImage').val());
	        var sext = $('#SulbiImage').val();
	        aExt = sext.split(".");
	        data.append("ext", 	aExt[1] );
// 	        alert(aExt[1]);
	        if(aExt[1]!='jpg' && aExt[1]!='JPG' && aExt[1]!='JPEG' && aExt[1]!='jpeg' && aExt[1]!='png' && aExt[1]!='PNG'  && aExt[1]!='gif'){
	    		alert("등록할 이미지 파일을 선택하세요-!!");
	    		return;
	        }
	        if($('#SulbiImage').val().length<1  ){
	    		alert("등록할 이미지 파일을 선택하세요-!!");
	    		return;
	    	}
	    	else{

	    	    $.ajax({
					type: "POST",
	    	        enctype: "multipart/form-data",
	    	        url: "<%=Config.this_SERVER_path%>/Contents/ImageFileUpload/ImageFileUpload.jsp" , 
	    	        data: data,
	    	        processData: false,
	    	        contentType: false,
					cache: false,
	    	        timeout: 600000,	    	            
	    	        beforeSend: function () {
	    	        },	    	         
	    	        success: function (html) {
						if(html.length>0){
							vImageFileName = $('#txt_SulbiCode').val() + "." +aExt[1];
							Set_image_File(vImageFileName);
// 							var images;
// 							var canvas = document.getElementById('SulbiImageFile');
// 							var context = canvas.getContext('2d');
<%-- 							loadImages("<%=Config.this_SERVER_path%>/images/SULBI/" + $('#txt_SulbiCode').val() + "." +aExt[1], context); --%>
							
// 							function loadImages(ImgPage1, context) {
// 								  var images;
// 								  images = new Image();
// 								  images.onload = function() {
// 									  context.drawImage(this,0 , 0,400,300);  //캔버스에 이미지 디스플레이
// 								  };
// 								  images.onerror = function () {
// 								  };
// 								  images.src = ImgPage1;
// 							} 
		                }
	    	        },
	    	        error: function (e) {
	                    console.log("ERROR : ", e);
	    	        }
	    	     });	
	    	}
	    });
	    
    });
	
    function Set_image_File( imageFile){
		var canvas = document.getElementById('SulbiImageFile');
		var context = canvas.getContext('2d');
		var imgSrc = "<%=Config.this_SERVER_path%>/images/SULBI/"
					+ imageFile + "?v=" + Math.random();
		loadImages(imgSrc, context);
		
		function loadImages(ImgPage1, context) {
			  var images;
			  images = new Image();
			  images.onload = function() {
				  context.clearRect(0, 0, 400, 300);
				  context.drawImage(this,0 , 0,400,300);  //캔버스에 이미지 디스플레이
			  };
			  images.onerror = function () {
			  };
			  images.src = ImgPage1;
		} 
    }
    
	function SetRecvData(){
		DataPars(M909S050100E102,GV_RECV_DATA);  	
 		if(M909S050100E102.retnValue > 0)
 			alert('수정 되었습니다.');
   		
   		parent.fn_MainInfo_List();
 		parent.$('#modalReport').hide();
	}
	
	function SaveOderInfo() {        
		var WebSockData="";
		
		var checklists = "";
		$("#checklists li").each(function() {
			
			var strVal = $(this).children("input").val();
			
			if(strVal != null && strVal.trim() != ""){
				checklists += $(this).children("input").val() + "/";
			}
			
		});
		
		var facilities_usage = "";
		$("#facilities_usage li").each(function() {
			
			var strVal = $(this).children("input").val();
			
			if(strVal != null && strVal.trim() != ""){
				facilities_usage += $(this).children("input").val() + "/";
			}
			
		});
		
		var clean_way = "";
		$("#clean_way li").each(function() {
			
			var strVal = $(this).children("input").val();
			
			if(strVal != null && strVal.trim() != ""){
				clean_way += $(this).children("input").val() + "/";
			}
			
		});

		var dataJson = new Object(); // jSON Object 선언 
			dataJson.member_key = "<%=member_key%>";
			dataJson.SulbiCode = $('#txt_SulbiCode').val();
			dataJson.RevisionNo = $('#txt_RevisionNo').val();
			dataJson.ImageFileName = vImageFileName;
			dataJson.DoipDate = $('#txt_DoipDate').val();
			dataJson.SulbiName = $('#txt_SulbiName').val();
			dataJson.GyuGyuk = $('#txt_GyuGyuk').val();
			dataJson.Maker = $('#txt_Maker').val();
			dataJson.GigiBunho = $('#txt_GigiBunho').val();
			dataJson.YuhyoDate = $('#txt_YuhyoDate').val();
			dataJson.GyojungJugi = $('#txt_GyojungJugi').val();
			dataJson.GyojungDate = $('#txt_GyojungDate').val(); 
			dataJson.UseDamdangJa = $('#txt_UseDamdangJa').val();
			dataJson.CheckimDamdangJa = $('#txt_CheckimDamdangJa').val();
			dataJson.UseDept = $('#txt_UseDept').val(); 
			dataJson.GyojungDamdangJa = $('#txt_GyojungDamdangJa').val(); 
			dataJson.Bigo = $('#txt_Bigo').val();
			dataJson.StartDate = $('#txt_StartDate').val();
			dataJson.user_id = "<%=loginID%>";
			dataJson.SulbiGubun = $("#select_SulbiGubun option:selected").val();
			dataJson.RevisionNo_Target = "<%=targetSulbiVector.get(1).toString() %>";
			
			// 설비 점검항목
			dataJson.checklists = checklists.slice(0,-1);
			dataJson.facilities_usage = facilities_usage.slice(0,-1);
			dataJson.clean_way = clean_way.slice(0,-1);
			
			var chekrtn = confirm("수정하시겠습니까?"); 
			
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
	        		 heneSwal.success('설비정보 수정에 성공하였습니다.');
	        	   	parent.fn_MainInfo_List();
	                parent.$("#ReportNote").children().remove();
	                $('#modalReport').modal('hide');
	         	}
	        	 else{
	        		 heneSwal.error('설비정보 수정에 실패하였습니다.');
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
		            <form id="form1S909S050102" method="post" enctype="multipart/form-data" action="<%=Config.this_SERVER_path%>/Contents/ImageFileUpload/ImageFileUpload.jsp">
						<input  type="file" id='SulbiImage' name="filename"  value="<%=targetSulbiVector.get(14).toString().trim()%> style="width:70%;float: left"/>
					</form>
					
		           	</td>
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
		            		value="<%=targetSulbiVector.get(1).toString()%>"/>
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
		            		value="<%=targetSulbiVector.get(2).toString()%>"/>
		            </td>
		            <td > 
		            	<input type="text" data-date-format="yyyy-mm-dd" id="txt_GyuGyuk" class="form-control" style="width: 150px; border: solid 1px #cccccc;"
		            		value="<%=targetSulbiVector.get(3).toString()%>"/>
		            </td>	
		            <td> 
		            	<input type="text"  id="txt_Maker" class="form-control" style="width: 150px; border: solid 1px #cccccc; vertical-align: middle;"
		            		value="<%=targetSulbiVector.get(4).toString()%>"/>
		            </td>
		            <td> 
		            	<input type="text"  id="txt_GigiBunho" class="form-control" style="width: 150px; border: solid 1px #cccccc; vertical-align: middle;"
		            		value="<%=targetSulbiVector.get(5).toString()%>"/>
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
		            		value="<%=targetSulbiVector.get(6).toString()%>"/>
		            </td>		            
		            <td> 
		            	<input type="text"  id="txt_UseDamdangJa" class="form-control" style="width: 150px; border: solid 1px #cccccc; vertical-align: middle;"
		            		value="<%=targetSulbiVector.get(7).toString()%>"/>
		            </td>		 
		            <td><input type="text"  id="txt_CheckimDamdangJa" class="form-control" style="width: 150px; border: solid 1px #cccccc; vertical-align: middle;"
		            		value="<%=targetSulbiVector.get(8).toString()%>"/>
		            </td>
		            <td> 
		            	<input type="text"  id="txt_GyojungDamdangJa" class="form-control" style="width: 150px; border: solid 1px #cccccc; vertical-align: middle;"
		            		value="<%=targetSulbiVector.get(9).toString()%>"/>
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
		            		value="<%=targetSulbiVector.get(10).toString()%>"/>
		            </td>
		            <td> 
		            	<input type="text" data-date-format="yyyy-mm-dd" id="txt_GyojungJugi" class="form-control" style="width: 150px; border: solid 1px #cccccc;"
		            		value="<%=targetSulbiVector.get(11).toString()%>"/>
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
	            			<% if(checklists.length > 0 && !checklists[0].equals("")){
		            		
	            				for(int i=0; i<checklists.length; i++){ %>
		            			<li>
		            				<input type = "text" value = "<%= checklists[i] %>" id = "checklist_<%=i%>"/>
		            			</li>
		            		<% } %>
		            		<li>
		            			<input type = "text" id = "checklist_<%=checklists.length%>"/>
	            			</li>
		            			
		            		<% } else {
		            			
		            			for(int i=0; i<8; i++){ %>
		            			<li>
		            				<input type = "text" value = "" id = "checklist_<%=i%>"/>
		            			</li>
		            		<%	}
		            		} %>
		            	</ul>
		            </td>		           
		            <td colspan="2">
		            	<!-- <textarea class="form-control" id="txt_Bigo"  style="cols:10;rows:4;resize: none;" disabled="disabled"></textarea> -->
		            	<ol id="facilities_usage">
		            		<% if(facilities_usage.length > 0 && !facilities_usage[0].equals("")){
		            		
		            			for(int i=0; i<facilities_usage.length; i++){ %>
		            			<li>
		            				<input type = "text" value = "<%= facilities_usage[i] %>" id = "facilities_usage_<%=i%>"/>
		            			</li>
		            		<% } %>
		            		<li>
		            			<input type = "text" id = "facilities_usage_<%=facilities_usage.length%>"/>
	            			</li>
		            			
		            		<% } else {
		            			
		            			for(int i=0; i<6; i++){ %>
		            			<li>
		            				<input type = "text" value = "" id = "facilities_usage_<%=i%>"/>
		            			</li>
		            		<%	}
		            		} %>
		            	</ol>
		            </td>
		        </tr>
		        <tr>
		            <td style=" font-weight: 900; font-size:14px; text-align:left" colspan="2">청소방법</td>		           
		        </tr>
		        <tr>
		            <td colspan="2">
		            	<ol id="clean_way">
	            			<% if(clean_way.length > 0 && !clean_way[0].equals("")){
		            		
	            				for(int i=0; i<clean_way.length; i++){ %>
		            			<li>
		            				<input type = "text" value = "<%= clean_way[i] %>" id = "clean_way_<%=i%>"/>
		            			</li>
		            		<% } %>
		            		<li>
		            			<input type = "text" id = "clean_way_<%=clean_way.length%>"/>
	            			</li>
		            			
		            		<% } else {
		            			
		            			for(int i=0; i<6; i++){ %>
		            			<li>
		            				<input type = "text" value = "" id = "clean_way_<%=i%>"/>
		            			</li>
		            		<%	}
		            		} %>
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
            	<button id="btn_Save"  class="btn btn-info" style="width: 100px" onclick="SaveOderInfo();">저장</button>
                <button id="btn_Canc"  class="btn btn-info" style="width: 100px" onclick="$('#modalReport').modal('hide');">취소</button>
            </p>
        </td>
    </tr>
  </table>
<!-- </form>  -->