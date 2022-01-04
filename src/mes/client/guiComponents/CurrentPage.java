package mes.client.guiComponents;

public class CurrentPage {
	String PageName[];
	public String fName;
	
	public CurrentPage(String RequestURI) {
		PageName = RequestURI.split("/");
	}
	public String GetJSP_FileName() {
		
		String dddd = PageName[PageName.length-1];
		fName = dddd.substring(0, dddd.indexOf("."));
		String extName = dddd.substring(dddd.indexOf(".")+1);
		
		return (fName + "." + extName.toLowerCase() );
	}
}
