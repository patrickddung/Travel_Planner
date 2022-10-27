package com.dntkdwls.controller;

import java.io.IOException;
import java.io.PrintWriter;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.dntkdwls.dao.WorldDao;
import com.dntkdwls.dto.WorldVo;


@WebServlet("/worldDetail.do")
public class WorldDetailServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;

	
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		request.setCharacterEncoding("UTF-8");
		response.setContentType("text/html; charset=UTF-8");		
		PrintWriter out = response.getWriter();
		
		String title = request.getParameter("title");
//		out.println(code);
		
		WorldDao wDao = WorldDao.getInstance();
		WorldVo wVo = new WorldVo();
		
		wVo = wDao.selectWorldBytitle(title);
		// System.out.println(pVo);
		
		request.setAttribute("world", wVo);
		System.out.println(wVo);
		System.out.println(title);
		
		
		RequestDispatcher dispatcher = request.getRequestDispatcher("Main_Content/map/worldDetail.jsp");
		dispatcher .forward(request, response);
	}

	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		
	}

}
