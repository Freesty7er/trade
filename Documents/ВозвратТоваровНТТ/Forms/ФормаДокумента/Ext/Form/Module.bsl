﻿&НаСервере
Процедура ПокупательПриИзмененииСервер()
	
	объект.Покупатель = Объект.Отдел.Магазин;
	
КонецПроцедуры


&НаКлиенте
Процедура ПокупательПриИзменении(Элемент)
	ПокупательПриИзмененииСервер();
КонецПроцедуры

&НаКлиенте
Процедура РасчетНаценки()
	Объект.Скидка = Объект.СуммаБезСкидки - Объект.СуммаДокумента;
КонецПроцедуры

&НаКлиенте
Процедура СуммаБезСкидкиПриИзменении(Элемент)
	РасчетНаценки();
КонецПроцедуры

&НаКлиенте
Процедура СуммаДокументаПриИзменении(Элемент)
	РасчетНаценки();
КонецПроцедуры
