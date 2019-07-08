﻿
#Область ОбработчикиСобытий

Процедура ОбработкаПроведения(отказ, режимПроведения)
	
	Движения.БПАГКоэффициентыРекомендуемогоЗапаса.Записывать = Истина;
	
	запрос = Новый Запрос;
	
	#Область ТекстЗапроса
	
	запрос.Текст = 
	"ВЫБРАТЬ
	|	БПАГУстановкаКоэффициентовРекомендуемогоЗапасаТорговыеТочки.Ссылка.Дата КАК Период,
	|	БПАГУстановкаКоэффициентовРекомендуемогоЗапасаТорговыеТочки.Контрагент,
	|	БПАГУстановкаКоэффициентовРекомендуемогоЗапасаНоменклатурныеГруппы.НоменклатурнаяГруппа,
	|	БПАГУстановкаКоэффициентовРекомендуемогоЗапасаНоменклатурныеГруппы.Коэффициент,
	|	БПАГУстановкаКоэффициентовРекомендуемогоЗапасаНоменклатурныеГруппы.ПорогПримененияКоэффициента
	|ИЗ
	|	Документ.БПАГУстановкаКоэффициентовРекомендуемогоЗапаса.ТорговыеТочки КАК БПАГУстановкаКоэффициентовРекомендуемогоЗапасаТорговыеТочки
	|		ЛЕВОЕ СОЕДИНЕНИЕ Документ.БПАГУстановкаКоэффициентовРекомендуемогоЗапаса.НоменклатурныеГруппы КАК БПАГУстановкаКоэффициентовРекомендуемогоЗапасаНоменклатурныеГруппы
	|		ПО БПАГУстановкаКоэффициентовРекомендуемогоЗапасаТорговыеТочки.Ссылка = БПАГУстановкаКоэффициентовРекомендуемогоЗапасаНоменклатурныеГруппы.Ссылка
	|ГДЕ
	|	БПАГУстановкаКоэффициентовРекомендуемогоЗапасаТорговыеТочки.Ссылка = &Документ";
	
	#КонецОбласти
	
	запрос.УстановитьПараметр("Документ", Ссылка);

	Движения.БПАГКоэффициентыРекомендуемогоЗапаса.Загрузить(Запрос.Выполнить().Выгрузить());
	
КонецПроцедуры

Процедура ПередЗаписью(отказ, режимЗаписи, режимПроведения)
	
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

Процедура ОбработкаПроверкиЗаполнения(отказ, проверяемыеРеквизиты)
	
	проверяемыеРеквизиты.Добавить("ТорговыеТочки.Контрагент");
	
	проверяемыеРеквизиты.Добавить("НоменклатурныеГруппы.НоменклатурнаяГруппа");
	проверяемыеРеквизиты.Добавить("НоменклатурныеГруппы.Коэффициент");
	проверяемыеРеквизиты.Добавить("НоменклатурныеГруппы.ПорогПримененияКоэффициента");
	
КонецПроцедуры

#КонецОбласти