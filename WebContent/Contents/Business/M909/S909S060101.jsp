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
	
	String  GV_PRODUCT_GUBUN_BIG = "";
	String  GV_PRODUCT_GUBUN_MID = "";

	Vector optCodeBig2 = null;
    Vector optNameBig2 = null;
    
    Vector optCodeMid2 = null;
    Vector optNameMid2 = null;
    
    Vector optCodeUnit2 = null;
    Vector optNameUnit2 = null;
	
	Vector Product_Big_Gubun_Vector2 = CommonData.getProductBigGubun(true, member_key);
	Vector Product_Mid_Gubun_Vector2 = CommonData.getProductMidGubun(GV_PRODUCT_GUBUN_BIG, true, member_key);
	Vector Product_Unit_Gubun_Vector2 = CommonData.getUnitGubun(member_key);
%>

<form id="formId">
   <table class="table table-hover">
        <tr>
        	<td colspan="4">* 대분류를 선택하셔야 중분류 선택이 활성화됩니다</td>
        </tr>
        
        <tr>
            <td>
            	제품대분류
            </td>
            <td>
            </td>
            <td>
				<select class="form-control" id="prod_gubun_b" name="prod_gubun_b">
					<%optCodeBig2 = (Vector)Product_Big_Gubun_Vector2.get(0);%>
					<%optNameBig2 = (Vector)Product_Big_Gubun_Vector2.get(1);%>
					<%for(int i=0; i<optNameBig2.size();i++){ %>
						<option value='<%=optCodeBig2.get(i).toString()%>'><%=optNameBig2.get(i).toString()%></option>
						<%} %>
				</select>
           	</td>
           	<td>
           		<!-- <button id="PRDGB" class="btn btn-info" onclick="registerProdCd(this,'대분류');">
           			등록
           		</button> -->
			</td>
		</tr>

		<tr>
            <td>
            	제품중분류
            </td>
            <td>
            </td>
            <td>
				<select class="form-control" id="prod_gubun_m" name="prod_gubun_m">
					<%optCodeMid2 = (Vector)Product_Mid_Gubun_Vector2.get(0);%>
					<%optNameMid2 = (Vector)Product_Mid_Gubun_Vector2.get(1);%>
					<%for(int i=0; i<optNameMid2.size();i++){ %>
						<option value='<%=optCodeMid2.get(i).toString()%>'>
							<%=optNameMid2.get(i).toString()%>
						</option>
					<%} %>
				</select>
           	</td>
           	<td>
           		<!-- <button id="PRDGM" class="btn btn-info" 
           				onclick="registerProdCd(this,'중분류');">
           			등록
           		</button> -->
			</td>
        </tr>
        
        <tr>
            <td>
            	제품코드
            </td>
            <td>
            </td>
            <td>
            	<input type="text" class="form-control" id="prod_cd" name="prod_cd" placeholder="ex) 1171">
           	</td>
        </tr>
        
        <tr>
            <td>
            	제품코드2
            </td>
            <td>
            </td>
            <td>
            	<input type="text" class="form-control" id="prod_sub_cd" name="prod_sub_cd" placeholder="ex) 111696">
           	</td>
        </tr>

        <tr>
            <td>
            	제품명
            </td>
            <td>
            </td>
            <td>
            	<input type="text" class="form-control" id="product_nm" name="product_nm">
           	</td>
        </tr>
        
        <tr>
            <td>
            	제품 개당 중량
            </td>
            <td>
            </td>
            <td>
            	<input type="text" class="form-control" placeholder="단위도 함께 입력해주세요 ex) 2kg" id="gugyuk" name="gugyuk">
            	<!-- <div class="input-group">
			      <input type="number" class="form-control" placeholder="kg 단위로 입력해주세요" id="gugyuk" name="gugyuk">
			      <div class="input-group-append">
			        <span class="input-group-text">kg</span>
			      </div>
			    </div> -->
           	</td>
        </tr>
        
        <tr>
            <td>
            	팩당 낱개 수량
            </td>
            <td>
            </td>
            <td>
            	<div class="input-group">
			      <input type="number" class="form-control" id="count_in_pack" name="count_in_pack">
			      <div class="input-group-append">
			        <span class="input-group-text">개</span>
			      </div>
			    </div>
           	</td>
        </tr>
        
        <tr>
            <td>
            	박스당 팩 수량
            </td>
            <td>
            </td>
            <td>
            	<div class="input-group">
			      <input type="number" class="form-control" id="count_in_box" name="count_in_box">
			      <div class="input-group-append">
			        <span class="input-group-text">팩</span>
			      </div>
			    </div>
           	</td>
        </tr>
        
        <tr>
            <td>
            	안전재고
            </td>
            <td>
            </td>
            <td>
            	<div class="input-group">
			      <input type="number" class="form-control" placeholder="낱개 기준으로 입력해주세요" id="safe_stock" name="safe_stock">
			      <div class="input-group-append">
			        <span class="input-group-text">개</span>
			      </div>
			    </div>
           	</td>
        </tr>
        
        <tr>
            <td>
            	포장 비용
            </td>
            <td>
            </td>
            <td>
            	<div class="input-group">
			      <input type="number" class="form-control" id="packing_cost" name="packing_cost">
			      <div class="input-group-append">
			        <span class="input-group-text">원</span>
			      </div>
			    </div>
           	</td>
        </tr>
       
        <tr>
            <td>
            	유통기한 기준일
            </td>
            <td>
            </td>
            <td>
            	<div class="input-group">
			      <input type="number" class="form-control" placeholder="일 단위로 입력해주세요" id="expiration_date" name="expiration_date">
			      <div class="input-group-append">
			        <span class="input-group-text">일</span>
			      </div>
			    </div>
           	</td>
        </tr>
        
        <tr>
            <td>
            	적용시작일자
            </td>
            <td>
            </td>
            <td>
            	<input type="date" id="start_date" class="form-control" name="start_date">
            	<input type="hidden" id="member_key" class="form-control" name="member_key" value='<%=member_key%>'>
           	</td>
        </tr>
    </table>
</form>
    
<script type="text/javascript">
	function executeQuery() {
		if( $('#prod_cd').val() == "" ) {
			heneSwal.warning("제품 분류를 선택해 주세요.");
			return false;
		}
		prod_gubun_b = "",prod_gubun_m = "";
		
		var formData = getFormDataJson('#formId');
		
		$.ajax({
			url: "<%=Config.this_SERVER_path%>/Contents/CommonView/insert_update_delete_json.jsp",
			data : {
				bomdata : JSON.stringify(formData),
				pid : 'M909S060100E101'
			},
			success: function(returnVal) {
				if(returnVal < 1) {
					heneSwal.error('에러 발생, 다시 시도해주세요');
				} else {
					$('#modalReport').modal('hide');
					parent.fn_MainInfo_List();
					heneSwal.success('제품 정보가 등록되었습니다');
				}
			},
			error: function() {
				heneSwal.error('에러 발생, 다시 시도해주세요');
			}
		});
	}
	
    $(document).ready(function () {
		$("#prod_gubun_m").attr("disabled", true);
		$("#PRDGM").attr("disabled", true);
		$("#prod_cd").attr("disabled", true);

		$("#prod_gubun_b").on("change", function(){
			fn_Gubun_Lock();

			vProdgubun_big = $(this).val();
			
			$("#product_nm").val("");
			$("#txt_Unit option:eq(0)").prop("selected", true);
			$("#gugyuk").val("");

			if(vProdgubun_big == "ALL") {
				vProdgubun_big = "";
			}

			$.ajax({
         		type: "POST",
	            url: "<%=Config.this_SERVER_path%>/Contents/Business/M909/S909S060200.jsp",
	            data: "prodgubun_big=" + vProdgubun_big ,
    	        success: function (html) {
    	        	$("#prod_gubun_m > option").remove();

            	    var changeMidResult = html.split("|");
            	    
            	    for( var i = 0 ; i < changeMidResult.length ; i++ ) {
	                	var value = changeMidResult[i].split(",")[0]
	                	var name  = changeMidResult[i].split(",")[1].trim();
	                	
		                $("#prod_gubun_m").append("<option value = " + value + ">" + name + "</option>");
        	        }
                	
            	    if( $("#prod_gubun_b").val() == "ALL" ) {
	                	$("#prod_gubun_m").prepend("<option value = 'ALL'>전체</option>"); 
    	            	$("#prod_gubun_m > option:eq(0)").prop("selected",true);
    	            	
    	            	$("#prod_cd").val("");
        	        } else if( $("#prod_gubun_m").val() == "Empty_Value" ) {
            	    	$("#prod_gubun_m").attr("disabled",true);
            	    	$("#prod_cd").attr("disabled",true);
            	    	$("#prod_cd").val("");
           	    	} else {
	                	vProdgubun_mid = $("#prod_gubun_m >option:eq(0)").val();
		                
		                var Product_Code = "";
		                
						$("#prod_cd").attr("disabled",false);
            	    	$("#prod_cd").val("");
                	}
    	        }
        	});
		});
		
		$("#prod_gubun_m").on("change", function(){
			var Big_Gubun = $("#prod_gubun_b").val();
			var Mid_Gubun = $("#prod_gubun_m").val();

			var Product_Code = "";
			
			if( Mid_Gubun != "Empty_Value" ) {
				$("#prod_cd").attr("disabled",false);
    	    	$("#prod_cd").val("");
			}
		});
    });
	
	function fn_Gubun_Lock() {
		if( $("#prod_gubun_b").val() == 'ALL' ) {
			$("#prod_gubun_m").attr("disabled",true);
			$("#PRDGM").attr("disabled",true);
		} else {
			$("#prod_gubun_m").attr("disabled",false);
			$("#PRDGM").attr("disabled",false);
		}
	}
	
	// 제품분류 코드등록
	function registerProdCd(obj, gubun) {
		var product_code = obj.id;
		var parent_val = "";
		var current_gubun = "대분류";
		var Mid_Gubun_Check = "";

		if(product_code == "PRDGM") {
			parent_val = $("#prod_gubun_b option:selected").val();
			current_gubun = "중분류";

			var url = "<%=Config.this_SERVER_path%>/Contents/Business/M909/S909S060201.jsp"
						+ "?product_code="	+ product_code
						+ "&parent_val="	+ parent_val
						+ "&current_gubun="	+ current_gubun;
			var footer = '<button id="btnSave" class="btn btn-outline-success"'
				   				+ 'onclick="SaveOderInfo()">저장</button>';
			var title = "제품" + gubun + "구분 코드 등록";
			var heneModal = new HenesysModal2(url, 'large', title, footer);
			heneModal.open_modal();
		}
	}
</script>