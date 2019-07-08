﻿
#Область ОбработчикиСобытий

Процедура ОбработкаПроведения(отказ, режимПроведения)
	
	// Инициализация дополнительных свойств для проведения документа.
	ОбщегоНазначенияСервер.ИнициализироватьДополнительныеСвойстваДляПроведения(Ссылка, ДополнительныеСвойства);
	
	// Подготовка наборов записей.
	ОбщегоНазначенияСервер.ПодготовитьНаборыЗаписейКРегистрацииДвижений(ЭтотОбъект);
	
	результатЗапроса = Документы.СводныйПутевойЛист.СформироватьТаблицыДляПроведения(Ссылка);
	
	Движения.ДенежныеДокументыВыданные.Загрузить(результатЗапроса[1].Выгрузить());
	Движения.ВзаиморасчетыССотрудниками.Загрузить(результатЗапроса[2].Выгрузить());
	Движения.ФинансовыйРезультат.Загрузить(результатЗапроса[3].Выгрузить());
	Движения.РасчетыПоОплатеТруда.Загрузить(результатЗапроса[4].Выгрузить());
	Движения.ПартииТоваровНаСкладах.Загрузить(результатЗапроса[5].Выгрузить());
	Движения.ВзаиморасчетыСПоставщиками.Загрузить(результатЗапроса[6].Выгрузить());
	
	#Область ПоследовательностьЗапасы
	
	Если Не отказ Тогда
		
		запрос = Новый Запрос;
		
		#Область ТекстЗапроса
		
		запрос.Текст =
		"ВЫБРАТЬ
		|	СоставДокумента.Ссылка.Подразделение,
		|	СоставДокумента.ЗаправкаНоменклатура.Родитель.Склад КАК МестоХранения,
		|	СоставДокумента.ЗаправкаНоменклатура.Родитель.СчетУчета КАК СчетУчета
		|ИЗ
		|	Документ.СводныйПутевойЛист.Состав КАК СоставДокумента
		|ГДЕ
		|	СоставДокумента.Ссылка = &Ссылка
		|	И СоставДокумента.ЗаправкаНоменклатура <> ЗНАЧЕНИЕ(Справочник.Номенклатура.ПустаяСсылка)
		|
		|СГРУППИРОВАТЬ ПО
		|	СоставДокумента.ЗаправкаНоменклатура.Родитель.СчетУчета,
		|	СоставДокумента.Ссылка.Подразделение,
		|	СоставДокумента.ЗаправкаНоменклатура.Родитель.Склад";
			
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

Процедура ОбработкаПроверкиЗаполнения(отказ, проверяемыеРеквизиты)
	
	ОбработкаТабличныхЧастейСервер.ПроверитьДублиСтрокТабличнойЧасти(Отказ, ЭтотОбъект, "Состав", Новый Структура("Автомобиль", "Автомобиль"));

КонецПроцедуры

Процедура ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)
	
	ПринадлежностьПоследовательностям.Запасы.Очистить();
	
	Если ОбменДанными.Загрузка Тогда
		// Обмен данными. Проверки не выполняем.
		Возврат;
	КонецЕсли; 
		
	Если РежимЗаписи = РежимЗаписиДокумента.Проведение Тогда
		
		Если (Дата < Дата("20151201")) Тогда
			
			Отказ = Истина;
			
		КонецЕсли;	
		
	КонецЕсли; 
	
КонецПроцедуры

Процедура ПриКопировании(объектКопирования)
	
	ЗаполнениеОбъектовСервер.ЗаполнитьДанныеСкопированногоДокумента(ЭтотОбъект, объектКопирования);
	
КонецПроцедуры

#КонецОбласти
