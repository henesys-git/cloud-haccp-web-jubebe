<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*,java.util.*,javax.servlet.http.*"%>
<%@ page import="mes.client.comm.*" %>
<%@ page import="mes.client.common.*" %>
<%@ page import="mes.client.guiComponents.*" %>
<%@ page import="mes.client.util.*" %>
<%@ page import="mes.client.conf.*" %>
<%@ page import="org.json.simple.JSONObject"%>
<!DOCTYPE html>

<%
/* 
S202S020161.jsp
이력번호 등록
*/

	String loginID = session.getAttribute("login_id").toString();
	String member_key = session.getAttribute("member_key").toString();
	DoyosaeTableModel TableModel;
	String zhtml = "";

	// tbm_our_company_info 데이터 불러오기 //
	String[] strColumnHeadE105    = {"기관코드","개정번호","기관명","사업자등록번호","전화번호","주소","거래처구분","업태","종목","대표자명","적용시작일자","적용종료일자","create_user_id",
	            		     "create_date","modify_user_id","modify_reason","modify_date","이력제사업장관리번호" } ;
	JSONObject jArrayE105 = new JSONObject();
	jArrayE105.put( "member_key", member_key);
	DoyosaeTableModel TableModelE105 = new DoyosaeTableModel("M909S070100E105", strColumnHeadE105, jArrayE105);
	int RowCountE105 =TableModelE105.getRowCount();
	
	String bizno="";
	String cust_nm="";
	String refno = "";
	String telno = "";
	String address = "";
	String boss_name = "";
	
	if(RowCountE105 < 1){
		bizno="";
		cust_nm="";
		telno = "";
		address = "";
		boss_name = "";
		refno = "";	
	}else{
		cust_nm = TableModelE105.getValueAt(0,2).toString().trim();
		bizno = TableModelE105.getValueAt(0,3).toString().trim();
		telno = TableModelE105.getValueAt(0,4).toString().trim();
		address = TableModelE105.getValueAt(0,5).toString().trim();
		boss_name = TableModelE105.getValueAt(0,10).toString().trim();
		refno = TableModelE105.getValueAt(0,18).toString().trim();
	}
	// 데이터 불러오기 끝
	
	String GV_ORDERNO="",GV_LOTNO="", GV_PART_CD="",GV_PART_NM="",GV_JSPPAGE="", GV_NUM_GUBUN="";

	
	if(request.getParameter("OrderNo")== null)
		GV_ORDERNO="";
	else
		GV_ORDERNO = request.getParameter("OrderNo");

	if(request.getParameter("LotNo")== null)
		GV_LOTNO="";
	else
		GV_LOTNO = request.getParameter("LotNo");
	
	if(request.getParameter("part_cd")== null)
		GV_PART_CD="";
	else
		GV_PART_CD = request.getParameter("part_cd");
	
	if(request.getParameter("part_nm")== null)
		GV_PART_NM="";
	else
		GV_PART_NM = request.getParameter("part_nm");
	
	

	CurrentPage jspPageName = new CurrentPage(request.getRequestURI());
	String JSPpage = jspPageName.GetJSP_FileName();
	ProcesStatusCheck prcStatusCheck = new ProcesStatusCheck(JSPpage+"|"+"ODPROCS"+"|");
	
	
	String GV_PROCESS_MODIFY	= prcStatusCheck.GV_PROCESS_MODIFY;
	String GV_PROCESS_DELETE	= prcStatusCheck.GV_PROCESS_DELETE;
	String GV_GET_NUM_PREFIX = prcStatusCheck.GV_PROCESS_NUMBER_GUBUN;
	
%>
    
	<script type="text/javascript">
//  웹소켓 통신을 위해서 필요한 변수들 ---시작
	var M202S020100E161 = {
			PID:  "M202S020100E161", 
			totalcnt: 0,
			retnValue: 999,
			colcnt: 0,
			colname: ["","","",""], //insert, Update, Delete 문장을 처리할 때는 사용되지않음
			data: []
	};  
	
	var SQL_Param = {
			PID:  "M202S020100E161", 
			excute: "queryProcess",
			stream: "N",
			param: ""
	};
	
    $(document).ready(function () {
    	$('#txt_partcd').val('<%=GV_PART_CD%>');
    	$('#txt_partnm').val('<%=GV_PART_NM%>');
    	
    	$('#txt_partcd_pig').val('<%=GV_PART_CD%>');
    	$('#txt_partnm_pig').val('<%=GV_PART_NM%>');
	
        $('#dateDelevery_cattle').datepicker({
        	format: 'yyyymmdd',
        	autoclose: true,
        	language: 'ko'
        });
        $('#dateDelevery_pig').datepicker({
        	format: 'yyyymmdd',
        	autoclose: true,
        	language: 'ko'
        });

        var today = new Date();
        var fromday = new Date();
        fromday.setDate(today.getDate());

        $('#dateOrder').datepicker('update', fromday);
        $('#dateDelevery_cattle').datepicker('update', today);
        $('#dateDelevery_pig').datepicker('update', today);
        
//     	$('input[type=radio][name=txt_Gubun]').on('click', function(){
    		
//     		var chkValue = $('input[type=radio][name=txt_Gubun]:checked').val;
//     		if(chkValue =='0'){
//     			$('#Cattle').css('display', 'block');
//     			$('#Pig').css('display', 'none');
//     		}else if(chkValue =='1'){
//     			$('#Cattle').css('display', 'none');
//     			$('#Pig').css('display', 'block');
//     		}
//     	});
        
    });	
    
    

    
	function SaveOderInfo_Cattle() {        
		
		var radio_returnyn = $(':input[name="txt_returnyn"]:radio:checked').val();
		var radio_cattlelottype = $(':input[name="txt_cattlelottype"]:radio:checked').val();
		var radio_incorptp = $(':input[name="txt_incorptp"]:radio:checked').val();
		
		if(radio_cattlelottype == "C" && $('#txt_cattleno').val() ==""){
			alert("이력/묶음 구분 중 이력인 경우 이력번호 입력은 필수 입니다.");
			return;
		}
		if(radio_cattlelottype == "L" && $('#txt_lotno').val() ==""){
			alert("이력/묶음 구분 중 묶음인 경우 묶음번호 입력은 필수 입니다.");
			return;
		}
		
        var dataJsonCattle = new Object(); // JSON Object 선언
        dataJsonCattle.Gubun = $('#txt_Gubun_Cattle').val();
        dataJsonCattle.member_key  = '<%=member_key%>';
        dataJsonCattle.refno	= '<%=refno%>'; // 사업장 관리번호 전송측(가공장/판매장에서 관리하는 관리번호)  
        dataJsonCattle.inymd = $('#dateDelevery_cattle').val(); // 입고일자 YYYMMDD 타입의 날짜형식
        dataJsonCattle.returnyn = radio_returnyn; // 반품구분 Y: 반품입고 N:일반매입
        dataJsonCattle.cattlelottype = radio_cattlelottype; // 이력, 묶음 구분 C:이력, L:묶음 구분
        dataJsonCattle.cattleno = $('#txt_cattleno').val(); // 이력번호 cattleLotType이 이력일 경우 필수 
        dataJsonCattle.lotno = $('#txt_lotno').val(); // 묶음번호 cattleLotType이 묶음일 경우 필수
//         dataJsonCattle.partcd = $('#txt_partcd').val(); // 표준부위코드 430xxx : 소부위는 430로 시작 (소의 종류에 따라 표기해햐함)
        dataJsonCattle.partcd = '<%=GV_PART_CD%>'; // 표준부위코드 430xxx : 소부위는 430로 시작 (소의 종류에 따라 표기해햐함)
        dataJsonCattle.partnm = '<%=GV_PART_NM%>'; // 표준부위명 사업장에서 사용하는 부위명(표준부위명과 다를 수 있음)
        dataJsonCattle.inweight = $('#txt_inweight').val(); // 입고중량(kg)
        dataJsonCattle.incorpno = '<%=bizno%>'; // 반출처 사업자등록번호
	    dataJsonCattle.incorpnm = '<%=cust_nm%>'; // 반출처 상호
	    dataJsonCattle.incorpaddr = '<%=address%>'; // 반출처 주소
	    dataJsonCattle.incorptp = radio_incorptp; // 반출처 유형 구분     077001 : 도축장  077010 : 가공장 077020 : 판매장
	    dataJsonCattle.bigo = $('#txt_bigo').val(); // 비고
	    
	    dataJsonCattle.prefix = '<%=GV_GET_NUM_PREFIX%>'; // 비고
	    dataJsonCattle.jsp_page = '<%=JSPpage%>'; // 비고
	    
	    dataJsonCattle.order_no  = '<%=GV_ORDERNO%>';
	    dataJsonCattle.lotno_henesys  = '<%=GV_LOTNO%>';
	    
	    


		SendTojsp(JSON.stringify(dataJsonCattle), SQL_Param.PID); // 보내는 데이터묶음 하나일때 => Object하나만
	}
	function SaveOderInfo_Pig() {   
		
		var radio_parttype = $(':input[name="txt_parttype"]:radio:checked').val();
		var radio_returnyn = $(':input[name="txt_returnyn_pig"]:radio:checked').val();
		var radio_inplacenm = $(':input[name="txt_inplacenm"]:radio:checked').val();
		var radio_intypenm = $(':input[name="txt_intypenm"]:radio:checked').val();
		var radio_piglottype = $(':input[name="txt_piglottype"]:radio:checked').val();
		
		

		if(radio_piglottype == "P" && $('#txt_pigno').val() ==""){
			alert("이력/묶음 구분 중 이력인 경우 이력번호 입력은 필수 입니다.");
			return;
		}
		if(radio_piglottype == "L" && $('#txt_lotno_pig').val() ==""){
			alert("이력/묶음 구분 중 묶음인 경우 묶음번호 입력은 필수 입니다.");
			return;
		}
		if(radio_parttype == "T" && radio_piglottype == "P" && $('#txt_butcheryno').val() ==""){
			alert("지육/정육 구분 중 지육이고 이력/묶음 구분 중 경우 이력인 경우 도체번호 입력은 필수 입니다.");
			return;
		}
		
	    var dataJsonPig = new Object(); // JSON Object 선언
	    dataJsonPig.Gubun = $('#txt_Gubun_Pig').val();
	    dataJsonPig.member_key  = '<%=member_key%>';
	    dataJsonPig.refno = '<%=refno%>';
	    dataJsonPig.parttype = radio_parttype; // 지육/정육 구분 지육:T 정육 :P 기타: E 메인
	    dataJsonPig.returnyn = radio_returnyn; // Y : 반품입고, N:일반매입
	    dataJsonPig.inymd = $('#dateDelevery_pig').val(); // 매입일자 YYYYMMDD 형식이고 현재일 이후 오류 처리
	    dataJsonPig.incorpno  = '<%=bizno%>';
	    dataJsonPig.incorpnm  = '<%=cust_nm%>';
	    dataJsonPig.incorpownernm   = '<%=boss_name%>';
	    dataJsonPig.incorptel = '<%=telno%>';
	    dataJsonPig.incorpaddr  = '<%=address%>';
	    dataJsonPig.inplacenm = radio_inplacenm; // 503010: 도축장,  503020:가공장, 503030:판매장
	    dataJsonPig.intypenm = radio_intypenm; // 511010:자체매입분, 511020:외부매입분
	    dataJsonPig.totweight = $('#txt_totweight').val();
	    dataJsonPig.piglottype = radio_piglottype; // P : 이력, L : 묶음
	    dataJsonPig.lotno = $('#txt_lotno_pig').val();
	    dataJsonPig.pigno = $('#txt_pigno').val();
	    dataJsonPig.butcheryno = $('#txt_butcheryno').val();
	    dataJsonPig.partcd = '<%=GV_PART_CD%>';
	    dataJsonPig.partnm = '<%=GV_PART_NM%>';
	    dataJsonPig.inweight = $('#txt_inweight_pig').val();
	    dataJsonPig.gradecd  = $('#txt_gradecd').val();
	    
	    
	    dataJsonPig.prefix = '<%=GV_GET_NUM_PREFIX%>'; // 비고
	    dataJsonPig.jsp_page = '<%=JSPpage%>'; // 비고
	    
	    dataJsonPig.order_no  = '<%=GV_ORDERNO%>';
	    dataJsonPig.lotno_henesys  = '<%=GV_LOTNO%>';
	    
	    SendTojsp(JSON.stringify(dataJsonPig), SQL_Param.PID); // 보내는 데이터묶음 하나일때 => Object하나만
	}
	function SendTojsp(bomdata, pid){
	    $.ajax({
	         type: "POST",
	         dataType: "json",
	         url: "<%=Config.this_SERVER_path%>/Contents/CommonView/insert_update_delete_json.jsp", 
	         data:  {"bomdata" : bomdata, "pid" : pid },
	         beforeSend: function () {
	         
	         },
	         
	         success: function (html) {	
	        	 if(html>-1){
	        		$('#txt_HistNo').val('');
	        		parent.$("#ReportNote_nd").children().remove();
	         		parent.$('#modalReport_nd').hide();
// 	                parent.$("#ReportNote").children().remove();
// 	         		parent.$('#modalReport').hide();
					alert("이력번호 생성이 완료되었습니다.");
					
	         		parent.DetailInfo_List.click();
	         	}
	         },
	         error: function (xhr, option, error) {

	         }
	     });		
	}      	
	
	function setDisplay(){
	    if($('input:radio[id=txt_Gubun_Cattle]').is(':checked')){
	    	$('#Pig').hide();
	    	$('#Cattle').show();
	    }else if($('input:radio[id=txt_Gubun_Pig]').is(':checked')){
	    	$('#Cattle').hide();
	    	$('#Pig').show();
	    }
	}




    </script>
    <div> 
       	<table class="table table-striped" style="width: 100%; margin: 0 ; align:left ;" id="Gubun">
       		<tr style="background-color: #fff;">
	            <td>구　　분 </td>
	            <td>
            	<input type="radio" id="txt_Gubun_Cattle" name="txt_Gubun"  value="0" onchange="setDisplay()" style="width: 60px;">소고기</input>
        		<input type="radio" id="txt_Gubun_Pig" name="txt_Gubun" value="1" onchange="setDisplay()" style="width: 60px;">돼지고기</input>
        		</td>
	        </tr>
       	</table>
	</div>
	<div style="display: none;" id="Cattle" > 
        	<table class="table table-striped" style="width: 100%; margin: 0 ; align:left ;" id="Cattle">
		        <tr style="background-color: #fff;">
		            <td>입고날짜</td>
		            <td ><input type="text" data-date-format='yyyymmdd' class="form-control" id="dateDelevery_cattle" style="width: 200px; float:left"  /></td>
		        </tr>
		        <tr style="background-color: #fff;">
					<td>반품구분</td>
					<td>
						<input type="radio" id="txt_returnyn" name="txt_returnyn" value="Y" style="width: 60px;">반품입고</input>
        				<input type="radio" id="txt_returnyn" name="txt_returnyn" value="N" checked="checked" style="width: 60px;">일반매입</input>
        			</td>
		        </tr>
		        <tr style="background-color: #fff;">
		            <td>이력/묶음 구분</td>
		            <td>
		            	<input type="radio" id="txt_cattlelottype" name="txt_cattlelottype" value="C" checked="checked" style="width: 60px;">이력</input>
		            	<input type="radio" id="txt_cattlelottype" name="txt_cattlelottype" value="L" style="width: 60px;">묶음</input></td>
		            </tr>
		        <tr>
					<td>이력번호</td>
					<td><input type="text" class="form-control" id="txt_cattleno" style="width: 200px" /></td>
		        </tr>
		        <tr style="background-color: #fff;">
		            <td>묶음번호</td>
		            <td ><input type="text" class="form-control" id="txt_lotno" style="width: 200px; float:left"  /></td>
	            </tr>
	            <tr>
					<td>표준부위코드</td>
					<td><input type="text" class="form-control" id="txt_partcd" style="width: 200px" readonly="readonly" /></td>
		        </tr>
		        <tr style="background-color: #fff;">
		            <td>표준부위명</td>
		            <td ><input type="text" class="form-control" id="txt_partnm" style="width: 200px; float:left" readonly="readonly" /></td>
	            </tr>
	            <tr>
					<td>입고중량(kg)</td>
					<td><input type="text" class="form-control" id="txt_inweight" style="width: 200px" /></td>
		        </tr>
		        <tr style="background-color: #fff;">
		            <td>반출처 유형 구분</td>
		            <td>
		            	<input type="radio" id="txt_incorptp" name="txt_incorptp" value="077001" checked="checked" style="width: 40px;">도축장</input>
		            	<input type="radio" id="txt_incorptp" name="txt_incorptp" value="077010" style="width: 40px;">가공장</input>
		            	<input type="radio" id="txt_incorptp" name="txt_incorptp" value="077020" style="width: 40px;">판매장</input>
		            </td>
		        </tr>
		        <tr>
					<td>비고</td>
					<td><input type="text" class="form-control" id="txt_bigo" style="width: 300px" /></td>
		        </tr>
	       
		        
	        	<tr style="vertical-align: middle">
	        		<td colspan="4" style="font-weight: 900; font-size:14px; text-align:center; vertical-align: middle">
				        <p style="text-align:center;">
				        	<button id="btn_Save"  class="btn btn-info"  onclick="SaveOderInfo_Cattle();" 
				        			style="font-weight: 900; font-size:18px;width:130px;height:60px;">저장</button>
<!--							parent.$('#modalReport').hide(); 1차 팝업 닫기-->
<!-- 					        parent.$('#modalReport_nd').hide(); 2차 팝업 닫기-->
					        <button id="btn_Canc"  class="btn btn-info"  onclick="parent.$('#modalReport_nd').hide();" 
					        		style="font-weight: 900; font-size:18px;width:130px;height:60px;;margin-left:30px;">취소</button>
				        </p>
        			</td>
	        	</tr>
        	</table>
		</div> 
		
		<div style="display: none;" id="Pig" > 
        	<table class="table table-striped" style="width: 100%; margin: 0 ; align:left ;" id="big">
        	
		        <tr style="background-color: #fff;">
		            <td>지육/정육 구분</td>
		            <td>
			            <input type="radio" id="txt_parttype" name="txt_parttype" value="T" checked="checked" style="width: 60px;">지육</input>
	        			<input type="radio" id="txt_parttype" name="txt_parttype" value="P" style="width: 60px;">정육</input>
	        			<input type="radio" id="txt_parttype" name="txt_parttype" value="E" style="width: 60px;">기타</input>
        			</td>
		        </tr>
		        <tr style="background-color: #fff;">
					<td>반품구분</td>
					<td>
						<input type="radio" id="txt_returnyn_pig" name="txt_returnyn_pig"  value="Y" style="width: 60px;">반품입고</input>
	        			<input type="radio" id="txt_returnyn_pig" name="txt_returnyn_pig" value="N" checked="checked" style="width: 60px;">일반매입</input>
        			</td>
		        </tr>
		        <tr style="background-color: #fff;">
		            <td>매입날짜</td>
		            <td ><input type="text" data-date-format='yyyymmdd' class="form-control" id="dateDelevery_pig" style="width: 200px; float:left"  /></td>
		        </tr>
		        <tr style="background-color: #fff;">
		            <td>반출처 유형 구분</td>
		            <td>
			            <input type="radio" id="txt_inplacenm" name="txt_inplacenm" value="503010" checked="checked" style="width: 60px;">도축장</input>
			            <input type="radio" id="txt_inplacenm" name="txt_inplacenm" value="503020" style="width: 60px;">가공장</input>
			            <input type="radio" id="txt_inplacenm" name="txt_inplacenm" value="503030" style="width: 60px;">판매장</input>
		            </td>
		        </tr>
      		    <tr style="background-color: #fff;">
		            <td>매입 구분</td>
		            <td>
			            <input type="radio" id="txt_intypenm" name="txt_intypenm" value="511010" checked="checked" style="width: 60px;">자체매입분</input>
			            <input type="radio" id="txt_intypenm" name="txt_intypenm" value="511020" style="width: 60px;">외부매입분</input>
		            </td>
		        </tr>
	            <tr>
					<td>총중량</td>
					<td><input type="text" class="form-control" id="txt_totweight" style="width: 200px" /></td>
		        </tr>
		        <tr style="background-color: #fff;">
		            <td>이력/묶음 구분</td>
		            <td>
			            <input type="radio" id="txt_piglottype" name="txt_piglottype" value="P" checked="checked" style="width: 60px;">이력</input>
			            <input type="radio" id="txt_piglottype" name="txt_piglottype" value="L" style="width: 60px;">묶음</input>
		            </td>
		        </tr>
		        <tr>
					<td>이력번호</td>
					<td><input type="text" class="form-control" id="txt_pigno" style="width: 200px" /></td>
		        </tr>
		        <tr style="background-color: #fff;">
		            <td>묶음번호</td>
		            <td ><input type="text" class="form-control" id="txt_lotno_pig" style="width: 200px; float:left"  /></td>
	            </tr>
	            <tr style="background-color: #fff;">
		            <td>도체번호</td>
		            <td ><input type="text" class="form-control" id="txt_butcheryno" style="width: 200px; float:left"  /></td>
	            </tr>
	            <tr>
					<td>부위코드</td>
					<td><input type="text" class="form-control" id="txt_partcd_pig" style="width: 200px" readonly="readonly" /></td>
		        </tr>
		        <tr style="background-color: #fff;">
		            <td>부위명</td>
		            <td ><input type="text" class="form-control" id="txt_partnm_pig" style="width: 200px; float:left" readonly="readonly" /></td>
	            </tr>
	            <tr>
					<td>중량</td>
					<td><input type="text" class="form-control" id="txt_inweight_pig" style="width: 200px" /></td>
		        </tr>
		        <tr style="background-color: #fff;">
		            <td>등급</td>
		            <td ><input type="text" class="form-control" id="txt_gradecd" style="width: 200px; float:left"  /></td>
	            </tr>
	       
		        
	        	<tr style="vertical-align: middle">
	        		<td colspan="4" style="font-weight: 900; font-size:14px; text-align:center; vertical-align: middle">
				        <p style="text-align:center;">
				        	<button id="btn_Save"  class="btn btn-info"  onclick="SaveOderInfo_Pig();" 
				        			style="font-weight: 900; font-size:18px;width:130px;height:60px;">저장</button>
<!-- 					        parent.$('#modalReport').hide(); 1차 팝업 닫기-->
<!-- 					        parent.$('#modalReport_nd').hide(); 2차 팝업 닫기-->
					        <button id="btn_Canc"  class="btn btn-info"  onclick="parent.$('#modalReport_nd').hide();" 
					        		style="font-weight: 900; font-size:18px;width:130px;height:60px;;margin-left:30px;">취소</button>
				        </p>
        			</td>
	        	</tr>
        	</table>
		</div> 

	