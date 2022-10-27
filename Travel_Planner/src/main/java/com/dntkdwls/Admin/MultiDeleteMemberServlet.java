package com.dntkdwls.Admin;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.dntkdwls.dao.MemberDao;
import com.dntkdwls.dto.MemberVo;

@WebServlet("/multiDeleteMember.do")
public class MultiDeleteMemberServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;

	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
	
		String[] userid = request.getParameterValues("chk");
				
		
		MemberDao mDao = MemberDao.getInstance();
		MemberVo mVo = new MemberVo();
		
										
		// 회원 삭제 코드: 데이터베이스에서 회원 삭제
		int result = mDao.multiDelete(userid);
//		if(result == userid.length) {
//			System.out.println("체크된 글 모두 삭제 성공");
//			response.sendRedirect("memberList.do");
//		} else {
//			System.out.println("체크된 글 모두 삭제 실패");
//			response.sendRedirect("memberList.do");
//		}
		
		// 페이지 이동
		response.sendRedirect("adminMemberList.do");
		
	}

	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		
	}

}
