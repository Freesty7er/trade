﻿#Область ОбработчикиСобытий

Процедура ОбработкаПроведения(Отказ, РежимПроведения)
	
	РасчетыПоОплатеТруда = Движения.РасчетыПоОплатеТруда;
	ВзаиморасчетыССотрудниками = Движения.ВзаиморасчетыССотрудниками;
	ФинансовыеРезультаты = Движения.ФинансовыйРезультат;
	
	Для Каждого СтрокаСостава Из Состав Цикл
		
			
		Если СтрокаСостава.ВидРасчета.Тип = 1 Тогда
			// Начисление
			Движение = ФинансовыеРезультаты.Добавить();
			Движение.Период = Дата;
			Движение.Подразделение 	= Подразделение;
			Движение.СтатьяЗатрат 	= КатегорияРаботников.СтатьяЗатратПоЗарплате;
			Движение.СуммаРасходов 	= СтрокаСостава.Результат;
			
			Движение = ВзаиморасчетыССотрудниками.Добавить();
			Движение.ВидДвижения 	= ВидДвиженияНакопления.Расход;
			Движение.Период 		= Дата;
			Движение.Подразделение 	= Подразделение;
			Движение.Сотрудник 		= СтрокаСостава.Сотрудник;
			Движение.Сумма 			= СтрокаСостава.Результат;
			Движение.СчетУчета		= ПланыСчетов.Внутренний.Зарплата;
			
		Иначе
			// Удержание
			Движение = ВзаиморасчетыССотрудниками.Добавить();
			Движение.ВидДвижения 	= ВидДвиженияНакопления.Приход;
			Движение.Период 		= Дата;
			Движение.Подразделение 	= Подразделение;
			Движение.Сотрудник 		= СтрокаСостава.Сотрудник;
			Движение.Сумма 			= СтрокаСостава.Результат;
			Движение.СчетУчета		= ПланыСчетов.Внутренний.Зарплата;
			
			// Уменьшим расходы на оплату труда....
			Движение = ФинансовыеРезультаты.Добавить();
			Движение.Период = Дата;
			Движение.Подразделение 	= Подразделение;
			Движение.СтатьяЗатрат 	= КатегорияРаботников.СтатьяЗатратПоЗарплате;
			Движение.СуммаРасходов 	= -1*СтрокаСостава.Результат;
			


		КонецЕсли;
		
		// 
		Движение = РасчетыПоОплатеТруда.Добавить();
		Движение.Период = Дата;
		Движение.ВидРасчета = СтрокаСостава.ВидРасчета;
		Движение.ПериодРегистрации = ПериодРегистрации;
		Движение.Подразделение = Подразделение;
		Движение.Сотрудник = СтрокаСостава.Сотрудник;
		Движение.Результат = СтрокаСостава.Результат;
		
	КонецЦикла;
	
	РасчетыПоОплатеТруда.Записать();
	ВзаиморасчетыССотрудниками.Записать();
	ФинансовыеРезультаты.Записать();
	
КонецПроцедуры

Процедура ПриКопировании(объектКопирования)
	
	ЗаполнениеОбъектовСервер.ЗаполнитьДанныеСкопированногоДокумента(ЭтотОбъект, ОбъектКопирования);
	
КонецПроцедуры

#КонецОбласти