﻿// Проверяет правильность заполнения шапки документа.
// Если какой-то из реквизтов шапки, влияющий на проведение не заполнен или
// заполнен не корректно, то выставляется флаг отказа в проведении.
// Проверяется также правильность заполнения реквизитов ссылочных полей документа.
// Проверка выполняется по объекту и по выборке из результата запроса по шапке.
//
// Параметры: 
//  ДокументОбъект             - объект проводимого документа, 
//  СтруктураОбязательныхПолей - структура, содержащая имена полей, которые собственно и надо проверить.
//  Отказ                      - флаг отказа в проведении.
//  Заголовок                  - строка, заголовок сообщения об ошибке проведения.
//
Процедура ПроверитьЗаполнениеШапкиДокумента(ДокументОбъект, СтруктураОбязательныхПолей, Отказ, Заголовок) Экспорт
	
	//ПроверитьПринадлежностьКВидамУчета();

	ТипыПланыСчетов     = ПланыСчетов.ТипВсеСсылки();
	МетаданныеРеквизиты = ДокументОбъект.Метаданные().Реквизиты;
	
	Для каждого КлючЗначение Из СтруктураОбязательныхПолей Цикл

		Значение = ДокументОбъект[КлючЗначение.Ключ];
		ПредставлениеРеквизита = МетаданныеРеквизиты[КлючЗначение.Ключ].Представление();

		Если НЕ ЗначениеЗаполнено(Значение) Тогда // надо ругаться

			Если НЕ ЗначениеЗаполнено(КлючЗначение.Значение) Тогда //стандартное ругательство
				СтрокаСообщения = "Не заполнено значение реквизита """ + СокрЛП(ПредставлениеРеквизита) + """!";
			Иначе
				СтрокаСообщения = КлючЗначение.Значение;
			КонецЕсли;
			ОбщегоНазначения.СообщитьОбОшибке(СтрокаСообщения, Отказ, Заголовок);
			
		ИначеЕсли ТипыПланыСчетов.СодержитТип(ТипЗнч(Значение)) тогда

			Если Значение.ЗапретитьИспользоватьВПроводках Тогда
				СтрокаСообщения = Локализация.СтрШаблон("Реквизит ""¤1¤"" : счет ¤2¤ ""¤3¤"" нельзя использовать в проводках.", СокрЛП(ПредставлениеРеквизита), СокрЛП(Значение), Значение.Наименование);
				ОбщегоНазначения.СообщитьОбОшибке(СтрокаСообщения, Отказ, Заголовок);
			КонецЕсли;

		КонецЕсли;

	КонецЦикла;

	Если СтруктураОбязательныхПолей.Свойство("Организация") и СтруктураОбязательныхПолей.Свойство("ДоговорКонтрагента") тогда

		// Если в документе есть организация и договор - провести проверку на соответствие
		//Организация в документе должна совпадать с организацией, указанной в договоре взаиморасчетов.
		Организация = ДокументОбъект.Организация;
		ДоговорКонтрагента = ДокументОбъект.ДоговорКонтрагента;
		Если ТипЗнч(ДоговорКонтрагента) = Тип("СправочникСсылка.ДоговорыКонтрагентов") тогда
			УправлениеВзаиморасчетами.ПроверитьСоответствиеОрганизацииДоговоруВзаиморасчетов(Организация, ДоговорКонтрагента, ДоговорКонтрагента.Организация, Отказ, Заголовок);
		КонецЕсли;

	КонецЕсли;

КонецПроцедуры // ПроверитьЗаполнениеШапкиДокумента()

// Проверяет правильность заполнения строк табличной части документа.
// Если какой-то из реквизтов, влияющий на проведение не заполнен или
// заполнен не корректно, то выставляется флаг отказа в проведении.
//
// Параметры:
//  ДокументОбъект             - объект проводимого документа, 
//  ИмяТабличнойЧасти          - табличная часть документа,
//  СтруктураОбязательныхПолей - структура, содержащая имена полей, которые собственно и надо проверить.
//  Отказ                      - флаг отказа в проведении.
//  Заголовок                  - строка, заголовок сообщения об ошибке проведения.
//
Процедура ПроверитьЗаполнениеТабличнойЧасти(ДокументОбъект, ИмяТабличнойЧасти, СтруктураОбязательныхПолей, 
                                                    Отказ, Заголовок) Экспорт

	ПредставлениеТабличнойЧасти = ДокументОбъект.Метаданные().ТабличныеЧасти[ИмяТабличнойЧасти].Представление();
	ТабличнаяЧасть = ДокументОбъект[ИмяТабличнойЧасти];
	МетаданныеРеквизиты = ДокументОбъект.Метаданные().ТабличныеЧасти[ИмяТабличнойЧасти].Реквизиты;

	// Цмкл по строкам табличной части.
	Для каждого СтрокаТаблицы Из ТабличнаяЧасть Цикл

		СтрокаНачалаСообщенияОбОшибке = "В строке номер """+ СокрЛП(СтрокаТаблицы.НомерСтроки) +
		                               """ табличной части """ + ПредставлениеТабличнойЧасти + """: ";

		// Цмкл по проверяемым полям
		Для каждого КлючЗначение Из СтруктураОбязательныхПолей Цикл

			Значение = СтрокаТаблицы[КлючЗначение.Ключ];
			Если НЕ ЗначениеЗаполнено(Значение) Тогда // надо ругаться

				Если НЕ ЗначениеЗаполнено(КлючЗначение.Значение) Тогда //стандартное ругательство
					ПредставлениеРеквизита = МетаданныеРеквизиты[КлючЗначение.Ключ].Представление();
					СтрокаСообщения = "Не заполнено значение реквизита """ + СокрЛП(ПредставлениеРеквизита) + """!";
				Иначе
					СтрокаСообщения = КлючЗначение.Значение;
				КонецЕсли;
				ОбщегоНазначения.СообщитьОбОшибке(СтрокаНачалаСообщенияОбОшибке + СтрокаСообщения, Отказ, Заголовок);

			КонецЕсли;

		КонецЦикла;

	КонецЦикла;

КонецПроцедуры // ПроверитьЗаполнениеТабличнойЧасти()
