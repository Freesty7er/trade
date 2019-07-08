﻿#Область ОбработчикиСобытий

Процедура ОбработкаПроведения(отказ, режимПроведения)
	
	Движения.ДенежныеДокументыНаХранении.Записывать = Истина;
	Движения.ДенежныеДокументыВыданные.Записывать = Истина;
	Движения.ПартииТоваровНаСкладах.Записывать = Истина;
	
	запрос = Новый Запрос;
	
	#Область ТекстЗапроса
		
	запрос.Текст =
	"ВЫБРАТЬ
	|	ВозвратИзПодотчетаСостав.Ссылка.Подразделение,
	|	ВозвратИзПодотчетаСостав.Номенклатура,
	|	ВозвратИзПодотчетаСостав.Количество,
	|	ВозвратИзПодотчетаСостав.Количество * ЕСТЬNULL(ЦеныНоменклатуры.Цена, 0) КАК Сумма,
	|	ВозвратИзПодотчетаСостав.Ссылка.Сотрудник,
	|	ВозвратИзПодотчетаСостав.НомерСтроки,
	|	ВозвратИзПодотчетаСостав.Ссылка.Дата КАК Период,
	|	ВозвратИзПодотчетаСостав.Номенклатура.Родитель.Склад КАК Склад,
	|	ВозвратИзПодотчетаСостав.Номенклатура.СчетУчета КАК СчетУчета,
	|	ВалютаУчета.Значение КАК Валюта,
	|	ВозвратИзПодотчетаСостав.Номенклатура.СчетУчета КАК КорСчет
	|ПОМЕСТИТЬ ВТ_СоставДокумента
	|ИЗ
	|	Документ.ВозвратИзПодотчета.Состав КАК ВозвратИзПодотчетаСостав
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ЦеныНоменклатуры.СрезПоследних(&ДатаСреза, ) КАК ЦеныНоменклатуры
	|		ПО ВозвратИзПодотчетаСостав.Номенклатура = ЦеныНоменклатуры.Номенклатура
	|			И ВозвратИзПодотчетаСостав.Ссылка.Подразделение = ЦеныНоменклатуры.Подразделение
	|			И (ЦеныНоменклатуры.ТипЦен = ЗНАЧЕНИЕ(Справочник.ТипыЦен.Закупка)),
	|	Константа.ВалютаУчета КАК ВалютаУчета
	|ГДЕ
	|	ВозвратИзПодотчетаСостав.Ссылка = &Ссылка
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ЗНАЧЕНИЕ(ВидДвиженияНакопления.Приход) КАК ВидДвижения,
	|	ВТ_СоставДокумента.Период,
	|	ВТ_СоставДокумента.Подразделение,
	|	ВТ_СоставДокумента.Номенклатура,
	|	ВТ_СоставДокумента.Количество,
	|	ВТ_СоставДокумента.Сумма,
	|	ВТ_СоставДокумента.Сотрудник,
	|	ВТ_СоставДокумента.НомерСтроки
	|ИЗ
	|	ВТ_СоставДокумента КАК ВТ_СоставДокумента
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ЗНАЧЕНИЕ(ВидДвиженияНакопления.Расход) КАК ВидДвижения,
	|	ВТ_СоставДокумента.Подразделение,
	|	ВТ_СоставДокумента.Номенклатура,
	|	ВТ_СоставДокумента.Количество,
	|	ВТ_СоставДокумента.Сумма,
	|	ВТ_СоставДокумента.Сотрудник,
	|	ВТ_СоставДокумента.НомерСтроки,
	|	ВТ_СоставДокумента.Период
	|ИЗ
	|	ВТ_СоставДокумента КАК ВТ_СоставДокумента
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ЗНАЧЕНИЕ(ВидДвиженияНакопления.Приход) КАК ВидДвижения,
	|	ВТ_СоставДокумента.Период,
	|	ВТ_СоставДокумента.Подразделение,
	|	ВТ_СоставДокумента.Склад,
	|	ВТ_СоставДокумента.Номенклатура,
	|	ВТ_СоставДокумента.СчетУчета,
	|	ВТ_СоставДокумента.Валюта,
	|	ВТ_СоставДокумента.Количество,
	|	ВТ_СоставДокумента.Сумма КАК Стоимость,
	|	ВТ_СоставДокумента.Сумма КАК СтоимостьВал,
	|	ЗНАЧЕНИЕ(Перечисление.ВидыХраненияЗапасов.НаСкладе) КАК ВидХранения,
	|	ЗНАЧЕНИЕ(Справочник.Сотрудники.ПустаяСсылка) КАК МОЛ,
	|	ВТ_СоставДокумента.КорСчет
	|ИЗ
	|	ВТ_СоставДокумента КАК ВТ_СоставДокумента
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ
	|	ЗНАЧЕНИЕ(ВидДвиженияНакопления.Расход),
	|	ВТ_СоставДокумента.Период,
	|	ВТ_СоставДокумента.Подразделение,
	|	ВТ_СоставДокумента.Склад,
	|	ВТ_СоставДокумента.Номенклатура,
	|	ВТ_СоставДокумента.СчетУчета,
	|	ВТ_СоставДокумента.Валюта,
	|	ВТ_СоставДокумента.Количество,
	|	ВТ_СоставДокумента.Сумма,
	|	ВТ_СоставДокумента.Сумма,
	|	ЗНАЧЕНИЕ(Перечисление.ВидыХраненияЗапасов.ВПодотчете),
	|	ВТ_СоставДокумента.Сотрудник,
	|	ВТ_СоставДокумента.КорСчет
	|ИЗ
	|	ВТ_СоставДокумента КАК ВТ_СоставДокумента";
	
	#КонецОбласти 
	
	запрос.УстановитьПараметр("Ссылка", Ссылка);
	запрос.УстановитьПараметр("ДатаСреза", Дата);
	
	результатЗапроса = запрос.ВыполнитьПакет();
	
	Движения.ДенежныеДокументыНаХранении.Загрузить(результатЗапроса[1].Выгрузить());
	Движения.ДенежныеДокументыВыданные.Загрузить(результатЗапроса[2].Выгрузить());
	Движения.ПартииТоваровНаСкладах.Загрузить(результатЗапроса[3].Выгрузить());
	
	#Область ПоследовательностьЗапасы
	
	Если Не отказ Тогда
		
		запрос = Новый Запрос;
		
		#Область ТекстЗапроса
		
		запрос.Текст =
		"ВЫБРАТЬ
		|	СоставДокумента.Ссылка.Подразделение,
		|	СоставДокумента.Номенклатура.Родитель.Склад КАК МестоХранения,
		|	СоставДокумента.Номенклатура.Родитель.СчетУчета КАК СчетУчета
		|ИЗ
		|	Документ.ВозвратИзПодотчета.Состав КАК СоставДокумента
		|ГДЕ
		|	СоставДокумента.Ссылка = &Ссылка
		|
		|СГРУППИРОВАТЬ ПО
		|	СоставДокумента.Номенклатура.Родитель.СчетУчета,
		|	СоставДокумента.Ссылка.Подразделение,
		|	СоставДокумента.Номенклатура.Родитель.Склад";
			
		#КонецОбласти 
		
		запрос.УстановитьПараметр("Ссылка", Ссылка);
		
		результатЗапроса = запрос.Выполнить();
		
		ПринадлежностьПоследовательностям.Запасы.Загрузить(результатЗапроса.Выгрузить());
		
		отбор = Новый Структура ("Подразделение, МестоХранения, СчетУчета");
		
		выборка = результатЗапроса.Выбрать();
		Пока выборка.Следующий() Цикл
			
			ЗаполнитьЗначенияСвойств(отбор, выборка);
			
			Последовательности.Запасы.УстановитьГраницу(МоментВремени(), отбор);
			
		КонецЦикла;
		
	КонецЕсли;
	
	#КонецОбласти 
	
КонецПроцедуры

Процедура ПередЗаписью(отказ, режимЗаписи, режимПроведения)
	
	ПринадлежностьПоследовательностям.Запасы.Очистить();
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	Если Подразделение.Пустая() Тогда
		
		ТекстСообщения = НСтр("ru = 'Запись невозможна без заполнения Подразделения.'");
		ПроверкаДанныхКлиентСервер.СообщитьОбОшибке(отказ, текстСообщения, ЭтотОбъект, "Подразделение");
		
	КонецЕсли;
	
КонецПроцедуры

Процедура ПриКопировании(объектКопирования)
	
	ЗаполнениеОбъектовСервер.ЗаполнитьДанныеСкопированногоДокумента(ЭтотОбъект, ОбъектКопирования);
	
КонецПроцедуры

#КонецОбласти 