package com.dntkdwls.dao;


import java.sql.Connection;
//import java.sql.Statement;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import com.dntkdwls.dto.MemberVo;
import com.dntkdwls.util.DBmanager;

// 데이터 베이스 접근
public class MemberDao {
	
	// 싱글톤 생성 및 사용
	// 필드
	private static MemberDao instance = new MemberDao();
	
	// 생성자
	private MemberDao(){
	}
	
	// 메소드
	public static MemberDao getInstance() {
		return instance;
	}
	
	// 로그인(사용자 인증)시 사용
	// 입력값 : 로그인 페이지에서 입력받은 사용자아이디와 암호
	// 반환값 : result (1:암호일치), (0:암호불일치), (-1: 사용자아이디없음)
	public int checkUser(String userid, String pwd) {
		int result = -1;
		
		Connection conn = null;
//		Statement stmt = null;
		PreparedStatement pstmt = null;
		ResultSet rs1 = null;
//		String sql = "select pwd from member where userid='"+userid+"'";
		String sql = "select pwd from member where userid=?";
		
		try {
			// (1단계) JDBC 드라이버 로드
//			Class.forName("oracle.jdbc.driver.OracleDriver");	// Oracle
//			
//			// (2단계) 데이터 베이스 연결 객체 생성
//			String url = "jdbc:oracle:thin:@localhost:1521:orcl";
//			String uid = "ora_user";
//			String pass = "1234";
//			conn = DriverManager.getConnection(url, uid, pass);		// DB연결
			
			conn = DBmanager.getConnection();

			// (3단계) Statement 객체 생성
//			stmt = conn.createStatement();
			pstmt =  conn.prepareStatement(sql);
			pstmt.setString(1, userid);
			
			// (4단계) SQL문 실행 및 결과 처리
			// executeQuery : 조회(select)
//			rs1 = stmt.executeQuery(sql);
			rs1 = pstmt.executeQuery();
			
			// stmt.executeUpdate("insert into member values('유재식','js104','134','js104@naver.com','010-5555-6166',0)");

			// rs.next() : 다음 행(row)을 확인
			// rs.getString("컬럼명")

			if(rs1.next()){
//				System.out.println(rs1.getString("pwd"));
				// 아이디/암호 비교 후 페이지 이동
				if(rs1.getString("pwd")!=null &&
						rs1.getString("pwd").equals(pwd)) {
					result = 1;		// 암호 일치
				}else {
					result = 0;		// 암호 불일치
				}
			}else {
				result = -1;		// 디비에 userid 없음
			}
		}catch(Exception e) {
			e.printStackTrace();
		}finally {
			DBmanager.close(conn, pstmt, rs1);
		}
		return result;		
	}
	
	
	// 회원가입 : DB에 회원 정보를 삽입
//	public int insertMember(String name, String id, String pwd, String email, String phone, int admin) {
	public int insertMember(MemberVo mVo) {
		Connection conn = null;
		ResultSet rs1 = null;	
//		Statement stmt = null;			// 정적 쿼리
		// 동일한 쿼리문을 특정 값만 바꿔서 여러번 실행해야 할때, 매개변수가 많아서 쿼리문 정리필요
		PreparedStatement pstmt = null;	// 동적 쿼리
		int result = -1;
		
		
//		String sql_insert = "insert into member values('"+name+"','"+id+"','"+pwd+"','"+email+"','"+phone+"','"+admin+"')";
//		String sql_insert = "insert into member values(?, ?, ?, ?, ?, ?)";		// ? : 변화가 가능한 변수
		String sql_insert = "insert into member values(user_seq.nextval, ?, ?, ?, ?, ?, ?, ?, ?)";
		
//		System.out.println(sql_insert);
		
		try {
			conn = DBmanager.getConnection();

			// (3단계) Statement 객체 생성
//			stmt = conn.createStatement();
			pstmt = conn.prepareStatement(sql_insert);
//			pstmt.setString(1, name);
//			pstmt.setString(2, id);
//			pstmt.setString(3, pwd);
//			pstmt.setString(4, email);
//			pstmt.setString(5, phone);
//			pstmt.setString(6, admin);
			
			pstmt.setString(1, mVo.getName());
			pstmt.setString(2, mVo.getUserid());
			pstmt.setString(3, mVo.getPwd());
			pstmt.setString(4, mVo.getEmail());
			pstmt.setString(5, mVo.getPhone());				// 문자형
			pstmt.setString(6, mVo.getNickname()); 			// 정수형
			pstmt.setString(7, mVo.getIntroduce());
			pstmt.setString(8, mVo.getUserlatlng());
			
			
//			pstmt.setFloat(int idx, float x);				// 실수형
//			pstmt.setDate(int idx, Date x);					// 날짜형
//			pstmt.setTimestamp(int idx, Timestamp x);		// 시간형
			
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
	
	// 회원 정보 가져오기 : select
	// 입력값 : 사용자id(userid)  
	// 반환값 : 해당 회원 정보
	public MemberVo getMember(String userid) {
		Connection conn = null;
		PreparedStatement pstmt = null;
		ResultSet rs1 = null;
		int result = -1;
		String sql = "select * from member where userid=?";
		MemberVo mVo = null;
		
		
		
		try {
			conn = DBmanager.getConnection();
			

			// (3단계) Statement 객체 생성
			pstmt =  conn.prepareStatement(sql);
			pstmt.setString(1, userid);
			
			// (4단계) SQL문 실행 및 결과 처리
			// executeQuery : 조회(select)
			rs1 = pstmt.executeQuery();
			
			// stmt.executeUpdate("insert into member values('유재식','js104','134','js104@naver.com','010-5555-6166',0)");

			// rs.next() : 다음 행(row)을 확인
			// rs.getString("컬럼명")

			if(rs1.next()){
				// 디비로부터 회원 정보 획득
				mVo = new MemberVo();
//				String name = rs1.getString("name");		// 컬럼명 name 인 정보를 가져옴
//				mVo.setName(name);							// DB에서 가져온 정보를 mVo객체에 저장
	
				mVo.setName(rs1.getString("name"));					
				mVo.setUserid(rs1.getString("userid"));				
				mVo.setPwd(rs1.getString("pwd"));					
				mVo.setEmail(rs1.getString("email"));			
				mVo.setPhone(rs1.getString("phone"));			
				mVo.setNickname(rs1.getString("nickname"));
				mVo.setIntroduce(rs1.getString("introduce"));
				mVo.setUserlatlng(rs1.getString("userlatlng"));
				
				
			}else {
				result = -1;		// 디비에 userid 없음
			}
		}catch(Exception e) {
			e.printStackTrace();
		}finally {
			DBmanager.close(conn, pstmt, rs1);
		}
		return mVo;
	}
	
	// 회원 정보 업데이트 : update
	// 입력값 : 회원 테이블 정보 
	// 반환값 : 성공여부
	public int updateMember(MemberVo mVo) {
		int result = -1;
		String sql = "update member set name=?,pwd=?,email=?,phone=?,nickname=?,introduce=?,userlatlng=? where userid=?";
		
		Connection conn = null;
		PreparedStatement pstmt = null;
		try {
			conn = DBmanager.getConnection();

			// (3단계) Statement 객체 생성
			pstmt =  conn.prepareStatement(sql);		// 쿼리 입력
			pstmt.setString(1, mVo.getName());
			pstmt.setString(2, mVo.getPwd());
			pstmt.setString(3, mVo.getEmail());
			pstmt.setString(4, mVo.getPhone());
			pstmt.setString(5, mVo.getNickname());
			pstmt.setString(6, mVo.getIntroduce());
			pstmt.setString(7, mVo.getUserlatlng());			
			pstmt.setString(8, mVo.getUserid());
			
			
			System.out.println(mVo.getPwd());
			System.out.println(mVo.getUserid());
			
			// (4단계) SQL문 실행 및 결과 처리
			// executeQuery : 수정(update)
			result = pstmt.executeUpdate();
		}catch(Exception e) {
			e.printStackTrace();
		}finally {
			DBmanager.close(conn, pstmt);
		}
		return result;
	}

	// 아이디를 확인
	// 입력값: 중복체크하려는 userid
	// 반환값: 체크한 id가 DB에 존재 여부(1), 존재안함(-1)
	public int confirmID(String userid) {
		int result = -1;
		Connection conn = null;
		PreparedStatement pstmt = null;
		ResultSet rs1 = null;
		
		String sql = "select userid from member where userid=?";
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
			pstmt.setString(1, userid);
			
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

	// 전체 멤버 조회(채팅)
	public List<MemberVo> selectAllmember() {
		String sql = "select * from member where code not in(21) order by name ASC";
		
//		ProductVo[] listArr = new ProductVo[100];
//		int countList = 0;		
		List<MemberVo> list = new ArrayList<MemberVo>();		// List 컬렉션 객체 생성
		
		
		
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
			MemberVo mVo = new MemberVo();	
			// 디비로부터 회원 정보 획득
			mVo.setCode(rs1.getInt("code"));
			mVo.setName(rs1.getString("name"));		// DB에서 가져온 정보를 pVo객체에 저장
			mVo.setUserid(rs1.getString("userid"));
			mVo.setPwd(rs1.getString("pwd"));
			mVo.setEmail(rs1.getString("email"));
			mVo.setPhone(rs1.getString("phone"));
			mVo.setNickname(rs1.getString("nickname"));
			mVo.setIntroduce(rs1.getString("introduce"));
			mVo.setUserlatlng(rs1.getString("userlatlng"));
				
			System.out.println(rs1.getString("name"));
			System.out.println(rs1.getString("introduce"));
				
				
			list.add(mVo);		// list 객체에 데이터 추가
			}
				
		}catch(Exception e) {
			e.printStackTrace();
		}finally {
			DBmanager.close(conn, pstmt, rs1);
		}
		return list;
	}
	
	//========================멤버 삭제===============================
	public void deleteMember(String userid) {
		int result = -1;
		Connection conn = null;
		// 동일한 쿼리문을 특정 값만 바꿔서 여러번 실행해야 할때, 매개변수가 많아서 쿼리문 정리 필요
		PreparedStatement pstmt = null;		// 동적 쿼리
				
				
		String sql = "delete from member where userid=?";
				
		try {
			conn = DBmanager.getConnection();

			// (3 단계) Statement 객체 생성
			pstmt = conn.prepareStatement(sql);
					
			pstmt.setString(1, userid);			
					
			// (4 단계) SQL문 실행 및 결과 처리
			result = pstmt.executeUpdate();			// 쿼리 수행
		} catch(Exception e) {
			e.printStackTrace();
		} finally {
			DBmanager.close(conn, pstmt); 
		}
	}
	
	
	//========================단일 멤버 조회===========================
	public MemberVo selectMemberByName(String userid) {

		String sql = "select * from member where userid=?";
		Connection conn = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		MemberVo mVo = null;
				
		try {
			conn = DBmanager.getConnection();
				
			// (3 단계) Statement 객체 생성
			pstmt = conn.prepareStatement(sql);
			pstmt.setString(1, userid);
				
			// (4 단계) SQL문 실행 및 결과 처리 => executeQuery : 조회(select)
			rs = pstmt.executeQuery();
			// rs.next() : 다음 행(row)을 확인, rs.getString("컬럼명")
			while(rs.next()){
				// rs.getInt("컬럼명")
				mVo = new MemberVo();				
				// 디비로부터 회원 정보 획득
				mVo.setCode(rs.getInt("code"));
				mVo.setUserid(rs.getString("userid"));		// 컬럼명 userid 인 정보를 가져옴
				mVo.setName(rs.getString("name"));	// DB에서 가져온 정보를 pVo 객체에 저장
				mVo.setPwd(rs.getString("pwd"));
				mVo.setEmail(rs.getString("email"));
				mVo.setPhone(rs.getString("phone"));
				mVo.setNickname(rs.getString("nickname"));
				mVo.setIntroduce(rs.getString("introduce"));
				mVo.setUserlatlng(rs.getString("userlatlng"));
			}
				
		} catch(Exception e) {
			e.printStackTrace();
				
		} finally {
			DBmanager.close(conn, pstmt, rs); 
		}
		return mVo;
	}
		
	//========================특정 멤버 검색===========================
	public List<MemberVo> searchMember(String userid, String name) {

		String sql = "select * from member where " + userid + " like ? ";
			
		List<MemberVo> list = new ArrayList<MemberVo>();
			
		Connection conn = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
			
		try {
			conn = DBmanager.getConnection();
				
			// (3 단계) Statement 객체 생성
			pstmt = conn.prepareStatement(sql);
			pstmt.setString(1, "%" + name + "%");
			

			// (4 단계) SQL문 실행 및 결과 처리 => executeQuery : 조회(select)
			rs = pstmt.executeQuery();
				
			// rs.next() : 다음 행(row)을 확인
			// rs.getString("컬럼명")
			while(rs.next()){
					
				MemberVo mVo = new MemberVo();
					
				mVo.setCode(rs.getInt("code"));
				mVo.setUserid(rs.getString("userid"));		// 컬럼명 userid 인 정보를 가져옴
				mVo.setName(rs.getString("name"));	// DB에서 가져온 정보를 pVo 객체에 저장
				mVo.setPwd(rs.getString("pwd"));
				mVo.setEmail(rs.getString("email"));
				mVo.setPhone(rs.getString("phone"));
				mVo.setNickname(rs.getString("nickname"));
				mVo.setIntroduce(rs.getString("introduce"));
				mVo.setUserlatlng(rs.getString("userlatlng"));
					
				list.add(mVo);	// list 객체에 데이터 추가
					
			}
				
		} catch(Exception e) {
			e.printStackTrace();
				
		} finally {
			DBmanager.close(conn, pstmt, rs); 
		}
			
		return list;
	}
		
	//========================여러 멤버 삭제===========================
	public int multiDelete(String[] userid) {
		int result = 0;
		int[] cnt = null;
		PreparedStatement pstmt = null;		// 동적 쿼리
		String sql = "delete from member where userid=?";
		Connection conn = null;			
		conn = DBmanager.getConnection();

		try {
			// (3 단계) Statement 객체 생성
			pstmt = conn.prepareStatement(sql);
				
			for(int i=0; i<userid.length; i++) {
				pstmt.setString(1, userid[i]);
					
				pstmt.addBatch();
			}
				
			cnt = pstmt.executeBatch();
				
			for(int i=0; i<cnt.length; i++) {
				if(cnt[i]==-2) {
					result++;
				}
			}
			
				
			// (4 단계) SQL문 실행 및 결과 처리
//			result = pstmt.executeUpdate();			// 쿼리 수행
		} catch(SQLException e) {
			e.printStackTrace();
		} finally {
			DBmanager.close(conn, pstmt); 
		}
		return result;
	}
	
	// 게시글 검색
	public List<MemberVo> getMemberList(){
		return getMemberList("userid", "", 1);
	}
				
	// 페이지 별 리스트 표시
	public List<MemberVo> getMemberList(int page){
		return getMemberList("userid", "", page);
	}
				
	// 검색 기능과 페이징을 구현
	public List<MemberVo> getMemberList(String column, String keyword, int page){
		String sql = "SELECT * FROM ("
				+ "SELECT ROWNUM N, m.* "
				+ "FROM (SELECT * FROM member where "+column+" like ? order by name ASC)m"
				+ ") "
				+ "WHERE	N BETWEEN ? AND ?";
//		첫번째 ? => 1, 11, 21, 31, 41, => an = 1+(page-1)*10
//		등차수열의 n에 대한 식은 첫번째 A 공차가 B인 경우 => A + B(n-1)
//		두번째 ? => 10, 20, 30, 40 => page*10
					
		MemberVo mVo = null;
		List<MemberVo> list = new ArrayList<MemberVo>();
					
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
							
				mVo = new MemberVo();				
				// 디비로부터 회원 정보 획득
				mVo.setName(rs1.getString("name"));		// DB에서 가져온 정보를 pVo객체에 저장
				mVo.setUserid(rs1.getString("userid"));
				mVo.setPwd(rs1.getString("pwd"));
				mVo.setEmail(rs1.getString("email"));
				mVo.setPhone(rs1.getString("phone"));
				mVo.setNickname(rs1.getString("nickname"));
				mVo.setIntroduce(rs1.getString("introduce"));
				mVo.setUserlatlng(rs1.getString("userlatlng"));
							
				System.out.println(rs1.getString("name"));
							
				list.add(mVo);	// list 객체에 데이터 추가
							
			}
						
		} catch(Exception e) {
			e.printStackTrace();
						
		} finally {
			DBmanager.close(conn, pstmt, rs1); 
		}
		return list;
	}
	
	// 게시물 수 조회
	public int getMemberCount() {
		return getMemberCount("userid", "");
	}
	// 특정 컬럼의 키워드를 통해 게시물 수 조회
	public int getMemberCount(String column, String keyword) {
		String sql = "SELECT COUNT(userid) count FROM ("
			+ "SELECT ROWNUM N, m.* "
			+ "FROM (SELECT * FROM member where "+column+" like ? order by name ASC) m"
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
				System.out.println(count);
			}
							
		} catch(Exception e) {
			e.printStackTrace();
							
		} finally {
			DBmanager.close(conn, pstmt, rs1); 
		}
		return count;
	}
	
	
	
	// 게시물 번호로 특정 게시물 다음 게시물 데이터 조회
	public MemberVo getNextMember(int userid) {
		MemberVo bVo = null;
		return bVo;
	}
				
	// 게시물 번호로 특정 게시물 이전 게시물 데이터 조회
	public MemberVo getPrevMember(int userid) {
		MemberVo bVo = null;
		return bVo;
	}

}


