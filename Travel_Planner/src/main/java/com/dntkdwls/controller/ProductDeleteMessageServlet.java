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


@WebServlet("/productdeletemessage.do")
public class ProductDeleteMessageServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;

	
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		
	}

	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		request.setCharacterEncoding("UTF-8");
		response.setContentType("text/html; charset=UTF-8");		
		PrintWriter out = response.getWriter();
		
		
		int result = -1;
		String code = request.getParameter("code");
		System.out.println(code);
		String usermessage = request.getParameter("Usermessage");
		System.out.println(usermessage);
		
		String usermessage_arr = usermessage.replace("`!@#$", "");
		String usermessage1 = usermessage_arr;
		System.out.println(usermessage1);
		
		
		
//		out.println(code);
		
		ProductDao pDao = ProductDao.getInstance();
		ProductVo pVo = new ProductVo();
		
		pVo = pDao.selectProductByCode(code);
		// System.out.println(pVo);
		
		request.setAttribute("product", pVo);
		
		String getmessage = pVo.getMessage();
		System.out.println("겟메세지     "+getmessage);
		
		boolean bool_usermessage = getmessage.contains(usermessage);
		System.out.println(bool_usermessage);
		String setmessage = null;
		
		if(bool_usermessage == true) {
			setmessage = getmessage.replace(usermessage, "");			
		}else {
			setmessage = getmessage.replace(usermessage1, "");						
		}
		System.out.println("셋메세지     "+setmessage);
		
		
		pVo.setMessage(setmessage);
		System.out.println(pVo.getMessage());
		// pVo.setCode(code);
		
		result = pDao.messageProduct(pVo);
		
		System.out.println(pVo);
		
		String url = request.getHeader("referer");	
//		수정후 목록 페이지로 이동
		response.sendRedirect(url);
	}

}
