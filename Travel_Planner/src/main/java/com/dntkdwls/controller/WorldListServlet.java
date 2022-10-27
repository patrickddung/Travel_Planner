package com.dntkdwls.controller;

import java.io.IOException;
import java.util.List;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.dntkdwls.dao.WorldDao;
import com.dntkdwls.dto.WorldVo;


@WebServlet("/worldList.do")
public class WorldListServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;

	
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		WorldDao wDao = WorldDao.getInstance();				
		
		// 모든 상품 리스트를 디비로부터 조회하여 저장
//		ProductVo[] productList = pDao.selectAllProduct();
//		System.out.println(productList[0]);		
		List<WorldVo> worldList = wDao.selectAllWorld();		
		request.setAttribute("worldList", worldList);
		System.out.println(worldList);
		
		// 리스트 페이지로 이동
		RequestDispatcher dispatcher = request.getRequestDispatcher("Main_Content/Plan/Index_Plan.jsp");
		dispatcher.forward(request, response);
	}

	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
	
	}

}
