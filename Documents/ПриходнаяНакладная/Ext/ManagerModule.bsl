﻿
////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ И ФУНКЦИИ ПЕЧАТИ ФОРМЫ

Функция ПечатнаяФорма(МассивОбъектов, ОбъектыПечати, ИмяМакета, КоллекцияПечатныхФорм)
	
	ТабличныйДокумент = Новый ТабличныйДокумент;
	ТабличныйДокумент.КлючПараметровПечати = "ПараметрыПечати_АктСписания";
	
	ПервыйДокумент = Истина;
	
	Для Каждого ТекущийДокумент Из МассивОбъектов Цикл
		
		Если Не ПервыйДокумент Тогда
			ТабличныйДокумент.ВывестиГоризонтальныйРазделительСтраниц();
		КонецЕсли;
		ПервыйДокумент = Ложь;
		
		НомерСтрокиНачало = ТабличныйДокумент.ВысотаТаблицы + 1;
		
		Если ИмяМакета = "Накладная" Тогда
			
			Запрос = Новый Запрос(
			"ВЫБРАТЬ
			|	ПриходнаяНакладная.СтруктурнаяЕдиница,
			|	ПриходнаяНакладная.Контрагент.ПолнНаим,
			|	ПриходнаяНакладная.Комментарий,
			|	ПриходнаяНакладная.Скидка,
			|	ПриходнаяНакладная.Запасы.(
			|		НомерСтроки КАК НомерСтроки,
			|		Номенклатура.Код,
			|		Номенклатура.Наименование,
			|		ЕдиницаИзмерения,
			|		Количество,
			|		Цена,
			|		Сумма,
			|		Маркетинг,
			|		ПриходнаяНакладная.Запасы.Цена + ПриходнаяНакладная.Запасы.Маркетинг КАК ЦенаПолная
			|	),
			|	ПриходнаяНакладная.Номер,
			|	ПриходнаяНакладная.Дата,
			|	ПриходнаяНакладная.Подразделение,
			|	ПриходнаяНакладная.Имущество.(
			|		НомерСтроки,
			|		Номенклатура.Код,
			|		Количество,
			|		Цена,
			|		Сумма,
			|		Номенклатура.Наименование,
			|		Номенклатура.ЕдиницаИзмерения КАК ЕдиницаИзмерения
			|	)
			|ИЗ
			|	Документ.ПриходнаяНакладная КАК ПриходнаяНакладная
			|ГДЕ
			|	ПриходнаяНакладная.Ссылка = &ТекущийДокумент
			|
			|УПОРЯДОЧИТЬ ПО
			|	НомерСтроки");
			
			Запрос.УстановитьПараметр("ТекущийДокумент", ТекущийДокумент);
			
			Шапка = Запрос.Выполнить().Выбрать();
			Шапка.Следующий();
			
			НомерДокумента = Шапка.Номер;
			
			ВыборкаСтрокДокументаЗапасы = Шапка.Запасы.Выбрать();
			ВыборкаСтрокДокументаИмущество = Шапка.Имущество.Выбрать();
			
			ТабличныйДокумент.ИмяПараметровПечати = "ПАРАМЕТРЫ_ПЕЧАТИ_ПриходнаяНакладная_Накладная";
			
			
			Макет = УправлениеПечатью.ПолучитьМакет("Документ.ПриходнаяНакладная.Накладная");
			
			
			КодЯзыкаПечать = Локализация.ПолучитьЯзыкФормированияПечатныхФорм();	
			Макет.КодЯзыкаМакета = КодЯзыкаПечать;
			
			ОбластьМакета = Макет.ПолучитьОбласть("Шапка");
			
			ЗаполнитьЗначенияСвойств(ОбластьМакета.Параметры, Шапка);
			ОбластьМакета.Параметры.Дата = Формат(Шапка.Дата, "ДЛФ=DD");
			
			ТабличныйДокумент.Вывести(ОбластьМакета);
			
			ИтСумма			= 0;
			ИтКоличество	= 0;
			ИтКоличествоНакладная	= 0;
			ИтСуммаНакладная = 0;
			
			ОбластьМакета = Макет.ПолучитьОбласть("Строка");

			Пока ВыборкаСтрокДокументаЗапасы.Следующий() Цикл
				
				//СуммаНакладная = Окр(ВыборкаСтрокДокумента.КоличествоНакладная * ВыборкаСтрокДокумента.Цена, 2, РежимОкругления.Окр15как20);
				//СуммаНакладная = Окр(СуммаНакладная - СуммаНакладная*Шапка.Скидка/100, 2, РежимОкругления.Окр15как20);
				
				ОбластьМакета.Параметры.Заполнить(ВыборкаСтрокДокументаЗапасы);
				//ОбластьМакета.Параметры.НоменклатураКод = Прав(ВыборкаСтрокДокумента.НоменклатураКод, 5);
				
				//ОбластьМакета.Параметры.СуммаНакладная = СуммаНакладная;
				
				ТабличныйДокумент.Вывести(ОбластьМакета);
				
				ИтКоличество	= ИтКоличество + ВыборкаСтрокДокументаЗапасы.Количество;
				//ИтКоличествоНакладная	= ИтКоличествоНакладная + ВыборкаСтрокДокумента.КоличествоНакладная;
				ИтСумма			= ИтСумма + ВыборкаСтрокДокументаЗапасы.Сумма;
				//ИтСуммаНакладная = ИтСуммаНакладная + СуммаНакладная;
				
			КонецЦикла;
			Пока ВыборкаСтрокДокументаИмущество.Следующий() Цикл
				ОбластьМакета.Параметры.Заполнить(ВыборкаСтрокДокументаИмущество);
				ТабличныйДокумент.Вывести(ОбластьМакета);
				ИтКоличество	= ИтКоличество + ВыборкаСтрокДокументаИмущество.Количество;
				ИтСумма			= ИтСумма + ВыборкаСтрокДокументаИмущество.Сумма;
			КонецЦикла;
			
			
			
			ОбластьМакета = Макет.ПолучитьОбласть("Итого");

			
			
			ОбластьМакета.Параметры.Сумма 		= ИтСумма;
			ОбластьМакета.Параметры.Количество	= ИтКоличество;
			//ОбластьМакета.Параметры.КоличествоНакладная	= ИтКоличествоНакладная;
			//ОбластьМакета.Параметры.СуммаНакладная	= ИтСуммаНакладная;
				
			ТабличныйДокумент.Вывести(ОбластьМакета);
			
			ОбластьМакета = Макет.ПолучитьОбласть("Подвал");
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
	
	Если УправлениеПечатью.НужноПечататьМакет(КоллекцияПечатныхФорм, "Накладная") Тогда
		УправлениеПечатью.ВывестиТабличныйДокументВКоллекцию(КоллекцияПечатныхФорм, "Накладная", "Приемный акт", ПечатнаяФорма(МассивОбъектов, ОбъектыПечати, "Накладная", КоллекцияПечатныхФорм));
	КонецЕсли;
	
	
КонецПроцедуры


