package errorMessages
{
	[Bindable]
	public class ErrorMessageCenter
	{
		public static var tooShortTelephoneNumber:String = "Минимальное количество цифр в номере телефона: 10. Пожалуйста, введите корректный номер телефона.";
		public static var wrongTelephoneNumber:String = "Телефонный номер может состоять только из цифр. Пожалуйста, введите корректный номер телефона";
		public static var wrongEmail:String = "Пожалуйста, введите правильный адрес электронной почты";
		public static var missedEmail:String = "Пожалуйста, введите адрес электронной почты";
		public static var tooShortFirstName:String = "Минимальное число символов в имени: 2. Пожалуйста, введите введите полное имя.";
		public static var tooShortLastName:String = "Минимальное число символов в фамилии: 2. Пожалуйста, введите полное имя.";
		public static var emptyFirstName:String = "Пожалуйста, укажите свое имя";
		public static var emptyLastName:String = "Пожалуйста, укажите свою фамилию";
		public static var passwordsNotMatched:String = "Введенные пароли не совпадают";
		public static var currentEmailIsExist:String = "Пожалуйста, введите другой адрес электронной почты";
	
		// Login messages
		public static var loginError:String = "Пользователя с таким адресом электронной почты или паролем не существует";
		
		// Network error
		public static var networkError:String = "Ошибка при соединении с сервером. Проверьте свое подключение к интернету";
		
		// Window title of error message
		public static var errorMessageTitle:String = "Сообщение об ошибке";
		public static var successMessage:String = "Сообщение";
		
		public static var successAccountCreating:String = "Учетная запись успешно создана";
		
		public static var errorAccountCreating:String = "Учетная запись с данной электронной почтой уже существует ";
		public static var projectCreateError:String = "Ошибка при создании проекта";
		
		// Сообщения, выдаваемые при успешной и неудачной загрузке продукта
		public static var loadFurnitureProductSuccessMessage:String = "Предмет мебели успешно загружен";
		public static var loadFurnitureProductErrorMessage:String = "Во время загрузки предмета мебели произошла ошибка";
		
		// Сообщение, выдаваемое, при неудачном обновлении статуса заказа
		public static var changeOrderStatusErrorMessage:String = "При изменении статуса заказа произошла ошибка. Попробуйте повторить данную процедуру позже";
		
		public static var successOrderCreated:String = "Заказ успешно оформлен";
	}
}