package com.book.form;

import java.io.Serializable;



public class Book extends BaseParam implements Serializable{
	

	
	/**
	 * 
	 */
	private static final long serialVersionUID = -1568174894528425050L;
	
	public String bookName;
	public String bookAuthor;
	public String bookPrice;
	
	
	
	public String getBookName() {
		return bookName;
	}
	public void setBookName(String bookName) {
		this.bookName = bookName;
	}
	public String getBookAuthor() {
		return bookAuthor;
	}
	public void setBookAuthor(String bookAuthor) {
		this.bookAuthor = bookAuthor;
	}
	public String getBookPrice() {
		return bookPrice;
	}
	public void setBookPrice(String bookPrice) {
		this.bookPrice = bookPrice;
	}

	
	
}
