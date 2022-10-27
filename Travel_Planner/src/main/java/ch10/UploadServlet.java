package ch10;

import java.io.IOException;
import java.io.PrintWriter;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import javax.servlet.ServletContext;
import com.oreilly.servlet.MultipartRequest;
import com.oreilly.servlet.multipart.DefaultFileRenamePolicy;


@WebServlet("/upload.do")
public class UploadServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;

	
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		
	}

	
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		request.setCharacterEncoding("UTF-8");
		response.setContentType("text/html; charset=UTF-8");
		PrintWriter out = response.getWriter();
		
//		일반적인 웹 사이트 경로 구성 => http://<host>:<port>/<contextPath>/index
		
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
			
			String fileName = multi.getFilesystemName("uploadFile");
			System.out.println("파일명:"+fileName);
//			System.out.println("파일명:" + multi.getFilesystemName("uploadFile"));
			System.out.println("게시물 작성자:" + multi.getParameter("name"));
			System.out.println("게시물 제목:" + multi.getParameter("title"));
			
			out.print("<br>" + multi.getFilesystemName("uploadFile"));
			out.print("<br>" + multi.getParameter("name"));
			out.print("<br>" + multi.getParameter("title"));
		}catch(Exception e) {
			System.out.println("파일 업로드간 예외 발생");
		}
		

	}

}
