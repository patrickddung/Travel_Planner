package com.dntkdwls.controller;

import java.io.IOException;
import java.util.List;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import com.dntkdwls.dao.WorldDao;
import com.dntkdwls.dto.WorldVo;


@WebServlet("/worlduserList.do")
public class WorldUserListServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;

	
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
				
		
		HttpSession session = request.getSession();
		String userid = (String) session.getAttribute("id");
		System.out.println(userid);
		
		// 모든 상품 리스트를 디비로부터 조회하여 저장
//		ProductVo[] productList = pDao.selectAllProduct();
//		System.out.println(productList[0]);		
		WorldDao wDao = WorldDao.getInstance();
		
		List<WorldVo> worldList = wDao.selectWorldByuserid(userid);		
		request.setAttribute("worldUserList", worldList);
		System.out.println(worldList);
		
		// 리스트 페이지로 이동
		RequestDispatcher dispatcher = request.getRequestDispatcher("Main_Content/userworld/App_WorldList.jsp");
		dispatcher.forward(request, response);
		
		
	}

	
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		
		
	}

}
