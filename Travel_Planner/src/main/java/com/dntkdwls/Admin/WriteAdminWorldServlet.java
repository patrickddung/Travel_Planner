package com.dntkdwls.Admin;

import java.io.IOException;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import com.dntkdwls.dao.WorldDao;
import com.dntkdwls.dto.WorldVo;

@WebServlet("/writeAdminWorld.do")
public class WriteAdminWorldServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;

	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// 페이지 이동
		RequestDispatcher dispatcher = request.getRequestDispatcher("member/Form3-3.jsp");
		dispatcher.forward(request, response);
	}

	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		request.setCharacterEncoding("UTF-8");
		response.setContentType("text/html; charset=UTF-8");
		
		WorldVo wVo = new WorldVo();
		WorldDao wDao = WorldDao.getInstance();
		
		int result = -1;
		
			
			// 입력 양식을 통해 정보를 획득
		String userid = request.getParameter("userid");
		String continent = request.getParameter("continent");
		String schedule = request.getParameter("schedule");
		String introduce = request.getParameter("introduce");
		String title = request.getParameter("title");
			
		wVo.setUserid(userid);		
		wVo.setContinent(continent);
		wVo.setSchedule(schedule);
		wVo.setIntroduce(introduce);
		wVo.setTitle(title);		// 수정된 상품 정보 bVo에 저장
			
		System.out.println(wVo);
		result = wDao.insertWorld(wVo);	//입력된 게시판 정보 삽입
		
			
		// 정상적인 게시판 등록 여부를 확인 / 정상 등록 메세지를 브라우저 출력 위해 속성값 저장
		if(result == 1) {
			System.out.println("게시판 등록에 성공");
			request.setAttribute("message", "게시판 등록에 성공했습니다.");
		} else {
			System.out.println("게시판 등록에 실패");
			request.setAttribute("message", "게시판 등록에 실패했습니다.");
		}
		response.sendRedirect("adminWorldList.do");	// 게시글 등록 후 리스트 확인 페이지 이동

	} 
	
}


