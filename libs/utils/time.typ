#let datetime-display-cn-cover(date) = {
  date.display("[year]  年   [month]  月")
}

#let datetime-display-cn-declare(date) = {
  date.display("[year] 年  [month]  月  [day]  日")
}

#let datetime-display-en-cover(date) = {
  date.display("[year] ,  [month]")
}

#let datetime-display-en-declare(date) = {
  date.display("[year]  [month]  [day]")
}
