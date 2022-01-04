<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*,java.util.*,javax.servlet.http.*"%>
<%@ page import="mes.client.comm.*" %>
<%@ page import="mes.client.common.*" %>
<%@ page import="mes.client.guiComponents.*" %>
<%@ page import="mes.client.util.*" %>
<%@ page import="mes.client.conf.*" %>
<%@ page import="org.json.simple.*"%><%@ include file="/strings.jsp" %>
<!DOCTYPE html>

<%
	String loginID = session.getAttribute("login_id").toString();
	String member_key = session.getAttribute("member_key").toString();
	DoyosaeTableModel TableModel;
	MakeGridData makeGridData;
	
	

	String RightButton[][]	= {{"off", "fn_Chart_View", rightbtnChartShow},{"off", "fn_Doc_Reg()", rightbtnDocSave},{"off", "pop_fn_Balju_form_button(this)", "발주서"}};
	String GV_NAME="", GV_TEMP="", GV_MIN="", GV_MAX="", GV_REGIST_DATE="", GV_DANGER="", GV_PROCESSING_METHOD="", GV_PROCESSING_METHOD2="";
	
	if(request.getParameter("name")== null)
		GV_NAME = "";
	else
		GV_NAME = request.getParameter("name"); 	
	
	if(request.getParameter("temp")== null)
		GV_TEMP = "";
	else
		GV_TEMP = request.getParameter("temp"); 
	
	if(request.getParameter("min")== null)
		GV_MIN = "";
	else
		GV_MIN = request.getParameter("min");
	
	if(request.getParameter("max")== null)
		GV_MAX = "";
	else
		GV_MAX = request.getParameter("max"); 
	
	if(request.getParameter("registDate")== null)
		GV_REGIST_DATE = "";
	else
		GV_REGIST_DATE = request.getParameter("registDate"); 
	
	if(request.getParameter("danger")== null)
		GV_DANGER = "";
	else
		GV_DANGER = request.getParameter("danger"); 
	
	/* GV_PROCESSING_METHOD = "- 2시간 전 생산제품 별도 보관\n" +
			"- 금속검출기 부저가 울리면 해당제품을 2~3회 반복하여 통과시켜 적정 감도로 조정\n" +
			"- 별도보관 된 전 제품을 다시 통과시킨다." ;
	GV_PROCESSING_METHOD2 =	"- 금속검출기가 작동한 제품을 1/2씩 분리한 후 금속검출기에 재통과하여 이물질 확인 후 제거\n" +
					"- 이물질에 의한 오염이 된 부위는 도려내서 폐기\n" +
					"- 나머지 부위에 대하여 금속검출을 재실시 한 후 이상이 없을 때 재사용\n"; */
  		
	
	JSONObject jArray = new JSONObject();
	jArray.put( "member_key", member_key);
	jArray.put( "name", GV_NAME);
	TableModel = new DoyosaeTableModel("M707S010600E106", jArray);
	
	
	makeGridData= new MakeGridData(TableModel);
 	makeGridData.RightButton	= RightButton; 
    makeGridData.htmlTable_ID	= "tableS707S010700";
    
 	makeGridData.Check_Box 	= "false";
 	String[] HyperLink		= {""}; //strColumnHead의 수만큼
 	makeGridData.HyperLink 	= HyperLink;
	
%>
    <script type="text/javascript">
	$(document).ready(function () {
		if("<%=GV_DANGER%>" =="danger") {
			$("#status").css('color','red');
			$('[data-toggle="tooltip"]').tooltip({
				title:"현재 상태에 문제가 있습니다.",
				placement:"left",	
				trigger:"manual",
				background:"red"
			}).tooltip('show');
		}
	});
    
	
	var vTableS707S010700
    $(document).ready(function () {
    	var exportDate = new Date();        
    	var printCounter = 0;
    	vTableS707S010700 = $('#<%=makeGridData.htmlTable_ID%>').DataTable({
    		scrollX: false,
     		scrollY: 200,
    	    scrollCollapse: true,
    	    paging: false,
    	    searching: false,
    	    ordering: true,
    	    order: [[ 0, "asc" ]],
    	    info: false,
    	    data: <%=makeGridData.getDataArry()%>,
   	    	'createdRow': function(row) {	
   	      		$(row).attr('id',"<%=makeGridData.htmlTable_ID%>_rowID");
   	      		<%-- $(row).attr('onclick',"<%=makeGridData.htmlTable_ID%>Event(this)"); --%>
   	      		$(row).attr('role',"row");
   	  		}, 
    	    columnDefs: [{	//{1,0,1,1,1,0, 0,0,1,1,0,1,1,0};
    	    	'targets': [],
	   			'createdCell':  function (td) {
	      			$(td).attr('style', 'display: none;'); 
	   			}
    	    },
   			// 조회컬럼크기
			{
	   			'targets': [1],
   				'createdCell':  function (td) {
					//	$(td).attr('style', 'display: none;'); //버튼 자리아래의 테이블 버튼자리와 같이 항상 처리한다.
				}
   			},
    	    	{ width: '2%', targets: 0 },
                { width: '2%', targets: 1 },
                ],
        language: { 
            url:"<%=Config.this_SERVER_path%>/AdminLTE-3.0.5/localisation/Korean.json"
         }
		});
    });
	
	
    </script>
		
      		   	
	
		<div style="width:100%; text-align:center;clear:both" >
			<div id="left_body" style="width:40%; float:left">
				<table class="table" style="width: 410px; align:left;">
			        <tr style="background-color: #fff; ">
			            <td style="width: 7%; font-weight: 900; font-size:14px; vertical-align: middle ;text-align:left">CCP명</td>
			            <td style="width: 10%; font-weight: 900; font-size:14px; vertical-align: middle ;text-align:left"colspan="3">
							<input type="text" 		class="form-control" id="ccpName" value="<%=GV_NAME %>" readonly/>
						</td>
						<td style="width: 10%; font-weight: 900; font-size:14px; vertical-align: middle ; text-align:left">
			           	</td>
					</tr>
			        <tr style="background-color: #fff;" data-toggle="tooltip">
			            <td style="width: 7%; font-weight: 900; font-size:14px; vertical-align: middle ;text-align:left">현재상태</td>
			            <td style="width: 18%; font-weight: 900; font-size:14px; vertical-align: middle ;text-align:left">
							<input type="text" 	class="form-control" id="status"  value="<%=GV_TEMP%>" readonly/>
			           	</td>
			         </tr>
			         <tr>
			            <td style="width: 7%; font-weight: 900; font-size:14px; vertical-align: middle ;text-align:left">최소값</td>
			            <td style="width: 18%; font-weight: 900; font-size:14px; vertical-align: middle ; text-align:left">
							<input type="text" 		class="form-control" id="min" value="<%=GV_MIN%>"  readonly/> 
			           	</td>
			         </tr>
			         
			         <tr>  	
			            <td style="width: 7%; font-weight: 900; font-size:14px; vertical-align: middle ; text-align:left">최대값</td>
			            <td style="width: 18%; font-weight: 900; font-size:14px; vertical-align: middle ;text-align:left">
							<input type="text" 		class="form-control" id="max" value="<%=GV_MAX%>" readonly />
			           	</td>
			         </tr>
			         
			         <tr>  	
			            <td style="width: 7%; font-weight: 900; font-size:14px; vertical-align: middle ;text-align:left">등록일자</td>
			            <td style=" width: 18%; font-weight: 900; font-size:14px; vertical-align: middle ;text-align:left">
							<input type="text" 		class="form-control" id="registDate"  value="<%=GV_REGIST_DATE%>" readonly/> 
			           	</td>
			        </tr>
		  
		      	</table> 
			</div>
			<div id="right_body" style="width:54%;float:left;margin-left: 6%; ">
				<p style="font-weight: 900; font-size:14px; vertical-align: middle ;margin-top: -19px;margin-bottom: 1px;">위해요소</p> 
	      		<table class='table table-bordered nowrap table-hover' id="<%=makeGridData.htmlTable_ID%>" style="width: 50% ;text-align: center">
					<thead>
						<tr>
							<th style="text-align:center;">코드</th>
							<th style="text-align:center;">요소명</th>
						</tr>
					</thead>
					<tbody id="<%=makeGridData.htmlTable_ID%>_body">		
					</tbody>
				</table>  
			</div>		
		</div>
      	
   


		<table style="width: 100%;margin-top: 25%;">
			<tr style="height: 60px;">
				<td style="text-align:center;">
					<p>
             			<button id="btn_Canc"  class="btn btn-info"  onclick="parent.$('#modalReport').hide();">확인</button>
            		</p>
				</td>
            </tr>
        </table>
        
        <script>
        //모바일 대응
        if(navigator.platform.toString()!='Win32' || window.screen.width < 1920) {
	        $("textarea").css("margin-left","100%");
	        $("#txt_processing_method2").css("margin-top","4%");
		}
        
        //CCP 모니터링 팝업창을 띄울때 현재 디스플레이 크기에 따라 조절하기
        if(window.screen.width >= 600 && window.screen.width < 1067) {
        	$("textarea").css("margin-left","92%");
	        $("#txt_processing_method").css("margin-top","-78%");	        
        	$("#txt_processing_method2").css("margin-top","4%");       	
        	$("textarea").css("width","340px");
        	 
        }
        
        //모바일 화면 가로 세로 전환시 일어나는 이벤트 (디스플레이 크기에 맞춰 CCP상세 모니터링 보여주기)
        $(window).on("orientationchange",function(){
        	if(window.screen.width >= 600 && window.screen.width < 1067) {
            	$("textarea").css("margin-left","92%");
    	        $("#txt_processing_method").css("margin-top","-78%");	        
            	$("#txt_processing_method2").css("margin-top","4%");           	
            	$("textarea").css("width","340px");
            	 
            } else {
            	$("textarea").css("margin-left","100%");
            	$("#txt_processing_method").css("margin-top","-76%");
    	        $("#txt_processing_method2").css("margin-top","4%");
    	        $("textarea").css("width","350px");
            }
        });
          	
        </script>
