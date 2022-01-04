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

<%
	String loginID = session.getAttribute("login_id").toString();
	String member_key = session.getAttribute("member_key").toString();

	DoyosaeTableModel TableModel;
	String zhtml = "";
    Vector optCode =  null;
    Vector optName =  null;
    Vector optValue = null;
    Vector codeGroupVector = null;
    
	String[] strColumnHead = {"공통코드그룹", "공통코드", "공통코드명", "개정번호", "비고"} ;

	String GV_PART_CODE="";
	String GV_CODE_GROUP="";
	String GV_PART_GUBUN_B="", GV_PART_GUBUN_M="", GV_PARENT_VAL="", GV_CURRENT_GUBUN="";
	
	if(request.getParameter("part_code")== null)
		GV_PART_CODE="";
	else
		GV_PART_CODE = request.getParameter("part_code");
	
	if(request.getParameter("parent_val")== null)
		GV_PARENT_VAL="";
	else
		GV_PARENT_VAL = request.getParameter("parent_val");
	
	if(request.getParameter("current_gubun")== null)
		GV_CURRENT_GUBUN="";
	else
		GV_CURRENT_GUBUN = request.getParameter("current_gubun");	
	System.out.println(GV_PART_CODE);
	if(GV_PART_CODE.equals("PRDGB")) codeGroupVector = CommonData.getPartCodeGroupBigDataAll();
	else if(GV_PART_CODE.equals("PRDGM")) codeGroupVector = CommonData.getPartCodeGroupMidDataAll();
	/* else if(GV_PART_CODE.equals("PRDGS")) codeGroupVector = CommonData.getPartCodeGroupSmDataAll(); */
	
	Vector partgubun_bigVector = PartListComboData.getPartBigGubunDataAll(member_key);
	Vector partgubun_midVector = PartListComboData.getPartMidGubunDataAll("",member_key);
	
	String GV_TODAY = Common.getSystemTime("date");
	
	CurrentPage jspPageName = new CurrentPage(request.getRequestURI());	
	String JSPpage = jspPageName.GetJSP_FileName();
%>
 
        
    <script type="text/javascript">

	
	function SaveOderInfo1() {
		
		var WebSockData="";
		var search_code_value="";
		var page="";
   		var dataJson = new Object(); // jSON Object 선언 
   			dataJson.member_key = "<%=member_key%>";
			dataJson.CodeGroupGubun = $("#select_CodeGroupGubun").val();
			dataJson.PartGubun = $('#txt_CodeValue').val();
            dataJson.CodeName = $('#txt_CodeName').val();
            dataJson.RevisionNo = $('#txt_RevisionNo').val();
            dataJson.StartDate1 = $('#txt_StartDate1').val();
            dataJson.user_id = "<%=loginID%>";


                
                 	search_code_value = $('#txt_CodeValue').val();
               
                	
                

                $.ajax({
         	         type: "POST",
         	         url: "<%=Config.this_SERVER_path%>/Contents/Business/M909/S909S110104.jsp", 
         	         data:  "Page=<%=JSPpage%>"+"&CodeGroupGubun=" + $("#select_CodeGroupGubun").val() + "&CodeValue=" + search_code_value,	         
         	         success: function (html) {
         	        	 if(html > 0) {
         	        		 	alert("이미 등록되어 있습니다.");
         	        		 	return true;
         	        		 } else {
         	        			var chekrtn = confirm("등록하시겠습니까?"); 
         	       				
         	       				if(chekrtn){
         	           				SendTojsp(JSON.stringify(dataJson), "M909S110100E201"); // 보내는 데이터묶음 하나일때 => Object하나만
         	       				}
         	        		 }
         	        		      			 
         	         }
         	     });    
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
	        		heneSwal.successTimer('코드등록에 성공하였습니다.');
	        		//$("li.active").trigger('click');
	        		$('#modalReport2').modal('hide');
	        		//$('#modalReport').modal('hide');
	        		parent.$("#insert").trigger('click');
	        		//parent.pop_fn_CodeCd_Insert();
	         	}
	        	 else{
	        		 heneSwal.error('코드등록에 실패하였습니다.');
	        	 }
	         },
	         error: function (xhr, option, error) {

	         }
	     });	 
	    
	}
	
    
    $(document).ready(function () {
		
    	new SetSingleDate2("", "#txt_StartDate1",0);
        
    	<%-- //$("#big_partgubun").val('<%=GV_PART_CODE%>').prop("selected",true); --%>
    	
    	
        //fn_PartGubun_Select();
        
	    $("#select_CodeGroupGubun").on("change", function(){
	    	groupCodeGubun = $(this).val();
	    });
	    
	    
	    if($("#big_partgubun").val()=="ALL" || $("#mid_partgubun").val()=="ALL") {
	    	$("#big_partgubun,#mid_partgubun").removeAttr("disabled");
	    }
    });

// 	$("#big_partgubun").change(function(){
		
    <%-- function fn_PartGubun_Select() {    
    	console.log($("#big_partgubun").val() + " : "+ $("#mid_partgubun").val());    
    	var vPart_gubun = $("#big_partgubun").val();
    	console.log(vPart_gubun);
		$.ajax(
        {
            type: "POST",
            url: "<%=Config.this_SERVER_path%>/Contents/Business/M909/S909S110210.jsp", 
            data: "part_gubun=" + vPart_gubun,
            beforeSend: function () {
//             	$("#txt_CodeValue").parent().children().remove();            
            },
            success: function (html) {
            	$("#txt_CodeValue").parent().hide().html(html.trim()).fadeIn(100);
            },
            error: function (xhr, option, error) {
            }
        });	    
	} --%>

    </script>
</head>
<body>
<!--    <table class="table table-hover" style="width: 100%; margin: 0 auto; align:left"> -->
<!-- <form id="mesfrm"> -->
   <table class="table table-hover" style="width: 100%; margin: 0 auto; align:left">

        
        <tr style="height: 40px; display:none">
            <td>코드구분</td>
            <td></td>
            <td>
	            <input id="select_CodeGroupGubun" value=<%=GV_PART_CODE%>></input>
            </td>
        </tr>
        
        <% if(GV_PART_CODE.equals("PRDGM")) {%>
         			
	        <tr style="height: 40px">
	            <td>관련대분류선택</td>
	            <td></td>
	            <td>
	            	<!-- <select class="form-control" id="big_partgubun" style="width: 140px" disabled="disabled" onchange="fn_PartGubun_Select()"> -->
	            	<select class="form-control" id="big_partgubun" style="width: 140px" disabled="disabled">
						<%	optCode =  (Vector)partgubun_bigVector.get(0);%>
						<%	optName =  (Vector)partgubun_bigVector.get(1);%>
						<%for(int i=0; i<optName.size();i++){ %>
						  <%if (optCode.get(i).equals(GV_PARENT_VAL)) {%>
							<option value='<%=optCode.get(i).toString()%>' selected="selected" ><%=optName.get(i).toString()%></option>
						  <%} else{%>
							<option value='<%=optCode.get(i).toString()%>'><%=optName.get(i).toString()%></option>
						  <%} %>
						<%}%>
					</select>			
	            </td>
	        </tr>
         
       <%} %>
        
        <tr style="background-color: #fff; height: 40px">
            <td><%=GV_CURRENT_GUBUN%>코드</td>
            <td> </td>
            <td ><input type="text" class="form-control" id="txt_CodeValue"  style="width: 200px; float:left" />
           	</td>
        </tr> 

        <tr style="background-color: #fff; height: 40px">
            <td><%=GV_CURRENT_GUBUN%>명</td>
            <td> </td>
            <td ><input type="text" class="form-control" id="txt_CodeName" style="width: 200px; float:left"  />
				<!-- <input type="hidden" class="form-control" id="txt_custcode" style="width: 120px" /> -->
           	</td>
        </tr>
        
       
        
        <tr style="background-color: #fff; height: 40px">
            <td>적용시작일자</td>
            <td> </td>
            <td>
            	<input type="text" data-date-format="yyyy-mm-dd" id="txt_StartDate1" class="form-control"
                	style="width: 220px; border: solid 1px #cccccc;"/>
            		
           	</td>
        </tr>
        

        <tr style="height: 60px">
            <td colspan="4" align="center">
                <p>
                	<button id="btn_Save2"  class="btn btn-info" style="width: 100px" onclick="SaveOderInfo1();">저장</button>
                    <button id="btn_Canc2"  class="btn btn-info" style="width: 100px" onclick="$('#modalReport2').modal('hide');">취소</button>
                </p>
            </td>
        </tr>
    </table>
<!-- </form>     -->
</body>
</html>