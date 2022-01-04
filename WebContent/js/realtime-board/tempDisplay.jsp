<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@page import="org.json.simple.JSONObject"%>
<!DOCTYPE html>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <title>온도 현황</title>
    <link rel="stylesheet" href="libs/canvas-gauges-master/fonts/fonts.css">
    <script src="libs/canvas-gauges-master/gauge.min.js"></script>
    <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.5.1/jquery.min.js"></script>
    <script src="https://unpkg.com/sweetalert/dist/sweetalert.min.js"></script>
	
    <style>
        header { color: white; text-align: center;}
        #title { font-size: 5vw; }
        #digital-clock { font-size: 4vw; }

        .main .content { text-align: center; }

        .swal-overlay {
            background-color: rgba(255,0,0,0.3);
        }
    </style>
</head>

<body style="background: #222">
    <header>
        <div class="wrap">
            <div class="content">
                <div id="title">온도 현황판</div>
                <div id="digital-clock"></div>
                <hr>
            </div>
        </div>
    </header>

    <audio id="alertsound" src="sound/beep.wav" muted></audio>

    <div class="main">
        <div class="wrap">
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
                            {"from": -5, "to": 2, "color": "rgba(0, 0, 255, .3)"},
                            {"from": 2, "to": 30, "color": "rgba(255, 0, 0, .3)"}
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

	<script>
        let minValues = ['-1', '-1', '-5', '-30']; // 작업장,양념실,냉장실,냉동실 최소 적정온도
        let maxValues = ['14', '14', '2', '-18'];  // 작업장,양념실,냉장실,냉동실 최대 적정온도
        let workAreaList = ['작업장', '양념실', '냉장실', '냉동실'];
        
        $(document).ready(function(){
            // retrieve initial temperature
            $.ajax({
                type: "GET",
                url: "../DBServiceAgent.jsp",
                data: "pid=M060S180000E034&rcvData=''",
                success: function (data) {
                    splittedData = data.trim().split('\n');
                    
                    var arr = [];
                    for(var i in splittedData) {
                        arr.push(splittedData[i].split("\t"));
                    }
                    
                    gaugeList = document.gauges;
                    for(var i=0; i<gaugeList.length; i++) {
                        gaugeList[i].value = arr[i][1];
                        judgeTemp(i);
                    }
                },
                error: function (xhr, option, error) {
                }
            });

            // Check and update temperature on screen
            setInterval(function() {
                $.ajax({
                    type: "GET",
                    url: "../DBServiceAgent.jsp",
                    data: "pid=M060S180000E034&rcvData=''",
                    success: function (data) {
                        splittedData = data.trim().split('\n');

                        var arr = [];
                        for(var i in splittedData) {
                            arr.push(splittedData[i].split("\t"));
                        }
                        
                        gaugeList = document.gauges;
                        for(var i=0; i<gaugeList.length; i++) {
                            gaugeList[i].value = arr[i][1];
                            judgeTemp(i);
                        }
                    },
                    error: function (xhr, option, error) {
                    }
                });
            }, 1000*5*1);
            
            // Alert if non-standard temperature lasts for one hour
            for(var i=0; i<4; i++) {                        // temperature device 1~4
                function timer(j) {
                    setTimeout(function() {
                        //setInterval(firstCheckValue, 1000*60*1, j); // one hour interval
                        setIntervalImmediately(firstCheckValue, 1000*60*1, j);
                    }, j*3000);
                };
                timer(i);
            }
            
            // Display date&time
            setInterval(function(){
                currentTime = getDateTime();
                document.getElementById("digital-clock").innerHTML = currentTime;
            }, 1000*1);
        });
        
        // Check temperature and change circle color as red or blue in the gauge
        function judgeTemp(index) {
                var gauge = gaugeList[index];
        
                // this will draw red or blue circle on a gauge plate depending on
                // current value
                gauge.on('beforeNeedle', function () {
                    // getting canvas 2d drawing context
                    var context = this.canvas.context;

                    // we can use gauge context special 'max' property which represents
                    // gauge radius in a real pixels and calculate size of relative pixel
                    // for our drawing needs
                    var pixel = context.max / 100;
        
                    // step out our circle center coordinate by 30% of its radius from
                    // gauge center
                    var centerX = 30 * pixel;
        
                    // stay in center by Y-coordinate
                    var centerY = 0;
        
                    // use circle radius equal to 5%
                    var radius = 5 * pixel;
        
                    // save previous context state
                    context.save();
        
                    // draw circle using canvas JS API
                    context.beginPath();
                    context.arc(centerX, centerY, radius, 0, 2 * Math.PI, false);
        
                    var gradient = context.createRadialGradient(
                        centerX, centerY, 0,
                        centerX, centerY, radius);
                    gradient.addColorStop(0, this.options.value >= minValues[index] && 
                                             this.options.value <= maxValues[index] ? '#aaf' : '#faa');
                    gradient.addColorStop(0.82, this.options.value >= minValues[index] && 
                                                this.options.value <= maxValues[index] ? '#00f' : '#f00');
                    gradient.addColorStop(1, this.options.value >= minValues[index] && 
                                             this.options.value <= maxValues[index] ? '#88a' : '#a88');
        
                    context.fillStyle = gradient;
                    context.fill();
                    context.closePath();
        
                    // restore previous context state to prevent break of
                    // further drawings
                    context.restore();
                });
        
                // redraw the gauge if it has been already drawn
                gauge.draw();
        }
        
        function getDateTime() {
            var now     = new Date(); 
            var year    = now.getFullYear();
            var month   = now.getMonth()+1; 
            var day     = now.getDate();
            var hour    = now.getHours();
            var minute  = now.getMinutes();
            var second  = now.getSeconds(); 
            if(month.toString().length == 1) {
                month = '0'+month;
            }
            if(day.toString().length == 1) {
                day = '0'+day;
            }   
            if(hour.toString().length == 1) {
                hour = '0'+hour;
            }
            if(minute.toString().length == 1) {
                minute = '0'+minute;
            }
            if(second.toString().length == 1) {
                second = '0'+second;
            }   
            var dateTime = year+'/'+month+'/'+day+' '+hour+':'+minute+':'+second;
            return dateTime;
        }

        function firstCheckValue(index) {
            console.log("started checking device"+index);
            var gauge = document.gauges;
            var firstResult = gauge[index].value < minValues[index] || gauge[index].value > maxValues[index] ? true : false;
            console.log("1stResult"+index+" " + firstResult);

            setTimeout(function() {
                if(firstResult == true){
                    var gauge = document.gauges;
                    var secondResult = gauge[index].value < minValues[index] || gauge[index].value > maxValues[index] ? true : false;
                    
                    if(secondResult == true) {
                        console.log("device"+index+"   beep!! beep!!");
                        warningIfTempNotMatch(index);
                    } else {
                        console.log("device"+index+"   first check failed but second check passed fortunately");
                        return; // do nothing
                    }
                } else {
                    console.log("device"+index+"   first check passed");
                    return; // do nothing   
                }
            }, 1000*55*1);
        }

        function warningIfTempNotMatch(index) {
            console.log("index checking : " + index);
            beep();
            swal({
                title: workAreaList[index],
                text: "온도 확인 요망",
                icon: "warning",
                button: false,
                timer: 2000
            });
        }
        
        function beep() {
            var snd = new Audio("sound/beep.wav");
            snd.play();
        }

        function setIntervalImmediately(func, interval, index) {
            func(index);
            return setInterval(func, interval, index);
        }
    </script>
</body>
</html>