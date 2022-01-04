<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*,java.util.*,javax.servlet.http.*"%>
<%@ page import="mes.client.comm.*" %>
<%@ page import="mes.client.common.*" %>
<%@ page import="mes.client.guiComponents.*" %>
<%@ page import="mes.client.util.*" %>
<%@ page import="mes.client.conf.*" %>

<!DOCTYPE html>

<%
	String loginID = session.getAttribute("login_id").toString();
	String member_key = session.getAttribute("member_key").toString();

	String zhtml = "";
	Vector optCode =  null;
	Vector optName =  null;
	Vector sulbiGroupVector = CommonData.getSulbiGroupDataAll(member_key);

	String  GV_JSPPAGE="",GV_NUM_GUBUN;
	String GV_SULBI_GROUP="";
	StringBuffer html = new StringBuffer();

	if(request.getParameter("jspPage")== null)
		GV_JSPPAGE="";
	else
		GV_JSPPAGE = request.getParameter("jspPage");

	if(request.getParameter("num_gubun")== null)
		GV_NUM_GUBUN="";
	else
		GV_NUM_GUBUN = request.getParameter("num_gubun");
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
    
	var vSelect_SulbiGubun = "";
    
//     웹소켓 통신을 위해서 필요한 변수들 ---시작
	var M909S050100E101 = {
			PID:  "M909S050100E101", 
			totalcnt: 0,
			retnValue: 999,
			colcnt: 0,
			colname: ["","","",""], //insert, Update, Delete 문장을 처리할 때는 사용되지않음
			data: []
	};  
	
	var SQL_Param = {
			PID:  "M909S050100E101", 
			excute: "queryProcess",
			stream: "N",
			param: ""
	};
	var GV_RECV_DATA = "";	//웹소켓 onMessage(event)들어온 데이터를 받는 변수
//  웹소켓 통신을 위해서 필요한 변수들 ---끝	

    var aExt=[];
	var number = 001;
    $(document).ready(function () {
    	
        new SetSingleDate2("", "#txt_StartDate", 0);
        new SetSingleDate2("", "#txt_DoipDate", 0);
        new SetSingleDate2("", "#txt_YuhyoDate", 0);

        var today = new Date();
        var fromday = new Date();
        fromday.setDate(today.getDate());
        
        $('#txt_SulbiCode').val(function(){
	    	
	    	vSelect_SulbiGubun = $("#select_SulbiGubun option:selected").val(); 
	    	
	    	$.ajax ({
	    			type: "POST",
		            url: "<%=Config.this_SERVER_path%>/Contents/Business/M909/S909S050200.jsp",
		            data: "select_SulbiGubun="+ vSelect_SulbiGubun,
		            success: function (maxValue) {
		            	$('#txt_SulbiCode').val($("#select_SulbiGubun option:selected").val() + "-" + maxValue);
		            },
		            error: function (xhr, option, error) {

		            }
		        });
	    });
        
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
	  			$('#alertNote').html("설비정보등록(S909S050101)!!! <BR><BR> 설비코드를 입력하신 후 이미지 Upload하십니다  !!!!!");
	   			$('#modalalert').show();
	   			return;
	    	}	    		
	    }); 
	    
	    $("#select_SulbiGubun").on("change",function(){
	    	
	    	vSelect_SulbiGubun = $("#select_SulbiGubun option:selected").val(); 
	    	
	    	$.ajax ({
	    			type: "POST",
		            url: "<%=Config.this_SERVER_path%>/Contents/Business/M909/S909S050200.jsp",
		            data: "select_SulbiGubun="+ vSelect_SulbiGubun,
		            success: function (maxValue) {
		            	$('#txt_SulbiCode').val($("#select_SulbiGubun option:selected").val() + "-" + maxValue);
		            },
		            error: function (xhr, option, error) {

		            }
		        });
	    });
	    	
	    $("#SulbiImage").on('change',function(){ 
	    	if($('#txt_SulbiCode').val().length<3){
	  			$('#alertNote').html("설비정보등록(S909S050101)!!! <BR><BR> 설비코드를 입력하신 후 이미지 Upload하십니다  !!!!!");
	   			$('#modalalert').show();
	   			return;
	    	}
	    	
	        var form = $('#form1S909S050101')[0];
	        var data = new FormData(form);

	        data.append("SulbiCode", 	$('#txt_SulbiCode').val());
	        var sext = $('#SulbiImage').val();
	        aExt = sext.split(".");
	        data.append("ext", 	aExt[1] );
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
							var canvas = document.getElementById('SulbiImageFile');
							var context = canvas.getContext('2d');
							var imgSrc = "<%=Config.this_SERVER_path%>/images/SULBI/" + $('#txt_SulbiCode').val() 
										+ "." +aExt[1] + "?v=" + Math.random();
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
	    	        },
	    	        error: function (e) {
	                    console.log("ERROR : ", e);
	    	        }
	    	     });	
	    	}
	    });
	    
    });
	
	function SetRecvData(){
		DataPars(M909S050100E101,GV_RECV_DATA);  	
 		if(M909S050100E101.retnValue > 0)
 			alert('등록 되었습니다.');
   		
   		parent.fn_MainInfo_List();
 		parent.$('#modalReport').hide();
 		number += 1;
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
			dataJson.SulbiCode_aExt = $('#txt_SulbiCode').val() + "." +aExt[1];
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
			dataJson.user_id =  "<%=loginID%>";
			dataJson.SulbiGubun = $("#select_SulbiGubun option:selected").val();

			// 설비 점검항목
			dataJson.checklists = checklists.slice(0,-1);
			dataJson.facilities_usage = facilities_usage.slice(0,-1);
			dataJson.clean_way = clean_way.slice(0,-1);
			
			var chekrtn = confirm("등록하시겠습니까?"); 
			
			if(chekrtn){        
		    	SendTojsp(JSON.stringify(dataJson), SQL_Param.PID); // 보내는 데이터묶음 하나일때 => Object하나만
	    		
// 				SendTojsp(urlencode(params), SQL_Param.PID);
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
	        		heneSwal.success('설비정보 등록에 성공하였습니다.');
	        	   	parent.fn_MainInfo_List();
	                parent.$("#ReportNote").children().remove();
	                $('#modalReport').modal('hide');
	         	}
	        	 else{
	        		heneSwal.error('설비정보 등록에 실패하였습니다.');
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
		            	<!-- <img src="../../images/SULBI/MasterPlan.jpg" width="400" height="300"></img>  -->
		            	<canvas id="SulbiImageFile" width="400" height="300" style="border:1px solid #d3d3d3;" ></canvas>		            	
		            </td>
		        </tr>
		        <tr style="background-color: #fff;">
		            <td style="width: 100%; font-weight: 900; font-size:14px; text-align:left">
		            <form id="form1S909S050101" method="post" enctype="multipart/form-data" action="<%=Config.this_SERVER_path%>/Contents/ImageFileUpload/ImageFileUpload.jsp">
						<input  type="file" id='SulbiImage' name="filename"  style="width:70%;float: left"/>
					</form>
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
						<input type="text" class="form-control" id="txt_SulbiCode" name='SulbiCode' style="width: 150px; float:left" readonly="readonly"/>
						<input type="hidden" class="form-control" id="txt_ext" name='ext' style="width: 150px; float:left"  />
		           	</td>
		            <td style=" font-weight: 900; font-size:14px; text-align:left">
						<input type="text" class="form-control" id="txt_SulbiName" style="float:left"  />
		           	</td>
		           	<td>
						<select class="form-control" id="select_SulbiGubun" style="width: 150px">
			            	<%	optCode =  (Vector)sulbiGroupVector.get(0);%>
			                <%	optName =  (Vector)sulbiGroupVector.get(1);%>
			                <%for(int i=1; i<optName.size();i++){ %>
								<option value='<%=optCode.get(i).toString()%>' 
									<%=GV_SULBI_GROUP.equals(optCode.get(i).toString()) ? "selected" : "" %> >
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
		            <td><input type="text" data-date-format="yyyy-mm-dd" id="txt_DoipDate" class="form-control" style="width: 150px; border: solid 1px #cccccc;"/></td>
		            <td><input type="text" data-date-format="yyyy-mm-dd" id="txt_GyuGyuk" class="form-control" style="width: 150px; border: solid 1px #cccccc;"/></td>		        
		        	<td><input type="text"  id="txt_Maker" class="form-control" style="width: 150px; border: solid 1px #cccccc; vertical-align: middle;"/></td>
		        	<td><input type="text"  id="txt_GigiBunho" class="form-control" style="border: solid 1px #cccccc; vertical-align: middle;"/></td>        
		        </tr>

				<tr>
				 	<td style=" font-weight: 900; font-size:14px; text-align:left">담당부서</td>	
					<td style=" font-weight: 900; font-size:14px; text-align:left">사용담당자</td>
					<td style="font-weight: 900; font-size:14px; text-align:left">책임담당자</td>
					<td style=" font-weight: 900; font-size:14px; text-align:left">교정담당자</td>
				</tr>
		
		        <tr style="background-color: #fff; ">
		            <td><input type="text"  id="txt_UseDept" class="form-control" style="width: 150px; border: solid 1px #cccccc; vertical-align: middle;"/></td>
		        	<td><input type="text"  id="txt_UseDamdangJa" class="form-control" style="border: solid 1px #cccccc; vertical-align: middle;"/></td>		           
		        	<td><input type="text"  id="txt_CheckimDamdangJa" class="form-control" style="width: 150px; border: solid 1px #cccccc; vertical-align: middle;"/></td>
		        	<td><input type="text"  id="txt_GyojungDamdangJa" class="form-control" style="border: solid 1px #cccccc; vertical-align: middle;"/></td>		       
		        </tr>

				<tr>
					<td style=" font-weight: 900; font-size:14px; text-align:left">유효일자</td>
					<td style=" font-weight: 900; font-size:14px; text-align:left">교정주기(년)</td>
					<td style=" font-weight: 900; font-size:14px; text-align:left">교정일자</td>
					<td style=" font-weight: 900; font-size:14px;">개정번호</td>
				</tr>

				<tr style="background-color: #fff;">
		            <td><input type="text" data-date-format="yyyy-mm-dd" id="txt_YuhyoDate" class="form-control" style="width: 150px; border: solid 1px #cccccc;"/></td>
		            <td><input type="text" data-date-format="yyyy-mm-dd" id="txt_GyojungJugi" class="form-control" style="width: 150px; border: solid 1px #cccccc;"/></td>
		            <td><input type="text" data-date-format="yyyy-mm-dd" id="txt_GyojungDate" class="form-control" style="width: 150px; border: solid 1px #cccccc;" readonly /></td>		        
		            <td><input type="text" class="form-control" id="txt_RevisionNo" value="0" style="width: 200px; float:left" readonly /></td>
        		</tr>
		        
		        <tr style="background-color: #fff" >
		            <td style=" font-weight: 900; font-size:14px; text-align:left" colspan="2">주요점검 및 주의사항</td>
		            <td style=" font-weight: 900; font-size:14px; text-align:left" colspan="2">사용방법</td>
		        </tr>
		        <tr>
		            <td colspan="2" rowspan="3">
		            	<ul id="checklists">
		            		<% for(int i=0; i<8; i++){ %>
		            			<li>
		            				<input type = "text" value = "" id = "checklists_<%=i%>"/>
		            			</li>
		            		<%	} %>
		            	</ul>
		            </td>		           
		            <td colspan="2">
		            	<!-- <textarea class="form-control" id="txt_Bigo"  style="cols:10;rows:4;resize: none;" disabled="disabled"></textarea> -->
		            	<ol id="facilities_usage">
		            		<% for(int i=0; i<6; i++){ %>
		            			<li>
		            				<input type = "text" value = "" id = "facilities_usage_<%=i%>"/>
		            			</li>
		            		<%	} %>
		            	</ol>
		            </td>
		        </tr>
		        <tr>
		            <td style=" font-weight: 900; font-size:14px; text-align:left" colspan="2">청소방법</td>		           
		        </tr>
		        <tr>
		            <td colspan="2">
		            	<ol id="clean_way">
		            		<% for(int i=0; i<6; i++){ %>
		            			<li>
		            				<input type = "text" value = "" id = "clean_way_<%=i%>"/>
		            			</li>
		            		<%	} %>
		            	</ol>
					</td>
		        </tr>
		        
		        <tr style="background-color: #fff" >
		            <td style=" font-weight: 900; font-size:14px; text-align:left" colspan="3">비고</td>
		            <td style=" font-weight: 900; font-size:14px;">적용시작일자</td>
		        </tr>
		        <tr>
		            <td colspan="3"><textarea class="form-control" id="txt_Bigo"  style="cols:10;rows:4;resize: none;" disabled="disabled"></textarea></td>
		            <td><input type="text" data-date-format="yyyy-mm-dd" id="txt_StartDate" class="form-control" style="border: solid 1px #cccccc;"/> </td>        				           
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