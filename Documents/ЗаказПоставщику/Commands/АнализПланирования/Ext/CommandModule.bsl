﻿
#Область изменения_20190319_Карпачев_А_Ю
&НаСервере
Функция ПолучитьЗначениеРеквизитаСсылкиНаСервере(ссылка, имяРеквизита)
	Возврат ссылка[имяРеквизита];
КонецФункции
#КонецОбласти

&НаКлиенте
Процедура ОбработкаКоманды(ПараметрКоманды, ПараметрыВыполненияКоманды)
	
	Если ПараметрКоманды.Количество() > 0 Тогда
		
		заказПоставщикуСсылка = ПараметрКоманды.Получить(0);
		
		Если КонецДня(ПолучитьЗначениеРеквизитаСсылкиНаСервере(заказПоставщикуСсылка, "ПериодПланированияДатаОкончания")) > КонецДня(ТекущаяДата()) Тогда
			ВызватьИсключение НСтр("ru = 'Окончание периода планирования еще не наступило.'");
		КонецЕсли;
		
	КонецЕсли;
	
	УправлениеПечатьюКлиент.ВыполнитьКомандуПечати("Документ.ЗаказПоставщику", "АнализПланирования", ПараметрКоманды, ПараметрыВыполненияКоманды, Неопределено);
	
КонецПроцедуры
