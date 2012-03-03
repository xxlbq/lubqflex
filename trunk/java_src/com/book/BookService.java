package com.book;

import com.book.form.BaseParam;
import com.book.form.Book;


public class BookService {

	public Object insertBook(BaseParam p){
		
		Book b = (Book)p;
		if(b.getBookName().equalsIgnoreCase("T")){
			b.setBookName(b.getBookName() + ":T");
		}
		if(b.getBookAuthor().equalsIgnoreCase("T")){
			b.setBookAuthor(b.getBookAuthor() + ":T");
		}
		
		return b;
	}
	
	
	public void test(){
		System.out.println(" BookService test ");
		
	}
}
