package com.dntkdwls.controller;

import java.io.IOException;
import java.io.PrintWriter;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletContext;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import com.dntkdwls.dao.ProductDao;
import com.dntkdwls.dao.WorldDao;
import com.dntkdwls.dto.ProductVo;
import com.dntkdwls.dto.WorldVo;
import com.oreilly.servlet.MultipartRequest;
import com.oreilly.servlet.multipart.DefaultFileRenamePolicy;


@WebServlet("/joinmap.do")
public class JoinMapServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;

	
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		RequestDispatcher dispatcher;
		dispatcher = request.getRequestDispatcher("Main_Content/map/App_map.jsp");
		dispatcher.forward(request,response);
	}

	
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		request.setCharacterEncoding("UTF-8");
		response.setContentType("text/html; charset=UTF-8");
		
		WorldDao wDao = WorldDao.getInstance();	
		WorldVo wVo = new WorldVo();
		
		
		int result = -1;
		String savePath = "upload";
		ServletContext context = getServletContext();				// 이 서블릿이 실행되고 있는 컨택스트 가져오기
		String uploadFilePath = context.getRealPath(savePath);		// 실제 경로를 리턴
		System.out.println("저장파일 서버경로: " + uploadFilePath);
		int uploadFileSizeLimit = 5 * 1024 * 1024;
		String encType = "UTF-8";
		
		String title = null;
				
		
		
		
		
		try {
			MultipartRequest multi = new MultipartRequest(
				request,							// request 객체
				uploadFilePath,						// 서버상의 실제 디렉토리
				uploadFileSizeLimit,				// 최대 업로드 파일 크기 
				encType,							// 인코딩 방식
				new DefaultFileRenamePolicy()		// 정책: 동일 이름 존재시, 새로운 이름 부여
			);	
			// 입력 양식을 통해 정보를 획득
			String userid = multi.getParameter("userid");
			title = multi.getParameter("title");
			System.out.println("title: "+ title);
			String introduce = multi.getParameter("description");
			System.out.println(introduce);
			String continent = multi.getParameter("continent");	
			System.out.println("경로는" + continent);
			String schedule = multi.getParameter("schedule");
			String pictureurl = multi.getFilesystemName("pictureurl");	
			
			
			// pVo.setCode(code);			// 입력된 상품 정보 저장
			wVo.setUserid(userid);
			wVo.setContinent(continent);
			wVo.setSchedule(schedule);
			wVo.setIntroduce(introduce);
			wVo.setTitle(title);
			wVo.setPictureurl(pictureurl);
			wVo.setMessage("");
			
		}catch(Exception e) {
			System.out.println("파일 업로드간 예외 발생" + e);
		}
		System.out.println(wVo);
		// 세션 설정
		HttpSession session = request.getSession();		// 생성된 세션 객체 호출
		session.removeAttribute("settitle");
		session.setAttribute("settitle", title);
		
		result = wDao.insertWorld(wVo);
		
		// 정상적인 상품 등록 여부를 확인 / 정상 등록 메세지를 브라우저 출력 위해 속성값 저장
		if(result == 1) {
			// 상품 등록 완료 시, 메시지 출력
			System.out.println("일정 등록에 성공");
			response.sendRedirect("main.jsp");
//			request.setAttribute("message", "상품 등록에 성공했습니다.");
		} else {
			System.out.println("일정 등록에 실패");
			response.sendRedirect("joinmap.do");
//			request.setAttribute("message", "상품 등록에 실패했습니다.");
		}
		
		// response.sendRedirect("main.jsp");		// 상품 등록 후 리스트 확인 페이지 이동
	}

}
