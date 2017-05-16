class GildedRose

  attr_reader :items

  SULFURAS = "Sulfuras, Hand of Ragnaros"
  BRIE = "Aged Brie"
  BACKSTAGE = "Backstage passes to a TAFKAL80ETC concert"

  def initialize(items)
    @items = items
  end

  def quality_up_1(item)
    item.quality = item.quality + 1 if item.quality < 50
  end

  def quality_down_1_except_sulfuras(item)
    item.quality = item.quality - 1 if item.name != SULFURAS
  end

  def update_quality

    @items.each do |item|
      if item.name != BRIE and item.name != BACKSTAGE
        if item.quality > 0
          quality_down_1_except_sulfuras(item)
        end
      else
        if item.quality < 50
          item.quality = item.quality + 1
          if item.name == BACKSTAGE
            if item.sell_in < 11
              quality_up_1(item)
            end
            if item.sell_in < 6
              quality_up_1(item)
            end
          end
        end
      end

      if item.name != SULFURAS
        item.sell_in = item.sell_in - 1
      end

      if item.sell_in < 0
        if item.name != BRIE
          if item.name != BACKSTAGE
            if item.quality > 0
              quality_down_1_except_sulfuras(item)
            end
          else
            item.quality = item.quality - item.quality
          end
        else
          quality_up_1(item)
        end
      end

    end
  end
end
