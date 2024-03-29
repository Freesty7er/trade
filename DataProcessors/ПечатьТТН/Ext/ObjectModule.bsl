﻿// Функция возвращает табличный документ для печати ТТН
Функция ПечатнаяФорма(МассивОбъектов, ОбъектыПечати, ПараметрыПечати) Экспорт
	
	ТабличныйДокумент = Новый ТабличныйДокумент;
	
	ПервыйДокумент = Истина;
	
	Для каждого ТекущийДокумент Из МассивОбъектов Цикл
		
		Если НЕ ПервыйДокумент Тогда
			ТабличныйДокумент.ВывестиГоризонтальныйРазделительСтраниц();
		КонецЕсли;
		ПервыйДокумент = Ложь;
		
		НомерСтрокиНачало = ТабличныйДокумент.ВысотаТаблицы + 1;
		
		ТабличныйДокумент.ИмяПараметровПечати = "ПАРАМЕТРЫ_ПЕЧАТИ_ПечатьТТН_ТТН";
		
		Запрос = Новый Запрос;
		Запрос.УстановитьПараметр("Документ",  ТекущийДокумент);
		
		Если ТипЗнч(ТекущийДокумент) = Тип("ДокументСсылка.РасходнаяНакладная") Тогда
			
			Запрос.Текст =
			"ВЫБРАТЬ
			|	РасходнаяНакладная.Номер КАК Номер,
			|	РасходнаяНакладная.Ссылка КАК ТекущийДокумент,
			|	РасходнаяНакладная.Дата КАК ДатаДокумента,
			|	РасходнаяНакладная.Организация,
			|	РасходнаяНакладная.Организация.Префикс КАК Префикс,
			|	РасходнаяНакладная.Организация КАК ЮрФизЛицо,
			|	РасходнаяНакладная.Организация КАК Поставщик,
			|	РасходнаяНакладная.Организация КАК Контрагент,
			|	РасходнаяНакладная.Организация КАК Руководители,
			|	РасходнаяНакладная.Организация КАК Грузоотправитель,
			|	РасходнаяНакладная.Контрагент КАК Грузополучатель,
			|	РасходнаяНакладная.Организация.БанковскийСчетПоУмолчанию КАК БанковскийСчет,
			|	РасходнаяНакладная.Контрагент КАК Покупатель,
			|	РасходнаяНакладная.Контрагент КАК Плательщик,
			|	0 КАК ВалютаДокумента,
			|	1 КАК Курс,
			|	1 КАК Кратность,
			|	ЛОЖЬ КАК НДСВключатьВСтоимость,
			|	ИСТИНА КАК СуммаВключаетНДС,
			|	РасходнаяНакладная.Запасы.(
			|		НомерСтроки КАК Номер,
			|		Номенклатура,
			|		ВЫБОР
			|			КОГДА (ВЫРАЗИТЬ(РасходнаяНакладная.Запасы.Номенклатура.ПолнНаим КАК СТРОКА(1000))) = """"
			|				ТОГДА РасходнаяНакладная.Запасы.Номенклатура.Наименование
			|			ИНАЧЕ ВЫРАЗИТЬ(РасходнаяНакладная.Запасы.Номенклатура.ПолнНаим КАК СТРОКА(1000))
			|		КОНЕЦ КАК ЗапасНаименование,
			|		Номенклатура.Код КАК КодПродукции,
			|		Количество КАК Количество,
			|		0 КАК КоличествоМест,
			|		Номенклатура.ЕдиницаИзмерения КАК БазоваяЕдиницаНаименование,
			|		ЕдиницаИзмерения КАК ЕдиницаИзмеренияДокумент,
			|		ЕдиницаИзмерения КАК ВидУпаковки,
			|		Номенклатура.ЕдиницаИзмерения.Код КАК БазоваяЕдиницаКодПоОКЕИ,
			|		1 КАК Коэффициент,
			|		Цена КАК Цена,
			|		Сумма КАК Сумма,
			|		РасходнаяНакладная.Запасы.Сумма / 6 КАК СуммаНДС,
			|		Сумма КАК Всего,
			|		Сумма КАК СуммаВВалютеДокумента,
			|		РасходнаяНакладная.Запасы.Сумма / 6 КАК СуммаНДСВВалютеДокумента,
			|		Всего КАК ВсегоВВалютеДокумента,
			|		0 КАК СтавкаНДС,
			|		Номенклатура.Артикул КАК Артикул,
			|		0 КАК Характеристика,
			|		"""" КАК Содержание,
			|		РасходнаяНакладная.Запасы.Количество * РасходнаяНакладная.Запасы.Номенклатура.Вес КАК Масса
			|	),
			|	РасходнаяНакладная.СуммаДокумента КАК ИтогоСуммаСНДС
			|ИЗ
			|	Документ.РасходнаяНакладная КАК РасходнаяНакладная
			|ГДЕ
			|	РасходнаяНакладная.Ссылка = &Документ";
			
			
		ИначеЕсли ТипЗнч(ТекущийДокумент) = Тип("ДокументСсылка.НалоговаяНакладная") Тогда
			
			Запрос.Текст =
			"ВЫБРАТЬ
			|	ПОДСТРОКА(НалоговаяНакладная.Номер, 10, 8) КАК Номер,
			|	НалоговаяНакладная.Ссылка КАК ТекущийДокумент,
			|	НалоговаяНакладная.Дата КАК ДатаДокумента,
			|	НалоговаяНакладная.Организация,
			|	НалоговаяНакладная.Организация.Префикс КАК Префикс,
			|	НалоговаяНакладная.Организация КАК ЮрФизЛицо,
			|	НалоговаяНакладная.Организация КАК Поставщик,
			|	НалоговаяНакладная.Организация КАК Контрагент,
			|	НалоговаяНакладная.Организация КАК Руководители,
			|	НалоговаяНакладная.Организация КАК Грузоотправитель,
			|	НалоговаяНакладная.Контрагент КАК Грузополучатель,
			|	НалоговаяНакладная.Организация.БанковскийСчетПоУмолчанию КАК БанковскийСчет,
			|	НалоговаяНакладная.Контрагент КАК Покупатель,
			|	НалоговаяНакладная.Контрагент КАК Плательщик,
			|	0 КАК ВалютаДокумента,
			|	1 КАК Курс,
			|	1 КАК Кратность,
			|	ЛОЖЬ КАК НДСВключатьВСтоимость,
			|	ИСТИНА КАК СуммаВключаетНДС,
			|	НалоговаяНакладная.Запасы.(
			|		НомерСтроки КАК Номер,
			|		Номенклатура,
			|		ВЫБОР
			|			КОГДА (ВЫРАЗИТЬ(НалоговаяНакладная.Запасы.Номенклатура.ПолнНаим КАК СТРОКА(1000))) = """"
			|				ТОГДА НалоговаяНакладная.Запасы.Номенклатура.Наименование
			|			ИНАЧЕ ВЫРАЗИТЬ(НалоговаяНакладная.Запасы.Номенклатура.ПолнНаим КАК СТРОКА(1000))
			|		КОНЕЦ КАК ЗапасНаименование,
			|		Номенклатура.Код КАК КодПродукции,
			|		Количество КАК Количество,
			|		0 КАК КоличествоМест,
			|		Номенклатура.ЕдиницаИзмерения КАК БазоваяЕдиницаНаименование,
			|		ЕдиницаИзмерения КАК ЕдиницаИзмеренияДокумент,
			|		ЕдиницаИзмерения КАК ВидУпаковки,
			|		Номенклатура.ЕдиницаИзмерения.Код КАК БазоваяЕдиницаКодПоОКЕИ,
			|		1 КАК Коэффициент,
			|		Цена КАК Цена,
			|		Сумма КАК Сумма,
			|		НалоговаяНакладная.Запасы.Сумма / 6 КАК СуммаНДС,
			|		Сумма КАК Всего,
			|		Сумма КАК СуммаВВалютеДокумента,
			|		НалоговаяНакладная.Запасы.Сумма / 6 КАК СуммаНДСВВалютеДокумента,
			|		Всего КАК ВсегоВВалютеДокумента,
			|		0 КАК СтавкаНДС,
			|		Номенклатура.Артикул КАК Артикул,
			|		0 КАК Характеристика,
			|		"""" КАК Содержание,
			|		НалоговаяНакладная.Запасы.Количество * НалоговаяНакладная.Запасы.Номенклатура.Вес КАК Масса
			|	),
			|	НалоговаяНакладная.СуммаДокумента КАК ИтогоСуммаСНДС
			|ИЗ
			|	Документ.НалоговаяНакладная КАК НалоговаяНакладная
			|ГДЕ
			|	НалоговаяНакладная.Ссылка = &Документ";
			
			
		КонецЕсли; 
		
		УстановитьПривилегированныйРежим(Истина);

		кладовщикСтруктура = РегистрыСведений.ОтветственныеЛица.ПолучитьПоследнее(ТекущийДокумент.Дата, Новый Структура("Организация, ТипОтветственногоЛица", ТекущийДокумент.Организация, Перечисления.ТипыОтветственныхЛиц.Кладовщик));
		руководительСтруктура = РегистрыСведений.ОтветственныеЛица.ПолучитьПоследнее(ТекущийДокумент.Дата, Новый Структура("Организация, ТипОтветственногоЛица", ТекущийДокумент.Организация, Перечисления.ТипыОтветственныхЛиц.Руководитель));
		
		УстановитьПривилегированныйРежим(Ложь);
		
		Шапка = Запрос.Выполнить().Выбрать();
		
		Шапка.Следующий();
		
		Макет = УправлениеПечатью.ПолучитьМакет("Обработка.ПечатьТТН.ПФ_MXL_ТТН");
		
		КодЯзыкаПечать = "uk"; 
		
		// Выводим общие реквизиты шапки
		СведенияОПоставщике       = УправлениеНебольшойФирмойСервер.СведенияОЮрФизЛице(КодЯзыкаПечать,Шапка.ЮрФизЛицо,        Шапка.ДатаДокумента , , Шапка.БанковскийСчет);
		СведенияОГрузоотправителе = УправлениеНебольшойФирмойСервер.СведенияОЮрФизЛице(КодЯзыкаПечать,Шапка.Грузоотправитель, Шапка.ДатаДокумента , , ?(Шапка.Грузоотправитель = Шапка.ЮрФизЛицо, Шапка.БанковскийСчет, Неопределено));
		СведенияОПокупателе       = УправлениеНебольшойФирмойСервер.СведенияОЮрФизЛице(КодЯзыкаПечать,Шапка.Покупатель,       Шапка.ДатаДокумента);
		СведенияОГрузополучателе  = УправлениеНебольшойФирмойСервер.СведенияОЮрФизЛице(КодЯзыкаПечать,Шапка.Грузополучатель,  Шапка.ДатаДокумента);
		
		НомерДокумента = Прав("        "+Шапка.Номер, 8);
		
		//Если Шапка.ДатаДокумента < Дата('20110101') Тогда
		//	НомерДокумента = УправлениеНебольшойФирмойСервер.ПолучитьНомерНаПечать(Шапка.Номер, Шапка.Префикс);
		//Иначе
		//	НомерДокумента = ПрефиксацияОбъектовКлиентСервер.ПолучитьНомерНаПечать(Шапка.Номер, Истина, Истина);
		//КонецЕсли;		
		
		ОбластьМакета = Макет.ПолучитьОбласть("Шапка");
		ОбластьМакета.Параметры.НомерДокумента                = НомерДокумента;
		ОбластьМакета.Параметры.ДатаДокумента                 = Шапка.ДатаДокумента;
		ОбластьМакета.Параметры.Грузоотправитель              = Шапка.Грузоотправитель;
		ОбластьМакета.Параметры.Грузополучатель               = Шапка.Грузополучатель;
		ОбластьМакета.Параметры.Плательщик                    = Шапка.Покупатель;
		
		//ОбластьМакета.Параметры.ПлательщикПредставление		  = ПараметрыПечати.Заказчик;
		//ОбластьМакета.Параметры.ПлательщикПредставление       	= УправлениеНебольшойФирмойСервер.ОписаниеОрганизации(СведенияОГрузоотправителе, "ПолноеНаименование,ИНН,ФактическийАдрес,Телефоны,НомерСчета,Банк,МФО,КоррСчет");
		//ОбластьМакета.Параметры.ГрузоотправительПредставление	= УправлениеНебольшойФирмойСервер.ОписаниеОрганизации(СведенияОГрузоотправителе, "ПолноеНаименование,ИНН,ФактическийАдрес,Телефоны,НомерСчета,Банк,МФО,КоррСчет");
		//ОбластьМакета.Параметры.ОрганизацияПеревозчик			= Шапка.Грузоотправитель.ПолнНаименование;
		ОбластьМакета.Параметры.ОрганизацияПеревозчик			= ПараметрыПечати.Перевозчик.ПолнНаим;
		ОбластьМакета.Параметры.ПлательщикПредставление       	= Шапка.Грузоотправитель.ПолнНаименование + ", " + Шапка.Грузоотправитель.ЮрАдрес;
		ОбластьМакета.Параметры.ГрузоотправительПредставление	= Шапка.Грузоотправитель.ПолнНаименование + ", " + Шапка.Грузоотправитель.ЮрАдрес;
		
		//ОбластьМакета.Параметры.ГрузополучательПредставление  	= УправлениеНебольшойФирмойСервер.ОписаниеОрганизации(СведенияОГрузополучателе,  "ПолноеНаименование,ИНН,ФактическийАдрес,Телефоны,НомерСчета,Банк,МФО,КоррСчет");
		ОбластьМакета.Параметры.ГрузополучательПредставление  	= Шапка.Грузополучатель.ПолнНаим + ", " + Шапка.Грузополучатель.ЮрАдрес;
		
		ОбластьМакета.Параметры.МаркаИГосНомерАвтомобиля	  	= ПараметрыПечати.МаркаАвтомобиля + " " + ПараметрыПечати.ГосНомерАвтомобиля;
		ОбластьМакета.Параметры.МаркаИГосНомерПрицепа		  	= ПараметрыПечати.МаркаПрицепа + " " + ПараметрыПечати.ГосНомерПрицепа;
		
		ОбластьМакета.Параметры.ФИОВодителя				= ПараметрыПечати.Водитель + " " + ПараметрыПечати.ВодительскоеУдостоверение;
		ОбластьМакета.Параметры.ФИОВодителяДолжность	= ПараметрыПечати.Водитель + ", водiй";
		
		УстановитьПривилегированныйРежим(Истина);
		ОбластьМакета.Параметры.ОтпускРазрешилДолжность	= "" + ОбщегоНазначения.ФамилияИнициалыФизЛица(руководительСтруктура.Сотрудник.ФизЛицо) + ", " + НРег(СокрЛП(руководительСтруктура.Должность));
		УстановитьПривилегированныйРежим(Ложь);
		
		ОбластьМакета.Параметры.Бухгалтер				= "";
		
		ОбластьМакета.Параметры.ВидПеревозки			= ПараметрыПечати.ВидПеревозки;
		//ОбластьМакета.Параметры.ОрганизацияПеревозчик	= ПараметрыПечати.Перевозчик;
		ОбластьМакета.Параметры.ПунктПогрузки			= ПараметрыПечати.ПунктПогрузки;
		ОбластьМакета.Параметры.ПунктРазгрузки			= ПараметрыПечати.ПунктРазгрузки;
		
		Масса = Окр(Шапка.Запасы.Выгрузить().Итог("Масса")/1000, "3", РежимОкругления.Окр15как20);
		МассаТонны = ЧислоПрописью(Цел(Масса), "Л=uk");
		МассаТонны = Лев(МассаТонны, Найти(МассаТонны, "0") - 1);
		МассаКилограммы = СокрЛП((Масса - Цел(Масса))*1000);
		
		ОбластьМакета.Параметры.КоличествоМестПрописью 		= ЧислоПрописью(ПараметрыПечати.КоличествоМест, "Л=uk;", ",,,,,,,,0");
		ОбластьМакета.Параметры.МассаБрутто 				= МассаТонны + "т. " + МассаКилограммы + " кг.";
		ОбластьМакета.Параметры.ОтпущеноНаСуммуПрописью 	= ОбщегоНазначенияСервер.СформироватьСуммуПрописью(Шапка.ИтогоСуммаСНДС);
		ОбластьМакета.Параметры.СуммаНДС 					= Формат(Шапка.ИтогоСуммаСНДС / 6, "ЧДЦ=2") + " грн";
		ОбластьМакета.Параметры.СопроводительныеДокументы 	= "Накл. № " + НомерДокумента + " вiд " + Формат(Шапка.ДатаДокумента,"ДФ=dd.MM.yyyy");
		
		ТабличныйДокумент.Вывести(ОбластьМакета);
		
		СтрокНаСтранице = 23;
		СтрокШапки      = 10;
		СтрокПодвала    = 9;
		НомерСтраницы   = 1;
		
		// Выводим заголовок таблицы
		ЗаголовокТаблицы = Макет.ПолучитьОбласть("ЗаголовокТаблицы");
		
		ТабличныйДокумент.ВывестиГоризонтальныйРазделительСтраниц();
		ТабличныйДокумент.Вывести(ЗаголовокТаблицы);
		
		// инициализация итогов по странице
		ИтогоКоличествоНаСтранице = 0;
		ИтогоСуммаНаСтранице      = 0;
		ИтогоНДСНаСтранице        = 0;
		ИтогоСуммаСНДСНаСтранице  = 0;
		
		// инициализация итогов по документу
		ИтогоМест		= 0;
		ИтогоКоличество = 0;
		ИтогоСуммаСНДС	= 0;
		ИтогоСумма		= 0;
		ИтогоНДС		= 0;
		Ном				= 0;
		
		// Выводим многострочную часть документа
		//ОбластьМакета = Макет.ПолучитьОбласть("Строка");
		ОбластьМакета = Макет.ПолучитьОбласть("СтрокаСводно");
		
		
		Если ТипЗнч(ТекущийДокумент) = Тип("ДокументСсылка.РасходнаяНакладная") И 1=2 Тогда
			
		Иначе
			
			ИтогоСуммаСНДС	= Шапка.ИтогоСуммаСНДС;
			
			ОбластьМакета.Параметры.СогласноДокумента 			= "Згiдно накл.№ " + НомерДокумента + " вiд " + Формат(Шапка.ДатаДокумента,"ДФ=dd.MM.yyyy");
			ОбластьМакета.Параметры.БазоваяЕдиницаНаименование 	= "кг";
			ОбластьМакета.Параметры.КоличествоМест				= ПараметрыПечати.КоличествоМест;
			ОбластьМакета.Параметры.Сумма						= ИтогоСуммаСНДС;
			ОбластьМакета.Параметры.СопроводительныеДокументы	= "Накл. № " + НомерДокумента + " вiд " + Формат(Шапка.ДатаДокумента,"ДФ=dd.MM.yyyy");
			ОбластьМакета.Параметры.Масса						= Окр(Шапка.Запасы.Выгрузить().Итог("Масса")/1000, "3", РежимОкругления.Окр15как20);
			
			ТабличныйДокумент.Вывести(ОбластьМакета);
			
		КонецЕсли;
		
		// Выводим итоги по документу в целом
		ОбластьМакета = Макет.ПолучитьОбласть("Всего");
		
		ОбластьМакета.Параметры.ИтогоКоличество = ИтогоКоличество;
		ОбластьМакета.Параметры.ИтогоСуммаСНДС  = ИтогоСуммаСНДС;
		ОбластьМакета.Параметры.Масса 			= Окр(Шапка.Запасы.Выгрузить().Итог("Масса")/1000, "3", РежимОкругления.Окр15как20);
		
		ТабличныйДокумент.Вывести(ОбластьМакета);
		
		// Выводим подвал документа
		ОбластьМакета = Макет.ПолучитьОбласть("Подвал");
		
		УстановитьПривилегированныйРежим(Истина);
		ОбластьМакета.Параметры.ФИОКладовщикДолжность	= ?(ЗначениеЗаполнено(кладовщикСтруктура.Сотрудник), "" + ОбщегоНазначения.ФамилияИнициалыФизЛица(кладовщикСтруктура.Сотрудник.ФизЛицо) + ", " + НРег(СокрЛП(кладовщикСтруктура.Должность)), "" + ОбщегоНазначения.ФамилияИнициалыФизЛица(руководительСтруктура.Сотрудник.ФизЛицо) + ", " + НРег(СокрЛП(руководительСтруктура.Должность)));
		УстановитьПривилегированныйРежим(Ложь);
		
		ОбластьМакета.Параметры.ФИОВодительДолжность	= ПараметрыПечати.Водитель + ", водiй";;
		
		ТабличныйДокумент.Вывести(ОбластьМакета);
		
		ОбластьМакета = Макет.ПолучитьОбласть("ПогрузочныеОперации");
		
		ТабличныйДокумент.Вывести(ОбластьМакета);
		
		// Зададим параметры макета
		ТабличныйДокумент.ПолеСверху 	= 0;
		ТабличныйДокумент.ПолеСлева  	= 0;
		ТабличныйДокумент.ПолеСнизу  	= 0;
		ТабличныйДокумент.ПолеСправа	= 0;
		ТабличныйДокумент.АвтоМасштаб	= Истина;
		
		ТабличныйДокумент.ОриентацияСтраницы = ОриентацияСтраницы.Ландшафт;
		
		УправлениеПечатью.ЗадатьОбластьПечатиДокумента(ТабличныйДокумент, НомерСтрокиНачало, ОбъектыПечати, ТекущийДокумент);
		
	КонецЦикла;
	
	ТабличныйДокумент.АвтоМасштаб = Истина;
	
	Возврат ТабличныйДокумент;
	
КонецФункции // ПечатнаяФорма()

