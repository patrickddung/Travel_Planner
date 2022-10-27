package com.dntkdwls.Admin;

import java.io.IOException;
import java.io.PrintWriter;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.dntkdwls.dao.ProductDao;
import com.dntkdwls.dto.ProductVo;

@WebServlet("/adminProductDetail.do")
public class AdminProductDetailServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;

	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		request.setCharacterEncoding("UTF-8");
		response.setContentType("text/html; charset=UTF-8");
		PrintWriter out = response.getWriter();
		
		// 쿼리스트링으로 전달 받은 code 획득
		String code = request.getParameter("code");
//		out.println(code);
		
		ProductDao pDao = ProductDao.getInstance();	// 데이터 베이스 연동
		ProductVo pVo = new ProductVo();
		
		// DB에서 해당 code 정보 확인
		pVo = pDao.selectProductByCode(code);
//		System.out.println(bVo);
		
		request.setAttribute("Product", pVo);
		
		// 페이지 이동
		RequestDispatcher dispatcher = request.getRequestDispatcher("member/Form2-4.jsp");
		dispatcher.forward(request, response);
	}

	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

	}

}
