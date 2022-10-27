package com.dntkdwls.Admin;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.dntkdwls.dao.WorldDao;
import com.dntkdwls.dto.WorldVo;

@WebServlet("/multiDeleteWorld.do")
public class MultiDeleteWorldServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;

	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
	
	
		WorldDao wDao = WorldDao.getInstance();
		WorldVo wVo = new WorldVo();
		
		// 쿼리스트링으로 전달 받은 다중 체크박스 목록획득
		String[] title = request.getParameterValues("chk");
		// 회원 삭제 코드: 데이터베이스에서 회원 삭제
		int result = wDao.multiDelete(title);
		
		// 페이지 이동
		response.sendRedirect("adminWorldList.do");
	}

	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

	}

}
