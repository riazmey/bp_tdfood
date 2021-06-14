Function CreateStruct(Caption, KeyAPI, NameAPI = "Yandex", LatCenter = "45.058262", LonCenter = "38.982607", DirectoryTempFiles) Export
	
	IF NOT ValueIsFilled(Caption) THEN
		Return Undefined;
	ENDIF;

	IF TypeOf(LatCenter) = Type("Число") THEN
		Lat = Format(LatCenter, "ЧЦ=10; ЧДЦ=7; ЧРД=.; ЧРГ=");
	ELSIF TypeOf(LatCenter) = Type("Строка") THEN
		Lat = LatCenter;
	ELSE
		Return Undefined;
	ENDIF;
	
	IF TypeOf(LonCenter) = Type("Число") THEN
		Lon = Format(LonCenter, "ЧЦ=10; ЧДЦ=7; ЧРД=.; ЧРГ=");
	ELSIF TypeOf(LonCenter) = Type("Строка") THEN
		Lon = LonCenter;
	ELSE
		Return Undefined;
	ENDIF;

	IF Upper(NameAPI) = "YANDEX" Then
		IconsIslands = New Map;
		IconsIslands.Insert("blue"      ,"islands#blueIcon");
		IconsIslands.Insert("green"     ,"islands#greenIcon");
		IconsIslands.Insert("orange"    ,"islands#orangeIcon");
		IconsIslands.Insert("grey"      ,"islands#grayIcon");
		IconsIslands.Insert("yellow"    ,"islands#yellowIcon");
		IconsIslands.Insert("brown"     ,"islands#brownIcon");
		IconsIslands.Insert("red"       ,"islands#redIcon");
		IconsIslands.Insert("pink"      ,"islands#pinkIcon");
		IconsIslands.Insert("violet"    ,"islands#violetIcon");
		IconsIslands.Insert("black"     ,"islands#blackIcon");
		IconsIslands.Insert("olive"     ,"islands#oliveIcon");
		IconsIslands.Insert("bluelight" ,"islands#lightBlueIcon");
		IconsIslands.Insert("greendark" ,"islands#darkGreenIcon");
		IconsIslands.Insert("orangedark","islands#darkOrangeIcon");
		IconsIslands.Insert("bluedark"  ,"islands#darkBlueIcon");
		
		IconsIslandsDot = New Map;
		IconsIslandsDot.Insert("blue"      ,"islands#blueDotIcon");
		IconsIslandsDot.Insert("green"     ,"islands#greenDotIcon");
		IconsIslandsDot.Insert("orange"    ,"islands#orangeDotIcon");
		IconsIslandsDot.Insert("grey"      ,"islands#grayDotIcon");
		IconsIslandsDot.Insert("yellow"    ,"islands#yellowDotIcon");
		IconsIslandsDot.Insert("brown"     ,"islands#brownDotIcon");
		IconsIslandsDot.Insert("red"       ,"islands#redDotIcon");
		IconsIslandsDot.Insert("pink"      ,"islands#pinkDotIcon");
		IconsIslandsDot.Insert("violet"    ,"islands#violetDotIcon");
		IconsIslandsDot.Insert("black"     ,"islands#blackDotIcon");
		IconsIslandsDot.Insert("olive"     ,"islands#oliveDotIcon");
		IconsIslandsDot.Insert("bluelight" ,"islands#lightBlueDotIcon");
		IconsIslandsDot.Insert("greendark" ,"islands#darkGreenDotIcon");
		IconsIslandsDot.Insert("orangedark","islands#darkOrangeDotIcon");
		IconsIslandsDot.Insert("bluedark"  ,"islands#darkBlueDotIcon");
		
		IconsIslandsStretchy = New Map;
		IconsIslandsStretchy.Insert("blue"      ,"islands#blueStretchyIcon");
		IconsIslandsStretchy.Insert("green"     ,"islands#greenStretchyIcon");
		IconsIslandsStretchy.Insert("orange"    ,"islands#orangeStretchyIcon");
		IconsIslandsStretchy.Insert("grey"      ,"islands#grayStretchyIcon");
		IconsIslandsStretchy.Insert("yellow"    ,"islands#yellowStretchyIcon");
		IconsIslandsStretchy.Insert("brown"     ,"islands#brownStretchyIcon");
		IconsIslandsStretchy.Insert("red"       ,"islands#redStretchyIcon");
		IconsIslandsStretchy.Insert("pink"      ,"islands#pinkStretchyIcon");
		IconsIslandsStretchy.Insert("violet"    ,"islands#violetStretchyIcon");
		IconsIslandsStretchy.Insert("black"     ,"islands#blackStretchyIcon");
		IconsIslandsStretchy.Insert("olive"     ,"islands#oliveStretchyIcon");	
		IconsIslandsStretchy.Insert("bluelight" ,"islands#lightBlueStretchyIcon");
		IconsIslandsStretchy.Insert("greendark" ,"islands#darkGreenStretchyIcon");
		IconsIslandsStretchy.Insert("orangedark","islands#darkOrangeStretchyIcon");
		IconsIslandsStretchy.Insert("bluedark"  ,"islands#darkBlueStretchyIcon");
		
		IconsIslandsStandart = New Map;
		IconsIslandsStandart.Insert("airplane"           ,"islands#blueAirportIcon");
		IconsIslandsStandart.Insert("auto"               ,"islands#blueAutoIcon");
		IconsIslandsStandart.Insert("barber"             ,"islands#blueBarberIcon");
		IconsIslandsStandart.Insert("bicycle"            ,"islands#blueBicycleIcon");
		IconsIslandsStandart.Insert("book"               ,"islands#blueBookIcon");
		IconsIslandsStandart.Insert("christian"          ,"islands#blueChristianIcon");
		IconsIslandsStandart.Insert("circus"             ,"islands#blueCircusIcon");
		IconsIslandsStandart.Insert("delivery"           ,"islands#blueDeliveryIcon");
		IconsIslandsStandart.Insert("dog"                ,"islands#blueDogIcon");
		IconsIslandsStandart.Insert("entertainmentcenter","islands#blueEntertainmentCenterIcon");
		IconsIslandsStandart.Insert("family"             ,"islands#blueFamilyIcon");
		IconsIslandsStandart.Insert("food"               ,"islands#blueFoodIcon");
		IconsIslandsStandart.Insert("garden"             ,"islands#blueGardenIcon");
		IconsIslandsStandart.Insert("heart"              ,"islands#blueHeartIcon");
		IconsIslandsStandart.Insert("hotel"              ,"islands#blueHotelIcon");
		IconsIslandsStandart.Insert("info"               ,"islands#blueInfoIcon");
		IconsIslandsStandart.Insert("leisure"            ,"islands#blueLeisureIcon");
		IconsIslandsStandart.Insert("medical"            ,"islands#blueMedicalIcon");
		IconsIslandsStandart.Insert("mountain"           ,"islands#blueMountainIcon");
		IconsIslandsStandart.Insert("observation"        ,"islands#blueObservationIcon");
		IconsIslandsStandart.Insert("parking"            ,"islands#blueParkingIcon");
		IconsIslandsStandart.Insert("pocket"             ,"islands#bluePocketIcon");
		IconsIslandsStandart.Insert("post"               ,"islands#bluePostIcon");
		IconsIslandsStandart.Insert("rapidTransit"       ,"islands#blueRapidTransitIcon");
		IconsIslandsStandart.Insert("run"                ,"islands#blueRunIcon");
		IconsIslandsStandart.Insert("shopping"           ,"islands#blueShoppingIcon");
		IconsIslandsStandart.Insert("sport"              ,"islands#blueSportIcon");
		IconsIslandsStandart.Insert("theater"            ,"islands#blueTheaterIcon");
		IconsIslandsStandart.Insert("underpass"          ,"islands#blueUnderpassIcon");
		IconsIslandsStandart.Insert("video"              ,"islands#blueVideoIcon");
		IconsIslandsStandart.Insert("water"              ,"islands#blueWaterParkIcon");
		IconsIslandsStandart.Insert("worship"            ,"islands#blueWorshipIcon");
		IconsIslandsStandart.Insert("attention"          ,"islands#blueAttentionIcon");
		IconsIslandsStandart.Insert("bar"                ,"islands#blueBarIcon");
		IconsIslandsStandart.Insert("beach"              ,"islands#blueBeachIcon");
		IconsIslandsStandart.Insert("bicycle2"           ,"islands#blueBicycle2Icon");
		IconsIslandsStandart.Insert("carWash"            ,"islands#blueCarWashIcon");
		IconsIslandsStandart.Insert("cinema"             ,"islands#blueCinemaIcon");
		IconsIslandsStandart.Insert("court"              ,"islands#blueCourtIcon");
		IconsIslandsStandart.Insert("discount"           ,"islands#blueDiscountIcon");
		IconsIslandsStandart.Insert("education"          ,"islands#blueEducationIcon");
		IconsIslandsStandart.Insert("factory"            ,"islands#blueFactoryIcon");
		IconsIslandsStandart.Insert("fashion"            ,"islands#blueFashionIcon");
		IconsIslandsStandart.Insert("fuelstation"        ,"islands#blueFuelStationIcon");
		IconsIslandsStandart.Insert("government"         ,"islands#blueGovernmentIcon");
		IconsIslandsStandart.Insert("home"               ,"islands#blueHomeIcon");
		IconsIslandsStandart.Insert("hydro"              ,"islands#blueHydroIcon");
		IconsIslandsStandart.Insert("laundry"            ,"islands#blueLaundryIcon");
		IconsIslandsStandart.Insert("masstransit"        ,"islands#blueMassTransitIcon");
		IconsIslandsStandart.Insert("money"              ,"islands#blueMoneyIcon");
		IconsIslandsStandart.Insert("nightclub"          ,"islands#blueNightClubIcon");
		IconsIslandsStandart.Insert("park"               ,"islands#blueParkIcon");
		IconsIslandsStandart.Insert("person"             ,"islands#bluePersonIcon");
		IconsIslandsStandart.Insert("pool"               ,"islands#bluePoolIcon");
		IconsIslandsStandart.Insert("railway"            ,"islands#blueRailwayIcon");
		IconsIslandsStandart.Insert("repairshop"         ,"islands#blueRepairShopIcon");
		IconsIslandsStandart.Insert("science"            ,"islands#blueScienceIcon");
		IconsIslandsStandart.Insert("souvenirs"          ,"islands#blueSouvenirsIcon");
		IconsIslandsStandart.Insert("star"               ,"islands#blueStarIcon");
		IconsIslandsStandart.Insert("toilet"             ,"islands#blueToiletIcon");
		IconsIslandsStandart.Insert("vegetation"         ,"islands#blueVegetationIcon");
		IconsIslandsStandart.Insert("waste"              ,"islands#blueWasteIcon");
		IconsIslandsStandart.Insert("waterway"           ,"islands#blueWaterwayIcon");
		IconsIslandsStandart.Insert("zoo"                ,"islands#blueZooIcon");	
		
		IconsIslandsStandartCircle = New Map;
		IconsIslandsStandartCircle.Insert("airplane"           ,"islands#blueAirportCircleIcon");
		IconsIslandsStandartCircle.Insert("auto"               ,"islands#blueAutoCircleIcon");
		IconsIslandsStandartCircle.Insert("barber"             ,"islands#blueBarberCircleIcon");
		IconsIslandsStandartCircle.Insert("bicycle"            ,"islands#blueBicycleCircleIcon");
		IconsIslandsStandartCircle.Insert("book"               ,"islands#blueBookCircleIcon");
		IconsIslandsStandartCircle.Insert("christian"          ,"islands#blueChristianCircleIcon");
		IconsIslandsStandartCircle.Insert("circus"             ,"islands#blueCircusCircleIcon");
		IconsIslandsStandartCircle.Insert("delivery"           ,"islands#blueDeliveryCircleIcon");
		IconsIslandsStandartCircle.Insert("dog"                ,"islands#blueDogCircleIcon");
		IconsIslandsStandartCircle.Insert("entertainmentcenter","islands#blueEntertainmentCenterCircleIcon");
		IconsIslandsStandartCircle.Insert("family"             ,"islands#blueFamilyCircleIcon");
		IconsIslandsStandartCircle.Insert("food"               ,"islands#blueFoodCircleIcon");
		IconsIslandsStandartCircle.Insert("garden"             ,"islands#blueGardenCircleIcon");
		IconsIslandsStandartCircle.Insert("heart"              ,"islands#blueHeartCircleIcon");
		IconsIslandsStandartCircle.Insert("hotel"              ,"islands#blueHotelCircleIcon");
		IconsIslandsStandartCircle.Insert("info"               ,"islands#blueInfoCircleIcon");
		IconsIslandsStandartCircle.Insert("leisure"            ,"islands#blueLeisureCircleIcon");
		IconsIslandsStandartCircle.Insert("medical"            ,"islands#blueMedicalCircleIcon");
		IconsIslandsStandartCircle.Insert("mountain"           ,"islands#blueMountainCircleIcon");
		IconsIslandsStandartCircle.Insert("observation"        ,"islands#blueObservationCircleIcon");
		IconsIslandsStandartCircle.Insert("parking"            ,"islands#blueParkingCircleIcon");
		IconsIslandsStandartCircle.Insert("pocket"             ,"islands#bluePocketCircleIcon");
		IconsIslandsStandartCircle.Insert("post"               ,"islands#bluePostCircleIcon");
		IconsIslandsStandartCircle.Insert("rapidtransit"       ,"islands#blueRapidTransitCircleIcon");
		IconsIslandsStandartCircle.Insert("run"                ,"islands#blueRunCircleIcon");
		IconsIslandsStandartCircle.Insert("shopping"           ,"islands#blueShoppingCircleIcon");
		IconsIslandsStandartCircle.Insert("sport"              ,"islands#blueSportCircleIcon");
		IconsIslandsStandartCircle.Insert("theater"            ,"islands#blueTheaterCircleIcon");
		IconsIslandsStandartCircle.Insert("underpass"          ,"islands#blueUnderpassCircleIcon");
		IconsIslandsStandartCircle.Insert("video"              ,"islands#blueVideoCircleIcon");
		IconsIslandsStandartCircle.Insert("water"              ,"islands#blueWaterParkCircleIcon");
		IconsIslandsStandartCircle.Insert("worship"            ,"islands#blueWorshipCircleIcon");
		IconsIslandsStandartCircle.Insert("attention"          ,"islands#blueAttentionCircleIcon");
		IconsIslandsStandartCircle.Insert("bar"                ,"islands#blueBarCircleIcon");
		IconsIslandsStandartCircle.Insert("beach"              ,"islands#blueBeachCircleIcon");
		IconsIslandsStandartCircle.Insert("bicycle2"           ,"islands#blueBicycle2CircleIcon");
		IconsIslandsStandartCircle.Insert("carWash"            ,"islands#blueCarWashCircleIcon");
		IconsIslandsStandartCircle.Insert("cinema"             ,"islands#blueCinemaCircleIcon");
		IconsIslandsStandartCircle.Insert("court"              ,"islands#blueCourtCircleIcon");
		IconsIslandsStandartCircle.Insert("discount"           ,"islands#blueDiscountCircleIcon");
		IconsIslandsStandartCircle.Insert("education"          ,"islands#blueEducationCircleIcon");
		IconsIslandsStandartCircle.Insert("factory"            ,"islands#blueFactoryCircleIcon");
		IconsIslandsStandartCircle.Insert("fashion"            ,"islands#blueFashionCircleIcon");
		IconsIslandsStandartCircle.Insert("fuelStation"        ,"islands#blueFuelStationCircleIcon");
		IconsIslandsStandartCircle.Insert("government"         ,"islands#blueGovernmentCircleIcon");
		IconsIslandsStandartCircle.Insert("home"               ,"islands#blueHomeCircleIcon");
		IconsIslandsStandartCircle.Insert("hydro"              ,"islands#blueHydroCircleIcon");
		IconsIslandsStandartCircle.Insert("laundry"            ,"islands#blueLaundryCircleIcon");
		IconsIslandsStandartCircle.Insert("massTransit"        ,"islands#blueMassTransitCircleIcon");
		IconsIslandsStandartCircle.Insert("money"              ,"islands#blueMoneyCircleIcon");
		IconsIslandsStandartCircle.Insert("nightClub"          ,"islands#blueNightClubCircleIcon");
		IconsIslandsStandartCircle.Insert("park"               ,"islands#blueParkCircleIcon");
		IconsIslandsStandartCircle.Insert("person"             ,"islands#bluePersonCircleIcon");
		IconsIslandsStandartCircle.Insert("pool"               ,"islands#bluePoolCircleIcon");
		IconsIslandsStandartCircle.Insert("railway"            ,"islands#blueRailwayCircleIcon");
		IconsIslandsStandartCircle.Insert("repairShop"         ,"islands#blueRepairShopCircleIcon");
		IconsIslandsStandartCircle.Insert("science"            ,"islands#blueScienceCircleIcon");
		IconsIslandsStandartCircle.Insert("souvenirs"          ,"islands#blueSouvenirsCircleIcon");
		IconsIslandsStandartCircle.Insert("star"               ,"islands#blueStarCircleIcon");
		IconsIslandsStandartCircle.Insert("toilet"             ,"islands#blueToiletCircleIcon");
		IconsIslandsStandartCircle.Insert("vegetation"         ,"islands#blueVegetationCircleIcon");
		IconsIslandsStandartCircle.Insert("waste"              ,"islands#blueWasteCircleIcon");
		IconsIslandsStandartCircle.Insert("waterway"           ,"islands#blueWaterwayCircleIcon");
		IconsIslandsStandartCircle.Insert("zoo"                ,"islands#blueZooCircleIcon");
		
		IconsIslandsCluster = New Map;
		IconsIslandsCluster.Insert("blue"              ,"islands#blueClusterIcons");
		IconsIslandsCluster.Insert("blueinverted"      ,"islands#invertedBlueClusterIcons");
		IconsIslandsCluster.Insert("green"             ,"islands#greenClusterIcons");
		IconsIslandsCluster.Insert("greeninverted"     ,"islands#invertedGreenClusterIcons");
		IconsIslandsCluster.Insert("orange"            ,"islands#orangeClusterIcons");
		IconsIslandsCluster.Insert("orangeinverted"    ,"islands#invertedOrangeClusterIcons");
		IconsIslandsCluster.Insert("grey"              ,"islands#grayClusterIcons");
		IconsIslandsCluster.Insert("greyinverted"      ,"islands#invertedGrayClusterIcons");
		IconsIslandsCluster.Insert("yellow"            ,"islands#yellowClusterIcons");
		IconsIslandsCluster.Insert("yellowinverted"    ,"islands#invertedYellowClusterIcons");
		IconsIslandsCluster.Insert("brown"             ,"islands#brownClusterIcons");
		IconsIslandsCluster.Insert("browninverted"     ,"islands#invertedBrownClusterIcons");
		IconsIslandsCluster.Insert("red"               ,"islands#redClusterIcons");
		IconsIslandsCluster.Insert("redinverted"       ,"islands#invertedRedClusterIcons");
		IconsIslandsCluster.Insert("pink"              ,"islands#pinkClusterIcons");
		IconsIslandsCluster.Insert("pinkinverted"      ,"islands#invertedPinkClusterIcons");
		IconsIslandsCluster.Insert("violet"            ,"islands#violetClusterIcons");
		IconsIslandsCluster.Insert("violetinverted"    ,"islands#invertedVioletClusterIcons");
		IconsIslandsCluster.Insert("black"             ,"islands#blackClusterIcons");
		IconsIslandsCluster.Insert("blackinverted"     ,"islands#invertedBlackClusterIcons");
		IconsIslandsCluster.Insert("olive"             ,"islands#oliveClusterIcons");
		IconsIslandsCluster.Insert("oliveinverted"     ,"islands#invertedOliveClusterIcons");
		IconsIslandsCluster.Insert("bluelight"         ,"islands#lightBlueClusterIcons");
		IconsIslandsCluster.Insert("bluelightinverted" ,"islands#invertedLightBlueClusterIcons");
		IconsIslandsCluster.Insert("greendark"         ,"islands#darkGreenClusterIcons");
		IconsIslandsCluster.Insert("greendarkinverted" ,"islands#invertedDarkGreenClusterIcons");
		IconsIslandsCluster.Insert("orangedark"        ,"islands#darkOrangeClusterIcons");
		IconsIslandsCluster.Insert("orangedarkinverted","islands#invertedDarkOrangeClusterIcons");
		IconsIslandsCluster.Insert("bluedark"          ,"islands#darkBlueClusterIcons");
		IconsIslandsCluster.Insert("bluedarkinverted"  ,"islands#invertedDarkBlueClusterIcons");
		
		
		
		
		IconsTwirl = New Map;
		IconsTwirl.Insert("blue"      ,"twirl#blueIcon");
		IconsTwirl.Insert("green"     ,"twirl#greenIcon");
		IconsTwirl.Insert("orange"    ,"twirl#orangeIcon");
		IconsTwirl.Insert("grey"      ,"twirl#greyIcon");
		IconsTwirl.Insert("yellow"    ,"twirl#yellowIcon");
		IconsTwirl.Insert("brown"     ,"twirl#brownIcon");
		IconsTwirl.Insert("red"       ,"twirl#redIcon");
		IconsTwirl.Insert("pink"      ,"twirl#pinkIcon");
		IconsTwirl.Insert("violet"    ,"twirl#violetIcon");
		IconsTwirl.Insert("black"     ,"twirl#blackIcon");
		IconsTwirl.Insert("bluelight" ,"twirl#lightblueIcon");
		IconsTwirl.Insert("greendark" ,"twirl#darkgreenIcon");
		IconsTwirl.Insert("orangedark","twirl#darkorangeIcon");
		IconsTwirl.Insert("bluedark"  ,"twirl#darkblueIcon");
		
		IconsTwirlDot = New Map;
		IconsTwirlDot.Insert("blue"      ,"twirl#blueDotIcon");
		IconsTwirlDot.Insert("green"     ,"twirl#greenDotIcon");
		IconsTwirlDot.Insert("orange"    ,"twirl#orangeDotIcon");
		IconsTwirlDot.Insert("grey"      ,"twirl#greyDotIcon");
		IconsTwirlDot.Insert("yellow"    ,"twirl#yellowDotIcon");
		IconsTwirlDot.Insert("brown"     ,"twirl#brownDotIcon");
		IconsTwirlDot.Insert("red"       ,"twirl#redDotIcon");
		IconsTwirlDot.Insert("pink"      ,"twirl#pinkDotIcon");
		IconsTwirlDot.Insert("violet"    ,"twirl#violetDotIcon");
		IconsTwirlDot.Insert("black"     ,"twirl#blackDotIcon");
		IconsTwirlDot.Insert("bluedight" ,"twirl#lightblueDotIcon");
		IconsTwirlDot.Insert("greendark" ,"twirl#darkgreenDotIcon");
		IconsTwirlDot.Insert("orangedark","twirl#darkorangeDotIcon");
		IconsTwirlDot.Insert("bluedark"  ,"twirl#darkblueDotIcon");
		
		IconsTwirlStretchy = New Map;
		IconsTwirlStretchy.Insert("blue"      ,"twirl#blueStretchyIcon");
		IconsTwirlStretchy.Insert("green"     ,"twirl#greenStretchyIcon");
		IconsTwirlStretchy.Insert("orange"    ,"twirl#orangeStretchyIcon");
		IconsTwirlStretchy.Insert("grey"      ,"twirl#greyStretchyIcon");
		IconsTwirlStretchy.Insert("yellow"    ,"twirl#yellowStretchyIcon");
		IconsTwirlStretchy.Insert("brown"     ,"twirl#brownStretchyIcon");
		IconsTwirlStretchy.Insert("red"       ,"twirl#redStretchyIcon");
		IconsTwirlStretchy.Insert("pink"      ,"twirl#pinkStretchyIcon");
		IconsTwirlStretchy.Insert("violet"    ,"twirl#violetStretchyIcon");
		IconsTwirlStretchy.Insert("black"     ,"twirl#blackStretchyIcon");
		IconsTwirlStretchy.Insert("bluelight" ,"twirl#lightblueStretchyIcon");
		IconsTwirlStretchy.Insert("greendark" ,"twirl#darkgreenStretchyIcon");
		IconsTwirlStretchy.Insert("orangedark","twirl#darkorangeStretchyIcon");
		IconsTwirlStretchy.Insert("bluedark"  ,"twirl#darkblueStretchyIcon");
		
		IconsTwirlStandart = New Map;
		IconsTwirlStandart.Insert("airplane"          ,"twirl#airplaneIcon");
		IconsTwirlStandart.Insert("anchor"            ,"twirl#anchorIcon");
		IconsTwirlStandart.Insert("badminton"         ,"twirl#badmintonIcon");
		IconsTwirlStandart.Insert("bank"              ,"twirl#bankIcon");
		IconsTwirlStandart.Insert("bar"               ,"twirl#barIcon");
		IconsTwirlStandart.Insert("barbershop"        ,"twirl#barberShopIcon");
		IconsTwirlStandart.Insert("bicycle"           ,"twirl#bicycleIcon");
		IconsTwirlStandart.Insert("bowling"           ,"twirl#bowlingIcon");
		IconsTwirlStandart.Insert("buildings"         ,"twirl#buildingsIcon");
		IconsTwirlStandart.Insert("bus"               ,"twirl#busIcon");
		IconsTwirlStandart.Insert("cafe"              ,"twirl#cafeIcon");
		IconsTwirlStandart.Insert("Camping"           ,"twirl#campingIcon");
		IconsTwirlStandart.Insert("car"               ,"twirl#carIcon");
		IconsTwirlStandart.Insert("cellular"          ,"twirl#cellularIcon");
		IconsTwirlStandart.Insert("cinema"            ,"twirl#cinemaIcon");
		IconsTwirlStandart.Insert("downhillskiing"    ,"twirl#downhillSkiingIcon");
		IconsTwirlStandart.Insert("dps"               ,"twirl#dpsIcon");
		IconsTwirlStandart.Insert("drycleaner"        ,"twirl#dryCleanerIcon");
		IconsTwirlStandart.Insert("electrictrain"     ,"twirl#electricTrainIcon");
		IconsTwirlStandart.Insert("factory"           ,"twirl#factoryIcon");
		IconsTwirlStandart.Insert("theater"           ,"twirl#theaterIcon");
		IconsTwirlStandart.Insert("fishing"           ,"twirl#fishingIcon");
		IconsTwirlStandart.Insert("gasstation"        ,"twirl#gasStationIcon");
		IconsTwirlStandart.Insert("gym"               ,"twirl#gymIcon");
		IconsTwirlStandart.Insert("hospital"          ,"twirl#hospitalIcon");
		IconsTwirlStandart.Insert("house"             ,"twirl#houseIcon");
		IconsTwirlStandart.Insert("keymaster"         ,"twirl#keyMasterIcon");
		IconsTwirlStandart.Insert("mailpost"          ,"twirl#mailPostIcon");
		IconsTwirlStandart.Insert("metrokiev"         ,"twirl#metroKievIcon");
		IconsTwirlStandart.Insert("metromoscow"       ,"twirl#metroMoscowIcon");
		IconsTwirlStandart.Insert("metrostpetersburg" ,"twirl#metroStPetersburgIcon");
		IconsTwirlStandart.Insert("metroyekaterinburg","twirl#metroYekaterinburgIcon");
		IconsTwirlStandart.Insert("motobike"          ,"twirl#motobikeIcon");
		IconsTwirlStandart.Insert("mushroom"          ,"twirl#mushroomIcon");
		IconsTwirlStandart.Insert("phone"             ,"twirl#phoneIcon");
		IconsTwirlStandart.Insert("photographer"      ,"twirl#photographerIcon");
		IconsTwirlStandart.Insert("pingPong"          ,"twirl#pingPongIcon");
		IconsTwirlStandart.Insert("restauraunt"       ,"twirl#restaurauntIcon");
		IconsTwirlStandart.Insert("ship"              ,"twirl#shipIcon");
		IconsTwirlStandart.Insert("shop"              ,"twirl#shopIcon");
		IconsTwirlStandart.Insert("skating"           ,"twirl#skatingIcon");
		IconsTwirlStandart.Insert("stadium"           ,"twirl#stadiumIcon");
		IconsTwirlStandart.Insert("skiing"            ,"twirl#skiingIcon");
		IconsTwirlStandart.Insert("smartphone"        ,"twirl#smartphoneIcon");
		IconsTwirlStandart.Insert("workshop"          ,"twirl#workshopIcon");
		IconsTwirlStandart.Insert("storehouse"        ,"twirl#storehouseIcon");
		IconsTwirlStandart.Insert("swimming"          ,"twirl#swimmingIcon");
		IconsTwirlStandart.Insert("tailorshop"        ,"twirl#tailorShopIcon");
		IconsTwirlStandart.Insert("tennis"            ,"twirl#tennisIcon");
		IconsTwirlStandart.Insert("tire"              ,"twirl#tireIcon");
		IconsTwirlStandart.Insert("Truck"             ,"twirl#truckIcon");
		IconsTwirlStandart.Insert("train"             ,"twirl#trainIcon");
		IconsTwirlStandart.Insert("Tramway"           ,"twirl#tramwayIcon");
		IconsTwirlStandart.Insert("trolleybus"        ,"twirl#trolleybusIcon");
		IconsTwirlStandart.Insert("wifi"              ,"twirl#wifiIcon");
		IconsTwirlStandart.Insert("wifilogo"          ,"twirl#wifiLogoIcon");
		IconsTwirlStandart.Insert("turnleft"          ,"twirl#turnLeftIcon");
		IconsTwirlStandart.Insert("turnright"         ,"twirl#turnRightIcon");
		IconsTwirlStandart.Insert("arrowdownleft"     ,"twirl#arrowDownLeftIcon");
		IconsTwirlStandart.Insert("arrowdownright"    ,"twirl#arrowDownRightIcon");
		IconsTwirlStandart.Insert("arrowleft"         ,"twirl#arrowLeftIcon");
		IconsTwirlStandart.Insert("arrowright"        ,"twirl#arrowRightIcon");
		IconsTwirlStandart.Insert("arrowup"           ,"twirl#arrowUpIcon");
		
		IconsTwirlCluster = New Map;
		IconsTwirlCluster.Insert("blue"               ,"twirl#blueClusterIcons");
		IconsTwirlCluster.Insert("blueinverted"       ,"twirl#invertedBlueClusterIcons");
		IconsTwirlCluster.Insert("green"              ,"twirl#greenClusterIcons");
		IconsTwirlCluster.Insert("greeninverted"      ,"twirl#invertedGreenClusterIcons");
		IconsTwirlCluster.Insert("orange"             ,"twirl#orangeClusterIcons");
		IconsTwirlCluster.Insert("orangeinverted"     ,"twirl#invertedOrangeClusterIcons");
		IconsTwirlCluster.Insert("grey"               ,"twirl#greyClusterIcons");
		IconsTwirlCluster.Insert("greyinverted"       ,"twirl#invertedGreyClusterIcons");
		IconsTwirlCluster.Insert("yellow"             ,"twirl#yellowClusterIcons");
		IconsTwirlCluster.Insert("yellowinverted"     ,"twirl#invertedYellowClusterIcons");
		IconsTwirlCluster.Insert("brown"              ,"twirl#brownClusterIcons");
		IconsTwirlCluster.Insert("browninverted"      ,"twirl#invertedBrownClusterIcons");
		IconsTwirlCluster.Insert("red"                ,"twirl#redClusterIcons");
		IconsTwirlCluster.Insert("redinverted"        ,"twirl#invertedRedClusterIcons");
		IconsTwirlCluster.Insert("pink"               ,"twirl#pinkClusterIcons");
		IconsTwirlCluster.Insert("pinkinverted"       ,"twirl#invertedPinkClusterIcons");
		IconsTwirlCluster.Insert("violet"             ,"twirl#violetClusterIcons");
		IconsTwirlCluster.Insert("violetinverted"     ,"twirl#invertedVioletClusterIcons");
		IconsTwirlCluster.Insert("black"              ,"twirl#blackClusterIcons");
		IconsTwirlCluster.Insert("blackinverted"      ,"twirl#invertedBlackClusterIcons");
		IconsTwirlCluster.Insert("bluelight"          ,"twirl#lightblueClusterIcons");
		IconsTwirlCluster.Insert("bluelightinverted"  ,"twirl#invertedLightblueClusterIcons");
		IconsTwirlCluster.Insert("greendark"          ,"twirl#darkgreenClusterIcons");
		IconsTwirlCluster.Insert("greendarkinverted"  ,"twirl#invertedDarkgreenClusterIcons");
		IconsTwirlCluster.Insert("orangedark"         ,"twirl#darkorangeClusterIcons");
		IconsTwirlCluster.Insert("orangedarkinverted" ,"twirl#invertedDarkorangeClusterIcons");
		IconsTwirlCluster.Insert("bluedark"           ,"twirl#darkblueClusterIcons");
		IconsTwirlCluster.Insert("bluedarkinverted"   ,"twirl#invertedDarkblueClusterIcons");

		IconsСollection = New Structure;
		IconsСollection.Insert("twirl"                , IconsTwirl);
		IconsСollection.Insert("twirldot"             , IconsTwirlDot);
		IconsСollection.Insert("twirlstretchy"        , IconsTwirlStretchy);
		IconsСollection.Insert("twirlstandart"        , IconsTwirlStandart);
		IconsСollection.Insert("twirlcluster"         , IconsTwirlCluster);
		IconsСollection.Insert("islands"              , IconsIslands);
		IconsСollection.Insert("islandsdot"           , IconsIslandsDot);
		IconsСollection.Insert("islandsstretchy"      , IconsIslandsStretchy);
		IconsСollection.Insert("islandsstandart"      , IconsIslandsStandart);
		IconsСollection.Insert("islandsstandartCircle", IconsIslandsStandartCircle);
		IconsСollection.Insert("islandscluster"       , IconsIslandsCluster);
		
		ColorPalette = New Map;
		ColorPalette.Insert("blue"      ,"#0a6cc8");
		ColorPalette.Insert("green"     ,"#19b400");
		ColorPalette.Insert("orange"    ,"#cca42b");
		ColorPalette.Insert("grey"      ,"#95948e");
		ColorPalette.Insert("yellow"    ,"#d2c52a");
		ColorPalette.Insert("brown"     ,"#946134");
		ColorPalette.Insert("red"       ,"#de3531");
		ColorPalette.Insert("pink"      ,"#e666dc");
		ColorPalette.Insert("violet"    ,"#a31de1");
		ColorPalette.Insert("black"     ,"#000000");
		ColorPalette.Insert("olive"     ,"#97a100");
		ColorPalette.Insert("bluelight" ,"#4290e6");
		ColorPalette.Insert("greendark" ,"#158902");
		ColorPalette.Insert("orangedark","#cc6c2b");
		ColorPalette.Insert("bluedark"  ,"#3b49e8");
		
		ColorOrder = New Array;
		ColorOrder.Add("blue");
		ColorOrder.Add("green");
		ColorOrder.Add("orange");
		//ColorOrder.Add("red");
		ColorOrder.Add("violet");
		ColorOrder.Add("olive");
		ColorOrder.Add("yellow");
		ColorOrder.Add("brown");
		ColorOrder.Add("grey");
		ColorOrder.Add("black");
		ColorOrder.Add("bluelight");
		ColorOrder.Add("greendark");
		ColorOrder.Add("orangedark");
		ColorOrder.Add("bluedark");
		ColorOrder.Add("pink");
		
	ENDIF;
	
	IF NOT ValueIsFilled(DirectoryTempFiles) Then
		Return Undefined;
	ENDIF;
	
	WebMapStruct = New Structure;
	WebMapStruct.Insert("NameAPI"           , NameAPI);
	WebMapStruct.Insert("KeyAPI"            , KeyAPI);
	WebMapStruct.Insert("Caption"           , Caption);
	WebMapStruct.Insert("IconsСollection"   , IconsСollection);
	WebMapStruct.Insert("ColorPalette"      , ColorPalette);
	WebMapStruct.Insert("ColorOrder"        , ColorOrder);
	WebMapStruct.Insert("LatCenter"         , Lat);
	WebMapStruct.Insert("LonCenter"         , Lon);
	WebMapStruct.Insert("Directory"         , DirectoryTempFiles);
	
	Return WebMapStruct;
	
EndFunction

Function GetCoordsOnMap(ElementHTMLDoc) Export
	StructReturned = New Structure;
	StructReturned.Insert("Latitude" , 0);
	StructReturned.Insert("Longitude", 0);
	
	TRY
		IntegerType = New TypeDescription("Число", New NumberQualifiers(15, 12));
		
		CoordX = ElementHTMLDoc.document.getElementById("CoordX").value;
		CoordX = IntegerType.AdjustValue(CoordX);
		
		CoordY = ElementHTMLDoc.document.getElementById("CoordY").value;
		CoordY = IntegerType.AdjustValue(CoordY);
		
		IF CoordX > 0 AND CoordY > 0 THEN
			StructReturned.Latitude  = CoordX;
			StructReturned.Longitude = CoordY;
			
			ElementHTMLDoc.document.getElementById("CoordX").value = "0";
			ElementHTMLDoc.document.getElementById("CoordY").value = "0";
		ENDIF;
	EXCEPT
		Return Undefined;
	ENDTRY;
	
	Return StructReturned;
EndFunction

Function GeocodeAddress(ElementHTMLDoc, WebMapStruct, Address) Export
	StructReturned = New Structure;
	StructReturned.Insert("Latitude" , 0);
	StructReturned.Insert("Longitude", 0);
	
	IF Upper(WebMapStruct.NameAPI) = "YANDEX" THEN
		HTTPConnectYandex  = New HTTPConnection("geocode-maps.yandex.ru", , , , , 20, New OpenSSLSecureConnection);
		FileGeocodeAddress = WebMapStruct.Directory + "Yandex_geocode_" + TrimAll(New UUID)+".xml";
		
		WebMapStruct.Insert("FileGeocodeAddress", FileGeocodeAddress);
		
		TRY
			HTTPConnectYandex.Get("/1.x/?apikey="+WebMapStruct.KeyAPI+"&geocode=" + Address + "&results=10", FileGeocodeAddress);
		EXCEPT
			Message("Ошибка при попытке геокодировать по яндексу адрес: " + Address);
			Message(ErrorDescription());
			Return StructReturned;
		ENDTRY;
	ENDIF;
	
	XMLReader = New XMLReader;
	XMLReader.OpenFile(FileGeocodeAddress);
	
	DOMBuilder 	= New DOMBuilder;
	DOMDocument = DOMBuilder.Read(XMLReader);
	
	ListTagText = DOMDocument.GetElementByTagName("text");
	ListTagPos  = DOMDocument.GetElementByTagName("pos");
	
	IF (ListTagText.Count() = 0) OR (ListTagPos.Count() = 0) THEN
		Return StructReturned;
	ENDIF;
	
	Latitude  = 0;
	Longitude = 0;
	FOR EACH TagData IN  ListTagPos DO
		Coords	     = TagData.TextContent;
		Separator    = Find(Coords," ");
		TmpLatitude	 = Number(Mid (Coords, Separator + 1));
		TmpLongitude = Number(Left(Coords, Separator - 1));
		
		IF TmpLatitude = 0 OR TmpLongitude = 0 THEN
			Continue;
		ENDIF;
		
		Latitude  = TmpLatitude;
		Longitude = TmpLongitude;
		Break;
	ENDDO;
		
	StructReturned.Latitude  = Latitude;
	StructReturned.Longitude = Longitude;
	
	Return StructReturned;
	
EndFunction

Procedure ExecuteJavaScript(ElementHTMLDoc, Command) Export
	TRY
		ElementHTMLDoc.document.getElementById("WebClientOperation").value = Command;
		ElementHTMLDoc.document.getElementById("WebClient").click();
	EXCEPT
	ENDTRY;
EndProcedure	

Procedure AddPlacemark(ElementHTMLDoc, Latitude, Longitude, Color, TypeIcon, NamePartner = "", Address = "", RemoveAllPlacemark = True) Export
	NormalizeLatitude  = Format(Latitude , "ЧЦ=10; ЧДЦ=7; ЧРД=.; ЧРГ=");
	NormalizeLongitude = Format(Longitude, "ЧЦ=10; ЧДЦ=7; ЧРД=.; ЧРГ=");
	
	If RemoveAllPlacemark Then
		ExecuteJavaScript(ElementHTMLDoc, "RemoveAllPlacemark();");
	EndIf;
	ExecuteJavaScript(ElementHTMLDoc, "AddPlacemark(" + NormalizeLatitude + ", " + NormalizeLongitude+ ", '" + NamePartner + "', '" + Address+"', '" + Color + "', '" + TypeIcon + "');");
EndProcedure

Procedure PrepareHTMLTextGeocodeAddress(WebMapStruct) Export
	
	IF NOT TypeOf(WebMapStruct) = Type("Структура") THEN
		Return;
	ENDIF;
	
	IconType = Undefined;
	WebMapStruct.Property("IconType", IconType);
	IconType = ?(IconType = Undefined, "twirl", IconType);
	
	HTMLIsertedVars = New Structure;
	HTMLIsertedVars.Insert("HTMLTitle"         , WebMapStruct.Caption);
	HTMLIsertedVars.Insert("KeyAPI"            , WebMapStruct.KeyAPI);
	HTMLIsertedVars.Insert("MapWidth"          , "100%");
	HTMLIsertedVars.Insert("MapHeight"         , "100%");
	HTMLIsertedVars.Insert("LatCenter"         , WebMapStruct.LatCenter);
	HTMLIsertedVars.Insert("LonCenter"         , WebMapStruct.LonCenter);
	HTMLIsertedVars.Insert("NamePartner"       , WebMapStruct.NamePartner);
	HTMLIsertedVars.Insert("Address"           , WebMapStruct.Address);
	HTMLIsertedVars.Insert("Color"             , WebMapStruct.Color);
	HTMLIsertedVars.Insert("TypeIcon"          , WebMapStruct.TypeIcon);
	HTMLIsertedVars.Insert("ArrayRoutes"       , "[]");
	HTMLIsertedVars.Insert("ArrayPointsCluster", "[]");

	
	IF Upper(WebMapStruct.NameAPI) = "YANDEX" Then
		HTMLText = WebMapStruct.HTMLTextMap;
	ENDIF;
	
	HTMLText = StrReplace(HTMLText, "<#function_init#>", WebMapStruct.HTMLTextInit);
	HTMLText = StrReplace(HTMLText, "<#body#>"         , WebMapStruct.HTMLTextBody);
	FOR EACH Property IN HTMLIsertedVars DO
		HTMLText = StrReplace(HTMLText, "<#"+Property.Key+"#>", Property.Value);
	ENDDO;
	
	WebMapStruct.Insert("HTMLText", HTMLText);
	
EndProcedure

Procedure HTMLMessage(WebMapHTML, Msg, Color) Export
	
	WebMapHTML = "<!DOCTYPE html"">
				|<html xmlns=""http://www.w3.org/1999/xhtml""> 
				|	<meta http-equiv=""Content-Type"" content=""text/html; charset=UTF-8"" />
				|	<style type=""text/css"">
				|		body, html {
				|			z-index: 1;
				|			padding: 0;
				|			margin: 0;
				|			width: 97,5%;
				|			height: 98%;
				|			background-color: #FFFBF0;
				|		}
				|		.inner {
				|			top: 0;
				|			bottom: 0;
				|			left: 0;
				|			right: 0;
				|			width: 90%;
				|			height: 180px;
				|			margin-top: 20%;
				|			text-align: center;
				|			background-color: #FFFBF0;
				|		}
				|	</style>
				|	<body>
				|		<div class=""inner"">
				|			<h1 style=""text-align: center""><span style=""color:"+Color+""">"+Msg+"</span></h1>
				|		</div>
				|	</body>
				|</html>";
					
EndProcedure

Procedure PrepareHTMLTextRoutes(WebMapStruct, ForceColorAndTypeDefault = False) Export
	
	IF NOT TypeOf(WebMapStruct) = Type("Структура") THEN
		Return;
	ENDIF;
	
	ArrayRoutes        = Undefined;
	WebMapStruct.Property("ArrayRoutes", ArrayRoutes);
	
	IF ArrayRoutes = Undefined THEN
		Return;
	ELSE
		IF NOT TypeOf(ArrayRoutes) = Type("Массив") THEN
			Return;
		ENDIF;
	ENDIF;
	
	IF ArrayRoutes.Count() > WebMapStruct.ColorOrder.Count() THEN
		Message("Одновременно отображаемых маршрутов на карте не может быть более "+WebMapStruct.ColorOrder.Count());
		Return;
	ENDIF;
	
	ArrayPointsCluster = New Array;
	
	IconType = Undefined;
	WebMapStruct.Property("IconType", IconType);
	
	IconType               = ?(IconType = Undefined, "islands", IconType);
	TextArrayRoutes        = "";
	TextArrayPointsCluster = "";
	CounterRoute           = 1;
	Ident                  = "				";
	FOR EACH Route IN ArrayRoutes DO
		
		Name        = "";
		Driver      = "";
		Car         = "";
		ColorName   = WebMapStruct.ColorOrder.Get(CounterRoute - 1);
		Color       = WebMapStruct.ColorPalette.Get(ColorName);
		TypeIcon    = WebMapStruct.IconsСollection[Lower(IconType)][Lower(ColorName)];
		ArrayPoints = "";
		
		Route.Property("Name"       , Name       );
		Route.Property("Driver"     , Driver     );
		Route.Property("Car"        , Car        );
		Route.Property("ArrayPoints", ArrayPoints);
		
		Name   = ?(Name = Undefined  , "", RemoveForbidenCharacters(Name)  );
		Driver = ?(Driver = Undefined, "", RemoveForbidenCharacters(Driver));
		Car    = ?(Car = Undefined   , "", RemoveForbidenCharacters(Car)   );
		
		IF ArrayPoints = Undefined THEN
			Continue;
		ELSE
			IF NOT TypeOf(ArrayPoints) = Type("Массив") THEN
				Continue;
			ENDIF;
		ENDIF;
		
		TextArrayPoints = "";
		FOR EACH Point IN Route.ArrayPoints DO
			
			If Point = Undefined Then
				Continue;
			EndIf;
			
			If Point.Count() = 0 Then
				Continue;
			EndIf;
			
			NormalizePoint = NormalizePointValues(Point);
			
			TextArrayPoints = TextArrayPoints + Ident + "			" +
			                  "['"+NormalizePoint.Name+"'"+
			                  ",'"+NormalizePoint.Address+"'"+
			                  ","+NormalizePoint.Latitude+
			                  ","+NormalizePoint.Longitude+
			                  ","+NormalizePoint.NumCruise+
			                  ","+NormalizePoint.NumInCruise+
			                  ","+NormalizePoint.Weight+
			                  ","+NormalizePoint.Ammount+
			                  ","+NormalizePoint.Profit+
			                  "],"+Chars.LF;
			
			ColorPoint    = Undefined;
			TypeIconPoint = Undefined;
			MainPoint     = Undefined;
			
			Point.Property("Color"   , ColorPoint);
			Point.Property("TypeIcon", TypeIconPoint);
			Point.Property("MainPoint",MainPoint);
			
			MainPoint = ?(MainPoint = Undefined, False, MainPoint);
			
			ClusterPointExist = False;
			If MainPoint Then
				FOR EACH ClusterPoint IN ArrayPointsCluster DO
					IF ClusterPoint.Name = NormalizePoint.Name THEN
						ClusterPointExist = True;
					ENDIF;
				ENDDO;
			EndIf;
			
			IF NOT ClusterPointExist THEN
			
				If ForceColorAndTypeDefault AND NOT MainPoint Then
					NormalizePoint.Insert("Color"    , "'"+Color+"'");
					NormalizePoint.Insert("TypeIcon" , "'"+TypeIcon+"'");
				Else
					NormalizePoint.Insert("Color"    , "'"+?(ColorPoint = Undefined, Color, RemoveForbidenCharacters(ColorPoint, "Color"))+"'");
					NormalizePoint.Insert("TypeIcon" , "'"+?(TypeIconPoint = Undefined, TypeIcon, RemoveForbidenCharacters(TypeIconPoint, "TypeIcon"))+"'");
				EndIf;
				NormalizePoint.Insert("RouteName", "'"+Name+"'");
				NormalizePoint.Insert("Driver"   , "'"+Driver+"'");
				NormalizePoint.Insert("Car"      , "'"+Car+"'");
				ArrayPointsCluster.Add(NormalizePoint);
				
			EndIf;
			
		ENDDO;
		TextArrayPoints = Chars.LF + Ident + "		" + "[" + Chars.LF + TextArrayPoints + Ident + "		" + "]";

		TextArrayRoutes = TextArrayRoutes + Ident + "	" +
		                  "['"+Name+"'"+
		                  ",'"+Driver+"'"+
		                  ",'"+Car+"'"+
		                  ",'"+Color+"'"+
		                  ",'"+TypeIcon+"'"+
		                  ","+TextArrayPoints+
		                  Chars.LF + Ident + "	"+ "],"+Chars.LF;
		
		CounterRoute = CounterRoute + 1;
		
	ENDDO;
	
	TextArrayRoutes = Chars.LF +
	                  Ident + "[" + Chars.LF +
					  TextArrayRoutes +
					  Ident + "]";
					  
	FOR EACH Point IN ArrayPointsCluster DO
		NormalizePoint = NormalizePointValues(Point);
		
		TextArrayPointsCluster = TextArrayPointsCluster + Ident + "	" +
		                         "['"+NormalizePoint.Name+"'" +
		                         ",'"+NormalizePoint.Address+"'"+
		                         ","+NormalizePoint.Latitude+
		                         ","+NormalizePoint.Longitude+
		                         ","+NormalizePoint.NumCruise+
		                         ","+NormalizePoint.NumInCruise+
		                         ","+NormalizePoint.Weight+
		                         ","+NormalizePoint.Ammount+
		                         ","+NormalizePoint.Profit+
		                         ","+NormalizePoint.Color+
		                         ","+NormalizePoint.TypeIcon+
		                         ","+NormalizePoint.RouteName+
		                         ","+NormalizePoint.Driver+
		                         ","+NormalizePoint.Car+
		                         "],"+Chars.LF;

	ENDDO;
	
	TextArrayPointsCluster = Chars.LF +
	                         Ident + "[" + Chars.LF +
					         TextArrayPointsCluster +
					         Ident + "]";
	
	HTMLIsertedVars = New Structure;
	HTMLIsertedVars.Insert("HTMLTitle"         , WebMapStruct.Caption);
	HTMLIsertedVars.Insert("KeyAPI"            , WebMapStruct.KeyAPI);
	HTMLIsertedVars.Insert("MapWidth"          , "100%");
	HTMLIsertedVars.Insert("MapHeight"         , "100%");
	HTMLIsertedVars.Insert("LatCenter"         , WebMapStruct.LatCenter);
	HTMLIsertedVars.Insert("LonCenter"         , WebMapStruct.LonCenter);
	HTMLIsertedVars.Insert("ArrayRoutes"       , TextArrayRoutes);
	HTMLIsertedVars.Insert("ArrayPointsCluster", TextArrayPointsCluster);
	
	IF Upper(WebMapStruct.NameAPI) = "YANDEX" Then
		HTMLText = WebMapStruct.HTMLTextMap;
	ENDIF;
	
	HTMLText = StrReplace(HTMLText, "<#function_init#>", WebMapStruct.HTMLTextInit);
	HTMLText = StrReplace(HTMLText, "<#body#>"         , WebMapStruct.HTMLTextBody);
	FOR EACH Property IN HTMLIsertedVars DO
		HTMLText = StrReplace(HTMLText, "<#"+Property.Key+"#>", Property.Value);
	ENDDO;
	
	WebMapStruct.Insert("HTMLText", HTMLText);
	
EndProcedure

Function NormalizePointValues(Val Point)
	
	Name        = "";
	Address     = "";
	Latitude    = "";
	Longitude   = "";
	NumCruise   = "";
	NumInCruise = "";
	Weight      = "";
	Ammount     = "";
	Profit      = "";
			
	Point.Property("Name"       , Name       );
	Point.Property("Address"    , Address    );
	Point.Property("Latitude"   , Latitude   );
	Point.Property("Longitude"  , Longitude  );
	Point.Property("NumCruise"  , NumCruise  );
	Point.Property("NumInCruise", NumInCruise);
	Point.Property("Weight"     , Weight     );
	Point.Property("Ammount"    , Ammount    );
	Point.Property("Profit"     , Profit     );
			
	Point.Insert("Name"        , ?(Name = Undefined       , ""  , RemoveForbidenCharacters(Name)       ));
	Point.Insert("Address"     , ?(Address = Undefined    , ""  , RemoveForbidenCharacters(Address)    ));
	Point.Insert("Latitude"    , ?(Latitude = Undefined   , "0" , RemoveForbidenCharacters(Latitude)   ));
	Point.Insert("Longitude"   , ?(Longitude = Undefined  , "0" , RemoveForbidenCharacters(Longitude)  ));
	Point.Insert("NumCruise"   , ?(NumCruise = Undefined  , "0" , RemoveForbidenCharacters(NumCruise)  ));
	Point.Insert("NumInCruise" , ?(NumInCruise = Undefined, "0" , RemoveForbidenCharacters(NumInCruise)));
	Point.Insert("Weight"      , ?(Weight = Undefined     , "0" , RemoveForbidenCharacters(Weight)     ));
	Point.Insert("Ammount"     , ?(Ammount = Undefined    , "0" , RemoveForbidenCharacters(Ammount)    ));
	Point.Insert("Profit"      , ?(Profit = Undefined     , "0" , RemoveForbidenCharacters(Profit)     ));

	Return Point;
	
EndFunction

Function RemoveForbidenCharacters(Val Value, DataType = "String")
	
	Value = StrReplace(Value, """", "");
	Value = StrReplace(Value, "'", "");
	Value = StrReplace(Value, "`", "");
	//Value = StrReplace(Value, "/", "");
	//Value = StrReplace(Value, "\", "");
	If NOT Lower(DataType) = "color" AND NOT Lower(DataType) = "typeicon" then
		Value = StrReplace(Value, "#", "N");
		Value = StrReplace(Value, "№", "N");
	EndIf;
	Value = StrReplace(Value, "«", "");
	Value = StrReplace(Value, "»", "");
	Value = StrReplace(Value, "+", "");
	Value = StrReplace(Value, ">", "");
	Value = StrReplace(Value, "<", "");
	
	Return TrimAll(Value);
	
EndFunction
