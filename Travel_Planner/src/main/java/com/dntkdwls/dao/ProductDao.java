package com.dntkdwls.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import com.dntkdwls.dto.MemberVo;
import com.dntkdwls.dto.ProductVo;
import com.dntkdwls.dto.WorldVo;
import com.dntkdwls.util.DBmanager;

public class ProductDao {
	
	// 싱글톤
	// 1. 생성자 private : 객체를 외부에서 만들지 못하도록
	// 2. 객체 생성 : 자신이 객체를 생성
	// 3. 객체 제공 기능 getInstance() : 자신의 객체(단지 1개)를 사용할 수 있도록 제공
	private ProductDao() {
		
	}
	
	private static ProductDao instance = new ProductDao();
	
	public static ProductDao getInstance() {
		return instance;
	}
	
	
	// 상품등록
	// 입력값 : 전체 상품 정보
	// 반환값 : 쿼리 수행 결과
	public int insertProduct(ProductVo pVo) {
		Connection conn = null;
		// 동일한 쿼리문을 특정 값만 바꿔서 여러번 실행해야 할때, 매개변수가 많아서 쿼리문 정리필요
		PreparedStatement pstmt = null;	// 동적 쿼리
		int result = -1;
		
		String sql_insert = "insert into product values(product_seq.nextval, ?, ?, ?, ?,?)";		// ? : 변화가 가능한 변수

		
		try {
			conn = DBmanager.getConnection();

			// (3단계) Statement 객체 생성
			pstmt = conn.prepareStatement(sql_insert);
			
//			pstmt.setInt(1, pVo.getCode());
			pstmt.setString(1, pVo.getName());
			pstmt.setString(2, pVo.getPictureurl());					// 정수형
			pstmt.setString(3, pVo.getDescription());
			pstmt.setString(4, pVo.getUserid());			// 문자형
			pstmt.setString(5, pVo.getMessage());			// 문자형			
			// pstmt.setDate(5, pVo.getReg_date());				// 날짜형

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

	// 전체 상품 조회
	public List<ProductVo> selectAllProduct() {
		String sql = "select * from product order by code desc";
		
//		ProductVo[] listArr = new ProductVo[100];
//		int countList = 0;		
		List<ProductVo> list = new ArrayList<ProductVo>();		// List 컬렉션 객체 생성
		
		
		
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
				ProductVo pVo = new ProductVo();	
				// 디비로부터 회원 정보 획득
				pVo.setCode(rs1.getInt("code"));		// 컬럼명 code 인 정보를 가져옴
				pVo.setName(rs1.getString("name"));		// DB에서 가져온 정보를 pVo객체에 저장
				pVo.setPictureurl(rs1.getString("pictureurl"));
				pVo.setDescription(rs1.getString("description"));
				pVo.setUserid(rs1.getString("userid"));
				pVo.setMessage(rs1.getString("message"));
				
				
				System.out.println(rs1.getInt("code"));
				System.out.println(rs1.getString("pictureurl"));
				
				
//				listArr[countList] = pVo;
//				countList++;
				
				list.add(pVo);		// list 객체에 데이터 추가
			}
				
		}catch(Exception e) {
			e.printStackTrace();
		}finally {
			DBmanager.close(conn, pstmt, rs1);
		}
		return list;
		
		
	}
		
	// 단일 상품 조회 (상품코드) => 다닝ㄹ 상품 정보 반환
	public ProductVo selectProductByCode(String code) {

		String sql = "select * from product where code=?";
		ProductVo pVo = null;		
		Connection conn = null;
		PreparedStatement pstmt = null;
		ResultSet rs1 = null;		
		
		try {
			conn = DBmanager.getConnection();
			

			// (3단계) Statement 객체 생성
			pstmt =  conn.prepareStatement(sql);
			pstmt.setString(1, code);
			
			// (4단계) SQL문 실행 및 결과 처리
			// executeQuery : 조회(select)
			rs1 = pstmt.executeQuery();

			while(rs1.next()){
				
				// rs1.getInt("컬럼명");
				pVo = new ProductVo();	
				// 디비로부터 회원 정보 획득
				pVo.setCode(rs1.getInt("code"));		// 컬럼명 code 인 정보를 가져옴
				pVo.setName(rs1.getString("name"));		// DB에서 가져온 정보를 pVo객체에 저장
				pVo.setPictureurl(rs1.getString("pictureurl"));
				pVo.setDescription(rs1.getString("description"));
				pVo.setUserid(rs1.getString("userid"));
				pVo.setMessage(rs1.getString("message"));
				
				
			}				
		}catch(Exception e) {
			e.printStackTrace();
		}finally {
			DBmanager.close(conn, pstmt, rs1);
		}
		return pVo;
		
	}
	
	// 상품 수정 (수정정보) => 디비에 정상 반영 여부 반환
	public int updateProduct(ProductVo pVo) {
		Connection conn = null;
		PreparedStatement pstmt = null;	// 동적 쿼리
		int result = -1;
		
		String sql = "update product set name=?,pictureurl=?,description=?,userid=?,message=? where code=?";		// ? : 변화가 가능한 변수
		
		
		try {
			conn = DBmanager.getConnection();

			// (3단계) Statement 객체 생성
			pstmt = conn.prepareStatement(sql);	
			pstmt.setString(1, pVo.getName());
			pstmt.setString(2, pVo.getPictureurl());
			pstmt.setString(3, pVo.getDescription());
			pstmt.setString(4, pVo.getUserid());
			pstmt.setString(5, pVo.getMessage());
			
			pstmt.setInt(6, pVo.getCode());
			
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

	// 상품 삭제
	public void deleteProduct(String code) {	
		Connection conn = null;
		PreparedStatement pstmt = null;	// 동적 쿼리
		String sql = "delete from product where code=?";		// ? : 변화가 가능한 변수
		int result = -1;
		
		try {
			conn = DBmanager.getConnection();

			// (3단계) Statement 객체 생성
			pstmt = conn.prepareStatement(sql);
	
			pstmt.setString(1, code);
			System.out.println(code);
			
			// (4단계) SQL문 실행 및 결과 처리
			//	executeUpdate : 삽입(insert/update/delete)
			result = pstmt.executeUpdate();		// 쿼리 수행
		
						
		}catch(Exception e) {
			e.printStackTrace();
		}finally {
			DBmanager.close(conn, pstmt);
		}
		
	}

	// 상품 검색
	// 입력값 : column: 검색대상(분야), keyword: 검색어
	// 반환깞: 검색 결과 리스트
	public List<ProductVo> searchProduct(String column, String keyword) {
		
//		#안되는 예시 : select * from product where 'code' like '%사과%' order by code desc;
//		=> String sql = "select * from product where ? like ? order by code desc";
		
		String sql = "select * from product where "+column+" like ? order by code desc";
	
		List<ProductVo> list = new ArrayList<ProductVo>();		// List 컬렉션 객체 생성
		
		Connection conn = null;
		PreparedStatement pstmt = null;
		ResultSet rs1 = null;		
		try {
			conn = DBmanager.getConnection();
			

			// (3단계) Statement 객체 생성
			pstmt =  conn.prepareStatement(sql);
			pstmt.setString(1, "%"+keyword+"%");
			
			// (4단계) SQL문 실행 및 결과 처리
			// executeQuery : 조회(select)
			rs1 = pstmt.executeQuery();

			while(rs1.next()){
				
				// rs1.getInt("컬럼명");
				ProductVo pVo = new ProductVo();	
				// 디비로부터 회원 정보 획득
				pVo.setCode(rs1.getInt("code"));		// 컬럼명 code 인 정보를 가져옴
				pVo.setName(rs1.getString("name"));		// DB에서 가져온 정보를 pVo객체에 저장
				pVo.setPictureurl(rs1.getString("pictureurl"));
				pVo.setDescription(rs1.getString("description"));
				pVo.setUserid(rs1.getString("userid"));
				pVo.setMessage(rs1.getString("message"));
				
				
				System.out.println(rs1.getInt("code"));
				System.out.println(rs1.getString("pictureurl"));
				
				
//				listArr[countList] = pVo;
//				countList++;
				
				list.add(pVo);		// list 객체에 데이터 추가
			}
				
		}catch(Exception e) {
			e.printStackTrace();
		}finally {
			DBmanager.close(conn, pstmt, rs1);
		}		
		return list;
	}
	
	// 전체 일정 조회(자기 자신의 아이디로 만든 일정만)
	public List<ProductVo> selectProductByuserid(String userid) {
		String sql = "select * from product where userid=? order by name ASC";
					
//		ProductVo[] listArr = new ProductVo[100];
//		int countList = 0;		
		List<ProductVo> list = new ArrayList<ProductVo>();		// List 컬렉션 객체 생성
						
						
						
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
				ProductVo pVo = new ProductVo();	
				// 디비로부터 회원 정보 획득
				pVo.setCode(rs1.getInt("code"));		// 컬럼명 code 인 정보를 가져옴
				pVo.setName(rs1.getString("name"));		// DB에서 가져온 정보를 pVo객체에 저장
				pVo.setPictureurl(rs1.getString("pictureurl"));
				pVo.setDescription(rs1.getString("description"));
				pVo.setUserid(rs1.getString("userid"));
					
							
								
//				listArr[countList] = pVo;
//				countList++;
								
				list.add(pVo);		// list 객체에 데이터 추가
			}
							
		}catch(Exception e) {
			e.printStackTrace();
		}finally {
			DBmanager.close(conn, pstmt, rs1);
		}
		return list;		
	}
	
	public int multiDelete(String[] code) {
		Connection conn = null;
		conn = DBmanager.getConnection();			

		PreparedStatement pstmt = null;		// 동적 쿼리
		int result = 0;
		int[] cnt = null;
		
		String sql = "delete from product where code=?";
		
		

		
		try {

			// (3 단계) Statement 객체 생성
			pstmt = conn.prepareStatement(sql);
			
			for(int i=0; i<code.length; i++) {
				pstmt.setString(1, code[i]);
				
				pstmt.addBatch();
			}
			
			cnt = pstmt.executeBatch();
			
			for(int i=0; i<cnt.length; i++) {
				if(cnt[i]==-2) {
					result++;
				}
			}
//			if(code.length==result) {
//				conn.commit();
//			} else {
//				conn.rollback();
//			}
			
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
	public List<ProductVo> getProductList(){
		return getProductList("userid", "", 1);
	}
	
	// 페이지 별 리스트 표시
	public List<ProductVo> getProductList(int page){
		return getProductList("userid", "", page);
	}
	
	// 검색 기능과 페이징을 구현
	public List<ProductVo> getProductList(String column, String keyword, int page){
		String sql = "SELECT * FROM ("
				+ "SELECT ROWNUM N, p.* "
				+ "FROM (SELECT * FROM product where "+column+" like ? order by name ASC)p"
				+ ") "
				+ "WHERE	N BETWEEN ? AND ?";
//		첫번째 ? => 1, 11, 21, 31, 41, => an = 1+(page-1)*10
//		등차수열의 n에 대한 식은 첫번째 A 공차가 B인 경우 => A + B(n-1)
//		두번째 ? => 10, 20, 30, 40 => page*10
		
		ProductVo pVo = null;
		List<ProductVo> list = new ArrayList<ProductVo>();
		
		Connection conn = null;
		PreparedStatement pstmt = null;
		ResultSet rs1 = null;
		
		try {
			conn = DBmanager.getConnection();
			
			// (3 단계) Statement 객체 생성
			pstmt = conn.prepareStatement(sql);
			pstmt.setString(1, "%"+ keyword +"%");
			pstmt.setInt(2, 1+(page-1)*9);		// ex) page = 1  1~10페이지
			pstmt.setInt(3, page*9);
			
			
			// (4 단계) SQL문 실행 및 결과 처리 => executeQuery : 조회(select)
			rs1 = pstmt.executeQuery();
			
			// rs.next() : 다음 행(row)을 확인
			// rs.getString("컬럼명")
			while(rs1.next()){
				
				pVo = new ProductVo();				
				// 디비로부터 회원 정보 획득
				pVo.setCode(rs1.getInt("code"));		// 컬럼명 code 인 정보를 가져옴
				pVo.setName(rs1.getString("name"));		// DB에서 가져온 정보를 pVo객체에 저장
				pVo.setPictureurl(rs1.getString("pictureurl"));
				pVo.setDescription(rs1.getString("description"));
				pVo.setUserid(rs1.getString("userid"));
				
				
				list.add(pVo);	// list 객체에 데이터 추가
				
			}
			
		} catch(Exception e) {
			e.printStackTrace();
			
		} finally {
			DBmanager.close(conn, pstmt, rs1); 
		}
		return list;
	}
	// 특정 컬럼의 키워드를 통해 게시물 수 조회
	
	// 게시물 수 조회
	public int getProductCount() {
		return getProductCount("userid", "");
	}
	
	
	
	// 특정 컬럼의 키워드를 통해 게시물 수 조회
	public int getProductCount(String column, String keyword) {
			String sql = "SELECT COUNT(userid) count FROM ("
			+ "SELECT ROWNUM N, p.* "
			+ "FROM (SELECT * FROM product where "+column+" like ? order by name desc)p"
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
	public ProductVo getNextProduct(int userid) {
		ProductVo pVo = null;
		return pVo;
	}
	
	// 게시물 번호로 특정 게시물 이전 게시물 데이터 조회
	public ProductVo getPrevProduct(int userid) {
		ProductVo pVo = null;
		return pVo;
	}
	
	
	// 사진에 댓글 달기
	public int messageProduct(ProductVo pVo) {
		Connection conn = null;
		PreparedStatement pstmt = null;	// 동적 쿼리
		int result = -1;
			
		String sql = "update product set message=? where code=?";		// ? : 변화가 가능한 변수
			
			
		try {
			conn = DBmanager.getConnection();

			// (3단계) Statement 객체 생성
			pstmt = conn.prepareStatement(sql);	
			pstmt.setString(1, pVo.getMessage());
			pstmt.setInt(2, pVo.getCode());	
				
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
	
}
