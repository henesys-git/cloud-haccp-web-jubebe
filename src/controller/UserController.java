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

import dao.UserDaoImpl;
import model.User;
import service.UserService;
import utils.FormatTransformer;


@WebServlet("/user")
public class UserController extends HttpServlet {
	
	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;

	static final Logger logger = 
			Logger.getLogger(UserController.class.getName());
	
	public void doGet(HttpServletRequest req, HttpServletResponse res) 
			throws ServletException, IOException {
		HttpSession session = req.getSession();
		String tenantId = (String) session.getAttribute("bizNo");
		
		if(tenantId == null) {
			tenantId = req.getParameter("bizNo");
		}
		
		String id = req.getParameter("id");
		
		UserService userService = new UserService(new UserDaoImpl(), tenantId);
		
		String result = "";
		
		if(id.equals("all")) {
			List<User> list = userService.getAllUsers();
			result = FormatTransformer.toJson(list);
		} 
		else if(id.equals("id-overlap")) {
			User user = userService.getOverlapId(id);
			result = FormatTransformer.toJson(user);
		}
		else {
			User user = userService.getUser(id);
			result = FormatTransformer.toJson(user);
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
		
		if(req.getParameter("type").equals("updateAuthority")) {
			updateAuthority(req, res);
		}
		
		if(req.getParameter("type").equals("delete")) {
			delete(req, res);
		}
		
	}
	
	public void insert(HttpServletRequest req, HttpServletResponse res) {
		HttpSession session = req.getSession();
		String tenantId = (String) session.getAttribute("bizNo");
		
		User user = new User(
				req.getParameter("id"), 
				req.getParameter("name"),
				req.getParameter("password"),
				req.getParameter("authority")
			);
		
		UserService userService = new UserService(new UserDaoImpl(), tenantId);
		Boolean inserted = userService.insert(user);
		
		res.setContentType("html/text; charset=UTF-8");
		
		try {
			PrintWriter out = res.getWriter();
			out.print(inserted.toString());
		} catch(Exception e) {
			e.printStackTrace();
		}
	}

	public void updateAuthority(HttpServletRequest req, HttpServletResponse res) {
		HttpSession session = req.getSession();
		String tenantId = (String) session.getAttribute("bizNo");
		
		User user = new User(
						req.getParameter("id"),
						req.getParameter("name"), 
						req.getParameter("authority")
					);
		
		UserService userService = new UserService(new UserDaoImpl(), tenantId);
		Boolean updated = userService.updateAuthority(user);
		
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
		
		String userId = req.getParameter("id");
		
		UserService userService = new UserService(new UserDaoImpl(), tenantId);
		Boolean deleted = userService.delete(userId);
		
		res.setContentType("html/text; charset=UTF-8");
		
		try {
			PrintWriter out = res.getWriter();
			out.print(deleted.toString());
		} catch(Exception e) {
			e.printStackTrace();
		}
		
	}

}
