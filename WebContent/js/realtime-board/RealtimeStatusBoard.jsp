<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@page import="org.json.simple.JSONObject"%>
<!DOCTYPE html>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">

    <link href="libs/tabulator-master/dist/css/tabulator_midnight.min.css" rel="stylesheet">
    <link href="css/tabulator_customized_for_hyupjin_project.css" rel="stylesheet">
    <link href="libs/canvas-gauges-master/fonts/fonts.css" rel="stylesheet" >
    <link href="css/main.css" rel="stylesheet">

    <script src="libs/canvas-gauges-master/gauge.min.js"></script>
    <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.5.1/jquery.min.js"></script>
    <script src="https://unpkg.com/sweetalert/dist/sweetalert.min.js"></script>
</head>

<body style="background: #222">
    <header>
        <h1 id="main-title">실시간 현황판</h1>
        <div id="digital-clock"></div>
    </header>

    <audio src="sound/beep.wav" muted></audio>
    <audio src="sound/newOrderAlert.wav" muted></audio>

    <div id="container">
        <div id="center">
            <div id="main-table"></div>
            <div id="main-chart"></div>
            <br>
        </div>
        <div id="second-area">
            <div id="temp-chart">
                <div class="content">
                    <!-- 작업장 -->
                    <canvas data-type="radial-gauge"
                    data-width="400"
                    data-height="400"
                    data-units="°C"
                    data-title="작업장"
                    data-min-value="-30"
                    data-max-value="30"
                    data-major-ticks="[-30,-20,-10,0,10,20,30]"
                    data-minor-ticks="2"
                    data-stroke-ticks="true"
                    data-highlights='[
                                {"from": -30, "to": -1, "color": "rgba(255, 0, 0, .3)"},
                                {"from": -1, "to": 14, "color": "rgba(0, 0, 255, .3)"},
                                {"from": 14, "to": 30, "color": "rgba(255, 0, 0, .3)"}
                            ]'
                    data-ticks-angle="225"
                    data-start-angle="67.5"
                    data-color-major-ticks="#ddd"
                    data-color-minor-ticks="#ddd"
                    data-color-title="#eee"
                    data-color-units="#ccc"
                    data-color-numbers="#eee"
                    data-color-plate="#222"
                    data-border-shadow-width="0"
                    data-borders="true"
                    data-needle-type="arrow"
                    data-needle-width="2"
                    data-needle-circle-size="7"
                    data-needle-circle-outer="true"
                    data-needle-circle-inner="false"
                    data-animation-duration="1500"
                    data-animation-rule="linear"
                    data-color-border-outer="#333"
                    data-color-border-outer-end="#111"
                    data-color-border-middle="#222"
                    data-color-border-middle-end="#111"
                    data-color-border-inner="#111"
                    data-color-border-inner-end="#333"
                    data-color-needle-shadow-down="#333"
                    data-color-needle-circle-outer="#333"
                    data-color-needle-circle-outer-end="#111"
                    data-color-needle-circle-inner="#111"
                    data-color-needle-circle-inner-end="#222"
                    data-value-box-border-radius="0"
                    data-color-value-box-rect="#222"
                    data-color-value-box-rect-end="#333"
                    data-font-value="Led"
                    data-font-numbers="Led"
                    data-font-title="Led"
                    data-font-units="Led"
                    ></canvas>
    
                    <!-- 양념실 -->
                    <canvas data-type="radial-gauge"
                    data-width="400"
                    data-height="400"
                    data-units="°C"
                    data-title="양념실"
                    data-min-value="-30"
                    data-max-value="30"
                    data-major-ticks="[-30,-20,-10,0,10,20,30]"
                    data-minor-ticks="2"
                    data-stroke-ticks="true"
                    data-highlights='[
                                {"from": -30, "to": -1, "color": "rgba(255, 0, 0, .3)"},
                                {"from": -1, "to": 14, "color": "rgba(0, 0, 255, .3)"},
                                {"from": 14, "to": 30, "color": "rgba(255, 0, 0, .3)"}
                            ]'
                    data-ticks-angle="225"
                    data-start-angle="67.5"
                    data-color-major-ticks="#ddd"
                    data-color-minor-ticks="#ddd"
                    data-color-title="#eee"
                    data-color-units="#ccc"
                    data-color-numbers="#eee"
                    data-color-plate="#222"
                    data-border-shadow-width="0"
                    data-borders="true"
                    data-needle-type="arrow"
                    data-needle-width="2"
                    data-needle-circle-size="7"
                    data-needle-circle-outer="true"
                    data-needle-circle-inner="false"
                    data-animation-duration="1500"
                    data-animation-rule="linear"
                    data-color-border-outer="#333"
                    data-color-border-outer-end="#111"
                    data-color-border-middle="#222"
                    data-color-border-middle-end="#111"
                    data-color-border-inner="#111"
                    data-color-border-inner-end="#333"
                    data-color-needle-shadow-down="#333"
                    data-color-needle-circle-outer="#333"
                    data-color-needle-circle-outer-end="#111"
                    data-color-needle-circle-inner="#111"
                    data-color-needle-circle-inner-end="#222"
                    data-value-box-border-radius="0"
                    data-color-value-box-rect="#222"
                    data-color-value-box-rect-end="#333"
                    data-font-value="Led"
                    data-font-numbers="Led"
                    data-font-title="Led"
                    data-font-units="Led"
                    ></canvas>
    
                    <!-- 냉장실 -->
                    <canvas data-type="radial-gauge"
                    data-width="400"
                    data-height="400"
                    data-units="°C"
                    data-title="냉장실"
                    data-min-value="-30"
                    data-max-value="30"
                    data-major-ticks="[-30,-20,-10,0,10,20,30]"
                    data-minor-ticks="2"
                    data-stroke-ticks="true"
                    data-highlights='[
                                {"from": -30, "to": -5, "color": "rgba(255, 0, 0, .3)"},
                                {"from": -5, "to": 5, "color": "rgba(0, 0, 255, .3)"},
                                {"from": 5, "to": 30, "color": "rgba(255, 0, 0, .3)"}
                            ]'
                    data-ticks-angle="225"
                    data-start-angle="67.5"
                    data-color-major-ticks="#ddd"
                    data-color-minor-ticks="#ddd"
                    data-color-title="#eee"
                    data-color-units="#ccc"
                    data-color-numbers="#eee"
                    data-color-plate="#222"
                    data-border-shadow-width="0"
                    data-borders="true"
                    data-needle-type="arrow"
                    data-needle-width="2"
                    data-needle-circle-size="7"
                    data-needle-circle-outer="true"
                    data-needle-circle-inner="false"
                    data-animation-duration="1500"
                    data-animation-rule="linear"
                    data-color-border-outer="#333"
                    data-color-border-outer-end="#111"
                    data-color-border-middle="#222"
                    data-color-border-middle-end="#111"
                    data-color-border-inner="#111"
                    data-color-border-inner-end="#333"
                    data-color-needle-shadow-down="#333"
                    data-color-needle-circle-outer="#333"
                    data-color-needle-circle-outer-end="#111"
                    data-color-needle-circle-inner="#111"
                    data-color-needle-circle-inner-end="#222"
                    data-value-box-border-radius="0"
                    data-color-value-box-rect="#222"
                    data-color-value-box-rect-end="#333"
                    data-font-value="Led"
                    data-font-numbers="Led"
                    data-font-title="Led"
                    data-font-units="Led"
                    ></canvas>
    
                    <!-- 냉동실 -->
                    <canvas data-type="radial-gauge"
                    data-width="400"
                    data-height="400"
                    data-units="°C"
                    data-title="냉동실"
                    data-min-value="-30"
                    data-max-value="30"
                    data-major-ticks="[-30,-20,-10,0,10,20,30]"
                    data-minor-ticks="2"
                    data-stroke-ticks="true"
                    data-highlights='[
                                {"from": -30, "to": -18, "color": "rgba(0, 0, 255, .3)"},
                                {"from": -18, "to": 30, "color": "rgba(255, 0, 0, .3)"}
                            ]'
                    data-ticks-angle="225"
                    data-start-angle="67.5"
                    data-color-major-ticks="#ddd"
                    data-color-minor-ticks="#ddd"
                    data-color-title="#eee"
                    data-color-units="#ccc"
                    data-color-numbers="#eee"
                    data-color-plate="#222"
                    data-border-shadow-width="0"
                    data-borders="true"
                    data-needle-type="arrow"
                    data-needle-width="2"
                    data-needle-circle-size="7"
                    data-needle-circle-outer="true"
                    data-needle-circle-inner="false"
                    data-animation-duration="1500"
                    data-animation-rule="linear"
                    data-color-border-outer="#333"
                    data-color-border-outer-end="#111"
                    data-color-border-middle="#222"
                    data-color-border-middle-end="#111"
                    data-color-border-inner="#111"
                    data-color-border-inner-end="#333"
                    data-color-needle-shadow-down="#333"
                    data-color-needle-circle-outer="#333"
                    data-color-needle-circle-outer-end="#111"
                    data-color-needle-circle-inner="#111"
                    data-color-needle-circle-inner-end="#222"
                    data-value-box-border-radius="0"
                    data-color-value-box-rect="#222"
                    data-color-value-box-rect-end="#333"
                    data-font-value="Led"
                    data-font-numbers="Led"
                    data-font-title="Led"
                    data-font-units="Led"
                    ></canvas>
                </div>
            </div>
        </div>
    </div>

    <footer>
        <!-- <p>@Copyright 2050 by Henesys. All rightss reserved.</p> -->
    </footer>

    <!-- tabulator library -->
    <script type="text/javascript" src="libs/tabulator-master/dist/js/tabulator.js"></script>
    <!-- jquery library -->
    <script src="//ajax.googleapis.com/ajax/libs/jquery/2.1.3/jquery.min.js"></script>
    <!-- canvasJS library -->
    <script src="https://canvasjs.com/assets/script/canvasjs.min.js"></script>
    <!-- custom js files -->
    <script type="text/javascript" src="js/temperature.js"></script>
    <script type="text/javascript" src="js/utils.js"></script>
    
    <script>
        // 생산실적 테이블 생성 및 초기 데이터 받아옴
        var tablePlanList = new Tabulator("#main-table", {
            layout:"fitColumns",
            placeholder:"계획된 작업 無",
            columns:[
                {title:"품목명", field:"prod_name", sorter:"string", headerSort:false, width:"30%", size:"20px"},
                {title:"단위중량", field:"prod_weight", hozAlign:"center", sorter:"string", headerSort:false, width:"11%"},
                {title:"계획수량", field:"count_num", hozAlign:"center", sorter:"string", headerSort:false, width:"12%"},
                // {title:"진행률", field:"per_cent", sorter:"number", formatter:"string", headerSort:false, width:"15%"},
                {title:"완료수량", field:"prdct_qtty", hozAlign:"center", sorter:"string", headerSort:false, width:"12%"},
                {title:"시작", field:"start_time", hozAlign:"center", sorter:"string", headerSort:false, width:"9%"},
                {title:"종료", field:"finish_time", hozAlign:"center", sorter:"string", headerSort:false, width:"9%"},
                {title:"작업상태", field:"work_status", hozAlign:"center", sorter:"string", headerSort:false, width:"13%"}
            ],
            ajaxURL:"/HJFS_MES/DBServiceAgent2.jsp?pid=M030S010000E034&rcvData=''",
            ajaxConfig:"get",
            ajaxLoader:true
        });

        $(document).ready(function(){
            // 생산실적 업데이트
            setInterval(function() {
            	// 현재 제품 개수 확인
            	var prodCount = $(".tabulator-row").length;
            	console.log("현재 제품 개수: " + prodCount);
            	
                // 개별 제품 작업 현황 업데이트
                tablePlanList.replaceData();
                console.log("제품 업데이트 중");
                setTimeout(function() {
                	console.log("1초 딜레이 줬음");
                	// 위에서 확인한 제품 개수보다 많으면 주문이 추가됐다는 뜻이므로 알람
                    var prodCountNew = $(".tabulator-row").length;
                    console.log("업데이트된 제품 개수: " + prodCountNew);
                    if(prodCountNew > prodCount) {
                    	console.log("새로운 주문이 감지되었습니다.");
                    	warningIfNewOrder();
                    }
                    console.log("==============");
                }, 1000*1);
                
                // 품목별 묶음 현황 업데이트
                $.getJSON("/HJFS_MES/DBServiceAgent2.jsp?pid=M030S010000E044&rcvData=''", function(result){
                    var arr = new Array();
 
                    for(var i=0; i<result.length; i++) {
                        var obj = new Object();
                        obj.label = result[i].prod_name;
                        obj.y = Number(result[i].per_cent);
                        arr.push(obj);
                    }

                    var chart = new CanvasJS.Chart("main-chart", {
                        theme: "dark1", // "light2", "dark1", "dark2"
                        animationEnabled: false,
                        title:{
                            text: "제품별 작업 현황",
                            fontfamily: "tahoma",
                            fontColor: "#FFFFFF",
                            padding: 10
                        },
                        axisY: {
                            maximum: 100,
                            minimum: 0
                        },
                        data: [
                        {
                            type: "column",
                            dataPoints: arr,
                            indexLabel: "{y}"+"%"
                        }
                        ]
                    });
                    chart.render();
                });
            }, 1000*3*1);

            // 초기 온도값 받아옴
            $.ajax({
                type: "GET",
                url: "/HJFS_MES/DBServiceAgent.jsp",
                data: "pid=M060S180000E034&rcvData=''",
                success: function (data) {
                    parseAndUpdateDataAndJudgeTemp(data);
                }
            });

            // 화면의 온도를 확인 및 업데이트
            setInterval(function() {
                $.ajax({
                    type: "GET",
                    url: "/HJFS_MES/DBServiceAgent.jsp",
                    data: "pid=M060S180000E034&rcvData=''",
                    success: function (data) {
                        parseAndUpdateDataAndJudgeTemp(data);
                    }
                });
            }, 1000*5*1);
            
            // 한시간 동안 비정상 온도일 시 알람
            for(var i=2; i<4; i++) {    // 온도장비 1~4 (현재는 냉장/냉동실만 체크)
                function timer(j) {
                    setTimeout(function() {
                        setIntervalImmediately(checkTempAndAlert, 1000*60*1, j);
                    }, j*3000);
                };
                timer(i);
            }
            
            // 시간 표시
            setInterval(function(){
                currentTime = getTimeAMPM(new Date);
                document.getElementById("digital-clock").innerHTML = currentTime;
            }, 1000*1);
        });
    </script>
</body>
</html>