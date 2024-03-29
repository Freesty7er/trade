﻿
&НаКлиенте
Процедура КомандаПросмотр(Команда)
	ИмяФайла = Объект.ФайлКарты;
	Если ПустаяСтрока(ИмяФайла) Тогда
		Предупреждение("Для выбранной карты не указан файл карты!", 10);
		Возврат;
	КонецЕсли;
	Если ЗначениеЗаполнено(КаталогКарт) Тогда
		ПолныйПуть = КаталогКарт + "\" + ИмяФайла;
		ФайлФото = Новый Файл(ПолныйПуть);
		Если ФайлФото.Существует() И ФайлФото.ЭтоФайл() Тогда
			Попытка
				ЗапуститьПриложение(ПолныйПуть);
			Исключение
			КонецПопытки;
		Иначе
			Предупреждение("Не найден файл карты (""" + ПолныйПуть + """)!", 10);
		КонецЕсли;
	КонецЕсли;
КонецПроцедуры

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	ВидПриложения = Константы.кпкПриложениеПросмотраКарт.Получить();
	КаталогКарт        = Константы.кпкПапкаКарт.Получить();
	
	Если ВидПриложения = 1 Тогда
		Элементы.СтандартноеПриложение.Видимость = Истина;
		Элементы.Map9Viewer.Видимость            = Ложь;
		Элементы.кнПросмотр.Видимость            = Истина;
	Иначе
		Элементы.СтандартноеПриложение.Видимость		 	= Ложь;
		Элементы.Map9Viewer.Видимость            = Истина;
		Элементы.кнПросмотр.Видимость            = Ложь;
		
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура ФайлКартыНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	Режим  = РежимДиалогаВыбораФайла.Открытие;
	
	Если ВидПриложения = 1 Тогда
		Фильтр = "Все файлы (*.*)|*.*|";
	Иначе
		Фильтр = "Файл Map9 (*.m9)|*.m9";
	КонецЕсли;
	
	ДиалогВыбораФайла = Новый ДиалогВыбораФайла(Режим);
	
	ДиалогВыбораФайла.ПолноеИмяФайла = "";	
	ДиалогВыбораФайла.Фильтр         = Фильтр;
	ДиалогВыбораФайла.Заголовок 	 = "Выберите файл карты"; 	
	ДиалогВыбораФайла.Каталог        = КаталогКарт;
	Если ДиалогВыбораФайла.Выбрать() Тогда
		Файл = Новый Файл(ДиалогВыбораФайла.ПолноеИмяФайла);
		Объект.ФайлКарты = Файл.Имя;
	Иначе
		Предупреждение("Файл не выбран!");
	КонецЕсли;
КонецПроцедуры
