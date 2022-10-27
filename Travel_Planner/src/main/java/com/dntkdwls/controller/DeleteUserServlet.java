package com.dntkdwls.controller;

import java.io.IOException;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import com.dntkdwls.dao.MemberDao;
import com.dntkdwls.dto.MemberVo;


@WebServlet("/deleteuser.do")
public class DeleteUserServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;

	
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		
	}

	
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// 회원 삭제 코드: 데이터베이스에서 상품 삭제
		MemberDao mDao = MemberDao.getInstance();
		MemberVo mVo = new MemberVo();
										
		String userid = request.getParameter("userid");
		System.out.println(userid);
										
		mDao.deleteMember(userid);
										
		// 세션을 사용하는 경우
		HttpSession session = request.getSession();
		session.invalidate();	// 세션 종료
				
				
		// 페이지 이동 : 로그인 
//		response.sendRedirect("member/login.jsp");	// 리다이렉트 방식
		RequestDispatcher dispatcher = request.getRequestDispatcher("member/login.jsp");
		dispatcher.forward(request, response);	
	}

}
