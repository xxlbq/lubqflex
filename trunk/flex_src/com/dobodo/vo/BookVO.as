package com.dobodo.vo
{
	import com.adobe.cairngorm.vo.IValueObject;
	
	[RemoteClass(alias="com.book.form.Book")]
	public class BookVO extends BaseParam implements IValueObject
	{
		public var bookName:String;
    	public var bookAuthor:String;
      	public var bookPrice:String;
      	
		public function BookVO()
		{
			super();
		}
	}
}