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

import dao.CommonCodeDaoImpl;
import dao.MenuDaoImpl;
import model.CommonCode;
import model.Menu;
import service.CommonCodeService;
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
		String id = req.getParameter("id");
		
		if(tenantId == null) {
			tenantId = req.getParameter("tenantId");
		}
		
		MenuService menuService = new MenuService(new MenuDaoImpl(), tenantId);
		
		String result = "";
		
		if(id != null) {
			
			if(id.equals("all")) {
				List<Menu> list = menuService.getAllMenu();
				result = FormatTransformer.toJson(list);
			}
			else {
				Menu menu = menuService.getMaxMenuId();
				result = FormatTransformer.toJson(menu);
			}
			
		}
		else {
			MenuBuildService builder = new MenuBuildService(menuService.getMenu());
			List<Menu> list = builder.buildTree();
			result = FormatTransformer.toJson(list);
		}
		
		res.setContentType("application/json; charset=UTF-8");
		PrintWriter out = res.getWriter();
		
		out.print(result);
	}

	public void doPost(HttpServletRequest req, HttpServletResponse res) 
			throws ServletException, IOException {
		
		if(req.getParameter("type").equals("insert")) {
			insert(req, res);
		}
		
		if(req.getParameter("type").equals("update")) {
			update(req, res);
		}
		
		if(req.getParameter("type").equals("delete")) {
			delete(req, res);
		}
		
	}
	
	public void insert(HttpServletRequest req, HttpServletResponse res) {
		HttpSession session = req.getSession();
		String tenantId = (String) session.getAttribute("bizNo");
		
		Menu menu = new Menu(
				req.getParameter("id"), 
				req.getParameter("name"),
				Integer.parseInt(req.getParameter("level").toString()),
				req.getParameter("path"),
				req.getParameter("parentId")
				
			);
		
		MenuService menuService = new MenuService(new MenuDaoImpl(), tenantId);
		Boolean inserted = menuService.insert(menu);
		
		res.setContentType("html/text; charset=UTF-8");
		
		try {
			PrintWriter out = res.getWriter();
			out.print(inserted.toString());
		} catch(Exception e) {
			e.printStackTrace();
		}
	}

	public void update(HttpServletRequest req, HttpServletResponse res) {
		HttpSession session = req.getSession();
		String tenantId = (String) session.getAttribute("bizNo");
		
		Menu menu = new Menu(
				req.getParameter("id"), 
				req.getParameter("name"),
				Integer.parseInt(req.getParameter("level").toString()),
				req.getParameter("path"),
				req.getParameter("parentId")
				
			);
		
		MenuService menuService = new MenuService(new MenuDaoImpl(), tenantId);
		Boolean updated = menuService.update(menu);
		
		res.setContentType("html/text; charset=UTF-8");
		
		try {
			PrintWriter out = res.getWriter();
			out.print(updated.toString());
		} catch(Exception e) {
			e.printStackTrace();
		}
	}
	
	public void delete(HttpServletRequest req, HttpServletResponse res) {
		HttpSession session = req.getSession();
		String tenantId = (String) session.getAttribute("bizNo");
		
		String menuId = req.getParameter("id");
		
		MenuService menuService = new MenuService(new MenuDaoImpl(), tenantId);
		Boolean deleted = menuService.delete(menuId);
		
		res.setContentType("html/text; charset=UTF-8");
		
		try {
			PrintWriter out = res.getWriter();
			out.print(deleted.toString());
		} catch(Exception e) {
			e.printStackTrace();
		}
		
	}
}
