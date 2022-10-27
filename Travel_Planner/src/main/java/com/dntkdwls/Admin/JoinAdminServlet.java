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

@WebServlet("/joinAdmin.do")
public class JoinAdminServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;

	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// 페이지 이동
		RequestDispatcher dispatcher = request.getRequestDispatcher("member/Form-3.jsp");
		dispatcher.forward(request, response);
	}

	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		request.setCharacterEncoding("UTF-8");
		response.setContentType("text/html; charset=UTF-8");
		PrintWriter out = response.getWriter();	// 웹페이지 출력 처리
		
		// 입력 양식을 통해 정보를 획득
		String name = request.getParameter("name");			// 입력양식으로부터 이름 획득
		String userid = request.getParameter("userId");
		String pwd = request.getParameter("pwd");
		String email = request.getParameter("email");
		String phone = request.getParameter("phone");
		String nickname =request.getParameter("nickname");
		String introduce =request.getParameter("introduce");
		String userlatlng =request.getParameter("userlatlng");
			
		MemberDao mDao = MemberDao.getInstance();
		
		MemberVo mVo = new MemberVo();
				
		mVo.setName(name);						// MmeberVo 클래스에 정보 저장
		mVo.setUserid(userid);
		mVo.setPwd(pwd);
		mVo.setEmail(email);
		mVo.setPhone(phone);
		mVo.setNickname(nickname);
		mVo.setIntroduce(introduce);
		mVo.setUserlatlng(userlatlng);
			
		System.out.println(mVo);
		
		// 데이터 베이스로 부터 해당 코드의 정보를 추가
		int result = mDao.insertMember(mVo);
		// 회원가입 성공 여부
		if (result == 1) {
			System.out.println("회원가입 성공");
			response.sendRedirect("memberList.do");
		} else {
			System.out.println("회원가입 실패");
		}

	
	}

}
