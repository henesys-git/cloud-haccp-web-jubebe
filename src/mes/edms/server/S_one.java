package mes.edms.server;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletResponse;

public class S_one extends HttpServlet {   	
	


	public HttpServletResponse setAllowOrigin(HttpServletResponse response) {
        
        //response.setHeader("Access-Control-Allow-Methods", "POST, GET, OPTIONS, DELETE");
        response.setHeader("Access-Control-Allow-Methods", "POST, GET");
        response.setHeader("Access-Control-Max-Age", "3600");
        response.setHeader("Access-Control-Allow-Headers", "x-requested-with");
        response.setHeader("Access-Control-Allow-Origin", "*");

        return response ;
    }	
	@Override
	public void init() throws ServletException {
		super.init();
		System.out.println("started S_one Servlet");
		(new Thread(new ScheduleExecTest())).start();
		
	}

}




