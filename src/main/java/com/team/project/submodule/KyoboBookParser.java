/**
 * 
 */
package com.team.project.submodule;

import java.io.File;
import java.io.FileOutputStream;
import java.io.InputStream;
import java.net.URL;
import java.net.URLConnection;
import java.util.ArrayList;
import java.util.Random;
import java.util.StringTokenizer;

import org.apache.ibatis.session.SqlSession;
import org.jsoup.Jsoup;
import org.jsoup.nodes.Document;
import org.jsoup.nodes.Element;
import org.jsoup.select.Elements;
import org.springframework.stereotype.Component;

import com.team.project.entities.Author;
import com.team.project.entities.Book;
import com.team.project.entities.Category;
import com.team.project.service.AuthorDAO;
import com.team.project.service.BookDAO;
import com.team.project.service.CategoryDAO;

/**
 * 교보문고를 크롤링하는데 필요한 모든 알고리즘을 모아놓은 클래스입니다.
 * @author : 김영호
 * @date : 2018. 9. 3. 오전 9:26:05
*/
@Component
public class KyoboBookParser {
	/**
	 * 교보문고의 책 상세보기 페이지에서 데이터를 추출해, DB에 삽입합니다.
	 * @param url 삽입할 책 한권의 상세보기 페이지 url주소입니다.
	 * @param session SqlSession을 인자로 넘겨야됨
	 * @author : 김영호
	 * @date : 2018. 9. 3. 오전 9:28:49
	 */
	public boolean parse(String url, SqlSession session) {

		//초기화
		AuthorDAO authorDAO = session.getMapper(AuthorDAO.class);
		BookDAO bookDAO = session.getMapper(BookDAO.class);
		Book book = new Book();
		Author author = new Author();

		//URL 커넥션 시작
		try {
			Document kyobo = Jsoup.connect(url).get();

			//정보 획득
			Element authorname = kyobo.selectFirst(".author .name");
			if(authorname.select(".popup_load").size()>0) {
				author.setName(authorname.selectFirst(".popup_load a").text());
			}else {
				author.setName(authorname.text());
			}
			author.setBirthyear(0);
			author.setDiscription(kyobo.select(".box_detail_author .box_detail_article").html());

			book.setName(kyobo.select(".box_detail_point .title").get(0).text());
			String price = kyobo.select(".org_price").text();
			price = price.replaceAll("[,원]", "");
			book.setPrice(Integer.parseInt(price));
			book.setRealprice(Integer.parseInt(price));
			book.setStock(0);
			
			Elements discription = kyobo.select(".box_detail_content .box_detail_article");
			book.setDiscription(discription.get(0).html());
			
			book.setPublisher(kyobo.select(".author .name[title=\"출판사\"] a").text());

			//컨텐츠리스트 찾기
			//다중선택자 써서 찾아야함
			discription = kyobo.select(".box_detail_content .title_detail_basic, .box_detail_content .box_detail_article");
			String result = null;
			for(int i=0; i<discription.size();i++) {
				if(discription.get(i).text().equals("목차")) {
					result=discription.get(i+1).html();
					break;
				}
			}
			book.setContentlist(result);
			book.setSellerdiscription(kyobo.select(".box_detail_content .box_detail_article .content[style=\"display:none;\"]").last().html());
			
			String date = kyobo.select(".author .date").text();
			StringTokenizer tokenizer = new StringTokenizer(date);
			book.setPublishyear(Integer.parseInt(tokenizer.nextToken().replaceAll("년","")));
			book.setPublishmonth(Integer.parseInt(tokenizer.nextToken().replaceAll("[0월]", "")));
			book.setPublishday(Integer.parseInt(tokenizer.nextToken().replaceAll("일","")));
			
			book.setBooktype(kyobo.select(".box_detail_point h1 .info").text());
			Elements detail = kyobo.select(".table_simple2 tbody tr td");
			book.setIsbn(detail.get(0).text());
			book.setPagenumber(Integer.parseInt(detail.get(1).text().replaceAll("쪽", "")));
			book.setScale(detail.get(2).text());
			
			//카테고리는 기존 어레이에서 랜덤
			ArrayList<Category> catlist = ((CategoryDAO)session.getMapper(CategoryDAO.class)).selectAll();
			book.setCat1(catlist.get(new Random().nextInt(catlist.size())).getName());

			book.setEvaluaternum(0);
			book.setSplashtext("");
			book.setTrailer("");
			
			//저자 입력
			ArrayList<Author> beforeauthor = authorDAO.selectAuthorByName(author.getName());
			int authorkey;
			if(beforeauthor.size() >0) {
				authorkey= beforeauthor.get(0).getCode();
				System.out.println("저자가 중복이므로 기존 키를 사용합니다. ");
			}else {
				authorDAO.insertAuthor(author);
				authorkey=author.getCode();
				System.out.println("저자가 입력되었습니다. :"+author.getName()+", 키 : "+authorkey);
			}
			
			//책 입력
			book.setAuthorcode(authorkey);
			bookDAO.insertBook(book);
			int bookkey=book.getCode();

			//책 사진 다운로드
			File file = new File("D:/TEAMProject/src/main/webapp/resources/images/books/"+bookkey+".jpg");
			file.createNewFile();
			FileOutputStream fos = new FileOutputStream(file); 

			String downloadlink = kyobo.select(".box_detail_cover .cover a img").attr("src");
			URLConnection connection = new URL(downloadlink).openConnection();
			InputStream is = connection.getInputStream();
			int readbyte;
			while((readbyte=is.read())!=-1) { 
				fos.write(readbyte);
			}
			fos.close();
			System.out.println("책이 입력되었습니다. : "+book.getName());
		} catch (Exception e) {
			System.out.println("입력 실패!");
			return false;
		}
		return true;
	}
	
	/**
	 * javascript로 되어있는 교보문고의 링크를 일반적인 링크로 바꾸어줍니다.
	 * @param javascript javascript로 되어있는 링크입니다.
	 * @return 일반적인 url 주소 String을 리턴합니다.
	 * @author : 김영호
	 * @date : 2018. 9. 6. 오후 12:14:31
	 */
	public String parseJavaScriptLink(String javascript){
		javascript = javascript.substring(25,javascript.length()-1);
		StringTokenizer tokenizer = new StringTokenizer(javascript, ",");
		String locale = tokenizer.nextToken().replaceAll("'", "");
		String linkclass = tokenizer.nextToken().replaceAll("'", "");
		String barcode = tokenizer.nextToken().replaceAll("'", "");
		javascript = "http://www.kyobobook.co.kr/product/detailViewKor.laf?mallGb=KOR&ejkGb="+locale+"&linkClass="+linkclass+"&barcode="+barcode;
		return javascript;
	}
}
