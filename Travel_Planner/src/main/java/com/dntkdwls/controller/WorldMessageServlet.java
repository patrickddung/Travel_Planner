package com.dntkdwls.controller;

import java.io.IOException;
import java.io.PrintWriter;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.dntkdwls.dao.WorldDao;
import com.dntkdwls.dto.WorldVo;


@WebServlet("/worldmessage.do")
public class WorldMessageServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;


	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		
	}

	
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		request.setCharacterEncoding("UTF-8");
		response.setContentType("text/html; charset=UTF-8");		
		PrintWriter out = response.getWriter();
		
		
		int result = -1;
		String title = request.getParameter("title");
		System.out.println(title);
		String message = request.getParameter("message");
		System.out.println(message);
		String userid = request.getParameter("userid");
		System.out.println(userid);
		message = userid +": "+ message;
		System.out.println(message);
//		out.println(code);
		
		WorldDao wDao = WorldDao.getInstance();
		WorldVo wVo = new WorldVo();
		
		wVo = wDao.selectWorldBytitle(title);
		// System.out.println(pVo);
		
		request.setAttribute("world", wVo);
		String getmessage = wVo.getMessage();
		if(getmessage == null) {
		}else {
			message = getmessage +"`!@#$" +message;
		}
		
		
		wVo.setMessage(message);
		
		result = wDao.messageWorld(wVo);
		
		System.out.println(wVo);
		
		
		String url = request.getHeader("referer");	
		System.out.println(url);
//		수정후 목록 페이지로 이동
		response.sendRedirect(url);
	}

}
