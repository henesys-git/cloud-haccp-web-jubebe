package controller;

import java.io.IOException;
import java.io.PrintWriter;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.apache.log4j.Logger;

import dao.MenuDaoImpl;
import model.Menu;
import service.MenuBuildService;
import service.MenuService;
import utils.FormatTransformer;


@WebServlet("/menu")
public class MenuController extends HttpServlet {
	
	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;

	static final Logger logger = 
			Logger.getLogger(MenuController.class.getName());
	
	public void doGet(HttpServletRequest req, HttpServletResponse res) 
			throws ServletException, IOException {
		HttpSession session = req.getSession();
		String tenantId = (String) session.getAttribute("bizNo");
		
		if(tenantId == null) {
			tenantId = req.getParameter("tenantId");
		}
		
		MenuService menuService = new MenuService(new MenuDaoImpl(), tenantId);
		
		MenuBuildService builder = new MenuBuildService(menuService.getMenu());
		
		
		List<Menu> list = builder.buildTree();
		String result = FormatTransformer.toJson(list);
		
		res.setContentType("application/json; charset=UTF-8");
		PrintWriter out = res.getWriter();
		
		out.print(result);
	}

	public void doPost(HttpServletRequest req, HttpServletResponse res) 
			throws ServletException, IOException {
	}
}
