package com.dntkdwls.Admin;

import java.io.IOException;
import java.util.List;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.dntkdwls.dao.ProductDao;
import com.dntkdwls.dto.MemberVo;
import com.dntkdwls.dto.ProductVo;


@WebServlet("/adminProductList.do")
public class AdminProductListServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;

	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		ProductDao pDao = ProductDao.getInstance();
		ProductVo pVo = new ProductVo();
		
		// 기본 값 설정 (검색, 페이지)
		int page = 1;
		
		// 검색 입력 양식으로 부터 받은 검색 대상과 내용을 가져옴
		String t_page = request.getParameter("p");

		//검색 대상, 내용이 null이거나 ""이 아니라면, 사용
		if(t_page !=null && !t_page.equals("")) {
			page = Integer.parseInt(t_page);
		}
		
		// 컬럼과 키워드를 사용하여 DB로부터 검색한 결과 리스트를 반환하고 전달
		int count = pDao.getProductCount();	// 전체 게시물 수
		List<ProductVo> ProductList = pDao.getProductList(page);	// 하나의 페이지에 표시할 데이터
		request.setAttribute("ProductList", ProductList);
		request.setAttribute("count", count);
		
		// 페이지 이동
		RequestDispatcher dispatcher = 
				request.getRequestDispatcher("member/Form2.jsp");
		dispatcher.forward(request, response);
	}

	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

	}

}
