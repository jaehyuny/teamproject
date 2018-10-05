package com.team.project.service;

import java.util.ArrayList;

import com.team.project.entities.Author;
import com.team.project.entities.BoardPaging;

public interface AuthorDAO {
	ArrayList<Author> selectAll();
	ArrayList<Author> selectAllPaging(BoardPaging boardpaging);
	int insertAuthor(Author author);
	void deleteAuthor(int code);
	void updateAuthor(Author author);
	Author selectAuthor(int code);
	int selectAuthorCode();
	int selectRowCount(String find);
	ArrayList<Author> selectAuthorByName(String name);
}
