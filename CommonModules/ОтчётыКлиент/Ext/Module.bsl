﻿
#Область НастройкиОтчётов

// Показывает вопрос о необходимости удаления настроек отчётов.
//
// Параметры:
//  мНастройкиОтчёта  - Массив - Набор значений типа СправочникСсылка.НастройкиОтчётов, которые должны
//                 быть удалены.
//  СписокНастроек  - ДинамическийСписок - Элемент формы, отображающий список настроек отчёта.
//
Процедура ПоказатьВопросОбУдаленииНастроекОтчётов(мНастройкиОтчёта, СписокНастроек) Экспорт

	стДополнительныеПараметры = Новый Структура;
	стДополнительныеПараметры.Вставить("НастройкиОтчёта", мНастройкиОтчёта);
	стДополнительныеПараметры.Вставить("СписокНастроек", СписокНастроек);
	ОписаниеОповещения = Новый ОписаниеОповещения("ОбработатьВопросОбУдаленииНастроекОтчётов", ОтчётыКлиент.ЭтотОбъект, стДополнительныеПараметры);
	ПоказатьВопрос(ОписаниеОповещения, НСтр("ru = 'Удалить выбранные настройки отчётов?'"), РежимДиалогаВопрос.ДаНет,, КодВозвратаДиалога.Нет);

КонецПроцедуры // ПоказатьВопросОбУдаленииНастроекОтчётов()

// Процедура обратного вызова для обработки вопрос о необходимости удаления настроек отчётов.
//
// Параметры:
//  РезультатВопроса  - КодВозвратаДиалога - Результат выбора пользователя.
//  мНастройкиОтчёта  - Массив - Набор удаляемых настроек отчётов.
//
Процедура ОбработатьВопросОбУдаленииНастроекОтчётов(РезультатВопроса, ДополнительныеПараметры) Экспорт

	Если РезультатВопроса = КодВозвратаДиалога.Да Тогда
	
		ОтчётыСервер.УдалитьНастройкиОтчёта(ДополнительныеПараметры.НастройкиОтчёта);
		ДополнительныеПараметры.СписокНастроек.Обновить();
	
	КонецЕсли; 

КонецПроцедуры // ОбработатьВопросОбУдаленииНастроекОтчётов()

// На сервере рассчитывает сумму, среднее и прочие показатели по числовым ячейкам табличного документа
//   и показывает результаты расчетов.
//
// Параметры:
//   Форма - УправляемаяФорма, Неопределено - Форма-владелец, из которой осуществляется открытие формы.
//   ТабличныйДокумент - ТабличныйДокумент - Таблица, для которой выполняются расчеты.
//   ВыделенныеОбласти - Неопределено, Массив - Необязательный. Области документа, которые требуется рассчитать.
//       - Неопределено - Значение по умолчанию. Расчет будет произведен по областям, выделенным интерактивно.
//       - Массив - Массив областей, для которых требуется расчет.
//            Состав аналогичен возвращаемому значению функции СтандартныеПодсистемыКлиент.ВыделенныеОбласти().
//
// См. также:
//   СтандартныеПодсистемыКлиентСервер.РасчетЯчеек().
//
Процедура ПоказатьРасчетЯчеек(форма, табличныйДокумент, выделенныеОбласти = Неопределено) Экспорт
	
	Если выделенныеОбласти = Неопределено Тогда
		выделенныеОбласти = ВыделенныеОбласти(табличныйДокумент);
	КонецЕсли;
	
	параметрыФормы = Новый Структура;
	параметрыФормы.Вставить("ТабличныйДокумент", табличныйДокумент);
	параметрыФормы.Вставить("ВыделенныеОбласти", выделенныеОбласти);
	
	режимОкна = РежимОткрытияОкнаФормы.БлокироватьОкноВладельца;
	
	ОткрытьФорму("ОбщаяФорма.ПоказателиВыделенныхЯчеек", параметрыФормы, форма, Истина, , , , режимОкна);
	
КонецПроцедуры

// Формирует описание выделенных областей табличного документа, которое можно передавать на сервер.
//   Служит заменой типа ВыделенныеОбластиТабличногоДокумента
//   когда нужно вычислить сумму ячеек на сервере без контекста.
//
// Параметры:
//   ТабличныйДокумент - ТабличныйДокумент - Таблица, для которой нужно сформировать описание выделенных ячеек.
//
// Возвращаемое значение: 
//   Массив из Структура - описание.
//       * Верх  - Число - Номер строки верхней границы области.
//       * Низ   - Число - Номер строки нижней границы области.
//       * Лево  - Число - Номер колонки верхней границы области.
//       * Право - Число - Номер колонки нижней границы области.
//       * ТипОбласти - ТипОбластиЯчеекТабличногоДокумента - Колонки, Прямоугольник, Строки, Таблица.
//
// См. также:
//   СтандартныеПодсистемыВызовСервера.РасчетЯчеек().
//
Функция ВыделенныеОбласти(табличныйДокумент)
	
	результат = Новый Массив;
	
	Для Каждого ВыделеннаяОбласть Из ТабличныйДокумент.ВыделенныеОбласти Цикл
		
		Если ТипЗнч(ВыделеннаяОбласть) <> Тип("ОбластьЯчеекТабличногоДокумента") Тогда
			Продолжить;
		КонецЕсли;
		
		структура = Новый Структура("Верх, Низ, Лево, Право, ТипОбласти");
		
		ЗаполнитьЗначенияСвойств(структура, выделеннаяОбласть);
		
		результат.Добавить(структура);
		
	КонецЦикла;
	
	Возврат результат;
	
КонецФункции

#КонецОбласти

#Область ДополнительныеПроцедурыИФункции

// После изменения настроек отчёта выводит в поле табличного документа сообщение о необходимости заново
// сформировать отчёт. Процедура используется для отчётов, созданных без использования СКД и в которых
// поле табличного документа не реагирует автоматически на изменение значений настроек отчёта.
//
// Параметры
//  ПолеТабличногоДокумента  - ПолеФормы - Поле табличного документа, расположенное на форме отчёта.
//
Процедура ИзменитьОтображениеСостоянияПоляТабличногоДокумента(ПолеТабличногоДокумента) Экспорт

	ОтображениеСостояния = ПолеТабличногоДокумента.ОтображениеСостояния;
	ОтображениеСостояния.Видимость = Истина;
	ОтображениеСостояния.ДополнительныйРежимОтображения = ДополнительныйРежимОтображения.Неактуальность;
	ОтображениеСостояния.Текст = НСтр("ru = 'Отчёт не сформирован. Нажмите ""Сформировать"" для получения отчёта.'");

КонецПроцедуры // ИзменитьОтображениеСостоянияПоляТабличногоДокумента()

#КонецОбласти
