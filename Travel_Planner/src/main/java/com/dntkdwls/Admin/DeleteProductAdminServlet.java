package com.dntkdwls.Admin;

import java.io.IOException;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.dntkdwls.dao.ProductDao;
import com.dntkdwls.dto.ProductVo;

@WebServlet("/deleteProductAdmin.do")
public class DeleteProductAdminServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;

	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// 쿼리스트링으로 전달 받은 code 획득
		String code = request.getParameter("code");
						
		// 게시판 삭제 링크 클릭시 삭제할 상품 정보를 표시
		ProductDao pDao = ProductDao.getInstance();	
		ProductVo pVo = new ProductVo();
						
		// 데이터베이스에서 삭제할 데이터 정보 확인
		pVo = pDao.selectProductByCode(code);
						
		request.setAttribute("Product", pVo);
					
		// 페이지 이동 : 삭제 페이지
		RequestDispatcher dispatcher = request.getRequestDispatcher("member/Form2-2.jsp");
		dispatcher.forward(request, response);
	}

	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// 게시판 삭제 코드: 데이터베이스에서 상품 삭제
		ProductDao bDao = ProductDao.getInstance();
		ProductVo bVo = new ProductVo();
		
		// 쿼리스트링으로 전달 받은 code 획득		
		String code = request.getParameter("code");
						
		bDao.deleteProduct(code);
						
		// 삭제 후 목록 페이지로 이동
		response.sendRedirect("adminProductList.do");
	}

}
