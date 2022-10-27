package com.dntkdwls.controller;

import java.io.IOException;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.dntkdwls.dao.MemberDao;
import com.dntkdwls.dto.MemberVo;


@WebServlet("/updateMember.do")
public class UpdateMemberServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;

	
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		
//		String userId = "dntkdwls";
		
		String userId = request.getParameter("userId");
		System.out.println("userId: "+userId);
//		MemberDao mDao = new MemberDao();				// 데이터베이스 연동
		MemberDao mDao = MemberDao.getInstance();		// 데이터 베이스 연동
		
		MemberVo mVo = mDao.getMember(userId);			// 데이터베이스 회원정보 로딩
		
//		request.setAttribute("name", mVo.getName());
//		request.setAttribute("id", mVo.getUserid());
//		request.setAttribute("pwd", mVo.getPwd());
//		request.setAttribute("email", mVo.getEmail());
//		request.setAttribute("phone", mVo.getPhone());
//		request.setAttribute("admin", mVo.getAdmin());
		
		request.setAttribute("mVo", mVo);
		System.out.println(mVo.getName());
	

		RequestDispatcher dispatcher;
		dispatcher = request.getRequestDispatcher("member/updateMember.jsp");
		dispatcher.forward(request,response);
	}

	
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// 데이터베이스에 수정된 정보를 업데이트
		request.setCharacterEncoding("UTF-8");			// post 방식 한글 설정
		response.setContentType("text/html; charset=UTF-8");
		
		String name = request.getParameter("name");
		String userid = request.getParameter("userId");
		String pwd = request.getParameter("userPwd");
		String email = request.getParameter("email");
		String phone = request.getParameter("phone");
		String nickname = request.getParameter("nickname");
		String introduce = request.getParameter("introduce");
		String userlatlng = request.getParameter("userlatlng");
		
		System.out.println("name: "+name);		
		System.out.println("userid: "+userid);
		System.out.println("pwd: "+pwd);
		System.out.println("email: "+email);
		System.out.println("phone: "+phone);
		System.out.println("nickname: "+nickname);
		System.out.println("introduce: "+introduce);
		System.out.println("userlatlng: "+userlatlng);
		
		
		
//		MemberDao mDao = new MemberDao();
		MemberDao mDao = MemberDao.getInstance();		// 데이터 베이스 연동
		
		MemberVo mVo = new MemberVo();
		
		mVo.setName(name);
		mVo.setUserid(userid);
		mVo.setPwd(pwd);
		mVo.setEmail(email);
		mVo.setPhone(phone);
		mVo.setNickname(nickname);
		mVo.setIntroduce(introduce);
		mVo.setUserlatlng(userlatlng);
		
		// mVo.setAdmin(Integer.parseInt(admin));
		
		
		mDao.updateMember(mVo);
		
		response.sendRedirect("login.do");		// 로그인 페이지로 다시이동
		
		
	}

}
