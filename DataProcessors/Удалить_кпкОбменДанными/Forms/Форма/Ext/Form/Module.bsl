﻿
&НаСервере
Процедура ВыгрузитьДанныеВФайлXML()
	
	
	Если Объект.ВыбАгент.Пустая() Тогда
		
			Если Элементы.Страницы.ТекущаяСтраница.Имя = "АПСервер" Тогда
				ТаблицаАгентов = Объект.ТабАПСервер;
			Иначе				
				ТаблицаАгентов = кпкАгентПлюс.ПолучитьТаблицуТорговыхАгентов(Объект.Подразделение);
			КонецЕсли;
			
			Обработано = 0;     
			Для Каждого СтрокаТаб Из ТаблицаАгентов Цикл
				Если СтрокаТаб.Пометка Тогда				
					Обработано = Обработано + 1;
					Объект.ВыбАгент = СтрокаТаб.Агент;
					Сообщить(Строка(Обработано) + ". Обработка данных агента: " + СокрЛП(СтрокаТаб.Агент), СтатусСообщения.Информация);
					
					РеквизитФормыВЗначение("Объект").ВыгрузитьДанные();
				КонецЕсли;
			КонецЦикла;	
			
			Объект.ВыбАгент = Справочники.Агенты.ПустаяСсылка();
			РеквизитФормыВЗначение("Объект").ПриИзмененииАгента(Объект.ВыбАгент);
			
		
	Иначе     		
		
		Сообщить("Обработка данных агента: " +  Объект.ВыбАгент + "...", СтатусСообщения.Информация);
		РеквизитФормыВЗначение("Объект").ВыгрузитьДанные();
		
	КонецЕсли;
	
	
КонецПроцедуры 

&НаСервере
Процедура ЗагрузитьДанныеИзФайлаXML()
	
	Если Объект.ВыбАгент.Пустая() Тогда
		
			Если Элементы.Страницы.ТекущаяСтраница.Имя = "АПСервер" Тогда
				ТаблицаАгентов = Объект.ТабАПСервер;
			Иначе				
				ТаблицаАгентов = кпкАгентПлюс.ПолучитьТаблицуТорговыхАгентов(Объект.Подразделение);
			КонецЕсли;
			
			Для Каждого СтрокаТаб Из ТаблицаАгентов Цикл
				Если СтрокаТаб.Пометка Тогда				
					
					Объект.ВыбАгент = СтрокаТаб.Агент;
					
					РеквизитФормыВЗначение("Объект").ЗагрузитьДанныеСАПСервера("ОтветитьНаЗапрос");
				КонецЕсли;
			КонецЦикла;	
			
			Объект.ВыбАгент = Справочники.Агенты.ПустаяСсылка();
			РеквизитФормыВЗначение("Объект").ПриИзмененииАгента(Объект.ВыбАгент);
		
	Иначе     		
		
		РеквизитФормыВЗначение("Объект").ЗагрузитьДанныеСАПСервера("ОтветитьНаЗапрос");
		
	КонецЕсли;

КонецПроцедуры
 

&НаСервере
Процедура ОбновитьТаблицуАгентов()
	
	Обработка = РеквизитФормыВЗначение("Объект");
	Обработка.ЗаполнитьТаблицуАПС();
	ЗначениеВРеквизитФормы(Обработка, "Объект");

КонецПроцедуры // ВыгрузитьДанныеВФайл()

&НаКлиенте
Процедура ВыгрузитьВКПК(Команда)
	
	ОчиститьСообщения();
	
	ВыгрузитьДанныеВФайлXML();	
	
КонецПроцедуры

&НаКлиенте
Процедура ЗагрузитьИзКПК(Команда)
	
	ОчиститьСообщения();
	
	ЗагрузитьДанныеИзФайлаXML();	
	
КонецПроцедуры

&НаКлиенте
Процедура Настройка(Команда)
	
	Если НЕ ЗначениеЗаполнено(Объект.ВыбАгент) тогда
		Возврат;	
	КонецЕсли;
	
	СтруктураДополнительныеНастройки = Новый Структура;
	СтруктураДополнительныеНастройки.Вставить("Агент", Объект.ВыбАгент);
	
	ФормаДопНастроек  = ПолучитьФорму("Обработка.кпкНастройкаАгентПлюс.Форма", СтруктураДополнительныеНастройки);

	ФормаДопНастроек.Открыть();
	
КонецПроцедуры

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Объект.ВидВыгрузки = 1;
	
	Если Объект.СпособОбмена = 0 Тогда
		Объект.СпособОбмена = Константы.кпкСпособОбмена.Получить();
	КонецЕсли;
	
	Объект.РеализацияПоЗаявкам = Константы.кпкРеализацияПоЗаявкам.Получить();
	
	Объект.флАрхив   = Истина;	
	Объект.флОчищатьСправочникиПередЗагрузкой    = Истина;	
	
	ПапкаСервера = СокрЛП(Константы.кпкАПСПапкаОбмена.Получить());
	
	Объект.флОбновлять = Истина;
	Объект.флПроводить = Истина;
	Объект.флВыгрТоварыСНулевОст 	= Истина;
	Объект.РеализацияПоЗаявкам 		= Ложь;
	

	//Результат = РеквизитФормыВЗначение("Объект").НачальнаяУстановка();
	//
	//Если НЕ Результат Тогда
	//	Отказ = Истина;
	//КонецЕсли;
	
	//Если Объект.СпособОбмена = 2 Тогда  				
	//	РеквизитФормыВЗначение("Объект").НастроитьАвтообменССервером();
	//КонецЕсли;    	
	
	
КонецПроцедуры

&НаСервере
Функция ПолучитьДанныеАгентНачалоВыбораИзСписка()
	
	СписокАгентов = Новый СписокЗначений;
	
	СтруктураДанные = Новый Структура();
	СтруктураДанные.Вставить("СписокАгентов", СписокАгентов);

	ТабАгентов = кпкАгентПлюс.ПолучитьТаблицуТорговыхАгентов(Объект.Подразделение);	
	
	Для Каждого СтрАгент Из ТабАгентов Цикл
		СписокАгентов.Добавить(СтрАгент.Агент, СтрАгент.Агент.Наименование);
	КонецЦикла;

	Возврат СтруктураДанные;

КонецФункции 

&НаКлиенте
Процедура ВыбАгентНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;	
	ВыбАгентНачалоВыбораИзСписка(Элемент, СтандартнаяОбработка);
	
КонецПроцедуры

&НаКлиенте
Процедура ВыбАгентНачалоВыбораИзСписка(Элемент, СтандартнаяОбработка)
	
	Элемент.СписокВыбора.Очистить();
	
	СтруктураДанные = ПолучитьДанныеАгентНачалоВыбораИзСписка();
	
	Для каждого ЭлСписка Из СтруктураДанные.СписокАгентов Цикл
		Элемент.СписокВыбора.Добавить(ЭлСписка.Значение, ЭлСписка.Представление);
	КонецЦикла;
	
КонецПроцедуры

&НаКлиенте
Процедура Обновить(Команда)
	ОбновитьТаблицуАгентов();	
КонецПроцедуры

&НаКлиенте
Процедура Отметить(Команда)
	
	Для Каждого Стр Из Объект.ТабАПСервер Цикл
		Стр.Пометка = Истина;
	КонецЦикла;
	
КонецПроцедуры

 &НаСервере
Процедура ФайлНастроекГенерация()
	
	Обработки.кпкАПСГенерацияФайлаНастроек.Создать().ГенерацияФайлаНастроек();

КонецПроцедуры // ФайлНастроекГенерация()

&НаКлиенте
Процедура ГенерацияФайлаНастроек(Команда)
	
	Если Вопрос("Записать новый файл настроек ?", РежимДиалогаВопрос.ДаНет) = КодВозвратаДиалога.Да Тогда
		ФайлНастроекГенерация();
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура СнятьОтметку(Команда)
	
	Для Каждого Стр Из Объект.ТабАПСервер Цикл
		Стр.Пометка = Ложь;
	КонецЦикла;
	
КонецПроцедуры


&НаКлиенте
Процедура ВыбАгентОткрытие(Элемент, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	Если ЗначениеЗаполнено(Объект.ВыбАгент) Тогда
		
		Структура = Новый Структура("Объект", Объект.ВыбАгент);
		Массив = Новый Массив;
		Массив.Добавить(Структура);
		Ключ = Новый("РегистрСведенийКлючЗаписи.кпкСведенияАгента", Массив); 
		
		ПараметрАгент = Новый Структура("Ключ", Ключ);

		Форма = ПолучитьФорму("РегистрСведений.кпкСведенияАгента.ФормаЗаписи",ПараметрАгент);
		Форма.Открыть();
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура СведенияОЗагруженныхДокументах(Команда)
	
	ФормаСписка = ПолучитьФорму("РегистрСведений.кпкСведенияДокумента.ФормаСписка");
	//Отбор 				= ФормаСписка.ЭлементыФормы.РегистрСведенийСписок.Значение.Отбор.Период;
	//Отбор.ВидСравнения  = ВидСравнения.ИнтервалВключаяГраницы;
	//Отбор.ЗначениеС     = НачалоДня(ТекущаяДата());
	//Отбор.ЗначениеПо    = КонецДня(ТекущаяДата());
	//Отбор.Использование = Истина;	
	//
	//Если Не ВыбАгент.Пустая() Тогда
	//	ФормаСписка.ЭлементыФормы.РегистрСведенийСписок.Значение.Отбор.Агент.Установить(ВыбАгент);
	//КонецЕсли;
	
	ФормаСписка.Открыть();
	
КонецПроцедуры


&НаКлиенте
Процедура ЖурналЗагрузок(Команда)
	
	ФормаОтчета = ПолучитьФорму("Отчет.кпкЖурналОбмена.Форма");
	ФормаОтчета.Открыть();
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	Попытка
		КПКОбъектServer1 = Новый COMОбъект("AgentPlus.ApServer");
	Исключение
		ТекстСообщения = "Не удалось создать объекты внешней компоненты APPlusCOM.dll." + 
						 " Возможно компонента APPlusCOM.dll не зарегистрирована на сервере";
		Предупреждение(ТекстСообщения);
		Отказ = истина;
	КонецПопытки;  	
	
КонецПроцедуры


