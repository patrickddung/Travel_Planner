package com.dntkdwls.Admin;

import java.io.IOException;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.dntkdwls.dao.ProductDao;
import com.dntkdwls.dto.ProductVo;

@WebServlet("/searchProductAdmin.do")
public class SearchProductAdminServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;

	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		ProductDao pDao = ProductDao.getInstance();
		
		// 기본 값 설정
		String column = "code";	// 검색 대상(분야)
		String keyword = "";	// 검색 내용(검색어)
		int page = 1;
		// 키워드가 비어 있는 경우를 대비하여 컬럼과 키워드 값 임시 저장
		String t_column = request.getParameter("column");
		String t_keyword = request.getParameter("keyword");
		String t_page = request.getParameter("page");
		// null 값이 아닌 경우,
		if(t_column != null)
			column = t_column;
		if(t_keyword != null) 
			keyword = t_keyword;			
		if(t_page != null) {
			page = Integer.parseInt(t_page);
		}

		
		System.out.println("c: " + column);
		System.out.println("k: " + keyword);
		
		// 컬럼과 키워드를 사용하여 디비로부터 검색한 결과 리스트를 반환하고 전달
		List<ProductVo> ProductList = pDao.getProductList(column, keyword, page);
		request.setAttribute("ProductList", ProductList);
		int count = pDao.getProductCount(column, keyword);
		request.setAttribute("count", count);
		
		
		// 포워드 방식으로 페이지 이동
		request.getRequestDispatcher("member/Form2.jsp").forward(request, response);
	}

	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

	}

}
