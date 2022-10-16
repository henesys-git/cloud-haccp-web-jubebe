<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page language="java" import="java.sql.*,java.util.*,javax.servlet.http.*"%>
<%@ page import="mes.client.guiComponents.*" %>
<%@ page import="mes.frame.util.*" %>
<%@ page import="mes.client.conf.*" %>




<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/OwlCarousel2/2.3.4/assets/owl.carousel.css"/>
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/OwlCarousel2/2.3.4/assets/owl.theme.default.min.css"/>
<script src="<%=Config.this_SERVER_path%>/AdminLTE-3.0.5/plugins/jquery/jquery.js"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/OwlCarousel2/2.3.4/owl.carousel.js"></script>

<style>
	@font-face {
	    font-family: 'popFontOneStore';
	    src: url('https://cdn.jsdelivr.net/gh/projectnoonnu/noonfonts_2105_2@1.0/ONE-Mobile-POP.woff') format('woff');
	    font-weight: normal;
	    font-style: normal;
	}
	
	html, body {
		height:100%;
		margin:0;
	}
	
	.owl-carousel * {
		font-family:'popFontOneStore';
	}

	.owl-carousel .owl-stage-outer .owl-stage .owl-item { 
		height: 100%; 
	}
	
	.cover_text {
	  height: 80%;
	  width: 80%;
	  text-align: center;
	  box-shadow: 4px 10px 20px rgba(55, 52, 73, 0.4);
	  position: absolute;
	  left: 50%;
	  top: 50%;
	  -webkit-transform: translate(-50%, -50%);
	  transform: translate(-50%, -50%);
	}

	.title_text{
		height: 10vh;
		font-size: 4vw;
		padding-top: 8vh;
	}
	
	.content_text{
		font-size: 4.7vw;
	    height: 70vh;
    	padding: 3vh;
	    display: flex;
	    align-items: center;
	    justify-content: center;
	    line-height:4.7vw;
	    word-break:break-all;
	}
	
	#background {
		position: fixed;
	  	bottom: 0px;
	  	right: 0px;
	  	width: 50%;
	  	height: 100%;
	  	background: #FF7A6C;
	 	-webkit-clip-path: polygon(52% 0, 100% 0, 100% 100%, 0% 100%);
	  	clip-path: polygon(52% 0, 100% 0, 100% 100%, 0% 100%);
	  	z-index: -1;
	  	transition: all 0.8s ease;
	}
</style>
<script type="text/javascript">
	$(document).ready(function(){
		
		function removeData() {
			$(".owl-carousel").empty();
			$(".owl-carousel").owlCarousel('destroy');
		}
		
		async function fetchData() {
			const url = "/notice?registerDatetime=active";
			
			var data = await $.ajax({
			        	url: url,
			        	async: false,
			        	dataType: 'json'
			        }).done(function(response) {
			        	return response;
			        });
			
			console.log(data);
			
			data.forEach(function(item) {
				item.noticeContent = item.noticeContent.replace(/\n/g, "<br />");

				$(".owl-carousel").append(`<div class="cover_text">
										    	<div class="title_text">`+item.noticeTitle+`</div>
										   		<div class="content_text">`+item.noticeContent+`</div>
										  </div>`);
			});
			
			$(".owl-carousel").owlCarousel({
				items: 1,
	            singleItem: true,
				loop: true,
				autoplay: 1000 * 10
			});
		};
		
		fetchData();
		
		setInterval(function() {
			removeData();
			fetchData();
		}, 1000 * 60);
	});
</script>


<div id="background_area" style="height:100%;width:100%;">
	<div id="background"></div>
	<div class="owl-carousel" style="height:100%; width:100%;">
</div>