<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*,java.util.*,javax.servlet.http.*"%>
<%@ page import="mes.client.comm.*" %>
<%@ page import="mes.client.common.*" %>
<%@ page import="mes.client.guiComponents.*" %>
<%@ page import="mes.client.util.*" %>
<%@ page import="mes.client.conf.*" %>
<%  	
	String member_key = session.getAttribute("member_key").toString();
	String GV_CALLER="", GV_CHECK_GUBUN = "";
	
	if(request.getParameter("caller")== null)
		GV_CALLER="0";
	else
		GV_CALLER = request.getParameter("caller");	
	
	if(request.getParameter("check_gubun")== null)
		GV_CHECK_GUBUN = "";
	else
		GV_CHECK_GUBUN = request.getParameter("check_gubun");
	
	Vector optCode =  null;
    Vector optName =  null;
    
    Vector partgubun_bigVector = PartListComboData.getPartBigGubunDataAll(member_key);
    Vector partgubun_midVector = PartListComboData.getPartMidGubunDataAll("",member_key);

%>

 <script type="text/javascript">
 	var vPart_gubun_b="";
	var vPart_gubun_m="";
	var vPart_gubun_s="";
	var vgyugyeok ="";
	var vPart_level="";
	var vPartCd		= "";
	var vRevisionNo = "";
	var vPartCode = "";
	
	var vPart_cd_alt = "";
	var vPart_nm_alt = "";
	var vPartgubun_big="";
	var vPartgubun_mid="";
	var vPartgubun_sm="";

	
$(document).ready(function () {        
		caller = "<%=GV_CALLER%>";
		
    	
    	
<%-- 		fn_MainSubMenuSelect("<%=sMenuTitle%>"); --%>
// 		$("#tablePartView_pop_body").html("원자재코드정보");
        
        fn_PartCode_List();
	    
	    $("#partgubun_big").on("change", function(){
	    	vPartgubun_big = $(this).val();
	    	
	    	if(vPartgubun_big=="ALL") vPartgubun_big="";
	    
	    	 $.ajax(
    		        {
    		            type: "POST",
    		            url: "<%=Config.this_SERVER_path%>/Contents/Business/M909/S909S110200.jsp",
    		            data: "partgubun_big="+ vPartgubun_big ,
    		            success: function (html) {
    		                $("#partgubun_mid > option").remove();
    		                var changMidResult = html.split("|");
    		                for(var i=0; i<changMidResult.length; i++) {
    		                	var value = changMidResult[i].split(",")[0]
    		                	var name  = changMidResult[i].split(",")[1].trim();
	    		                $("#partgubun_mid").append("<option value="+value+">"+name+"</option>");
    		                	
    		                }
    		                if($("#partgubun_big").val()=="ALL") {
    		                	$("#partgubun_mid").prepend("<option value='ALL'>전체</option>"); 
    		                	$("#partgubun_mid > option:eq(0)").prop("selected",true);
    		                }
    		                vPartgubun_mid=$("#partgubun_mid >option:eq(0)").val();
					    	fn_PartCode_List();
    		            },
    		            error: function (xhr, option, error) {

    		            }
    		        });
	    	

	    });

	    $("#partgubun_mid").on("change", function(){
	    	vPartgubun_big = $("#partgubun_big").val();
	    	vPartgubun_mid = $(this).val();    	
	    	if($("#partgubun_mid").val()=="ALL") {
	    		fn_PartCode_List();
	    		return;
	    	}
	    	
	    	fn_PartCode_List();

	    }); 
	    
	    
		$('#tablePartView_pop tbody').on('click', 'tr', function () {
			part_selected_row = selectTable_Part.row(this).index();

			$($("input[id='checkbox1']")[part_selected_row]).prop("checked", function(){
		        return !$(this).prop('checked');
		    });

			var td = $(this).children();
			
			var txt_part_cd 			= td.eq(4).text().trim(); 
			var txt_part_revision_no 	= td.eq(5).text().trim();
			var txt_part_name 			= td.eq(6).text().trim();
			var txt_gyugeok 			= td.eq(2).text().trim();
			var txt_part_level 			= td.eq(3).text().trim();
			var txt_unit_price 			= td.eq(7).text().trim();
			var txt_part_gubun_b		= td.eq(15).text().trim();
			var txt_part_gubun_m		= td.eq(16).text().trim();
			
			if(caller == "0") { //일반 화면에서 부를 때
		 		$("#txt_part_name", parent.document).val(txt_part_name);
		 		$("#txt_part_revision_no", parent.document).val(txt_part_revision_no);
		 		$("#txt_part_cd", parent.document).val(txt_part_cd);
		 		$("#txt_gyugeok", parent.document).val(txt_gyugeok);
		 		$("#txt_part_level", parent.document).val(txt_part_level);
		 		$("#txt_unit_price", parent.document).val(txt_unit_price);
		 		$("#txt_part_gubun_b", parent.document).val(txt_part_gubun_b);
		 		$("#txt_part_gubun_m", parent.document).val(txt_part_gubun_m);
			}
			else if(caller == 1) { //레이어팝업(Iframe에서 다른 Iframe으로 값을 보낼때 상대방 Iframe의 Function을 사용)에서부를 때
	 			console.log('hi');
				parent.SetpartName_code(txt_part_name, txt_part_cd,txt_part_revision_no,txt_gyugeok,txt_unit_price);
			}

			parent.$('#modalReport_nd').hide(); // modalReport2로 완전 교체되면 없앨 예정
			
		} );
        

		$('#tablePartView_pop tbody').on( 'blur', 'tr', function () {
			selectTable_Part.row( this ).attr("class", "hene-bg-color_w");
		} );
	    	    
    });

    
    //원자재등록정보
    function fn_PartCode_List() {
    	
		if(vPartgubun_big=="ALL")
			vPartgubun_big="";
		if(vPartgubun_mid=="ALL")
			vPartgubun_mid="";
    	
        $.ajax(
        {
            type: "POST",
            url: "<%=Config.this_SERVER_path%>/Contents/CommonView/PartCodeView_tyens.jsp",
            data: "partgubun_big="+ vPartgubun_big +  "&partgubun_mid="+ vPartgubun_mid + "&caller=" + "<%=GV_CALLER%>" + "&check_gubun=" + "<%=GV_CHECK_GUBUN%>", 
            beforeSend: function () {
                $("#tablePartView_pop_body").children().remove();
            },
            success: function (html) {
                $("#tablePartView_pop_body").hide().html(html).fadeIn(100);
            },
            error: function (xhr, option, error) {

            }
        });
        
      
    }
    
    </script>

            
 <div class="panel panel-default" style="margin-left:5px; margin-top:5px; margin-right:5px; margin-bottom:5px; width:100%">
        <!-- Default panel contents -->
        <div class="panel-body">
            
            <p style="height:5px ;clear:both; margin-bottom:3px;">
            </p>
            <div class="panel panel-default">
                <!-- Default panel contents -->
<!--                 <div class="panel-heading" style="font-size:16px; font-weight: bold" id="InfoContentTitle">원자재코드정보</div> -->
                <div style="float: left">
					<table style="width: 100%; text-align:left; background-color:#f5f5f5;">
						<tr>
							<td style='width:21%; vertical-align: middle'>원자재 대분류</td>
							<td style='width:26%;vertical-align: middle'>
								<select class="form-control" id="partgubun_big" style="width: 120px">
									<%	optCode =  (Vector)partgubun_bigVector.get(0);%>
									<%	optName =  (Vector)partgubun_bigVector.get(1);%>
									<%for(int i=0; i<optName.size();i++){ %>
										<option value='<%=optCode.get(i).toString()%>'><%=optName.get(i).toString()%></option>
									<%} %>
								</select>
<!-- 								<input type="hidden" class="form-control" id="txt_partgubun_big" style="width: 75%; float:left" readonly="readonly" /> -->
							</td>
							                       
						<td style='width:22%; vertical-align: middle'>원자재 중분류</td>
							<td style='width:26%;vertical-align: middle'>
								<select class="form-control" id="partgubun_mid" style="width: 120px">
									<%	optCode =  (Vector)partgubun_midVector.get(0);%>
									<%	optName =  (Vector)partgubun_midVector.get(1);%>
									<%for(int i=0; i<optName.size();i++){ %>
										<option value='<%=optCode.get(i).toString()%>'><%=optName.get(i).toString()%></option>
									<%} %>
								</select>
<!-- 								<input type="hidden" class="form-control" id="txt_partgubun_mid" style="width: 75%; float:left" readonly="readonly" /> -->
							</td>                          
						</tr>
					</table>
				</div>
                <div class="panel-body">
                    <div style="clear:both" id="tablePartView_pop_body" >
                    </div>
 
                </div>
            	</div>
            </div>
        </div>
