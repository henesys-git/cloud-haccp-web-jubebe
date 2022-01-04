<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*,java.util.*,javax.servlet.http.*,java.text.*"%>
<%@ page import="mes.client.comm.*" %>
<%@ page import="mes.client.common.*" %>
<%@ page import="mes.client.guiComponents.*" %>
<%@ page import="mes.client.util.*" %>
<%@ page import="mes.client.conf.*" %>
<%@ page import="org.json.simple.*"%><%@ include file="/strings.jsp" %>
<%
/* 
배송차량 청소관리일지 canvas (S838S060500_canvas.jsp)
*/	
	String loginID = session.getAttribute("login_id").toString();
	String member_key = session.getAttribute("member_key").toString();
	DoyosaeTableModel TableModel;

	String GV_VHCL_NO = "", GV_VHCL_NO_REV = "", GV_SERVICE_DATE = "", CV_CHECK_PERSON = "" ;

	if(request.getParameter("vhcl_no") == null)
		GV_VHCL_NO = "";
	else
		GV_VHCL_NO = request.getParameter("vhcl_no");	
	
	if(request.getParameter("vhcl_no_rev") == null)
		GV_VHCL_NO_REV = "";
	else
		GV_VHCL_NO_REV = request.getParameter("vhcl_no_rev");
	
	if(request.getParameter("service_date") == null)
		GV_SERVICE_DATE = "";
	else
		GV_SERVICE_DATE = request.getParameter("service_date");
	
	if(request.getParameter("check_person") == null)
		CV_CHECK_PERSON = "";
	else
		CV_CHECK_PERSON = request.getParameter("check_person");

	JSONObject jArray = new JSONObject();
	jArray.put( "member_key", member_key);
	jArray.put( "vhcl_no", GV_VHCL_NO);
	jArray.put( "vhcl_no_rev", GV_VHCL_NO_REV);
	jArray.put( "service_date", GV_SERVICE_DATE);
	jArray.put( "check_person", CV_CHECK_PERSON);

	TableModel = new DoyosaeTableModel("M838S060500E174", jArray);
	int RowCount =TableModel.getRowCount();
    
	StringBuffer CheckListArray = new StringBuffer();
	CheckListArray.append("[");
	for(int i=0; i<RowCount; i++) {
		CheckListArray.append("[");
		CheckListArray.append( "'" + TableModel.getValueAt(i, 0).toString().trim() + "'" );
		if( i == RowCount - 1 ) CheckListArray.append("]");
		else CheckListArray.append("],");
	}
	CheckListArray.append("]");
	
%>

<script type="text/javascript">	
	// check_date, check_time 체크 날짜 세팅
	// var today = new Date("2019-06-02"); // 특정날짜
	//var today = new Date(); // 오늘날짜
	var Service_Date = new Date("<%=GV_SERVICE_DATE%>");
	var check_date 	= Service_Date.getFullYear() 
					+ "-" + ("0" + (Service_Date.getMonth() + 1)).slice(-2) 
					+ "-" + ("0" + Service_Date.getDate()).slice(-2) ;
	var check_time 	= ("0" + Service_Date.getHours()).slice(-2) 
					+ ":" + ("0" + Service_Date.getMinutes()).slice(-2) 
					+ ":" + ("0" + Service_Date.getSeconds()).slice(-2) ;
				
	// check_duration 체크 날짜기간(월~토) 세팅
	var duration_start = new Date(Service_Date); // check_duration 기간 처음 날짜(월요일)
		duration_start.setDate(Service_Date.getDate() + 1 - Service_Date.getDay());
		var duration_end = new Date(Service_Date); // check_duration 기간 마지막 날짜(토요일)
		duration_end.setDate(Service_Date.getDate() + 6 - Service_Date.getDay());
		var check_duration  = duration_start.getFullYear() 
							+ "-" + ("0" + (duration_start.getMonth() + 1)).slice(-2) 
							+ "-" + ("0" + duration_start.getDate()).slice(-2)
				 			+ "~" + duration_end.getFullYear() 
							+ "-" + ("0" + (duration_end.getMonth() + 1)).slice(-2) 
							+ "-" + ("0" + duration_end.getDate()).slice(-2) ; // 형식 : 2019-00-00~2019-00-00
			console.log("duration_start="+duration_start+"\n"+"duration_end="+duration_end);
			console.log("check_duration" + check_duration);
	
	var check_duration_start = duration_start.getFullYear() 
							+ "-" + ("0" + (duration_start.getMonth() + 1)).slice(-2) 
							+ "-" + ("0" + duration_start.getDate()).slice(-2);
	var check_duration_end = duration_end.getFullYear() 
							+ "-" + ("0" + (duration_end.getMonth() + 1)).slice(-2) 
							+ "-" + ("0" + duration_end.getDate()).slice(-2);

	//var duration_range = [ check_duration_start ];
	
	var txt_duration = [("0" + (duration_start.getFullYear())).slice(-2), ("0" + (duration_start.getMonth() + 1)).slice(-2), ("0" + duration_start.getDate()).slice(-2),
						("0" + (duration_end.getFullYear())).slice(-2), ("0" + (duration_end.getMonth() + 1)).slice(-2), ("0" + duration_end.getDate()).slice(-2)];
	console.log("txt_duration@@@@@@@@@@@@" + txt_duration);
						
	var DayOfTheWeek = [];
	var Duration_YYYY_MM_DD = [];
	
	for( i = 0 ; i < 6 ; i++ ) // 일요일 제외
	{
		var TempDate = new Date();
		var TempTXT = "";
		
		TempDate.setFullYear(duration_start.getFullYear());
		TempDate.setMonth(duration_start.getMonth());
		TempDate.setDate(duration_start.getDate() + i);
		
		DayOfTheWeek.push(("0" + TempDate.getDate()).slice(-2));
		
		TempTXT = TempDate.getFullYear() + '-' + ("0" + (TempDate.getMonth() + 1)).slice(-2) + '-' + ("0" + TempDate.getDate()).slice(-2);
		
		Duration_YYYY_MM_DD.push(TempTXT);
		console.log("TempDate.getFullYear()@@@@@@@@@@@@@@@@@@" + TempDate.getFullYear() + "############");
		console.log("TempDate.getMonth()@@@@@@@@@@@@@@@@@@" + TempDate.getMonth() + "############");
		console.log("TempDate.getDate()@@@@@@@@@@@@@@@@@@" + TempDate.getDate() + "############");
	}
	
	console.log("DayOfTheWeek@@@@@@@@@@@@@@@@@@" + DayOfTheWeek + "############");
	console.log("Duration_YYYY_MM_DD%%%%%%%%%%%%%%%%%%" + Duration_YYYY_MM_DD + "$$$$$$$$$$$$");
	
	var driver = "";
	
	var CanvasPadding = 10; // 캔버스영역 안쪽 여백
	
	// 상단 텍스트 영역
	var HeadText_HeightStart = 30; // 헤드텍스트의 높이를 지정 , 전체 보고서의 높이 위치를 조정된다
	var HaedText_HeightEnd = HeadText_HeightStart + 30; // 헤드텍스트 영역 종료 높이
	
	// 표1 영역
	var vTextStyle_B		= '30px 맑은고딕';
	var vTextStyleBold_B	= 'bold 30px 맑은고딕';
	
	var vTextStyle_M		= '20px 맑은고딕';
	var vTextStyleBold_M	= 'bold 20px 맑은고딕';
	
	var vTextStyle_S		= '15px 맑은고딕';
	var vTextStyleBold_S	= 'bold 15px 맑은고딕';
	var DataGrid_RowHeight_S = 30; // 표의 작은 행 높이
	var DataGrid_RowHeight_B = 50; // 표의 큰 행 높이
	var DataGrid1_Width = 0 ; // doc.ready에서 표1의 각 열너비를 더해서 계산
	var DataGrid_Height = HaedText_HeightEnd
						+ DataGrid_RowHeight_S * (4 + 1)
						+ DataGrid_RowHeight_B * (4 + 2 + 6 + 3)
						+ 300
						+ CanvasPadding * 3;

	var HeightEndOfDataGrid1 = HaedText_HeightEnd + CanvasPadding * 2 + DataGrid_RowHeight_S * 4;
	var HeightEndOfDataGrid2 = HeightEndOfDataGrid1 + CanvasPadding + DataGrid_RowHeight_B * 4;
	var HeightEndOfDataGrid3 = HeightEndOfDataGrid2 + DataGrid_RowHeight_B * 2;
	var HeightEndOfDataGrid4 = HeightEndOfDataGrid3 + DataGrid_RowHeight_B * 6 + DataGrid_RowHeight_S;
	var HeightEndOfDataGrid5 = HeightEndOfDataGrid4 + DataGrid_RowHeight_B * 3 + 300;

	function replaceAll(str, searchStr, replaceStr) {
		  return str.split(searchStr).join(replaceStr);
		}
	
    $(document).ready(function () {
    	// 표1의 전체너비 계산
    	for( i = 0 ; i < DataGrid1.col_head_width.length ; i++ )
    		DataGrid1_Width += DataGrid1.col_head_width[i];
    	
    	// 캔버스 전체 크기 영역
    	var CanvasWidth = DataGrid1_Width + CanvasPadding * 2; // 캔버스영역 너비
    	var CanvasHeight = DataGrid_Height + CanvasPadding * 2; // 캔버스영역 높이
    	
		document.getElementById('myCanvas').width = CanvasWidth;
		document.getElementById('myCanvas').height = CanvasHeight;
		var ctx = document.getElementById('myCanvas').getContext("2d"); // 캔버스 컨텍스트
		
		// 캔버스 내에 실제로 그리는 영역 좌표
    	var pointSX = CanvasPadding; // 시작좌표x
    	var pointSY = CanvasPadding; // 시작좌표y
    	var pointEX = CanvasWidth - CanvasPadding ; // 끝좌표x
    	var pointEY = CanvasHeight - CanvasPadding ; // 끝좌표y
    	
		// 그리기
	    //HeadText.drawText(ctx, pointSX, pointSY + HeadText_HeightStart, pointEX, pointSY + HaedText_HeightEnd);
	    HeadText.drawText(ctx, pointSX, HeadText_HeightStart, pointEX, HeadText_HeightStart + HaedText_HeightEnd);
 		DataGrid1.drawGrid(ctx, pointSX, pointSY + HaedText_HeightEnd + CanvasPadding, pointEX, HeightEndOfDataGrid1);
 		DataGrid2.drawGrid(ctx, pointSX, HeightEndOfDataGrid1 + CanvasPadding, pointEX, HeightEndOfDataGrid2);
 		DataGrid3.drawGrid(ctx, pointSX, HeightEndOfDataGrid2, pointEX, HeightEndOfDataGrid3);
 		DataGrid4.drawGrid(ctx, pointSX, HeightEndOfDataGrid3, pointEX, HeightEndOfDataGrid4);
 		DataGrid5.drawGrid(ctx, pointSX, HeightEndOfDataGrid4, pointEX, HeightEndOfDataGrid5);
    });	
    
 	// 상단 텍스트 정의
	var HeadText = {
		drawText(ctx, sx, sy, ex, ey) {
			var line_space = 25;
			
			var blank_tab = '    '; // 4칸 공백
			var vehicle_info1 = "● 1.5톤 냉동탑차 차량번호 : ";
			var vehicle_info2 = "● 3.5톤 윙바디 차량번호 : ";
			
			ctx_fillText(ctx, sx, sy, vehicle_info1, 'black', '15px 맑은고딕', 'start','top');
			ctx_fillText(ctx, sx, sy + line_space, vehicle_info2, 'black', '15px 맑은고딕', 'start','top');
		}
	};
	
	// 표1 정의
	var DataGrid1 = {
		col_head_width:[200, 600, 100, 100],
			
		drawGrid: function(ctx, sx, sy, ex, ey) { // 표1 양식 그리기
			ctx_Box(ctx, sx, sy, ex, ey, 'black', 2); // 표 전체 틀(사각형)
			
			// 헤드
			var col_head_y = sy + DataGrid_RowHeight_S ;
			var col_head_y_center = sy + (DataGrid_RowHeight_S)/2 ;
			var col_head_x = sx;
			var col_head_x_start = col_head_x;
			
			var approval_box_width = 100 + 100;
			// col_head_width[2] + col_head_width[3]
			
			ctx_Line(ctx, ex - approval_box_width, col_head_y, ex, col_head_y, 'black', 1);
			ctx_Line(ctx, sx, col_head_y + DataGrid_RowHeight_S, sx + (200 + 600), col_head_y + DataGrid_RowHeight_S, 'black', 1);
			ctx_Line(ctx, sx, col_head_y + DataGrid_RowHeight_S*2, sx + 200, col_head_y + DataGrid_RowHeight_S*2, 'black', 1);
			
			ctx_fillText(ctx, sx + (200 * 1/2), sy + 30, '태양 E&S', 'black', vTextStyleBold_B, 'center','middle');
			// sx + (col_head_width[0] * 1/2)
			ctx_fillText(ctx, sx + 200 + (600 * 1/2), sy + 30, '보관/운송 관리기준서', 'black', vTextStyleBold_B, 'center','middle');
			// sx + col_head_width[0] + (col_head_width[1] * 1/2)
			ctx_fillText(ctx, ex - (approval_box_width * 3/4), sy + 15, '작    성', 'black', vTextStyle_S, 'center','middle');
			ctx_fillText(ctx, ex - (approval_box_width * 1/4), sy + 15, '승    인', 'black', vTextStyle_S, 'center','middle');
			ctx_fillText(ctx, sx + (200 * 1/2), col_head_y + DataGrid_RowHeight_S + 15, '재정일자 2019.05.22', 'black', vTextStyle_S, 'center','middle');
			ctx_fillText(ctx, sx + (200 * 1/2), col_head_y + DataGrid_RowHeight_S * 2 + 15, '개정일자 2020.02.11', 'black', vTextStyle_S, 'center','middle');
			ctx_fillText(ctx, sx + 200 + (600 * 1/2), col_head_y + DataGrid_RowHeight_S + 30, '배송차량 청소관리 일지', 'black', vTextStyle_M, 'center','middle');
			
			for(i=0; i<this.col_head_width.length; i++){
				col_head_x += this.col_head_width[i] ;
				var col_head_x_center = col_head_x - this.col_head_width[i]/2 ;
				if(i==this.col_head_width.length-1) { // 마지막엔 세로선 그릴필요X
					
				} else {
					ctx_Line(ctx, col_head_x, sy, col_head_x, sy + DataGrid_RowHeight_S * 4, 'black', 1); // 세로선
				}
				
			}
		} // drawGrid function end
	} ; // DataGrid1(표1) 정의  end
	
	// 표2 정의
	var DataGrid2 = {
		col_head_width : [300, 700],
		
		drawGrid: function(ctx, sx, sy, ex, ey) { // 표2 양식 그리기
			ctx_Box(ctx, sx, sy, ex, ey, 'black', 2); // 표 전체 틀(사각형)

			var left_col_data_name = ['점검일자', '점  검  자', '차  량  번  호', '청소주기/소독주기'];
			var blank_tab4 = '    ';	// 4칸 공백
			var blank_tab6 = '      ';	// 6칸 공백
			var _Date = "20" + txt_duration[0] + "년" + txt_duration[1] + "월" + txt_duration[2] + "일 ~ 20" + txt_duration[3] + "년" + txt_duration[4] + "월" + txt_duration[5] + "일"
//			var _Date = "20    년      월      일 ~ 20    년      월      일"
			
			var left_box_width = 300;	// col_head_width[0]
			var right_box_width = 700;	// col_head_width[1]
			
			for( i = 0 ; i < left_col_data_name.length ; i++ )
			{
				if( i != left_col_data_name.length - 1 )
				{
					ctx_fillText(ctx, sx + (left_box_width * 1/2), sy + DataGrid_RowHeight_B * i + 25, left_col_data_name[i], 'black', vTextStyleBold_M, 'center','middle');
					ctx_Line(ctx, sx, sy + DataGrid_RowHeight_B * (i+1), ex, sy + DataGrid_RowHeight_B * (i+1), 'black', 1);
				}
				else
				{
					ctx_fillText(ctx, sx + (left_box_width * 1/2), sy + DataGrid_RowHeight_B * i + 25, left_col_data_name[i], 'black', vTextStyleBold_M, 'center','middle');
				}
			}
			
			ctx_fillText(ctx, sx + left_box_width + (right_box_width * 1/2), sy + 25, _Date, 'black', vTextStyle_M, 'center','middle');
			ctx_fillText(ctx, sx + left_box_width + (right_box_width * 1/2), sy + DataGrid_RowHeight_B*3 + 25, '1회/일, 1회/주', 'black', vTextStyle_S, 'center','middle');

			ctx_Line(ctx, sx + left_box_width, sy, sx + left_box_width, sy + DataGrid_RowHeight_B * 4, 'black', 1) // 세로선
			
			ctx_fillText(ctx, sx + left_box_width + (right_box_width * 1/2), sy + DataGrid_RowHeight_B*(1+1/2), "<%=CV_CHECK_PERSON%>", 'black', vTextStyle_M, 'center','middle');
			ctx_fillText(ctx, sx + left_box_width + (right_box_width * 1/2), sy + DataGrid_RowHeight_B*(2+1/2), "<%=GV_VHCL_NO%>", 'black', vTextStyle_M, 'center','middle');
		} // drawGrid function end
	} ; // DataGrid2(표2) 정의  end
	
	// 표3 정의
	var DataGrid3 = {
		col_head_width : [300, 700],
		
		drawGrid: function(ctx, sx, sy, ex, ey) { // 표3 양식 그리기
			ctx_Box(ctx, sx, sy, ex, ey, 'black', 2); // 표 전체 틀(사각형)

			var blank_tab6 = '      ';	// 6칸 공백
			var _7Date = [ '월(' + DayOfTheWeek[0] + ')','화(' + DayOfTheWeek[1] + ')','수(' + DayOfTheWeek[2] + ')',
							'목(' + DayOfTheWeek[3] + ')', '금(' + DayOfTheWeek[4] + ')','토(' + DayOfTheWeek[5] + ')' ];
//			var _7Date = ['월(      )', '화(      )', '수(      )', '목(      )', '금(      )', '토(      )' ];
			
			var left_box_width = 300;	// col_head_width[0]
			var right_box_width = 700;	// col_head_width[1]
			var right_box_width_s = right_box_width / 6;
			
			ctx_Line(ctx, sx, sy, sx + left_box_width, sy + DataGrid_RowHeight_B, 'black', 1);
			ctx_Line(ctx, sx, sy, sx + left_box_width, sy + DataGrid_RowHeight_B*2, 'black', 1);
			
			for( i = 0 ; i < _7Date.length ; i++ )
			{
				ctx_fillText(ctx, sx + left_box_width + ( right_box_width_s/2 * (2*i + 1) ), sy + 25, _7Date[i], 'black', vTextStyle_M, 'center','middle');
				
				$.ajax(
						{
							type: "POST",
							url: "<%=Config.this_SERVER_path%>/Contents/Business/M838/S838S060540.jsp",
							data: "vhcl_no=" + "<%=GV_VHCL_NO%>" + "&vhcl_no_rev=" + "<%=GV_VHCL_NO_REV%>" + "&service_date=" + Duration_YYYY_MM_DD[i] ,
							async: false,
							beforeSend: function () {
//				 				$("#Transport_List_contents").children().remove();
							},
							success: function (html) {
								driver = html.split('|')[0].trim();
								console.log("driver@@@@@@@@@@@@@@@@@@@@@@@@@@@@@" + driver + "#############################");
							},
							error: function (xhr, option, error) {
					
							}
						});
				//console.log("driver@@@@@@@@@@@@@@@@@@@@@@@@@@@@@" + driver + "#############################");
				if( driver != "N" )
				{
					ctx_fillText(ctx, sx + left_box_width + ( right_box_width_s/2 * (2*i + 1) ), sy + DataGrid_RowHeight_B * (1+1/2), driver, 'black', vTextStyle_M, 'center','middle');
				}
				
				ctx_Line(ctx, sx + left_box_width + (right_box_width_s * i), sy, sx + left_box_width + (right_box_width_s * i), sy + DataGrid_RowHeight_B * 2, 'black', 1) // 세로선
			}
			
			ctx_Line(ctx, sx + left_box_width, sy + DataGrid_RowHeight_B, ex, sy + DataGrid_RowHeight_B, 'black', 1);
			
			ctx_fillText(ctx, sx + left_box_width - 10, sy + 25, '운행일', 'black', vTextStyle_S, 'end', 'middle');
			ctx_fillText(ctx, sx + left_box_width - 10, sy + DataGrid_RowHeight_B + 25, '운전자', 'black', vTextStyle_S, 'end', 'middle');
			ctx_fillText(ctx, sx + 15, sy + DataGrid_RowHeight_B + 25, '점검사항', 'black', vTextStyle_S, 'start','middle');
		} // drawGrid function end
	} ; // DataGrid3(표3) 정의  end
	
	// 표4 정의
	var DataGrid4 = {
		col_head_width : [300, 700],
		col_data : <%=CheckListArray.toString()%>,
		drawGrid: function(ctx, sx, sy, ex, ey) { // 표3 양식 그리기
			ctx_Box(ctx, sx, sy, ex, ey, 'black', 2); // 표 전체 틀(사각형)

			var blank_tab4 = '    ';	// 4칸 공백
			
			// var Check_List = [ '운행 전 적재함은 청결한가?','운행 후 적재함은 청결한가?', '운행 후 세차를 하였는가?', '운행 후 소독을 하였는가?', '운행 후 운전석은 청결한가?', '타코메타는 청결하며 잘 작동하는가?' ];
			var Check_List = this.col_data;
			
			var left_box_width = 300;	// col_head_width[0]
			var right_box_width = 700;	// col_head_width[1]
			var right_box_width_s = right_box_width / 6;
			
			var Check_List_Result_Array = [];
			
			for( i = 0 ; i < Check_List.length ; i++ )
			{
				ctx_Line(ctx, sx, sy + DataGrid_RowHeight_B * (i + 1), ex, sy + DataGrid_RowHeight_B * (i + 1), 'black', 1); // 가로줄
				ctx_Line(ctx, sx + left_box_width + (right_box_width_s * i), sy, sx + left_box_width + (right_box_width_s * i), sy + DataGrid_RowHeight_B * 6, 'black', 1); // 세로줄
				ctx_fillText(ctx, sx + 15, sy + DataGrid_RowHeight_B * (i + 1) - 25, Check_List[i][0], 'black', vTextStyle_S, 'start','middle');
			}
			
			for( var i = 0 ; i < 6 ; i++ )
			{
				$.ajax(
						{
							type: "POST",
							url: "<%=Config.this_SERVER_path%>/Contents/Business/M838/S838S060550.jsp",
							data: "vhcl_no=" + "<%=GV_VHCL_NO%>" + "&vhcl_no_rev=" + "<%=GV_VHCL_NO_REV%>" + "&service_date=" + Duration_YYYY_MM_DD[i] ,
							async: false,
							beforeSend: function () {
//							 				$("#Transport_List_contents").children().remove();
							},
							success: function (html) {
										html = html.trim();
										
										for( var j = 0 ; j < html.split('|').length ; j++ )
										{
											if( html.split('|')[j] == 'Y' )
												Check_List_Result_Array.push('O');
											if( html.split('|')[j] == 'N' )
												Check_List_Result_Array.push('X');
										}
								
										if( Check_List_Result_Array.length != 1 )
										{
											for( var j = 0 ; j < Check_List_Result_Array.length ; j++ )
											{
												ctx_fillText(ctx, sx + left_box_width + right_box_width_s * (i+1/2), sy + DataGrid_RowHeight_B * (j+1/2),
																Check_List_Result_Array[j], 'black', vTextStyle_S, 'center','middle');
											}
											console.log("Check_List_Result_Array1@@@@@@@@@@@@@@@@@@@@@@@@@@@@@" + Check_List_Result_Array + "#############################");
											Check_List_Result_Array.length = 0;
										}
							
										console.log("Check_List_Result_Array2@@@@@@@@@@@@@@@@@@@@@@@@@@@@@" + Check_List_Result_Array + "#############################");
										Check_List_Result_Array.length = 0;
									},
						error: function (xhr, option, error) {
				
						}
					});
			}
			
			ctx_Line(ctx, sx + left_box_width, sy + DataGrid_RowHeight_B * 6, sx + left_box_width, sy + DataGrid_RowHeight_B * 6 + DataGrid_RowHeight_S, 'black', 1);
			ctx_fillText(ctx, sx + 15, sy + (DataGrid_RowHeight_B * 6) + 15, '점검결과', 'black', vTextStyle_S, 'start','middle');
			ctx_fillText(ctx, sx + left_box_width + (right_box_width * 1/2) , sy + (DataGrid_RowHeight_B * 6) + 15, '양호(o)' + blank_tab4 + '불량(x)', 'black', vTextStyle_S, 'center','middle');
		} // drawGrid function end
	} ; // DataGrid4(표4) 정의  end
	
	// 표5 정의
	var DataGrid5 = {
		col_head_width : [300, 700],
		
		drawGrid: function(ctx, sx, sy, ex, ey) { // 표3 양식 그리기
			ctx_Box(ctx, sx, sy, ex, ey, 'black', 2); // 표 전체 틀(사각형)
			
//			var col_size				= [ 30, 135, 135, 250, 250, 100, 100 ];
			var col_size_sum			= [ 30, 165, 300, 650, 800, 900, 1000 ];
			var col_name				= [ '이상발생일시', '이상발생내역', '조치내역 및 결과', '조치완료일시', '조치자', '확인' ];
			var _text					= [ '이', '상', '발', '생', '내', '역' ];
			var temperature_recording	= "[ 온도기록지 부착(공간부족시 뒷면 사용 가능 / 출발시간, 도착시간 표시할 것) ]";
			
			var Strange_Info_List = [];
			var strange_temp_result = [];
			var strange_temp = [];
			var strange_temp_size = 0;
			
			var left_box_width = 300;	// col_head_width[0]
			var right_box_width = 700;	// col_head_width[1]
			var right_box_width_s = right_box_width / 6;
			var _text_size = DataGrid_RowHeight_B * 3;

			for( i = 0 ; i < col_size_sum.length - 1 ; i++ )
			{
				ctx_Line(ctx, sx + col_size_sum[i], sy, sx + col_size_sum[i], sy + DataGrid_RowHeight_B * 3, 'black', 1);
				ctx_fillText(ctx, sx + (col_size_sum[i] + col_size_sum[i+1])/2, sy + 25, col_name[i], 'black', vTextStyle_S, 'center','middle');
				ctx_fillText(ctx, sx + 15, sy + _text_size/6 * (i + 1/2), _text[i], 'black', vTextStyle_S, 'center','middle');
			}
			
			ctx_Line(ctx, sx + col_size_sum[0], sy + DataGrid_RowHeight_B, ex, sy + DataGrid_RowHeight_B, 'black', 1);
			ctx_Line(ctx, sx, sy + DataGrid_RowHeight_B * 3, ex, sy + DataGrid_RowHeight_B * 3, 'black', 1);
			ctx_fillText(ctx, sx + 15, sy + 5 + DataGrid_RowHeight_B * 3, temperature_recording, 'black', vTextStyle_S, 'start','top');
			
			$.ajax(
					{
						type: "POST",
						url: "<%=Config.this_SERVER_path%>/Contents/Business/M838/S838S060560.jsp",
						data: "vhcl_no=" + "<%=GV_VHCL_NO%>" + "&vhcl_no_rev=" + "<%=GV_VHCL_NO_REV%>" + "&start_date=" + Duration_YYYY_MM_DD[0] + "&end_date=" + Duration_YYYY_MM_DD[5],
						async: false,
						beforeSend: function () {
//			 				$("#Transport_List_contents").children().remove();
						},
						success: function (html) {
							console.log("html@@@@@@@@@@@@@@@@@@@@@@@@@@@@@" + html + "#############################");
							
							Strange_Info_List = html.trim();
							
							if( html.trim() != 'N' )
							{
								var Data_List = html.trim();
								
								var temp1 = Data_List.substring(2,Data_List.length-2);
								var temp2 = replaceAll(temp1,'],[','|');
								var split_Data_List = temp2.split('|');
								
								strange_temp_size = split_Data_List[0].split(',').length;
								
								var k = 0;
								var wrapText_raw_count = 0;
								var Max_wrapText_raw_count = 0;
								
								for( var i = 0 ; i < split_Data_List.length ; i++ )
								{
									for(var j = 0 ; j < strange_temp_size ; j++ )
									{
										strange_temp.push(split_Data_List[i].split(',')[j]);
									}
									
									for(var j = 0 ; j < strange_temp_size ; j++ )
									{
										console.log("strange_temp[" + j + "]=" + strange_temp[j] + "@@@@@@@@@@@@@@@@@@@");
										
										wrapText_raw_count = ctx_wrapText(ctx, sx + col_size_sum[j] + 5, sy + DataGrid_RowHeight_B + 15 * 1/2 + k, strange_temp[j],
																	'black', vTextStyle_S, 'start','up', col_size_sum[j+1] - col_size_sum[j] - 10, 15);
										
										if( Max_wrapText_raw_count < wrapText_raw_count )
											Max_wrapText_raw_count = wrapText_raw_count;											
										
										console.log((j+1) + "번째내용의 줄 수?????????" + wrapText_raw_count + "#######################");
									}
									k = k + 15 * Max_wrapText_raw_count;
									
									strange_temp.length = 0;
									
								}
							}
						},
						error: function (xhr, option, error) {
				
						}
					});
		} // drawGrid function end
	} ; // DataGrid5(표5) 정의  end
	
</script>
    <div id="PrintAreaP"  style="overflow-y:auto; width:100%; height:650px; text-align:center;">
	    <canvas id="myCanvas" ></canvas>    
	</div>
	<p style="text-align:center;" >
    	<button id="btn_Print"  class="btn btn-info" onclick="print_area();">프린트</button>
        <button id="btn_Canc"  class="btn btn-info"  onclick="parent.$('#modalReport').hide();">닫기</button>
    </p>