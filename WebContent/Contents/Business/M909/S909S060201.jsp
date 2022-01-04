<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*,java.util.*,javax.servlet.http.*"%>
<%@ page import="mes.client.comm.*" %>
<%@ page import="mes.client.common.*" %>
<%@ page import="mes.client.guiComponents.*" %>
<%@ page import="mes.client.util.*" %>
<%@ page import="mes.client.conf.*" %>
<%@ page import="org.json.simple.*"%><%@ include file="/strings.jsp" %>
<!-- 
제품 중분류 등록 yumsam
-->
<%
	String loginID = session.getAttribute("login_id").toString();
	String member_key = session.getAttribute("member_key").toString();

	DoyosaeTableModel TableModel;
	String zhtml = "";
    Vector optCode =  null;
    Vector optName =  null;
    Vector optValue = null;
    Vector codeGroupVector = null;
    
	String GV_PRODUCT_CODE = "", 
		   GV_PARENT_VAL = "", 
		   GV_CURRENT_GUBUN = "", 
		   GV_PRODUCT_GUBUN_BIG = "", 
		   GV_MID_GUBUN_CHECK = "";
	
	if(request.getParameter("product_code") != null)
		GV_PRODUCT_CODE = request.getParameter("product_code");

	if(request.getParameter("parent_val") != null)
		GV_PARENT_VAL = request.getParameter("parent_val");

	if(request.getParameter("current_gubun") != null)
		GV_CURRENT_GUBUN = request.getParameter("current_gubun");
	
	if(GV_PRODUCT_CODE.equals("PRDGB")) {
		codeGroupVector = CommonData.getPartCodeGroupBigDataAll();
	} else if(GV_PRODUCT_CODE.equals("PRDGM")) {
		codeGroupVector = CommonData.getPartCodeGroupMidDataAll();
	}
	
	Vector Product_Big_Gubun_Vector = CommonData.getProductBigGubun(true, member_key);
	Vector Product_Mid_Gubun_Vector = CommonData.getProductMidGubun(GV_PRODUCT_GUBUN_BIG, true, member_key);
	
	String GUBUN_CODE_MAX = "";
	
	JSONObject jArray = new JSONObject();
	jArray.put("member_key", member_key);
	if( GV_CURRENT_GUBUN.equals("대분류") ) {
		GUBUN_CODE_MAX = (String)CommonData.getProductBigGubunCodeMaxNumber(jArray).get(0);
	}
	
	if( GV_CURRENT_GUBUN.equals("중분류") ) {
		jArray.put( "Big_Gubun", GV_PARENT_VAL);
		GUBUN_CODE_MAX = (String)CommonData.getProductMidGubunCodeMaxNumber(jArray).get(0);
	}
%>
 
<script>

$(document).ready(function () {
	
	function SaveOderInfo() {
		var gubun = "";

		<%if(GV_CURRENT_GUBUN.equals("대분류")) {%>
			gubun = "PRODB";
		<%}else if(GV_CURRENT_GUBUN.equals("중분류")) {%>
			gubun = "PRODM";
		<%}%>
		
   		var dataJson = new Object();       
            dataJson.code_cd = gubun;
			dataJson.code_value = $('#txt_CodeValue').val();
            dataJson.code_name = $('#txt_CodeName').val();
            dataJson.order_index = $('#txt_CodeValue').val();
            dataJson.create_user_id = "<%=loginID%>"
			dataJson.member_key = "<%=member_key%>";
			
		if ($('#txt_CodeName').val() == ""){
			alert('제품 분류명을 입력하세요.');
			return false;
		}
		
		var JSONparam = JSON.stringify(dataJson);
		var chekrtn = confirm("등록하시겠습니까?"); 
		
		if(chekrtn) {
			SendTojsp(JSONparam, "M909S060100E1001");
		}
	}
 
	function SendTojsp(bomdata, pid){
		
	     $.ajax({
	         type: "POST",
	         dataType: "json",
	         url: "<%=Config.this_SERVER_path%>/Contents/CommonView/insert_update_delete_json.jsp", 
	         data: "bomdata=" + bomdata + "&pid=" + pid,
	         success: function (html) {
	        	 if(html>-1){
	        		parent.$("#insert").trigger('click');
	        		$("li.active").trigger('click');
	         		parent.$('#modalReport_nd').hide();
	         	}
	         }
	     });	 
	}
	
	// 제품코드 글자 수 제한(숫자 4자리)
	$("#txt_CodeValue").keyup(function () {
		var TEXT_MAX_SIZE = 2;
		
		var ProductCode_Text = $("#txt_CodeValue").val();
		var ProductCode_Text_Size = 0;
		
		ProductCode_Text_Size = Byte_Check(ProductCode_Text);
		
		if( ProductCode_Text_Size > TEXT_MAX_SIZE )
		{
			alert("최대 " + TEXT_MAX_SIZE + " 자리 숫자까지 입력 가능합니다.");
			
			$("#txt_CodeValue").val(ProductCode_Text.substring(0,TEXT_MAX_SIZE));
		}
	});
});
</script>

	<table class="table table-hover">
		<tr style="display:none">
		    <td>코드 구분</td>
		    <td></td>
		    <td>
				<input id="select_CodeGroupGubun" value=<%=GV_PRODUCT_CODE%>>
		    </td>
		</tr>
        
        <% if(GV_PRODUCT_CODE.equals("PRDGM")) {%>
	        <tr>
	            <td>관련 대분류</td>
	            <td></td>
	            <td>
	            	<select class="form-control" id="txt_ProductGubunBig" disabled="disabled">
						<% optCode = (Vector)Product_Big_Gubun_Vector.get(0);%>
						<% optName = (Vector)Product_Big_Gubun_Vector.get(1);%>
						<%for(int i=0; i<optName.size();i++){ %>
						  <%if (optCode.get(i).equals(GV_PARENT_VAL)) {%>
							<option value='<%=optCode.get(i).toString()%>' selected="selected"><%=optName.get(i).toString()%></option>
						  <%} else{%>
							<option value='<%=optCode.get(i).toString()%>'><%=optName.get(i).toString()%></option>
						  <%} %>
						<%}%>
					</select>
	            </td>
	        </tr>
       	<%}%>
        
        <tr>
            <td>제품<%=GV_CURRENT_GUBUN%>코드</td>
            <td></td>
            <td>
            	<input type="text" class="form-control" id="txt_CodeValue" value='<%=GUBUN_CODE_MAX%>' readonly>
           	</td>
        </tr>

        <tr>
            <td>제품<%=GV_CURRENT_GUBUN%>명</td>
            <td></td>
            <td>
            	<input type="text" class="form-control" id="txt_CodeName">
           	</td>
        </tr>
    </table>