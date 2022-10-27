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


@WebServlet("/worldmap.do")
public class WorldMapServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;

	
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// 세션 설정
		HttpSession session = request.getSession();		// 생성된 세션 객체 호출
		Object loginUser = session.getAttribute("loginUser");
		Object name = session.getAttribute("name");
		session.removeAttribute("settitle");
		
		
		
		System.out.println(loginUser);
		System.out.println(name);
		
		
//		MemberDao mDao = new MemberDao();				// 데이터베이스 연동
//		MemberDao mDao = MemberDao.getInstance();		// 데이터 베이스 연동
		
		// MemberVo mVo = mDao.getMember(id);			// 데이터베이스 회원정보 로딩
				
		// request.setAttribute("name", mVo.getName());
//		request.setAttribute("id", mVo.getUserid());
//	    request.setAttribute("pwd", mVo.getPwd());
//		request.setAttribute("email", mVo.getEmail());
//		request.setAttribute("phone", mVo.getPhone());
//		request.setAttribute("nickname", mVo.getNickname());
//		request.setAttribute("introduce", mVo.getIntroduce());
//		request.setAttribute("userlatlng", mVo.getUserlatlng());
		
		 
		
		
		
		RequestDispatcher dispatcher;
		dispatcher = request.getRequestDispatcher("Main_Content/map/Index_WorldMap.jsp");
		dispatcher.forward(request,response);
	}

	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		
	}

}
