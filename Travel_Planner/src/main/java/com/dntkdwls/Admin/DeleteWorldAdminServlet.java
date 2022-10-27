package com.dntkdwls.Admin;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.dntkdwls.dao.WorldDao;
import com.dntkdwls.dto.WorldVo;

@WebServlet("/deleteWorldAdmin.do")
public class DeleteWorldAdminServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;

	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// 게시판 삭제 코드: 데이터베이스에서 상품 삭제
		WorldDao wDao = WorldDao.getInstance();
		WorldVo wVo = new WorldVo();
		
		// 쿼리스트링으로 전달 받은 title 획득
		String title = request.getParameter("title");
		
		// DB에서 해당 title 정보 삭제
		wDao.deleteWorld(title);
										
		// 삭제 후 목록 페이지로 이동
		response.sendRedirect("adminWorldList.do");
	}

	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		
	}

}
