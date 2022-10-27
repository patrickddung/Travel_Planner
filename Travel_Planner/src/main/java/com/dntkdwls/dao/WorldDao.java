package com.dntkdwls.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import com.dntkdwls.dto.ProductVo;
import com.dntkdwls.dto.WorldVo;
import com.dntkdwls.util.DBmanager;

public class WorldDao {
	// 싱글톤 생성 및 사용
	// 필드
	private static WorldDao instance = new WorldDao();
		
	// 생성자
	private WorldDao(){
	}
		
	// 메소드
	public static WorldDao getInstance() {
		return instance;
	}
	
	// 일정 등록 : DB에 일정 정보를 삽입
	public int insertWorld(WorldVo wVo) {
		Connection conn = null;
		ResultSet rs1 = null;	
//		Statement stmt = null;			// 정적 쿼리
		// 동일한 쿼리문을 특정 값만 바꿔서 여러번 실행해야 할때, 매개변수가 많아서 쿼리문 정리필요
		PreparedStatement pstmt = null;	// 동적 쿼리
		int result = -1;
		
		
		String sql_insert = "insert into world values(?, ?, ?, ?, ?, ?, ?)";
		
//		System.out.println(sql_insert);
		
		try {
			conn = DBmanager.getConnection();

			// (3단계) Statement 객체 생성
//			stmt = conn.createStatement();
			pstmt = conn.prepareStatement(sql_insert);
			
			pstmt.setString(1, wVo.getUserid());
			pstmt.setString(2, wVo.getContinent());
			pstmt.setString(3, wVo.getSchedule());
			pstmt.setString(4, wVo.getIntroduce());
			pstmt.setString(5, wVo.getTitle());				// 문자형
			pstmt.setString(6, wVo.getPictureurl());
			pstmt.setString(7, wVo.getMessage());
			
			
			
			
			// (4단계) SQL문 실행 및 결과 처리
//			result = stmt.executeUpdate(sql_insert);
			result = pstmt.executeUpdate();		// 쿼리 수행
		
		}catch(Exception e) {
			e.printStackTrace();
		}finally {
			DBmanager.close(conn, pstmt);
//			try {
//				// (5단계) 사용한 리소스 해제
////				stmt.close();
//				pstmt.close();
//				conn.close();
//			}catch(Exception e) {

		}
		return result;
		
	}

	// 아이디를 확인
	// 입력값: 중복체크하려는 userid
	// 반환값: 체크한 id가 DB에 존재 여부(1), 존재안함(-1)
	public int confirmTitle(String title) {
		int result = -1;
		Connection conn = null;
		PreparedStatement pstmt = null;
		ResultSet rs1 = null;
			
		String sql = "select title from world where title=?";
		try {
//			// (1단계) JDBC 드라이버 로드
//			Class.forName("oracle.jdbc.driver.OracleDriver");	// Oracle
//			
//			// (2단계) 데이터 베이스 연결 객체 생성
//			String url = "jdbc:oracle:thin:@localhost:1521:orcl";
//			String uid = "ora_user";
//			String pass = "1234";
//			conn = DriverManager.getConnection(url, uid, pass);		// DB연결
				
			conn = DBmanager.getConnection();
				

			// (3단계) Statement 객체 생성
			pstmt =  conn.prepareStatement(sql);
			pstmt.setString(1, title);
				
			// (4단계) SQL문 실행 및 결과 처리
			// executeQuery : 조회(select)
			rs1 = pstmt.executeQuery();
				
			if(rs1.next()){
				// 디비로부터 회원 정보 획득
				result = 1;								
				}else {
				}
			}catch(Exception e) {
				e.printStackTrace();
			}finally {
				DBmanager.close(conn, pstmt, rs1);
			}
			
			return result;			
		}
	
	// 전체 일정 조회
	public List<WorldVo> selectAllWorld() {
		String sql = "select * from world";
			
//		ProductVo[] listArr = new ProductVo[100];
//		int countList = 0;		
		List<WorldVo> list = new ArrayList<WorldVo>();		// List 컬렉션 객체 생성
			
			
			
		Connection conn = null;
		PreparedStatement pstmt = null;
		ResultSet rs1 = null;		
		try {
			conn = DBmanager.getConnection();
				

			// (3단계) Statement 객체 생성
			pstmt =  conn.prepareStatement(sql);
				
			// (4단계) SQL문 실행 및 결과 처리
			// executeQuery : 조회(select)
			rs1 = pstmt.executeQuery();

			while(rs1.next()){
					
				// rs1.getInt("컬럼명");
				WorldVo wVo = new WorldVo();	
				// 디비로부터 회원 정보 획득
				wVo.setUserid(rs1.getString("userid"));		// 컬럼명 code 인 정보를 가져옴
				wVo.setContinent(rs1.getString("continent"));		// DB에서 가져온 정보를 pVo객체에 저장
				wVo.setSchedule(rs1.getString("schedule"));
				wVo.setIntroduce(rs1.getString("introduce"));
				wVo.setTitle(rs1.getString("title"));
				wVo.setPictureurl(rs1.getString("pictureurl"));
				wVo.setMessage(rs1.getString("message"));
					
					
//				listArr[countList] = pVo;
//				countList++;
					
				list.add(wVo);		// list 객체에 데이터 추가
			}
					
		}catch(Exception e) {
			e.printStackTrace();
		}finally {
			DBmanager.close(conn, pstmt, rs1);
		}
		return list;		
	}

	
	// 단일 일정 조회 (Title) => 단일 일정 정보 반환
	public WorldVo selectWorldBytitle(String title) {

		String sql = "select * from world where title=?";
		WorldVo wVo = null;		
		Connection conn = null;
		PreparedStatement pstmt = null;
		ResultSet rs1 = null;		
			
		try {
			conn = DBmanager.getConnection();
				

			// (3단계) Statement 객체 생성
			pstmt =  conn.prepareStatement(sql);
			pstmt.setString(1, title);
			
			// (4단계) SQL문 실행 및 결과 처리
			// executeQuery : 조회(select)
			rs1 = pstmt.executeQuery();

			while(rs1.next()){
					
				// rs1.getInt("컬럼명");
				wVo = new WorldVo();	
				// 디비로부터 회원 정보 획득
				wVo.setUserid(rs1.getString("userid"));		// 컬럼명 code 인 정보를 가져옴
				wVo.setContinent(rs1.getString("continent"));		// DB에서 가져온 정보를 pVo객체에 저장
				wVo.setSchedule(rs1.getString("schedule"));
				wVo.setIntroduce(rs1.getString("introduce"));
				wVo.setTitle(rs1.getString("title"));
				wVo.setPictureurl(rs1.getString("pictureurl"));
				wVo.setMessage(rs1.getString("message"));
					
			}				
		}catch(Exception e) {
			e.printStackTrace();
		}finally {
			DBmanager.close(conn, pstmt, rs1);
		}
		return wVo;
			
	}
	// 전체 일정 조회(자기 자신의 아이디로 만든 일정만)
	public List<WorldVo> selectWorldByuserid(String userid) {
		String sql = "select * from world where userid=? order by continent";
				
//		ProductVo[] listArr = new ProductVo[100];
//		int countList = 0;		
		List<WorldVo> list = new ArrayList<WorldVo>();		// List 컬렉션 객체 생성
				
				
				
		Connection conn = null;
		PreparedStatement pstmt = null;
		ResultSet rs1 = null;		
		try {
			conn = DBmanager.getConnection();
					

			// (3단계) Statement 객체 생성
			pstmt =  conn.prepareStatement(sql);
			pstmt.setString(1, userid);
					
			// (4단계) SQL문 실행 및 결과 처리
			// executeQuery : 조회(select)
			rs1 = pstmt.executeQuery();

			while(rs1.next()){
						
				// rs1.getInt("컬럼명");
				WorldVo wVo = new WorldVo();	
				// 디비로부터 회원 정보 획득
				wVo.setUserid(rs1.getString("userid"));		// 컬럼명 code 인 정보를 가져옴
				wVo.setContinent(rs1.getString("continent"));		// DB에서 가져온 정보를 pVo객체에 저장
				wVo.setSchedule(rs1.getString("schedule"));
				wVo.setIntroduce(rs1.getString("introduce"));
				wVo.setTitle(rs1.getString("title"));
				wVo.setMessage(rs1.getString("message"));
						
						
//				listArr[countList] = pVo;
//				countList++;
						
				list.add(wVo);		// list 객체에 데이터 추가
			}
						
		}catch(Exception e) {
			e.printStackTrace();
		}finally {
			DBmanager.close(conn, pstmt, rs1);
		}
		return list;		
	}
	
	// 상품 삭제
	public void deleteWorld(String title) {	
		Connection conn = null;
		PreparedStatement pstmt = null;	// 동적 쿼리
		String sql = "delete from world where title=?";		// ? : 변화가 가능한 변수
		int result = -1;
			
		try {
			conn = DBmanager.getConnection();

			// (3단계) Statement 객체 생성
			pstmt = conn.prepareStatement(sql);
		
			pstmt.setString(1, title);
			System.out.println(title);
				
			// (4단계) SQL문 실행 및 결과 처리
			//	executeUpdate : 삽입(insert/update/delete)
			result = pstmt.executeUpdate();		// 쿼리 수행
			
							
		}catch(Exception e) {
			e.printStackTrace();
		}finally {
			DBmanager.close(conn, pstmt);
		}
			
	}
	
	// 게시판 검색
	// 입력값: column: 검색 대상(분야), keyword: 검색어
	// 반환값: 검색 결과 리스트
	public List<WorldVo> searchWorld(String column, String keyword) {
		String sql = "select * from world where "+ column + " like ? ";
					
		List<WorldVo> list = new ArrayList<WorldVo>();
					
		Connection conn = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
					
		try {
			conn = DBmanager.getConnection();
					
			// (3 단계) Statement 객체 생성
			pstmt = conn.prepareStatement(sql);
			pstmt.setString(1, "%" + keyword + "%");
			

			// (4 단계) SQL문 실행 및 결과 처리 => executeQuery : 조회(select)
			rs = pstmt.executeQuery();
				
			// rs.next() : 다음 행(row)을 확인
			// rs.getString("컬럼명")
			while(rs.next()){
					
				WorldVo wVo = new WorldVo();				
				// 디비로부터 회원 정보 획득
				wVo.setUserid(rs.getString("userid"));		// 컬럼명 name 인 정보를 가져옴
				wVo.setContinent(rs.getString("continent"));	// DB에서 가져온 정보를 pVo 객체에 저장
				wVo.setSchedule(rs.getString("schedule"));
				wVo.setIntroduce(rs.getString("introduce"));
				wVo.setTitle(rs.getString("title"));
				wVo.setMessage(rs.getString("message"));
					
				list.add(wVo);	// list 객체에 데이터 추가
						
			}
						
		} catch(Exception e) {
			e.printStackTrace();
						
		} finally {
			DBmanager.close(conn, pstmt, rs); 
		}
					
		return list;
	}
	
	// 사진에 댓글 달기
	public int messageWorld(WorldVo wVo) {
		Connection conn = null;
		PreparedStatement pstmt = null;	// 동적 쿼리
		int result = -1;
				
		String sql = "update world set message=? where title=?";		// ? : 변화가 가능한 변수
				
				
		try {
			conn = DBmanager.getConnection();

			// (3단계) Statement 객체 생성
			pstmt = conn.prepareStatement(sql);	
			pstmt.setString(1, wVo.getMessage());
			pstmt.setString(2, wVo.getTitle());	
					
			// (4단계) SQL문 실행 및 결과 처리
			//	executeUpdate : 삽입(insert/update/delete)
			result = pstmt.executeUpdate();		// 쿼리 수행
				
								
		}catch(Exception e) {
			e.printStackTrace();
		}finally {
			DBmanager.close(conn, pstmt);
		}
		return result;
	}
	
	public int multiDelete(String[] title) {
		Connection conn = null;
		conn = DBmanager.getConnection();			

		PreparedStatement pstmt = null;		// 동적 쿼리
		int result = 0;
		int[] cnt = null;
		
		String sql = "delete from world where title=?";
				
		try {
			pstmt = conn.prepareStatement(sql);
			
			for(int i=0; i<title.length; i++) {
				pstmt.setString(1, title[i]);
				
				pstmt.addBatch();
			}
			
			cnt = pstmt.executeBatch();
			
			for(int i=0; i<cnt.length; i++) {
				if(cnt[i]==-2) {
					result++;
				}
			}

		} catch(SQLException e) {
			e.printStackTrace();
		} finally {
			DBmanager.close(conn, pstmt); 
		}
		return result;
	}
	
	// 게시글 검색
	public List<WorldVo> getWorldList(){
		return getWorldList("userid", "", 1);
	}
	
	// 페이지 별 리스트 표시
	public List<WorldVo> getWorldList(int page){
		return getWorldList("userid", "", page);
	}
	
	// 검색 기능과 페이징을 구현
	public List<WorldVo> getWorldList(String column, String keyword, int page){
		String sql = "SELECT * FROM ("
				+ "SELECT ROWNUM N, w.* "
				+ "FROM (SELECT * FROM world where "+column+" like ? order by userid ASC) w"
				+ ") "
				+ "WHERE	N BETWEEN ? AND ?";
//		첫번째 ? => 1, 11, 21, 31, 41, => an = 1+(page-1)*10
//		등차수열의 n에 대한 식은 첫번째 A 공차가 B인 경우 => A + B(n-1)
//		두번째 ? => 10, 20, 30, 40 => page*10
		
		WorldVo wVo = null;
		List<WorldVo> list = new ArrayList<WorldVo>();
		
		Connection conn = null;
		PreparedStatement pstmt = null;
		ResultSet rs1 = null;
		
		try {
			conn = DBmanager.getConnection();
			
			// (3 단계) Statement 객체 생성
			pstmt = conn.prepareStatement(sql);
			pstmt.setString(1, "%"+ keyword +"%");
			pstmt.setInt(2, 1+(page-1)*10);		// ex) page = 1  1~10페이지
			pstmt.setInt(3, page*10);
			
			
			// (4 단계) SQL문 실행 및 결과 처리 => executeQuery : 조회(select)
			rs1 = pstmt.executeQuery();
			
			// rs.next() : 다음 행(row)을 확인
			// rs.getString("컬럼명")
			while(rs1.next()){
				
				wVo = new WorldVo();				
				// 디비로부터 회원 정보 획득
				wVo.setUserid(rs1.getString("userid"));		// 컬럼명 name 인 정보를 가져옴
				wVo.setContinent(rs1.getString("continent"));	// DB에서 가져온 정보를 pVo 객체에 저장
				wVo.setTitle(rs1.getString("title"));
				wVo.setSchedule(rs1.getString("schedule"));
				wVo.setIntroduce(rs1.getString("introduce"));
				wVo.setMessage(rs1.getString("message"));
					
				list.add(wVo);	// list 객체에 데이터 추가
			
				
			}
			
		} catch(Exception e) {
			e.printStackTrace();
			
		} finally {
			DBmanager.close(conn, pstmt, rs1); 
		}
		return list;
	}
	
	// 게시물 수 조회
	public int getWorldCount() {
		return getWorldCount("userid", "");
	}
	
	// 특정 컬럼의 키워드를 통해 게시물 수 조회
	public int getWorldCount(String column, String keyword) {
		String sql = "SELECT COUNT(userid) count FROM ("
			+ "SELECT ROWNUM N, w.* "
			+ "FROM (SELECT * FROM world where "+column+" like ? order by title ASC) w"
			+ ") ";
		Connection conn = null;
		PreparedStatement pstmt = null;
		ResultSet rs1 = null;
		int count = 0;
			
		try {
			conn = DBmanager.getConnection();
				
			// (3 단계) Statement 객체 생성
			pstmt = conn.prepareStatement(sql);
			pstmt.setString(1, "%"+ keyword +"%");
				
			// (4 단계) SQL문 실행 및 결과 처리 => executeQuery : 조회(select)
			rs1 = pstmt.executeQuery();
				
			// rs.next() : 다음 행(row)을 확인
			// rs.getString("컬럼명")
			if(rs1.next()) {
				count = rs1.getInt("count");		
			}
				
		} catch(Exception e) {
			e.printStackTrace();
				
		} finally {
			DBmanager.close(conn, pstmt, rs1); 
		}
		return count;
	}
	
	// 게시물 번호로 특정 게시물 다음 게시물 데이터 조회
	public WorldVo getNextWorld(int userid) {
		WorldVo wVo = null;
		return wVo;
	}
	
	// 게시물 번호로 특정 게시물 이전 게시물 데이터 조회
	public WorldVo getPrevWorld(int userid) {
		WorldVo wVo = null;
		return wVo;
	}
	
	
}
