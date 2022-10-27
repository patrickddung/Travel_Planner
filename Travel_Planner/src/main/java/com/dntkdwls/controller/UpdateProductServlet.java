package com.dntkdwls.controller;

import java.io.IOException;


import javax.servlet.RequestDispatcher;
import javax.servlet.ServletContext;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.dntkdwls.dao.ProductDao;
import com.dntkdwls.dto.ProductVo;
import com.oreilly.servlet.MultipartRequest;
import com.oreilly.servlet.multipart.DefaultFileRenamePolicy;


@WebServlet("/updateProduct.do")
public class UpdateProductServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;

	
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// 쿼리스트링으로 전달 받은 code를 획득
		String code = request.getParameter("code");	
			
		// 상품 삭제링크 클릭시 삭제할 상품 정보를 표시
		ProductDao pDao = ProductDao.getInstance();
		ProductVo pVo = new ProductVo();
				
		// 데이터베이스에서 삭제할 데이터 정보 확인
		pVo = pDao.selectProductByCode(code);
				
		request.setAttribute("product", pVo);
				
		// 페이지 이동 : 삭제 페이지
		RequestDispatcher dispatcher = request.getRequestDispatcher("Main_Content/userphoto/App_updateProduct.jsp");
		dispatcher .forward(request, response);
	}

	
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// 상품 수정 코드 : 데이터베이스에서 상품 삭제
		ProductDao pDao = ProductDao.getInstance();
		ProductVo pVo = new ProductVo();
		
		// 파일 업로드 코드 작성
		int result = -1;
		String savePath = "upload";
		ServletContext context = getServletContext();				// 이 서블릿이 실행되고 있는 컨택스트 가져오기
		String uploadFilePath = context.getRealPath(savePath);		// 실제 경로를 리턴
		System.out.println("저장파일 서버경로: " + uploadFilePath);
		int uploadFileSizeLimit = 5 * 1024 * 1024;
		String encType = "UTF-8";
		
		try {
			MultipartRequest multi = new MultipartRequest(
				request,							// request 객체
				uploadFilePath,						// 서버상의 실제 디렉토리
				uploadFileSizeLimit,				// 최대 업로드 파일 크기 
				encType,							// 인코딩 방식
				new DefaultFileRenamePolicy()		// 정책: 동일 이름 존재시, 새로운 이름 부여
			);	
			// 입력 양식을 통해 정보를 획득
			int code = Integer.parseInt(multi.getParameter("code")) ;
			String name = multi.getParameter("name");
			String description = multi.getParameter("description");
			String pictureurl = multi.getFilesystemName("pictureurl");			
			String userid = multi.getParameter("userid");
			String message = multi.getParameter("message");
			System.out.println("메세지는"+message);
			
			
			
			pVo.setCode(code);			
			pVo.setName(name);
			//pVo.setPrice(price);
			pVo.setDescription(description);
			pVo.setPictureurl(pictureurl);
			pVo.setUserid(userid);
			pVo.setMessage(message);
		}catch(Exception e) {
			System.out.println("파일 업로드간 예외 발생" + e);
		}
				
		// 데이터베이스의 해당 코드의 정보를 수정
		result = pDao.updateProduct(pVo);
		
		// 상품이 정상적으로 수정 됬는지 확인
		if(result == 1) {
			System.out.println("상품 수정에 성공");
		} else {
			System.out.println("상품 수정에 실패");
		}
				
//		수정후 목록 페이지로 이동
		response.sendRedirect("productuserList.do");
	}

}
