package com.team.project;

import java.util.Scanner;

import javax.inject.Inject;

import org.apache.ibatis.session.SqlSession;
import org.jsoup.Jsoup;
import org.jsoup.nodes.Document;
import org.jsoup.nodes.Element;
import org.jsoup.select.Elements;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.junit4.SpringJUnit4ClassRunner;
import org.springframework.test.context.web.WebAppConfiguration;

import com.team.project.submodule.KyoboBookParser;

@RunWith(SpringJUnit4ClassRunner.class)
@ContextConfiguration(
	    locations = "file:src/main/webapp/WEB-INF/spring/**/*.xml" )
@WebAppConfiguration
public class KyoboCrawler {
	@Inject
	SqlSession session;
	@Inject
	KyoboBookParser kyoboParser;
	/**
	 * 교보문고의 책 페이지를 복사하면서 데이터를 파싱하여 도서db에 저장합니다.
	 * 저자는 이미 있을경우 새로 등록하지는 않습니다.
	 * @author : 김영호
	 * @date : 2018. 8. 31. 오전 10:43:28
	 */
	public void crawlOne() {
		Scanner scanner = new Scanner(System.in);
		while(true) {
			System.out.print("url을 입력하십시오 : ");
			String url = scanner.next();
			kyoboParser.parse(url, session);
		}
	}

	/**
	 * 교보문고의 리스트페이지에서 n페이지만큼의 모든 데이터를 파싱합니다.
	 * @author : 김영호
	 * @date : 2018. 9. 6. 오전 11:49:21
	 */
	@Test
	public void crawlList() {
		Document Kyobo;
		Scanner scanner = new Scanner(System.in);
		int amount = 0;
		int failedamount = 0;
		try {
			//데이터 입력
			System.out.println("목표 URL을 입력하세요. 책 리스트가 있는 페이지의 1페이지의 url을 복사하시면 됩니다.");
			System.out.print("URL : ");
			String url = scanner.nextLine();
			System.out.println("몇페이지부터 파싱할지 정해야합니다. 1부터 시작을 추천하며, 한페이지당 20권입니다.");
			System.out.print("페이지 수 :");
			int startpage=scanner.nextInt();
			System.out.println("몇페이지까지 파싱할지 정해야합니다. 한페이지당 20권입니다.");
			System.out.print("페이지 수 :");
			int pages= scanner.nextInt();
			System.out.println("한페이지 파싱후 몇초간 기다리시겠습니까? 너무 짧을경우 교보문고에서 밴먹을수도 있습니다.");
			System.out.print("대기시간(밀리초) : ");
			int waittime= scanner.nextInt();
			
			//파싱 시작
			System.out.println("파싱을 시작합니다..");
			for(int targetpage=startpage; targetpage<=pages; targetpage++) {
				//리스트페이지의 n페이지의 데이터를 얻음
				Kyobo = Jsoup.connect(url)
						.data("targetPage",Integer.toString(targetpage))
						.post();
				//각 타겟주소 리스트를 eachlink에 저장
				Elements eachlink = Kyobo.select(".id_detailli .thumb_cont .detail .title a");
				for(Element one : eachlink) {
					//javascript로 되어있는 타겟주소를 url주소로 변환
					String resulturl = kyoboParser.parseJavaScriptLink(one.attr("href"));

					//추출한url을 통해 해당 url의 책 정보를 파싱해 db에 저장
					boolean issuccess = kyoboParser.parse(resulturl, session);
					
					//추출 완료 후 n초 대기
					amount++;
					if(issuccess==false) {
						failedamount++;
					}
					System.out.println("현재 입력 됨 : "+(amount-failedamount)+"개, 전체 :"+amount+"개, "+targetpage+"페이지 파싱 중..");
					Thread.sleep(waittime);
				}
				System.out.println("현재 페이지의 모든 정보를 획득했습니다. 다음페이지로 넘어갑니다.");
			}
			System.out.println("========= 결과 =========");
			System.out.println("입력 성공 : "+(amount-failedamount)+"개");
			System.out.println("입력 실패 : "+(failedamount)+"개");
			System.out.println("성공률 : "+(((float)(amount-failedamount)/amount)*100)+"%");
			System.out.println("전체 : "+(amount)+"개");
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
	}
	
}

