/**
 * 
 */

/*
	자바스크립트 파일을 로드
*/
function loadJs(js) {    
    //selecting js file
    var jsSection = document.querySelector('script[src="'+js+'"]');

    //selecting parent node to remove js and add new js 
    var parent = jsSection.parentElement;
    //deleting js file
    parent.removeChild(jsSection);

    //creating new js file 
    var script= document.createElement('script');
    script.type= 'text/javascript';
    script.src= js;

    //adding new file in selected tag.
    parent.appendChild(script);
}