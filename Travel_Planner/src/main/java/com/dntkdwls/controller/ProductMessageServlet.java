package com.dntkdwls.controller;

import java.io.IOException;
import java.io.PrintWriter;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.dntkdwls.dao.ProductDao;
import com.dntkdwls.dto.ProductVo;


@WebServlet("/productmessage.do")
public class ProductMessageServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;

	
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		
	}

	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		request.setCharacterEncoding("UTF-8");
		response.setContentType("text/html; charset=UTF-8");		
		PrintWriter out = response.getWriter();
		
		
		int result = -1;
		String code = request.getParameter("code");
		String message = request.getParameter("message");
		String userid = request.getParameter("userid");
		String user = request.getParameter("user");
		System.out.println("user"+user);
		message = userid +": "+ message;
//		out.println(code);
		
		ProductDao pDao = ProductDao.getInstance();
		ProductVo pVo = new ProductVo();
		
		pVo = pDao.selectProductByCode(code);
		// System.out.println(pVo);
		
		request.setAttribute("product", pVo);
		String getmessage = pVo.getMessage();
		message = getmessage +"`!@#$" +message;
		
		pVo.setMessage(message);
		
		result = pDao.messageProduct(pVo);
		
		System.out.println(pVo);
		
		
		String url = request.getHeader("referer");	
		System.out.println(url);
//		수정후 목록 페이지로 이동
		response.sendRedirect(url);
	}

}
