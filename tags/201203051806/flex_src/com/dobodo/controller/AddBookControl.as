package com.dobodo.controller
{
	import com.adobe.cairngorm.control.FrontController;
	import com.dobodo.command.AddBookCommand;
	import com.dobodo.event.AddBookEvent;
	public class AddBookControl extends FrontController
	{
		public function AddBookControl()
		{
   			addCommand(AddBookEvent.EVENT_ADD_BOOK, AddBookCommand);
		}
	}
}