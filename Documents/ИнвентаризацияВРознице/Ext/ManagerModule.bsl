﻿Функция СоздатьДокументНаОснованииДанныхПОС(ДанныеЗаполнения, ОписаниеОшибки = "") Экспорт
	
	ВыполненоУспешно = Истина;
	
	
	
	Возврат ВыполненоУспешно;
	
КонецФункции
	

#Область ФункцииПечатиФормы
Функция ПечатнаяФорма(МассивОбъектов, ОбъектыПечати, ИмяМакета, КоллекцияПечатныхФорм)
	
	ТабличныйДокумент = Новый ТабличныйДокумент;
	ТабличныйДокумент.КлючПараметровПечати = "ПараметрыПечати_Инвентаризация";
	
	ПервыйДокумент = Истина;
	
	Для Каждого ТекущийДокумент Из МассивОбъектов Цикл
		
		Если Не ПервыйДокумент Тогда
			ТабличныйДокумент.ВывестиГоризонтальныйРазделительСтраниц();
		КонецЕсли;
		ПервыйДокумент = Ложь;
		
		НомерСтрокиНачало = ТабличныйДокумент.ВысотаТаблицы + 1;
		
		Если ИмяМакета = "Акт" Тогда
			
			Запрос = Новый Запрос();
			Запрос.УстановитьПараметр("ТекущийДокумент", ТекущийДокумент);
			Запрос.Текст = 
			"ВЫБРАТЬ
			|	Инвентаризация.Номер,
			|	Инвентаризация.Дата,
			|	Инвентаризация.Состав.(
			|		НомерСтроки КАК НомерСтроки,
			|		Номенклатура,
			|		Номенклатура.Код,
			|		Цена,
			|		Количество,
			|		КоличествоФакт,
			|		КоличествоИзлишек,
			|		КоличествоНедостача,
			|		СуммаИзлишек,
			|		СуммаНедостача
			|	),
			|	Инвентаризация.СтруктурнаяЕдиница КАК Склад
			|ИЗ
			|	Документ.Инвентаризация КАК Инвентаризация
			|ГДЕ
			|	Инвентаризация.Ссылка = &ТекущийДокумент
			|
			|УПОРЯДОЧИТЬ ПО
			|	НомерСтроки";
			
			Шапка = Запрос.Выполнить().Выбрать();
			Шапка.Следующий();
			
		
			ВыборкаСтрокДокумента = Шапка.Состав.Выбрать();
			
			ТабличныйДокумент.ИмяПараметровПечати = "ПАРАМЕТРЫ_ПЕЧАТИ_Инвентаризация_Акт";
			
			
			Макет = УправлениеПечатью.ПолучитьМакет("Документ.Инвентаризация.Акт");
			
			
			КодЯзыкаПечать = Локализация.ПолучитьЯзыкФормированияПечатныхФорм();	
			Макет.КодЯзыкаМакета = КодЯзыкаПечать;
			
			ОбластьМакета = Макет.ПолучитьОбласть("Шапка");
			
			ЗаполнитьЗначенияСвойств(ОбластьМакета.Параметры, Шапка);
			
			ТабличныйДокумент.Вывести(ОбластьМакета);
			
			ИтКоличество			= 0;	
			ИтКоличествоФакт		= 0;
			ИтКоличествоНедостача	= 0;	
			ИтСуммаНедостача		= 0;
			ИтКоличествоИзлишек		= 0;
			ИтСуммаИзлишек			= 0;
			
			ОбластьМакета = Макет.ПолучитьОбласть("Строка");

			Пока ВыборкаСтрокДокумента.Следующий() Цикл
				
				ОбластьМакета.Параметры.Заполнить(ВыборкаСтрокДокумента);
				ОбластьМакета.Параметры.НоменклатураКод = Прав(ВыборкаСтрокДокумента.НоменклатураКод, 5);
				
				ТабличныйДокумент.Вывести(ОбластьМакета);
				
				ИтКоличество			= ИтКоличество + ВыборкаСтрокДокумента.Количество;
				ИтКоличествоФакт		= ИтКоличествоФакт + ВыборкаСтрокДокумента.КоличествоФакт;
				ИтКоличествоНедостача	= ИтКоличествоНедостача + ВыборкаСтрокДокумента.КоличествоНедостача;	
				ИтСуммаНедостача		= ИтСуммаНедостача + ВыборкаСтрокДокумента.СуммаНедостача;
				ИтКоличествоИзлишек		= ИтКоличествоИзлишек + ВыборкаСтрокДокумента.КоличествоИзлишек;
				ИтСуммаИзлишек			= ИтСуммаИзлишек + ВыборкаСтрокДокумента.СуммаИзлишек;
				
			КонецЦикла;
			
			ОбластьМакета = Макет.ПолучитьОбласть("Итого");

			ОбластьМакета.Параметры.Количество			= ИтКоличество;
			ОбластьМакета.Параметры.КоличествоФакт		= ИтКоличествоФакт;
			ОбластьМакета.Параметры.КоличествоНедостача	= ИтКоличествоНедостача;	
			ОбластьМакета.Параметры.СуммаНедостача		= ИтСуммаНедостача;
			ОбластьМакета.Параметры.КоличествоИзлишек	= ИтКоличествоИзлишек;
			ОбластьМакета.Параметры.СуммаИзлишек		= ИтСуммаИзлишек;
			
				
			ТабличныйДокумент.Вывести(ОбластьМакета);
				
				
			ТабличныйДокумент.ОриентацияСтраницы=ОриентацияСтраницы.Портрет;
			
			
		КонецЕсли;
		
		УправлениеПечатью.ЗадатьОбластьПечатиДокумента(ТабличныйДокумент, НомерСтрокиНачало, ОбъектыПечати, ТекущийДокумент);
		
	КонецЦикла;
	
	ТабличныйДокумент.АвтоМасштаб = Истина;
	
	Возврат ТабличныйДокумент;
	
КонецФункции // ПечатнаяФорма()

// Сформировать печатные формы объектов
//
// ВХОДЯЩИЕ:
//   ИменаМакетов    - Строка    - Имена макетов, перечисленные через запятую
//   МассивОбъектов  - Массив    - Массив ссылок на объекты которые нужно распечатать
//   ПараметрыПечати - Структура - Структура дополнительных параметров печати
//
// ИСХОДЯЩИЕ:
//   КоллекцияПечатныхФорм - Таблица значений - Сформированные табличные документы
//   ПараметрыВывода       - Структура        - Параметры сформированных табличных документов
//
Процедура Печать(МассивОбъектов,
				 ПараметрыПечати,
				 КоллекцияПечатныхФорм,
				 ОбъектыПечати,
				 ПараметрыВывода) Экспорт
	
	ПараметрыВывода.ДоступнаПечатьПоКомплектно = Истина;
	
	Если УправлениеПечатью.НужноПечататьМакет(КоллекцияПечатныхФорм, "Акт") Тогда
		УправлениеПечатью.ВывестиТабличныйДокументВКоллекцию(КоллекцияПечатныхФорм, "Акт", "Акт", ПечатнаяФорма(МассивОбъектов, ОбъектыПечати, "Акт", КоллекцияПечатныхФорм));
	КонецЕсли;
	
	
КонецПроцедуры
#КонецОбласти

Функция СформироватьТаблицыДляПроведения(ссылка) Экспорт
	
	запрос = Новый Запрос;
	//запрос.МенеджерВременныхТаблиц = Новый МенеджерВременныхТаблиц;
	
	#Область ТекстЗапроса
	
	запрос.Текст = 
	"ВЫБРАТЬ
	|	ИнвентаризацияВРозницеОпись.Ссылка,
	|	ИнвентаризацияВРозницеОпись.Ссылка.Дата,
	|	ИнвентаризацияВРозницеОпись.Ссылка.Подразделение,
	|	ИнвентаризацияВРозницеОпись.Номенклатура,
	|	ИнвентаризацияВРозницеОпись.Ссылка.ОтделВМагазине КАК ОтделВМагазине,
	|	ИнвентаризацияВРозницеОпись.КоличествоФакт КАК Количество,
	|	ЦеныНоменклатурыПродажи.Цена * ИнвентаризацияВРозницеОпись.КоличествоФакт КАК Сумма,
	|	(ЦеныНоменклатурыПродажи.Цена - ЦеныНоменклатурыЗакупка.Цена) * ИнвентаризацияВРозницеОпись.КоличествоФакт КАК Наценка
	|ПОМЕСТИТЬ ТаблицаТоваров
	|ИЗ
	|	Документ.ИнвентаризацияВРознице.Опись КАК ИнвентаризацияВРозницеОпись
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ЦеныНоменклатуры.СрезПоследних(&МоментВремени, ) КАК ЦеныНоменклатурыПродажи
	|		ПО ИнвентаризацияВРозницеОпись.Ссылка.Подразделение = ЦеныНоменклатурыПродажи.Подразделение
	|			И ИнвентаризацияВРозницеОпись.Номенклатура = ЦеныНоменклатурыПродажи.Номенклатура
	|			И (ЦеныНоменклатурыПродажи.ТипЦен = &ТипЦеныПродажи)
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ЦеныНоменклатуры.СрезПоследних(&МоментВремени, ) КАК ЦеныНоменклатурыЗакупка
	|		ПО ИнвентаризацияВРозницеОпись.Ссылка.Подразделение = ЦеныНоменклатурыЗакупка.Подразделение
	|			И ИнвентаризацияВРозницеОпись.Номенклатура = ЦеныНоменклатурыЗакупка.Номенклатура
	|			И (ЦеныНоменклатурыЗакупка.ТипЦен = &ТипЦеныЗакупки)
	|ГДЕ
	|	ИнвентаризацияВРозницеОпись.Ссылка = &Ссылка
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ВложенныйЗапрос.Период,
	|	ВложенныйЗапрос.ВидДвижения,
	|	ВложенныйЗапрос.Подразделение,
	|	ВложенныйЗапрос.Номенклатура,
	|	ВложенныйЗапрос.ОтделМагазина,
	|	СУММА(ВложенныйЗапрос.Количество) КАК Количество,
	|	ВложенныйЗапрос.Регистратор,
	|	СУММА(ВложенныйЗапрос.Сумма) КАК Сумма,
	|	СУММА(ВложенныйЗапрос.Наценка) КАК Наценка
	|ИЗ
	|	(ВЫБРАТЬ
	|		ТаблицаТоваров.Дата КАК Период,
	|		ЗНАЧЕНИЕ(ВидДвиженияНакопления.Расход) КАК ВидДвижения,
	|		ТаблицаТоваров.Подразделение КАК Подразделение,
	|		ТаблицаТоваров.Номенклатура КАК Номенклатура,
	|		ТаблицаТоваров.ОтделВМагазине КАК ОтделМагазина,
	|		-ТаблицаТоваров.Количество КАК Количество,
	|		ТаблицаТоваров.Ссылка КАК Регистратор,
	|		-ТаблицаТоваров.Сумма КАК Сумма,
	|		-ТаблицаТоваров.Наценка КАК Наценка
	|	ИЗ
	|		ТаблицаТоваров КАК ТаблицаТоваров
	|	
	|	ОБЪЕДИНИТЬ ВСЕ
	|	
	|	ВЫБРАТЬ
	|		&Период,
	|		ЗНАЧЕНИЕ(ВидДвиженияНакопления.Расход),
	|		ТоварыВРозницеОстатки.Подразделение,
	|		ТоварыВРозницеОстатки.Номенклатура,
	|		ТоварыВРозницеОстатки.ОтделМагазина,
	|		ТоварыВРозницеОстатки.КоличествоОстаток,
	|		&Ссылка,
	|		ТоварыВРозницеОстатки.СуммаОстаток,
	|		ТоварыВРозницеОстатки.НаценкаОстаток
	|	ИЗ
	|		РегистрНакопления.ТоварыВРознице.Остатки(
	|				&МоментВремени,
	|				Подразделение = &Подразделение
	|					И ОтделМагазина = &ОтделМагазина) КАК ТоварыВРозницеОстатки) КАК ВложенныйЗапрос
	|
	|СГРУППИРОВАТЬ ПО
	|	ВложенныйЗапрос.Период,
	|	ВложенныйЗапрос.ОтделМагазина,
	|	ВложенныйЗапрос.Регистратор,
	|	ВложенныйЗапрос.ВидДвижения,
	|	ВложенныйЗапрос.Подразделение,
	|	ВложенныйЗапрос.Номенклатура";
	
	#КонецОбласти 
	
	запрос.УстановитьПараметр("Ссылка", 		ссылка);
	запрос.УстановитьПараметр("МоментВремени", Новый Граница(ссылка.МоментВремени(), ВидГраницы.Исключая));
	запрос.УстановитьПараметр("Период", 		ссылка.Дата);
	запрос.УстановитьПараметр("Подразделение", 	ссылка.Подразделение);
	запрос.УстановитьПараметр("ОтделМагазина", 	ссылка.ОтделВМагазине);
	запрос.УстановитьПараметр("ТипЦеныПродажи",	ссылка.ОтделВМагазине.Магазин.ТипЦен);
	запрос.УстановитьПараметр("ТипЦеныЗакупки",	ссылка.Подразделение.ЦенаСклада);
	
	Возврат Запрос.ВыполнитьПакет()
	
Конецфункции	