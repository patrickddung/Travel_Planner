package com.dntkdwls.Admin;

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

@WebServlet("/adminWorldDetail.do")
public class AdminWorldDetailServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;

	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		request.setCharacterEncoding("UTF-8");
		response.setContentType("text/html; charset=UTF-8");
		PrintWriter out = response.getWriter();
		
		// 쿼리스트링으로 전달 받은 title 획득
		String title = request.getParameter("title");
		
		WorldDao wDao = WorldDao.getInstance();	// 데이터 베이스 연동
		WorldVo wVo = new WorldVo();
		
		// DB에서 해당 title 정보 확인
		wVo = wDao.selectWorldBytitle(title);
		
		request.setAttribute("world", wVo);
		
		// 페이지 이동
		RequestDispatcher dispatcher = request.getRequestDispatcher("member/Form3-4.jsp");
		dispatcher.forward(request, response);
	}

	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

	}

}
