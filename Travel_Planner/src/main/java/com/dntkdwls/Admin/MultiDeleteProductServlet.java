package com.dntkdwls.Admin;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.dntkdwls.dao.ProductDao;
import com.dntkdwls.dto.ProductVo;

@WebServlet("/multiDeleteProduct.do")
public class MultiDeleteProductServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;

	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		String[] code = request.getParameterValues("chk");

		ProductDao pDao = ProductDao.getInstance();
		ProductVo pVo = new ProductVo();
										
		// 게시글 삭제 코드: 데이터베이스에서 회원 삭제
		int result = pDao.multiDelete(code);
//		if(result == code.length) {
//			System.out.println("체크된 글 모두 삭제 성공");
//			response.sendRedirect("memberList.do");
//		} else {
//			System.out.println("체크된 글 모두 삭제 실패");
//			response.sendRedirect("memberList.do");
//		}
		// 페이지 이동
		response.sendRedirect("adminProductList.do");
	}

	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

	}

}
