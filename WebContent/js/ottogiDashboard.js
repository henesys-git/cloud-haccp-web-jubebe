$(function () {
  'use strict'

  var ticksStyle = {
    fontColor: '#495057',
    fontStyle: 'bold'
  }

  var mode      = 'index'
  var intersect = true

  var $salesChart = $('#ottogi-heating-chart')
  var salesChart  = new Chart($salesChart, {
    type   : 'bar',
    data   : {
      labels  : ['만두동1라인', '만두동2라인', '만두동3라인', '3층라인', '5층라인'],
      datasets: [
        {
          backgroundColor: '#007bff',
          borderColor    : '#007bff',
          data           : [0.2, 0.3, 0.4, 0.5, 0.6]
        },
        {
          backgroundColor: '#ced4da',
          borderColor    : '#ced4da',
          data           : [0.5, 0.6, 0.7, 0.8, 0.9]
        },
		{
          backgroundColor: '#eb3434',
          borderColor    : '#eb3434',
          data           : [1, 1, 1, 1, 1]
        },
		{
          backgroundColor: '#ebdf34',
          borderColor    : '#ebdf34',
          data           : [1.2, 1.2, 1.2, 1.2, 1.2]
        }
      ]
    },
    options: {
      maintainAspectRatio: false,
      tooltips           : {
        mode     : mode,
        intersect: intersect
      },
      hover              : {
        mode     : mode,
        intersect: intersect
      },
      legend             : {
        display: false
      },
      scales             : {
        yAxes: [{
          // display: false,
          gridLines: {
            display      : true,
            lineWidth    : '4px',
            color        : 'rgba(0, 0, 0, .2)',
            zeroLineColor: 'transparent'
          },
          ticks    : $.extend({
            beginAtZero: true,
			suggestedMax: 1.2
            /*// Include a dollar sign in the ticks
            callback: function (value, index, values) {
              if (value >= 1000) {
                value /= 1000
                value += 'k'
              }
              return '$' + value
            }*/

          }, ticksStyle)
        }],
        xAxes: [{
          display  : true,
          gridLines: {
            display: false
          },
          ticks    : ticksStyle
        }]
      }
    }
  })

  var $visitorsChart = $('#ottogi-metal-chart')
  var visitorsChart  = new Chart($visitorsChart, {
    data   : {
      labels  : ['09H', '10H', '11H', '12H', '13H', '14H', '15H'],
      datasets: [{
        type                : 'line',
        data                : [100, 120, 170, 167, 180, 177, 160],
        backgroundColor     : 'transparent',
        borderColor         : '#007bff',
        pointBorderColor    : '#007bff',
        pointBackgroundColor: '#007bff',
        fill                : false
        // pointHoverBackgroundColor: '#007bff',
        // pointHoverBorderColor    : '#007bff'
      },
        {
          type                : 'line',
          data                : [60, 80, 70, 67, 80, 77, 100],
          backgroundColor     : 'tansparent',
          borderColor         : '#ced4da',
          pointBorderColor    : '#ced4da',
          pointBackgroundColor: '#ced4da',
          fill                : false
          // pointHoverBackgroundColor: '#ced4da',
          // pointHoverBorderColor    : '#ced4da'
        },
		{
          type                : 'line',
          data                : [65, 86, 76, 72, 85, 82, 105],
          backgroundColor     : 'tansparent',
          borderColor         : '#eb3434',
          pointBorderColor    : '#eb3434',
          pointBackgroundColor: '#eb3434',
          fill                : false
          // pointHoverBackgroundColor: '#ced4da',
          // pointHoverBorderColor    : '#ced4da'
        },
		{
          type                : 'line',
          data                : [20, 15, 30, 42, 27, 18, 15],
          backgroundColor     : 'tansparent',
          borderColor         : '#ebdf34',
          pointBorderColor    : '#ebdf34',
          pointBackgroundColor: '#ebdf34',
          fill                : false
          // pointHoverBackgroundColor: '#ced4da',
          // pointHoverBorderColor    : '#ced4da'
        },
		{
          type                : 'line',
          data                : [80, 73, 72, 88, 73, 91, 120],
          backgroundColor     : 'tansparent',
          borderColor         : '#3deb34',
          pointBorderColor    : '#3deb34',
          pointBackgroundColor: '#3deb34',
          fill                : false
          // pointHoverBackgroundColor: '#ced4da',
          // pointHoverBorderColor    : '#ced4da'
        },
		{
          type                : 'line',
          data                : [101, 105, 102, 88, 73, 99, 110],
          backgroundColor     : 'tansparent',
          borderColor         : '#ebb134',
          pointBorderColor    : '#ebb134',
          pointBackgroundColor: '#ebb134',
          fill                : false
          // pointHoverBackgroundColor: '#ced4da',
          // pointHoverBorderColor    : '#ced4da'
        }
]
    },
    options: {
      maintainAspectRatio: false,
      tooltips           : {
        mode     : mode,
        intersect: intersect
      },
      hover              : {
        mode     : mode,
        intersect: intersect
      },
      legend             : {
        display: false
      },
      scales             : {
        yAxes: [{
          // display: false,
          gridLines: {
            display      : true,
            lineWidth    : '4px',
            color        : 'rgba(0, 0, 0, .2)',
            zeroLineColor: 'transparent'
          },
          ticks    : $.extend({
            beginAtZero : true,
            suggestedMax: 200
          }, ticksStyle)
        }],
        xAxes: [{
          display  : true,
          gridLines: {
            display: false
          },
          ticks    : ticksStyle
        }]
      }
    }
  })
})
