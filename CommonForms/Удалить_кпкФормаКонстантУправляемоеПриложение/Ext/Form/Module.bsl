﻿ &НаСервере
// <Описание процедуры>
//
// Параметры
//  <Параметр1>  - <Тип.Вид> - <описание параметра>
//                 <продолжение описания параметра>
//  <Параметр2>  - <Тип.Вид> - <описание параметра>
//                 <продолжение описания параметра>
//
Процедура УстановитьВидимостьДоступность()
 	флПриложение = Булево(НаборКонстант.кпкПриложениеПросмотраКарт - 1);

	Если Не флПриложение Тогда		
		Если Не НаборКонстант.кпкРежимЗагрузкиТреков = 0 Тогда
			НаборКонстант.кпкРежимЗагрузкиТреков = 0;
		КонецЕсли;            		
	КонецЕсли;            		
	
	Элементы.кпкПутьКФайлуЗапускаMap9Viewer.Доступность = флПриложение;	
	Элементы.кпкПапкаТреков.Доступность 		   = флПриложение; 
	Элементы.кпкРежимЗагрузкиТреков.Доступность      = флПриложение; 
	
	Элементы.кпкПогрешностьПриРасчетеФактаПосещенияТочки.Доступность = Не флПриложение; 				
	
	Элементы.кпкПапкаТреков.Доступность  = Булево(НаборКонстант.кпкРежимЗагрузкиТреков); 		
	
	Если НаборКонстант.кпкИнтервалПП = -1
		Или НаборКонстант.кпкИнтервалПП = 7 
		Или НаборКонстант.кпкИнтервалПП = 14 Тогда
		
		Элементы.ДнейПланирования.Видимость  = Ложь;
	Иначе	
		Элементы.ДнейПланирования.Видимость  = Истина;
		ДнейПланирования = НаборКонстант.кпкИнтервалПП;
	КонецЕсли; 
	
	Элементы.кпкРежимПланированияПродаж.Видимость = НаборКонстант.кпкИспользоватьПланыПродаж;
	
	Если НаборКонстант.кпкСпособОбмена = 1 Тогда
		Элементы.АгентСервер.Видимость = Ложь;	
		Элементы.ПрямоеПодключение.Видимость = Истина;	
	ИначеЕсли НаборКонстант.кпкСпособОбмена = 2 Тогда // А+ Сервер
		Элементы.АгентСервер.Видимость = Истина;	
		Элементы.ПрямоеПодключение.Видимость = Ложь;	
	КонецЕсли;

КонецПроцедуры // УстановитьВидимостьДоступность() 

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	ТаблицаЦен = Константы.кпкТипыЦен.Получить().Получить();
	Если Не ТаблицаЦен = Неопределено Тогда
		Для Каждого ТекСтрока Из ТаблицаЦен Цикл
			НоваяСтрока 		  = СписокЦен.Добавить();
			НоваяСтрока.Выгружать = ТекСтрока.Выгружать;
			НоваяСтрока.ТипыЦен   = ТекСтрока.ТипыЦен;
			Если Не ТаблицаЦен.Колонки.Найти("Код") = Неопределено Тогда
				НоваяСтрока.Код	= ТекСтрока.Код;
			КонецЕсли;
		КонецЦикла;
	КонецЕсли;
	
	
	НомерВерсииМодуля =  "10.3.14.3(ver3)";
	
	Если НЕ ЗначениеЗаполнено(Константы.кпкНомерВерсииМодуляОбмена.Получить()) Тогда
		Константы.кпкНомерВерсииМодуляОбмена.Установить(НомерВерсииМодуля);
	КонецЕсли;
	
	Если НЕ ЗначениеЗаполнено(Константы.кпкСпособОбмена.Получить()) Тогда
		НаборКонстант.кпкСпособОбмена = 2;
		Константы.кпкСпособОбмена.Установить(2);
	КонецЕсли;

	УстановитьВидимостьДоступность();

КонецПроцедуры


&НаКлиенте
Процедура кпкИнтервалПППриИзменении(Элемент)
	
	Если НаборКонстант.кпкИнтервалПП = -1
		Или НаборКонстант.кпкИнтервалПП = 7 
		Или НаборКонстант.кпкИнтервалПП = 14 Тогда
		
		Элементы.ДнейПланирования.Видимость  = Ложь;
	
	Иначе	
		Элементы.ДнейПланирования.Видимость  = Истина;
	КонецЕсли; 
	
	
КонецПроцедуры


&НаКлиенте
Процедура кпкИспользоватьПланыПродажПриИзменении(Элемент)
	
	Элементы.кпкРежимПланированияПродаж.Видимость = НаборКонстант.кпкИспользоватьПланыПродаж;
	
КонецПроцедуры


&НаКлиенте
Процедура кпкСпособОбменаПриИзменении(Элемент)
	
	Если НаборКонстант.кпкСпособОбмена = 1 Тогда
		Элементы.АгентСервер.Видимость = Ложь;	
		Элементы.ПрямоеПодключение.Видимость = Истина;	
	ИначеЕсли НаборКонстант.кпкСпособОбмена = 2 Тогда // А+ Сервер
		Элементы.АгентСервер.Видимость = Истина;	
		Элементы.ПрямоеПодключение.Видимость = Ложь;	
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура кпкАПСПапкаОбменаНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	Диалог = Новый ДиалогВыбораФайла(РежимДиалогаВыбораФайла.ВыборКаталога);
	Диалог.Заголовок = "Выберите папку обмена для ""Агент + Сервер""";
	Диалог.МножественныйВыбор = Ложь;
	Диалог.Каталог = НаборКонстант.кпкАПСПапкаОбмена;

	Если Диалог.Выбрать() Тогда
		НаборКонстант.кпкАПСПапкаОбмена = Диалог.Каталог;
	КонецЕсли;
	
КонецПроцедуры


&НаКлиенте
Процедура кпкПапкаКартНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	Диалог = Новый ДиалогВыбораФайла(РежимДиалогаВыбораФайла.ВыборКаталога);
	Диалог.Заголовок = "Выберите каталог хранения карт GPS";
	Диалог.МножественныйВыбор = Ложь;
	Диалог.Каталог = НаборКонстант.кпкПапкаКарт;

	Если Диалог.Выбрать() Тогда
		НаборКонстант.кпкПапкаКарт = Диалог.Каталог;
	КонецЕсли;
	
КонецПроцедуры


&НаКлиенте
Процедура кпкПапкаТрековНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	Диалог = Новый ДиалогВыбораФайла(РежимДиалогаВыбораФайла.ВыборКаталога);
	Диалог.Заголовок = "Выберите каталог хранения треков перемещений агентов";
	Диалог.МножественныйВыбор = Ложь;
	Диалог.Каталог = НаборКонстант.кпкПапкаТреков;

	Если Диалог.Выбрать() Тогда
		НаборКонстант.кпкПапкаТреков = Диалог.Каталог;
	КонецЕсли;
	
КонецПроцедуры


&НаКлиенте
Процедура кпкПутьКФайлуЗапускаMap9ViewerНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	ДиалогВыбора = Новый ДиалогВыбораФайла(РежимДиалогаВыбораФайла.Открытие);
	ДиалогВыбора.Каталог = "C:\Program Files\Map9";
	ДиалогВыбора.Заголовок = "Выберите файл...";
	ДиалогВыбора.Фильтр = "Все файлы (*.*)|*.*|";
	ДиалогВыбора.ПредварительныйПросмотр = Истина;
	ДиалогВыбора.ПроверятьСуществованиеФайла = Истина;
	ДиалогВыбора.МножественныйВыбор = Ложь;
	
	Если ДиалогВыбора.Выбрать() Тогда
		НаборКонстант.кпкПутьКФайлуЗапускаMap9Viewer = ДиалогВыбора.ПолноеИмяФайла;
	КонецЕсли;
	
КонецПроцедуры


&НаКлиенте
Процедура МобильныеУстройства(Команда)
	
	ОткрытьФорму("Справочник.кпкКПК.Форма.ФормаСписка", , ЭтаФорма);
	
КонецПроцедуры

 &НаСервере
// <Описание процедуры>
//
// Параметры
//  <Параметр1>  - <Тип.Вид> - <описание параметра>
//                 <продолжение описания параметра>
//  <Параметр2>  - <Тип.Вид> - <описание параметра>
//                 <продолжение описания параметра>
//
Процедура ФайлНастроекГенерация()
	
	Обработки.кпкАПСГенерацияФайлаНастроек.Создать().ГенерацияФайлаНастроек();

КонецПроцедуры // ФайлНастроекГенерация()
  
	 
&НаКлиенте
Процедура ГенерацияФайлаНастроек(Команда)
	// Вставить содержимое обработчика.
	Если ЭтаФорма.Модифицированность Тогда
		Режим = РежимДиалогаВопрос.ДаНет;
		Ответ = Вопрос("Сначала следует сохранить изменения в текущих настройках. Сохранить изменения сейчас?", Режим, 0);
		Если Ответ = КодВозвратаДиалога.Нет Тогда
			Возврат;
		Иначе
			Записать();
		КонецЕсли; 
	КонецЕсли;
	Если Вопрос("Записать новый файл настроек ?", РежимДиалогаВопрос.ДаНет) = КодВозвратаДиалога.Да Тогда
		ФайлНастроекГенерация();
	КонецЕсли;
КонецПроцедуры


&НаКлиенте
Процедура УстановитьФлажки(Команда)
	
	Для Каждого ТекСтрока Из СписокЦен Цикл
		ТекСтрока.Выгружать = Истина;
	КонецЦикла;
	
КонецПроцедуры


&НаКлиенте
Процедура СнятьФлажки(Команда)
	
	Для Каждого ТекСтрока Из СписокЦен Цикл
		ТекСтрока.Выгружать = Ложь;
	КонецЦикла;
	
КонецПроцедуры

 &НаСервере
Процедура ВыгрузитьВидыЦен()

	СписокТипЦен = Справочники.ТипыЦен.Выбрать();
	Сч = 1;
	Пока СписокТипЦен.Следующий() Цикл
		Если СписокТипЦен.ПометкаУдаления Тогда Продолжить; КонецЕсли;
		НоваяСтрока 		= СписокЦен.Добавить();
		НоваяСтрока.ТипыЦен = СписокТипЦен.Ссылка;
		НоваяСтрока.Код 	= Сч;
		Сч = Сч + 1;
	КонецЦикла;

КонецПроцедуры // ВыгрузитьВидыЦен()
 

&НаКлиенте
Процедура ЗаполнитьПоСправочнику(Команда)
	Если СписокЦен.Количество() > 0 Тогда
		ОчиститьТаблицу = Вопрос("Перед заполнением список цен будет очищен. Если уже производилась выгрузка данных в МУ, то возможны проблемы при обмене данными. Продолжить заполнение?", РежимДиалогаВопрос.ДаНет,, КодВозвратаДиалога.Нет);
		Если ОчиститьТаблицу = КодВозвратаДиалога.Да Тогда
			СписокЦен.Очистить();
		Иначе
			Возврат;		
		КонецЕсли;
	КонецЕсли;
	
	ЭтаФорма.Модифицированность = Истина;
	
	ВыгрузитьВидыЦен();
	
КонецПроцедуры


&НаСервере
Процедура ПриЗаписиНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)
	
	Константы.кпкТипыЦен.Установить(Новый ХранилищеЗначения(СписокЦен.Выгрузить()));
	
	Если НЕ (НаборКонстант.кпкИнтервалПП = -1
		Или НаборКонстант.кпкИнтервалПП = 7 
		Или НаборКонстант.кпкИнтервалПП = 14) Тогда
	
		Константы.кпкИнтервалПП.Установить(ДнейПланирования);
	КонецЕсли; 
	
КонецПроцедуры


&НаКлиенте
Процедура СписокЦенТипыЦенОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	
	НайденныеСтроки = СписокЦен.НайтиСтроки(Новый Структура("ТипыЦен", ВыбранноеЗначение));
	
	Если НайденныеСтроки.Количество() > 0 Тогда		
		Сообщить("Такой тип цен уже есть в списке!", СтатусСообщения.Внимание);
		СтандартнаяОбработка = Ложь;		
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
// <Описание функции>
//
// Параметры
//  <Параметр1>  - <Тип.Вид> - <описание параметра>
//                 <продолжение описания параметра>
//  <Параметр2>  - <Тип.Вид> - <описание параметра>
//                 <продолжение описания параметра>
//
// Возвращаемое значение:
//   <Тип.Вид>   - <описание возвращаемого значения>
//
Функция ОпределитьКодВМУ()
	
 	СписокЦенСорт = СписокЦен.Выгрузить();
	СписокЦенСорт.Сортировать("Код Убыв");
	СтрокаТаб = СписокЦенСорт.Получить(0);
	Если СтрокаТаб = Неопределено Тогда
		Возврат 1;			
	Иначе
		Возврат СтрокаТаб.Код + 1;			
	КонецЕсли;

КонецФункции // ОпределитьКодВМУ()
 

&НаКлиенте
Процедура СписокЦенПриОкончанииРедактирования(Элемент, НоваяСтрока, ОтменаРедактирования)
	
	Если НоваяСтрока Тогда
		Элемент.ТекущиеДанные.Код = ОпределитьКодВМУ();			
	КонецЕсли;
	
КонецПроцедуры


&НаСервере
Процедура ПередЗаписьюНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)
	
	Если НаборКонстант.кпкРежимЗагрузкиТреков = 1 и Не ЗначениеЗаполнено(НаборКонстант.кпкПапкаТреков) Тогда      		
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю("Нужно заполнить константу ""Папка треков перемещений""!");
		Отказ = Истина;  
		Возврат;
	КонецЕсли; 
	
	Сч = 1;
	ЕстьФлВыгрузки = Ложь;
	
	Для Каждого СтрокаТаб Из СписокЦен Цикл
		
		Если СтрокаТаб.Выгружать Тогда
			ЕстьФлВыгрузки = Истина; 
		КонецЕсли;	
			
		Если Не ЗначениеЗаполнено(СтрокаТаб.Код) Тогда
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю("В строке № " + Сч + " не заполнен код типа цены для МУ! Рекомендуется перезаполнить таблицу типов цен!");
			Отказ = Истина;
			Возврат;
			Сч = Сч + 1;
		КонецЕсли;
		
	КонецЦикла;
	
	Если Не ЕстьФлВыгрузки Тогда
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю("Не включено ни одного типа цены для выгрузки в МУ!");
		Отказ = Истина;
		Возврат;
	КонецЕсли;
	
	СписокЦенСорт = СписокЦен.Выгрузить(); 
	СписокЦенСорт.Сортировать("Код Возр");	
	ПредЗнач = "";
	Для Каждого СтрокаТаб Из СписокЦенСорт Цикл
		Если ПредЗнач = СтрокаТаб.Код Тогда
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю("Найден дублирующийся код типа цены для МУ: " + СтрокаТаб.Код + ". Рекомендуется перезаполнить таблицу типов цен!");
			Отказ = Истина;	
			Возврат;
		КонецЕсли;		
		ПредЗнач = СтрокаТаб.Код;
	КонецЦикла; 	
	
	ЕстьОшибки = Ложь;
	Если (Не ЗначениеЗаполнено(НаборКонстант.кпкАПССервер) или Не ЗначениеЗаполнено(НаборКонстант.кпкАПСПапкаОбмена)) и НаборКонстант.кпкСпособОбмена = 2 Тогда
		ЕстьОшибки = Обработки.кпкАПСГенерацияФайлаНастроек.Создать().ПроверкаНастроекАгентСервера(НаборКонстант.кпкАПСПапкаОбмена, НаборКонстант.кпкАПССервер, "");
	КонецЕсли;
	
	Отказ = ЕстьОшибки; 
	
КонецПроцедуры


&НаКлиенте
Процедура кпкПриложениеПросмотраКартПриИзменении(Элемент)
	УстановитьВидимостьДоступность();	
КонецПроцедуры


&НаКлиенте
Процедура кпкРежимЗагрузкиТрековПриИзменении(Элемент)
	УстановитьВидимостьДоступность();	
КонецПроцедуры


&НаКлиенте
Процедура ПросмотрФайлаНастроек(Команда)
	
	ИмяФайла = СокрЛП(НаборКонстант.кпкАПСПапкаОбмена) + "\config.xml";
	
	ЗапуститьПриложение(ИмяФайла);
	
КонецПроцедуры


&НаКлиенте
Процедура ПерезапуститьСлужбу(Команда)
	Если Вопрос("Перезапустить службу ""Агент Плюс СОД"" ?", РежимДиалогаВопрос.ДаНет) = КодВозвратаДиалога.Нет Тогда
		Возврат;
	КонецЕсли;
	
	
	Попытка
		КомандаСистемы("net stop ""Agent Plus Service""");
		КомандаСистемы("net start ""Agent Plus Service""");
	Исключение
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю("Не удалось выполнить перезапуск службы!");
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю("Причина: " + ОписаниеОшибки());					
	КонецПопытки;				
	
КонецПроцедуры


&НаКлиенте
Процедура ПередЗаписью(Отказ, ПараметрыЗаписи)
	
КонецПроцедуры

