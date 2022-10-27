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


@WebServlet("/worlddeletemessage.do")
public class WorldDeleteMessageServlet extends HttpServlet {
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
		String usermessage = request.getParameter("Usermessage");
		System.out.println(usermessage);
		
		String usermessage_arr = usermessage.replace("`!@#$", "");
		String usermessage1 = usermessage_arr;
		System.out.println(usermessage1);
		
		
		
//		out.println(code);
		
		WorldDao wDao = WorldDao.getInstance();
		WorldVo wVo = new WorldVo();
		
		wVo = wDao.selectWorldBytitle(title);
		// System.out.println(pVo);
		
		request.setAttribute("world", wVo);
		
		String getmessage = wVo.getMessage();
		System.out.println("겟메세지     "+getmessage);
		
		boolean bool_usermessage = getmessage.contains(usermessage);
		System.out.println(bool_usermessage);
		String setmessage = null;
		
		if(bool_usermessage == true) {
			setmessage = getmessage.replace(usermessage, "");			
		}else {
			setmessage = getmessage.replace(usermessage1, "");						
		}
		System.out.println("셋메세지     "+setmessage);
		
		
		wVo.setMessage(setmessage);
		System.out.println(wVo.getMessage());
		// pVo.setCode(code);
		
		result = wDao.messageWorld(wVo);
		
		System.out.println(wVo);
		
		String url = request.getHeader("referer");	
//		수정후 목록 페이지로 이동
		response.sendRedirect(url);
	}

}
