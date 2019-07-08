﻿Перем БазовыйАдрес 	Экспорт;
Перем ANT_LOGIN 	Экспорт;	// логин клиента
Перем ANT_PASSWORD 	Экспорт;	// пароль клиента
Перем ANT_DEBUG 	Экспорт;	// логин клиента
Перем ДатаМаршрутов Экспорт;	// дата выгружаемых/загружаемых маршрутов


Перем соединение;
Перем идентификторСессии;
Перем uriПространстваИмен;

Процедура ВыполнитьАвторизациюНаСервере()
	
	
	//соединение = Новый HTTPСоединение(БазовыйАдрес);
	//ответ = соединение.Получить(Новый HTTPЗапрос("config?req=srv"));
	//строкаОтвета = ответ.ПолучитьТелоКакСтроку();
	//
	//адресСервиса = СтрЗаменить(строкаОтвета, "http://", "");
	
	соединение = Новый HTTPСоединение(БазовыйАдрес);
	ответ = соединение.Получить(Новый HTTPЗапрос("config?req=api"));
	строкаОтвета = ответ.ПолучитьТелоКакСтроку();
	
	адресСервиса = СтрЗаменить(строкаОтвета, "https://", "");
	
	
	соединение = Новый HTTPСоединение(адресСервиса);
	
	методСервиса		= "DEX_UserAuthorization";
	методСервисаОтвет 	= "DEX_UserAuthorization";
	
	запрос = Новый HTTPЗапрос(методСервиса);
	запрос.УстановитьТелоИзСтроки("type=login&format=xml&email=" + ANT_LOGIN + "&pass="+ANT_PASSWORD, КодировкаТекста.UTF8);
	
	ответ = соединение.ОтправитьДляОбработки(запрос);
	
	чтениеXML = Новый ЧтениеXML;
	чтениеXML.УстановитьСтроку(ответ.ПолучитьТелоКакСтроку());
	
	ОбъектXDTO = ФабрикаXDTO.ПрочитатьXML(ЧтениеXML,ФабрикаXDTO.Тип(uriПространстваИмен, методСервисаОтвет));
	
	идентификторСессии = ОбъектXDTO.Session_Ident;
	
КонецПроцедуры	// АвторизацияНаСервере()	

Функция ПолучитьСправочники() Экспорт
	
	ВыполнитьАвторизациюНаСервере();
	
	методСервиса		= СтрШаблон("DEX_RefExport_JSON?Session_Ident=%1&format=xml",идентификторСессии);
	методСервисаОтвет 	= "DEX_RefExport";

	запрос = Новый HTTPЗапрос(методСервиса);
	
	ответ = соединение.Получить(запрос);
	
	чтениеXML = Новый ЧтениеXML;
	чтениеXML.УстановитьСтроку(ответ.ПолучитьТелоКакСтроку());
	
	ОбъектXDTO = ФабрикаXDTO.ПрочитатьXML(ЧтениеXML,ФабрикаXDTO.Тип("http://www.ant-logistics.com.ua/", методСервисаОтвет));
	
	Для Каждого текКонтрагент Из ОбъектXDTO.Comps.DEX_Comp Цикл
		
		сообщить(СтрШаблон("код - %1, широта - %2, долгота - %3",текКонтрагент.comp_code, текКонтрагент.lat, текКонтрагент.lng));
		
	КонецЦикла;
	
	Возврат (1);
	
КонецФункции

функция ПолучитьМаршруты(узелОбмена) Экспорт
	
	имяСобытияЖурналаРегистрации = НСтр("ru = 'Обмен данными ANTLOGI'");
	каталогВременныхФайлов = Константы.МЛ_КаталогХраненияЖурналовОбмена.Получить();
	
	ВыполнитьАвторизациюНаСервере();
	
	ДатаПолучаемыхМаршрутов = КонецДня(ДатаМаршрутов) + 1;
	
	методСервиса		= СтрШаблон("DEX_Export_Response_JSON?Session_Ident=%1&Date_Data=%2&format=xml",идентификторСессии, Формат(ДатаПолучаемыхМаршрутов, "ДФ=dd.MM.yyyy"));
	методСервисаОтвет 	= "DEX_Export_Response";

	запрос = Новый HTTPЗапрос(методСервиса);
	
	ответ = соединение.Получить(запрос);

	строкаDEX_Export_Response = ответ.ПолучитьТелоКакСтроку();
	
	чтениеXML = Новый ЧтениеXML;
	чтениеXML.УстановитьСтроку(строкаDEX_Export_Response);
	
	ОбъектXDTO = ФабрикаXDTO.ПрочитатьXML(ЧтениеXML,ФабрикаXDTO.Тип("http://www.ant-logistics.com.ua/", методСервисаОтвет));	
	
	Если ANT_DEBUG Тогда
		
		текстСообщения = СтрШаблон(НСтр("ru = 'Загрузка маршрутов за: %1'"), Формат(ДатаПолучаемыхМаршрутов, "ДФ=dd.MM.yyyy"));
		
		ЗаписьЖурналаРегистрации(имяСобытияЖурналаРегистрации, 
					УровеньЖурналаРегистрации.Предупреждение, 
					Метаданные.ПланыОбмена.ОбменСМуравьинойЛогистикой, 
					узелОбмена, 
					текстСообщения);
		
		меткаДляФайла = СокрЛП(новый УникальныйИдентификатор());
		
		временныйФайл = ПолучитьИмяВременногоФайла("xml");
		текст = Новый ТекстовыйДокумент;
		текст.УстановитьТекст(строкаDEX_Export_Response);
		текст.Записать(временныйФайл);
		КопироватьФайл(временныйФайл, каталогВременныхФайлов + "\"+меткаДляФайла+"-DEX_Export_Response.xml");
		
		
		
	КонецЕсли;
	
	Возврат (ОбъектXDTO);
	
КонецФункции

функция ВыгрузитьЗаявкиПоУзлуОбмена(узелОбмена) Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	
	каталогВременныхФайлов = Константы.МЛ_КаталогХраненияЖурналовОбмена.Получить();
	
	структураОтвета = Новый Структура("результат, сообщение", Ложь, "");
	
	имяСобытияЖурналаРегистрации = НСтр("ru = 'Обмен данными ANTLOGI'");
	
	
	запрос = Новый Запрос;
	запрос.МенеджерВременныхТаблиц = Новый МенеджерВременныхТаблиц;
	
	#Область ТекстЗапроса
	
	запрос.Текст =
	"ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	КпкЗаявкаИзменения.Ссылка КАК Ссылка
	|ИЗ
	|	Документ.КпкЗаявка.Изменения КАК КпкЗаявкаИзменения
	|ГДЕ
	|	КпкЗаявкаИзменения.Узел = &Узел
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	КпкЗаявкаИзменения.Ссылка КАК Документ,
	|	Контрагент.Код КАК Comp_Code,
	|	Контрагент.Наименование КАК Comp_Name,
	|	Контрагент.АдресДоставкиУлица.Наименование КАК Street,
	|	Контрагент.АдресДоставкиДом КАК House,
	|	"""" КАК Postcode,
	|	Контрагент.АдресДоставкиГород.Наименование КАК City,
	|	""UA"" КАК Country,
	|	Контрагент.ГПСШирота КАК lat,
	|	Контрагент.ГПСДолгота КАК lng,
	|	ЧАС(Контрагент.РИНКАЙ_ВременноеОкноС_1) * 3600 + МИНУТА(Контрагент.РИНКАЙ_ВременноеОкноС_1) * 60 + СЕКУНДА(Контрагент.РИНКАЙ_ВременноеОкноС_1) КАК StartFirstTimeWindow,
	|	ЧАС(Контрагент.РИНКАЙ_ВременноеОкноДо_1) * 3600 + МИНУТА(Контрагент.РИНКАЙ_ВременноеОкноДо_1) * 60 + СЕКУНДА(Контрагент.РИНКАЙ_ВременноеОкноДо_1) КАК EndFirstTimeWindow,
	|	МИНУТА(Контрагент.РИНКАЙ_АдминистративноеВремя) КАК Unload_Time,
	|	ВЫРАЗИТЬ(КпкЗаявкаИзменения.Ссылка.Номер КАК СТРОКА(11)) КАК Request_Num,
	|	"""" КАК Additional_Info,
	|	КпкЗаявкаИзменения.Ссылка.Комментарий КАК Note,
	|	ВесПоЗаказам.Вес КАК QtyW,
	|	ВесПоЗаказам.Количество КАК Qty,
	|	ВЫБОР
	|		КОГДА КпкЗаявкаИзменения.Ссылка.МаршрутРазвоза = ЗНАЧЕНИЕ(Справочник.МаршрутыРазвоза.ПустаяСсылка)
	|			ТОГДА """"
	|		ИНАЧЕ КпкЗаявкаИзменения.Ссылка.МаршрутРазвоза.Наименование
	|	КОНЕЦ КАК CompGroup_Name,
	|	КпкЗаявкаИзменения.НомерСообщения,
	|	ДОБАВИТЬКДАТЕ(НАЧАЛОПЕРИОДА(КпкЗаявкаИзменения.Ссылка.Дата, ДЕНЬ), ДЕНЬ, 1) КАК ДатаМаршрутаДляВыгрузки,
	|	ЕСТЬNULL(ВесПоЗаказам.profit, 0) КАК Profit,
	|	0 КАК Profit3
	|ИЗ
	|	Документ.КпкЗаявка.Изменения КАК КпкЗаявкаИзменения
	|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.Контрагенты КАК Контрагент
	|		ПО КпкЗаявкаИзменения.Ссылка.Контрагент = Контрагент.Ссылка
	|		ЛЕВОЕ СОЕДИНЕНИЕ (ВЫБРАТЬ
	|			КпкЗаявкаЗапасы.Ссылка КАК Ссылка,
	|			СУММА(КпкЗаявкаЗапасы.Количество) КАК Количество,
	|			СУММА(КпкЗаявкаЗапасы.Номенклатура.Вес * КпкЗаявкаЗапасы.Количество) КАК Вес,
	|			СУММА(ВЫРАЗИТЬ(КпкЗаявкаЗапасы.Количество * (ЕСТЬNULL(ЦеныНоменклатурыПродажа.Цена, 0) * (1 - ЕСТЬNULL(АвтоматическиеСкидки.ПроцентСкидки, 0) / 100) - ЕСТЬNULL(ЦеныНоменклатурыЗакупка.Цена, 0)) КАК ЧИСЛО(12, 2))) КАК profit
	|		ИЗ
	|			Документ.КпкЗаявка.Запасы КАК КпкЗаявкаЗапасы
	|				ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ЦеныНоменклатуры.СрезПоследних(, ТипЦен.Код = ""000000001"") КАК ЦеныНоменклатурыЗакупка
	|				ПО КпкЗаявкаЗапасы.Ссылка.Подразделение = ЦеныНоменклатурыЗакупка.Подразделение
	|					И КпкЗаявкаЗапасы.Номенклатура = ЦеныНоменклатурыЗакупка.Номенклатура
	|				ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ЦеныНоменклатуры.СрезПоследних КАК ЦеныНоменклатурыПродажа
	|				ПО КпкЗаявкаЗапасы.Ссылка.Подразделение = ЦеныНоменклатурыПродажа.Подразделение
	|					И КпкЗаявкаЗапасы.Ссылка.ТипЦен = ЦеныНоменклатурыПродажа.ТипЦен
	|					И КпкЗаявкаЗапасы.Номенклатура = ЦеныНоменклатурыПродажа.Номенклатура
	|				ЛЕВОЕ СОЕДИНЕНИЕ Справочник.АвтоматическиеСкидки КАК АвтоматическиеСкидки
	|				ПО КпкЗаявкаЗапасы.Ссылка.Контрагент = АвтоматическиеСкидки.Владелец
	|					И КпкЗаявкаЗапасы.Номенклатура.Родитель = АвтоматическиеСкидки.Группа
	|					И КпкЗаявкаЗапасы.Номенклатура.ЦеноваяГруппа = АвтоматическиеСкидки.ЦеноваяГруппа
	|					И (АвтоматическиеСкидки.ПометкаУдаления = ЛОЖЬ)
	|		
	|		СГРУППИРОВАТЬ ПО
	|			КпкЗаявкаЗапасы.Ссылка) КАК ВесПоЗаказам
	|		ПО КпкЗаявкаИзменения.Ссылка = ВесПоЗаказам.Ссылка
	|ГДЕ
	|	КпкЗаявкаИзменения.Узел = &Узел
	|ИТОГИ ПО
	|	ДатаМаршрутаДляВыгрузки";
	
	#КонецОбласти
	
	запрос.УстановитьПараметр("Узел", узелОбмена);
	
	результатЗапроса = запрос.ВыполнитьПакет();
	
	Если результатЗапроса[0].Пустой() Тогда
		
		текстСообщения = СтрШаблон(НСтр("ru = 'Узел: %1. Отсутствует информация для выгрузки'"), узелОбмена);
		
		Если ANT_DEBUG Тогда
			
			ЗаписьЖурналаРегистрации(имяСобытияЖурналаРегистрации, 
					УровеньЖурналаРегистрации.Предупреждение, 
					Метаданные.ПланыОбмена.ОбменСМуравьинойЛогистикой, 
					узелОбмена, 
					текстСообщения);		
		КонецЕсли;
		
		структураОтвета.результат = Ложь;
		структураОтвета.сообщение = текстСообщения;
		
		Возврат структураОтвета;
		
	КонецЕсли;
	
	ВыполнитьАвторизациюНаСервере();
	
	НачатьТранзакцию();
	
	#Область Блокировка
	блокировка = Новый БлокировкаДанных;
	
	элементБлокировки = блокировка.Добавить();
	элементБлокировки.Область = "Документ.кпкЗаявка";
	элементБлокировки.Режим = РежимБлокировкиДанных.Исключительный;
	//элементБлокировки.ИсточникДанных = результатЗапроса.Выгрузить();
	элементБлокировки.ИсточникДанных = результатЗапроса[0];
	элементБлокировки.ИспользоватьИзИсточникаДанных("Ссылка", "Ссылка");
	
	элементБлокировки = блокировка.Добавить();
	элементБлокировки.Область = "ПланОбмена.ОбменСМуравьинойЛогистикой";
	элементБлокировки.Режим = РежимБлокировкиДанных.Исключительный;
	элементБлокировки.УстановитьЗначение("Ссылка", узелОбмена);
	
	блокировка.Заблокировать();
	#КонецОбласти
	
	выборкаПоДням = результатЗапроса[1].Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам, "ДатаМаршрутаДляВыгрузки");
	Пока выборкаПоДням.Следующий() Цикл
		
		//датаМаршрутовДляВыгрузки = КонецДня(ДатаМаршрутов) + 1;
		датаМаршрутовДляВыгрузки = выборкаПоДням.ДатаМаршрутаДляВыгрузки;
		
		количествоЗаявок = 0;
		
		ArrayOfDEX_ImportXDTO = ФабрикаXDTO.Создать(ФабрикаXDTO.Тип(uriПространстваИмен, "ArrayOfDEX_Import"));
		
		выборка = выборкаПоДням.Выбрать();
		Пока выборка.Следующий() Цикл
			
			Если (выборка.Qty = Null) Или (выборка.QtyW = Null) Тогда
				Продолжить;
			КонецЕсли;
			
			DEX_ImportXDTO = ФабрикаXDTO.Создать(ФабрикаXDTO.Тип(uriПространстваИмен, "DEX_Import"));
			
			ЗаполнитьЗначенияСвойств(DEX_ImportXDTO, выборка);
			
			DEX_ImportXDTO.Address = ?(ПустаяСтрока(выборка.City),"",выборка.City+", ")+?(ПустаяСтрока(выборка.Street),"",выборка.Street+", ")+СокрЛП(выборка.House);
			DEX_ImportXDTO.TimeWork_Beg = Формат(НачалоДня(ТекущаяДата())+ выборка.StartFirstTimeWindow, "ДФ=ЧЧ:мм");
			DEX_ImportXDTO.TimeWork_End = Формат(НачалоДня(ТекущаяДата())+ выборка.EndFirstTimeWindow, "ДФ=ЧЧ:мм");
			
			ArrayOfDEX_ImportXDTO.DEX_Import.Добавить(DEX_ImportXDTO);
			
			количествоЗаявок = количествоЗаявок + 1;
			
		КонецЦикла;
		
		
		ArrayOfDEX_ImportXML = Новый ЗаписьXML;
		ArrayOfDEX_ImportXML.УстановитьСтроку("UTF-8");
		ArrayOfDEX_ImportXML.ЗаписатьОбъявлениеXML();
		
		ФабрикаXDTO.ЗаписатьXML(ArrayOfDEX_ImportXML, ArrayOfDEX_ImportXDTO); 
		строкаArrayOfDEX_ImportXML = ArrayOfDEX_ImportXML.Закрыть();
		
		//уберем атрибуты xmlns
		текстовыйДокумент = Новый ТекстовыйДокумент;
		текстовыйДокумент.УстановитьТекст(строкаArrayOfDEX_ImportXML);
		текстовыйДокумент.ЗаменитьСтроку(2, "<ArrayOfDEX_Import>");
		
		строкаArrayOfDEX_ImportXML = ЗаменитьНеЧитаемыеСимволыИзСтроки(ТекстовыйДокумент.ПолучитьТекст());
		
		// отправка данных на сервер
		запрос = Новый HTTPЗапрос("DEX_Import_Request_JSON");
		//параметрыЗапроса = "Session_Ident="+идентификторСессии+
		//	"&Date_Data="+Формат(датаМаршрутовДляВыгрузки, "ДФ=dd.MM.yyyy")+
		//	"&format=xml&remove=0&Comps=" + строкаArrayOfDEX_ImportXML;
			
		параметрыЗапроса = СтрШаблон("Session_Ident=%1&Date_Data=%2&format=xml&remove=0&Comps=%3",идентификторСессии,Формат(датаМаршрутовДляВыгрузки, "ДФ=dd.MM.yyyy"),строкаArrayOfDEX_ImportXML);
		
		//СтрокаЗапроса.Закрыть()+"&Automobiles="+мСтрокаЗапроса.Закрыть();
		
		запрос.УстановитьТелоИзСтроки(параметрыЗапроса, КодировкаТекста.UTF8);
		
		ответ = соединение.ОтправитьДляОбработки(запрос);
		текстОтвета = Ответ.ПолучитьТелоКакСтроку();
		
		чтениеXML = Новый ЧтениеXML;
		чтениеXML.УстановитьСтроку(текстОтвета);
		
		BaseResponseXDTO = ФабрикаXDTO.ПрочитатьXML(чтениеXML,ФабрикаXDTO.Тип(uriПространстваИмен, "BaseResponse"));
		
		Если BaseResponseXDTO.ErrorResponse.error = "OK" Тогда
			структураОтвета.результат = Истина;
		Иначе
			структураОтвета.результат = Ложь;
			структураОтвета.сообщение = BaseResponseXDTO.ErrorResponse.msg;
		КонецЕсли;
		
		Если ANT_DEBUG Тогда
			
			текстСообщения = СтрШаблон(НСтр("ru = 'Узел: %1 (%2). Заказов (%3) на сервер: %4'"), узелОбмена, датаМаршрутовДляВыгрузки, количествоЗаявок,структураОтвета.сообщение);
			
			ЗаписьЖурналаРегистрации(имяСобытияЖурналаРегистрации, 
				УровеньЖурналаРегистрации.Предупреждение, 
				Метаданные.ПланыОбмена.ОбменСМуравьинойЛогистикой, 
				узелОбмена, 
				текстСообщения);
			
			меткаДляФайла = СокрЛП(новый УникальныйИдентификатор());
			
			//Если Не структураОтвета.результат Тогда
				временныйФайл = ПолучитьИмяВременногоФайла("xml");
				текст = Новый ТекстовыйДокумент;
				текст.УстановитьТекст(строкаArrayOfDEX_ImportXML);
				текст.Записать(временныйФайл);
				КопироватьФайл(временныйФайл, каталогВременныхФайлов+"\"+меткаДляФайла+"-comps.xml");
			//КонецЕсли;
			
			
		КонецЕсли;
		
		Если Не структураОтвета.результат Тогда
			Прервать;
		КонецЕсли; 
		
	КонецЦикла;
	
	// если ответ = "ОК" (обмен прошел успешно), меняем номер сообщения
	Если  структураОтвета.результат Тогда
		УстановитьНомерСообщенияУзла(узелОбмена);
	КонецЕсли;
	
	ЗафиксироватьТранзакцию();
	
	Возврат структураОтвета;
	
КонецФункции

#Область ДополнительныеПроцедурыИФункции

Функция УстановитьНомерСообщенияУзла(узел)
	
	номерРевизии = узел.НомерОтправленного + 1;
	
	узелОбъект = узел.ПолучитьОбъект();
	узелОбъект.НомерОтправленного = НомерРевизии;
	узелОбъект.НомерПринятого = узелОбъект.НомерПринятого + 1;
	
	ПланыОбмена.УдалитьРегистрациюИзменений(узел);
	
	узелОбъект.Записать();
	
	Возврат номерРевизии;	
	
КонецФункции

Функция ЗаменитьНеЧитаемыеСимволыИзСтроки(Знач анализируемыйТекст, заменятьСимволы = Истина) 

	итоговаяСтрока = анализируемыйТекст;
	
    // Читаемые символы. 
    соответствиеСимволов = Новый Соответствие;
	
	соответствиеСимволов.Вставить("&gt;",">");
	соответствиеСимволов.Вставить("&copy;","");
	соответствиеСимволов.Вставить("&reg;","");
	соответствиеСимволов.Вставить("&trade;","");
	соответствиеСимволов.Вставить("&euro;","");
	соответствиеСимволов.Вставить("&pound;","");
	соответствиеСимволов.Вставить("&bdquo;","");
	соответствиеСимволов.Вставить("&ldquo;","");
	соответствиеСимволов.Вставить("&laquo;","");
	соответствиеСимволов.Вставить("&raquo;","");
	соответствиеСимволов.Вставить("&gt;","");
	соответствиеСимволов.Вставить("&lt;","");
	соответствиеСимволов.Вставить("&ge;","");
	соответствиеСимволов.Вставить("&le;","");
	соответствиеСимволов.Вставить("&asymp;","");
	соответствиеСимволов.Вставить("&ne;","");
	соответствиеСимволов.Вставить("&equiv;","");
	соответствиеСимволов.Вставить("&sect;","");
	соответствиеСимволов.Вставить("&amp;","");
	соответствиеСимволов.Вставить("&infin;","");
	
	соответствиеСимволов.Вставить("&","%26");
	
	Для Каждого текущееСоответствие Из соответствиеСимволов Цикл
		итоговаяСтрока = СтрЗаменить(итоговаяСтрока, текущееСоответствие.Ключ, текущееСоответствие.Значение);
	КонецЦикла;
     
    Возврат итоговаяСтрока; 
     
КонецФункции	// ЗаменитьНеЧитаемыеСимволыИзСтроки()

#КонецОбласти

uriПространстваИмен = "http://www.ant-logistics.com.ua/";
БазовыйАдрес = "www.ant-logistics.com.ua";
ANT_LOGIN = "freshfood.trans@gmail.com";
ANT_PASSWORD = "Liza2010";
ANT_DEBUG = Ложь;