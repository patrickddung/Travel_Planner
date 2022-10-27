package com.dntkdwls.Admin;

import java.io.IOException;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.dntkdwls.dao.MemberDao;
import com.dntkdwls.dto.MemberVo;


@WebServlet("/searchMember.do")
public class SearchMemberServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;

	
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		MemberDao mDao = MemberDao.getInstance();
		MemberVo mVo = new MemberVo();
		
		// 기본 값 설정
		String column = "userid";
		String keyword = "";
		int page = 1;
		
		// 키워드가 비어 있는 경우를 대비하여 컬럼과 키워드 값 임시 저장
		String t_column = request.getParameter("column");
		String t_keyword = request.getParameter("keyword");
		String t_page = request.getParameter("p");
	
		// null 값이 아닌 경우,
		if(t_column != null){
			column = t_column;				
		}
		if(t_keyword != null){
			keyword = t_keyword;					
		}
		if(t_page !=null) {
			page = Integer.parseInt(t_page);
		}
		
		System.out.println("u: " + column);
		System.out.println("n: " + keyword);
		
		// 컬럼과 키워드를 사용하여 디비로부터 검색한 결과 리스트를 반환하고 전달
		List<MemberVo> memberList = mDao.getMemberList(column, keyword, page);
		request.setAttribute("memberList", memberList);
		int count = mDao.getMemberCount(column,keyword);
		request.setAttribute("count", count);
		
		// 페이지 이동
		request.getRequestDispatcher("member/Form.jsp").forward(request, response);
	}

	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

	}
	

}
