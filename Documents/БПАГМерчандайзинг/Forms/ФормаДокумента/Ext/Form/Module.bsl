﻿//&НаКлиенте
//Перем СтарыйВидАнкеты;

&НаСервереБезКонтекста
Функция ПолучитьКодАгента(Агент)
	
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ
	|	БПАГАгенты.Код
	|ИЗ
	|	Справочник.БПАГАгенты КАК БПАГАгенты
	|ГДЕ
	|	БПАГАгенты.Ссылка = &Ссылка";
	Запрос.УстановитьПараметр("Ссылка", Агент);
	
	Код = "";
	Выборка = Запрос.Выполнить().Выбрать();
	Если Выборка.Следующий() Тогда
		Код = СокрЛП(Выборка.Код);
	КонецЕсли;
	
	Возврат Код;
	
КонецФункции

//&НаКлиенте
//Функция ПолучитьHTMLАнкеты() 
//	КаталогКартинокАгента = КаталогОбмена + ПолучитьКодАгента(Объект.Агент) + "\Images\";
//	
//	СтрокаОтветов = "";
//	Для Каждого тмпСтрока Из СодержимоеАнкеты Цикл
//		
//		Если тмпСтрока.ЭтоГруппа Тогда
//			СтрокаОтветов = СтрокаОтветов + "<br><div><table bgcolor=#F5D0A9 width=""100%""><tr><td><strong>" + тмпСтрока.Наименование + "</strong></td></tr></table></div>";
//		Иначе
//			Ответ = Строка(ЭтаФорма[тмпСтрока.ИмяРеквизита]);
//			
//			СтрокаФото = "";
//			Отбор = Новый Структура();
//			Отбор.Вставить("Вопрос", тмпСтрока.Вопрос);
//			МассивФото = Объект.Картинки.НайтиСтроки(Отбор);
//			Для Каждого тмпФото Из МассивФото Цикл
//				СтрокаФото = СтрокаФото + "<img src=""file://" + КаталогКартинокАгента + тмпФото.Имя + """ width = ""20%"" alt=""" + СокрЛП(тмпСтрока.Код) + """ hspace=3 vspace=3/>";
//			КонецЦикла;
//			
//			СтрокаОтветов = СтрокаОтветов + "<div><span style="" font-size: " + ?(тмпСтрока.РазмерШрифтаВопроса = 0, "12", СокрЛП(тмпСтрока.РазмерШрифтаВопроса)) + "px; color: #" + БПАГ.ПреобразоватьЦветИз10В16(тмпСтрока.ЦветВопроса) + ";"">" + ?(тмпСтрока.Наименование = "", "", тмпСтрока.Наименование + ":") + "</span> <span style="" font-size: " + ?(тмпСтрока.РазмерШрифтаОтвета = 0, "14", СокрЛП(тмпСтрока.РазмерШрифтаОтвета)) + "px; color: #" + БПАГ.ПреобразоватьЦветИз10В16(тмпСтрока.ЦветОтвета) + ";"">" + Ответ + "</span></div>" + СтрокаФото;
//			
//		КонецЕсли;
//	КонецЦикла;
//	
//	Текст = "<!DOCTYPE HTML PUBLIC ""-//W3C//DTD HTML 4.0 Transitional//EN"">
//		|<HTML>
//		|<HEAD>
//		|<META HTTP-EQUIV=""Content-Type"" CONTENT=""text/html; CHARSET=utf-8"">
//		|<TITLE></TITLE>
//		|<STYLE type=""text/css"">
//		|    }
//		|    body, td, th {
//		|        font-size: 14px;
//		|		 font-family: Arial, sans-serif;
//		|    }
//		|    td, th {
//		|        vertical-align: top;
//		|    }
//		|    .left {
//		|        text-align: left;
//		|    }
//		|    .right {
//		|        text-align: right;
//		|    }
//		|    .center {
//		|        text-align: center;
//		|    }
//		|</STYLE>
//		|</HEAD>
//		|<BODY>
//		|<table bgcolor=#F5D0A9 width=""100%""><tr><td><strong>" + Объект.ВидАнкеты + " № " + Объект.Номер + " от " + Объект.Дата + "</td></tr>
//		|<tr><td>" + Объект.Контрагент + "</td></tr>
//		|</strong></p></table><br>" + СтрокаОтветов + "
//		|</BODY>
//		|</HTML>";
//		
//	Возврат Текст;
//		
//КонецФункции

&НаСервере
Процедура СчитатьТЗВРеквизит(ТЗ, ИмяТЗ)
	
	//МассивДобавляемыхРеквизитов = Новый Массив;
	//МассивУдаляемыхРеквизитов = Новый Массив;
	//
	//РеквизитФормы = РеквизитФормыВЗначение(ИмяТЗ);
	//
	//Для Каждого тмпКолонка Из РеквизитФормы.Колонки Цикл
	//	МассивУдаляемыхРеквизитов.Добавить(ИмяТЗ + "." + тмпКолонка.Имя);
	//КонецЦикла;
	//
	//Для Каждого тмпКолонка Из ТЗ.Колонки Цикл
	//	МассивДобавляемыхРеквизитов.Добавить(Новый РеквизитФормы(тмпКолонка.Имя, тмпКолонка.ТипЗначения, ИмяТЗ));
	//	Если тмпКолонка.Имя = "ВариантыОтвета" Тогда
	//		МассивДобавляемыхРеквизитов.Добавить(Новый РеквизитФормы("Вариант", Новый ОписаниеТипов("Строка"), ИмяТЗ + "." + тмпКолонка.Имя));
	//	КонецЕсли;
	//КонецЦикла;
	//
	//ЭтаФорма.ИзменитьРеквизиты(МассивДобавляемыхРеквизитов, МассивУдаляемыхРеквизитов);

	//ЗначениеВРеквизитФормы(ТЗ, ИмяТЗ);
	
КонецПроцедуры

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	КаталогОбмена = БПАГ.БПАГПолучитьНастройку("1СКаталогОбмена");
	
	//ОбновитьПоля();
	
КонецПроцедуры

//&НаКлиенте
//Процедура ПриОткрытии(Отказ)
//	HTMLПросмотрАнкеты = ПолучитьHTMLАнкеты();
//КонецПроцедуры

&НаКлиенте
Процедура КомандаПереключитьВид(Команда)
	Элементы.КнопкаОтладка.Пометка = Не Элементы.КнопкаОтладка.Пометка;
	Элементы.КнопкаМерчандайзинг.Пометка = Не Элементы.КнопкаМерчандайзинг.Пометка;
	
	Элементы.ГруппаОтладка.Видимость = Элементы.КнопкаОтладка.Пометка;
	Элементы.ГруппаТовары.Видимость = Элементы.КнопкаМерчандайзинг.Пометка;
КонецПроцедуры

//&НаСервере
//Процедура ОбновитьПоля()
//	
//	СчитатьТЗВРеквизит(БПАГ.ПолучитьСодержимоеАнкеты(Объект.ВидАнкеты, Объект.Ссылка), "СодержимоеАнкеты");
//	
//	ПрефиксАвтоРеквизитов = "АвтоВопрос";
//	ПрефиксАвтоГрупп = "АвтоГруппа";
//	
//	//Удалим старые элементы и реквизиты.
//	МассивЭлементовНаУдаление = Новый Массив;
//	МассивРеквизитовНаУдаление = Новый Массив;
//	Для Каждого тмпЭлемент Из Элементы Цикл
//		Если Лев(тмпЭлемент.Имя, СтрДлина(ПрефиксАвтоРеквизитов)) = ПрефиксАвтоРеквизитов Тогда
//			
//			Попытка
//				МассивРеквизитовНаУдаление.Добавить(тмпЭлемент.ПутьКДанным);
//			Исключение
//			КонецПопытки;
//			
//			МассивЭлементовНаУдаление.Добавить(тмпЭлемент);
//			
//		ИначеЕсли Лев(тмпЭлемент.Имя, СтрДлина(ПрефиксАвтоГрупп)) = ПрефиксАвтоГрупп Тогда
//			
//			МассивЭлементовНаУдаление.Добавить(тмпЭлемент);
//						
//		КонецЕсли;
//	КонецЦикла;
//	
//	Для Каждого тмпЭлемент Из МассивЭлементовНаУдаление Цикл
//		Попытка
//			Элементы.Удалить(тмпЭлемент);
//		Исключение
//		КонецПопытки;
//	КонецЦикла;
//	
//	ИзменитьРеквизиты( , МассивРеквизитовНаУдаление);
//	
//	МассивРеквизитов = Новый Массив;
//	ГруппаАнкета = Элементы.ГруппаАнкета;
//		
//	//Два прохода. Сначала создаем реквизиты формы, затем соответствующие элементы управления.
//	Для i = 1 По 2 Цикл
//	
//		СчетчикГрупп = 0;
//		СчетчикВопросов = 0;
//		ТекущаяГруппа = ГруппаАнкета;
//	
//		Для Каждого тмпСтрока Из СодержимоеАнкеты Цикл
//			
//			Если тмпСтрока.ЭтоГруппа Тогда
//				
//				Если i = 2 Тогда
//					СчетчикГрупп = СчетчикГрупп + 1;
//					ТекущаяГруппа = Элементы.Добавить(ПрефиксАвтоГрупп + Формат(СчетчикГрупп, "ЧГ=0"), Тип("ГруппаФормы"), ГруппаАнкета);
//					ТекущаяГруппа.Вид = ВидГруппыФормы.ОбычнаяГруппа;
//					ТекущаяГруппа.Заголовок = тмпСтрока.Наименование;
//				КонецЕсли;
//			
//			Иначе
//				
//				СчетчикВопросов = СчетчикВопросов + 1;
//				ИмяРеквизита = ПрефиксАвтоРеквизитов + Формат(СчетчикВопросов, "ЧГ=0");
//				
//				ТипРеквизита = "Строка";
//				Если тмпСтрока.Тип = Перечисления.БПАГТипыВопросовАнкет.Булево Тогда
//					ТипРеквизита = "Булево";
//					
//				ИначеЕсли тмпСтрока.Тип = Перечисления.БПАГТипыВопросовАнкет.Дата Тогда
//					ТипРеквизита = "Дата";
//				
//				ИначеЕсли тмпСтрока.Тип = Перечисления.БПАГТипыВопросовАнкет.Число Тогда
//					ТипРеквизита = "Число";
//				
//				КонецЕсли;
//				
//				Если i = 1 Тогда
//					
//					Реквизит = Новый РеквизитФормы(ИмяРеквизита, Новый ОписаниеТипов(ТипРеквизита), , ?(тмпСтрока.Наименование = "", " ", тмпСтрока.Наименование), Истина);
//					Реквизит.СохраняемыеДанные = Ложь;
//					
//					МассивРеквизитов.Добавить(Реквизит);
//					
//					тмпСтрока.ИмяРеквизита = ИмяРеквизита;
//						
//				Иначе	
//					
//					НовыйВопрос = Элементы.Добавить(ИмяРеквизита, Тип("ПолеФормы"), ТекущаяГруппа);
//					НовыйВопрос.Вид = ВидПоляФормы.ПолеВвода;
//					НовыйВопрос.ПутьКДанным = ИмяРеквизита;
//					НовыйВопрос.УстановитьДействие("ПриИзменении", "ПриИзмененииАвтоРеквизита");
//					
//					Если тмпСтрока.ВариантыОтвета.Количество() > 0 Тогда
//					
//						НовыйВопрос.КнопкаВыпадающегоСписка = Истина;
//						НовыйВопрос.РежимВыбораИзСписка = Истина;
//						
//						Для Каждого тмпВариант Из тмпСтрока.ВариантыОтвета Цикл
//							НовыйВопрос.СписокВыбора.Добавить(тмпВариант.Вариант, тмпВариант.Вариант);
//						КонецЦикла;
//						
//					ИначеЕсли тмпСтрока.Тип = Перечисления.БПАГТипыВопросовАнкет.ДаНет Тогда
//						
//						НовыйВопрос.КнопкаВыпадающегоСписка = Истина;
//						НовыйВопрос.РежимВыбораИзСписка = Истина;
//						НовыйВопрос.Ширина = "5";
//						
//						НовыйВопрос.СписокВыбора.Добавить(" ", " ");
//						НовыйВопрос.СписокВыбора.Добавить("Да", "Да");
//						НовыйВопрос.СписокВыбора.Добавить("Нет", "Нет");
//						
//					ИначеЕсли тмпСтрока.Тип = Перечисления.БПАГТипыВопросовАнкет.Булево Тогда
//						
//						НовыйВопрос.Вид = ВидПоляФормы.ПолеФлажка;
//						
//					КонецЕсли;
//					
//					ЭтаФорма[ИмяРеквизита] = тмпСтрока.Ответ;
//					
//				КонецЕсли;
//				
//			КонецЕсли;
//			
//		КонецЦикла;
//		
//		Если i = 1 Тогда
//			ИзменитьРеквизиты(МассивРеквизитов);
//		КонецЕсли;
//	КонецЦикла;
//	
//КонецПроцедуры

//&НаКлиенте
//Процедура HTMLПросмотрАнкетыПриНажатии(Элемент, ДанныеСобытия, СтандартнаяОбработка)
//	Попытка
//		ФайлКартинки = ДанныеСобытия.Element.href;
//		КодВопроса = ДанныеСобытия.Element.alt;
//		
//		Если Лев(ФайлКартинки, СтрДлина("file:///")) = "file:///" Тогда
//			ФайлКартинки = Сред(ФайлКартинки, СтрДлина("file:///") + 1);
//			
//			МассивФото = БПАГ.ПолучитьМассивКартинокАнкеты(Объект.Ссылка, КодВопроса, КаталогОбмена);
//			
//			П = Новый Структура;
//			П.Вставить("ТекущееФото", ФайлКартинки);
//			П.Вставить("МассивФото", МассивФото);
//			П.Вставить("ЗаголовокГалереи", БПАГ.ПолучитьЗаголовокГалереиКартинок(КодВопроса));

//			ОткрытьФорму("Документ.БПАГАнкета.Форма.ФормаПросмотраКартинок", П);
//			
//		КонецЕсли;
//	Исключение
//	КонецПопытки;
//КонецПроцедуры

//&НаКлиенте
//Процедура ВидАнкетыПриИзменении(Элемент)
//	Если Объект.ВидАнкеты <> СтарыйВидАнкеты Тогда
//		Перезаполнить = СтарыйВидАнкеты.Пустая();
//		
//		Если Не Перезаполнить Тогда
//			Перезаполнить = (Вопрос("При изменении вида анкеты будет очищена структура документа и вся введенная информация! Продолжить?", РежимДиалогаВопрос.ОКОтмена, , , "Пан Агент") = КодВозвратаДиалога.ОК);
//		КонецЕсли;
//			
//		Если Перезаполнить Тогда
//			ОбновитьПоля();
//			СтарыйВидАнкеты = Объект.ВидАнкеты;
//			ОбновитьHTML();
//		Иначе
//			Объект.ВидАнкеты = СтарыйВидАнкеты;
//		КонецЕсли;
//		
//	КонецЕсли;
//КонецПроцедуры

&НаКлиенте
Процедура ПередЗаписью(Отказ, ПараметрыЗаписи)
	
	//Объект.Товары.Очистить();
	//Для Каждого тмпСтрока Из СодержимоеАнкеты Цикл
	//	
	//	Если Не тмпСтрока.ЭтоГруппа Тогда
	//		НоваяСтрока = Объект.Товары.Добавить();
	//		НоваяСтрока.Вопрос = тмпСтрока.Вопрос;
	//		НоваяСтрока.Ответ = ЭтаФорма[тмпСтрока.ИмяРеквизита];
	//	КонецЕсли;
	//КонецЦикла;
	
КонецПроцедуры

//&НаКлиенте
//Процедура ПриИзмененииАвтоРеквизита()
//	ОбновитьHTML();
//	ЭтаФорма.Модифицированность = Истина;
//КонецПроцедуры

//&НаКлиенте
//Процедура ОбновитьHTML()
//	HTMLПросмотрАнкеты = ПолучитьHTMLАнкеты();
//КонецПроцедуры

&НаКлиенте
Процедура ПоказатьПанельОтладки(Команда)
	Элементы.ГруппаКнопокПереключениеВида.Видимость = Истина;
КонецПроцедуры

//СтарыйВидАнкеты = Объект.ВидАнкеты;