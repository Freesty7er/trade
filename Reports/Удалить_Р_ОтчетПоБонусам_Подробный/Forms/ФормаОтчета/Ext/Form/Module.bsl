﻿
&НаКлиенте
Процедура Сформировать(Команда)
	
		Если НЕ ЗначениеЗаполнено(Отчет.КонПериода) Тогда
		Предупреждение("Не задан конец периода", 5);
		Возврат;
	ИначеЕсли Отчет.НачПериода > КонецДня(Отчет.КонПериода) Тогда
		Предупреждение("Начало периода больше конеца периода", 5);
		Возврат;
	КонецЕсли;

	СформироватьОтчет();

КонецПроцедуры

&НаСервере 
Процедура СформироватьОтчет()
	
	ПолеТабличногоДокумента.Очистить();
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("НачПериода", Отчет.НачПериода);
	Запрос.УстановитьПараметр("КонПериода", КонецДня(Отчет.КонПериода));
	Запрос.УстановитьПараметр("ДисконтнаяКарта", Отчет.ДисконтнаяКарта);
	Запрос.УстановитьПараметр("Номенклатура", Отчет.Номенклатура);
	Запрос.Текст = ПолучитьТекстЗапроса();
	
	Макет = Отчеты.Р_ОтчетПоБонусам_Подробный.ПолучитьМакет("Макет");
	
	ОбластьШапка = Макет.ПолучитьОбласть("Шапка");
	ОбластьШапка.Параметры.НачПериода = Отчет.НачПериода;
	ОбластьШапка.Параметры.КонПериода = КонецДня(Отчет.КонПериода);
	
	ПолеТабличногоДокумента.Вывести(ОбластьШапка);
	
	Если ГруппироватьПоКлиенты = 1 Тогда
		Область1 = Макет.ПолучитьОбласть("СтрокаКарты1");
		Область2 = Макет.ПолучитьОбласть("СтрокаТовары1");
	Иначе
		Область2 = Макет.ПолучитьОбласть("СтрокаКарты2");
		Область1 = Макет.ПолучитьОбласть("СтрокаТовары2");
	КонецЕсли;
	
	ПолеТабличногоДокумента.НачатьАвтогруппировкуСтрок();
	
	Выборка1 = Запрос.Выполнить().Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
	Пока Выборка1.Следующий() Цикл
		
		ЗаполнитьЗначенияСвойств(Область1.Параметры, Выборка1);
		
		Если ГруппироватьПоКлиенты = 1 Тогда
			Область1.Параметры.ПроцентЗачисления = Р_ОбщегоНазначения_ПОС.ПолучитьПроцентНачисленияБонусов(Выборка1.Карта, КонецДня(Отчет.КонПериода));
		//ИначеЕсли ЭлементыФормы.ВыборКодАртикул.Значение = "Код" Тогда
			//Область1.Параметры.Номенклатура = "(" + СокрЛП(Выборка1.КодТовара) + ") " + Выборка1.Номенклатура;
		//ИначеЕсли  ЭлементыФормы.ВыборКодАртикул.Значение = "Артикул" Тогда
		//	Область1.Параметры.Номенклатура = "(" + СокрЛП(Выборка1.АртикулТовара) + ") " + Выборка1.Номенклатура;
		КонецЕсли;
		
		ПолеТабличногоДокумента.Вывести(Область1, 1, , Ложь);
		
		Выборка2 = Выборка1.Выбрать();
		Пока Выборка2.Следующий() Цикл
			
			ЗаполнитьЗначенияСвойств(Область2.Параметры, Выборка2);
			
			Если ГруппироватьПоКлиенты = 1 Тогда
				//Если ЭлементыФормы.ВыборКодАртикул.Значение = "Код" Тогда
					//Область2.Параметры.Номенклатура = "(" + СокрЛП(Выборка2.КодТовара) + ") " + Выборка2.Номенклатура;
				//ИначеЕсли  ЭлементыФормы.ВыборКодАртикул.Значение = "Артикул" Тогда
				//	Область2.Параметры.Номенклатура = "(" + СокрЛП(Выборка2.АртикулТовара) + ") " + Выборка2.Номенклатура;
				//КонецЕсли
			КонецЕсли;
			
			ПолеТабличногоДокумента.Вывести(Область2, 2, , Ложь);
			
		КонецЦикла;
		
	КонецЦикла;
	
	ПолеТабличногоДокумента.ЗакончитьАвтогруппировкуСтрок();
	
	ПолеТабличногоДокумента.Защита = Истина;
	
	ПолеТабличногоДокумента.ОриентацияСтраницы = ОриентацияСтраницы.Ландшафт;
	
	ПолеТабличногоДокумента.ПолеСлева = 5;
	ПолеТабличногоДокумента.ПолеСправа = 5;

КонецПроцедуры

Функция ПолучитьТекстЗапроса()
	
	ТекстЗапроса = 
	"ВЫБРАТЬ
	|	ИнформационныеКарты.Ссылка КАК Карта,
	//|	Р_ПродажиПоБонуснымКартамОбороты.ДисконтнаяКарта КАК Карта,
	|	Р_ПродажиПоБонуснымКартамОбороты.Номенклатура КАК Номенклатура,
	|	Р_ПродажиПоБонуснымКартамОбороты.Номенклатура.Код КАК КодТовара,
	|	Р_ПродажиПоБонуснымКартамОбороты.Номенклатура.Артикул КАК АртикулТовара,
	|	СУММА(ЕСТЬNULL(Р_ПродажиПоБонуснымКартамОбороты.КоличествоОборот, 0)) КАК КоличествоПродажи,
	|	СУММА(ЕСТЬNULL(Р_ПродажиПоБонуснымКартамОбороты.СуммаПродажиОборот, 0)) КАК СуммаПродажи,
	|	СРЕДНЕЕ(ЕСТЬNULL(Р_ПродажиПоБонуснымКартамОбороты.Регистратор.ПроцентБонусаПоЧеку, 0)) КАК ПроцентЗачисления,
	|	СУММА(ЕСТЬNULL(Р_ПродажиПоБонуснымКартамОбороты.СуммаБонусовОборот, 0)) КАК СуммаБонусовОборот,
	|	СУММА(ЕСТЬNULL(Р_ПродажиПоБонуснымКартамОбороты.СуммаБонусовЗачисленоОборот, 0)) КАК СуммаБонусовЗачислено,
	|	СУММА(ЕСТЬNULL(Р_ПродажиПоБонуснымКартамОбороты.СуммаБонусовСписаноОборот, 0)) КАК СуммаБонусовСписано,
	|	СУММА(ЕСТЬNULL(Р_ПродажиПоБонуснымКартамОстатки.СуммаБонусовОборот, 0)) КАК СуммаБонусовОстаток
	|ИЗ
	|	Справочник.ИнформационныеКарты КАК ИнформационныеКарты
	|	ЛЕВОЕ СОЕДИНЕНИЕ РегистрНакопления.Р_ПродажиПоБонуснымКартам.Обороты(, &КонПериода, Регистратор,
	|		//ТекстУсловия
	|	) КАК Р_ПродажиПоБонуснымКартамОстатки
	|	ПО ИнформационныеКарты.Ссылка = Р_ПродажиПоБонуснымКартамОстатки.ДисконтнаяКарта
	|	ЛЕВОЕ СОЕДИНЕНИЕ РегистрНакопления.Р_ПродажиПоБонуснымКартам.Обороты(&НачПериода, &КонПериода, Регистратор,
	|		//ТекстУсловия
	|	) КАК Р_ПродажиПоБонуснымКартамОбороты
	|	ПО ИнформационныеКарты.Ссылка = Р_ПродажиПоБонуснымКартамОбороты.ДисконтнаяКарта
	|	 И Р_ПродажиПоБонуснымКартамОстатки.ДисконтнаяКарта = Р_ПродажиПоБонуснымКартамОбороты.ДисконтнаяКарта
	|	 И Р_ПродажиПоБонуснымКартамОстатки.Номенклатура = Р_ПродажиПоБонуснымКартамОбороты.Номенклатура
	|	 И Р_ПродажиПоБонуснымКартамОстатки.Регистратор = Р_ПродажиПоБонуснымКартамОбороты.Регистратор
	|ГДЕ
	|	ИнформационныеКарты.Р_ВыгружатьНаПОС
	|	И ИнформационныеКарты.ТипКарты = ЗНАЧЕНИЕ(Перечисление.ТипыИнформационныхКарт.Р_Бонусная)
	|	//ЗначениеУсловия
	|СГРУППИРОВАТЬ ПО
	|	ИнформационныеКарты.Ссылка,
	//|	Р_ПродажиПоБонуснымКартамОбороты.ДисконтнаяКарта,
	|	Р_ПродажиПоБонуснымКартамОбороты.Номенклатура
	|ИТОГИ
	|	СУММА(КоличествоПродажи),
	|	СУММА(СуммаПродажи),
	|	СУММА(СуммаБонусовОборот),
	|	СУММА(СуммаБонусовЗачислено),
	|	СУММА(СуммаБонусовСписано),
	|	СУММА(СуммаБонусовОстаток)
	|ПО
	|	//ТекстИтоги";
	
	Если ГруппироватьПоКлиенты = 1 Тогда 
		ТекстЗапроса = СтрЗаменить(ТекстЗапроса, "//ТекстИтоги", "Карта");
	Иначе
		ТекстЗапроса = СтрЗаменить(ТекстЗапроса, "//ТекстИтоги", "Номенклатура");
	КонецЕсли;
	
	Если Не ЗначениеЗаполнено(Отчет.ДисконтнаяКарта) И ЗначениеЗаполнено(Отчет.Номенклатура) Тогда
		ТекстЗапроса = СтрЗаменить(ТекстЗапроса, "//ТекстУсловия", "Номенклатура = &Номенклатура");
	ИначеЕсли ЗначениеЗаполнено(Отчет.ДисконтнаяКарта) И Не ЗначениеЗаполнено(Отчет.Номенклатура) Тогда
		ТекстЗапроса = СтрЗаменить(ТекстЗапроса, "//ТекстУсловия", "ДисконтнаяКарта = &ДисконтнаяКарта");
		ТекстЗапроса = СтрЗаменить(ТекстЗапроса, "//ЗначениеУсловия", "И ИнформационныеКарты.Ссылка = &ДисконтнаяКарта");
	ИначеЕсли ЗначениеЗаполнено(Отчет.ДисконтнаяКарта) И ЗначениеЗаполнено(Отчет.Номенклатура) Тогда
		ТекстЗапроса = СтрЗаменить(ТекстЗапроса, "//ТекстУсловия", "Номенклатура = &Номенклатура И ДисконтнаяКарта = &ДисконтнаяКарта");
		ТекстЗапроса = СтрЗаменить(ТекстЗапроса, "//ЗначениеУсловия", "И ИнформационныеКарты.Ссылка = &ДисконтнаяКарта");
	Иначе
		ТекстЗапроса = СтрЗаменить(ТекстЗапроса, "//ТекстУсловия", "");
	КонецЕсли;
	
	Возврат ТекстЗапроса;
	
КонецФункции

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	Отчет.НачПериода = НачалоДня(ТекущаяДата());
	Отчет.КонПериода = ТекущаяДата();

КонецПроцедуры
