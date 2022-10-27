package com.dntkdwls.Admin;

import java.io.IOException;
import java.io.PrintWriter;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.dntkdwls.dao.MemberDao;
import com.dntkdwls.dto.MemberVo;

@WebServlet("/adminMemberDetail.do")
public class AdminMemberDetailServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;

	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		request.setCharacterEncoding("UTF-8");
		response.setContentType("text/html; charset=UTF-8");
		PrintWriter out = response.getWriter();
		
		// 쿼리스트링으로 전달 받은 code 획득
		String userId = request.getParameter("userid");
		
		MemberDao mDao = MemberDao.getInstance();	// 데이터 베이스 연동
		MemberVo mVo = new MemberVo();
		
		// DB에서 userid 확인
		mVo = mDao.getMember(userId);
		
		request.setAttribute("member", mVo);
		
		// 페이지 이동
		RequestDispatcher dispatcher = request.getRequestDispatcher("member/Form-4.jsp");
		dispatcher.forward(request, response);
	}

	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

	}

}
