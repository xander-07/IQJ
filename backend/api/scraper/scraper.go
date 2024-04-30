package scraper

import (
	"fmt"
	"iqj/database"
	"time"

	"github.com/gocolly/colly"
)

type NewsBlock struct {
	Header          string
	Link            string
	PublicationTime string
	ImageLink       []string
	Tags            []string
}

// Тикер, который запускает главную функцию каждые 30 секунд.
func ScrapTick() {
	ticker := time.NewTicker(10 * time.Second)
	defer ticker.Stop()

	for {
		select {
		case <-ticker.C:
			Scraper()
		}
	}
}

// Главная функция, которая вызывает парсеры блочной и полной новости.
func Scraper() {
	x := scraper("https://www.mirea.ru/news/index.php?set_filter=Y&arrFilter_ff%5BTAGS%5D=%D1%81%D0%BE%D1%82%D1%80%D1%83%D0%B4%D0%BD%D0%B8%D0%BA%D0%B0%D0%BC")
	scraper2(x)
}

// Парсим блочные новости для сотрудников с первой страницы и добавляем их в массив.
func scraper(url string) []NewsBlock {
	var newsblarr []NewsBlock
	c := colly.NewCollector()
	c.OnHTML(".uk-card.uk-card-default", func(e *colly.HTMLElement) {
		newsblock := NewsBlock{}

		x := e.ChildText(".uk-link-reset")
		newsblock.Header = x[:len(x)-18]
		newsblock.Link = "https://www.mirea.ru" + e.ChildAttr(".uk-link-reset", "href")
		newsblock.PublicationTime = e.ChildText(".uk-margin-small-bottom.uk-text-small")
		imgStr := "https://www.mirea.ru" + e.ChildAttr(".enableSrcset", "data-src")
		newsblock.ImageLink = append(newsblock.ImageLink, imgStr)
		newsblarr = append([]NewsBlock{newsblock}, newsblarr...)
	})

	// Переключение на следующую страницу
	//c.OnHTML(".bx-pag-next a", func(e *colly.HTMLElement) {
	//	nextPage := e.Request.AbsoluteURL(e.Attr("href"))
	//	c.Visit(nextPage)
	//})

	c.Visit(url)
	return newsblarr
}

// Парсим полные новости для сотрудников по ссылкам из блочных и добавляем их в массив и базу данных.
func scraper2(newsblarr []NewsBlock) {
	c := colly.NewCollector()
	news := database.News{}
	var title, text string

	c.OnHTML("h1", func(e *colly.HTMLElement) {
		title = e.Text
	})

	c.OnHTML(".news-item-text", func(e *colly.HTMLElement) {
		text = e.Text
	})

	var mas []string
	c.OnHTML("a[data-fancybox=\"gallery\"]", func(e *colly.HTMLElement) {
		mas = append(mas, "https://www.mirea.ru"+e.ChildAttr("img", "src"))
	})

	var tags []string
	c.OnHTML("li[class=\"uk-display-inline-block\"]", func(e *colly.HTMLElement) {
		tags = append(tags, e.Text)
	})

	for i := range newsblarr {
		c.Visit(newsblarr[i].Link)
		news.Header = title
		news.Link = newsblarr[i].Link
		news.Content = text
		news.ImageLinks = mas
		mas = nil
		news.Tags = tags
		tags = nil
		news.PublicationTime = newsblarr[i].PublicationTime
		err := database.Database.News.Add(&news)
		if err != nil {
			fmt.Println(err)
		}
	}
}
