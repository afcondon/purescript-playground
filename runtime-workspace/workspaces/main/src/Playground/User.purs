module Playground.User where

-- World-map bubbles starter — 245 countries (from restcountries.com,
-- snapshot 2026-04-20). Grouped by continent and laid out with
-- DataViz.Layout.Hierarchy.Pack. Rendered as SVG for the render column.
--
-- Next steps:
--   1. Add a secondary circle per country sized by population
--      (low-opacity fill inside the land bubble) — visually separates
--      dense countries from sparse ones against the global average
--      (~58.86 people/km²).
--   2. Colour continents distinctly.
--   3. Label the largest N bubbles.

import Prelude

import Data.Array as Array
import Data.Foldable (foldl)
import Data.Map (Map)
import Data.Map as Map
import Data.Maybe (Maybe(..))
import Data.Number.Format (toString) as Num
import Data.Tuple (Tuple(..))
import DataViz.Layout.Hierarchy.Pack (HierarchyData(..), PackNode(..), defaultPackConfig, hierarchy, pack)
import Data.Number (sqrt)
import Data.Int (toNumber)
import Data.FoldableWithIndex (foldlWithIndex)

type Country =
  { code :: String
  , name :: String
  , continent :: String
  , areaKm2 :: Number
  , population :: Number
  }

countries :: Array Country
countries = [ { code: "ABW", name: "Aruba", continent: "North America", areaKm2: 180.0, population: 107566.0 }
  , { code: "AFG", name: "Afghanistan", continent: "Asia", areaKm2: 652230.0, population: 43844000.0 }
  , { code: "AGO", name: "Angola", continent: "Africa", areaKm2: 1246700.0, population: 36170961.0 }
  , { code: "AIA", name: "Anguilla", continent: "North America", areaKm2: 91.0, population: 16010.0 }
  , { code: "ALA", name: "Åland Islands", continent: "Europe", areaKm2: 1580.0, population: 30654.0 }
  , { code: "ALB", name: "Albania", continent: "Europe", areaKm2: 28748.0, population: 2363314.0 }
  , { code: "AND", name: "Andorra", continent: "Europe", areaKm2: 468.0, population: 88406.0 }
  , { code: "ARE", name: "United Arab Emirates", continent: "Asia", areaKm2: 83600.0, population: 11294243.0 }
  , { code: "ARG", name: "Argentina", continent: "South America", areaKm2: 2780400.0, population: 46735004.0 }
  , { code: "ARM", name: "Armenia", continent: "Asia", areaKm2: 29743.0, population: 3076200.0 }
  , { code: "ASM", name: "American Samoa", continent: "Oceania", areaKm2: 199.0, population: 49710.0 }
  , { code: "ATG", name: "Antigua and Barbuda", continent: "North America", areaKm2: 442.0, population: 103603.0 }
  , { code: "AUS", name: "Australia", continent: "Oceania", areaKm2: 7692024.0, population: 27536874.0 }
  , { code: "AUT", name: "Austria", continent: "Europe", areaKm2: 83871.0, population: 9200931.0 }
  , { code: "AZE", name: "Azerbaijan", continent: "Asia", areaKm2: 86600.0, population: 10241722.0 }
  , { code: "BDI", name: "Burundi", continent: "Africa", areaKm2: 27834.0, population: 12332788.0 }
  , { code: "BEL", name: "Belgium", continent: "Europe", areaKm2: 30528.0, population: 11825551.0 }
  , { code: "BEN", name: "Benin", continent: "Africa", areaKm2: 112622.0, population: 13224860.0 }
  , { code: "BES", name: "Caribbean Netherlands", continent: "North America", areaKm2: 328.0, population: 31980.0 }
  , { code: "BFA", name: "Burkina Faso", continent: "Africa", areaKm2: 272967.0, population: 24070553.0 }
  , { code: "BGD", name: "Bangladesh", continent: "Asia", areaKm2: 147570.0, population: 169828911.0 }
  , { code: "BGR", name: "Bulgaria", continent: "Europe", areaKm2: 110879.0, population: 6437360.0 }
  , { code: "BHR", name: "Bahrain", continent: "Asia", areaKm2: 765.0, population: 1594654.0 }
  , { code: "BHS", name: "Bahamas", continent: "North America", areaKm2: 13943.0, population: 398165.0 }
  , { code: "BIH", name: "Bosnia and Herzegovina", continent: "Europe", areaKm2: 51209.0, population: 3422000.0 }
  , { code: "BLM", name: "Saint Barthélemy", continent: "North America", areaKm2: 21.0, population: 10562.0 }
  , { code: "BLR", name: "Belarus", continent: "Europe", areaKm2: 207600.0, population: 9109280.0 }
  , { code: "BLZ", name: "Belize", continent: "North America", areaKm2: 22966.0, population: 417634.0 }
  , { code: "BMU", name: "Bermuda", continent: "North America", areaKm2: 54.0, population: 64055.0 }
  , { code: "BOL", name: "Bolivia", continent: "South America", areaKm2: 1098581.0, population: 11365333.0 }
  , { code: "BRA", name: "Brazil", continent: "South America", areaKm2: 8515767.0, population: 213421037.0 }
  , { code: "BRB", name: "Barbados", continent: "North America", areaKm2: 430.0, population: 267800.0 }
  , { code: "BRN", name: "Brunei", continent: "Asia", areaKm2: 5765.0, population: 455500.0 }
  , { code: "BTN", name: "Bhutan", continent: "Asia", areaKm2: 38394.0, population: 784043.0 }
  , { code: "BWA", name: "Botswana", continent: "Africa", areaKm2: 582000.0, population: 2359609.0 }
  , { code: "CAF", name: "Central African Republic", continent: "Africa", areaKm2: 622984.0, population: 6470307.0 }
  , { code: "CAN", name: "Canada", continent: "North America", areaKm2: 9984670.0, population: 41651653.0 }
  , { code: "CCK", name: "Cocos (Keeling) Islands", continent: "Asia", areaKm2: 14.0, population: 593.0 }
  , { code: "CHE", name: "Switzerland", continent: "Europe", areaKm2: 41284.0, population: 9082848.0 }
  , { code: "CHL", name: "Chile", continent: "South America", areaKm2: 756102.0, population: 20206953.0 }
  , { code: "CHN", name: "China", continent: "Asia", areaKm2: 9706961.0, population: 1408280000.0 }
  , { code: "CIV", name: "Ivory Coast", continent: "Africa", areaKm2: 322463.0, population: 31719275.0 }
  , { code: "CMR", name: "Cameroon", continent: "Africa", areaKm2: 475442.0, population: 29442327.0 }
  , { code: "COD", name: "DR Congo", continent: "Africa", areaKm2: 2344858.0, population: 112832000.0 }
  , { code: "COG", name: "Republic of the Congo", continent: "Africa", areaKm2: 342000.0, population: 6142180.0 }
  , { code: "COK", name: "Cook Islands", continent: "Oceania", areaKm2: 236.0, population: 15040.0 }
  , { code: "COL", name: "Colombia", continent: "South America", areaKm2: 1141748.0, population: 53057212.0 }
  , { code: "COM", name: "Comoros", continent: "Africa", areaKm2: 1862.0, population: 919901.0 }
  , { code: "CPV", name: "Cape Verde", continent: "Africa", areaKm2: 4033.0, population: 491233.0 }
  , { code: "CRI", name: "Costa Rica", continent: "North America", areaKm2: 51100.0, population: 5309625.0 }
  , { code: "CUB", name: "Cuba", continent: "North America", areaKm2: 109884.0, population: 9748007.0 }
  , { code: "CUW", name: "Curaçao", continent: "North America", areaKm2: 444.0, population: 156115.0 }
  , { code: "CXR", name: "Christmas Island", continent: "Asia", areaKm2: 135.0, population: 1692.0 }
  , { code: "CYM", name: "Cayman Islands", continent: "North America", areaKm2: 264.0, population: 84738.0 }
  , { code: "CYP", name: "Cyprus", continent: "Europe", areaKm2: 9251.0, population: 1442614.0 }
  , { code: "CZE", name: "Czechia", continent: "Europe", areaKm2: 78865.0, population: 10882341.0 }
  , { code: "DEU", name: "Germany", continent: "Europe", areaKm2: 357114.0, population: 83491249.0 }
  , { code: "DJI", name: "Djibouti", continent: "Africa", areaKm2: 23200.0, population: 1066809.0 }
  , { code: "DMA", name: "Dominica", continent: "North America", areaKm2: 751.0, population: 67408.0 }
  , { code: "DNK", name: "Denmark", continent: "Europe", areaKm2: 43094.0, population: 6011488.0 }
  , { code: "DOM", name: "Dominican Republic", continent: "North America", areaKm2: 48671.0, population: 10771504.0 }
  , { code: "DZA", name: "Algeria", continent: "Africa", areaKm2: 2381741.0, population: 47400000.0 }
  , { code: "ECU", name: "Ecuador", continent: "South America", areaKm2: 276841.0, population: 18103660.0 }
  , { code: "EGY", name: "Egypt", continent: "Africa", areaKm2: 1002450.0, population: 107271260.0 }
  , { code: "ERI", name: "Eritrea", continent: "Africa", areaKm2: 117600.0, population: 3607000.0 }
  , { code: "ESH", name: "Western Sahara", continent: "Africa", areaKm2: 266000.0, population: 600904.0 }
  , { code: "ESP", name: "Spain", continent: "Europe", areaKm2: 505992.0, population: 49315949.0 }
  , { code: "EST", name: "Estonia", continent: "Europe", areaKm2: 45227.0, population: 1369995.0 }
  , { code: "ETH", name: "Ethiopia", continent: "Africa", areaKm2: 1104300.0, population: 111652998.0 }
  , { code: "FIN", name: "Finland", continent: "Europe", areaKm2: 338455.0, population: 5650325.0 }
  , { code: "FJI", name: "Fiji", continent: "Oceania", areaKm2: 18272.0, population: 900869.0 }
  , { code: "FLK", name: "Falkland Islands", continent: "South America", areaKm2: 12173.0, population: 3662.0 }
  , { code: "FRA", name: "France", continent: "Europe", areaKm2: 543908.0, population: 66351959.0 }
  , { code: "FRO", name: "Faroe Islands", continent: "Europe", areaKm2: 1393.0, population: 54885.0 }
  , { code: "FSM", name: "Micronesia", continent: "Oceania", areaKm2: 702.0, population: 105564.0 }
  , { code: "GAB", name: "Gabon", continent: "Africa", areaKm2: 267668.0, population: 2469296.0 }
  , { code: "GBR", name: "United Kingdom", continent: "Europe", areaKm2: 244376.0, population: 69281437.0 }
  , { code: "GEO", name: "Georgia", continent: "Asia", areaKm2: 69700.0, population: 4000921.0 }
  , { code: "GGY", name: "Guernsey", continent: "Europe", areaKm2: 78.0, population: 64781.0 }
  , { code: "GHA", name: "Ghana", continent: "Africa", areaKm2: 238533.0, population: 33742380.0 }
  , { code: "GIB", name: "Gibraltar", continent: "Europe", areaKm2: 6.0, population: 38000.0 }
  , { code: "GIN", name: "Guinea", continent: "Africa", areaKm2: 245857.0, population: 14363931.0 }
  , { code: "GLP", name: "Guadeloupe", continent: "North America", areaKm2: 1628.0, population: 378561.0 }
  , { code: "GMB", name: "Gambia", continent: "Africa", areaKm2: 10689.0, population: 2422712.0 }
  , { code: "GNB", name: "Guinea-Bissau", continent: "Africa", areaKm2: 36125.0, population: 1781308.0 }
  , { code: "GNQ", name: "Equatorial Guinea", continent: "Africa", areaKm2: 28051.0, population: 1668768.0 }
  , { code: "GRC", name: "Greece", continent: "Europe", areaKm2: 131990.0, population: 10400720.0 }
  , { code: "GRD", name: "Grenada", continent: "North America", areaKm2: 344.0, population: 109021.0 }
  , { code: "GRL", name: "Greenland", continent: "North America", areaKm2: 2166086.0, population: 56542.0 }
  , { code: "GTM", name: "Guatemala", continent: "North America", areaKm2: 108889.0, population: 18079810.0 }
  , { code: "GUF", name: "French Guiana", continent: "South America", areaKm2: 83534.0, population: 292354.0 }
  , { code: "GUM", name: "Guam", continent: "Oceania", areaKm2: 549.0, population: 153836.0 }
  , { code: "GUY", name: "Guyana", continent: "South America", areaKm2: 214969.0, population: 772975.0 }
  , { code: "HKG", name: "Hong Kong", continent: "Asia", areaKm2: 1104.0, population: 7527500.0 }
  , { code: "HND", name: "Honduras", continent: "North America", areaKm2: 112492.0, population: 9892632.0 }
  , { code: "HRV", name: "Croatia", continent: "Europe", areaKm2: 56594.0, population: 3866233.0 }
  , { code: "HTI", name: "Haiti", continent: "North America", areaKm2: 27750.0, population: 11867032.0 }
  , { code: "HUN", name: "Hungary", continent: "Europe", areaKm2: 93028.0, population: 9539502.0 }
  , { code: "IDN", name: "Indonesia", continent: "Asia", areaKm2: 1904569.0, population: 284438782.0 }
  , { code: "IMN", name: "Isle of Man", continent: "Europe", areaKm2: 572.0, population: 84530.0 }
  , { code: "IND", name: "India", continent: "Asia", areaKm2: 3287263.0, population: 1417492000.0 }
  , { code: "IOT", name: "British Indian Ocean Territory", continent: "Asia", areaKm2: 60.0, population: 0.0 }
  , { code: "IRL", name: "Ireland", continent: "Europe", areaKm2: 70273.0, population: 5458600.0 }
  , { code: "IRN", name: "Iran", continent: "Asia", areaKm2: 1648195.0, population: 85961000.0 }
  , { code: "IRQ", name: "Iraq", continent: "Asia", areaKm2: 438317.0, population: 46118793.0 }
  , { code: "ISL", name: "Iceland", continent: "Europe", areaKm2: 103000.0, population: 391810.0 }
  , { code: "ISR", name: "Israel", continent: "Asia", areaKm2: 21937.0, population: 10134800.0 }
  , { code: "ITA", name: "Italy", continent: "Europe", areaKm2: 301336.0, population: 58927633.0 }
  , { code: "JAM", name: "Jamaica", continent: "North America", areaKm2: 10991.0, population: 2825544.0 }
  , { code: "JEY", name: "Jersey", continent: "Europe", areaKm2: 116.0, population: 103267.0 }
  , { code: "JOR", name: "Jordan", continent: "Asia", areaKm2: 89342.0, population: 11734000.0 }
  , { code: "JPN", name: "Japan", continent: "Asia", areaKm2: 377930.0, population: 123210000.0 }
  , { code: "KAZ", name: "Kazakhstan", continent: "Asia", areaKm2: 2724900.0, population: 20426568.0 }
  , { code: "KEN", name: "Kenya", continent: "Africa", areaKm2: 580367.0, population: 53330978.0 }
  , { code: "KGZ", name: "Kyrgyzstan", continent: "Asia", areaKm2: 199951.0, population: 7281800.0 }
  , { code: "KHM", name: "Cambodia", continent: "Asia", areaKm2: 181035.0, population: 17577760.0 }
  , { code: "KIR", name: "Kiribati", continent: "Oceania", areaKm2: 811.0, population: 120740.0 }
  , { code: "KNA", name: "Saint Kitts and Nevis", continent: "North America", areaKm2: 261.0, population: 51320.0 }
  , { code: "KOR", name: "South Korea", continent: "Asia", areaKm2: 100210.0, population: 51159889.0 }
  , { code: "KWT", name: "Kuwait", continent: "Asia", areaKm2: 17818.0, population: 4881254.0 }
  , { code: "LAO", name: "Laos", continent: "Asia", areaKm2: 236800.0, population: 7647000.0 }
  , { code: "LBN", name: "Lebanon", continent: "Asia", areaKm2: 10452.0, population: 5490000.0 }
  , { code: "LBR", name: "Liberia", continent: "Africa", areaKm2: 111369.0, population: 5248621.0 }
  , { code: "LBY", name: "Libya", continent: "Africa", areaKm2: 1759540.0, population: 7459000.0 }
  , { code: "LCA", name: "Saint Lucia", continent: "North America", areaKm2: 616.0, population: 184100.0 }
  , { code: "LIE", name: "Liechtenstein", continent: "Europe", areaKm2: 160.0, population: 40900.0 }
  , { code: "LKA", name: "Sri Lanka", continent: "Asia", areaKm2: 65610.0, population: 21763170.0 }
  , { code: "LSO", name: "Lesotho", continent: "Africa", areaKm2: 30355.0, population: 2116427.0 }
  , { code: "LTU", name: "Lithuania", continent: "Europe", areaKm2: 65300.0, population: 2894886.0 }
  , { code: "LUX", name: "Luxembourg", continent: "Europe", areaKm2: 2586.0, population: 681973.0 }
  , { code: "LVA", name: "Latvia", continent: "Europe", areaKm2: 64559.0, population: 1829000.0 }
  , { code: "MAC", name: "Macau", continent: "Asia", areaKm2: 30.0, population: 685900.0 }
  , { code: "MAF", name: "Saint Martin", continent: "North America", areaKm2: 53.0, population: 31496.0 }
  , { code: "MAR", name: "Morocco", continent: "Africa", areaKm2: 446550.0, population: 36828330.0 }
  , { code: "MCO", name: "Monaco", continent: "Europe", areaKm2: 2.0, population: 38423.0 }
  , { code: "MDA", name: "Moldova", continent: "Europe", areaKm2: 33847.0, population: 2749076.0 }
  , { code: "MDG", name: "Madagascar", continent: "Africa", areaKm2: 587041.0, population: 31727042.0 }
  , { code: "MDV", name: "Maldives", continent: "Asia", areaKm2: 300.0, population: 515132.0 }
  , { code: "MEX", name: "Mexico", continent: "North America", areaKm2: 1964375.0, population: 130575786.0 }
  , { code: "MHL", name: "Marshall Islands", continent: "Oceania", areaKm2: 181.0, population: 42418.0 }
  , { code: "MKD", name: "North Macedonia", continent: "Europe", areaKm2: 25713.0, population: 1822612.0 }
  , { code: "MLI", name: "Mali", continent: "Africa", areaKm2: 1240192.0, population: 22395489.0 }
  , { code: "MLT", name: "Malta", continent: "Europe", areaKm2: 316.0, population: 574250.0 }
  , { code: "MMR", name: "Myanmar", continent: "Asia", areaKm2: 676578.0, population: 51316756.0 }
  , { code: "MNE", name: "Montenegro", continent: "Europe", areaKm2: 13812.0, population: 623327.0 }
  , { code: "MNG", name: "Mongolia", continent: "Asia", areaKm2: 1564110.0, population: 3544835.0 }
  , { code: "MNP", name: "Northern Mariana Islands", continent: "Oceania", areaKm2: 464.0, population: 47329.0 }
  , { code: "MOZ", name: "Mozambique", continent: "Africa", areaKm2: 801590.0, population: 34090466.0 }
  , { code: "MRT", name: "Mauritania", continent: "Africa", areaKm2: 1030700.0, population: 4927532.0 }
  , { code: "MSR", name: "Montserrat", continent: "North America", areaKm2: 102.0, population: 4386.0 }
  , { code: "MTQ", name: "Martinique", continent: "North America", areaKm2: 1128.0, population: 349925.0 }
  , { code: "MUS", name: "Mauritius", continent: "Africa", areaKm2: 2040.0, population: 1243741.0 }
  , { code: "MWI", name: "Malawi", continent: "Africa", areaKm2: 118484.0, population: 20734262.0 }
  , { code: "MYS", name: "Malaysia", continent: "Asia", areaKm2: 330803.0, population: 34231700.0 }
  , { code: "MYT", name: "Mayotte", continent: "Africa", areaKm2: 374.0, population: 320901.0 }
  , { code: "NAM", name: "Namibia", continent: "Africa", areaKm2: 825615.0, population: 3022401.0 }
  , { code: "NCL", name: "New Caledonia", continent: "Oceania", areaKm2: 18575.0, population: 264596.0 }
  , { code: "NER", name: "Niger", continent: "Africa", areaKm2: 1267000.0, population: 26312034.0 }
  , { code: "NFK", name: "Norfolk Island", continent: "Oceania", areaKm2: 36.0, population: 2188.0 }
  , { code: "NGA", name: "Nigeria", continent: "Africa", areaKm2: 923768.0, population: 223800000.0 }
  , { code: "NIC", name: "Nicaragua", continent: "North America", areaKm2: 130373.0, population: 6803886.0 }
  , { code: "NIU", name: "Niue", continent: "Oceania", areaKm2: 260.0, population: 1681.0 }
  , { code: "NLD", name: "Netherlands", continent: "Europe", areaKm2: 41865.0, population: 18100436.0 }
  , { code: "NOR", name: "Norway", continent: "Europe", areaKm2: 386224.0, population: 5606944.0 }
  , { code: "NPL", name: "Nepal", continent: "Asia", areaKm2: 147181.0, population: 29911840.0 }
  , { code: "NRU", name: "Nauru", continent: "Oceania", areaKm2: 21.0, population: 11680.0 }
  , { code: "NZL", name: "New Zealand", continent: "Oceania", areaKm2: 268838.0, population: 5324700.0 }
  , { code: "OMN", name: "Oman", continent: "Asia", areaKm2: 309500.0, population: 5343630.0 }
  , { code: "PAK", name: "Pakistan", continent: "Asia", areaKm2: 796095.0, population: 241499431.0 }
  , { code: "PAN", name: "Panama", continent: "North America", areaKm2: 75417.0, population: 4064780.0 }
  , { code: "PCN", name: "Pitcairn Islands", continent: "Oceania", areaKm2: 47.0, population: 35.0 }
  , { code: "PER", name: "Peru", continent: "South America", areaKm2: 1285216.0, population: 34350244.0 }
  , { code: "PHL", name: "Philippines", continent: "Asia", areaKm2: 342353.0, population: 114123600.0 }
  , { code: "PLW", name: "Palau", continent: "Oceania", areaKm2: 459.0, population: 16733.0 }
  , { code: "PNG", name: "Papua New Guinea", continent: "Oceania", areaKm2: 462840.0, population: 11781559.0 }
  , { code: "POL", name: "Poland", continent: "Europe", areaKm2: 312679.0, population: 37392000.0 }
  , { code: "PRI", name: "Puerto Rico", continent: "North America", areaKm2: 8870.0, population: 3203295.0 }
  , { code: "PRK", name: "North Korea", continent: "Asia", areaKm2: 120538.0, population: 25950000.0 }
  , { code: "PRT", name: "Portugal", continent: "Europe", areaKm2: 92090.0, population: 10749635.0 }
  , { code: "PRY", name: "Paraguay", continent: "South America", areaKm2: 406752.0, population: 6109644.0 }
  , { code: "PSE", name: "Palestine", continent: "Asia", areaKm2: 6220.0, population: 5483450.0 }
  , { code: "PYF", name: "French Polynesia", continent: "Oceania", areaKm2: 4167.0, population: 279500.0 }
  , { code: "QAT", name: "Qatar", continent: "Asia", areaKm2: 11586.0, population: 3173024.0 }
  , { code: "REU", name: "Réunion", continent: "Africa", areaKm2: 2511.0, population: 896175.0 }
  , { code: "ROU", name: "Romania", continent: "Europe", areaKm2: 238391.0, population: 19036031.0 }
  , { code: "RUS", name: "Russia", continent: "Asia", areaKm2: 17098246.0, population: 146028325.0 }
  , { code: "RWA", name: "Rwanda", continent: "Africa", areaKm2: 26338.0, population: 14104969.0 }
  , { code: "SAU", name: "Saudi Arabia", continent: "Asia", areaKm2: 2149690.0, population: 35300280.0 }
  , { code: "SDN", name: "Sudan", continent: "Africa", areaKm2: 1886068.0, population: 51662000.0 }
  , { code: "SEN", name: "Senegal", continent: "Africa", areaKm2: 196722.0, population: 18593258.0 }
  , { code: "SGP", name: "Singapore", continent: "Asia", areaKm2: 710.0, population: 6110200.0 }
  , { code: "SHN", name: "Saint Helena, Ascension and Tristan da Cunha", continent: "Africa", areaKm2: 394.0, population: 5651.0 }
  , { code: "SJM", name: "Svalbard and Jan Mayen", continent: "Europe", areaKm2: 61399.0, population: 2530.0 }
  , { code: "SLB", name: "Solomon Islands", continent: "Oceania", areaKm2: 28896.0, population: 750325.0 }
  , { code: "SLE", name: "Sierra Leone", continent: "Africa", areaKm2: 71740.0, population: 9077691.0 }
  , { code: "SLV", name: "El Salvador", continent: "North America", areaKm2: 21041.0, population: 6029976.0 }
  , { code: "SMR", name: "San Marino", continent: "Europe", areaKm2: 61.0, population: 34132.0 }
  , { code: "SOM", name: "Somalia", continent: "Africa", areaKm2: 637657.0, population: 19655000.0 }
  , { code: "SPM", name: "Saint Pierre and Miquelon", continent: "North America", areaKm2: 242.0, population: 5819.0 }
  , { code: "SRB", name: "Serbia", continent: "Europe", areaKm2: 77589.0, population: 6567783.0 }
  , { code: "SSD", name: "South Sudan", continent: "Africa", areaKm2: 619745.0, population: 15786898.0 }
  , { code: "STP", name: "São Tomé and Príncipe", continent: "Africa", areaKm2: 964.0, population: 209607.0 }
  , { code: "SUR", name: "Suriname", continent: "South America", areaKm2: 163820.0, population: 616500.0 }
  , { code: "SVK", name: "Slovakia", continent: "Europe", areaKm2: 49037.0, population: 5413813.0 }
  , { code: "SVN", name: "Slovenia", continent: "Europe", areaKm2: 20273.0, population: 2130638.0 }
  , { code: "SWE", name: "Sweden", continent: "Europe", areaKm2: 450295.0, population: 10605098.0 }
  , { code: "SWZ", name: "Eswatini", continent: "Africa", areaKm2: 17364.0, population: 1235549.0 }
  , { code: "SXM", name: "Sint Maarten", continent: "North America", areaKm2: 34.0, population: 41349.0 }
  , { code: "SYC", name: "Seychelles", continent: "Africa", areaKm2: 452.0, population: 122729.0 }
  , { code: "SYR", name: "Syria", continent: "Asia", areaKm2: 185180.0, population: 25620000.0 }
  , { code: "TCA", name: "Turks and Caicos Islands", continent: "North America", areaKm2: 948.0, population: 50828.0 }
  , { code: "TCD", name: "Chad", continent: "Africa", areaKm2: 1284000.0, population: 19340757.0 }
  , { code: "TGO", name: "Togo", continent: "Africa", areaKm2: 56785.0, population: 8095498.0 }
  , { code: "THA", name: "Thailand", continent: "Asia", areaKm2: 513120.0, population: 65859640.0 }
  , { code: "TJK", name: "Tajikistan", continent: "Asia", areaKm2: 143100.0, population: 10499000.0 }
  , { code: "TKL", name: "Tokelau", continent: "Oceania", areaKm2: 12.0, population: 2608.0 }
  , { code: "TKM", name: "Turkmenistan", continent: "Asia", areaKm2: 488100.0, population: 7057841.0 }
  , { code: "TLS", name: "Timor-Leste", continent: "Oceania", areaKm2: 14874.0, population: 1391221.0 }
  , { code: "TON", name: "Tonga", continent: "Oceania", areaKm2: 747.0, population: 100179.0 }
  , { code: "TTO", name: "Trinidad and Tobago", continent: "North America", areaKm2: 5130.0, population: 1367764.0 }
  , { code: "TUN", name: "Tunisia", continent: "Africa", areaKm2: 163610.0, population: 11972169.0 }
  , { code: "TUR", name: "Turkey", continent: "Asia", areaKm2: 783562.0, population: 85664944.0 }
  , { code: "TUV", name: "Tuvalu", continent: "Oceania", areaKm2: 26.0, population: 10643.0 }
  , { code: "TWN", name: "Taiwan", continent: "Asia", areaKm2: 36197.0, population: 23317031.0 }
  , { code: "TZA", name: "Tanzania", continent: "Africa", areaKm2: 947303.0, population: 68153004.0 }
  , { code: "UGA", name: "Uganda", continent: "Africa", areaKm2: 241550.0, population: 45905417.0 }
  , { code: "UKR", name: "Ukraine", continent: "Europe", areaKm2: 603550.0, population: 32862000.0 }
  , { code: "UMI", name: "United States Minor Outlying Islands", continent: "Oceania", areaKm2: 34.2, population: 0.0 }
  , { code: "UNK", name: "Kosovo", continent: "Europe", areaKm2: 10908.0, population: 1585566.0 }
  , { code: "URY", name: "Uruguay", continent: "South America", areaKm2: 181034.0, population: 3499451.0 }
  , { code: "USA", name: "United States", continent: "North America", areaKm2: 9525067.0, population: 340110988.0 }
  , { code: "UZB", name: "Uzbekistan", continent: "Asia", areaKm2: 447400.0, population: 37859698.0 }
  , { code: "VAT", name: "Vatican City", continent: "Europe", areaKm2: 0.5, population: 882.0 }
  , { code: "VCT", name: "Saint Vincent and the Grenadines", continent: "North America", areaKm2: 389.0, population: 110872.0 }
  , { code: "VEN", name: "Venezuela", continent: "South America", areaKm2: 916445.0, population: 28517000.0 }
  , { code: "VGB", name: "British Virgin Islands", continent: "North America", areaKm2: 151.0, population: 39471.0 }
  , { code: "VIR", name: "United States Virgin Islands", continent: "North America", areaKm2: 347.0, population: 87146.0 }
  , { code: "VNM", name: "Vietnam", continent: "Asia", areaKm2: 331212.0, population: 101343800.0 }
  , { code: "VUT", name: "Vanuatu", continent: "Oceania", areaKm2: 12189.0, population: 321409.0 }
  , { code: "WLF", name: "Wallis and Futuna", continent: "Oceania", areaKm2: 142.0, population: 11620.0 }
  , { code: "WSM", name: "Samoa", continent: "Oceania", areaKm2: 2842.0, population: 205557.0 }
  , { code: "YEM", name: "Yemen", continent: "Asia", areaKm2: 527968.0, population: 32684503.0 }
  , { code: "ZAF", name: "South Africa", continent: "Africa", areaKm2: 1221037.0, population: 63100945.0 }
  , { code: "ZMB", name: "Zambia", continent: "Africa", areaKm2: 752612.0, population: 19693423.0 }
  , { code: "ZWE", name: "Zimbabwe", continent: "Africa", areaKm2: 390757.0, population: 17073087.0 }
  ]

byContinent :: Map String (Array Country)
byContinent = foldl addOne Map.empty countries
  where
  addOne m c = Map.alter (Just <<< addTo c) c.continent m
  addTo c Nothing = [ c ]
  addTo c (Just xs) = Array.snoc xs c

continentTotals :: Array { continent :: String, n :: Int, areaKm2 :: Number, population :: Number }
continentTotals = map summarise (Map.toUnfoldable byContinent)
  where
  summarise (Tuple k cs) =
    { continent: k
    , n: Array.length cs
    , areaKm2: foldl (\a c -> a + c.areaKm2) 0.0 cs
    , population: foldl (\a c -> a + c.population) 0.0 cs
    }

continentTree :: HierarchyData String
continentTree = HierarchyData
  { data_: "world"
  , value: Nothing
  , children: Just (map continentBranch (Map.toUnfoldable byContinent))
  }
  where
  continentBranch (Tuple name cs) = HierarchyData
    { data_: name
    , value: Nothing
    , children: Just (map countryLeaf cs)
    }
  countryLeaf c = HierarchyData
    { data_: c.code, value: Just c.areaKm2, children: Nothing }

packedLayout :: PackNode String
packedLayout = pack
  (defaultPackConfig { size = { width: 800.0, height: 800.0 }, padding = 2.0 })
  (hierarchy continentTree)

renderNode :: PackNode String -> String
renderNode (PackNode n) =
  let
    self = "<circle cx=\"" <> Num.toString n.x
        <> "\" cy=\"" <> Num.toString n.y
        <> "\" r=\"" <> Num.toString n.r
        <> "\" " <> styleFor n.depth <> "/>"
  in self <> foldl (\acc k -> acc <> renderNode k) "" n.children

styleFor :: Int -> String
styleFor d = case d of
  0 -> "fill=\"none\" stroke=\"#ccc\" stroke-width=\"0.5\""
  1 -> "fill=\"#1f7aa5\" fill-opacity=\"0.08\" stroke=\"#1f7aa5\" stroke-width=\"1\""
  _ -> "fill=\"#c08a1e\" fill-opacity=\"0.45\" stroke=\"#8a5d14\" stroke-width=\"0.3\""

bubbleSvg :: String
bubbleSvg =
  "<svg xmlns=\"http://www.w3.org/2000/svg\" viewBox=\"0 0 800 800\">"
    <> renderNode packedLayout
    <> "</svg>"

globalDensity :: Number
globalDensity = 58.86

countryByCode :: Map String Country
countryByCode = foldl (\m c -> Map.insert c.code c m) Map.empty countries

continentColour :: String -> String
continentColour cont = case cont of
  "Africa"        -> "#d97706"
  "Asia"          -> "#dc2626"
  "Europe"        -> "#2563eb"
  "North America" -> "#059669"
  "South America" -> "#7c3aed"
  "Oceania"       -> "#0891b2"
  _               -> "#666666"

leafInner :: { outerR :: Number, cx :: Number, cy :: Number, country :: Country } -> String
leafInner { outerR, cx, cy, country } =
  let
    density = country.population / country.areaKm2
    ratio = sqrt (density / globalDensity)
    clamped = ratio > 1.0
    innerR = if clamped then outerR else ratio * outerR
    stroke = if clamped then "#b91c1c" else "#222222"
    strokeW = if clamped then "0.8" else "0.2"
  in "<circle cx=\"" <> Num.toString cx
       <> "\" cy=\"" <> Num.toString cy
       <> "\" r=\"" <> Num.toString innerR
       <> "\" fill=\"#111827\" fill-opacity=\"0.55\" stroke=\""
       <> stroke <> "\" stroke-width=\"" <> strokeW <> "\"/>"

renderLeaf :: String -> PackNode String -> String
renderLeaf colour (PackNode n) =
  let
    outer = "<circle cx=\"" <> Num.toString n.x
         <> "\" cy=\"" <> Num.toString n.y
         <> "\" r=\"" <> Num.toString n.r
         <> "\" fill=\"" <> colour <> "\" fill-opacity=\"0.55\" stroke=\"" <> colour <> "\" stroke-width=\"0.3\"/>"
    innerMaybe = case Map.lookup n.data_ countryByCode of
      Just c -> leafInner { outerR: n.r, cx: n.x, cy: n.y, country: c }
      Nothing -> ""
  in outer <> innerMaybe

renderContinent :: PackNode String -> String
renderContinent (PackNode n) =
  let
    colour = continentColour n.data_
    border = "<circle cx=\"" <> Num.toString n.x
          <> "\" cy=\"" <> Num.toString n.y
          <> "\" r=\"" <> Num.toString n.r
          <> "\" fill=\"" <> colour <> "\" fill-opacity=\"0.10\" stroke=\""
          <> colour <> "\" stroke-width=\"1\"/>"
  in border <> foldl (\acc k -> acc <> renderLeaf colour k) "" n.children

renderRoot :: PackNode String -> String
renderRoot (PackNode n) =
  "<circle cx=\"" <> Num.toString n.x
    <> "\" cy=\"" <> Num.toString n.y
    <> "\" r=\"" <> Num.toString n.r
    <> "\" fill=\"none\" stroke=\"#e5e7eb\" stroke-width=\"0.5\"/>"
    <> foldl (\acc k -> acc <> renderContinent k) "" n.children

bubbleSvg2 :: String
bubbleSvg2 =
  "<svg xmlns=\"http://www.w3.org/2000/svg\" viewBox=\"0 0 820 880\">"
    <> "<text x=\"10\" y=\"20\" font-family=\"sans-serif\" font-size=\"14\" fill=\"#111\">Countries packed by land area, coloured by continent; inner disc sized by population density vs. global average (58.86/kmÂ²)</text>"
    <> "<g transform=\"translate(10,40)\">" <> renderRoot packedLayout <> "</g>"
    <> legendSvg
    <> "</svg>"

legendSvg :: String
legendSvg =
  let
    items =
      [ { label: "Africa",        colour: continentColour "Africa" }
      , { label: "Asia",          colour: continentColour "Asia" }
      , { label: "Europe",        colour: continentColour "Europe" }
      , { label: "North America", colour: continentColour "North America" }
      , { label: "South America", colour: continentColour "South America" }
      , { label: "Oceania",       colour: continentColour "Oceania" }
      ]
    swatch i it = "<g transform=\"translate(" <> Num.toString (10.0 + 140.0 * (toNumber (i `mod` 3))) <> "," <> Num.toString (10.0 + 20.0 * (toNumber (i / 3))) <> ")\">"
      <> "<circle cx=\"8\" cy=\"8\" r=\"6\" fill=\"" <> it.colour <> "\" fill-opacity=\"0.55\" stroke=\"" <> it.colour <> "\"/>"
      <> "<text x=\"22\" y=\"12\" font-family=\"sans-serif\" font-size=\"11\" fill=\"#333\">" <> it.label <> "</text>"
      <> "</g>"
  in "<g transform=\"translate(10,845)\">"
       <> (foldlWithIndex (\i acc it -> acc <> swatch i it) "" items)
       <> "</g>"

