package com.team.project.aop;

import java.lang.annotation.Annotation;
import java.lang.reflect.Method;
import java.util.ArrayList;
import java.util.Arrays;

import javax.servlet.http.HttpSession;

import org.aspectj.lang.ProceedingJoinPoint;
import org.aspectj.lang.annotation.Around;
import org.aspectj.lang.annotation.Aspect;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Component;


@Component
@Aspect
public class LoginAdvice {

	private static final Logger logger = LoggerFactory.getLogger(LoginAdvice.class);
	
	
	@Around("execution(* com.team.project.*Controller.*(..))")
	public Object loginChk(ProceedingJoinPoint pjp) throws Throwable {
		long startTime = System.currentTimeMillis();
		logger.debug("---------------------------------------------");
		logger.debug("조인포인트 배열 : " + Arrays.toString(pjp.getArgs()));
		logger.debug("target 객체 : " + pjp.getTarget());
		logger.debug("Advice 행하는 객체 : " + pjp.getThis());
		logger.debug("대상 객체 메소드의 정보 : " + pjp.getSignature());
		logger.debug("---------------------------------------------");
		
		HttpSession session = null;
		//제외할 메소드를 저장하는 배열
		ArrayList<String> exceptPage = new ArrayList<>();
		exceptPage.add("chat");
		exceptPage.add("login");
		exceptPage.add("logoutForm");
		
		//session을 요구하는 페이지이면, Object o에 session이 들어가있다. session에 그 값을 담는다.
		for(Object o:pjp.getArgs()) {
			//instanceof는 대상의 타입을 비교한다.
			if(o instanceof HttpSession) {
				logger.debug("HttpSession과 같은 타입입니다. HttpSession을 사용한 메소드에 접근했습니다.");
				session = (HttpSession) o;
			}
		}
		//session이 null이 아닌 상황은, session을 꺼내서 사용하는 메소드이다.
		if(session!=null) {
			//실행된 메소드의 이름을 가져온다.
			String thisMethod = pjp.getSignature().getName();
			//제외할 메소드(페이지)가 아니면 로그인체크를 한다.
			if(!exceptPage.contains(thisMethod)) {
				String loginId = (String) session.getAttribute("sessionid");

				boolean ajaxMethodCheck = false;
				/* getDeclaringType()은 대상 조인포인트의 메소드를 선언한 Class를 반환한다.
				 * getDeclaredMethods()는 대상 Class가 선언한 모든 메소드를 반환한다. */
				Method[] methods = pjp.getSignature().getDeclaringType().getDeclaredMethods();
				for(Method item:methods) {
					if(thisMethod.equals(item.getName())) {
						//getAnnotations()는 대상 메소드에 걸린 모든 어노테이션을 배열로 반환한다.
						for(Annotation anno:item.getAnnotations()) {
							//ResponseBody 어노테이션이 사용된 메소드를 찾아 걸러낸다.(ajax 제외하기)
							if(anno.annotationType().toString().contains("ResponseBody")) {
								logger.debug("ResponseBody 감지!!!!");
								ajaxMethodCheck = true;
								break;
							}
						}
						break;
					}
				}
				
				if(ajaxMethodCheck == false && (loginId == null || "".equals(loginId))) {
					return "redirect:/loginForm";
				}
			}
		}
		
		Object result = pjp.proceed();
		logger.debug("pjp.proceed(): " + result);

		long endTime = System.currentTimeMillis();
		logger.debug("작동 시간 : " + (endTime - startTime));
		return result;
	}
	
	
}
