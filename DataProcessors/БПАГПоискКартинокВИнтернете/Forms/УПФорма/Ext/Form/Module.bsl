﻿
&НаКлиенте
Процедура НайтиКартинки(Команда)
	Если СокрЛП(Объект.ПараметрыПоиска) = "" Тогда
		Возврат;
	КонецЕсли;
	Поиск();
КонецПроцедуры

Процедура УдалитьЭлементыПередПоиском()
	МассивНаУдаление = Новый Массив;
	МассивЭлементовНаУдаление = Новый Массив;
	Для Каждого Элемент Из Элементы Цикл
		Если Лев(Элемент.Имя, 8) = "Картинка" И Элемент.Вид = ВидПоляФормы.ПолеКартинки Тогда
			МассивНаУдаление.Добавить(Элемент.Имя);
			МассивЭлементовНаУдаление.Добавить(Элемент);
		КонецЕсли;
	КонецЦикла;
	
	Для Каждого ТекЭлемент Из МассивЭлементовНаУдаление Цикл
		Элементы.Удалить(ТекЭлемент);
	КонецЦикла;
	
	ИзменитьРеквизиты(,МассивНаУдаление);
КонецПроцедуры

Процедура Поиск()	
	УдалитьЭлементыПередПоиском();
	
	// Ищем картинки
	ОбработкаОбъект = РеквизитФормыВЗначение("Объект");
	Результаты = ОбработкаОбъект.НайтиКартинки(1, Объект.ПараметрыПоиска, КоличествоКартинок, НачальнаяКартинка);
	
	Если Результаты = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Элементы.Прогрессор.МаксимальноеЗначение = Результаты.Количество();
	
	СчетчикГруппСтрок = 1;
	СчетчикЭлементов = 1;
	
	Счетчик = 0;
	Для Каждого Результат ИЗ Результаты Цикл		
		
		Прогрессор = Счетчик + 1;
		
		Если СчетчикЭлементов > 5 Тогда
			СчетчикЭлементов = 1;
			СчетчикГруппСтрок = СчетчикГруппСтрок + 1; 
		КонецЕсли;
		
		ИмяКартинки = "Картинка" + Счетчик;
						
		ДобавляемыеРеквизиты = Новый Массив;
		ДобавляемыеРеквизиты.Добавить(Новый РеквизитФормы(ИмяКартинки, Новый ОписаниеТипов("Строка"), ));
		ИзменитьРеквизиты(ДобавляемыеРеквизиты);
		НоваяКартинка = Элементы.Добавить(ИмяКартинки, Тип("ПолеФормы"), Элементы["ГруппаСтрока"+СокрЛП(СчетчикГруппСтрок)]);
		НоваяКартинка.Вид = ВидПоляФормы.ПолеКартинки;
		
		тмпЗаголовок = "" + Результат.Имя + "." + Результат.Расширение;
		НоваяКартинка.Заголовок = ?(СтрДлина(тмпЗаголовок) > 18, Лев(тмпЗаголовок, 17) + "…", тмпЗаголовок);
		
		НоваяКартинка.ПутьКДанным = ИмяКартинки;
		НоваяКартинка.РастягиватьПоВертикали = Ложь;
		НоваяКартинка.РастягиватьПоГоризонтали = Ложь;
		Новаякартинка.Ширина = 15;
		НоваяКартинка.Высота = 5;
		НоваяКартинка.РазмерКартинки = РазмерКартинки.Пропорционально;
		НоваяКартинка.Гиперссылка = Истина;
		НоваяКартинка.УстановитьДействие("Нажатие", "ПолеКартинкиНажатие");
		
		Попытка
			ДвоичныеДанные = Новый ДвоичныеДанные(ПолучитьКартинку(Результат.Ссылка, Результат.Расширение));
			СсылкаНаКартинку = ПоместитьВоВременноеХранилище(ДвоичныеДанные, Объект.ИдентификаторФормы);
			ЭтаФорма[ИмяКартинки] = СсылкаНаКартинку;
		Исключение
			
		КонецПопытки;
		Счетчик = Счетчик + 1;
		СчетчикЭлементов = СчетчикЭлементов + 1;
	КонецЦикла;		
КонецПроцедуры

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	КоличествоКартинок = 10;
	НачальнаяКартинка = 1;
	Объект.КартинкиВыбраны = Ложь;
	
	ОбработкаОбъект = РеквизитФормыВЗначение("Объект");	
	// Создаем объект "VBScript.RegExp" для работы с регулярными выражениями
	Попытка
		ОбработкаОбъект.мRegExp = Новый COMОбъект("VBScript.RegExp");  
	Исключение	
		Отказ = Истина;
		Возврат;
	КонецПопытки;

	ОбработкаОбъект.мRegExp.IgnoreCase = Истина; // Игнорировать регистр
	ОбработкаОбъект.мRegExp.Global = Истина; // Поиск всех вхождений шаблона	
КонецПроцедуры

Функция ПолучитьКартинку(Адрес, Расширение) Экспорт	
	ВремФайл = ПолучитьИмяВременногоФайла(Расширение);
	
	СтруктураАдреса = РазложитьАдрес(Адрес);
	Попытка
		Соединение = Новый HTTPСоединение(СтруктураАдреса.АдресСервера, , , , , , );
		Соединение.Получить(СтруктураАдреса.АдресКартинки, ВремФайл);				
		Возврат ВремФайл;
	Исключение	
	КонецПопытки;
	
	Возврат Неопределено;
КонецФункции

// Функция раскладывает адрес на адрес сервера и адрес картинки
//
Функция РазложитьАдрес(Знач Адрес)
	
	Адрес = СтрЗаменить(Адрес, "http://", "");
	Результат = Новый Структура();
	СтрокиАдреса = СтрЗаменить(Адрес, "/", Символы.ПС);
	Результат.Вставить("АдресСервера", СтрПолучитьСтроку(СтрокиАдреса, 1));	
	АдресКартинки = "";
	Для Сч = 2 По СтрЧислоСтрок(СтрокиАдреса) Цикл
		АдресКартинки = АдресКартинки + СтрПолучитьСтроку(СтрокиАдреса, Сч) + "/";
	КонецЦикла;
	Результат.Вставить("АдресКартинки", Лев(АдресКартинки, СтрДлина(АдресКартинки) - 1));	
	
	Возврат Результат;
	
КонецФункции

&НаКлиенте
Процедура ПолеКартинкиНажатие(Элемент, СтандартнаяОбработка)
	СтандартнаяОбработка = Ложь;
	                                   
	Отбор = Новый Структура;
	Отбор.Вставить("СсылкаНаКартинку", ЭтаФорма[Элемент.Имя]);	
	НайденныеСтроки = Объект.ВыбранныеКартинки.НайтиСтроки(Отбор);
	Если НайденныеСтроки.Количество() = 0 Тогда
		 НоваяСтрока = Объект.ВыбранныеКартинки.Добавить();
         НоваяСтрока.СсылкаНаКартинку = ЭтаФорма[Элемент.Имя];
		 НоваяСтрока.ИмяКартинки = Элемент.Заголовок;
	 Иначе
		 Для Каждого СтрокаТабл Из НайденныеСтроки Цикл
		 Объект.ВыбранныеКартинки.Удалить(СтрокаТабл);
		 КонецЦикла;
	КонецЕсли;
			
	ОбновитьОтображениеКартинок();
КонецПроцедуры

&НаКлиенте
Процедура КнопкаВперед(Команда)
	НачальнаяКартинка = НачальнаяКартинка + КоличествоКартинок;
	Поиск();
КонецПроцедуры

&НаКлиенте
Процедура КнопкаНазад(Команда)
	Если НачальнаяКартинка > 9 Тогда
		НачальнаяКартинка = НачальнаяКартинка - КоличествоКартинок;
		Поиск();
	КонецЕсли;
КонецПроцедуры

Процедура ОбновитьОтображениеКартинок()
	Для Каждого Элемент Из Элементы Цикл
		Если Лев(Элемент.Имя, 8) = "Картинка" И Элемент.Вид = ВидПоляФормы.ПолеКартинки Тогда
			Элемент.ЦветРамки = Новый Цвет;
			Элемент.ЦветТекстаЗаголовка = Новый Цвет;
			Отбор = Новый Структура;
			Отбор.Вставить("СсылкаНаКартинку", ЭтаФорма[Элемент.Имя]);	
			НайденныеСтроки = Объект.ВыбранныеКартинки.НайтиСтроки(Отбор);
			Если НайденныеСтроки.Количество() > 0 Тогда
				Элемент.ЦветРамки = WebЦвета.Синий;
				Элемент.ЦветТекстаЗаголовка = WebЦвета.Синий;
			КонецЕсли;	
		КонецЕсли;
	КонецЦикла;	
КонецПроцедуры

&НаКлиенте
Процедура КнопкаВыбрать(Команда)
	Если Объект.ВыбранныеКартинки.Количество() > 0 Тогда
		Объект.КартинкиВыбраны = Истина;
	КонецЕсли;
	ЭтаФорма.Закрыть();
КонецПроцедуры
