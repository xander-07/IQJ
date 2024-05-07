package cache

import (
	"container/list"
	"sync"
)

// Структура LFU кэша
type LFUCache struct {
	capacity  int
	cache     map[string]*list.Element
	freq      map[int]*list.List // Частоты использования элементов кэша.
	freqCount map[string]int     // Счетчики частоты использования элементов.
	minFreq   int                // Минимальная частота использования элемента
	mu        sync.Mutex
}

// Элемент кэша
type Entry struct {
	key   string
	value interface{}
	freq  int
}

// Создание нового экземляра кэша с переданной ёмкостью
func NewLFUCache(capacity int) *LFUCache {
	return &LFUCache{
		capacity:  capacity,
		cache:     make(map[string]*list.Element),
		freq:      make(map[int]*list.List),
		freqCount: make(map[string]int),
		minFreq:   0,
	}
}

// Получение значения в кэш по ключу
func (lfu *LFUCache) Set(key string, value interface{}) {
	lfu.mu.Lock()
	defer lfu.mu.Unlock()

	// Удаление элемента, если емкость кэша >= допустимой
	if len(lfu.cache) >= lfu.capacity {
		lfu.evict()
	}

	// Создание новой записи кэша
	e := &Entry{
		key:   key,
		value: value,
		freq:  1,
	}

	if _, ok := lfu.freq[1]; !ok {
		lfu.freq[1] = list.New()
	}
	elem := lfu.freq[1].PushBack(e)
	lfu.cache[key] = elem
	lfu.freqCount[key] = 1
	lfu.minFreq = 1
}

// Получение значения из кэша по ключу
func (lfu *LFUCache) Get(key string) interface{} {
	lfu.mu.Lock()
	defer lfu.mu.Unlock()

	if elem, ok := lfu.cache[key]; ok {
		e := elem.Value.(*Entry)
		lfu.updateFreq(e)
		return e.value
	}

	return nil
}

// Удаление самого неиспользуемого элемента
func (lfu *LFUCache) evict() {
	freqList := lfu.freq[lfu.minFreq]
	e := freqList.Front()
	delete(lfu.cache, e.Value.(*Entry).key)     // Удаляем запись из кэша
	freqList.Remove(e)                          // Удаляем запись из списка с наименьшей частотой
	delete(lfu.freqCount, e.Value.(*Entry).key) // Удаляем запись из счетчика частоты использования
}

// Обновляение частоты использования записи кэша.
func (lfu *LFUCache) updateFreq(e *Entry) {
	freq := e.freq
	lfu.freq[freq].Remove(lfu.cache[e.key]) // Удаляем запись из списка текущей частоты
	if lfu.minFreq == freq && lfu.freq[freq].Len() == 0 {
		lfu.minFreq++ // Если список пуст и частота равна минимальной, увеличиваем минимальную частоту
	}
	freq++                            // Увеличиваем частоту использования элемента на 1
	e.freq = freq                     // Обновляем частоту использования записи
	if _, ok := lfu.freq[freq]; !ok { // Если для новой частоты еще нет списка, создаем его
		lfu.freq[freq] = list.New()
	}
	elem := lfu.freq[freq].PushBack(e) // Добавляем запись в список с новой частотой
	lfu.cache[e.key] = elem            // Запоминаем элемент в кэше
	lfu.freqCount[e.key] = freq        // Обновляем счетчик частоты использования для этого элемента
}
