let minValues = ['-1', '-1', '-5', '-30']; // 작업장,양념실,냉장실,냉동실 최소 적정온도
let maxValues = ['14', '14', '5', '-18'];  // 작업장,양념실,냉장실,냉동실 최대 적정온도
let workAreaList = ['작업장', '양념실', '냉장실', '냉동실'];

// Check temperature and change circle color as red or blue in the gauge
function judgeTemp(index) {
    var gauge = gaugeList[index];

    // this will draw red or blue circle on a gauge plate 
    // depending on current value
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

function checkTempAndAlert(index) {
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
    beep("sound/beep.wav");
    swal({
        title: workAreaList[index],
        text: "온도 확인 요망",
        icon: "warning",
        button: false,
        timer: 2000
    });
}

function warningIfNewOrder() {
    console.log("new order alert!!");
    beep("sound/newOrderAlert.wav");
    swal({
        title: "알림",
        text: "새로운 주문이 들어왔습니다.",
        icon: "warning",
        button: false,
        timer: 2000
    });
}

function beep(filePath) {
    var snd = new Audio(filePath);
    snd.play();
}

function setIntervalImmediately(func, interval, index) {
    func(index);
    return setInterval(func, interval, index);
}

function parseAndUpdateDataAndJudgeTemp(data) {
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
}