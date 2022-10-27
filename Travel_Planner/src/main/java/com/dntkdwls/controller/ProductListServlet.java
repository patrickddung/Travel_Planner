package com.dntkdwls.controller;

import java.io.IOException;
import java.util.List;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.dntkdwls.dao.ProductDao;
import com.dntkdwls.dto.ProductVo;


@WebServlet("/productList.do")
public class ProductListServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;

	
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		ProductDao pDao = ProductDao.getInstance();				
		
		// 모든 상품 리스트를 디비로부터 조회하여 저장
//		ProductVo[] productList = pDao.selectAllProduct();
//		System.out.println(productList[0]);		
		List<ProductVo> productList = pDao.selectAllProduct();		
		request.setAttribute("productList", productList);
		System.out.println(productList);
		
		// 리스트 페이지로 이동
		RequestDispatcher dispatcher = request.getRequestDispatcher("Main_Content/Photo/Index_Photo.jsp");
		dispatcher.forward(request, response);
		
		
	}

	
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		
	}

}
