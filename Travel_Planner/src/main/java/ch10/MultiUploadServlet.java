package ch10;

import java.io.IOException;
import java.io.PrintWriter;
import java.util.Enumeration;

import javax.servlet.ServletContext;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.oreilly.servlet.MultipartRequest;
import com.oreilly.servlet.multipart.DefaultFileRenamePolicy;


@WebServlet("/multiUpload.do")
public class MultiUploadServlet extends HttpServlet {
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
			
			Enumeration files = multi.getFileNames();
			while(files.hasMoreElements()) {
				String file = (String) files.nextElement();
				String fileName = multi.getFilesystemName(file);	// 중복된 파일 업로드 시, 파일명 변환됨
				String orgFileName = multi.getOriginalFileName(file);
				
				System.out.println("파일명: " + fileName);
				System.out.println("원본 파일명: " + orgFileName);
				
				out.print("<br>파일명: " + fileName);
				out.print("<br>원본파일명: " + orgFileName);
				out.print("<hr>");
				
			}
		}catch(Exception e) {
			System.out.println("파일 업로드간 예외 발생");
		}
	}

}
