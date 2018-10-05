package com.team.project.submodule;

import java.util.Optional;

import javax.servlet.http.HttpSession;

import org.aspectj.lang.annotation.Aspect;
import org.aspectj.lang.annotation.Before;

@Aspect
public class LoginAspect {
	
	@Before("execution(* com.team.project.*)")
	public String loginCheck(HttpSession session) {
		System.out.println("이전");
		String optId = (String) Optional.ofNullable(session.getAttribute("sessionid")).orElse("xxx");
		if(optId.equals("xxx")) {
			System.out.println("걸림");
			return "redirect:/";
		}
		System.out.println("끝");
		return "";
	}

}
