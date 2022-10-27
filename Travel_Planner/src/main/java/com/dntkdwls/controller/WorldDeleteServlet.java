package com.dntkdwls.controller;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.dntkdwls.dao.WorldDao;
import com.dntkdwls.dto.WorldVo;


@WebServlet("/worldDelete.do")
public class WorldDeleteServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;

	
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// 상품 삭제 코드 : 데이터베이스에서 상품 삭제
		System.out.println("성공");
						
		WorldDao wDao = WorldDao.getInstance();
		WorldVo wVo = new WorldVo();
					
		String title = request.getParameter("title");
		System.out.println("성공");
		// 데이터베이스로 부터 해당 코드의 정보를 삭제
		wDao.deleteWorld(title);
		System.out.println("성공");
//		삭제후 목록 페이지로 이동
		response.sendRedirect("worlduserList.do");
	}

	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		
	}

}
