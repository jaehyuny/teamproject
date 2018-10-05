package com.team.project.submodule;

import java.util.LinkedList;
import java.util.Random;

import org.springframework.stereotype.Component;

@Component
public class ChatNicknames {
	LinkedList<String> nicknames = new LinkedList<>();
	LinkedList<String> nicknamesFront = new LinkedList<>();
	LinkedList<String> original_nicknames = new LinkedList<>();
	Random ran = new Random();
	
	public ChatNicknames() {
		nicknamesFront.add("친절한 ");
		nicknamesFront.add("사나운 ");
		nicknamesFront.add("용맹한 ");
		nicknamesFront.add("게으른 ");
		nicknamesFront.add("똑똑한 ");
		nicknamesFront.add("멍청한 ");
		nicknamesFront.add("부지런한 ");
		nicknamesFront.add("나약한 ");
		nicknamesFront.add("튼튼한 ");
		nicknamesFront.add("여린 ");
		nicknamesFront.add("굳센 ");
		nicknamesFront.add("시끄러운 ");
		nicknamesFront.add("슬픈 ");
		nicknamesFront.add("익명의 ");
		nicknamesFront.add("특별한 ");
		nicknamesFront.add("치사한 ");
		nicknamesFront.add("소심한 ");
		nicknamesFront.add("겁쟁이 ");
		nicknamesFront.add("허세부리는 ");
		nicknamesFront.add("정중한 ");
		nicknamesFront.add("열정적인 ");
		nicknamesFront.add("활발한 ");
		nicknamesFront.add("욕심쟁이 ");
		
		nicknames.add("고양이");
		nicknames.add("푸들");
		nicknames.add("호랑이");
		nicknames.add("물소");
		nicknames.add("들개");
		nicknames.add("적토마");
		nicknames.add("가물치");
		nicknames.add("멸치");
		nicknames.add("참치");
		nicknames.add("고등어");
		nicknames.add("한우");
		nicknames.add("돼지");
		nicknames.add("흑염소");
		nicknames.add("치타");
		nicknames.add("해달");
		nicknames.add("강아지");
		nicknames.add("개구리");
		nicknames.add("다람쥐");
		nicknames.add("사슴");
		nicknames.add("코끼리");
		nicknames.add("고라니");
		nicknames.add("사자");
		nicknames.add("악어");
		nicknames.add("참새");
		nicknames.add("독수리");
		nicknames.add("원숭이");
		nicknames.add("오소리");
		nicknames.add("상어");
		nicknames.add("돌고래");
		nicknames.add("미어캣");
		
		for(String item:nicknames) {
			original_nicknames.add(item);
		}
	}
	
	public String popRandomName() {
		System.out.println("original : " + original_nicknames.size());
		System.out.println("Nicknames.size() : " + nicknames.size());
		String prefix = nicknamesFront.get(ran.nextInt(nicknamesFront.size()));
		String nickname =  nicknames.get(ran.nextInt(nicknames.size()));
		nicknames.remove(nickname);
		return prefix + nickname;
	}
	
	public void returnName(String name) {
		for(String item:original_nicknames) {
			if(name.contains(item) && !nicknames.contains(item)) {
				nicknames.add(item);
			}
		}
	}
	
}
