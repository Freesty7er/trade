﻿#Область ОбработчикиСобытий

Процедура ОбработкаПроведения(Отказ, РежимПроведения)
	
	ТекстЗапроса = "ВЫБРАТЬ
	               |	ВЫБОР
	               |		КОГДА УправленческийОстатки.Счет = &ТоварыВРознице
	               |			ТОГДА УправленческийОстатки.СуммаОстаток
	               |		ИНАЧЕ 0
	               |	КОНЕЦ КАК ТоварыВРознице,
	               |	ВЫБОР
	               |		КОГДА УправленческийОстатки.Счет = &НаценкаВРознице
	               |			ТОГДА -УправленческийОстатки.СуммаОстаток
	               |		ИНАЧЕ 0
	               |	КОНЕЦ КАК НаценкаВРознице
	               |ИЗ
	               |	РегистрБухгалтерии.Управленческий.Остатки(
	               |			&ДатаДокумента,
	               |			Счет = &ТоварыВРознице
	               |				ИЛИ Счет = &НаценкаВРознице,
	               |			,
	               |			Субконто1 = &Магазин
	               |				И Субконто2 = &Отдел) КАК УправленческийОстатки
	               |ИТОГИ
	               |	СУММА(ТоварыВРознице),
	               |	СУММА(НаценкаВРознице)
	               |ПО
	               |	ОБЩИЕ,
	               |	УправленческийОстатки.Субконто1";

	
	Запрос = Новый Запрос(ТекстЗапроса);
	Запрос.УстановитьПараметр("ДатаДокумента", Ссылка.Дата);
	Запрос.УстановитьПараметр("Магазин", Ссылка.Отдел.Магазин);
	Запрос.УстановитьПараметр("Отдел", Ссылка.Отдел);
	Запрос.УстановитьПараметр("ТоварыВРознице", ПланыСчетов.Внутренний.ТоварыВРознице);
	Запрос.УстановитьПараметр("НаценкаВРознице", ПланыСчетов.Внутренний.РозничнаяНаценкаБаза);
	
	Результат = Запрос.Выполнить();
	Если Результат.Пустой() Тогда
		Результат = Новый Структура("ТоварыВРознице, НаценкаВРознице",0,0);
	Иначе
		Результат = Результат.Выбрать();
		Результат.Следующий();
	КонецЕсли;
		
	БазаДляСписанияНаценки 	= 0;
	ПриходВРозницу 			= 0;
	ПриходНаценки 			= 0;
	
	
	Проводки = Движения.Управленческий;
	

	// Взаиморасчеты
	Для Каждого СтрокаДокумента Из Состав Цикл
		
		Если СтрокаДокумента.Оплата = 0 Тогда
			Продолжить;
		КонецЕсли;
		
		НоваяПроводка = Проводки.Добавить();
		НоваяПроводка.Подразделение = Подразделение;
		НоваяПроводка.Период	= Дата;
		НоваяПроводка.СчетДт = ПланыСчетов.Внутренний.ПоставщикиБаза;
		НоваяПроводка.СубконтоДт.Контрагенты = Контрагент;
		НоваяПроводка.СубконтоДт.ДокументПоставки = СтрокаДокумента.ДокументПоставки;
		НоваяПроводка.СубконтоДт.Отделы = Отдел;
		
		НоваяПроводка.СчетКт = ПланыСчетов.Внутренний.ТоварыВРознице;
		НоваяПроводка.СубконтоКт.Магазины = Отдел.Магазин;
		НоваяПроводка.СубконтоКт.Отделы = Отдел;
		НоваяПроводка.Сумма	= СтрокаДокумента.Оплата;
		
		// списать наценку
		БазаДляСписанияНаценки = БазаДляСписанияНаценки + СтрокаДокумента.Оплата;		
		
	КонецЦикла;
	
	// Спишем наценку.....
	Если НЕ(БазаДляСписанияНаценки = 0) Тогда
		// спишем наценку....
		НоваяПроводка = Проводки.Добавить();
		НоваяПроводка.Подразделение = Подразделение;
		НоваяПроводка.Период	= Дата;
		
		НоваяПроводка.СчетДт = ПланыСчетов.Внутренний.РозничнаяНаценкаБаза;
		НоваяПроводка.СубконтоДт.Магазины = Отдел.Магазин;
		НоваяПроводка.СубконтоДт.Отделы = Отдел;
		
		НоваяПроводка.СчетКт = ПланыСчетов.Внутренний.Доходы;
		НоваяПроводка.СубконтоКт.Магазины = Отдел.Магазин;
		НоваяПроводка.СубконтоКт.Отделы = Отдел;
		
		КоэффСписания = (Результат.НаценкаВРознице + ПриходНаценки)  / (Результат.ТоварыВРознице + ПриходВРозницу);
		
		НоваяПроводка.Сумма	= (КоэффСписания) * БазаДляСписанияНаценки;
		
		//ПроцентНаценки = БазаДляСписанияНаценки / (БазаДляСписанияНаценки - НоваяПроводка.Сумма) * 100 - 100;
		ПроцентНаценки = 100 - ((БазаДляСписанияНаценки - НоваяПроводка.Сумма) / БазаДляСписанияНаценки) * 100 ;
		
		НоваяПроводка.Содержание	= "Списание наценки (" + Формат(ПроцентНаценки, "ЧДЦ=4")+ "%)";
		
	КонецЕсли;
	
	Проводки.Записать();
 
	
КонецПроцедуры

Процедура ПриКопировании(объектКопирования)
	
	ЗаполнениеОбъектовСервер.ЗаполнитьДанныеСкопированногоДокумента(ЭтотОбъект, объектКопирования);
	
КонецПроцедуры

#КонецОбласти 