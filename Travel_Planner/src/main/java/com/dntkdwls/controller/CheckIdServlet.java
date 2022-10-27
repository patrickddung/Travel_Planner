package com.dntkdwls.controller;

import java.io.IOException;


import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.dntkdwls.dao.MemberDao;

@WebServlet("/checkId.do")
public class CheckIdServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;

	
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		
		String userid = request.getParameter("userid");
		
		// 입력한 아이디를 DB에서 조회하여 동일한 아이디가 없는지 확인
//		MemberDao mDao = new MemberDao();
		MemberDao mDao = MemberDao.getInstance();		// 데이터 베이스 연동
		
		int result = mDao.confirmID(userid);
		
//		result => (-1)사용가능, (1)사용불가능
		if(result==1) {
			request.setAttribute("message", " 아이디 사용이 불가능합니다.");
		}else {
			request.setAttribute("message1", " 아이디 사용이 가능합니다.");
		}
		
		
		request.setAttribute("userid", userid);
		request.setAttribute("result", result);
		
		
		RequestDispatcher dispatcher;
		dispatcher = request.getRequestDispatcher("member/checkId.jsp");
		dispatcher.forward(request,response);
	}

	
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
	
	}

}
